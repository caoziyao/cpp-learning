
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:

#include <x86.h>
#include <stdio.h>

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
	cons_init();
  100006:	e8 c5 04 00 00       	call   1004d0 <cons_init>

	print("hello");
  10000b:	83 ec 0c             	sub    $0xc,%esp
  10000e:	68 be 07 10 00       	push   $0x1007be
  100013:	e8 bb 06 00 00       	call   1006d3 <print>
  100018:	83 c4 10             	add    $0x10,%esp

	int a = 0;
  10001b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	a = a + 3;
  100022:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
    while (1);
  100026:	eb fe                	jmp    100026 <kern_init+0x26>

00100028 <delay>:
#include <x86.h>
#include <string.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100028:	55                   	push   %ebp
  100029:	89 e5                	mov    %esp,%ebp
  10002b:	83 ec 10             	sub    $0x10,%esp
  10002e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100034:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100038:	89 c2                	mov    %eax,%edx
  10003a:	ec                   	in     (%dx),%al
  10003b:	88 45 f4             	mov    %al,-0xc(%ebp)
  10003e:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100044:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100048:	89 c2                	mov    %eax,%edx
  10004a:	ec                   	in     (%dx),%al
  10004b:	88 45 f5             	mov    %al,-0xb(%ebp)
  10004e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100054:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100058:	89 c2                	mov    %eax,%edx
  10005a:	ec                   	in     (%dx),%al
  10005b:	88 45 f6             	mov    %al,-0xa(%ebp)
  10005e:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100064:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100068:	89 c2                	mov    %eax,%edx
  10006a:	ec                   	in     (%dx),%al
  10006b:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  10006e:	90                   	nop
  10006f:	c9                   	leave  
  100070:	c3                   	ret    

00100071 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100077:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  10007e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100081:	0f b7 00             	movzwl (%eax),%eax
  100084:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100088:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10008b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100093:	0f b7 00             	movzwl (%eax),%eax
  100096:	66 3d 5a a5          	cmp    $0xa55a,%ax
  10009a:	74 12                	je     1000ae <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  10009c:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1000a3:	66 c7 05 c6 19 10 00 	movw   $0x3b4,0x1019c6
  1000aa:	b4 03 
  1000ac:	eb 13                	jmp    1000c1 <cga_init+0x50>
    } else {
        *cp = was;
  1000ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000b1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1000b5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  1000b8:	66 c7 05 c6 19 10 00 	movw   $0x3d4,0x1019c6
  1000bf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  1000c1:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  1000c8:	0f b7 c0             	movzwl %ax,%eax
  1000cb:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  1000cf:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1000d3:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1000d7:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1000db:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  1000dc:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  1000e3:	83 c0 01             	add    $0x1,%eax
  1000e6:	0f b7 c0             	movzwl %ax,%eax
  1000e9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1000ed:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1000f1:	89 c2                	mov    %eax,%edx
  1000f3:	ec                   	in     (%dx),%al
  1000f4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1000f7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1000fb:	0f b6 c0             	movzbl %al,%eax
  1000fe:	c1 e0 08             	shl    $0x8,%eax
  100101:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100104:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  10010b:	0f b7 c0             	movzwl %ax,%eax
  10010e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100112:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100116:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  10011a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10011e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  10011f:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  100126:	83 c0 01             	add    $0x1,%eax
  100129:	0f b7 c0             	movzwl %ax,%eax
  10012c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100130:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100134:	89 c2                	mov    %eax,%edx
  100136:	ec                   	in     (%dx),%al
  100137:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10013a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10013e:	0f b6 c0             	movzbl %al,%eax
  100141:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100147:	a3 c0 19 10 00       	mov    %eax,0x1019c0
    crt_pos = pos;
  10014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10014f:	66 a3 c4 19 10 00    	mov    %ax,0x1019c4
}
  100155:	90                   	nop
  100156:	c9                   	leave  
  100157:	c3                   	ret    

00100158 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100158:	55                   	push   %ebp
  100159:	89 e5                	mov    %esp,%ebp
  10015b:	83 ec 20             	sub    $0x20,%esp
  10015e:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  100164:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100168:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10016c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100170:	ee                   	out    %al,(%dx)
  100171:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  100177:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  10017b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10017f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100183:	ee                   	out    %al,(%dx)
  100184:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10018a:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  10018e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  100192:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100196:	ee                   	out    %al,(%dx)
  100197:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  10019d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1001a1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1001a5:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1001a9:	ee                   	out    %al,(%dx)
  1001aa:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  1001b0:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  1001b4:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  1001b8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1001bc:	ee                   	out    %al,(%dx)
  1001bd:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  1001c3:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  1001c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1001cb:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1001cf:	ee                   	out    %al,(%dx)
  1001d0:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  1001d6:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  1001da:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1001de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1001e2:	ee                   	out    %al,(%dx)
  1001e3:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1001e9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ed:	89 c2                	mov    %eax,%edx
  1001ef:	ec                   	in     (%dx),%al
  1001f0:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  1001f3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1001f7:	3c ff                	cmp    $0xff,%al
  1001f9:	0f 95 c0             	setne  %al
  1001fc:	0f b6 c0             	movzbl %al,%eax
  1001ff:	a3 c8 19 10 00       	mov    %eax,0x1019c8
  100204:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10020a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10020e:	89 c2                	mov    %eax,%edx
  100210:	ec                   	in     (%dx),%al
  100211:	88 45 ea             	mov    %al,-0x16(%ebp)
  100214:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  10021a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10021e:	89 c2                	mov    %eax,%edx
  100220:	ec                   	in     (%dx),%al
  100221:	88 45 eb             	mov    %al,-0x15(%ebp)

    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);
}
  100224:	90                   	nop
  100225:	c9                   	leave  
  100226:	c3                   	ret    

00100227 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100227:	55                   	push   %ebp
  100228:	89 e5                	mov    %esp,%ebp
  10022a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10022d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100234:	eb 09                	jmp    10023f <lpt_putc+0x18>
        delay();
  100236:	e8 ed fd ff ff       	call   100028 <delay>

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10023b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10023f:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100245:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100249:	89 c2                	mov    %eax,%edx
  10024b:	ec                   	in     (%dx),%al
  10024c:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10024f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100253:	84 c0                	test   %al,%al
  100255:	78 09                	js     100260 <lpt_putc+0x39>
  100257:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10025e:	7e d6                	jle    100236 <lpt_putc+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100260:	8b 45 08             	mov    0x8(%ebp),%eax
  100263:	0f b6 c0             	movzbl %al,%eax
  100266:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  10026c:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10026f:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100273:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100277:	ee                   	out    %al,(%dx)
  100278:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10027e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100282:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100286:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10028a:	ee                   	out    %al,(%dx)
  10028b:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100291:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  100295:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100299:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10029d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10029e:	90                   	nop
  10029f:	c9                   	leave  
  1002a0:	c3                   	ret    

001002a1 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1002a1:	55                   	push   %ebp
  1002a2:	89 e5                	mov    %esp,%ebp
  1002a4:	53                   	push   %ebx
  1002a5:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ab:	b0 00                	mov    $0x0,%al
  1002ad:	85 c0                	test   %eax,%eax
  1002af:	75 07                	jne    1002b8 <cga_putc+0x17>
        c |= 0x0700;
  1002b1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	0f b6 c0             	movzbl %al,%eax
  1002be:	83 f8 0a             	cmp    $0xa,%eax
  1002c1:	74 4e                	je     100311 <cga_putc+0x70>
  1002c3:	83 f8 0d             	cmp    $0xd,%eax
  1002c6:	74 59                	je     100321 <cga_putc+0x80>
  1002c8:	83 f8 08             	cmp    $0x8,%eax
  1002cb:	0f 85 8a 00 00 00    	jne    10035b <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1002d1:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  1002d8:	66 85 c0             	test   %ax,%ax
  1002db:	0f 84 a0 00 00 00    	je     100381 <cga_putc+0xe0>
            crt_pos --;
  1002e1:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  1002e8:	83 e8 01             	sub    $0x1,%eax
  1002eb:	66 a3 c4 19 10 00    	mov    %ax,0x1019c4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1002f1:	a1 c0 19 10 00       	mov    0x1019c0,%eax
  1002f6:	0f b7 15 c4 19 10 00 	movzwl 0x1019c4,%edx
  1002fd:	0f b7 d2             	movzwl %dx,%edx
  100300:	01 d2                	add    %edx,%edx
  100302:	01 d0                	add    %edx,%eax
  100304:	8b 55 08             	mov    0x8(%ebp),%edx
  100307:	b2 00                	mov    $0x0,%dl
  100309:	83 ca 20             	or     $0x20,%edx
  10030c:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10030f:	eb 70                	jmp    100381 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  100311:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  100318:	83 c0 50             	add    $0x50,%eax
  10031b:	66 a3 c4 19 10 00    	mov    %ax,0x1019c4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  100321:	0f b7 1d c4 19 10 00 	movzwl 0x1019c4,%ebx
  100328:	0f b7 0d c4 19 10 00 	movzwl 0x1019c4,%ecx
  10032f:	0f b7 c1             	movzwl %cx,%eax
  100332:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100338:	c1 e8 10             	shr    $0x10,%eax
  10033b:	89 c2                	mov    %eax,%edx
  10033d:	66 c1 ea 06          	shr    $0x6,%dx
  100341:	89 d0                	mov    %edx,%eax
  100343:	c1 e0 02             	shl    $0x2,%eax
  100346:	01 d0                	add    %edx,%eax
  100348:	c1 e0 04             	shl    $0x4,%eax
  10034b:	29 c1                	sub    %eax,%ecx
  10034d:	89 ca                	mov    %ecx,%edx
  10034f:	89 d8                	mov    %ebx,%eax
  100351:	29 d0                	sub    %edx,%eax
  100353:	66 a3 c4 19 10 00    	mov    %ax,0x1019c4
        break;
  100359:	eb 27                	jmp    100382 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10035b:	8b 0d c0 19 10 00    	mov    0x1019c0,%ecx
  100361:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  100368:	8d 50 01             	lea    0x1(%eax),%edx
  10036b:	66 89 15 c4 19 10 00 	mov    %dx,0x1019c4
  100372:	0f b7 c0             	movzwl %ax,%eax
  100375:	01 c0                	add    %eax,%eax
  100377:	01 c8                	add    %ecx,%eax
  100379:	8b 55 08             	mov    0x8(%ebp),%edx
  10037c:	66 89 10             	mov    %dx,(%eax)
        break;
  10037f:	eb 01                	jmp    100382 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  100381:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  100382:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  100389:	66 3d cf 07          	cmp    $0x7cf,%ax
  10038d:	76 59                	jbe    1003e8 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10038f:	a1 c0 19 10 00       	mov    0x1019c0,%eax
  100394:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10039a:	a1 c0 19 10 00       	mov    0x1019c0,%eax
  10039f:	83 ec 04             	sub    $0x4,%esp
  1003a2:	68 00 0f 00 00       	push   $0xf00
  1003a7:	52                   	push   %edx
  1003a8:	50                   	push   %eax
  1003a9:	e8 5b 03 00 00       	call   100709 <memmove>
  1003ae:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003b1:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1003b8:	eb 15                	jmp    1003cf <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1003ba:	a1 c0 19 10 00       	mov    0x1019c0,%eax
  1003bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1003c2:	01 d2                	add    %edx,%edx
  1003c4:	01 d0                	add    %edx,%eax
  1003c6:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1003cf:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1003d6:	7e e2                	jle    1003ba <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1003d8:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  1003df:	83 e8 50             	sub    $0x50,%eax
  1003e2:	66 a3 c4 19 10 00    	mov    %ax,0x1019c4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1003e8:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  1003ef:	0f b7 c0             	movzwl %ax,%eax
  1003f2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1003f6:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1003fa:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1003fe:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100402:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  100403:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  10040a:	66 c1 e8 08          	shr    $0x8,%ax
  10040e:	0f b6 c0             	movzbl %al,%eax
  100411:	0f b7 15 c6 19 10 00 	movzwl 0x1019c6,%edx
  100418:	83 c2 01             	add    $0x1,%edx
  10041b:	0f b7 d2             	movzwl %dx,%edx
  10041e:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  100422:	88 45 e9             	mov    %al,-0x17(%ebp)
  100425:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100429:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10042d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10042e:	0f b7 05 c6 19 10 00 	movzwl 0x1019c6,%eax
  100435:	0f b7 c0             	movzwl %ax,%eax
  100438:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10043c:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  100440:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100444:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100448:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  100449:	0f b7 05 c4 19 10 00 	movzwl 0x1019c4,%eax
  100450:	0f b6 c0             	movzbl %al,%eax
  100453:	0f b7 15 c6 19 10 00 	movzwl 0x1019c6,%edx
  10045a:	83 c2 01             	add    $0x1,%edx
  10045d:	0f b7 d2             	movzwl %dx,%edx
  100460:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  100464:	88 45 eb             	mov    %al,-0x15(%ebp)
  100467:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10046b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10046f:	ee                   	out    %al,(%dx)
}
  100470:	90                   	nop
  100471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100474:	c9                   	leave  
  100475:	c3                   	ret    

00100476 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  100476:	55                   	push   %ebp
  100477:	89 e5                	mov    %esp,%ebp
  100479:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10047c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100483:	eb 09                	jmp    10048e <serial_putc+0x18>
        delay();
  100485:	e8 9e fb ff ff       	call   100028 <delay>

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10048a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10048e:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100494:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100498:	89 c2                	mov    %eax,%edx
  10049a:	ec                   	in     (%dx),%al
  10049b:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10049e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1004a2:	0f b6 c0             	movzbl %al,%eax
  1004a5:	83 e0 20             	and    $0x20,%eax
  1004a8:	85 c0                	test   %eax,%eax
  1004aa:	75 09                	jne    1004b5 <serial_putc+0x3f>
  1004ac:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1004b3:	7e d0                	jle    100485 <serial_putc+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1004b8:	0f b6 c0             	movzbl %al,%eax
  1004bb:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1004c1:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1004c4:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1004c8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1004cc:	ee                   	out    %al,(%dx)
}
  1004cd:	90                   	nop
  1004ce:	c9                   	leave  
  1004cf:	c3                   	ret    

001004d0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1004d0:	55                   	push   %ebp
  1004d1:	89 e5                	mov    %esp,%ebp
    cga_init();
  1004d3:	e8 99 fb ff ff       	call   100071 <cga_init>
    serial_init();
  1004d8:	e8 7b fc ff ff       	call   100158 <serial_init>
    if (!serial_exists) {
//        cprintf("serial port does not exist!!\n");
    }
}
  1004dd:	90                   	nop
  1004de:	5d                   	pop    %ebp
  1004df:	c3                   	ret    

001004e0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1004e0:	55                   	push   %ebp
  1004e1:	89 e5                	mov    %esp,%ebp
  1004e3:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1004e6:	ff 75 08             	pushl  0x8(%ebp)
  1004e9:	e8 39 fd ff ff       	call   100227 <lpt_putc>
  1004ee:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1004f1:	83 ec 0c             	sub    $0xc,%esp
  1004f4:	ff 75 08             	pushl  0x8(%ebp)
  1004f7:	e8 a5 fd ff ff       	call   1002a1 <cga_putc>
  1004fc:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1004ff:	83 ec 0c             	sub    $0xc,%esp
  100502:	ff 75 08             	pushl  0x8(%ebp)
  100505:	e8 6c ff ff ff       	call   100476 <serial_putc>
  10050a:	83 c4 10             	add    $0x10,%esp
}
  10050d:	90                   	nop
  10050e:	c9                   	leave  
  10050f:	c3                   	ret    

00100510 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  100510:	55                   	push   %ebp
  100511:	89 e5                	mov    %esp,%ebp
  100513:	83 ec 14             	sub    $0x14,%esp
  100516:	8b 45 08             	mov    0x8(%ebp),%eax
  100519:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10051d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100521:	66 a3 bc 19 10 00    	mov    %ax,0x1019bc
    if (did_init) {
  100527:	a1 cc 19 10 00       	mov    0x1019cc,%eax
  10052c:	85 c0                	test   %eax,%eax
  10052e:	74 36                	je     100566 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  100530:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100534:	0f b6 c0             	movzbl %al,%eax
  100537:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10053d:	88 45 fa             	mov    %al,-0x6(%ebp)
  100540:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  100544:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100548:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  100549:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10054d:	66 c1 e8 08          	shr    $0x8,%ax
  100551:	0f b6 c0             	movzbl %al,%eax
  100554:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10055a:	88 45 fb             	mov    %al,-0x5(%ebp)
  10055d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100561:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100565:	ee                   	out    %al,(%dx)
    }
}
  100566:	90                   	nop
  100567:	c9                   	leave  
  100568:	c3                   	ret    

00100569 <pic_enable>:

void
pic_enable(unsigned int irq) {
  100569:	55                   	push   %ebp
  10056a:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  10056c:	8b 45 08             	mov    0x8(%ebp),%eax
  10056f:	ba 01 00 00 00       	mov    $0x1,%edx
  100574:	89 c1                	mov    %eax,%ecx
  100576:	d3 e2                	shl    %cl,%edx
  100578:	89 d0                	mov    %edx,%eax
  10057a:	f7 d0                	not    %eax
  10057c:	89 c2                	mov    %eax,%edx
  10057e:	0f b7 05 bc 19 10 00 	movzwl 0x1019bc,%eax
  100585:	21 d0                	and    %edx,%eax
  100587:	0f b7 c0             	movzwl %ax,%eax
  10058a:	50                   	push   %eax
  10058b:	e8 80 ff ff ff       	call   100510 <pic_setmask>
  100590:	83 c4 04             	add    $0x4,%esp
}
  100593:	90                   	nop
  100594:	c9                   	leave  
  100595:	c3                   	ret    

00100596 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  100596:	55                   	push   %ebp
  100597:	89 e5                	mov    %esp,%ebp
  100599:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  10059c:	c7 05 cc 19 10 00 01 	movl   $0x1,0x1019cc
  1005a3:	00 00 00 
  1005a6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1005ac:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1005b0:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1005b4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1005b8:	ee                   	out    %al,(%dx)
  1005b9:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1005bf:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1005c3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1005c7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1005cb:	ee                   	out    %al,(%dx)
  1005cc:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1005d2:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1005d6:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1005da:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1005de:	ee                   	out    %al,(%dx)
  1005df:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1005e5:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1005e9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1005ed:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1005f1:	ee                   	out    %al,(%dx)
  1005f2:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1005f8:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  1005fc:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100600:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100604:	ee                   	out    %al,(%dx)
  100605:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  10060b:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10060f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100613:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100617:	ee                   	out    %al,(%dx)
  100618:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10061e:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  100622:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100626:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10062a:	ee                   	out    %al,(%dx)
  10062b:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  100631:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100635:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100639:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10063d:	ee                   	out    %al,(%dx)
  10063e:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100644:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100648:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  10064c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100650:	ee                   	out    %al,(%dx)
  100651:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100657:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  10065b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10065f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100663:	ee                   	out    %al,(%dx)
  100664:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  10066a:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10066e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100672:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100676:	ee                   	out    %al,(%dx)
  100677:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10067d:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  100681:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100685:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  100689:	ee                   	out    %al,(%dx)
  10068a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  100690:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  100694:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100698:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10069c:	ee                   	out    %al,(%dx)
  10069d:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1006a3:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1006a7:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1006ab:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1006af:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1006b0:	0f b7 05 bc 19 10 00 	movzwl 0x1019bc,%eax
  1006b7:	66 83 f8 ff          	cmp    $0xffff,%ax
  1006bb:	74 13                	je     1006d0 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1006bd:	0f b7 05 bc 19 10 00 	movzwl 0x1019bc,%eax
  1006c4:	0f b7 c0             	movzwl %ax,%eax
  1006c7:	50                   	push   %eax
  1006c8:	e8 43 fe ff ff       	call   100510 <pic_setmask>
  1006cd:	83 c4 04             	add    $0x4,%esp
    }
}
  1006d0:	90                   	nop
  1006d1:	c9                   	leave  
  1006d2:	c3                   	ret    

001006d3 <print>:

/*
 * 打印
 * */
void
print(const char *msg) {
  1006d3:	55                   	push   %ebp
  1006d4:	89 e5                	mov    %esp,%ebp
  1006d6:	83 ec 18             	sub    $0x18,%esp
	const char *s = msg;
  1006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s ++ != '\0') {
  1006df:	eb 15                	jmp    1006f6 <print+0x23>
		cons_putc(*s);
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	0f b6 00             	movzbl (%eax),%eax
  1006e7:	0f be c0             	movsbl %al,%eax
  1006ea:	83 ec 0c             	sub    $0xc,%esp
  1006ed:	50                   	push   %eax
  1006ee:	e8 ed fd ff ff       	call   1004e0 <cons_putc>
  1006f3:	83 c4 10             	add    $0x10,%esp
 * 打印
 * */
void
print(const char *msg) {
	const char *s = msg;
	while (*s ++ != '\0') {
  1006f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f9:	8d 50 01             	lea    0x1(%eax),%edx
  1006fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1006ff:	0f b6 00             	movzbl (%eax),%eax
  100702:	84 c0                	test   %al,%al
  100704:	75 db                	jne    1006e1 <print+0xe>
		cons_putc(*s);
	}
}
  100706:	90                   	nop
  100707:	c9                   	leave  
  100708:	c3                   	ret    

00100709 <memmove>:
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  100709:	55                   	push   %ebp
  10070a:	89 e5                	mov    %esp,%ebp
  10070c:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  10070f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100712:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  100715:	8b 45 08             	mov    0x8(%ebp),%eax
  100718:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  10071b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10071e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100721:	73 54                	jae    100777 <memmove+0x6e>
  100723:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100726:	8b 45 10             	mov    0x10(%ebp),%eax
  100729:	01 d0                	add    %edx,%eax
  10072b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10072e:	76 47                	jbe    100777 <memmove+0x6e>
        s += n, d += n;
  100730:	8b 45 10             	mov    0x10(%ebp),%eax
  100733:	01 45 fc             	add    %eax,-0x4(%ebp)
  100736:	8b 45 10             	mov    0x10(%ebp),%eax
  100739:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  10073c:	eb 13                	jmp    100751 <memmove+0x48>
            *-- d = *-- s;
  10073e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100742:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100746:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100749:	0f b6 10             	movzbl (%eax),%edx
  10074c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10074f:	88 10                	mov    %dl,(%eax)
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  100751:	8b 45 10             	mov    0x10(%ebp),%eax
  100754:	8d 50 ff             	lea    -0x1(%eax),%edx
  100757:	89 55 10             	mov    %edx,0x10(%ebp)
  10075a:	85 c0                	test   %eax,%eax
  10075c:	75 e0                	jne    10073e <memmove+0x35>
 * */
void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  10075e:	eb 24                	jmp    100784 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  100760:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100763:	8d 50 01             	lea    0x1(%eax),%edx
  100766:	89 55 f8             	mov    %edx,-0x8(%ebp)
  100769:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10076c:	8d 4a 01             	lea    0x1(%edx),%ecx
  10076f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  100772:	0f b6 12             	movzbl (%edx),%edx
  100775:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  100777:	8b 45 10             	mov    0x10(%ebp),%eax
  10077a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10077d:	89 55 10             	mov    %edx,0x10(%ebp)
  100780:	85 c0                	test   %eax,%eax
  100782:	75 dc                	jne    100760 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  100784:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100787:	c9                   	leave  
  100788:	c3                   	ret    

00100789 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  100789:	55                   	push   %ebp
  10078a:	89 e5                	mov    %esp,%ebp
  10078c:	83 ec 14             	sub    $0x14,%esp
  10078f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100792:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  100795:	8b 45 08             	mov    0x8(%ebp),%eax
  100798:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  10079b:	eb 0f                	jmp    1007ac <memset+0x23>
		*p ++ = c;
  10079d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1007a0:	8d 50 01             	lea    0x1(%eax),%edx
  1007a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  1007a6:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  1007aa:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  1007ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1007af:	8d 50 ff             	lea    -0x1(%eax),%edx
  1007b2:	89 55 10             	mov    %edx,0x10(%ebp)
  1007b5:	85 c0                	test   %eax,%eax
  1007b7:	75 e4                	jne    10079d <memset+0x14>
		*p ++ = c;
	}
	return s;
  1007b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1007bc:	c9                   	leave  
  1007bd:	c3                   	ret    
