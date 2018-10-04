
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <threadFunc>:
#include <stdio.h>
#include <proc.h>
#include <defs.h>

void
threadFunc(void *arg) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 08             	sub    $0x8,%esp
	print("thread function\n");
  100006:	83 ec 0c             	sub    $0xc,%esp
  100009:	68 ab 0a 10 00       	push   $0x100aab
  10000e:	e8 fc 06 00 00       	call   10070f <print>
  100013:	83 c4 10             	add    $0x10,%esp
}
  100016:	90                   	nop
  100017:	c9                   	leave  
  100018:	c3                   	ret    

00100019 <kern_init>:


int
kern_init(void) {
  100019:	55                   	push   %ebp
  10001a:	89 e5                	mov    %esp,%ebp
  10001c:	83 ec 18             	sub    $0x18,%esp
	int a = 1;
  10001f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cons_init();
  100026:	e8 e1 04 00 00       	call   10050c <cons_init>
	proc_init();
  10002b:	e8 eb 08 00 00       	call   10091b <proc_init>

	print("main function");
  100030:	83 ec 0c             	sub    $0xc,%esp
  100033:	68 bc 0a 10 00       	push   $0x100abc
  100038:	e8 d2 06 00 00       	call   10070f <print>
  10003d:	83 c4 10             	add    $0x10,%esp

//	struct proc_struct *p = alloc_proc();
	proc_init();
  100040:	e8 d6 08 00 00       	call   10091b <proc_init>
	thread_start("other", 2, threadFunc, NULL);
  100045:	6a 00                	push   $0x0
  100047:	68 00 00 10 00       	push   $0x100000
  10004c:	6a 02                	push   $0x2
  10004e:	68 ca 0a 10 00       	push   $0x100aca
  100053:	e8 4a 08 00 00       	call   1008a2 <thread_start>
  100058:	83 c4 10             	add    $0x10,%esp
//	_beginthread(threadFunc, 0, NULL);

	a = 2;
  10005b:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)

    while (1) {
    	;
    }
  100062:	eb fe                	jmp    100062 <kern_init+0x49>

00100064 <delay>:
#include <x86.h>
#include <string.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100064:	55                   	push   %ebp
  100065:	89 e5                	mov    %esp,%ebp
  100067:	83 ec 10             	sub    $0x10,%esp
  10006a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100070:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100074:	89 c2                	mov    %eax,%edx
  100076:	ec                   	in     (%dx),%al
  100077:	88 45 f4             	mov    %al,-0xc(%ebp)
  10007a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100080:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100084:	89 c2                	mov    %eax,%edx
  100086:	ec                   	in     (%dx),%al
  100087:	88 45 f5             	mov    %al,-0xb(%ebp)
  10008a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100090:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100094:	89 c2                	mov    %eax,%edx
  100096:	ec                   	in     (%dx),%al
  100097:	88 45 f6             	mov    %al,-0xa(%ebp)
  10009a:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  1000a0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1000a4:	89 c2                	mov    %eax,%edx
  1000a6:	ec                   	in     (%dx),%al
  1000a7:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  1000aa:	90                   	nop
  1000ab:	c9                   	leave  
  1000ac:	c3                   	ret    

001000ad <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  1000ad:	55                   	push   %ebp
  1000ae:	89 e5                	mov    %esp,%ebp
  1000b0:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  1000b3:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  1000ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000bd:	0f b7 00             	movzwl (%eax),%eax
  1000c0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1000c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000c7:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1000cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000cf:	0f b7 00             	movzwl (%eax),%eax
  1000d2:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1000d6:	74 12                	je     1000ea <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  1000d8:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1000df:	66 c7 05 26 10 10 00 	movw   $0x3b4,0x101026
  1000e6:	b4 03 
  1000e8:	eb 13                	jmp    1000fd <cga_init+0x50>
    } else {
        *cp = was;
  1000ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1000ed:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1000f1:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  1000f4:	66 c7 05 26 10 10 00 	movw   $0x3d4,0x101026
  1000fb:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  1000fd:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  100104:	0f b7 c0             	movzwl %ax,%eax
  100107:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  10010b:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10010f:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100113:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100117:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100118:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  10011f:	83 c0 01             	add    $0x1,%eax
  100122:	0f b7 c0             	movzwl %ax,%eax
  100125:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100129:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10012d:	89 c2                	mov    %eax,%edx
  10012f:	ec                   	in     (%dx),%al
  100130:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100133:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100137:	0f b6 c0             	movzbl %al,%eax
  10013a:	c1 e0 08             	shl    $0x8,%eax
  10013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100140:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  100147:	0f b7 c0             	movzwl %ax,%eax
  10014a:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  10014e:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100152:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100156:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10015a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  10015b:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  100162:	83 c0 01             	add    $0x1,%eax
  100165:	0f b7 c0             	movzwl %ax,%eax
  100168:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10016c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100170:	89 c2                	mov    %eax,%edx
  100172:	ec                   	in     (%dx),%al
  100173:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100176:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10017a:	0f b6 c0             	movzbl %al,%eax
  10017d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100183:	a3 20 10 10 00       	mov    %eax,0x101020
    crt_pos = pos;
  100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10018b:	66 a3 24 10 10 00    	mov    %ax,0x101024
}
  100191:	90                   	nop
  100192:	c9                   	leave  
  100193:	c3                   	ret    

00100194 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100194:	55                   	push   %ebp
  100195:	89 e5                	mov    %esp,%ebp
  100197:	83 ec 20             	sub    $0x20,%esp
  10019a:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  1001a0:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1001a4:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1001a8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1001ac:	ee                   	out    %al,(%dx)
  1001ad:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  1001b3:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  1001b7:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1001bb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1001bf:	ee                   	out    %al,(%dx)
  1001c0:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1001c6:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  1001ca:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  1001ce:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1001d2:	ee                   	out    %al,(%dx)
  1001d3:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  1001d9:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1001dd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1001e1:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1001e5:	ee                   	out    %al,(%dx)
  1001e6:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  1001ec:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  1001f0:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  1001f4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1001f8:	ee                   	out    %al,(%dx)
  1001f9:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  1001ff:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  100203:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100207:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10020b:	ee                   	out    %al,(%dx)
  10020c:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  100212:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  100216:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10021a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10021e:	ee                   	out    %al,(%dx)
  10021f:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100225:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100229:	89 c2                	mov    %eax,%edx
  10022b:	ec                   	in     (%dx),%al
  10022c:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  10022f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100233:	3c ff                	cmp    $0xff,%al
  100235:	0f 95 c0             	setne  %al
  100238:	0f b6 c0             	movzbl %al,%eax
  10023b:	a3 28 10 10 00       	mov    %eax,0x101028
  100240:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100246:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10024a:	89 c2                	mov    %eax,%edx
  10024c:	ec                   	in     (%dx),%al
  10024d:	88 45 ea             	mov    %al,-0x16(%ebp)
  100250:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  100256:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10025a:	89 c2                	mov    %eax,%edx
  10025c:	ec                   	in     (%dx),%al
  10025d:	88 45 eb             	mov    %al,-0x15(%ebp)

    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);
}
  100260:	90                   	nop
  100261:	c9                   	leave  
  100262:	c3                   	ret    

00100263 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100263:	55                   	push   %ebp
  100264:	89 e5                	mov    %esp,%ebp
  100266:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100270:	eb 09                	jmp    10027b <lpt_putc+0x18>
        delay();
  100272:	e8 ed fd ff ff       	call   100064 <delay>

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100277:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10027b:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100281:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100285:	89 c2                	mov    %eax,%edx
  100287:	ec                   	in     (%dx),%al
  100288:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10028b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10028f:	84 c0                	test   %al,%al
  100291:	78 09                	js     10029c <lpt_putc+0x39>
  100293:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10029a:	7e d6                	jle    100272 <lpt_putc+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10029c:	8b 45 08             	mov    0x8(%ebp),%eax
  10029f:	0f b6 c0             	movzbl %al,%eax
  1002a2:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  1002a8:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1002ab:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  1002af:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1002b3:	ee                   	out    %al,(%dx)
  1002b4:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1002ba:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1002be:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1002c2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1002c6:	ee                   	out    %al,(%dx)
  1002c7:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  1002cd:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  1002d1:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  1002d5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1002d9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1002da:	90                   	nop
  1002db:	c9                   	leave  
  1002dc:	c3                   	ret    

001002dd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1002dd:	55                   	push   %ebp
  1002de:	89 e5                	mov    %esp,%ebp
  1002e0:	53                   	push   %ebx
  1002e1:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e7:	b0 00                	mov    $0x0,%al
  1002e9:	85 c0                	test   %eax,%eax
  1002eb:	75 07                	jne    1002f4 <cga_putc+0x17>
        c |= 0x0700;
  1002ed:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f7:	0f b6 c0             	movzbl %al,%eax
  1002fa:	83 f8 0a             	cmp    $0xa,%eax
  1002fd:	74 4e                	je     10034d <cga_putc+0x70>
  1002ff:	83 f8 0d             	cmp    $0xd,%eax
  100302:	74 59                	je     10035d <cga_putc+0x80>
  100304:	83 f8 08             	cmp    $0x8,%eax
  100307:	0f 85 8a 00 00 00    	jne    100397 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  10030d:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100314:	66 85 c0             	test   %ax,%ax
  100317:	0f 84 a0 00 00 00    	je     1003bd <cga_putc+0xe0>
            crt_pos --;
  10031d:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100324:	83 e8 01             	sub    $0x1,%eax
  100327:	66 a3 24 10 10 00    	mov    %ax,0x101024
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10032d:	a1 20 10 10 00       	mov    0x101020,%eax
  100332:	0f b7 15 24 10 10 00 	movzwl 0x101024,%edx
  100339:	0f b7 d2             	movzwl %dx,%edx
  10033c:	01 d2                	add    %edx,%edx
  10033e:	01 d0                	add    %edx,%eax
  100340:	8b 55 08             	mov    0x8(%ebp),%edx
  100343:	b2 00                	mov    $0x0,%dl
  100345:	83 ca 20             	or     $0x20,%edx
  100348:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10034b:	eb 70                	jmp    1003bd <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  10034d:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100354:	83 c0 50             	add    $0x50,%eax
  100357:	66 a3 24 10 10 00    	mov    %ax,0x101024
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10035d:	0f b7 1d 24 10 10 00 	movzwl 0x101024,%ebx
  100364:	0f b7 0d 24 10 10 00 	movzwl 0x101024,%ecx
  10036b:	0f b7 c1             	movzwl %cx,%eax
  10036e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100374:	c1 e8 10             	shr    $0x10,%eax
  100377:	89 c2                	mov    %eax,%edx
  100379:	66 c1 ea 06          	shr    $0x6,%dx
  10037d:	89 d0                	mov    %edx,%eax
  10037f:	c1 e0 02             	shl    $0x2,%eax
  100382:	01 d0                	add    %edx,%eax
  100384:	c1 e0 04             	shl    $0x4,%eax
  100387:	29 c1                	sub    %eax,%ecx
  100389:	89 ca                	mov    %ecx,%edx
  10038b:	89 d8                	mov    %ebx,%eax
  10038d:	29 d0                	sub    %edx,%eax
  10038f:	66 a3 24 10 10 00    	mov    %ax,0x101024
        break;
  100395:	eb 27                	jmp    1003be <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  100397:	8b 0d 20 10 10 00    	mov    0x101020,%ecx
  10039d:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  1003a4:	8d 50 01             	lea    0x1(%eax),%edx
  1003a7:	66 89 15 24 10 10 00 	mov    %dx,0x101024
  1003ae:	0f b7 c0             	movzwl %ax,%eax
  1003b1:	01 c0                	add    %eax,%eax
  1003b3:	01 c8                	add    %ecx,%eax
  1003b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1003b8:	66 89 10             	mov    %dx,(%eax)
        break;
  1003bb:	eb 01                	jmp    1003be <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1003bd:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1003be:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  1003c5:	66 3d cf 07          	cmp    $0x7cf,%ax
  1003c9:	76 59                	jbe    100424 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1003cb:	a1 20 10 10 00       	mov    0x101020,%eax
  1003d0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1003d6:	a1 20 10 10 00       	mov    0x101020,%eax
  1003db:	83 ec 04             	sub    $0x4,%esp
  1003de:	68 00 0f 00 00       	push   $0xf00
  1003e3:	52                   	push   %edx
  1003e4:	50                   	push   %eax
  1003e5:	e8 dc 05 00 00       	call   1009c6 <memmove>
  1003ea:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1003ed:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1003f4:	eb 15                	jmp    10040b <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1003f6:	a1 20 10 10 00       	mov    0x101020,%eax
  1003fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1003fe:	01 d2                	add    %edx,%edx
  100400:	01 d0                	add    %edx,%eax
  100402:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100407:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10040b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  100412:	7e e2                	jle    1003f6 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  100414:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  10041b:	83 e8 50             	sub    $0x50,%eax
  10041e:	66 a3 24 10 10 00    	mov    %ax,0x101024
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  100424:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  10042b:	0f b7 c0             	movzwl %ax,%eax
  10042e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100432:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  100436:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10043a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10043e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10043f:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  100446:	66 c1 e8 08          	shr    $0x8,%ax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	0f b7 15 26 10 10 00 	movzwl 0x101026,%edx
  100454:	83 c2 01             	add    $0x1,%edx
  100457:	0f b7 d2             	movzwl %dx,%edx
  10045a:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10045e:	88 45 e9             	mov    %al,-0x17(%ebp)
  100461:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100465:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100469:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10046a:	0f b7 05 26 10 10 00 	movzwl 0x101026,%eax
  100471:	0f b7 c0             	movzwl %ax,%eax
  100474:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100478:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10047c:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100480:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100484:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  100485:	0f b7 05 24 10 10 00 	movzwl 0x101024,%eax
  10048c:	0f b6 c0             	movzbl %al,%eax
  10048f:	0f b7 15 26 10 10 00 	movzwl 0x101026,%edx
  100496:	83 c2 01             	add    $0x1,%edx
  100499:	0f b7 d2             	movzwl %dx,%edx
  10049c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  1004a0:	88 45 eb             	mov    %al,-0x15(%ebp)
  1004a3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1004a7:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1004ab:	ee                   	out    %al,(%dx)
}
  1004ac:	90                   	nop
  1004ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004b0:	c9                   	leave  
  1004b1:	c3                   	ret    

001004b2 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1004b2:	55                   	push   %ebp
  1004b3:	89 e5                	mov    %esp,%ebp
  1004b5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1004b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1004bf:	eb 09                	jmp    1004ca <serial_putc+0x18>
        delay();
  1004c1:	e8 9e fb ff ff       	call   100064 <delay>

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1004c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1004ca:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1004d0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1004d4:	89 c2                	mov    %eax,%edx
  1004d6:	ec                   	in     (%dx),%al
  1004d7:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1004da:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1004de:	0f b6 c0             	movzbl %al,%eax
  1004e1:	83 e0 20             	and    $0x20,%eax
  1004e4:	85 c0                	test   %eax,%eax
  1004e6:	75 09                	jne    1004f1 <serial_putc+0x3f>
  1004e8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1004ef:	7e d0                	jle    1004c1 <serial_putc+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f4:	0f b6 c0             	movzbl %al,%eax
  1004f7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1004fd:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100500:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  100504:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100508:	ee                   	out    %al,(%dx)
}
  100509:	90                   	nop
  10050a:	c9                   	leave  
  10050b:	c3                   	ret    

0010050c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10050c:	55                   	push   %ebp
  10050d:	89 e5                	mov    %esp,%ebp
    cga_init();
  10050f:	e8 99 fb ff ff       	call   1000ad <cga_init>
    serial_init();
  100514:	e8 7b fc ff ff       	call   100194 <serial_init>
    if (!serial_exists) {
//        cprintf("serial port does not exist!!\n");
    }
}
  100519:	90                   	nop
  10051a:	5d                   	pop    %ebp
  10051b:	c3                   	ret    

0010051c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10051c:	55                   	push   %ebp
  10051d:	89 e5                	mov    %esp,%ebp
  10051f:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  100522:	ff 75 08             	pushl  0x8(%ebp)
  100525:	e8 39 fd ff ff       	call   100263 <lpt_putc>
  10052a:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10052d:	83 ec 0c             	sub    $0xc,%esp
  100530:	ff 75 08             	pushl  0x8(%ebp)
  100533:	e8 a5 fd ff ff       	call   1002dd <cga_putc>
  100538:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  10053b:	83 ec 0c             	sub    $0xc,%esp
  10053e:	ff 75 08             	pushl  0x8(%ebp)
  100541:	e8 6c ff ff ff       	call   1004b2 <serial_putc>
  100546:	83 c4 10             	add    $0x10,%esp
}
  100549:	90                   	nop
  10054a:	c9                   	leave  
  10054b:	c3                   	ret    

0010054c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10054c:	55                   	push   %ebp
  10054d:	89 e5                	mov    %esp,%ebp
  10054f:	83 ec 14             	sub    $0x14,%esp
  100552:	8b 45 08             	mov    0x8(%ebp),%eax
  100555:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  100559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10055d:	66 a3 00 10 10 00    	mov    %ax,0x101000
    if (did_init) {
  100563:	a1 2c 10 10 00       	mov    0x10102c,%eax
  100568:	85 c0                	test   %eax,%eax
  10056a:	74 36                	je     1005a2 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10056c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100570:	0f b6 c0             	movzbl %al,%eax
  100573:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100579:	88 45 fa             	mov    %al,-0x6(%ebp)
  10057c:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  100580:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100584:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  100585:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100589:	66 c1 e8 08          	shr    $0x8,%ax
  10058d:	0f b6 c0             	movzbl %al,%eax
  100590:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100596:	88 45 fb             	mov    %al,-0x5(%ebp)
  100599:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10059d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1005a1:	ee                   	out    %al,(%dx)
    }
}
  1005a2:	90                   	nop
  1005a3:	c9                   	leave  
  1005a4:	c3                   	ret    

001005a5 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1005a5:	55                   	push   %ebp
  1005a6:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ab:	ba 01 00 00 00       	mov    $0x1,%edx
  1005b0:	89 c1                	mov    %eax,%ecx
  1005b2:	d3 e2                	shl    %cl,%edx
  1005b4:	89 d0                	mov    %edx,%eax
  1005b6:	f7 d0                	not    %eax
  1005b8:	89 c2                	mov    %eax,%edx
  1005ba:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  1005c1:	21 d0                	and    %edx,%eax
  1005c3:	0f b7 c0             	movzwl %ax,%eax
  1005c6:	50                   	push   %eax
  1005c7:	e8 80 ff ff ff       	call   10054c <pic_setmask>
  1005cc:	83 c4 04             	add    $0x4,%esp
}
  1005cf:	90                   	nop
  1005d0:	c9                   	leave  
  1005d1:	c3                   	ret    

001005d2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1005d2:	55                   	push   %ebp
  1005d3:	89 e5                	mov    %esp,%ebp
  1005d5:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1005d8:	c7 05 2c 10 10 00 01 	movl   $0x1,0x10102c
  1005df:	00 00 00 
  1005e2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1005e8:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1005ec:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1005f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1005f4:	ee                   	out    %al,(%dx)
  1005f5:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1005fb:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1005ff:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100603:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100607:	ee                   	out    %al,(%dx)
  100608:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10060e:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  100612:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  100616:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10061a:	ee                   	out    %al,(%dx)
  10061b:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100621:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  100625:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100629:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10062d:	ee                   	out    %al,(%dx)
  10062e:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100634:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100638:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10063c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100640:	ee                   	out    %al,(%dx)
  100641:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100647:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10064b:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10064f:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100653:	ee                   	out    %al,(%dx)
  100654:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10065a:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10065e:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100662:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100666:	ee                   	out    %al,(%dx)
  100667:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10066d:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100671:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100675:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100679:	ee                   	out    %al,(%dx)
  10067a:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100680:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100684:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100688:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10068c:	ee                   	out    %al,(%dx)
  10068d:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100693:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  100697:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10069b:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10069f:	ee                   	out    %al,(%dx)
  1006a0:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1006a6:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1006aa:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1006ae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1006b2:	ee                   	out    %al,(%dx)
  1006b3:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  1006b9:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1006bd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1006c1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1006c5:	ee                   	out    %al,(%dx)
  1006c6:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1006cc:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1006d0:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1006d4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1006d8:	ee                   	out    %al,(%dx)
  1006d9:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1006df:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1006e3:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1006e7:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1006eb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1006ec:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  1006f3:	66 83 f8 ff          	cmp    $0xffff,%ax
  1006f7:	74 13                	je     10070c <pic_init+0x13a>
        pic_setmask(irq_mask);
  1006f9:	0f b7 05 00 10 10 00 	movzwl 0x101000,%eax
  100700:	0f b7 c0             	movzwl %ax,%eax
  100703:	50                   	push   %eax
  100704:	e8 43 fe ff ff       	call   10054c <pic_setmask>
  100709:	83 c4 04             	add    $0x4,%esp
    }
}
  10070c:	90                   	nop
  10070d:	c9                   	leave  
  10070e:	c3                   	ret    

0010070f <print>:

/*
 * 打印
 * */
void
print(const char *msg) {
  10070f:	55                   	push   %ebp
  100710:	89 e5                	mov    %esp,%ebp
  100712:	83 ec 18             	sub    $0x18,%esp
	const char *s = msg;
  100715:	8b 45 08             	mov    0x8(%ebp),%eax
  100718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  10071b:	eb 19                	jmp    100736 <print+0x27>
		cons_putc(*s);
  10071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100720:	0f b6 00             	movzbl (%eax),%eax
  100723:	0f be c0             	movsbl %al,%eax
  100726:	83 ec 0c             	sub    $0xc,%esp
  100729:	50                   	push   %eax
  10072a:	e8 ed fd ff ff       	call   10051c <cons_putc>
  10072f:	83 c4 10             	add    $0x10,%esp
		s++;
  100732:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 * 打印
 * */
void
print(const char *msg) {
	const char *s = msg;
	while (*s != '\0') {
  100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100739:	0f b6 00             	movzbl (%eax),%eax
  10073c:	84 c0                	test   %al,%al
  10073e:	75 dd                	jne    10071d <print+0xe>
		cons_putc(*s);
		s++;
	}
}
  100740:	90                   	nop
  100741:	c9                   	leave  
  100742:	c3                   	ret    

00100743 <switch_to>:
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    # 保存了进程在返回switch_to函数后的指令地址到context.eip中
    movl 4(%esp), %eax          # eax points to from
  100743:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
  100747:	8f 00                	popl   (%eax)

    # 保存前一个进程的其他7个寄存器到context中的相应域中
    movl %esp, 4(%eax)
  100749:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
  10074c:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
  10074f:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
  100752:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
  100755:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
  100758:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
  10075b:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    # context的高地址的域ebp开始，逐一把相关域的值赋值给对应的寄存器
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
  10075e:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
  100762:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
  100765:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
  100768:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
  10076b:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
  10076e:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
  100771:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
  100774:	8b 60 04             	mov    0x4(%eax),%esp

	# 把context中保存的下一个进程要执行的指令地址context.eip放到了堆栈顶
    pushl 0(%eax)               # push eip
  100777:	ff 30                	pushl  (%eax)

	# 最后一条指令“ret”时，会把栈顶的内容赋值给EIP寄存器，这样就切换到下一个进程执行了
    ret
  100779:	c3                   	ret    

0010077a <do_fork>:
 * ret == 0 // child
 * ret >0  // parent
 * ret < 0 // error
 * */
int
do_fork() {
  10077a:	55                   	push   %ebp
  10077b:	89 e5                	mov    %esp,%ebp
	return 0;
  10077d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100782:	5d                   	pop    %ebp
  100783:	c3                   	ret    

00100784 <alloc_proc>:

//
struct proc_struct *
alloc_proc(){
  100784:	55                   	push   %ebp
  100785:	89 e5                	mov    %esp,%ebp
  100787:	83 ec 18             	sub    $0x18,%esp
	int n = sizeof(struct proc_struct);
  10078a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	struct proc_struct *p = (struct proc_struct *)alloc(n);
  100791:	83 ec 0c             	sub    $0xc,%esp
  100794:	ff 75 f4             	pushl  -0xc(%ebp)
  100797:	e8 c4 01 00 00       	call   100960 <alloc>
  10079c:	83 c4 10             	add    $0x10,%esp
  10079f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (p != NULL) {
  1007a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1007a6:	74 13                	je     1007bb <alloc_proc+0x37>
		p->state = EnumProcUnint;
  1007a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1007ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		p->pid = -1;
  1007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1007b4:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	}
//	p->cr3 = boot_cr3;
	return p;
  1007bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1007be:	c9                   	leave  
  1007bf:	c3                   	ret    

001007c0 <alloc_thread>:


task_struct *
alloc_thread(){
  1007c0:	55                   	push   %ebp
  1007c1:	89 e5                	mov    %esp,%ebp
  1007c3:	83 ec 18             	sub    $0x18,%esp
	int n = sizeof(task_struct) ;  // PG_SIZE
  1007c6:	c7 45 f4 60 00 00 00 	movl   $0x60,-0xc(%ebp)
	task_struct *p = (task_struct *)alloc(n);
  1007cd:	83 ec 0c             	sub    $0xc,%esp
  1007d0:	ff 75 f4             	pushl  -0xc(%ebp)
  1007d3:	e8 88 01 00 00       	call   100960 <alloc>
  1007d8:	83 c4 10             	add    $0x10,%esp
  1007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (p != NULL) {
  1007de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1007e2:	74 0a                	je     1007ee <alloc_thread+0x2e>
		p->status = EnumProcUnint;
  1007e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1007e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	}
//	p->cr3 = boot_cr3;
	return p;
  1007ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1007f1:	c9                   	leave  
  1007f2:	c3                   	ret    

001007f3 <init_thread>:
//	return 0;
//}

// 初始化线程基本信息
void
init_thread(task_struct* pthread, char* name, int prio) {
  1007f3:	55                   	push   %ebp
  1007f4:	89 e5                	mov    %esp,%ebp
  1007f6:	83 ec 08             	sub    $0x8,%esp
	memset(pthread, 0, sizeof(*pthread));
  1007f9:	83 ec 04             	sub    $0x4,%esp
  1007fc:	6a 60                	push   $0x60
  1007fe:	6a 00                	push   $0x0
  100800:	ff 75 08             	pushl  0x8(%ebp)
  100803:	e8 3e 02 00 00       	call   100a46 <memset>
  100808:	83 c4 10             	add    $0x10,%esp
//	memset(&(proc->context), 0, sizeof(struct context));
	strcpy(pthread->name, name);
  10080b:	8b 45 08             	mov    0x8(%ebp),%eax
  10080e:	83 c0 08             	add    $0x8,%eax
  100811:	83 ec 08             	sub    $0x8,%esp
  100814:	ff 75 0c             	pushl  0xc(%ebp)
  100817:	50                   	push   %eax
  100818:	e8 5e 02 00 00       	call   100a7b <strcpy>
  10081d:	83 c4 10             	add    $0x10,%esp
//	if (pthread->name == main_thread) {
//		pthread->status = EnumProcRunning;
//	} else {
//		pthread->status = EnumProcReady;
//	}
	pthread->status = EnumProcReady;
  100820:	8b 45 08             	mov    0x8(%ebp),%eax
  100823:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)

	pthread->priority = prio;
  10082a:	8b 45 10             	mov    0x10(%ebp),%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	8b 45 08             	mov    0x8(%ebp),%eax
  100832:	88 50 18             	mov    %dl,0x18(%eax)
	pthread->ticks = prio;
  100835:	8b 45 10             	mov    0x10(%ebp),%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 08             	mov    0x8(%ebp),%eax
  10083d:	88 50 19             	mov    %dl,0x19(%eax)
	pthread->elapsed_ticks = 0;
  100840:	8b 45 08             	mov    0x8(%ebp),%eax
  100843:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	// self_kstack是线程自己在内核态下使用的栈顶地址
	pthread->self_kstack = (uint32_t*)((uint32_t)pthread + PG_SIZE);;
  10084a:	8b 45 08             	mov    0x8(%ebp),%eax
  10084d:	05 00 04 00 00       	add    $0x400,%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	8b 45 08             	mov    0x8(%ebp),%eax
  100857:	89 10                	mov    %edx,(%eax)
	pthread->stack_magic = 0x19971234;     // 自定义的魔数，检查栈溢出
  100859:	8b 45 08             	mov    0x8(%ebp),%eax
  10085c:	c7 40 5c 34 12 97 19 	movl   $0x19971234,0x5c(%eax)
}
  100863:	90                   	nop
  100864:	c9                   	leave  
  100865:	c3                   	ret    

00100866 <kernel_thread>:

static void
kernel_thread(thread_func function, void *func_arg)
{
  100866:	55                   	push   %ebp
  100867:	89 e5                	mov    %esp,%ebp
  100869:	83 ec 08             	sub    $0x8,%esp
//	function(func_arg);
	print("aaaaaaa");
  10086c:	83 ec 0c             	sub    $0xc,%esp
  10086f:	68 d0 0a 10 00       	push   $0x100ad0
  100874:	e8 96 fe ff ff       	call   10070f <print>
  100879:	83 c4 10             	add    $0x10,%esp
}
  10087c:	90                   	nop
  10087d:	c9                   	leave  
  10087e:	c3                   	ret    

0010087f <thread_create>:

// 创建线程
void
thread_create(task_struct* pthread, thread_func function, void* func_arg) {
  10087f:	55                   	push   %ebp
  100880:	89 e5                	mov    %esp,%ebp
//	pthread->self_kstack -= sizeof(intr_stack);

	// 留出线程栈空间
//	pthread->self_kstack -= sizeof(thread_stack);

	pthread->function = function;
  100882:	8b 45 08             	mov    0x8(%ebp),%eax
  100885:	8b 55 0c             	mov    0xc(%ebp),%edx
  100888:	89 50 54             	mov    %edx,0x54(%eax)
	pthread->func_arg = func_arg;
  10088b:	8b 45 08             	mov    0x8(%ebp),%eax
  10088e:	8b 55 10             	mov    0x10(%ebp),%edx
  100891:	89 50 58             	mov    %edx,0x58(%eax)

	pthread->context.eip = &kernel_thread;
  100894:	ba 66 08 10 00       	mov    $0x100866,%edx
  100899:	8b 45 08             	mov    0x8(%ebp),%eax
  10089c:	89 50 30             	mov    %edx,0x30(%eax)
//	thread_stack* kthread_stack = (thread_stack*)pthread->self_kstack;
//	kthread_stack->eip = kernel_thread;
//	kthread_stack->thread_func = function;
//	kthread_stack->func_arg = func_arg;
//	kthread_stack->ebp = kthread_stack->ebx = kthread_stack->esi = kthread_stack->edi = 0;
}
  10089f:	90                   	nop
  1008a0:	5d                   	pop    %ebp
  1008a1:	c3                   	ret    

001008a2 <thread_start>:

// 创建一优先级为prio的线程,线程名为name,线程所执行的函数是function(func_arg)
task_struct*
thread_start(char* name, int prio, thread_func function, void*  func_arg) {
  1008a2:	55                   	push   %ebp
  1008a3:	89 e5                	mov    %esp,%ebp
  1008a5:	83 ec 18             	sub    $0x18,%esp
	// pcb都位于内核空间,包括用户进程的pcb也是在内核空间
//	task_struct* thread = get_kernel_pages(1);
	task_struct* thread = alloc_thread();
  1008a8:	e8 13 ff ff ff       	call   1007c0 <alloc_thread>
  1008ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (thread == NULL) {
  1008b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1008b4:	75 17                	jne    1008cd <thread_start+0x2b>
		print("error thread_start\n");
  1008b6:	83 ec 0c             	sub    $0xc,%esp
  1008b9:	68 d8 0a 10 00       	push   $0x100ad8
  1008be:	e8 4c fe ff ff       	call   10070f <print>
  1008c3:	83 c4 10             	add    $0x10,%esp
		return NULL;
  1008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  1008cb:	eb 46                	jmp    100913 <thread_start+0x71>
	}

	init_thread(thread, name, prio);
  1008cd:	83 ec 04             	sub    $0x4,%esp
  1008d0:	ff 75 0c             	pushl  0xc(%ebp)
  1008d3:	ff 75 08             	pushl  0x8(%ebp)
  1008d6:	ff 75 f4             	pushl  -0xc(%ebp)
  1008d9:	e8 15 ff ff ff       	call   1007f3 <init_thread>
  1008de:	83 c4 10             	add    $0x10,%esp
	thread_create(thread, function, func_arg);
  1008e1:	83 ec 04             	sub    $0x4,%esp
  1008e4:	ff 75 14             	pushl  0x14(%ebp)
  1008e7:	ff 75 10             	pushl  0x10(%ebp)
  1008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  1008ed:	e8 8d ff ff ff       	call   10087f <thread_create>
  1008f2:	83 c4 10             	add    $0x10,%esp
	 * 准备好数据之后执行ret，此时会从栈顶会得到返回地址，该地址也就是上面赋值的eip，也就是kernelthread的地址，然后执行该函数，
	 * kernel_thread从栈中得到参数，也就是栈顶+4的真正要执行的线程函数地址，和栈顶+8的线程函数所需的参数。
	 * */
//	asm volatile ("movl %0, %%esp; pop %%ebp; pop %%ebx; pop %%edi; pop %%esi; ret"  : : "g" (thread->self_kstack) : "memory");

	switch_to(&(current->context), &(thread->context));
  1008f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f8:	8d 50 30             	lea    0x30(%eax),%edx
  1008fb:	a1 30 10 10 00       	mov    0x101030,%eax
  100900:	83 c0 30             	add    $0x30,%eax
  100903:	83 ec 08             	sub    $0x8,%esp
  100906:	52                   	push   %edx
  100907:	50                   	push   %eax
  100908:	e8 36 fe ff ff       	call   100743 <switch_to>
  10090d:	83 c4 10             	add    $0x10,%esp
	return thread;
  100910:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100913:	c9                   	leave  
  100914:	c3                   	ret    

00100915 <running_thread>:

// 执行线程
task_struct *
running_thread() {
  100915:	55                   	push   %ebp
  100916:	89 e5                	mov    %esp,%ebp

}
  100918:	90                   	nop
  100919:	5d                   	pop    %ebp
  10091a:	c3                   	ret    

0010091b <proc_init>:

//
void
proc_init(void) {
  10091b:	55                   	push   %ebp
  10091c:	89 e5                	mov    %esp,%ebp
  10091e:	83 ec 08             	sub    $0x8,%esp
//	idleproc = alloc_proc();
//	if (idleproc == NULL) {
//		print("cannot alloc idleproc.\n");
//		return ;
//	}
	current = alloc_thread();
  100921:	e8 9a fe ff ff       	call   1007c0 <alloc_thread>
  100926:	a3 30 10 10 00       	mov    %eax,0x101030
	if (current == NULL) {
  10092b:	a1 30 10 10 00       	mov    0x101030,%eax
  100930:	85 c0                	test   %eax,%eax
  100932:	75 12                	jne    100946 <proc_init+0x2b>
		print("cannot alloc current.\n");
  100934:	83 ec 0c             	sub    $0xc,%esp
  100937:	68 ec 0a 10 00       	push   $0x100aec
  10093c:	e8 ce fd ff ff       	call   10070f <print>
  100941:	83 c4 10             	add    $0x10,%esp
		return ;
  100944:	eb 18                	jmp    10095e <proc_init+0x43>
	}
	init_thread(current, "main", 1);
  100946:	a1 30 10 10 00       	mov    0x101030,%eax
  10094b:	83 ec 04             	sub    $0x4,%esp
  10094e:	6a 01                	push   $0x1
  100950:	68 03 0b 10 00       	push   $0x100b03
  100955:	50                   	push   %eax
  100956:	e8 98 fe ff ff       	call   1007f3 <init_thread>
  10095b:	83 c4 10             	add    $0x10,%esp


//	idleproc->pid = 0;
//	idleproc->state = EnumProcReady;
//	current = idleproc;
}
  10095e:	c9                   	leave  
  10095f:	c3                   	ret    

00100960 <alloc>:
static char *allocp = allocbuf;    /*next free position*/

/*
 * */
char
*alloc(int n) {
  100960:	55                   	push   %ebp
  100961:	89 e5                	mov    %esp,%ebp
  100963:	83 ec 10             	sub    $0x10,%esp
	int size = allocbuf+AllocSize - allocp;
  100966:	b8 50 37 10 00       	mov    $0x103750,%eax
  10096b:	89 c2                	mov    %eax,%edx
  10096d:	a1 04 10 10 00       	mov    0x101004,%eax
  100972:	29 c2                	sub    %eax,%edx
  100974:	89 d0                	mov    %edx,%eax
  100976:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(size >= n) {
  100979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10097c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10097f:	7c 17                	jl     100998 <alloc+0x38>
		allocp += n;
  100981:	8b 15 04 10 10 00    	mov    0x101004,%edx
  100987:	8b 45 08             	mov    0x8(%ebp),%eax
  10098a:	01 d0                	add    %edx,%eax
  10098c:	a3 04 10 10 00       	mov    %eax,0x101004
//		return alloc - n;
		return allocp;
  100991:	a1 04 10 10 00       	mov    0x101004,%eax
  100996:	eb 05                	jmp    10099d <alloc+0x3d>
	} else {
		return NULL;
  100998:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  10099d:	c9                   	leave  
  10099e:	c3                   	ret    

0010099f <afree>:

/*
 * */
void
afree(char *p) {
  10099f:	55                   	push   %ebp
  1009a0:	89 e5                	mov    %esp,%ebp
    if (p >= allocbuf && p<allocbuf + AllocSize) {
  1009a2:	81 7d 08 40 10 10 00 	cmpl   $0x101040,0x8(%ebp)
  1009a9:	72 12                	jb     1009bd <afree+0x1e>
  1009ab:	b8 50 37 10 00       	mov    $0x103750,%eax
  1009b0:	39 45 08             	cmp    %eax,0x8(%ebp)
  1009b3:	73 08                	jae    1009bd <afree+0x1e>
    	 allocp = p;
  1009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1009b8:	a3 04 10 10 00       	mov    %eax,0x101004
    }
}
  1009bd:	90                   	nop
  1009be:	5d                   	pop    %ebp
  1009bf:	c3                   	ret    

001009c0 <pmm_init>:


//
void
pmm_init() {
  1009c0:	55                   	push   %ebp
  1009c1:	89 e5                	mov    %esp,%ebp

}
  1009c3:	90                   	nop
  1009c4:	5d                   	pop    %ebp
  1009c5:	c3                   	ret    

001009c6 <memmove>:
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  1009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  1009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  1009d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1009db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1009de:	73 54                	jae    100a34 <memmove+0x6e>
  1009e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1009e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1009e6:	01 d0                	add    %edx,%eax
  1009e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1009eb:	76 47                	jbe    100a34 <memmove+0x6e>
        s += n, d += n;
  1009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1009f0:	01 45 fc             	add    %eax,-0x4(%ebp)
  1009f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1009f6:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  1009f9:	eb 13                	jmp    100a0e <memmove+0x48>
            *-- d = *-- s;
  1009fb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  1009ff:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a06:	0f b6 10             	movzbl (%eax),%edx
  100a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100a0c:	88 10                	mov    %dl,(%eax)
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  100a11:	8d 50 ff             	lea    -0x1(%eax),%edx
  100a14:	89 55 10             	mov    %edx,0x10(%ebp)
  100a17:	85 c0                	test   %eax,%eax
  100a19:	75 e0                	jne    1009fb <memmove+0x35>
 * */
void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  100a1b:	eb 24                	jmp    100a41 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  100a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100a20:	8d 50 01             	lea    0x1(%eax),%edx
  100a23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  100a26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100a29:	8d 4a 01             	lea    0x1(%edx),%ecx
  100a2c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  100a2f:	0f b6 12             	movzbl (%edx),%edx
  100a32:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  100a34:	8b 45 10             	mov    0x10(%ebp),%eax
  100a37:	8d 50 ff             	lea    -0x1(%eax),%edx
  100a3a:	89 55 10             	mov    %edx,0x10(%ebp)
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	75 dc                	jne    100a1d <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  100a41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100a44:	c9                   	leave  
  100a45:	c3                   	ret    

00100a46 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  100a46:	55                   	push   %ebp
  100a47:	89 e5                	mov    %esp,%ebp
  100a49:	83 ec 14             	sub    $0x14,%esp
  100a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a4f:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  100a52:	8b 45 08             	mov    0x8(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  100a58:	eb 0f                	jmp    100a69 <memset+0x23>
		*p ++ = c;
  100a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a5d:	8d 50 01             	lea    0x1(%eax),%edx
  100a60:	89 55 fc             	mov    %edx,-0x4(%ebp)
  100a63:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  100a67:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  100a69:	8b 45 10             	mov    0x10(%ebp),%eax
  100a6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  100a6f:	89 55 10             	mov    %edx,0x10(%ebp)
  100a72:	85 c0                	test   %eax,%eax
  100a74:	75 e4                	jne    100a5a <memset+0x14>
		*p ++ = c;
	}
	return s;
  100a76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100a79:	c9                   	leave  
  100a7a:	c3                   	ret    

00100a7b <strcpy>:


char *
strcpy(char *dst, const char *src){
  100a7b:	55                   	push   %ebp
  100a7c:	89 e5                	mov    %esp,%ebp
  100a7e:	83 ec 10             	sub    $0x10,%esp
	char *ret = dst;
  100a81:	8b 45 08             	mov    0x8(%ebp),%eax
  100a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++=*src++)!='\0') {
  100a87:	90                   	nop
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  100a94:	8d 4a 01             	lea    0x1(%edx),%ecx
  100a97:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  100a9a:	0f b6 12             	movzbl (%edx),%edx
  100a9d:	88 10                	mov    %dl,(%eax)
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	84 c0                	test   %al,%al
  100aa4:	75 e2                	jne    100a88 <strcpy+0xd>
		;
	}

	return ret;
  100aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa9:	c9                   	leave  
  100aaa:	c3                   	ret    
