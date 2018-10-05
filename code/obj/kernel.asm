
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <threadFunc>:
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 08             	sub    $0x8,%esp
  100006:	83 ec 0c             	sub    $0xc,%esp
  100009:	68 eb 0b 10 00       	push   $0x100beb
  10000e:	e8 e1 06 00 00       	call   1006f4 <print>
  100013:	83 c4 10             	add    $0x10,%esp
  100016:	90                   	nop
  100017:	c9                   	leave  
  100018:	c3                   	ret    

00100019 <kern_init>:
  100019:	55                   	push   %ebp
  10001a:	89 e5                	mov    %esp,%ebp
  10001c:	83 ec 18             	sub    $0x18,%esp
  10001f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  100026:	e8 c6 04 00 00       	call   1004f1 <cons_init>
  10002b:	83 ec 0c             	sub    $0xc,%esp
  10002e:	68 fc 0b 10 00       	push   $0x100bfc
  100033:	e8 bc 06 00 00       	call   1006f4 <print>
  100038:	83 c4 10             	add    $0x10,%esp
  10003b:	e8 73 09 00 00       	call   1009b3 <page_init>
  100040:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  100047:	eb fe                	jmp    100047 <kern_init+0x2e>

00100049 <delay>:
#include <x86.h>
#include <string.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100049:	55                   	push   %ebp
  10004a:	89 e5                	mov    %esp,%ebp
  10004c:	83 ec 10             	sub    $0x10,%esp
  10004f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100055:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100059:	89 c2                	mov    %eax,%edx
  10005b:	ec                   	in     (%dx),%al
  10005c:	88 45 f4             	mov    %al,-0xc(%ebp)
  10005f:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100065:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100069:	89 c2                	mov    %eax,%edx
  10006b:	ec                   	in     (%dx),%al
  10006c:	88 45 f5             	mov    %al,-0xb(%ebp)
  10006f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100075:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100079:	89 c2                	mov    %eax,%edx
  10007b:	ec                   	in     (%dx),%al
  10007c:	88 45 f6             	mov    %al,-0xa(%ebp)
  10007f:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100085:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100089:	89 c2                	mov    %eax,%edx
  10008b:	ec                   	in     (%dx),%al
  10008c:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  10008f:	90                   	nop
  100090:	c9                   	leave  
  100091:	c3                   	ret    

00100092 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100092:	55                   	push   %ebp
  100093:	89 e5                	mov    %esp,%ebp
  100095:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100098:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  10009f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000a2:	0f b7 00             	movzwl (%eax),%eax
  1000a5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1000a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000ac:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1000b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000b4:	0f b7 00             	movzwl (%eax),%eax
  1000b7:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1000bb:	74 12                	je     1000cf <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  1000bd:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1000c4:	66 c7 05 26 50 10 00 	movw   $0x3b4,0x105026
  1000cb:	b4 03 
  1000cd:	eb 13                	jmp    1000e2 <cga_init+0x50>
    } else {
        *cp = was;
  1000cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000d2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1000d6:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  1000d9:	66 c7 05 26 50 10 00 	movw   $0x3d4,0x105026
  1000e0:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  1000e2:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  1000e9:	0f b7 c0             	movzwl %ax,%eax
  1000ec:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  1000f0:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1000f4:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1000f8:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1000fc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  1000fd:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  100104:	83 c0 01             	add    $0x1,%eax
  100107:	0f b7 c0             	movzwl %ax,%eax
  10010a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10010e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100112:	89 c2                	mov    %eax,%edx
  100114:	ec                   	in     (%dx),%al
  100115:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100118:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10011c:	0f b6 c0             	movzbl %al,%eax
  10011f:	c1 e0 08             	shl    $0x8,%eax
  100122:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100125:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  10012c:	0f b7 c0             	movzwl %ax,%eax
  10012f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100133:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100137:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  10013b:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10013f:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100140:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  100147:	83 c0 01             	add    $0x1,%eax
  10014a:	0f b7 c0             	movzwl %ax,%eax
  10014d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100151:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	ec                   	in     (%dx),%al
  100158:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10015b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10015f:	0f b6 c0             	movzbl %al,%eax
  100162:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100168:	a3 20 50 10 00       	mov    %eax,0x105020
    crt_pos = pos;
  10016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100170:	66 a3 24 50 10 00    	mov    %ax,0x105024
}
  100176:	90                   	nop
  100177:	c9                   	leave  
  100178:	c3                   	ret    

00100179 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100179:	55                   	push   %ebp
  10017a:	89 e5                	mov    %esp,%ebp
  10017c:	83 ec 20             	sub    $0x20,%esp
  10017f:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  100185:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100189:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10018d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100191:	ee                   	out    %al,(%dx)
  100192:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  100198:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  10019c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1001a0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1001a4:	ee                   	out    %al,(%dx)
  1001a5:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1001ab:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  1001af:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  1001b3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1001b7:	ee                   	out    %al,(%dx)
  1001b8:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  1001be:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1001c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1001c6:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1001ca:	ee                   	out    %al,(%dx)
  1001cb:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  1001d1:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  1001d5:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  1001d9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1001dd:	ee                   	out    %al,(%dx)
  1001de:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  1001e4:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  1001e8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1001ec:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1001f0:	ee                   	out    %al,(%dx)
  1001f1:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  1001f7:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  1001fb:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1001ff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100203:	ee                   	out    %al,(%dx)
  100204:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10020a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10020e:	89 c2                	mov    %eax,%edx
  100210:	ec                   	in     (%dx),%al
  100211:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100214:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100218:	3c ff                	cmp    $0xff,%al
  10021a:	0f 95 c0             	setne  %al
  10021d:	0f b6 c0             	movzbl %al,%eax
  100220:	a3 28 50 10 00       	mov    %eax,0x105028
  100225:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10022b:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10022f:	89 c2                	mov    %eax,%edx
  100231:	ec                   	in     (%dx),%al
  100232:	88 45 ea             	mov    %al,-0x16(%ebp)
  100235:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  10023b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10023f:	89 c2                	mov    %eax,%edx
  100241:	ec                   	in     (%dx),%al
  100242:	88 45 eb             	mov    %al,-0x15(%ebp)

    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);
}
  100245:	90                   	nop
  100246:	c9                   	leave  
  100247:	c3                   	ret    

00100248 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100248:	55                   	push   %ebp
  100249:	89 e5                	mov    %esp,%ebp
  10024b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10024e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100255:	eb 09                	jmp    100260 <lpt_putc+0x18>
        delay();
  100257:	e8 ed fd ff ff       	call   100049 <delay>

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10025c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100260:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100266:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10026a:	89 c2                	mov    %eax,%edx
  10026c:	ec                   	in     (%dx),%al
  10026d:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100270:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100274:	84 c0                	test   %al,%al
  100276:	78 09                	js     100281 <lpt_putc+0x39>
  100278:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10027f:	7e d6                	jle    100257 <lpt_putc+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100281:	8b 45 08             	mov    0x8(%ebp),%eax
  100284:	0f b6 c0             	movzbl %al,%eax
  100287:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  10028d:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100290:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100294:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100298:	ee                   	out    %al,(%dx)
  100299:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10029f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1002a3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1002a7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1002ab:	ee                   	out    %al,(%dx)
  1002ac:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  1002b2:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  1002b6:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  1002ba:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1002be:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1002bf:	90                   	nop
  1002c0:	c9                   	leave  
  1002c1:	c3                   	ret    

001002c2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	53                   	push   %ebx
  1002c6:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cc:	b0 00                	mov    $0x0,%al
  1002ce:	85 c0                	test   %eax,%eax
  1002d0:	75 07                	jne    1002d9 <cga_putc+0x17>
        c |= 0x0700;
  1002d2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002dc:	0f b6 c0             	movzbl %al,%eax
  1002df:	83 f8 0a             	cmp    $0xa,%eax
  1002e2:	74 4e                	je     100332 <cga_putc+0x70>
  1002e4:	83 f8 0d             	cmp    $0xd,%eax
  1002e7:	74 59                	je     100342 <cga_putc+0x80>
  1002e9:	83 f8 08             	cmp    $0x8,%eax
  1002ec:	0f 85 8a 00 00 00    	jne    10037c <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1002f2:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  1002f9:	66 85 c0             	test   %ax,%ax
  1002fc:	0f 84 a0 00 00 00    	je     1003a2 <cga_putc+0xe0>
            crt_pos --;
  100302:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  100309:	83 e8 01             	sub    $0x1,%eax
  10030c:	66 a3 24 50 10 00    	mov    %ax,0x105024
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100312:	a1 20 50 10 00       	mov    0x105020,%eax
  100317:	0f b7 15 24 50 10 00 	movzwl 0x105024,%edx
  10031e:	0f b7 d2             	movzwl %dx,%edx
  100321:	01 d2                	add    %edx,%edx
  100323:	01 d0                	add    %edx,%eax
  100325:	8b 55 08             	mov    0x8(%ebp),%edx
  100328:	b2 00                	mov    $0x0,%dl
  10032a:	83 ca 20             	or     $0x20,%edx
  10032d:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  100330:	eb 70                	jmp    1003a2 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  100332:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  100339:	83 c0 50             	add    $0x50,%eax
  10033c:	66 a3 24 50 10 00    	mov    %ax,0x105024
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  100342:	0f b7 1d 24 50 10 00 	movzwl 0x105024,%ebx
  100349:	0f b7 0d 24 50 10 00 	movzwl 0x105024,%ecx
  100350:	0f b7 c1             	movzwl %cx,%eax
  100353:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100359:	c1 e8 10             	shr    $0x10,%eax
  10035c:	89 c2                	mov    %eax,%edx
  10035e:	66 c1 ea 06          	shr    $0x6,%dx
  100362:	89 d0                	mov    %edx,%eax
  100364:	c1 e0 02             	shl    $0x2,%eax
  100367:	01 d0                	add    %edx,%eax
  100369:	c1 e0 04             	shl    $0x4,%eax
  10036c:	29 c1                	sub    %eax,%ecx
  10036e:	89 ca                	mov    %ecx,%edx
  100370:	89 d8                	mov    %ebx,%eax
  100372:	29 d0                	sub    %edx,%eax
  100374:	66 a3 24 50 10 00    	mov    %ax,0x105024
        break;
  10037a:	eb 27                	jmp    1003a3 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10037c:	8b 0d 20 50 10 00    	mov    0x105020,%ecx
  100382:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  100389:	8d 50 01             	lea    0x1(%eax),%edx
  10038c:	66 89 15 24 50 10 00 	mov    %dx,0x105024
  100393:	0f b7 c0             	movzwl %ax,%eax
  100396:	01 c0                	add    %eax,%eax
  100398:	01 c8                	add    %ecx,%eax
  10039a:	8b 55 08             	mov    0x8(%ebp),%edx
  10039d:	66 89 10             	mov    %dx,(%eax)
        break;
  1003a0:	eb 01                	jmp    1003a3 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1003a2:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1003a3:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  1003aa:	66 3d cf 07          	cmp    $0x7cf,%ax
  1003ae:	76 59                	jbe    100409 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1003b0:	a1 20 50 10 00       	mov    0x105020,%eax
  1003b5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1003bb:	a1 20 50 10 00       	mov    0x105020,%eax
  1003c0:	83 ec 04             	sub    $0x4,%esp
  1003c3:	68 00 0f 00 00       	push   $0xf00
  1003c8:	52                   	push   %edx
  1003c9:	50                   	push   %eax
  1003ca:	e8 37 07 00 00       	call   100b06 <memmove>
  1003cf:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003d2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1003d9:	eb 15                	jmp    1003f0 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1003db:	a1 20 50 10 00       	mov    0x105020,%eax
  1003e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1003e3:	01 d2                	add    %edx,%edx
  1003e5:	01 d0                	add    %edx,%eax
  1003e7:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1003f0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1003f7:	7e e2                	jle    1003db <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1003f9:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  100400:	83 e8 50             	sub    $0x50,%eax
  100403:	66 a3 24 50 10 00    	mov    %ax,0x105024
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  100409:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  100410:	0f b7 c0             	movzwl %ax,%eax
  100413:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100417:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10041b:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10041f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100423:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  100424:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  10042b:	66 c1 e8 08          	shr    $0x8,%ax
  10042f:	0f b6 c0             	movzbl %al,%eax
  100432:	0f b7 15 26 50 10 00 	movzwl 0x105026,%edx
  100439:	83 c2 01             	add    $0x1,%edx
  10043c:	0f b7 d2             	movzwl %dx,%edx
  10043f:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  100443:	88 45 e9             	mov    %al,-0x17(%ebp)
  100446:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10044a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10044e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10044f:	0f b7 05 26 50 10 00 	movzwl 0x105026,%eax
  100456:	0f b7 c0             	movzwl %ax,%eax
  100459:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10045d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  100461:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100465:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100469:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10046a:	0f b7 05 24 50 10 00 	movzwl 0x105024,%eax
  100471:	0f b6 c0             	movzbl %al,%eax
  100474:	0f b7 15 26 50 10 00 	movzwl 0x105026,%edx
  10047b:	83 c2 01             	add    $0x1,%edx
  10047e:	0f b7 d2             	movzwl %dx,%edx
  100481:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  100485:	88 45 eb             	mov    %al,-0x15(%ebp)
  100488:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10048c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100490:	ee                   	out    %al,(%dx)
}
  100491:	90                   	nop
  100492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100495:	c9                   	leave  
  100496:	c3                   	ret    

00100497 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  100497:	55                   	push   %ebp
  100498:	89 e5                	mov    %esp,%ebp
  10049a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10049d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1004a4:	eb 09                	jmp    1004af <serial_putc+0x18>
        delay();
  1004a6:	e8 9e fb ff ff       	call   100049 <delay>

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1004ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1004af:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1004b5:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	ec                   	in     (%dx),%al
  1004bc:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1004bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1004c3:	0f b6 c0             	movzbl %al,%eax
  1004c6:	83 e0 20             	and    $0x20,%eax
  1004c9:	85 c0                	test   %eax,%eax
  1004cb:	75 09                	jne    1004d6 <serial_putc+0x3f>
  1004cd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1004d4:	7e d0                	jle    1004a6 <serial_putc+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d9:	0f b6 c0             	movzbl %al,%eax
  1004dc:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1004e2:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1004e5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1004e9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1004ed:	ee                   	out    %al,(%dx)
}
  1004ee:	90                   	nop
  1004ef:	c9                   	leave  
  1004f0:	c3                   	ret    

001004f1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1004f1:	55                   	push   %ebp
  1004f2:	89 e5                	mov    %esp,%ebp
    cga_init();
  1004f4:	e8 99 fb ff ff       	call   100092 <cga_init>
    serial_init();
  1004f9:	e8 7b fc ff ff       	call   100179 <serial_init>
    if (!serial_exists) {
//        cprintf("serial port does not exist!!\n");
    }
}
  1004fe:	90                   	nop
  1004ff:	5d                   	pop    %ebp
  100500:	c3                   	ret    

00100501 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  100501:	55                   	push   %ebp
  100502:	89 e5                	mov    %esp,%ebp
  100504:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  100507:	ff 75 08             	pushl  0x8(%ebp)
  10050a:	e8 39 fd ff ff       	call   100248 <lpt_putc>
  10050f:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  100512:	83 ec 0c             	sub    $0xc,%esp
  100515:	ff 75 08             	pushl  0x8(%ebp)
  100518:	e8 a5 fd ff ff       	call   1002c2 <cga_putc>
  10051d:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  100520:	83 ec 0c             	sub    $0xc,%esp
  100523:	ff 75 08             	pushl  0x8(%ebp)
  100526:	e8 6c ff ff ff       	call   100497 <serial_putc>
  10052b:	83 c4 10             	add    $0x10,%esp
}
  10052e:	90                   	nop
  10052f:	c9                   	leave  
  100530:	c3                   	ret    

00100531 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  100531:	55                   	push   %ebp
  100532:	89 e5                	mov    %esp,%ebp
  100534:	83 ec 14             	sub    $0x14,%esp
  100537:	8b 45 08             	mov    0x8(%ebp),%eax
  10053a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10053e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100542:	66 a3 00 50 10 00    	mov    %ax,0x105000
    if (did_init) {
  100548:	a1 2c 50 10 00       	mov    0x10502c,%eax
  10054d:	85 c0                	test   %eax,%eax
  10054f:	74 36                	je     100587 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  100551:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100555:	0f b6 c0             	movzbl %al,%eax
  100558:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10055e:	88 45 fa             	mov    %al,-0x6(%ebp)
  100561:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  100565:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100569:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10056a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10056e:	66 c1 e8 08          	shr    $0x8,%ax
  100572:	0f b6 c0             	movzbl %al,%eax
  100575:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10057b:	88 45 fb             	mov    %al,-0x5(%ebp)
  10057e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100582:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100586:	ee                   	out    %al,(%dx)
    }
}
  100587:	90                   	nop
  100588:	c9                   	leave  
  100589:	c3                   	ret    

0010058a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10058a:	55                   	push   %ebp
  10058b:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  10058d:	8b 45 08             	mov    0x8(%ebp),%eax
  100590:	ba 01 00 00 00       	mov    $0x1,%edx
  100595:	89 c1                	mov    %eax,%ecx
  100597:	d3 e2                	shl    %cl,%edx
  100599:	89 d0                	mov    %edx,%eax
  10059b:	f7 d0                	not    %eax
  10059d:	89 c2                	mov    %eax,%edx
  10059f:	0f b7 05 00 50 10 00 	movzwl 0x105000,%eax
  1005a6:	21 d0                	and    %edx,%eax
  1005a8:	0f b7 c0             	movzwl %ax,%eax
  1005ab:	50                   	push   %eax
  1005ac:	e8 80 ff ff ff       	call   100531 <pic_setmask>
  1005b1:	83 c4 04             	add    $0x4,%esp
}
  1005b4:	90                   	nop
  1005b5:	c9                   	leave  
  1005b6:	c3                   	ret    

001005b7 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1005b7:	55                   	push   %ebp
  1005b8:	89 e5                	mov    %esp,%ebp
  1005ba:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1005bd:	c7 05 2c 50 10 00 01 	movl   $0x1,0x10502c
  1005c4:	00 00 00 
  1005c7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1005cd:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1005d1:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1005d5:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1005d9:	ee                   	out    %al,(%dx)
  1005da:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1005e0:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1005e4:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1005e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1005ec:	ee                   	out    %al,(%dx)
  1005ed:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1005f3:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1005f7:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1005fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1005ff:	ee                   	out    %al,(%dx)
  100600:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100606:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  10060a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10060e:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100612:	ee                   	out    %al,(%dx)
  100613:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100619:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  10061d:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100621:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100625:	ee                   	out    %al,(%dx)
  100626:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  10062c:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  100630:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100634:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100638:	ee                   	out    %al,(%dx)
  100639:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10063f:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  100643:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100647:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10064b:	ee                   	out    %al,(%dx)
  10064c:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  100652:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100656:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10065a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10065e:	ee                   	out    %al,(%dx)
  10065f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100665:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100669:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  10066d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100671:	ee                   	out    %al,(%dx)
  100672:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100678:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  10067c:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100680:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100684:	ee                   	out    %al,(%dx)
  100685:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  10068b:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10068f:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100693:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100697:	ee                   	out    %al,(%dx)
  100698:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10069e:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1006a2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1006a6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1006aa:	ee                   	out    %al,(%dx)
  1006ab:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1006b1:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1006b5:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1006b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1006bd:	ee                   	out    %al,(%dx)
  1006be:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1006c4:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1006c8:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1006cc:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1006d0:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1006d1:	0f b7 05 00 50 10 00 	movzwl 0x105000,%eax
  1006d8:	66 83 f8 ff          	cmp    $0xffff,%ax
  1006dc:	74 13                	je     1006f1 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1006de:	0f b7 05 00 50 10 00 	movzwl 0x105000,%eax
  1006e5:	0f b7 c0             	movzwl %ax,%eax
  1006e8:	50                   	push   %eax
  1006e9:	e8 43 fe ff ff       	call   100531 <pic_setmask>
  1006ee:	83 c4 04             	add    $0x4,%esp
    }
}
  1006f1:	90                   	nop
  1006f2:	c9                   	leave  
  1006f3:	c3                   	ret    

001006f4 <print>:

/*
 * 打印
 * */
void
print(const char *msg) {
  1006f4:	55                   	push   %ebp
  1006f5:	89 e5                	mov    %esp,%ebp
  1006f7:	83 ec 18             	sub    $0x18,%esp
	const char *s = msg;
  1006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  100700:	eb 19                	jmp    10071b <print+0x27>
		cons_putc(*s);
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	0f b6 00             	movzbl (%eax),%eax
  100708:	0f be c0             	movsbl %al,%eax
  10070b:	83 ec 0c             	sub    $0xc,%esp
  10070e:	50                   	push   %eax
  10070f:	e8 ed fd ff ff       	call   100501 <cons_putc>
  100714:	83 c4 10             	add    $0x10,%esp
		s++;
  100717:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 * 打印
 * */
void
print(const char *msg) {
	const char *s = msg;
	while (*s != '\0') {
  10071b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071e:	0f b6 00             	movzbl (%eax),%eax
  100721:	84 c0                	test   %al,%al
  100723:	75 dd                	jne    100702 <print+0xe>
		cons_putc(*s);
		s++;
	}
}
  100725:	90                   	nop
  100726:	c9                   	leave  
  100727:	c3                   	ret    

00100728 <switch_to>:
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    # 保存了进程在返回switch_to函数后的指令地址到context.eip中
    movl 4(%esp), %eax          # eax points to from
  100728:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
  10072c:	8f 00                	popl   (%eax)

    # 保存前一个进程的其他7个寄存器到context中的相应域中
    movl %esp, 4(%eax)
  10072e:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
  100731:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
  100734:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
  100737:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
  10073a:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
  10073d:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
  100740:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    # context的高地址的域ebp开始，逐一把相关域的值赋值给对应的寄存器
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
  100743:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
  100747:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
  10074a:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
  10074d:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
  100750:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
  100753:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
  100756:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
  100759:	8b 60 04             	mov    0x4(%eax),%esp

	# 把context中保存的下一个进程要执行的指令地址context.eip放到了堆栈顶
    pushl 0(%eax)               # push eip
  10075c:	ff 30                	pushl  (%eax)

	# 最后一条指令“ret”时，会把栈顶的内容赋值给EIP寄存器，这样就切换到下一个进程执行了
    ret
  10075e:	c3                   	ret    

0010075f <do_fork>:
 * ret == 0 // child
 * ret >0  // parent
 * ret < 0 // error
 * */
int
do_fork() {
  10075f:	55                   	push   %ebp
  100760:	89 e5                	mov    %esp,%ebp
	return 0;
  100762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100767:	5d                   	pop    %ebp
  100768:	c3                   	ret    

00100769 <alloc_proc>:

//
struct proc_struct *
alloc_proc(){
  100769:	55                   	push   %ebp
  10076a:	89 e5                	mov    %esp,%ebp
  10076c:	83 ec 18             	sub    $0x18,%esp
	int n = sizeof(struct proc_struct);
  10076f:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	struct proc_struct *p = (struct proc_struct *)alloc(n);
  100776:	83 ec 0c             	sub    $0xc,%esp
  100779:	ff 75 f4             	pushl  -0xc(%ebp)
  10077c:	e8 d2 01 00 00       	call   100953 <alloc>
  100781:	83 c4 10             	add    $0x10,%esp
  100784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (p != NULL) {
  100787:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10078b:	74 13                	je     1007a0 <alloc_proc+0x37>
		p->state = EnumProcUnint;
  10078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		p->pid = -1;
  100796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100799:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	}
//	p->cr3 = boot_cr3;
	return p;
  1007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1007a3:	c9                   	leave  
  1007a4:	c3                   	ret    

001007a5 <alloc_thread>:


task_struct *
alloc_thread(){
  1007a5:	55                   	push   %ebp
  1007a6:	89 e5                	mov    %esp,%ebp
  1007a8:	83 ec 18             	sub    $0x18,%esp
	int n = sizeof(task_struct) ;  // PG_SIZE
  1007ab:	c7 45 f4 60 00 00 00 	movl   $0x60,-0xc(%ebp)
	task_struct *p = (task_struct *)alloc(n);
  1007b2:	83 ec 0c             	sub    $0xc,%esp
  1007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  1007b8:	e8 96 01 00 00       	call   100953 <alloc>
  1007bd:	83 c4 10             	add    $0x10,%esp
  1007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (p != NULL) {
  1007c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1007c7:	74 0a                	je     1007d3 <alloc_thread+0x2e>
		p->status = EnumProcUnint;
  1007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1007cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	}
//	p->cr3 = boot_cr3;
	return p;
  1007d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1007d6:	c9                   	leave  
  1007d7:	c3                   	ret    

001007d8 <init_thread>:
//	return 0;
//}

// 初始化线程基本信息
void
init_thread(task_struct* pthread, char* name, int prio) {
  1007d8:	55                   	push   %ebp
  1007d9:	89 e5                	mov    %esp,%ebp
  1007db:	83 ec 08             	sub    $0x8,%esp
	memset(pthread, 0, sizeof(*pthread));
  1007de:	83 ec 04             	sub    $0x4,%esp
  1007e1:	6a 60                	push   $0x60
  1007e3:	6a 00                	push   $0x0
  1007e5:	ff 75 08             	pushl  0x8(%ebp)
  1007e8:	e8 99 03 00 00       	call   100b86 <memset>
  1007ed:	83 c4 10             	add    $0x10,%esp
//	memset(&(proc->context), 0, sizeof(struct context));
	strcpy(pthread->name, name);
  1007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f3:	83 c0 08             	add    $0x8,%eax
  1007f6:	83 ec 08             	sub    $0x8,%esp
  1007f9:	ff 75 0c             	pushl  0xc(%ebp)
  1007fc:	50                   	push   %eax
  1007fd:	e8 b9 03 00 00       	call   100bbb <strcpy>
  100802:	83 c4 10             	add    $0x10,%esp
//	if (pthread->name == main_thread) {
//		pthread->status = EnumProcRunning;
//	} else {
//		pthread->status = EnumProcReady;
//	}
	pthread->status = EnumProcReady;
  100805:	8b 45 08             	mov    0x8(%ebp),%eax
  100808:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

	pthread->priority = prio;
  10080f:	8b 45 10             	mov    0x10(%ebp),%eax
  100812:	89 c2                	mov    %eax,%edx
  100814:	8b 45 08             	mov    0x8(%ebp),%eax
  100817:	88 50 18             	mov    %dl,0x18(%eax)
	pthread->ticks = prio;
  10081a:	8b 45 10             	mov    0x10(%ebp),%eax
  10081d:	89 c2                	mov    %eax,%edx
  10081f:	8b 45 08             	mov    0x8(%ebp),%eax
  100822:	88 50 19             	mov    %dl,0x19(%eax)
	pthread->elapsed_ticks = 0;
  100825:	8b 45 08             	mov    0x8(%ebp),%eax
  100828:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	// self_kstack是线程自己在内核态下使用的栈顶地址
	pthread->self_kstack = (uint32_t*)((uint32_t)pthread + PG_SIZE);;
  10082f:	8b 45 08             	mov    0x8(%ebp),%eax
  100832:	05 00 04 00 00       	add    $0x400,%eax
  100837:	89 c2                	mov    %eax,%edx
  100839:	8b 45 08             	mov    0x8(%ebp),%eax
  10083c:	89 10                	mov    %edx,(%eax)
	pthread->stack_magic = 0x19971234;     // 自定义的魔数，检查栈溢出
  10083e:	8b 45 08             	mov    0x8(%ebp),%eax
  100841:	c7 40 5c 34 12 97 19 	movl   $0x19971234,0x5c(%eax)
}
  100848:	90                   	nop
  100849:	c9                   	leave  
  10084a:	c3                   	ret    

0010084b <kernel_thread>:

static void
kernel_thread(thread_func function, void *func_arg)
{
  10084b:	55                   	push   %ebp
  10084c:	89 e5                	mov    %esp,%ebp
  10084e:	83 ec 08             	sub    $0x8,%esp
//	function(func_arg);
	print("aaaaaaa");
  100851:	83 ec 0c             	sub    $0xc,%esp
  100854:	68 06 0c 10 00       	push   $0x100c06
  100859:	e8 96 fe ff ff       	call   1006f4 <print>
  10085e:	83 c4 10             	add    $0x10,%esp
	while(1) {
		;
	}
  100861:	eb fe                	jmp    100861 <kernel_thread+0x16>

00100863 <thread_create>:
}

// 创建线程
void
thread_create(task_struct* pthread, thread_func function, void* func_arg) {
  100863:	55                   	push   %ebp
  100864:	89 e5                	mov    %esp,%ebp
//	pthread->self_kstack -= sizeof(intr_stack);

	// 留出线程栈空间
//	pthread->self_kstack -= sizeof(thread_stack);

	pthread->function = function;
  100866:	8b 45 08             	mov    0x8(%ebp),%eax
  100869:	8b 55 0c             	mov    0xc(%ebp),%edx
  10086c:	89 50 54             	mov    %edx,0x54(%eax)
	pthread->func_arg = func_arg;
  10086f:	8b 45 08             	mov    0x8(%ebp),%eax
  100872:	8b 55 10             	mov    0x10(%ebp),%edx
  100875:	89 50 58             	mov    %edx,0x58(%eax)

	pthread->context.eip = &kernel_thread;
  100878:	ba 4b 08 10 00       	mov    $0x10084b,%edx
  10087d:	8b 45 08             	mov    0x8(%ebp),%eax
  100880:	89 50 30             	mov    %edx,0x30(%eax)
//	thread_stack* kthread_stack = (thread_stack*)pthread->self_kstack;
//	kthread_stack->eip = kernel_thread;
//	kthread_stack->thread_func = function;
//	kthread_stack->func_arg = func_arg;
//	kthread_stack->ebp = kthread_stack->ebx = kthread_stack->esi = kthread_stack->edi = 0;
}
  100883:	90                   	nop
  100884:	5d                   	pop    %ebp
  100885:	c3                   	ret    

00100886 <thread_start>:

// 创建一优先级为prio的线程,线程名为name,线程所执行的函数是function(func_arg)
task_struct*
thread_start(char* name, int prio, thread_func function, void*  func_arg) {
  100886:	55                   	push   %ebp
  100887:	89 e5                	mov    %esp,%ebp
  100889:	83 ec 08             	sub    $0x8,%esp
	// pcb都位于内核空间,包括用户进程的pcb也是在内核空间
//	task_struct* thread = get_kernel_pages(1);
	thread = alloc_thread();
  10088c:	e8 14 ff ff ff       	call   1007a5 <alloc_thread>
  100891:	a3 34 50 10 00       	mov    %eax,0x105034
	if (thread == NULL) {
  100896:	a1 34 50 10 00       	mov    0x105034,%eax
  10089b:	85 c0                	test   %eax,%eax
  10089d:	75 17                	jne    1008b6 <thread_start+0x30>
		print("error thread_start\n");
  10089f:	83 ec 0c             	sub    $0xc,%esp
  1008a2:	68 0e 0c 10 00       	push   $0x100c0e
  1008a7:	e8 48 fe ff ff       	call   1006f4 <print>
  1008ac:	83 c4 10             	add    $0x10,%esp
		return NULL;
  1008af:	b8 00 00 00 00       	mov    $0x0,%eax
  1008b4:	eb 50                	jmp    100906 <thread_start+0x80>
	}

	init_thread(thread, name, prio);
  1008b6:	a1 34 50 10 00       	mov    0x105034,%eax
  1008bb:	83 ec 04             	sub    $0x4,%esp
  1008be:	ff 75 0c             	pushl  0xc(%ebp)
  1008c1:	ff 75 08             	pushl  0x8(%ebp)
  1008c4:	50                   	push   %eax
  1008c5:	e8 0e ff ff ff       	call   1007d8 <init_thread>
  1008ca:	83 c4 10             	add    $0x10,%esp
	thread_create(thread, function, func_arg);
  1008cd:	a1 34 50 10 00       	mov    0x105034,%eax
  1008d2:	83 ec 04             	sub    $0x4,%esp
  1008d5:	ff 75 14             	pushl  0x14(%ebp)
  1008d8:	ff 75 10             	pushl  0x10(%ebp)
  1008db:	50                   	push   %eax
  1008dc:	e8 82 ff ff ff       	call   100863 <thread_create>
  1008e1:	83 c4 10             	add    $0x10,%esp
	 * 准备好数据之后执行ret，此时会从栈顶会得到返回地址，该地址也就是上面赋值的eip，也就是kernelthread的地址，然后执行该函数，
	 * kernel_thread从栈中得到参数，也就是栈顶+4的真正要执行的线程函数地址，和栈顶+8的线程函数所需的参数。
	 * */
//	asm volatile ("movl %0, %%esp; pop %%ebp; pop %%ebx; pop %%edi; pop %%esi; ret"  : : "g" (thread->self_kstack) : "memory");

	switch_to(&(current->context), &(thread->context));
  1008e4:	a1 34 50 10 00       	mov    0x105034,%eax
  1008e9:	8d 50 30             	lea    0x30(%eax),%edx
  1008ec:	a1 30 50 10 00       	mov    0x105030,%eax
  1008f1:	83 c0 30             	add    $0x30,%eax
  1008f4:	83 ec 08             	sub    $0x8,%esp
  1008f7:	52                   	push   %edx
  1008f8:	50                   	push   %eax
  1008f9:	e8 2a fe ff ff       	call   100728 <switch_to>
  1008fe:	83 c4 10             	add    $0x10,%esp
	return thread;
  100901:	a1 34 50 10 00       	mov    0x105034,%eax
}
  100906:	c9                   	leave  
  100907:	c3                   	ret    

00100908 <running_thread>:

// 执行线程
task_struct *
running_thread() {
  100908:	55                   	push   %ebp
  100909:	89 e5                	mov    %esp,%ebp

}
  10090b:	90                   	nop
  10090c:	5d                   	pop    %ebp
  10090d:	c3                   	ret    

0010090e <proc_init>:

//
void
proc_init(void) {
  10090e:	55                   	push   %ebp
  10090f:	89 e5                	mov    %esp,%ebp
  100911:	83 ec 08             	sub    $0x8,%esp
//	idleproc = alloc_proc();
//	if (idleproc == NULL) {
//		print("cannot alloc idleproc.\n");
//		return ;
//	}
	current = alloc_thread();
  100914:	e8 8c fe ff ff       	call   1007a5 <alloc_thread>
  100919:	a3 30 50 10 00       	mov    %eax,0x105030
	if (current == NULL) {
  10091e:	a1 30 50 10 00       	mov    0x105030,%eax
  100923:	85 c0                	test   %eax,%eax
  100925:	75 12                	jne    100939 <proc_init+0x2b>
		print("cannot alloc current.\n");
  100927:	83 ec 0c             	sub    $0xc,%esp
  10092a:	68 22 0c 10 00       	push   $0x100c22
  10092f:	e8 c0 fd ff ff       	call   1006f4 <print>
  100934:	83 c4 10             	add    $0x10,%esp
		return ;
  100937:	eb 18                	jmp    100951 <proc_init+0x43>
	}
	init_thread(current, "main", 1);
  100939:	a1 30 50 10 00       	mov    0x105030,%eax
  10093e:	83 ec 04             	sub    $0x4,%esp
  100941:	6a 01                	push   $0x1
  100943:	68 39 0c 10 00       	push   $0x100c39
  100948:	50                   	push   %eax
  100949:	e8 8a fe ff ff       	call   1007d8 <init_thread>
  10094e:	83 c4 10             	add    $0x10,%esp


//	idleproc->pid = 0;
//	idleproc->state = EnumProcReady;
//	current = idleproc;
}
  100951:	c9                   	leave  
  100952:	c3                   	ret    

00100953 <alloc>:
size_t npage = 0;

/*
 * */
char
*alloc(int n) {
  100953:	55                   	push   %ebp
  100954:	89 e5                	mov    %esp,%ebp
  100956:	83 ec 10             	sub    $0x10,%esp
	int size = allocbuf+AllocSize - allocp;
  100959:	b8 70 77 10 00       	mov    $0x107770,%eax
  10095e:	89 c2                	mov    %eax,%edx
  100960:	a1 04 50 10 00       	mov    0x105004,%eax
  100965:	29 c2                	sub    %eax,%edx
  100967:	89 d0                	mov    %edx,%eax
  100969:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(size >= n) {
  10096c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10096f:	3b 45 08             	cmp    0x8(%ebp),%eax
  100972:	7c 17                	jl     10098b <alloc+0x38>
		allocp += n;
  100974:	8b 15 04 50 10 00    	mov    0x105004,%edx
  10097a:	8b 45 08             	mov    0x8(%ebp),%eax
  10097d:	01 d0                	add    %edx,%eax
  10097f:	a3 04 50 10 00       	mov    %eax,0x105004
//		return alloc - n;
		return allocp;
  100984:	a1 04 50 10 00       	mov    0x105004,%eax
  100989:	eb 05                	jmp    100990 <alloc+0x3d>
	} else {
		return NULL;
  10098b:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  100990:	c9                   	leave  
  100991:	c3                   	ret    

00100992 <afree>:

/*
 * */
void
afree(char *p) {
  100992:	55                   	push   %ebp
  100993:	89 e5                	mov    %esp,%ebp
    if (p >= allocbuf && p<allocbuf + AllocSize) {
  100995:	81 7d 08 60 50 10 00 	cmpl   $0x105060,0x8(%ebp)
  10099c:	72 12                	jb     1009b0 <afree+0x1e>
  10099e:	b8 70 77 10 00       	mov    $0x107770,%eax
  1009a3:	39 45 08             	cmp    %eax,0x8(%ebp)
  1009a6:	73 08                	jae    1009b0 <afree+0x1e>
    	 allocp = p;
  1009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ab:	a3 04 50 10 00       	mov    %eax,0x105004
    }
}
  1009b0:	90                   	nop
  1009b1:	5d                   	pop    %ebp
  1009b2:	c3                   	ret    

001009b3 <page_init>:

/* pmm_init - initialize the physical memory management */
void
page_init(void) {
  1009b3:	55                   	push   %ebp
  1009b4:	89 e5                	mov    %esp,%ebp
  1009b6:	53                   	push   %ebx
  1009b7:	83 ec 44             	sub    $0x44,%esp
//	 KERNBASE 0x100000
	struct e820map *memmap = (struct e820map *)(0x8000);
  1009ba:	c7 45 e8 00 80 00 00 	movl   $0x8000,-0x18(%ebp)
	uint64_t maxpa = 0;
  1009c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1009c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int i;
	int nr_map = memmap->nr_map;
  1009cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d2:	8b 00                	mov    (%eax),%eax
  1009d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < nr_map; i++) {
  1009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009de:	e9 a0 00 00 00       	jmp    100a83 <page_init+0xd0>
		uint64_t begin = memmap->map[i].addr;
  1009e3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1009e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1009e9:	89 d0                	mov    %edx,%eax
  1009eb:	c1 e0 02             	shl    $0x2,%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	c1 e0 02             	shl    $0x2,%eax
  1009f3:	01 c8                	add    %ecx,%eax
  1009f5:	8b 50 08             	mov    0x8(%eax),%edx
  1009f8:	8b 40 04             	mov    0x4(%eax),%eax
  1009fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1009fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
		uint64_t end = begin + memmap->map[i].size;
  100a01:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100a07:	89 d0                	mov    %edx,%eax
  100a09:	c1 e0 02             	shl    $0x2,%eax
  100a0c:	01 d0                	add    %edx,%eax
  100a0e:	c1 e0 02             	shl    $0x2,%eax
  100a11:	01 c8                	add    %ecx,%eax
  100a13:	8b 48 0c             	mov    0xc(%eax),%ecx
  100a16:	8b 58 10             	mov    0x10(%eax),%ebx
  100a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100a1f:	01 c8                	add    %ecx,%eax
  100a21:	11 da                	adc    %ebx,%edx
  100a23:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100a26:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		uint32_t type = memmap->map[i].type;
  100a29:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100a2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100a2f:	89 d0                	mov    %edx,%eax
  100a31:	c1 e0 02             	shl    $0x2,%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	c1 e0 02             	shl    $0x2,%eax
  100a39:	01 c8                	add    %ecx,%eax
  100a3b:	83 c0 14             	add    $0x14,%eax
  100a3e:	8b 00                	mov    (%eax),%eax
  100a40:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (type == E820_ARM) {
  100a43:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  100a47:	75 36                	jne    100a7f <page_init+0xcc>
			// address range memory
		  if (maxpa < end && begin < KMEMSIZE) {
  100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a4f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  100a52:	77 2b                	ja     100a7f <page_init+0xcc>
  100a54:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  100a57:	72 05                	jb     100a5e <page_init+0xab>
  100a59:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  100a5c:	73 21                	jae    100a7f <page_init+0xcc>
  100a5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  100a62:	77 1b                	ja     100a7f <page_init+0xcc>
  100a64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  100a68:	72 09                	jb     100a73 <page_init+0xc0>
  100a6a:	81 7d d8 ff ff ff 37 	cmpl   $0x37ffffff,-0x28(%ebp)
  100a71:	77 0c                	ja     100a7f <page_init+0xcc>
			maxpa = end;
  100a73:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100a76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100a7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
	struct e820map *memmap = (struct e820map *)(0x8000);
	uint64_t maxpa = 0;

	int i;
	int nr_map = memmap->nr_map;
	for (i = 0; i < nr_map; i++) {
  100a7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a86:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100a89:	0f 8c 54 ff ff ff    	jl     1009e3 <page_init+0x30>
		  }
		}
	}

	// 最大的物理内存地址maxpa
	if (maxpa > KMEMSIZE) {
  100a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a93:	72 1d                	jb     100ab2 <page_init+0xff>
  100a95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a99:	77 09                	ja     100aa4 <page_init+0xf1>
  100a9b:	81 7d f0 00 00 00 38 	cmpl   $0x38000000,-0x10(%ebp)
  100aa2:	76 0e                	jbe    100ab2 <page_init+0xff>
		maxpa = KMEMSIZE;
  100aa4:	c7 45 f0 00 00 00 38 	movl   $0x38000000,-0x10(%ebp)
  100aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	// bootloader加载ucore的结束地址（用全局指针变量end记录）
	extern char end[];

	//	需要管理的物理页个数
	npage = maxpa / PGSIZE;
  100ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ab8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  100abc:	c1 ea 0c             	shr    $0xc,%edx
  100abf:	a3 40 50 10 00       	mov    %eax,0x105040
	// 把end按页大小为边界去整后，作为管理页级物理内存空间所需的Page结构的内存空间
	pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  100ac4:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  100acb:	b8 74 77 10 00       	mov    $0x107774,%eax
  100ad0:	8d 50 ff             	lea    -0x1(%eax),%edx
  100ad3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  100ad6:	01 d0                	add    %edx,%eax
  100ad8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  100adb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  100ade:	ba 00 00 00 00       	mov    $0x0,%edx
  100ae3:	f7 75 c8             	divl   -0x38(%ebp)
  100ae6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  100ae9:	29 d0                	sub    %edx,%eax
  100aeb:	a3 70 77 10 00       	mov    %eax,0x107770
//				}
//			}
//		}
//	}

	print("e820map:\n");
  100af0:	83 ec 0c             	sub    $0xc,%esp
  100af3:	68 3e 0c 10 00       	push   $0x100c3e
  100af8:	e8 f7 fb ff ff       	call   1006f4 <print>
  100afd:	83 c4 10             	add    $0x10,%esp
}
  100b00:	90                   	nop
  100b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b04:	c9                   	leave  
  100b05:	c3                   	ret    

00100b06 <memmove>:
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  100b06:	55                   	push   %ebp
  100b07:	89 e5                	mov    %esp,%ebp
  100b09:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  100b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  100b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100b1e:	73 54                	jae    100b74 <memmove+0x6e>
  100b20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100b23:	8b 45 10             	mov    0x10(%ebp),%eax
  100b26:	01 d0                	add    %edx,%eax
  100b28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100b2b:	76 47                	jbe    100b74 <memmove+0x6e>
        s += n, d += n;
  100b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  100b30:	01 45 fc             	add    %eax,-0x4(%ebp)
  100b33:	8b 45 10             	mov    0x10(%ebp),%eax
  100b36:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  100b39:	eb 13                	jmp    100b4e <memmove+0x48>
            *-- d = *-- s;
  100b3b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100b3f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b46:	0f b6 10             	movzbl (%eax),%edx
  100b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100b4c:	88 10                	mov    %dl,(%eax)
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  100b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  100b51:	8d 50 ff             	lea    -0x1(%eax),%edx
  100b54:	89 55 10             	mov    %edx,0x10(%ebp)
  100b57:	85 c0                	test   %eax,%eax
  100b59:	75 e0                	jne    100b3b <memmove+0x35>
 * */
void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  100b5b:	eb 24                	jmp    100b81 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  100b5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100b60:	8d 50 01             	lea    0x1(%eax),%edx
  100b63:	89 55 f8             	mov    %edx,-0x8(%ebp)
  100b66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100b69:	8d 4a 01             	lea    0x1(%edx),%ecx
  100b6c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  100b6f:	0f b6 12             	movzbl (%edx),%edx
  100b72:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  100b74:	8b 45 10             	mov    0x10(%ebp),%eax
  100b77:	8d 50 ff             	lea    -0x1(%eax),%edx
  100b7a:	89 55 10             	mov    %edx,0x10(%ebp)
  100b7d:	85 c0                	test   %eax,%eax
  100b7f:	75 dc                	jne    100b5d <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  100b81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100b84:	c9                   	leave  
  100b85:	c3                   	ret    

00100b86 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  100b86:	55                   	push   %ebp
  100b87:	89 e5                	mov    %esp,%ebp
  100b89:	83 ec 14             	sub    $0x14,%esp
  100b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b8f:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  100b92:	8b 45 08             	mov    0x8(%ebp),%eax
  100b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  100b98:	eb 0f                	jmp    100ba9 <memset+0x23>
		*p ++ = c;
  100b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b9d:	8d 50 01             	lea    0x1(%eax),%edx
  100ba0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  100ba3:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  100ba7:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  100ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  100bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  100baf:	89 55 10             	mov    %edx,0x10(%ebp)
  100bb2:	85 c0                	test   %eax,%eax
  100bb4:	75 e4                	jne    100b9a <memset+0x14>
		*p ++ = c;
	}
	return s;
  100bb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100bb9:	c9                   	leave  
  100bba:	c3                   	ret    

00100bbb <strcpy>:


char *
strcpy(char *dst, const char *src){
  100bbb:	55                   	push   %ebp
  100bbc:	89 e5                	mov    %esp,%ebp
  100bbe:	83 ec 10             	sub    $0x10,%esp
	char *ret = dst;
  100bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++=*src++)!='\0') {
  100bc7:	90                   	nop
  100bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bcb:	8d 50 01             	lea    0x1(%eax),%edx
  100bce:	89 55 08             	mov    %edx,0x8(%ebp)
  100bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bd4:	8d 4a 01             	lea    0x1(%edx),%ecx
  100bd7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  100bda:	0f b6 12             	movzbl (%edx),%edx
  100bdd:	88 10                	mov    %dl,(%eax)
  100bdf:	0f b6 00             	movzbl (%eax),%eax
  100be2:	84 c0                	test   %al,%al
  100be4:	75 e2                	jne    100bc8 <strcpy+0xd>
		;
	}

	return ret;
  100be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100be9:	c9                   	leave  
  100bea:	c3                   	ret    
