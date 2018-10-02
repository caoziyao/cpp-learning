
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60
    7c1c:	e6 60                	out    %al,$0x60

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	d0 7d 0f             	sarb   0xf(%ebp)
    movl %cr0, %eax
    7c24:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea 32 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c32

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c4a:	e8 61 00 00 00       	call   7cb0 <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>

00007c51 <readsect>:
写I/O地址0x1f2~0x1f5,0x1f7，发出读取第offseet个扇区处的磁盘数据的命令；
读I/O地址0x1f7，等待磁盘准备好;
连续读I/O地址0x1f0，把磁盘扇区数据读到指定内存。
*/
static void
readsect(void *dst, uint32_t secno) {
    7c51:	55                   	push   %ebp
    7c52:	89 d1                	mov    %edx,%ecx
    7c54:	89 e5                	mov    %esp,%ebp
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7c56:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c5b:	57                   	push   %edi
    7c5c:	89 c7                	mov    %eax,%edi
    7c5e:	ec                   	in     (%dx),%al
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c5f:	83 e0 c0             	and    $0xffffffc0,%eax
    7c62:	3c 40                	cmp    $0x40,%al
    7c64:	75 f8                	jne    7c5e <readsect+0xd>
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
    7c66:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c6b:	b0 01                	mov    $0x1,%al
    7c6d:	ee                   	out    %al,(%dx)
    7c6e:	0f b6 c1             	movzbl %cl,%eax
    7c71:	b2 f3                	mov    $0xf3,%dl
    7c73:	ee                   	out    %al,(%dx)
    7c74:	0f b6 c5             	movzbl %ch,%eax
    7c77:	b2 f4                	mov    $0xf4,%dl
    7c79:	ee                   	out    %al,(%dx)
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    7c7a:	89 c8                	mov    %ecx,%eax
    7c7c:	b2 f5                	mov    $0xf5,%dl
    7c7e:	c1 e8 10             	shr    $0x10,%eax
    7c81:	0f b6 c0             	movzbl %al,%eax
    7c84:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7c85:	c1 e9 18             	shr    $0x18,%ecx
    7c88:	b2 f6                	mov    $0xf6,%dl
    7c8a:	88 c8                	mov    %cl,%al
    7c8c:	83 e0 0f             	and    $0xf,%eax
    7c8f:	83 c8 e0             	or     $0xffffffe0,%eax
    7c92:	ee                   	out    %al,(%dx)
    7c93:	b0 20                	mov    $0x20,%al
    7c95:	b2 f7                	mov    $0xf7,%dl
    7c97:	ee                   	out    %al,(%dx)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7c98:	ec                   	in     (%dx),%al
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c99:	83 e0 c0             	and    $0xffffffc0,%eax
    7c9c:	3c 40                	cmp    $0x40,%al
    7c9e:	75 f8                	jne    7c98 <readsect+0x47>
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
    7ca0:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ca5:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7caa:	fc                   	cld    
    7cab:	f2 6d                	repnz insl (%dx),%es:(%edi)
    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
    7cad:	5f                   	pop    %edi
    7cae:	5d                   	pop    %ebp
    7caf:	c3                   	ret    

00007cb0 <bootmain>:
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7cb0:	55                   	push   %ebp
    7cb1:	89 e5                	mov    %esp,%ebp
    7cb3:	57                   	push   %edi
    7cb4:	56                   	push   %esi
    7cb5:	53                   	push   %ebx

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7cb6:	bb 01 00 00 00       	mov    $0x1,%ebx
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7cbb:	83 ec 1c             	sub    $0x1c,%esp
    7cbe:	8d 43 7f             	lea    0x7f(%ebx),%eax

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    7cc1:	89 da                	mov    %ebx,%edx
    7cc3:	c1 e0 09             	shl    $0x9,%eax
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7cc6:	43                   	inc    %ebx
        readsect((void *)va, secno);
    7cc7:	e8 85 ff ff ff       	call   7c51 <readsect>
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7ccc:	83 fb 09             	cmp    $0x9,%ebx
    7ccf:	75 ed                	jne    7cbe <bootmain+0xe>
    // read the 1st page off disk
    // 首先读取了位于主引导扇区的后的连续8个扇区
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7cd1:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7cd8:	45 4c 46 
    7cdb:	75 6a                	jne    7d47 <bootmain+0x97>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7cdd:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7ce2:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7ce8:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7cef:	c1 e0 05             	shl    $0x5,%eax
    7cf2:	01 d8                	add    %ebx,%eax
    7cf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; ph < eph; ph ++) {
    7cf7:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    7cfa:	73 3f                	jae    7d3b <bootmain+0x8b>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7cfc:	8b 73 08             	mov    0x8(%ebx),%esi
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;
    7cff:	8b 43 14             	mov    0x14(%ebx),%eax

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d02:	8b 4b 04             	mov    0x4(%ebx),%ecx
    7d05:	81 e6 ff ff ff 00    	and    $0xffffff,%esi
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;
    7d0b:	01 f0                	add    %esi,%eax
    7d0d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7d10:	89 c8                	mov    %ecx,%eax
    7d12:	25 ff 01 00 00       	and    $0x1ff,%eax

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7d17:	c1 e9 09             	shr    $0x9,%ecx
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7d1a:	29 c6                	sub    %eax,%esi

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7d1c:	8d 79 01             	lea    0x1(%ecx),%edi

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d1f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
    7d22:	73 12                	jae    7d36 <bootmain+0x86>
        readsect((void *)va, secno);
    7d24:	89 fa                	mov    %edi,%edx
    7d26:	89 f0                	mov    %esi,%eax
    7d28:	e8 24 ff ff ff       	call   7c51 <readsect>
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d2d:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d33:	47                   	inc    %edi
    7d34:	eb e9                	jmp    7d1f <bootmain+0x6f>
    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
    7d36:	83 c3 20             	add    $0x20,%ebx
    7d39:	eb bc                	jmp    7cf7 <bootmain+0x47>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d3b:	a1 18 00 01 00       	mov    0x10018,%eax
    7d40:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d45:	ff d0                	call   *%eax
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
    7d47:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d4c:	89 c2                	mov    %eax,%edx
    7d4e:	66 ef                	out    %ax,(%dx)
    7d50:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d55:	66 ef                	out    %ax,(%dx)
    7d57:	eb fe                	jmp    7d57 <bootmain+0xa7>
