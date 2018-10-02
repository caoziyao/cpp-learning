
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# 3.跳转到 ucore 执行
# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode 实模式
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
    # Enable A20: 发送 io 信号
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
    # Switch from real to protected mode, using a bootstrap GDT（全局描述符表寄存器）
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    #
    lgdt gdtdesc		# 加载到 gdtr 寄存器
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	e0 7d                	loopne 7ca0 <readseg+0x4f>
    movl %cr0, %eax		# 使能 cr0 的 bit0 位，进入保护模式
    7c23:	0f 20 c0             	mov    %cr0,%eax
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers 段选择子
    # PROT_MODE_DSEG  0x10
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
    call bootmain		# 跳转 bootmain 加载 elf 格式 ucore
    7c4a:	e8 9d 00 00 00       	call   7cec <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>

00007c51 <readseg>:
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c51:	55                   	push   %ebp
    7c52:	89 e5                	mov    %esp,%ebp
    7c54:	57                   	push   %edi
    uintptr_t end_va = va + count;
    7c55:	8d 3c 10             	lea    (%eax,%edx,1),%edi

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c58:	89 ca                	mov    %ecx,%edx

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c5a:	c1 e9 09             	shr    $0x9,%ecx
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c5d:	56                   	push   %esi
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c5e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c64:	8d 71 01             	lea    0x1(%ecx),%esi
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c67:	53                   	push   %ebx
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c68:	29 d0                	sub    %edx,%eax
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c6a:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c6b:	89 7d f0             	mov    %edi,-0x10(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c6e:	89 c3                	mov    %eax,%ebx
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7c70:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
    7c73:	73 71                	jae    7ce6 <readseg+0x95>

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7c75:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c7a:	ec                   	in     (%dx),%al
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7c7b:	83 e0 c0             	and    $0xffffffc0,%eax
    7c7e:	3c 40                	cmp    $0x40,%al
    7c80:	75 f3                	jne    7c75 <readseg+0x24>
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
    7c82:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c87:	b0 01                	mov    $0x1,%al
    7c89:	ee                   	out    %al,(%dx)
    7c8a:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7c8f:	89 f0                	mov    %esi,%eax
    7c91:	ee                   	out    %al,(%dx)
    7c92:	89 f0                	mov    %esi,%eax
    7c94:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7c99:	c1 e8 08             	shr    $0x8,%eax
    7c9c:	ee                   	out    %al,(%dx)
    7c9d:	89 f0                	mov    %esi,%eax
    7c9f:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ca4:	c1 e8 10             	shr    $0x10,%eax
    7ca7:	ee                   	out    %al,(%dx)
    7ca8:	89 f0                	mov    %esi,%eax
    7caa:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7caf:	c1 e8 18             	shr    $0x18,%eax
    7cb2:	83 e0 0f             	and    $0xf,%eax
    7cb5:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb8:	ee                   	out    %al,(%dx)
    7cb9:	b0 20                	mov    $0x20,%al
    7cbb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cc0:	ee                   	out    %al,(%dx)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7cc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cc6:	ec                   	in     (%dx),%al
    7cc7:	83 e0 c0             	and    $0xffffffc0,%eax
    7cca:	3c 40                	cmp    $0x40,%al
    7ccc:	75 f3                	jne    7cc1 <readseg+0x70>
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
    7cce:	89 df                	mov    %ebx,%edi
    7cd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd5:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cda:	fc                   	cld    
    7cdb:	f2 6d                	repnz insl (%dx),%es:(%edi)
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7cdd:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7ce3:	46                   	inc    %esi
    7ce4:	eb 8a                	jmp    7c70 <readseg+0x1f>
        readsect((void *)va, secno);
    }
}
    7ce6:	58                   	pop    %eax
    7ce7:	5b                   	pop    %ebx
    7ce8:	5e                   	pop    %esi
    7ce9:	5f                   	pop    %edi
    7cea:	5d                   	pop    %ebp
    7ceb:	c3                   	ret    

00007cec <bootmain>:

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7cec:	55                   	push   %ebp
    // read the 1st page off disk
    // 首先读取了位于主引导扇区的后的连续8个扇区
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7ced:	31 c9                	xor    %ecx,%ecx
    7cef:	ba 00 10 00 00       	mov    $0x1000,%edx
    7cf4:	b8 00 00 01 00       	mov    $0x10000,%eax
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7cf9:	89 e5                	mov    %esp,%ebp
    7cfb:	56                   	push   %esi
    7cfc:	53                   	push   %ebx
    // read the 1st page off disk
    // 首先读取了位于主引导扇区的后的连续8个扇区
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7cfd:	e8 4f ff ff ff       	call   7c51 <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d02:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d09:	45 4c 46 
    7d0c:	75 3f                	jne    7d4d <bootmain+0x61>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d0e:	a1 1c 00 01 00       	mov    0x1001c,%eax
    eph = ph + ELFHDR->e_phnum;
    7d13:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d1a:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7d20:	c1 e6 05             	shl    $0x5,%esi
    7d23:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph ++) {
    7d25:	39 f3                	cmp    %esi,%ebx
    7d27:	73 18                	jae    7d41 <bootmain+0x55>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d29:	8b 43 08             	mov    0x8(%ebx),%eax
    7d2c:	8b 4b 04             	mov    0x4(%ebx),%ecx
    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
    7d2f:	83 c3 20             	add    $0x20,%ebx
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d32:	8b 53 f4             	mov    -0xc(%ebx),%edx
    7d35:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d3a:	e8 12 ff ff ff       	call   7c51 <readseg>
    7d3f:	eb e4                	jmp    7d25 <bootmain+0x39>
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d41:	a1 18 00 01 00       	mov    0x10018,%eax
    7d46:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d4b:	ff d0                	call   *%eax
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
    7d4d:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7d52:	89 d0                	mov    %edx,%eax
    7d54:	66 ef                	out    %ax,(%dx)
    7d56:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d5b:	66 ef                	out    %ax,(%dx)
    7d5d:	eb fe                	jmp    7d5d <bootmain+0x71>
