
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
#include <console.h>
#include <x86.h>

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
	cons_init();
  100006:	e8 59 05 00 00       	call   100564 <cons_init>
//	sti();
	cons_putc('h');
  10000b:	83 ec 0c             	sub    $0xc,%esp
  10000e:	6a 68                	push   $0x68
  100010:	e8 5f 05 00 00       	call   100574 <cons_putc>
  100015:	83 c4 10             	add    $0x10,%esp
	cons_putc('e');
  100018:	83 ec 0c             	sub    $0xc,%esp
  10001b:	6a 65                	push   $0x65
  10001d:	e8 52 05 00 00       	call   100574 <cons_putc>
  100022:	83 c4 10             	add    $0x10,%esp
	cons_putc('l');
  100025:	83 ec 0c             	sub    $0xc,%esp
  100028:	6a 6c                	push   $0x6c
  10002a:	e8 45 05 00 00       	call   100574 <cons_putc>
  10002f:	83 c4 10             	add    $0x10,%esp

	int a = 0;
  100032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	a = a + 3;
  100039:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
    while (1);
  10003d:	eb fe                	jmp    10003d <kern_init+0x3d>

0010003f <delay>:
//#include <stdio.h>
//#include <string.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  10003f:	55                   	push   %ebp
  100040:	89 e5                	mov    %esp,%ebp
  100042:	83 ec 10             	sub    $0x10,%esp
  100045:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10004b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10004f:	89 c2                	mov    %eax,%edx
  100051:	ec                   	in     (%dx),%al
  100052:	88 45 f4             	mov    %al,-0xc(%ebp)
  100055:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  10005b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  10005f:	89 c2                	mov    %eax,%edx
  100061:	ec                   	in     (%dx),%al
  100062:	88 45 f5             	mov    %al,-0xb(%ebp)
  100065:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  10006b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10006f:	89 c2                	mov    %eax,%edx
  100071:	ec                   	in     (%dx),%al
  100072:	88 45 f6             	mov    %al,-0xa(%ebp)
  100075:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  10007b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10007f:	89 c2                	mov    %eax,%edx
  100081:	ec                   	in     (%dx),%al
  100082:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100085:	90                   	nop
  100086:	c9                   	leave  
  100087:	c3                   	ret    

00100088 <memmove>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

void *
memmove(void *dst, const void *src, size_t n) {
  100088:	55                   	push   %ebp
  100089:	89 e5                	mov    %esp,%ebp
  10008b:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  10008e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100091:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  100094:	8b 45 08             	mov    0x8(%ebp),%eax
  100097:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  10009a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10009d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1000a0:	73 54                	jae    1000f6 <memmove+0x6e>
  1000a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1000a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000a8:	01 d0                	add    %edx,%eax
  1000aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1000ad:	76 47                	jbe    1000f6 <memmove+0x6e>
        s += n, d += n;
  1000af:	8b 45 10             	mov    0x10(%ebp),%eax
  1000b2:	01 45 fc             	add    %eax,-0x4(%ebp)
  1000b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000b8:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  1000bb:	eb 13                	jmp    1000d0 <memmove+0x48>
            *-- d = *-- s;
  1000bd:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  1000c1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1000c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000c8:	0f b6 10             	movzbl (%eax),%edx
  1000cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1000ce:	88 10                	mov    %dl,(%eax)
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  1000d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1000d6:	89 55 10             	mov    %edx,0x10(%ebp)
  1000d9:	85 c0                	test   %eax,%eax
  1000db:	75 e0                	jne    1000bd <memmove+0x35>

void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  1000dd:	eb 24                	jmp    100103 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  1000df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1000e2:	8d 50 01             	lea    0x1(%eax),%edx
  1000e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1000e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1000eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  1000ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  1000f1:	0f b6 12             	movzbl (%edx),%edx
  1000f4:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  1000f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1000fc:	89 55 10             	mov    %edx,0x10(%ebp)
  1000ff:	85 c0                	test   %eax,%eax
  100101:	75 dc                	jne    1000df <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  100103:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100106:	c9                   	leave  
  100107:	c3                   	ret    

00100108 <cga_init>:

static void
cga_init(void) {
  100108:	55                   	push   %ebp
  100109:	89 e5                	mov    %esp,%ebp
  10010b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  10010e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100118:	0f b7 00             	movzwl (%eax),%eax
  10011b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  10011f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100122:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100127:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10012a:	0f b7 00             	movzwl (%eax),%eax
  10012d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100131:	74 12                	je     100145 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100133:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  10013a:	66 c7 05 22 19 10 00 	movw   $0x3b4,0x101922
  100141:	b4 03 
  100143:	eb 13                	jmp    100158 <cga_init+0x50>
    } else {
        *cp = was;
  100145:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100148:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10014c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  10014f:	66 c7 05 22 19 10 00 	movw   $0x3d4,0x101922
  100156:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100158:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  10015f:	0f b7 c0             	movzwl %ax,%eax
  100162:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100166:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10016a:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  10016e:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100172:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100173:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  10017a:	83 c0 01             	add    $0x1,%eax
  10017d:	0f b7 c0             	movzwl %ax,%eax
  100180:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100184:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100188:	89 c2                	mov    %eax,%edx
  10018a:	ec                   	in     (%dx),%al
  10018b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10018e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100192:	0f b6 c0             	movzbl %al,%eax
  100195:	c1 e0 08             	shl    $0x8,%eax
  100198:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  10019b:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  1001a2:	0f b7 c0             	movzwl %ax,%eax
  1001a5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  1001a9:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1001ad:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  1001b1:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1001b5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  1001b6:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  1001bd:	83 c0 01             	add    $0x1,%eax
  1001c0:	0f b7 c0             	movzwl %ax,%eax
  1001c3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1001c7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1001cb:	89 c2                	mov    %eax,%edx
  1001cd:	ec                   	in     (%dx),%al
  1001ce:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1001d1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1001d5:	0f b6 c0             	movzbl %al,%eax
  1001d8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  1001db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001de:	a3 1c 19 10 00       	mov    %eax,0x10191c
    crt_pos = pos;
  1001e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1001e6:	66 a3 20 19 10 00    	mov    %ax,0x101920
}
  1001ec:	90                   	nop
  1001ed:	c9                   	leave  
  1001ee:	c3                   	ret    

001001ef <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  1001ef:	55                   	push   %ebp
  1001f0:	89 e5                	mov    %esp,%ebp
  1001f2:	83 ec 20             	sub    $0x20,%esp
  1001f5:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  1001fb:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1001ff:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100203:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100207:	ee                   	out    %al,(%dx)
  100208:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  10020e:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  100212:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100216:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10021a:	ee                   	out    %al,(%dx)
  10021b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100221:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  100225:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  100229:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10022d:	ee                   	out    %al,(%dx)
  10022e:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  100234:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100238:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10023c:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100240:	ee                   	out    %al,(%dx)
  100241:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  100247:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  10024b:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  10024f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100253:	ee                   	out    %al,(%dx)
  100254:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  10025a:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  10025e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100262:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100266:	ee                   	out    %al,(%dx)
  100267:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  10026d:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  100271:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  100275:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100279:	ee                   	out    %al,(%dx)
  10027a:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100280:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100284:	89 c2                	mov    %eax,%edx
  100286:	ec                   	in     (%dx),%al
  100287:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  10028a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10028e:	3c ff                	cmp    $0xff,%al
  100290:	0f 95 c0             	setne  %al
  100293:	0f b6 c0             	movzbl %al,%eax
  100296:	a3 24 19 10 00       	mov    %eax,0x101924
  10029b:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1002a1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1002a5:	89 c2                	mov    %eax,%edx
  1002a7:	ec                   	in     (%dx),%al
  1002a8:	88 45 ea             	mov    %al,-0x16(%ebp)
  1002ab:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  1002b1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1002b5:	89 c2                	mov    %eax,%edx
  1002b7:	ec                   	in     (%dx),%al
  1002b8:	88 45 eb             	mov    %al,-0x15(%ebp)

    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);
}
  1002bb:	90                   	nop
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1002c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1002cb:	eb 09                	jmp    1002d6 <lpt_putc+0x18>
        delay();
  1002cd:	e8 6d fd ff ff       	call   10003f <delay>

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1002d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1002d6:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  1002dc:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1002e0:	89 c2                	mov    %eax,%edx
  1002e2:	ec                   	in     (%dx),%al
  1002e3:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  1002e6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1002ea:	84 c0                	test   %al,%al
  1002ec:	78 09                	js     1002f7 <lpt_putc+0x39>
  1002ee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1002f5:	7e d6                	jle    1002cd <lpt_putc+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  1002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fa:	0f b6 c0             	movzbl %al,%eax
  1002fd:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100303:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100306:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10030a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10030e:	ee                   	out    %al,(%dx)
  10030f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100315:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100319:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10031d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100321:	ee                   	out    %al,(%dx)
  100322:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100328:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10032c:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100330:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100334:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100335:	90                   	nop
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	53                   	push   %ebx
  10033c:	83 ec 10             	sub    $0x10,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10033f:	8b 45 08             	mov    0x8(%ebp),%eax
  100342:	b0 00                	mov    $0x0,%al
  100344:	85 c0                	test   %eax,%eax
  100346:	75 07                	jne    10034f <cga_putc+0x17>
        c |= 0x0700;
  100348:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	0f b6 c0             	movzbl %al,%eax
  100355:	83 f8 0a             	cmp    $0xa,%eax
  100358:	74 4e                	je     1003a8 <cga_putc+0x70>
  10035a:	83 f8 0d             	cmp    $0xd,%eax
  10035d:	74 59                	je     1003b8 <cga_putc+0x80>
  10035f:	83 f8 08             	cmp    $0x8,%eax
  100362:	0f 85 8a 00 00 00    	jne    1003f2 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  100368:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  10036f:	66 85 c0             	test   %ax,%ax
  100372:	0f 84 a0 00 00 00    	je     100418 <cga_putc+0xe0>
            crt_pos --;
  100378:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  10037f:	83 e8 01             	sub    $0x1,%eax
  100382:	66 a3 20 19 10 00    	mov    %ax,0x101920
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100388:	a1 1c 19 10 00       	mov    0x10191c,%eax
  10038d:	0f b7 15 20 19 10 00 	movzwl 0x101920,%edx
  100394:	0f b7 d2             	movzwl %dx,%edx
  100397:	01 d2                	add    %edx,%edx
  100399:	01 d0                	add    %edx,%eax
  10039b:	8b 55 08             	mov    0x8(%ebp),%edx
  10039e:	b2 00                	mov    $0x0,%dl
  1003a0:	83 ca 20             	or     $0x20,%edx
  1003a3:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1003a6:	eb 70                	jmp    100418 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1003a8:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  1003af:	83 c0 50             	add    $0x50,%eax
  1003b2:	66 a3 20 19 10 00    	mov    %ax,0x101920
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1003b8:	0f b7 1d 20 19 10 00 	movzwl 0x101920,%ebx
  1003bf:	0f b7 0d 20 19 10 00 	movzwl 0x101920,%ecx
  1003c6:	0f b7 c1             	movzwl %cx,%eax
  1003c9:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1003cf:	c1 e8 10             	shr    $0x10,%eax
  1003d2:	89 c2                	mov    %eax,%edx
  1003d4:	66 c1 ea 06          	shr    $0x6,%dx
  1003d8:	89 d0                	mov    %edx,%eax
  1003da:	c1 e0 02             	shl    $0x2,%eax
  1003dd:	01 d0                	add    %edx,%eax
  1003df:	c1 e0 04             	shl    $0x4,%eax
  1003e2:	29 c1                	sub    %eax,%ecx
  1003e4:	89 ca                	mov    %ecx,%edx
  1003e6:	89 d8                	mov    %ebx,%eax
  1003e8:	29 d0                	sub    %edx,%eax
  1003ea:	66 a3 20 19 10 00    	mov    %ax,0x101920
        break;
  1003f0:	eb 27                	jmp    100419 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1003f2:	8b 0d 1c 19 10 00    	mov    0x10191c,%ecx
  1003f8:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  1003ff:	8d 50 01             	lea    0x1(%eax),%edx
  100402:	66 89 15 20 19 10 00 	mov    %dx,0x101920
  100409:	0f b7 c0             	movzwl %ax,%eax
  10040c:	01 c0                	add    %eax,%eax
  10040e:	01 c8                	add    %ecx,%eax
  100410:	8b 55 08             	mov    0x8(%ebp),%edx
  100413:	66 89 10             	mov    %dx,(%eax)
        break;
  100416:	eb 01                	jmp    100419 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  100418:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  100419:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  100420:	66 3d cf 07          	cmp    $0x7cf,%ax
  100424:	76 56                	jbe    10047c <cga_putc+0x144>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  100426:	a1 1c 19 10 00       	mov    0x10191c,%eax
  10042b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100431:	a1 1c 19 10 00       	mov    0x10191c,%eax
  100436:	68 00 0f 00 00       	push   $0xf00
  10043b:	52                   	push   %edx
  10043c:	50                   	push   %eax
  10043d:	e8 46 fc ff ff       	call   100088 <memmove>
  100442:	83 c4 0c             	add    $0xc,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100445:	c7 45 f8 80 07 00 00 	movl   $0x780,-0x8(%ebp)
  10044c:	eb 15                	jmp    100463 <cga_putc+0x12b>
            crt_buf[i] = 0x0700 | ' ';
  10044e:	a1 1c 19 10 00       	mov    0x10191c,%eax
  100453:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100456:	01 d2                	add    %edx,%edx
  100458:	01 d0                	add    %edx,%eax
  10045a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10045f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  100463:	81 7d f8 cf 07 00 00 	cmpl   $0x7cf,-0x8(%ebp)
  10046a:	7e e2                	jle    10044e <cga_putc+0x116>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10046c:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  100473:	83 e8 50             	sub    $0x50,%eax
  100476:	66 a3 20 19 10 00    	mov    %ax,0x101920
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10047c:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  100483:	0f b7 c0             	movzwl %ax,%eax
  100486:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  10048a:	c6 45 ec 0e          	movb   $0xe,-0x14(%ebp)
  10048e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100492:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100496:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  100497:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  10049e:	66 c1 e8 08          	shr    $0x8,%ax
  1004a2:	0f b6 c0             	movzbl %al,%eax
  1004a5:	0f b7 15 22 19 10 00 	movzwl 0x101922,%edx
  1004ac:	83 c2 01             	add    $0x1,%edx
  1004af:	0f b7 d2             	movzwl %dx,%edx
  1004b2:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  1004b6:	88 45 ed             	mov    %al,-0x13(%ebp)
  1004b9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1004bd:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1004c1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1004c2:	0f b7 05 22 19 10 00 	movzwl 0x101922,%eax
  1004c9:	0f b7 c0             	movzwl %ax,%eax
  1004cc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1004d0:	c6 45 ee 0f          	movb   $0xf,-0x12(%ebp)
  1004d4:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  1004d8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1004dc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1004dd:	0f b7 05 20 19 10 00 	movzwl 0x101920,%eax
  1004e4:	0f b6 c0             	movzbl %al,%eax
  1004e7:	0f b7 15 22 19 10 00 	movzwl 0x101922,%edx
  1004ee:	83 c2 01             	add    $0x1,%edx
  1004f1:	0f b7 d2             	movzwl %dx,%edx
  1004f4:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1004f8:	88 45 ef             	mov    %al,-0x11(%ebp)
  1004fb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  1004ff:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100503:	ee                   	out    %al,(%dx)
}
  100504:	90                   	nop
  100505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100508:	c9                   	leave  
  100509:	c3                   	ret    

0010050a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10050a:	55                   	push   %ebp
  10050b:	89 e5                	mov    %esp,%ebp
  10050d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100510:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100517:	eb 09                	jmp    100522 <serial_putc+0x18>
        delay();
  100519:	e8 21 fb ff ff       	call   10003f <delay>

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10051e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100522:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100528:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10052c:	89 c2                	mov    %eax,%edx
  10052e:	ec                   	in     (%dx),%al
  10052f:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  100532:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100536:	0f b6 c0             	movzbl %al,%eax
  100539:	83 e0 20             	and    $0x20,%eax
  10053c:	85 c0                	test   %eax,%eax
  10053e:	75 09                	jne    100549 <serial_putc+0x3f>
  100540:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100547:	7e d0                	jle    100519 <serial_putc+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  100549:	8b 45 08             	mov    0x8(%ebp),%eax
  10054c:	0f b6 c0             	movzbl %al,%eax
  10054f:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100555:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100558:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  10055c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100560:	ee                   	out    %al,(%dx)
}
  100561:	90                   	nop
  100562:	c9                   	leave  
  100563:	c3                   	ret    

00100564 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  100564:	55                   	push   %ebp
  100565:	89 e5                	mov    %esp,%ebp
    cga_init();
  100567:	e8 9c fb ff ff       	call   100108 <cga_init>
    serial_init();
  10056c:	e8 7e fc ff ff       	call   1001ef <serial_init>
    if (!serial_exists) {
//        cprintf("serial port does not exist!!\n");
    }
}
  100571:	90                   	nop
  100572:	5d                   	pop    %ebp
  100573:	c3                   	ret    

00100574 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  100574:	55                   	push   %ebp
  100575:	89 e5                	mov    %esp,%ebp
    lpt_putc(c);
  100577:	ff 75 08             	pushl  0x8(%ebp)
  10057a:	e8 3f fd ff ff       	call   1002be <lpt_putc>
  10057f:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  100582:	ff 75 08             	pushl  0x8(%ebp)
  100585:	e8 ae fd ff ff       	call   100338 <cga_putc>
  10058a:	83 c4 04             	add    $0x4,%esp
    serial_putc(c);
  10058d:	ff 75 08             	pushl  0x8(%ebp)
  100590:	e8 75 ff ff ff       	call   10050a <serial_putc>
  100595:	83 c4 04             	add    $0x4,%esp
}
  100598:	90                   	nop
  100599:	c9                   	leave  
  10059a:	c3                   	ret    

0010059b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10059b:	55                   	push   %ebp
  10059c:	89 e5                	mov    %esp,%ebp
  10059e:	83 ec 14             	sub    $0x14,%esp
  1005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1005a8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1005ac:	66 a3 18 19 10 00    	mov    %ax,0x101918
    if (did_init) {
  1005b2:	a1 28 19 10 00       	mov    0x101928,%eax
  1005b7:	85 c0                	test   %eax,%eax
  1005b9:	74 36                	je     1005f1 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1005bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1005bf:	0f b6 c0             	movzbl %al,%eax
  1005c2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1005c8:	88 45 fa             	mov    %al,-0x6(%ebp)
  1005cb:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1005cf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1005d3:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1005d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1005d8:	66 c1 e8 08          	shr    $0x8,%ax
  1005dc:	0f b6 c0             	movzbl %al,%eax
  1005df:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1005e5:	88 45 fb             	mov    %al,-0x5(%ebp)
  1005e8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1005ec:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1005f0:	ee                   	out    %al,(%dx)
    }
}
  1005f1:	90                   	nop
  1005f2:	c9                   	leave  
  1005f3:	c3                   	ret    

001005f4 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1005f4:	55                   	push   %ebp
  1005f5:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fa:	ba 01 00 00 00       	mov    $0x1,%edx
  1005ff:	89 c1                	mov    %eax,%ecx
  100601:	d3 e2                	shl    %cl,%edx
  100603:	89 d0                	mov    %edx,%eax
  100605:	f7 d0                	not    %eax
  100607:	89 c2                	mov    %eax,%edx
  100609:	0f b7 05 18 19 10 00 	movzwl 0x101918,%eax
  100610:	21 d0                	and    %edx,%eax
  100612:	0f b7 c0             	movzwl %ax,%eax
  100615:	50                   	push   %eax
  100616:	e8 80 ff ff ff       	call   10059b <pic_setmask>
  10061b:	83 c4 04             	add    $0x4,%esp
}
  10061e:	90                   	nop
  10061f:	c9                   	leave  
  100620:	c3                   	ret    

00100621 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  100621:	55                   	push   %ebp
  100622:	89 e5                	mov    %esp,%ebp
  100624:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  100627:	c7 05 28 19 10 00 01 	movl   $0x1,0x101928
  10062e:	00 00 00 
  100631:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100637:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10063b:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  10063f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100643:	ee                   	out    %al,(%dx)
  100644:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10064a:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10064e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100652:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100656:	ee                   	out    %al,(%dx)
  100657:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10065d:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  100661:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  100665:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100669:	ee                   	out    %al,(%dx)
  10066a:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100670:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  100674:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100678:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10067c:	ee                   	out    %al,(%dx)
  10067d:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100683:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100687:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10068b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10068f:	ee                   	out    %al,(%dx)
  100690:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100696:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10069a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10069e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1006a2:	ee                   	out    %al,(%dx)
  1006a3:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1006a9:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1006ad:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1006b1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1006b5:	ee                   	out    %al,(%dx)
  1006b6:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1006bc:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1006c0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1006c4:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1006c8:	ee                   	out    %al,(%dx)
  1006c9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1006cf:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1006d3:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1006d7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1006db:	ee                   	out    %al,(%dx)
  1006dc:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1006e2:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1006e6:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1006ea:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1006ee:	ee                   	out    %al,(%dx)
  1006ef:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1006f5:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1006f9:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1006fd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100701:	ee                   	out    %al,(%dx)
  100702:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  100708:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10070c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100710:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  100714:	ee                   	out    %al,(%dx)
  100715:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10071b:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10071f:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100723:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100727:	ee                   	out    %al,(%dx)
  100728:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10072e:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  100732:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100736:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  10073a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10073b:	0f b7 05 18 19 10 00 	movzwl 0x101918,%eax
  100742:	66 83 f8 ff          	cmp    $0xffff,%ax
  100746:	74 13                	je     10075b <pic_init+0x13a>
        pic_setmask(irq_mask);
  100748:	0f b7 05 18 19 10 00 	movzwl 0x101918,%eax
  10074f:	0f b7 c0             	movzwl %ax,%eax
  100752:	50                   	push   %eax
  100753:	e8 43 fe ff ff       	call   10059b <pic_setmask>
  100758:	83 c4 04             	add    $0x4,%esp
    }
}
  10075b:	90                   	nop
  10075c:	c9                   	leave  
  10075d:	c3                   	ret    
