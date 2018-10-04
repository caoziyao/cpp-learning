
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
#include <stdio.h>
#include <proc.h>
#include <defs.h>

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
	int a = 1;
  100006:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cons_init();
  10000d:	e8 c6 04 00 00       	call   1004d8 <cons_init>

	print("hello");
  100012:	83 ec 0c             	sub    $0xc,%esp
  100015:	68 b5 08 10 00       	push   $0x1008b5
  10001a:	e8 bc 06 00 00       	call   1006db <print>
  10001f:	83 c4 10             	add    $0x10,%esp

//	struct proc_struct *p = alloc_proc();
	proc_init();
  100022:	e8 2e 07 00 00       	call   100755 <proc_init>

	a = 2;
  100027:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)

    while (1) {
    	;
    }
  10002e:	eb fe                	jmp    10002e <kern_init+0x2e>

00100030 <delay>:
#include <x86.h>
#include <string.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100030:	55                   	push   %ebp
  100031:	89 e5                	mov    %esp,%ebp
  100033:	83 ec 10             	sub    $0x10,%esp
  100036:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10003c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100040:	89 c2                	mov    %eax,%edx
  100042:	ec                   	in     (%dx),%al
  100043:	88 45 f4             	mov    %al,-0xc(%ebp)
  100046:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  10004c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100050:	89 c2                	mov    %eax,%edx
  100052:	ec                   	in     (%dx),%al
  100053:	88 45 f5             	mov    %al,-0xb(%ebp)
  100056:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  10005c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100060:	89 c2                	mov    %eax,%edx
  100062:	ec                   	in     (%dx),%al
  100063:	88 45 f6             	mov    %al,-0xa(%ebp)
  100066:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  10006c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100070:	89 c2                	mov    %eax,%edx
  100072:	ec                   	in     (%dx),%al
  100073:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100076:	90                   	nop
  100077:	c9                   	leave  
  100078:	c3                   	ret    

00100079 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  10007f:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100089:	0f b7 00             	movzwl (%eax),%eax
  10008c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100093:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10009b:	0f b7 00             	movzwl (%eax),%eax
  10009e:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1000a2:	74 12                	je     1000b6 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  1000a4:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1000ab:	66 c7 05 26 10 10 00 	movw   $0x3b4,0x101026
  1000b2:	b4 03 
  1000b4:	eb 13                	jmp    1000c9 <cga_init+0x50>
    } else {
        *cp = was;
  1000b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000b9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1000bd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  1000c0:	66 c7 05 26 10 10 00 	movw   $0x3d4,0x101026
  1000c7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  1000c9:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  1000d0:	0f b7 c0             	movzwl %ax,%eax
  1000d3:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  1000d7:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1000db:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1000df:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1000e3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  1000e4:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  1000eb:	83 c0 01             	add    $0x1,%eax
  1000ee:	0f b7 c0             	movzwl %ax,%eax
  1000f1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1000f5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1000f9:	89 c2                	mov    %eax,%edx
  1000fb:	ec                   	in     (%dx),%al
  1000fc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1000ff:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100103:	0f b6 c0             	movzbl %al,%eax
  100106:	c1 e0 08             	shl    $0x8,%eax
  100109:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  10010c:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  100113:	0f b7 c0             	movzwl %ax,%eax
  100116:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  10011a:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10011e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100122:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100126:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100127:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  10012e:	83 c0 01             	add    $0x1,%eax
  100131:	0f b7 c0             	movzwl %ax,%eax
  100134:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100138:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10013c:	89 c2                	mov    %eax,%edx
  10013e:	ec                   	in     (%dx),%al
  10013f:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100142:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100146:	0f b6 c0             	movzbl %al,%eax
  100149:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  10014c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10014f:	a3 20 10 10 00       	mov    %eax,0x101020
    crt_pos = pos;
  100154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100157:	66 a3 24 10 10 00    	mov    %ax,0x101024
}
  10015d:	90                   	nop
  10015e:	c9                   	leave  
  10015f:	c3                   	ret    

00100160 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100160:	55                   	push   %ebp
  100161:	89 e5                	mov    %esp,%ebp
  100163:	83 ec 20             	sub    $0x20,%esp
  100166:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  10016c:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100170:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100174:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100178:	ee                   	out    %al,(%dx)
  100179:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  10017f:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  100183:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100187:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10018b:	ee                   	out    %al,(%dx)
  10018c:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100192:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  100196:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  10019a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10019e:	ee                   	out    %al,(%dx)
  10019f:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  1001a5:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1001a9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1001ad:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1001b1:	ee                   	out    %al,(%dx)
  1001b2:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  1001b8:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  1001bc:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  1001c0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1001c4:	ee                   	out    %al,(%dx)
  1001c5:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  1001cb:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  1001cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1001d3:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1001d7:	ee                   	out    %al,(%dx)
  1001d8:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  1001de:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  1001e2:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1001e6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1001ea:	ee                   	out    %al,(%dx)
  1001eb:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1001f1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001f5:	89 c2                	mov    %eax,%edx
  1001f7:	ec                   	in     (%dx),%al
  1001f8:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  1001fb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1001ff:	3c ff                	cmp    $0xff,%al
  100201:	0f 95 c0             	setne  %al
  100204:	0f b6 c0             	movzbl %al,%eax
  100207:	a3 28 10 10 00       	mov    %eax,0x101028
  10020c:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100212:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100216:	89 c2                	mov    %eax,%edx
  100218:	ec                   	in     (%dx),%al
  100219:	88 45 ea             	mov    %al,-0x16(%ebp)
  10021c:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  100222:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100226:	89 c2                	mov    %eax,%edx
  100228:	ec                   	in     (%dx),%al
  100229:	88 45 eb             	mov    %al,-0x15(%ebp)

    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);
}
  10022c:	90                   	nop
  10022d:	c9                   	leave  
  10022e:	c3                   	ret    

0010022f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10022f:	55                   	push   %ebp
  100230:	89 e5                	mov    %esp,%ebp
  100232:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10023c:	eb 09                	jmp    100247 <lpt_putc+0x18>
        delay();
  10023e:	e8 ed fd ff ff       	call   100030 <delay>

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100243:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100247:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10024d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100251:	89 c2                	mov    %eax,%edx
  100253:	ec                   	in     (%dx),%al
  100254:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100257:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10025b:	84 c0                	test   %al,%al
  10025d:	78 09                	js     100268 <lpt_putc+0x39>
  10025f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100266:	7e d6                	jle    10023e <lpt_putc+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	0f b6 c0             	movzbl %al,%eax
  10026e:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100274:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100277:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10027b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10027f:	ee                   	out    %al,(%dx)
  100280:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100286:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10028a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10028e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100292:	ee                   	out    %al,(%dx)
  100293:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100299:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10029d:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  1002a1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1002a5:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1002a6:	90                   	nop
  1002a7:	c9                   	leave  
  1002a8:	c3                   	ret    

001002a9 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1002a9:	55                   	push   %ebp
  1002aa:	89 e5                	mov    %esp,%ebp
  1002ac:	53                   	push   %ebx
  1002ad:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b3:	b0 00                	mov    $0x0,%al
  1002b5:	85 c0                	test   %eax,%eax
  1002b7:	75 07                	jne    1002c0 <cga_putc+0x17>
        c |= 0x0700;
  1002b9:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c3:	0f b6 c0             	movzbl %al,%eax
  1002c6:	83 f8 0a             	cmp    $0xa,%eax
  1002c9:	74 4e                	je     100319 <cga_putc+0x70>
  1002cb:	83 f8 0d             	cmp    $0xd,%eax
  1002ce:	74 59                	je     100329 <cga_putc+0x80>
  1002d0:	83 f8 08             	cmp    $0x8,%eax
  1002d3:	0f 85 8a 00 00 00    	jne    100363 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1002d9:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  1002e0:	66 85 c0             	test   %ax,%ax
  1002e3:	0f 84 a0 00 00 00    	je     100389 <cga_putc+0xe0>
            crt_pos --;
  1002e9:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  1002f0:	83 e8 01             	sub    $0x1,%eax
  1002f3:	66 a3 24 10 10 00    	mov    %ax,0x101024
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1002f9:	a1 20 10 10 00       	mov    0x101020,%eax
  1002fe:	0f b7 15 24 10 10 00 	movzwl 0x101024,%edx
  100305:	0f b7 d2             	movzwl %dx,%edx
  100308:	01 d2                	add    %edx,%edx
  10030a:	01 d0                	add    %edx,%eax
  10030c:	8b 55 08             	mov    0x8(%ebp),%edx
  10030f:	b2 00                	mov    $0x0,%dl
  100311:	83 ca 20             	or     $0x20,%edx
  100314:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  100317:	eb 70                	jmp    100389 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  100319:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100320:	83 c0 50             	add    $0x50,%eax
  100323:	66 a3 24 10 10 00    	mov    %ax,0x101024
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  100329:	0f b7 1d 24 10 10 00 	movzwl 0x101024,%ebx
  100330:	0f b7 0d 24 10 10 00 	movzwl 0x101024,%ecx
  100337:	0f b7 c1             	movzwl %cx,%eax
  10033a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100340:	c1 e8 10             	shr    $0x10,%eax
  100343:	89 c2                	mov    %eax,%edx
  100345:	66 c1 ea 06          	shr    $0x6,%dx
  100349:	89 d0                	mov    %edx,%eax
  10034b:	c1 e0 02             	shl    $0x2,%eax
  10034e:	01 d0                	add    %edx,%eax
  100350:	c1 e0 04             	shl    $0x4,%eax
  100353:	29 c1                	sub    %eax,%ecx
  100355:	89 ca                	mov    %ecx,%edx
  100357:	89 d8                	mov    %ebx,%eax
  100359:	29 d0                	sub    %edx,%eax
  10035b:	66 a3 24 10 10 00    	mov    %ax,0x101024
        break;
  100361:	eb 27                	jmp    10038a <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  100363:	8b 0d 20 10 10 00    	mov    0x101020,%ecx
  100369:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	66 89 15 24 10 10 00 	mov    %dx,0x101024
  10037a:	0f b7 c0             	movzwl %ax,%eax
  10037d:	01 c0                	add    %eax,%eax
  10037f:	01 c8                	add    %ecx,%eax
  100381:	8b 55 08             	mov    0x8(%ebp),%edx
  100384:	66 89 10             	mov    %dx,(%eax)
        break;
  100387:	eb 01                	jmp    10038a <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  100389:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10038a:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100391:	66 3d cf 07          	cmp    $0x7cf,%ax
  100395:	76 59                	jbe    1003f0 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  100397:	a1 20 10 10 00       	mov    0x101020,%eax
  10039c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1003a2:	a1 20 10 10 00       	mov    0x101020,%eax
  1003a7:	83 ec 04             	sub    $0x4,%esp
  1003aa:	68 00 0f 00 00       	push   $0xf00
  1003af:	52                   	push   %edx
  1003b0:	50                   	push   %eax
  1003b1:	e8 4a 04 00 00       	call   100800 <memmove>
  1003b6:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003b9:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1003c0:	eb 15                	jmp    1003d7 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1003c2:	a1 20 10 10 00       	mov    0x101020,%eax
  1003c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1003ca:	01 d2                	add    %edx,%edx
  1003cc:	01 d0                	add    %edx,%eax
  1003ce:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1003d7:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1003de:	7e e2                	jle    1003c2 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1003e0:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  1003e7:	83 e8 50             	sub    $0x50,%eax
  1003ea:	66 a3 24 10 10 00    	mov    %ax,0x101024
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1003f0:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  1003f7:	0f b7 c0             	movzwl %ax,%eax
  1003fa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1003fe:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  100402:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  100406:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10040a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10040b:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100412:	66 c1 e8 08          	shr    $0x8,%ax
  100416:	0f b6 c0             	movzbl %al,%eax
  100419:	0f b7 15 26 10 10 00 	movzwl 0x101026,%edx
  100420:	83 c2 01             	add    $0x1,%edx
  100423:	0f b7 d2             	movzwl %dx,%edx
  100426:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10042a:	88 45 e9             	mov    %al,-0x17(%ebp)
  10042d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100431:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100435:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  100436:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  10043d:	0f b7 c0             	movzwl %ax,%eax
  100440:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100444:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  100448:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  10044c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100450:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  100451:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100458:	0f b6 c0             	movzbl %al,%eax
  10045b:	0f b7 15 26 10 10 00 	movzwl 0x101026,%edx
  100462:	83 c2 01             	add    $0x1,%edx
  100465:	0f b7 d2             	movzwl %dx,%edx
  100468:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  10046c:	88 45 eb             	mov    %al,-0x15(%ebp)
  10046f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100473:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100477:	ee                   	out    %al,(%dx)
}
  100478:	90                   	nop
  100479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10047c:	c9                   	leave  
  10047d:	c3                   	ret    

0010047e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10047e:	55                   	push   %ebp
  10047f:	89 e5                	mov    %esp,%ebp
  100481:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10048b:	eb 09                	jmp    100496 <serial_putc+0x18>
        delay();
  10048d:	e8 9e fb ff ff       	call   100030 <delay>

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100492:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100496:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10049c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1004a0:	89 c2                	mov    %eax,%edx
  1004a2:	ec                   	in     (%dx),%al
  1004a3:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1004a6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1004aa:	0f b6 c0             	movzbl %al,%eax
  1004ad:	83 e0 20             	and    $0x20,%eax
  1004b0:	85 c0                	test   %eax,%eax
  1004b2:	75 09                	jne    1004bd <serial_putc+0x3f>
  1004b4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1004bb:	7e d0                	jle    10048d <serial_putc+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c0:	0f b6 c0             	movzbl %al,%eax
  1004c3:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1004c9:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1004cc:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1004d0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1004d4:	ee                   	out    %al,(%dx)
}
  1004d5:	90                   	nop
  1004d6:	c9                   	leave  
  1004d7:	c3                   	ret    

001004d8 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1004d8:	55                   	push   %ebp
  1004d9:	89 e5                	mov    %esp,%ebp
    cga_init();
  1004db:	e8 99 fb ff ff       	call   100079 <cga_init>
    serial_init();
  1004e0:	e8 7b fc ff ff       	call   100160 <serial_init>
    if (!serial_exists) {
//        cprintf("serial port does not exist!!\n");
    }
}
  1004e5:	90                   	nop
  1004e6:	5d                   	pop    %ebp
  1004e7:	c3                   	ret    

001004e8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1004e8:	55                   	push   %ebp
  1004e9:	89 e5                	mov    %esp,%ebp
  1004eb:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1004ee:	ff 75 08             	pushl  0x8(%ebp)
  1004f1:	e8 39 fd ff ff       	call   10022f <lpt_putc>
  1004f6:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1004f9:	83 ec 0c             	sub    $0xc,%esp
  1004fc:	ff 75 08             	pushl  0x8(%ebp)
  1004ff:	e8 a5 fd ff ff       	call   1002a9 <cga_putc>
  100504:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  100507:	83 ec 0c             	sub    $0xc,%esp
  10050a:	ff 75 08             	pushl  0x8(%ebp)
  10050d:	e8 6c ff ff ff       	call   10047e <serial_putc>
  100512:	83 c4 10             	add    $0x10,%esp
}
  100515:	90                   	nop
  100516:	c9                   	leave  
  100517:	c3                   	ret    

00100518 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  100518:	55                   	push   %ebp
  100519:	89 e5                	mov    %esp,%ebp
  10051b:	83 ec 14             	sub    $0x14,%esp
  10051e:	8b 45 08             	mov    0x8(%ebp),%eax
  100521:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  100525:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100529:	66 a3 00 10 10 00    	mov    %ax,0x101000
    if (did_init) {
  10052f:	a1 2c 10 10 00       	mov    0x10102c,%eax
  100534:	85 c0                	test   %eax,%eax
  100536:	74 36                	je     10056e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  100538:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10053c:	0f b6 c0             	movzbl %al,%eax
  10053f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100545:	88 45 fa             	mov    %al,-0x6(%ebp)
  100548:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10054c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100550:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  100551:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100555:	66 c1 e8 08          	shr    $0x8,%ax
  100559:	0f b6 c0             	movzbl %al,%eax
  10055c:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100562:	88 45 fb             	mov    %al,-0x5(%ebp)
  100565:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100569:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10056d:	ee                   	out    %al,(%dx)
    }
}
  10056e:	90                   	nop
  10056f:	c9                   	leave  
  100570:	c3                   	ret    

00100571 <pic_enable>:

void
pic_enable(unsigned int irq) {
  100571:	55                   	push   %ebp
  100572:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  100574:	8b 45 08             	mov    0x8(%ebp),%eax
  100577:	ba 01 00 00 00       	mov    $0x1,%edx
  10057c:	89 c1                	mov    %eax,%ecx
  10057e:	d3 e2                	shl    %cl,%edx
  100580:	89 d0                	mov    %edx,%eax
  100582:	f7 d0                	not    %eax
  100584:	89 c2                	mov    %eax,%edx
  100586:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  10058d:	21 d0                	and    %edx,%eax
  10058f:	0f b7 c0             	movzwl %ax,%eax
  100592:	50                   	push   %eax
  100593:	e8 80 ff ff ff       	call   100518 <pic_setmask>
  100598:	83 c4 04             	add    $0x4,%esp
}
  10059b:	90                   	nop
  10059c:	c9                   	leave  
  10059d:	c3                   	ret    

0010059e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10059e:	55                   	push   %ebp
  10059f:	89 e5                	mov    %esp,%ebp
  1005a1:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1005a4:	c7 05 2c 10 10 00 01 	movl   $0x1,0x10102c
  1005ab:	00 00 00 
  1005ae:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1005b4:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1005b8:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1005bc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1005c0:	ee                   	out    %al,(%dx)
  1005c1:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1005c7:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1005cb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1005cf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1005d3:	ee                   	out    %al,(%dx)
  1005d4:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1005da:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1005de:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1005e2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1005e6:	ee                   	out    %al,(%dx)
  1005e7:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1005ed:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1005f1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1005f5:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1005f9:	ee                   	out    %al,(%dx)
  1005fa:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100600:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100604:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100608:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10060c:	ee                   	out    %al,(%dx)
  10060d:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100613:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  100617:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10061b:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10061f:	ee                   	out    %al,(%dx)
  100620:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  100626:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10062a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10062e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100632:	ee                   	out    %al,(%dx)
  100633:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  100639:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10063d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100641:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100645:	ee                   	out    %al,(%dx)
  100646:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10064c:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100650:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100654:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100658:	ee                   	out    %al,(%dx)
  100659:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10065f:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  100663:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100667:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10066b:	ee                   	out    %al,(%dx)
  10066c:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  100672:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  100676:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10067a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10067e:	ee                   	out    %al,(%dx)
  10067f:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  100685:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  100689:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10068d:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  100691:	ee                   	out    %al,(%dx)
  100692:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  100698:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10069c:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1006a0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1006a4:	ee                   	out    %al,(%dx)
  1006a5:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1006ab:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1006af:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1006b3:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1006b7:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1006b8:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  1006bf:	66 83 f8 ff          	cmp    $0xffff,%ax
  1006c3:	74 13                	je     1006d8 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1006c5:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  1006cc:	0f b7 c0             	movzwl %ax,%eax
  1006cf:	50                   	push   %eax
  1006d0:	e8 43 fe ff ff       	call   100518 <pic_setmask>
  1006d5:	83 c4 04             	add    $0x4,%esp
    }
}
  1006d8:	90                   	nop
  1006d9:	c9                   	leave  
  1006da:	c3                   	ret    

001006db <print>:

/*
 * 打印
 * */
void
print(const char *msg) {
  1006db:	55                   	push   %ebp
  1006dc:	89 e5                	mov    %esp,%ebp
  1006de:	83 ec 18             	sub    $0x18,%esp
	const char *s = msg;
  1006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  1006e7:	eb 19                	jmp    100702 <print+0x27>
		cons_putc(*s);
  1006e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ec:	0f b6 00             	movzbl (%eax),%eax
  1006ef:	0f be c0             	movsbl %al,%eax
  1006f2:	83 ec 0c             	sub    $0xc,%esp
  1006f5:	50                   	push   %eax
  1006f6:	e8 ed fd ff ff       	call   1004e8 <cons_putc>
  1006fb:	83 c4 10             	add    $0x10,%esp
		s++;
  1006fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 * 打印
 * */
void
print(const char *msg) {
	const char *s = msg;
	while (*s != '\0') {
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	0f b6 00             	movzbl (%eax),%eax
  100708:	84 c0                	test   %al,%al
  10070a:	75 dd                	jne    1006e9 <print+0xe>
		cons_putc(*s);
		s++;
	}
}
  10070c:	90                   	nop
  10070d:	c9                   	leave  
  10070e:	c3                   	ret    

0010070f <do_fork>:
 * ret == 0 // child
 * ret >0  // parent
 * ret < 0 // error
 * */
int
do_fork() {
  10070f:	55                   	push   %ebp
  100710:	89 e5                	mov    %esp,%ebp
	return 0;
  100712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100717:	5d                   	pop    %ebp
  100718:	c3                   	ret    

00100719 <alloc_proc>:

//
struct proc_struct *
alloc_proc(){
  100719:	55                   	push   %ebp
  10071a:	89 e5                	mov    %esp,%ebp
  10071c:	83 ec 18             	sub    $0x18,%esp
	int n = sizeof(struct proc_struct);
  10071f:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	struct proc_struct *p = (struct proc_struct *)alloc(n);
  100726:	83 ec 0c             	sub    $0xc,%esp
  100729:	ff 75 f4             	pushl  -0xc(%ebp)
  10072c:	e8 69 00 00 00       	call   10079a <alloc>
  100731:	83 c4 10             	add    $0x10,%esp
  100734:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (p != NULL) {
  100737:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10073b:	74 13                	je     100750 <alloc_proc+0x37>
		p->state = EnumProcUnint;
  10073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		p->pid = -1;
  100746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100749:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	}
//	p->cr3 = boot_cr3;
	return p;
  100750:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100753:	c9                   	leave  
  100754:	c3                   	ret    

00100755 <proc_init>:


//
void
proc_init(void) {
  100755:	55                   	push   %ebp
  100756:	89 e5                	mov    %esp,%ebp
  100758:	83 ec 08             	sub    $0x8,%esp
	idleproc = alloc_proc();
  10075b:	e8 b9 ff ff ff       	call   100719 <alloc_proc>
  100760:	a3 30 10 10 00       	mov    %eax,0x101030
	if (idleproc != NULL) {
  100765:	a1 30 10 10 00       	mov    0x101030,%eax
  10076a:	85 c0                	test   %eax,%eax
  10076c:	74 19                	je     100787 <proc_init+0x32>
		idleproc->pid = 0;
  10076e:	a1 30 10 10 00       	mov    0x101030,%eax
  100773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		idleproc->state = EnumProcRunnable;
  10077a:	a1 30 10 10 00       	mov    0x101030,%eax
  10077f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	} else {
		print("cannot alloc idleproc.\n");
	}
}
  100785:	eb 10                	jmp    100797 <proc_init+0x42>
	idleproc = alloc_proc();
	if (idleproc != NULL) {
		idleproc->pid = 0;
		idleproc->state = EnumProcRunnable;
	} else {
		print("cannot alloc idleproc.\n");
  100787:	83 ec 0c             	sub    $0xc,%esp
  10078a:	68 bb 08 10 00       	push   $0x1008bb
  10078f:	e8 47 ff ff ff       	call   1006db <print>
  100794:	83 c4 10             	add    $0x10,%esp
	}
}
  100797:	90                   	nop
  100798:	c9                   	leave  
  100799:	c3                   	ret    

0010079a <alloc>:
static char *allocp = allocbuf;    /*next free position*/

/*
 * */
char
*alloc(int n) {
  10079a:	55                   	push   %ebp
  10079b:	89 e5                	mov    %esp,%ebp
  10079d:	83 ec 10             	sub    $0x10,%esp
	int size = allocbuf+AllocSize - allocp;
  1007a0:	b8 50 37 10 00       	mov    $0x103750,%eax
  1007a5:	89 c2                	mov    %eax,%edx
  1007a7:	a1 04 10 10 00       	mov    0x101004,%eax
  1007ac:	29 c2                	sub    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(size >= n) {
  1007b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1007b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  1007b9:	7c 17                	jl     1007d2 <alloc+0x38>
		allocp += n;
  1007bb:	8b 15 04 10 10 00    	mov    0x101004,%edx
  1007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c4:	01 d0                	add    %edx,%eax
  1007c6:	a3 04 10 10 00       	mov    %eax,0x101004
//		return alloc - n;
		return allocp;
  1007cb:	a1 04 10 10 00       	mov    0x101004,%eax
  1007d0:	eb 05                	jmp    1007d7 <alloc+0x3d>
	} else {
		return NULL;
  1007d2:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  1007d7:	c9                   	leave  
  1007d8:	c3                   	ret    

001007d9 <afree>:

/*
 * */
void
afree(char *p) {
  1007d9:	55                   	push   %ebp
  1007da:	89 e5                	mov    %esp,%ebp
    if (p >= allocbuf && p<allocbuf + AllocSize) {
  1007dc:	81 7d 08 40 10 10 00 	cmpl   $0x101040,0x8(%ebp)
  1007e3:	72 12                	jb     1007f7 <afree+0x1e>
  1007e5:	b8 50 37 10 00       	mov    $0x103750,%eax
  1007ea:	39 45 08             	cmp    %eax,0x8(%ebp)
  1007ed:	73 08                	jae    1007f7 <afree+0x1e>
    	 allocp = p;
  1007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f2:	a3 04 10 10 00       	mov    %eax,0x101004
    }
}
  1007f7:	90                   	nop
  1007f8:	5d                   	pop    %ebp
  1007f9:	c3                   	ret    

001007fa <pmm_init>:


//
void
pmm_init() {
  1007fa:	55                   	push   %ebp
  1007fb:	89 e5                	mov    %esp,%ebp

}
  1007fd:	90                   	nop
  1007fe:	5d                   	pop    %ebp
  1007ff:	c3                   	ret    

00100800 <memmove>:
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  100800:	55                   	push   %ebp
  100801:	89 e5                	mov    %esp,%ebp
  100803:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  10080c:	8b 45 08             	mov    0x8(%ebp),%eax
  10080f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  100812:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100815:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100818:	73 54                	jae    10086e <memmove+0x6e>
  10081a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10081d:	8b 45 10             	mov    0x10(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100825:	76 47                	jbe    10086e <memmove+0x6e>
        s += n, d += n;
  100827:	8b 45 10             	mov    0x10(%ebp),%eax
  10082a:	01 45 fc             	add    %eax,-0x4(%ebp)
  10082d:	8b 45 10             	mov    0x10(%ebp),%eax
  100830:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  100833:	eb 13                	jmp    100848 <memmove+0x48>
            *-- d = *-- s;
  100835:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100839:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10083d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100840:	0f b6 10             	movzbl (%eax),%edx
  100843:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100846:	88 10                	mov    %dl,(%eax)
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  100848:	8b 45 10             	mov    0x10(%ebp),%eax
  10084b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10084e:	89 55 10             	mov    %edx,0x10(%ebp)
  100851:	85 c0                	test   %eax,%eax
  100853:	75 e0                	jne    100835 <memmove+0x35>
 * */
void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  100855:	eb 24                	jmp    10087b <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  100857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10085a:	8d 50 01             	lea    0x1(%eax),%edx
  10085d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  100860:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100863:	8d 4a 01             	lea    0x1(%edx),%ecx
  100866:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  100869:	0f b6 12             	movzbl (%edx),%edx
  10086c:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  10086e:	8b 45 10             	mov    0x10(%ebp),%eax
  100871:	8d 50 ff             	lea    -0x1(%eax),%edx
  100874:	89 55 10             	mov    %edx,0x10(%ebp)
  100877:	85 c0                	test   %eax,%eax
  100879:	75 dc                	jne    100857 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  10087b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10087e:	c9                   	leave  
  10087f:	c3                   	ret    

00100880 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  100880:	55                   	push   %ebp
  100881:	89 e5                	mov    %esp,%ebp
  100883:	83 ec 14             	sub    $0x14,%esp
  100886:	8b 45 0c             	mov    0xc(%ebp),%eax
  100889:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  10088c:	8b 45 08             	mov    0x8(%ebp),%eax
  10088f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  100892:	eb 0f                	jmp    1008a3 <memset+0x23>
		*p ++ = c;
  100894:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100897:	8d 50 01             	lea    0x1(%eax),%edx
  10089a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  10089d:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  1008a1:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  1008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1008a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  1008ac:	85 c0                	test   %eax,%eax
  1008ae:	75 e4                	jne    100894 <memset+0x14>
		*p ++ = c;
	}
	return s;
  1008b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1008b3:	c9                   	leave  
  1008b4:	c3                   	ret    
