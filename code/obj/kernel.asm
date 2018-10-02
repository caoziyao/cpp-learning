
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <init_driver>:
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));


void init_driver() {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 08             	sub    $0x8,%esp
	cons_init();                // init the console, 对串口、键盘和时钟外设的中断初始化
  100006:	e8 f2 08 00 00       	call   1008fd <cons_init>
	pic_init();                 // init interrupt controller, 中断控制器的初始化工作
  10000b:	e8 30 0a 00 00       	call   100a40 <pic_init>
	idt_init();                 // init interrupt descriptor table, 对整个中断门描述符表的创建
  100010:	e8 81 0b 00 00       	call   100b96 <idt_init>
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  100015:	fb                   	sti    

	sti();                      // enable irq interrupt
}
  100016:	90                   	nop
  100017:	c9                   	leave  
  100018:	c3                   	ret    

00100019 <unite_test>:


void unite_test() {
  100019:	55                   	push   %ebp
  10001a:	89 e5                	mov    %esp,%ebp
  10001c:	83 ec 08             	sub    $0x8,%esp
	testmain();
  10001f:	e8 b5 18 00 00       	call   1018d9 <testmain>
}
  100024:	90                   	nop
  100025:	c9                   	leave  
  100026:	c3                   	ret    

00100027 <kern_init>:


int
kern_init(void) {
  100027:	55                   	push   %ebp
  100028:	89 e5                	mov    %esp,%ebp
  10002a:	83 ec 18             	sub    $0x18,%esp
	init_driver();
  10002d:	e8 ce ff ff ff       	call   100000 <init_driver>
	unite_test();
  100032:	e8 e2 ff ff ff       	call   100019 <unite_test>
	int a = 1;
  100037:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	a = a + 3;
  10003e:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
	char *s = "ddss";
  100042:	c7 45 f0 ec 18 10 00 	movl   $0x1018ec,-0x10(%ebp)
	int l = strlen(s);
  100049:	83 ec 0c             	sub    $0xc,%esp
  10004c:	ff 75 f0             	pushl  -0x10(%ebp)
  10004f:	e8 7f 17 00 00       	call   1017d3 <strlen>
  100054:	83 c4 10             	add    $0x10,%esp
  100057:	89 45 ec             	mov    %eax,-0x14(%ebp)

	const char *msg = "hello lmo-os";
  10005a:	c7 45 e8 f1 18 10 00 	movl   $0x1018f1,-0x18(%ebp)
	cprintf(msg);
  100061:	83 ec 0c             	sub    $0xc,%esp
  100064:	ff 75 e8             	pushl  -0x18(%ebp)
  100067:	e8 6a 00 00 00       	call   1000d6 <cprintf>
  10006c:	83 c4 10             	add    $0x10,%esp

     while (1);
  10006f:	eb fe                	jmp    10006f <kern_init+0x48>

00100071 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100077:	83 ec 0c             	sub    $0xc,%esp
  10007a:	ff 75 08             	pushl  0x8(%ebp)
  10007d:	e8 ac 08 00 00       	call   10092e <cons_putc>
  100082:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100085:	8b 45 0c             	mov    0xc(%ebp),%eax
  100088:	8b 00                	mov    (%eax),%eax
  10008a:	8d 50 01             	lea    0x1(%eax),%edx
  10008d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100090:	89 10                	mov    %edx,(%eax)
}
  100092:	90                   	nop
  100093:	c9                   	leave  
  100094:	c3                   	ret    

00100095 <vcprintf>:
/*
 * todo
 * 格式化输出
 * */
int
vcprintf(const char *msg) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
  10009b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
  1000a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  1000a8:	eb 1d                	jmp    1000c7 <vcprintf+0x32>
		cputch(*s, &cnt);
  1000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ad:	0f b6 00             	movzbl (%eax),%eax
  1000b0:	0f be c0             	movsbl %al,%eax
  1000b3:	83 ec 08             	sub    $0x8,%esp
  1000b6:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1000b9:	52                   	push   %edx
  1000ba:	50                   	push   %eax
  1000bb:	e8 b1 ff ff ff       	call   100071 <cputch>
  1000c0:	83 c4 10             	add    $0x10,%esp
		s++;
  1000c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
vcprintf(const char *msg) {
	int cnt = 0;
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
	while (*s != '\0') {
  1000c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ca:	0f b6 00             	movzbl (%eax),%eax
  1000cd:	84 c0                	test   %al,%al
  1000cf:	75 d9                	jne    1000aa <vcprintf+0x15>
		cputch(*s, &cnt);
		s++;
	}
	return cnt;
  1000d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1000d4:	c9                   	leave  
  1000d5:	c3                   	ret    

001000d6 <cprintf>:
/*
 * cprintf - formats a string and writes it to stdout
 * todo
 * */
int
cprintf(const char *msg) {
  1000d6:	55                   	push   %ebp
  1000d7:	89 e5                	mov    %esp,%ebp
  1000d9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	cnt = vcprintf(msg);
  1000dc:	83 ec 0c             	sub    $0xc,%esp
  1000df:	ff 75 08             	pushl  0x8(%ebp)
  1000e2:	e8 ae ff ff ff       	call   100095 <vcprintf>
  1000e7:	83 c4 10             	add    $0x10,%esp
  1000ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return cnt;
  1000ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1000f0:	c9                   	leave  
  1000f1:	c3                   	ret    

001000f2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  1000f2:	55                   	push   %ebp
  1000f3:	89 e5                	mov    %esp,%ebp
  1000f5:	83 ec 18             	sub    $0x18,%esp
  1000f8:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  1000fe:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100102:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100106:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10010a:	ee                   	out    %al,(%dx)
  10010b:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100111:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100115:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100119:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10011d:	ee                   	out    %al,(%dx)
  10011e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100124:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100128:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10012c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100130:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100131:	c7 05 60 33 10 00 00 	movl   $0x0,0x103360
  100138:	00 00 00 

//    cprintf("++ setup timer interrupts\n");
    pic_enable(IRQ_TIMER);
  10013b:	83 ec 0c             	sub    $0xc,%esp
  10013e:	6a 00                	push   $0x0
  100140:	e8 ce 08 00 00       	call   100a13 <pic_enable>
  100145:	83 c4 10             	add    $0x10,%esp
}
  100148:	90                   	nop
  100149:	c9                   	leave  
  10014a:	c3                   	ret    

0010014b <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  10014b:	55                   	push   %ebp
  10014c:	89 e5                	mov    %esp,%ebp
  10014e:	83 ec 10             	sub    $0x10,%esp
  100151:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100157:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10015b:	89 c2                	mov    %eax,%edx
  10015d:	ec                   	in     (%dx),%al
  10015e:	88 45 f4             	mov    %al,-0xc(%ebp)
  100161:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100167:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  10016b:	89 c2                	mov    %eax,%edx
  10016d:	ec                   	in     (%dx),%al
  10016e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100171:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100177:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10017b:	89 c2                	mov    %eax,%edx
  10017d:	ec                   	in     (%dx),%al
  10017e:	88 45 f6             	mov    %al,-0xa(%ebp)
  100181:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100187:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10018b:	89 c2                	mov    %eax,%edx
  10018d:	ec                   	in     (%dx),%al
  10018e:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100191:	90                   	nop
  100192:	c9                   	leave  
  100193:	c3                   	ret    

00100194 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100194:	55                   	push   %ebp
  100195:	89 e5                	mov    %esp,%ebp
  100197:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  10019a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  1001a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001a4:	0f b7 00             	movzwl (%eax),%eax
  1001a7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1001ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001ae:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1001b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001b6:	0f b7 00             	movzwl (%eax),%eax
  1001b9:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1001bd:	74 12                	je     1001d1 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  1001bf:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1001c6:	66 c7 05 26 29 10 00 	movw   $0x3b4,0x102926
  1001cd:	b4 03 
  1001cf:	eb 13                	jmp    1001e4 <cga_init+0x50>
    } else {
        *cp = was;
  1001d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001d4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1001d8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  1001db:	66 c7 05 26 29 10 00 	movw   $0x3d4,0x102926
  1001e2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  1001e4:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  1001eb:	0f b7 c0             	movzwl %ax,%eax
  1001ee:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  1001f2:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1001f6:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1001fa:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1001fe:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  1001ff:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  100206:	83 c0 01             	add    $0x1,%eax
  100209:	0f b7 c0             	movzwl %ax,%eax
  10020c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100210:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100214:	89 c2                	mov    %eax,%edx
  100216:	ec                   	in     (%dx),%al
  100217:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10021a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10021e:	0f b6 c0             	movzbl %al,%eax
  100221:	c1 e0 08             	shl    $0x8,%eax
  100224:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100227:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  10022e:	0f b7 c0             	movzwl %ax,%eax
  100231:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100235:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100239:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  10023d:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100241:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100242:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  100249:	83 c0 01             	add    $0x1,%eax
  10024c:	0f b7 c0             	movzwl %ax,%eax
  10024f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100253:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100257:	89 c2                	mov    %eax,%edx
  100259:	ec                   	in     (%dx),%al
  10025a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10025d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100261:	0f b6 c0             	movzbl %al,%eax
  100264:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100267:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10026a:	a3 20 29 10 00       	mov    %eax,0x102920
    crt_pos = pos;
  10026f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100272:	66 a3 24 29 10 00    	mov    %ax,0x102924
}
  100278:	90                   	nop
  100279:	c9                   	leave  
  10027a:	c3                   	ret    

0010027b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  10027b:	55                   	push   %ebp
  10027c:	89 e5                	mov    %esp,%ebp
  10027e:	83 ec 28             	sub    $0x28,%esp
  100281:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100287:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10028b:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10028f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100293:	ee                   	out    %al,(%dx)
  100294:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  10029a:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  10029e:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1002a2:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1002a6:	ee                   	out    %al,(%dx)
  1002a7:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  1002ad:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  1002b1:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1002b5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1002b9:	ee                   	out    %al,(%dx)
  1002ba:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  1002c0:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  1002c4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1002c8:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1002cc:	ee                   	out    %al,(%dx)
  1002cd:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  1002d3:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  1002d7:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1002db:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1002df:	ee                   	out    %al,(%dx)
  1002e0:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  1002e6:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  1002ea:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1002ee:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1002f2:	ee                   	out    %al,(%dx)
  1002f3:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  1002f9:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  1002fd:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100301:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100305:	ee                   	out    %al,(%dx)
  100306:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10030c:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100310:	89 c2                	mov    %eax,%edx
  100312:	ec                   	in     (%dx),%al
  100313:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100316:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10031a:	3c ff                	cmp    $0xff,%al
  10031c:	0f 95 c0             	setne  %al
  10031f:	0f b6 c0             	movzbl %al,%eax
  100322:	a3 28 29 10 00       	mov    %eax,0x102928
  100327:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10032d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100331:	89 c2                	mov    %eax,%edx
  100333:	ec                   	in     (%dx),%al
  100334:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100337:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  10033d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100341:	89 c2                	mov    %eax,%edx
  100343:	ec                   	in     (%dx),%al
  100344:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100347:	a1 28 29 10 00       	mov    0x102928,%eax
  10034c:	85 c0                	test   %eax,%eax
  10034e:	74 0d                	je     10035d <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100350:	83 ec 0c             	sub    $0xc,%esp
  100353:	6a 04                	push   $0x4
  100355:	e8 b9 06 00 00       	call   100a13 <pic_enable>
  10035a:	83 c4 10             	add    $0x10,%esp
    }
}
  10035d:	90                   	nop
  10035e:	c9                   	leave  
  10035f:	c3                   	ret    

00100360 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100360:	55                   	push   %ebp
  100361:	89 e5                	mov    %esp,%ebp
  100363:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10036d:	eb 09                	jmp    100378 <lpt_putc_sub+0x18>
        delay();
  10036f:	e8 d7 fd ff ff       	call   10014b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100374:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100378:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10037e:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100382:	89 c2                	mov    %eax,%edx
  100384:	ec                   	in     (%dx),%al
  100385:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100388:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10038c:	84 c0                	test   %al,%al
  10038e:	78 09                	js     100399 <lpt_putc_sub+0x39>
  100390:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100397:	7e d6                	jle    10036f <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100399:	8b 45 08             	mov    0x8(%ebp),%eax
  10039c:	0f b6 c0             	movzbl %al,%eax
  10039f:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  1003a5:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1003a8:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  1003ac:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1003b0:	ee                   	out    %al,(%dx)
  1003b1:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1003b7:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1003bb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1003bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1003c3:	ee                   	out    %al,(%dx)
  1003c4:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  1003ca:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  1003ce:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  1003d2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1003d6:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1003d7:	90                   	nop
  1003d8:	c9                   	leave  
  1003d9:	c3                   	ret    

001003da <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1003da:	55                   	push   %ebp
  1003db:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1003dd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1003e1:	74 0d                	je     1003f0 <lpt_putc+0x16>
        lpt_putc_sub(c);
  1003e3:	ff 75 08             	pushl  0x8(%ebp)
  1003e6:	e8 75 ff ff ff       	call   100360 <lpt_putc_sub>
  1003eb:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1003ee:	eb 1e                	jmp    10040e <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1003f0:	6a 08                	push   $0x8
  1003f2:	e8 69 ff ff ff       	call   100360 <lpt_putc_sub>
  1003f7:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1003fa:	6a 20                	push   $0x20
  1003fc:	e8 5f ff ff ff       	call   100360 <lpt_putc_sub>
  100401:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  100404:	6a 08                	push   $0x8
  100406:	e8 55 ff ff ff       	call   100360 <lpt_putc_sub>
  10040b:	83 c4 04             	add    $0x4,%esp
    }
}
  10040e:	90                   	nop
  10040f:	c9                   	leave  
  100410:	c3                   	ret    

00100411 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100411:	55                   	push   %ebp
  100412:	89 e5                	mov    %esp,%ebp
  100414:	53                   	push   %ebx
  100415:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  100418:	8b 45 08             	mov    0x8(%ebp),%eax
  10041b:	b0 00                	mov    $0x0,%al
  10041d:	85 c0                	test   %eax,%eax
  10041f:	75 07                	jne    100428 <cga_putc+0x17>
        c |= 0x0700;
  100421:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  100428:	8b 45 08             	mov    0x8(%ebp),%eax
  10042b:	0f b6 c0             	movzbl %al,%eax
  10042e:	83 f8 0a             	cmp    $0xa,%eax
  100431:	74 4e                	je     100481 <cga_putc+0x70>
  100433:	83 f8 0d             	cmp    $0xd,%eax
  100436:	74 59                	je     100491 <cga_putc+0x80>
  100438:	83 f8 08             	cmp    $0x8,%eax
  10043b:	0f 85 8a 00 00 00    	jne    1004cb <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  100441:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  100448:	66 85 c0             	test   %ax,%ax
  10044b:	0f 84 a0 00 00 00    	je     1004f1 <cga_putc+0xe0>
            crt_pos --;
  100451:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  100458:	83 e8 01             	sub    $0x1,%eax
  10045b:	66 a3 24 29 10 00    	mov    %ax,0x102924
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  100461:	a1 20 29 10 00       	mov    0x102920,%eax
  100466:	0f b7 15 24 29 10 00 	movzwl 0x102924,%edx
  10046d:	0f b7 d2             	movzwl %dx,%edx
  100470:	01 d2                	add    %edx,%edx
  100472:	01 d0                	add    %edx,%eax
  100474:	8b 55 08             	mov    0x8(%ebp),%edx
  100477:	b2 00                	mov    $0x0,%dl
  100479:	83 ca 20             	or     $0x20,%edx
  10047c:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10047f:	eb 70                	jmp    1004f1 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  100481:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  100488:	83 c0 50             	add    $0x50,%eax
  10048b:	66 a3 24 29 10 00    	mov    %ax,0x102924
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  100491:	0f b7 1d 24 29 10 00 	movzwl 0x102924,%ebx
  100498:	0f b7 0d 24 29 10 00 	movzwl 0x102924,%ecx
  10049f:	0f b7 c1             	movzwl %cx,%eax
  1004a2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1004a8:	c1 e8 10             	shr    $0x10,%eax
  1004ab:	89 c2                	mov    %eax,%edx
  1004ad:	66 c1 ea 06          	shr    $0x6,%dx
  1004b1:	89 d0                	mov    %edx,%eax
  1004b3:	c1 e0 02             	shl    $0x2,%eax
  1004b6:	01 d0                	add    %edx,%eax
  1004b8:	c1 e0 04             	shl    $0x4,%eax
  1004bb:	29 c1                	sub    %eax,%ecx
  1004bd:	89 ca                	mov    %ecx,%edx
  1004bf:	89 d8                	mov    %ebx,%eax
  1004c1:	29 d0                	sub    %edx,%eax
  1004c3:	66 a3 24 29 10 00    	mov    %ax,0x102924
        break;
  1004c9:	eb 27                	jmp    1004f2 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1004cb:	8b 0d 20 29 10 00    	mov    0x102920,%ecx
  1004d1:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  1004d8:	8d 50 01             	lea    0x1(%eax),%edx
  1004db:	66 89 15 24 29 10 00 	mov    %dx,0x102924
  1004e2:	0f b7 c0             	movzwl %ax,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 c8                	add    %ecx,%eax
  1004e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1004ec:	66 89 10             	mov    %dx,(%eax)
        break;
  1004ef:	eb 01                	jmp    1004f2 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1004f1:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1004f2:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  1004f9:	66 3d cf 07          	cmp    $0x7cf,%ax
  1004fd:	76 59                	jbe    100558 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1004ff:	a1 20 29 10 00       	mov    0x102920,%eax
  100504:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10050a:	a1 20 29 10 00       	mov    0x102920,%eax
  10050f:	83 ec 04             	sub    $0x4,%esp
  100512:	68 00 0f 00 00       	push   $0xf00
  100517:	52                   	push   %edx
  100518:	50                   	push   %eax
  100519:	e8 12 13 00 00       	call   101830 <memmove>
  10051e:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100521:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  100528:	eb 15                	jmp    10053f <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  10052a:	a1 20 29 10 00       	mov    0x102920,%eax
  10052f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100532:	01 d2                	add    %edx,%edx
  100534:	01 d0                	add    %edx,%eax
  100536:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10053b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10053f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  100546:	7e e2                	jle    10052a <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  100548:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  10054f:	83 e8 50             	sub    $0x50,%eax
  100552:	66 a3 24 29 10 00    	mov    %ax,0x102924
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  100558:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  10055f:	0f b7 c0             	movzwl %ax,%eax
  100562:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100566:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10056a:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10056e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100572:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  100573:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  10057a:	66 c1 e8 08          	shr    $0x8,%ax
  10057e:	0f b6 c0             	movzbl %al,%eax
  100581:	0f b7 15 26 29 10 00 	movzwl 0x102926,%edx
  100588:	83 c2 01             	add    $0x1,%edx
  10058b:	0f b7 d2             	movzwl %dx,%edx
  10058e:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  100592:	88 45 e9             	mov    %al,-0x17(%ebp)
  100595:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100599:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10059d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10059e:	0f b7 05 26 29 10 00 	movzwl 0x102926,%eax
  1005a5:	0f b7 c0             	movzwl %ax,%eax
  1005a8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1005ac:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1005b0:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1005b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1005b8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1005b9:	0f b7 05 24 29 10 00 	movzwl 0x102924,%eax
  1005c0:	0f b6 c0             	movzbl %al,%eax
  1005c3:	0f b7 15 26 29 10 00 	movzwl 0x102926,%edx
  1005ca:	83 c2 01             	add    $0x1,%edx
  1005cd:	0f b7 d2             	movzwl %dx,%edx
  1005d0:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  1005d4:	88 45 eb             	mov    %al,-0x15(%ebp)
  1005d7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1005db:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1005df:	ee                   	out    %al,(%dx)
}
  1005e0:	90                   	nop
  1005e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005e4:	c9                   	leave  
  1005e5:	c3                   	ret    

001005e6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1005e6:	55                   	push   %ebp
  1005e7:	89 e5                	mov    %esp,%ebp
  1005e9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1005ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1005f3:	eb 09                	jmp    1005fe <serial_putc_sub+0x18>
        delay();
  1005f5:	e8 51 fb ff ff       	call   10014b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1005fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1005fe:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100604:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100608:	89 c2                	mov    %eax,%edx
  10060a:	ec                   	in     (%dx),%al
  10060b:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10060e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100612:	0f b6 c0             	movzbl %al,%eax
  100615:	83 e0 20             	and    $0x20,%eax
  100618:	85 c0                	test   %eax,%eax
  10061a:	75 09                	jne    100625 <serial_putc_sub+0x3f>
  10061c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100623:	7e d0                	jle    1005f5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  100625:	8b 45 08             	mov    0x8(%ebp),%eax
  100628:	0f b6 c0             	movzbl %al,%eax
  10062b:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100631:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100634:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  100638:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10063c:	ee                   	out    %al,(%dx)
}
  10063d:	90                   	nop
  10063e:	c9                   	leave  
  10063f:	c3                   	ret    

00100640 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  100640:	55                   	push   %ebp
  100641:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100643:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100647:	74 0d                	je     100656 <serial_putc+0x16>
        serial_putc_sub(c);
  100649:	ff 75 08             	pushl  0x8(%ebp)
  10064c:	e8 95 ff ff ff       	call   1005e6 <serial_putc_sub>
  100651:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  100654:	eb 1e                	jmp    100674 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  100656:	6a 08                	push   $0x8
  100658:	e8 89 ff ff ff       	call   1005e6 <serial_putc_sub>
  10065d:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  100660:	6a 20                	push   $0x20
  100662:	e8 7f ff ff ff       	call   1005e6 <serial_putc_sub>
  100667:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10066a:	6a 08                	push   $0x8
  10066c:	e8 75 ff ff ff       	call   1005e6 <serial_putc_sub>
  100671:	83 c4 04             	add    $0x4,%esp
    }
}
  100674:	90                   	nop
  100675:	c9                   	leave  
  100676:	c3                   	ret    

00100677 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  100677:	55                   	push   %ebp
  100678:	89 e5                	mov    %esp,%ebp
  10067a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10067d:	eb 33                	jmp    1006b2 <cons_intr+0x3b>
        if (c != 0) {
  10067f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100683:	74 2d                	je     1006b2 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  100685:	a1 44 2b 10 00       	mov    0x102b44,%eax
  10068a:	8d 50 01             	lea    0x1(%eax),%edx
  10068d:	89 15 44 2b 10 00    	mov    %edx,0x102b44
  100693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100696:	88 90 40 29 10 00    	mov    %dl,0x102940(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10069c:	a1 44 2b 10 00       	mov    0x102b44,%eax
  1006a1:	3d 00 02 00 00       	cmp    $0x200,%eax
  1006a6:	75 0a                	jne    1006b2 <cons_intr+0x3b>
                cons.wpos = 0;
  1006a8:	c7 05 44 2b 10 00 00 	movl   $0x0,0x102b44
  1006af:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b5:	ff d0                	call   *%eax
  1006b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1006ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1006be:	75 bf                	jne    10067f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1006c0:	90                   	nop
  1006c1:	c9                   	leave  
  1006c2:	c3                   	ret    

001006c3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1006c3:	55                   	push   %ebp
  1006c4:	89 e5                	mov    %esp,%ebp
  1006c6:	83 ec 10             	sub    $0x10,%esp
  1006c9:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1006cf:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	ec                   	in     (%dx),%al
  1006d6:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1006d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1006dd:	0f b6 c0             	movzbl %al,%eax
  1006e0:	83 e0 01             	and    $0x1,%eax
  1006e3:	85 c0                	test   %eax,%eax
  1006e5:	75 07                	jne    1006ee <serial_proc_data+0x2b>
        return -1;
  1006e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ec:	eb 2a                	jmp    100718 <serial_proc_data+0x55>
  1006ee:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1006f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	ec                   	in     (%dx),%al
  1006fb:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1006fe:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  100702:	0f b6 c0             	movzbl %al,%eax
  100705:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  100708:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10070c:	75 07                	jne    100715 <serial_proc_data+0x52>
        c = '\b';
  10070e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  100715:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100718:	c9                   	leave  
  100719:	c3                   	ret    

0010071a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10071a:	55                   	push   %ebp
  10071b:	89 e5                	mov    %esp,%ebp
  10071d:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  100720:	a1 28 29 10 00       	mov    0x102928,%eax
  100725:	85 c0                	test   %eax,%eax
  100727:	74 10                	je     100739 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  100729:	83 ec 0c             	sub    $0xc,%esp
  10072c:	68 c3 06 10 00       	push   $0x1006c3
  100731:	e8 41 ff ff ff       	call   100677 <cons_intr>
  100736:	83 c4 10             	add    $0x10,%esp
    }
}
  100739:	90                   	nop
  10073a:	c9                   	leave  
  10073b:	c3                   	ret    

0010073c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10073c:	55                   	push   %ebp
  10073d:	89 e5                	mov    %esp,%ebp
  10073f:	83 ec 18             	sub    $0x18,%esp
  100742:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100748:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	ec                   	in     (%dx),%al
  10074f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100752:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  100756:	0f b6 c0             	movzbl %al,%eax
  100759:	83 e0 01             	and    $0x1,%eax
  10075c:	85 c0                	test   %eax,%eax
  10075e:	75 0a                	jne    10076a <kbd_proc_data+0x2e>
        return -1;
  100760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100765:	e9 5d 01 00 00       	jmp    1008c7 <kbd_proc_data+0x18b>
  10076a:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void cli(void) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100770:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100774:	89 c2                	mov    %eax,%edx
  100776:	ec                   	in     (%dx),%al
  100777:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  10077a:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10077e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  100781:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  100785:	75 17                	jne    10079e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  100787:	a1 48 2b 10 00       	mov    0x102b48,%eax
  10078c:	83 c8 40             	or     $0x40,%eax
  10078f:	a3 48 2b 10 00       	mov    %eax,0x102b48
        return 0;
  100794:	b8 00 00 00 00       	mov    $0x0,%eax
  100799:	e9 29 01 00 00       	jmp    1008c7 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10079e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007a2:	84 c0                	test   %al,%al
  1007a4:	79 47                	jns    1007ed <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1007a6:	a1 48 2b 10 00       	mov    0x102b48,%eax
  1007ab:	83 e0 40             	and    $0x40,%eax
  1007ae:	85 c0                	test   %eax,%eax
  1007b0:	75 09                	jne    1007bb <kbd_proc_data+0x7f>
  1007b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007b6:	83 e0 7f             	and    $0x7f,%eax
  1007b9:	eb 04                	jmp    1007bf <kbd_proc_data+0x83>
  1007bb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007bf:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1007c2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007c6:	0f b6 80 00 20 10 00 	movzbl 0x102000(%eax),%eax
  1007cd:	83 c8 40             	or     $0x40,%eax
  1007d0:	0f b6 c0             	movzbl %al,%eax
  1007d3:	f7 d0                	not    %eax
  1007d5:	89 c2                	mov    %eax,%edx
  1007d7:	a1 48 2b 10 00       	mov    0x102b48,%eax
  1007dc:	21 d0                	and    %edx,%eax
  1007de:	a3 48 2b 10 00       	mov    %eax,0x102b48
        return 0;
  1007e3:	b8 00 00 00 00       	mov    $0x0,%eax
  1007e8:	e9 da 00 00 00       	jmp    1008c7 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1007ed:	a1 48 2b 10 00       	mov    0x102b48,%eax
  1007f2:	83 e0 40             	and    $0x40,%eax
  1007f5:	85 c0                	test   %eax,%eax
  1007f7:	74 11                	je     10080a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1007f9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1007fd:	a1 48 2b 10 00       	mov    0x102b48,%eax
  100802:	83 e0 bf             	and    $0xffffffbf,%eax
  100805:	a3 48 2b 10 00       	mov    %eax,0x102b48
    }

    shift |= shiftcode[data];
  10080a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10080e:	0f b6 80 00 20 10 00 	movzbl 0x102000(%eax),%eax
  100815:	0f b6 d0             	movzbl %al,%edx
  100818:	a1 48 2b 10 00       	mov    0x102b48,%eax
  10081d:	09 d0                	or     %edx,%eax
  10081f:	a3 48 2b 10 00       	mov    %eax,0x102b48
    shift ^= togglecode[data];
  100824:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100828:	0f b6 80 00 21 10 00 	movzbl 0x102100(%eax),%eax
  10082f:	0f b6 d0             	movzbl %al,%edx
  100832:	a1 48 2b 10 00       	mov    0x102b48,%eax
  100837:	31 d0                	xor    %edx,%eax
  100839:	a3 48 2b 10 00       	mov    %eax,0x102b48

    c = charcode[shift & (CTL | SHIFT)][data];
  10083e:	a1 48 2b 10 00       	mov    0x102b48,%eax
  100843:	83 e0 03             	and    $0x3,%eax
  100846:	8b 14 85 00 25 10 00 	mov    0x102500(,%eax,4),%edx
  10084d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100851:	01 d0                	add    %edx,%eax
  100853:	0f b6 00             	movzbl (%eax),%eax
  100856:	0f b6 c0             	movzbl %al,%eax
  100859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10085c:	a1 48 2b 10 00       	mov    0x102b48,%eax
  100861:	83 e0 08             	and    $0x8,%eax
  100864:	85 c0                	test   %eax,%eax
  100866:	74 22                	je     10088a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  100868:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10086c:	7e 0c                	jle    10087a <kbd_proc_data+0x13e>
  10086e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  100872:	7f 06                	jg     10087a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  100874:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  100878:	eb 10                	jmp    10088a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10087a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10087e:	7e 0a                	jle    10088a <kbd_proc_data+0x14e>
  100880:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  100884:	7f 04                	jg     10088a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  100886:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10088a:	a1 48 2b 10 00       	mov    0x102b48,%eax
  10088f:	f7 d0                	not    %eax
  100891:	83 e0 06             	and    $0x6,%eax
  100894:	85 c0                	test   %eax,%eax
  100896:	75 2c                	jne    1008c4 <kbd_proc_data+0x188>
  100898:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10089f:	75 23                	jne    1008c4 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1008a1:	83 ec 0c             	sub    $0xc,%esp
  1008a4:	68 fe 18 10 00       	push   $0x1018fe
  1008a9:	e8 28 f8 ff ff       	call   1000d6 <cprintf>
  1008ae:	83 c4 10             	add    $0x10,%esp
  1008b1:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  1008b7:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1008bb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1008bf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1008c3:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1008c7:	c9                   	leave  
  1008c8:	c3                   	ret    

001008c9 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1008c9:	55                   	push   %ebp
  1008ca:	89 e5                	mov    %esp,%ebp
  1008cc:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  1008cf:	83 ec 0c             	sub    $0xc,%esp
  1008d2:	68 3c 07 10 00       	push   $0x10073c
  1008d7:	e8 9b fd ff ff       	call   100677 <cons_intr>
  1008dc:	83 c4 10             	add    $0x10,%esp
}
  1008df:	90                   	nop
  1008e0:	c9                   	leave  
  1008e1:	c3                   	ret    

001008e2 <kbd_init>:

static void
kbd_init(void) {
  1008e2:	55                   	push   %ebp
  1008e3:	89 e5                	mov    %esp,%ebp
  1008e5:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1008e8:	e8 dc ff ff ff       	call   1008c9 <kbd_intr>
    pic_enable(IRQ_KBD);
  1008ed:	83 ec 0c             	sub    $0xc,%esp
  1008f0:	6a 01                	push   $0x1
  1008f2:	e8 1c 01 00 00       	call   100a13 <pic_enable>
  1008f7:	83 c4 10             	add    $0x10,%esp
}
  1008fa:	90                   	nop
  1008fb:	c9                   	leave  
  1008fc:	c3                   	ret    

001008fd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1008fd:	55                   	push   %ebp
  1008fe:	89 e5                	mov    %esp,%ebp
  100900:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  100903:	e8 8c f8 ff ff       	call   100194 <cga_init>
    serial_init();
  100908:	e8 6e f9 ff ff       	call   10027b <serial_init>
    kbd_init();
  10090d:	e8 d0 ff ff ff       	call   1008e2 <kbd_init>
    if (!serial_exists) {
  100912:	a1 28 29 10 00       	mov    0x102928,%eax
  100917:	85 c0                	test   %eax,%eax
  100919:	75 10                	jne    10092b <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10091b:	83 ec 0c             	sub    $0xc,%esp
  10091e:	68 0a 19 10 00       	push   $0x10190a
  100923:	e8 ae f7 ff ff       	call   1000d6 <cprintf>
  100928:	83 c4 10             	add    $0x10,%esp
    }
}
  10092b:	90                   	nop
  10092c:	c9                   	leave  
  10092d:	c3                   	ret    

0010092e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10092e:	55                   	push   %ebp
  10092f:	89 e5                	mov    %esp,%ebp
  100931:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  100934:	ff 75 08             	pushl  0x8(%ebp)
  100937:	e8 9e fa ff ff       	call   1003da <lpt_putc>
  10093c:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10093f:	83 ec 0c             	sub    $0xc,%esp
  100942:	ff 75 08             	pushl  0x8(%ebp)
  100945:	e8 c7 fa ff ff       	call   100411 <cga_putc>
  10094a:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  10094d:	83 ec 0c             	sub    $0xc,%esp
  100950:	ff 75 08             	pushl  0x8(%ebp)
  100953:	e8 e8 fc ff ff       	call   100640 <serial_putc>
  100958:	83 c4 10             	add    $0x10,%esp
}
  10095b:	90                   	nop
  10095c:	c9                   	leave  
  10095d:	c3                   	ret    

0010095e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10095e:	55                   	push   %ebp
  10095f:	89 e5                	mov    %esp,%ebp
  100961:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  100964:	e8 b1 fd ff ff       	call   10071a <serial_intr>
    kbd_intr();
  100969:	e8 5b ff ff ff       	call   1008c9 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10096e:	8b 15 40 2b 10 00    	mov    0x102b40,%edx
  100974:	a1 44 2b 10 00       	mov    0x102b44,%eax
  100979:	39 c2                	cmp    %eax,%edx
  10097b:	74 36                	je     1009b3 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10097d:	a1 40 2b 10 00       	mov    0x102b40,%eax
  100982:	8d 50 01             	lea    0x1(%eax),%edx
  100985:	89 15 40 2b 10 00    	mov    %edx,0x102b40
  10098b:	0f b6 80 40 29 10 00 	movzbl 0x102940(%eax),%eax
  100992:	0f b6 c0             	movzbl %al,%eax
  100995:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  100998:	a1 40 2b 10 00       	mov    0x102b40,%eax
  10099d:	3d 00 02 00 00       	cmp    $0x200,%eax
  1009a2:	75 0a                	jne    1009ae <cons_getc+0x50>
            cons.rpos = 0;
  1009a4:	c7 05 40 2b 10 00 00 	movl   $0x0,0x102b40
  1009ab:	00 00 00 
        }
        return c;
  1009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b1:	eb 05                	jmp    1009b8 <cons_getc+0x5a>
    }
    return 0;
  1009b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 14             	sub    $0x14,%esp
  1009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1009c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1009c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1009cb:	66 a3 10 25 10 00    	mov    %ax,0x102510
    if (did_init) {
  1009d1:	a1 4c 2b 10 00       	mov    0x102b4c,%eax
  1009d6:	85 c0                	test   %eax,%eax
  1009d8:	74 36                	je     100a10 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1009da:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1009de:	0f b6 c0             	movzbl %al,%eax
  1009e1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1009e7:	88 45 fa             	mov    %al,-0x6(%ebp)
  1009ea:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1009ee:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1009f2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1009f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1009f7:	66 c1 e8 08          	shr    $0x8,%ax
  1009fb:	0f b6 c0             	movzbl %al,%eax
  1009fe:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100a04:	88 45 fb             	mov    %al,-0x5(%ebp)
  100a07:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100a0b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100a0f:	ee                   	out    %al,(%dx)
    }
}
  100a10:	90                   	nop
  100a11:	c9                   	leave  
  100a12:	c3                   	ret    

00100a13 <pic_enable>:

void
pic_enable(unsigned int irq) {
  100a13:	55                   	push   %ebp
  100a14:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  100a16:	8b 45 08             	mov    0x8(%ebp),%eax
  100a19:	ba 01 00 00 00       	mov    $0x1,%edx
  100a1e:	89 c1                	mov    %eax,%ecx
  100a20:	d3 e2                	shl    %cl,%edx
  100a22:	89 d0                	mov    %edx,%eax
  100a24:	f7 d0                	not    %eax
  100a26:	89 c2                	mov    %eax,%edx
  100a28:	0f b7 05 10 25 10 00 	movzwl 0x102510,%eax
  100a2f:	21 d0                	and    %edx,%eax
  100a31:	0f b7 c0             	movzwl %ax,%eax
  100a34:	50                   	push   %eax
  100a35:	e8 80 ff ff ff       	call   1009ba <pic_setmask>
  100a3a:	83 c4 04             	add    $0x4,%esp
}
  100a3d:	90                   	nop
  100a3e:	c9                   	leave  
  100a3f:	c3                   	ret    

00100a40 <pic_init>:
ICW3： 8259的级联命令字，用来区分主片和从片。
ICW4：指定中断嵌套方式、数据缓冲选择、中断结束方式和CPU类型。
 * */
/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  100a40:	55                   	push   %ebp
  100a41:	89 e5                	mov    %esp,%ebp
  100a43:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  100a46:	c7 05 4c 2b 10 00 01 	movl   $0x1,0x102b4c
  100a4d:	00 00 00 
  100a50:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100a56:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  100a5a:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  100a5e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100a62:	ee                   	out    %al,(%dx)
  100a63:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100a69:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  100a6d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100a71:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100a75:	ee                   	out    %al,(%dx)
  100a76:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  100a7c:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  100a80:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  100a84:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100a88:	ee                   	out    %al,(%dx)
  100a89:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100a8f:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  100a93:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100a97:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100a9b:	ee                   	out    %al,(%dx)
  100a9c:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100aa2:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100aa6:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100aaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100aae:	ee                   	out    %al,(%dx)
  100aaf:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100ab5:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  100ab9:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100abd:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100ac1:	ee                   	out    %al,(%dx)
  100ac2:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  100ac8:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  100acc:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100ad0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ad4:	ee                   	out    %al,(%dx)
  100ad5:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  100adb:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100adf:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ae3:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ae7:	ee                   	out    %al,(%dx)
  100ae8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100aee:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100af2:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100af6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100afa:	ee                   	out    %al,(%dx)
  100afb:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100b01:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  100b05:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100b09:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100b0d:	ee                   	out    %al,(%dx)
  100b0e:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  100b14:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  100b18:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100b1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100b20:	ee                   	out    %al,(%dx)
  100b21:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  100b27:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  100b2b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100b2f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  100b33:	ee                   	out    %al,(%dx)
  100b34:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  100b3a:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  100b3e:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100b42:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100b46:	ee                   	out    %al,(%dx)
  100b47:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  100b4d:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  100b51:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100b55:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  100b59:	ee                   	out    %al,(%dx)

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    // 初始化完毕，使能主从8259A的所有中断
    if (irq_mask != 0xFFFF) {
  100b5a:	0f b7 05 10 25 10 00 	movzwl 0x102510,%eax
  100b61:	66 83 f8 ff          	cmp    $0xffff,%ax
  100b65:	74 13                	je     100b7a <pic_init+0x13a>
        pic_setmask(irq_mask);
  100b67:	0f b7 05 10 25 10 00 	movzwl 0x102510,%eax
  100b6e:	0f b7 c0             	movzwl %ax,%eax
  100b71:	50                   	push   %eax
  100b72:	e8 43 fe ff ff       	call   1009ba <pic_setmask>
  100b77:	83 c4 04             	add    $0x4,%esp
    }
}
  100b7a:	90                   	nop
  100b7b:	c9                   	leave  
  100b7c:	c3                   	ret    

00100b7d <print_ticks>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uint32_t)idt
};


static void print_ticks() {
  100b7d:	55                   	push   %ebp
  100b7e:	89 e5                	mov    %esp,%ebp
  100b80:	83 ec 08             	sub    $0x8,%esp
    cprintf("ticks\n");
  100b83:	83 ec 0c             	sub    $0xc,%esp
  100b86:	68 28 19 10 00       	push   $0x101928
  100b8b:	e8 46 f5 ff ff       	call   1000d6 <cprintf>
  100b90:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    cprintf("EOT: kernel seems ok.");
#endif
}
  100b93:	90                   	nop
  100b94:	c9                   	leave  
  100b95:	c3                   	ret    

00100b96 <idt_init>:


/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  100b96:	55                   	push   %ebp
  100b97:	89 e5                	mov    %esp,%ebp
  100b99:	83 ec 10             	sub    $0x10,%esp
	// 保存在vectors.S中的256个中断处理例程的入口地址数组
    extern uintptr_t __vectors[];

    // 在中断门描述符表中通过建立中断门描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量\__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  100b9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ba3:	e9 c3 00 00 00       	jmp    100c6b <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  100ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bab:	8b 04 85 1a 25 10 00 	mov    0x10251a(,%eax,4),%eax
  100bb2:	89 c2                	mov    %eax,%edx
  100bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bb7:	66 89 14 c5 60 2b 10 	mov    %dx,0x102b60(,%eax,8)
  100bbe:	00 
  100bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bc2:	66 c7 04 c5 62 2b 10 	movw   $0x8,0x102b62(,%eax,8)
  100bc9:	00 08 00 
  100bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bcf:	0f b6 14 c5 64 2b 10 	movzbl 0x102b64(,%eax,8),%edx
  100bd6:	00 
  100bd7:	83 e2 e0             	and    $0xffffffe0,%edx
  100bda:	88 14 c5 64 2b 10 00 	mov    %dl,0x102b64(,%eax,8)
  100be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100be4:	0f b6 14 c5 64 2b 10 	movzbl 0x102b64(,%eax,8),%edx
  100beb:	00 
  100bec:	83 e2 1f             	and    $0x1f,%edx
  100bef:	88 14 c5 64 2b 10 00 	mov    %dl,0x102b64(,%eax,8)
  100bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bf9:	0f b6 14 c5 65 2b 10 	movzbl 0x102b65(,%eax,8),%edx
  100c00:	00 
  100c01:	83 e2 f0             	and    $0xfffffff0,%edx
  100c04:	83 ca 0e             	or     $0xe,%edx
  100c07:	88 14 c5 65 2b 10 00 	mov    %dl,0x102b65(,%eax,8)
  100c0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c11:	0f b6 14 c5 65 2b 10 	movzbl 0x102b65(,%eax,8),%edx
  100c18:	00 
  100c19:	83 e2 ef             	and    $0xffffffef,%edx
  100c1c:	88 14 c5 65 2b 10 00 	mov    %dl,0x102b65(,%eax,8)
  100c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c26:	0f b6 14 c5 65 2b 10 	movzbl 0x102b65(,%eax,8),%edx
  100c2d:	00 
  100c2e:	83 e2 9f             	and    $0xffffff9f,%edx
  100c31:	88 14 c5 65 2b 10 00 	mov    %dl,0x102b65(,%eax,8)
  100c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c3b:	0f b6 14 c5 65 2b 10 	movzbl 0x102b65(,%eax,8),%edx
  100c42:	00 
  100c43:	83 ca 80             	or     $0xffffff80,%edx
  100c46:	88 14 c5 65 2b 10 00 	mov    %dl,0x102b65(,%eax,8)
  100c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c50:	8b 04 85 1a 25 10 00 	mov    0x10251a(,%eax,4),%eax
  100c57:	c1 e8 10             	shr    $0x10,%eax
  100c5a:	89 c2                	mov    %eax,%edx
  100c5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c5f:	66 89 14 c5 66 2b 10 	mov    %dx,0x102b66(,%eax,8)
  100c66:	00 
	// 保存在vectors.S中的256个中断处理例程的入口地址数组
    extern uintptr_t __vectors[];

    // 在中断门描述符表中通过建立中断门描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量\__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  100c67:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c6e:	3d ff 00 00 00       	cmp    $0xff,%eax
  100c73:	0f 86 2f ff ff ff    	jbe    100ba8 <idt_init+0x12>
  100c79:	c7 45 f8 14 25 10 00 	movl   $0x102514,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  100c80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100c83:	0f 01 18             	lidtl  (%eax)
    }

    // 建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    // load the IDT
    lidt(&idt_pd);
}
  100c86:	90                   	nop
  100c87:	c9                   	leave  
  100c88:	c3                   	ret    

00100c89 <trap_dispatch>:



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  100c89:	55                   	push   %ebp
  100c8a:	89 e5                	mov    %esp,%ebp
  100c8c:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  100c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c92:	8b 40 28             	mov    0x28(%eax),%eax
  100c95:	83 f8 21             	cmp    $0x21,%eax
  100c98:	74 57                	je     100cf1 <trap_dispatch+0x68>
  100c9a:	83 f8 24             	cmp    $0x24,%eax
  100c9d:	74 38                	je     100cd7 <trap_dispatch+0x4e>
  100c9f:	83 f8 20             	cmp    $0x20,%eax
  100ca2:	75 67                	jne    100d0b <trap_dispatch+0x82>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
  100ca4:	a1 60 33 10 00       	mov    0x103360,%eax
  100ca9:	83 c0 01             	add    $0x1,%eax
  100cac:	a3 60 33 10 00       	mov    %eax,0x103360
        if (ticks % TICK_NUM == 0) {
  100cb1:	8b 0d 60 33 10 00    	mov    0x103360,%ecx
  100cb7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  100cbc:	89 c8                	mov    %ecx,%eax
  100cbe:	f7 e2                	mul    %edx
  100cc0:	89 d0                	mov    %edx,%eax
  100cc2:	c1 e8 05             	shr    $0x5,%eax
  100cc5:	6b c0 64             	imul   $0x64,%eax,%eax
  100cc8:	29 c1                	sub    %eax,%ecx
  100cca:	89 c8                	mov    %ecx,%eax
  100ccc:	85 c0                	test   %eax,%eax
  100cce:	75 5e                	jne    100d2e <trap_dispatch+0xa5>
            print_ticks();
  100cd0:	e8 a8 fe ff ff       	call   100b7d <print_ticks>
        }
        break;
  100cd5:	eb 57                	jmp    100d2e <trap_dispatch+0xa5>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  100cd7:	e8 82 fc ff ff       	call   10095e <cons_getc>
  100cdc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial \n");
  100cdf:	83 ec 0c             	sub    $0xc,%esp
  100ce2:	68 2f 19 10 00       	push   $0x10192f
  100ce7:	e8 ea f3 ff ff       	call   1000d6 <cprintf>
  100cec:	83 c4 10             	add    $0x10,%esp
        break;
  100cef:	eb 3e                	jmp    100d2f <trap_dispatch+0xa6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  100cf1:	e8 68 fc ff ff       	call   10095e <cons_getc>
  100cf6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd \n");
  100cf9:	83 ec 0c             	sub    $0xc,%esp
  100cfc:	68 38 19 10 00       	push   $0x101938
  100d01:	e8 d0 f3 ff ff       	call   1000d6 <cprintf>
  100d06:	83 c4 10             	add    $0x10,%esp
        break;
  100d09:	eb 24                	jmp    100d2f <trap_dispatch+0xa6>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  100d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0e:	0f b7 40 34          	movzwl 0x34(%eax),%eax
  100d12:	0f b7 c0             	movzwl %ax,%eax
  100d15:	83 e0 03             	and    $0x3,%eax
  100d18:	85 c0                	test   %eax,%eax
  100d1a:	75 13                	jne    100d2f <trap_dispatch+0xa6>
        	cprintf("in kernel, it must be a mistake \n");
  100d1c:	83 ec 0c             	sub    $0xc,%esp
  100d1f:	68 40 19 10 00       	push   $0x101940
  100d24:	e8 ad f3 ff ff       	call   1000d6 <cprintf>
  100d29:	83 c4 10             	add    $0x10,%esp
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
        }
    }
}
  100d2c:	eb 01                	jmp    100d2f <trap_dispatch+0xa6>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  100d2e:	90                   	nop
        	cprintf("in kernel, it must be a mistake \n");
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
        }
    }
}
  100d2f:	90                   	nop
  100d30:	c9                   	leave  
  100d31:	c3                   	ret    

00100d32 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 08             	sub    $0x8,%esp
    trap_dispatch(tf);
  100d38:	83 ec 0c             	sub    $0xc,%esp
  100d3b:	ff 75 08             	pushl  0x8(%ebp)
  100d3e:	e8 46 ff ff ff       	call   100c89 <trap_dispatch>
  100d43:	83 c4 10             	add    $0x10,%esp
}
  100d46:	90                   	nop
  100d47:	c9                   	leave  
  100d48:	c3                   	ret    

00100d49 <vector0>:
# __vectors地址处开始处连续存储了256个中断处理例程的入口地址数组
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  100d49:	6a 00                	push   $0x0
  pushl $0
  100d4b:	6a 00                	push   $0x0
  jmp __alltraps
  100d4d:	e9 67 0a 00 00       	jmp    1017b9 <__alltraps>

00100d52 <vector1>:
.globl vector1
vector1:
  pushl $0
  100d52:	6a 00                	push   $0x0
  pushl $1
  100d54:	6a 01                	push   $0x1
  jmp __alltraps
  100d56:	e9 5e 0a 00 00       	jmp    1017b9 <__alltraps>

00100d5b <vector2>:
.globl vector2
vector2:
  pushl $0
  100d5b:	6a 00                	push   $0x0
  pushl $2
  100d5d:	6a 02                	push   $0x2
  jmp __alltraps
  100d5f:	e9 55 0a 00 00       	jmp    1017b9 <__alltraps>

00100d64 <vector3>:
.globl vector3
vector3:
  pushl $0
  100d64:	6a 00                	push   $0x0
  pushl $3
  100d66:	6a 03                	push   $0x3
  jmp __alltraps
  100d68:	e9 4c 0a 00 00       	jmp    1017b9 <__alltraps>

00100d6d <vector4>:
.globl vector4
vector4:
  pushl $0
  100d6d:	6a 00                	push   $0x0
  pushl $4
  100d6f:	6a 04                	push   $0x4
  jmp __alltraps
  100d71:	e9 43 0a 00 00       	jmp    1017b9 <__alltraps>

00100d76 <vector5>:
.globl vector5
vector5:
  pushl $0
  100d76:	6a 00                	push   $0x0
  pushl $5
  100d78:	6a 05                	push   $0x5
  jmp __alltraps
  100d7a:	e9 3a 0a 00 00       	jmp    1017b9 <__alltraps>

00100d7f <vector6>:
.globl vector6
vector6:
  pushl $0
  100d7f:	6a 00                	push   $0x0
  pushl $6
  100d81:	6a 06                	push   $0x6
  jmp __alltraps
  100d83:	e9 31 0a 00 00       	jmp    1017b9 <__alltraps>

00100d88 <vector7>:
.globl vector7
vector7:
  pushl $0
  100d88:	6a 00                	push   $0x0
  pushl $7
  100d8a:	6a 07                	push   $0x7
  jmp __alltraps
  100d8c:	e9 28 0a 00 00       	jmp    1017b9 <__alltraps>

00100d91 <vector8>:
.globl vector8
vector8:
  pushl $8
  100d91:	6a 08                	push   $0x8
  jmp __alltraps
  100d93:	e9 21 0a 00 00       	jmp    1017b9 <__alltraps>

00100d98 <vector9>:
.globl vector9
vector9:
  pushl $9
  100d98:	6a 09                	push   $0x9
  jmp __alltraps
  100d9a:	e9 1a 0a 00 00       	jmp    1017b9 <__alltraps>

00100d9f <vector10>:
.globl vector10
vector10:
  pushl $10
  100d9f:	6a 0a                	push   $0xa
  jmp __alltraps
  100da1:	e9 13 0a 00 00       	jmp    1017b9 <__alltraps>

00100da6 <vector11>:
.globl vector11
vector11:
  pushl $11
  100da6:	6a 0b                	push   $0xb
  jmp __alltraps
  100da8:	e9 0c 0a 00 00       	jmp    1017b9 <__alltraps>

00100dad <vector12>:
.globl vector12
vector12:
  pushl $12
  100dad:	6a 0c                	push   $0xc
  jmp __alltraps
  100daf:	e9 05 0a 00 00       	jmp    1017b9 <__alltraps>

00100db4 <vector13>:
.globl vector13
vector13:
  pushl $13
  100db4:	6a 0d                	push   $0xd
  jmp __alltraps
  100db6:	e9 fe 09 00 00       	jmp    1017b9 <__alltraps>

00100dbb <vector14>:
.globl vector14
vector14:
  pushl $14
  100dbb:	6a 0e                	push   $0xe
  jmp __alltraps
  100dbd:	e9 f7 09 00 00       	jmp    1017b9 <__alltraps>

00100dc2 <vector15>:
.globl vector15
vector15:
  pushl $0
  100dc2:	6a 00                	push   $0x0
  pushl $15
  100dc4:	6a 0f                	push   $0xf
  jmp __alltraps
  100dc6:	e9 ee 09 00 00       	jmp    1017b9 <__alltraps>

00100dcb <vector16>:
.globl vector16
vector16:
  pushl $0
  100dcb:	6a 00                	push   $0x0
  pushl $16
  100dcd:	6a 10                	push   $0x10
  jmp __alltraps
  100dcf:	e9 e5 09 00 00       	jmp    1017b9 <__alltraps>

00100dd4 <vector17>:
.globl vector17
vector17:
  pushl $17
  100dd4:	6a 11                	push   $0x11
  jmp __alltraps
  100dd6:	e9 de 09 00 00       	jmp    1017b9 <__alltraps>

00100ddb <vector18>:
.globl vector18
vector18:
  pushl $0
  100ddb:	6a 00                	push   $0x0
  pushl $18
  100ddd:	6a 12                	push   $0x12
  jmp __alltraps
  100ddf:	e9 d5 09 00 00       	jmp    1017b9 <__alltraps>

00100de4 <vector19>:
.globl vector19
vector19:
  pushl $0
  100de4:	6a 00                	push   $0x0
  pushl $19
  100de6:	6a 13                	push   $0x13
  jmp __alltraps
  100de8:	e9 cc 09 00 00       	jmp    1017b9 <__alltraps>

00100ded <vector20>:
.globl vector20
vector20:
  pushl $0
  100ded:	6a 00                	push   $0x0
  pushl $20
  100def:	6a 14                	push   $0x14
  jmp __alltraps
  100df1:	e9 c3 09 00 00       	jmp    1017b9 <__alltraps>

00100df6 <vector21>:
.globl vector21
vector21:
  pushl $0
  100df6:	6a 00                	push   $0x0
  pushl $21
  100df8:	6a 15                	push   $0x15
  jmp __alltraps
  100dfa:	e9 ba 09 00 00       	jmp    1017b9 <__alltraps>

00100dff <vector22>:
.globl vector22
vector22:
  pushl $0
  100dff:	6a 00                	push   $0x0
  pushl $22
  100e01:	6a 16                	push   $0x16
  jmp __alltraps
  100e03:	e9 b1 09 00 00       	jmp    1017b9 <__alltraps>

00100e08 <vector23>:
.globl vector23
vector23:
  pushl $0
  100e08:	6a 00                	push   $0x0
  pushl $23
  100e0a:	6a 17                	push   $0x17
  jmp __alltraps
  100e0c:	e9 a8 09 00 00       	jmp    1017b9 <__alltraps>

00100e11 <vector24>:
.globl vector24
vector24:
  pushl $0
  100e11:	6a 00                	push   $0x0
  pushl $24
  100e13:	6a 18                	push   $0x18
  jmp __alltraps
  100e15:	e9 9f 09 00 00       	jmp    1017b9 <__alltraps>

00100e1a <vector25>:
.globl vector25
vector25:
  pushl $0
  100e1a:	6a 00                	push   $0x0
  pushl $25
  100e1c:	6a 19                	push   $0x19
  jmp __alltraps
  100e1e:	e9 96 09 00 00       	jmp    1017b9 <__alltraps>

00100e23 <vector26>:
.globl vector26
vector26:
  pushl $0
  100e23:	6a 00                	push   $0x0
  pushl $26
  100e25:	6a 1a                	push   $0x1a
  jmp __alltraps
  100e27:	e9 8d 09 00 00       	jmp    1017b9 <__alltraps>

00100e2c <vector27>:
.globl vector27
vector27:
  pushl $0
  100e2c:	6a 00                	push   $0x0
  pushl $27
  100e2e:	6a 1b                	push   $0x1b
  jmp __alltraps
  100e30:	e9 84 09 00 00       	jmp    1017b9 <__alltraps>

00100e35 <vector28>:
.globl vector28
vector28:
  pushl $0
  100e35:	6a 00                	push   $0x0
  pushl $28
  100e37:	6a 1c                	push   $0x1c
  jmp __alltraps
  100e39:	e9 7b 09 00 00       	jmp    1017b9 <__alltraps>

00100e3e <vector29>:
.globl vector29
vector29:
  pushl $0
  100e3e:	6a 00                	push   $0x0
  pushl $29
  100e40:	6a 1d                	push   $0x1d
  jmp __alltraps
  100e42:	e9 72 09 00 00       	jmp    1017b9 <__alltraps>

00100e47 <vector30>:
.globl vector30
vector30:
  pushl $0
  100e47:	6a 00                	push   $0x0
  pushl $30
  100e49:	6a 1e                	push   $0x1e
  jmp __alltraps
  100e4b:	e9 69 09 00 00       	jmp    1017b9 <__alltraps>

00100e50 <vector31>:
.globl vector31
vector31:
  pushl $0
  100e50:	6a 00                	push   $0x0
  pushl $31
  100e52:	6a 1f                	push   $0x1f
  jmp __alltraps
  100e54:	e9 60 09 00 00       	jmp    1017b9 <__alltraps>

00100e59 <vector32>:
.globl vector32
vector32:
  pushl $0
  100e59:	6a 00                	push   $0x0
  pushl $32
  100e5b:	6a 20                	push   $0x20
  jmp __alltraps
  100e5d:	e9 57 09 00 00       	jmp    1017b9 <__alltraps>

00100e62 <vector33>:
.globl vector33
vector33:
  pushl $0
  100e62:	6a 00                	push   $0x0
  pushl $33
  100e64:	6a 21                	push   $0x21
  jmp __alltraps
  100e66:	e9 4e 09 00 00       	jmp    1017b9 <__alltraps>

00100e6b <vector34>:
.globl vector34
vector34:
  pushl $0
  100e6b:	6a 00                	push   $0x0
  pushl $34
  100e6d:	6a 22                	push   $0x22
  jmp __alltraps
  100e6f:	e9 45 09 00 00       	jmp    1017b9 <__alltraps>

00100e74 <vector35>:
.globl vector35
vector35:
  pushl $0
  100e74:	6a 00                	push   $0x0
  pushl $35
  100e76:	6a 23                	push   $0x23
  jmp __alltraps
  100e78:	e9 3c 09 00 00       	jmp    1017b9 <__alltraps>

00100e7d <vector36>:
.globl vector36
vector36:
  pushl $0
  100e7d:	6a 00                	push   $0x0
  pushl $36
  100e7f:	6a 24                	push   $0x24
  jmp __alltraps
  100e81:	e9 33 09 00 00       	jmp    1017b9 <__alltraps>

00100e86 <vector37>:
.globl vector37
vector37:
  pushl $0
  100e86:	6a 00                	push   $0x0
  pushl $37
  100e88:	6a 25                	push   $0x25
  jmp __alltraps
  100e8a:	e9 2a 09 00 00       	jmp    1017b9 <__alltraps>

00100e8f <vector38>:
.globl vector38
vector38:
  pushl $0
  100e8f:	6a 00                	push   $0x0
  pushl $38
  100e91:	6a 26                	push   $0x26
  jmp __alltraps
  100e93:	e9 21 09 00 00       	jmp    1017b9 <__alltraps>

00100e98 <vector39>:
.globl vector39
vector39:
  pushl $0
  100e98:	6a 00                	push   $0x0
  pushl $39
  100e9a:	6a 27                	push   $0x27
  jmp __alltraps
  100e9c:	e9 18 09 00 00       	jmp    1017b9 <__alltraps>

00100ea1 <vector40>:
.globl vector40
vector40:
  pushl $0
  100ea1:	6a 00                	push   $0x0
  pushl $40
  100ea3:	6a 28                	push   $0x28
  jmp __alltraps
  100ea5:	e9 0f 09 00 00       	jmp    1017b9 <__alltraps>

00100eaa <vector41>:
.globl vector41
vector41:
  pushl $0
  100eaa:	6a 00                	push   $0x0
  pushl $41
  100eac:	6a 29                	push   $0x29
  jmp __alltraps
  100eae:	e9 06 09 00 00       	jmp    1017b9 <__alltraps>

00100eb3 <vector42>:
.globl vector42
vector42:
  pushl $0
  100eb3:	6a 00                	push   $0x0
  pushl $42
  100eb5:	6a 2a                	push   $0x2a
  jmp __alltraps
  100eb7:	e9 fd 08 00 00       	jmp    1017b9 <__alltraps>

00100ebc <vector43>:
.globl vector43
vector43:
  pushl $0
  100ebc:	6a 00                	push   $0x0
  pushl $43
  100ebe:	6a 2b                	push   $0x2b
  jmp __alltraps
  100ec0:	e9 f4 08 00 00       	jmp    1017b9 <__alltraps>

00100ec5 <vector44>:
.globl vector44
vector44:
  pushl $0
  100ec5:	6a 00                	push   $0x0
  pushl $44
  100ec7:	6a 2c                	push   $0x2c
  jmp __alltraps
  100ec9:	e9 eb 08 00 00       	jmp    1017b9 <__alltraps>

00100ece <vector45>:
.globl vector45
vector45:
  pushl $0
  100ece:	6a 00                	push   $0x0
  pushl $45
  100ed0:	6a 2d                	push   $0x2d
  jmp __alltraps
  100ed2:	e9 e2 08 00 00       	jmp    1017b9 <__alltraps>

00100ed7 <vector46>:
.globl vector46
vector46:
  pushl $0
  100ed7:	6a 00                	push   $0x0
  pushl $46
  100ed9:	6a 2e                	push   $0x2e
  jmp __alltraps
  100edb:	e9 d9 08 00 00       	jmp    1017b9 <__alltraps>

00100ee0 <vector47>:
.globl vector47
vector47:
  pushl $0
  100ee0:	6a 00                	push   $0x0
  pushl $47
  100ee2:	6a 2f                	push   $0x2f
  jmp __alltraps
  100ee4:	e9 d0 08 00 00       	jmp    1017b9 <__alltraps>

00100ee9 <vector48>:
.globl vector48
vector48:
  pushl $0
  100ee9:	6a 00                	push   $0x0
  pushl $48
  100eeb:	6a 30                	push   $0x30
  jmp __alltraps
  100eed:	e9 c7 08 00 00       	jmp    1017b9 <__alltraps>

00100ef2 <vector49>:
.globl vector49
vector49:
  pushl $0
  100ef2:	6a 00                	push   $0x0
  pushl $49
  100ef4:	6a 31                	push   $0x31
  jmp __alltraps
  100ef6:	e9 be 08 00 00       	jmp    1017b9 <__alltraps>

00100efb <vector50>:
.globl vector50
vector50:
  pushl $0
  100efb:	6a 00                	push   $0x0
  pushl $50
  100efd:	6a 32                	push   $0x32
  jmp __alltraps
  100eff:	e9 b5 08 00 00       	jmp    1017b9 <__alltraps>

00100f04 <vector51>:
.globl vector51
vector51:
  pushl $0
  100f04:	6a 00                	push   $0x0
  pushl $51
  100f06:	6a 33                	push   $0x33
  jmp __alltraps
  100f08:	e9 ac 08 00 00       	jmp    1017b9 <__alltraps>

00100f0d <vector52>:
.globl vector52
vector52:
  pushl $0
  100f0d:	6a 00                	push   $0x0
  pushl $52
  100f0f:	6a 34                	push   $0x34
  jmp __alltraps
  100f11:	e9 a3 08 00 00       	jmp    1017b9 <__alltraps>

00100f16 <vector53>:
.globl vector53
vector53:
  pushl $0
  100f16:	6a 00                	push   $0x0
  pushl $53
  100f18:	6a 35                	push   $0x35
  jmp __alltraps
  100f1a:	e9 9a 08 00 00       	jmp    1017b9 <__alltraps>

00100f1f <vector54>:
.globl vector54
vector54:
  pushl $0
  100f1f:	6a 00                	push   $0x0
  pushl $54
  100f21:	6a 36                	push   $0x36
  jmp __alltraps
  100f23:	e9 91 08 00 00       	jmp    1017b9 <__alltraps>

00100f28 <vector55>:
.globl vector55
vector55:
  pushl $0
  100f28:	6a 00                	push   $0x0
  pushl $55
  100f2a:	6a 37                	push   $0x37
  jmp __alltraps
  100f2c:	e9 88 08 00 00       	jmp    1017b9 <__alltraps>

00100f31 <vector56>:
.globl vector56
vector56:
  pushl $0
  100f31:	6a 00                	push   $0x0
  pushl $56
  100f33:	6a 38                	push   $0x38
  jmp __alltraps
  100f35:	e9 7f 08 00 00       	jmp    1017b9 <__alltraps>

00100f3a <vector57>:
.globl vector57
vector57:
  pushl $0
  100f3a:	6a 00                	push   $0x0
  pushl $57
  100f3c:	6a 39                	push   $0x39
  jmp __alltraps
  100f3e:	e9 76 08 00 00       	jmp    1017b9 <__alltraps>

00100f43 <vector58>:
.globl vector58
vector58:
  pushl $0
  100f43:	6a 00                	push   $0x0
  pushl $58
  100f45:	6a 3a                	push   $0x3a
  jmp __alltraps
  100f47:	e9 6d 08 00 00       	jmp    1017b9 <__alltraps>

00100f4c <vector59>:
.globl vector59
vector59:
  pushl $0
  100f4c:	6a 00                	push   $0x0
  pushl $59
  100f4e:	6a 3b                	push   $0x3b
  jmp __alltraps
  100f50:	e9 64 08 00 00       	jmp    1017b9 <__alltraps>

00100f55 <vector60>:
.globl vector60
vector60:
  pushl $0
  100f55:	6a 00                	push   $0x0
  pushl $60
  100f57:	6a 3c                	push   $0x3c
  jmp __alltraps
  100f59:	e9 5b 08 00 00       	jmp    1017b9 <__alltraps>

00100f5e <vector61>:
.globl vector61
vector61:
  pushl $0
  100f5e:	6a 00                	push   $0x0
  pushl $61
  100f60:	6a 3d                	push   $0x3d
  jmp __alltraps
  100f62:	e9 52 08 00 00       	jmp    1017b9 <__alltraps>

00100f67 <vector62>:
.globl vector62
vector62:
  pushl $0
  100f67:	6a 00                	push   $0x0
  pushl $62
  100f69:	6a 3e                	push   $0x3e
  jmp __alltraps
  100f6b:	e9 49 08 00 00       	jmp    1017b9 <__alltraps>

00100f70 <vector63>:
.globl vector63
vector63:
  pushl $0
  100f70:	6a 00                	push   $0x0
  pushl $63
  100f72:	6a 3f                	push   $0x3f
  jmp __alltraps
  100f74:	e9 40 08 00 00       	jmp    1017b9 <__alltraps>

00100f79 <vector64>:
.globl vector64
vector64:
  pushl $0
  100f79:	6a 00                	push   $0x0
  pushl $64
  100f7b:	6a 40                	push   $0x40
  jmp __alltraps
  100f7d:	e9 37 08 00 00       	jmp    1017b9 <__alltraps>

00100f82 <vector65>:
.globl vector65
vector65:
  pushl $0
  100f82:	6a 00                	push   $0x0
  pushl $65
  100f84:	6a 41                	push   $0x41
  jmp __alltraps
  100f86:	e9 2e 08 00 00       	jmp    1017b9 <__alltraps>

00100f8b <vector66>:
.globl vector66
vector66:
  pushl $0
  100f8b:	6a 00                	push   $0x0
  pushl $66
  100f8d:	6a 42                	push   $0x42
  jmp __alltraps
  100f8f:	e9 25 08 00 00       	jmp    1017b9 <__alltraps>

00100f94 <vector67>:
.globl vector67
vector67:
  pushl $0
  100f94:	6a 00                	push   $0x0
  pushl $67
  100f96:	6a 43                	push   $0x43
  jmp __alltraps
  100f98:	e9 1c 08 00 00       	jmp    1017b9 <__alltraps>

00100f9d <vector68>:
.globl vector68
vector68:
  pushl $0
  100f9d:	6a 00                	push   $0x0
  pushl $68
  100f9f:	6a 44                	push   $0x44
  jmp __alltraps
  100fa1:	e9 13 08 00 00       	jmp    1017b9 <__alltraps>

00100fa6 <vector69>:
.globl vector69
vector69:
  pushl $0
  100fa6:	6a 00                	push   $0x0
  pushl $69
  100fa8:	6a 45                	push   $0x45
  jmp __alltraps
  100faa:	e9 0a 08 00 00       	jmp    1017b9 <__alltraps>

00100faf <vector70>:
.globl vector70
vector70:
  pushl $0
  100faf:	6a 00                	push   $0x0
  pushl $70
  100fb1:	6a 46                	push   $0x46
  jmp __alltraps
  100fb3:	e9 01 08 00 00       	jmp    1017b9 <__alltraps>

00100fb8 <vector71>:
.globl vector71
vector71:
  pushl $0
  100fb8:	6a 00                	push   $0x0
  pushl $71
  100fba:	6a 47                	push   $0x47
  jmp __alltraps
  100fbc:	e9 f8 07 00 00       	jmp    1017b9 <__alltraps>

00100fc1 <vector72>:
.globl vector72
vector72:
  pushl $0
  100fc1:	6a 00                	push   $0x0
  pushl $72
  100fc3:	6a 48                	push   $0x48
  jmp __alltraps
  100fc5:	e9 ef 07 00 00       	jmp    1017b9 <__alltraps>

00100fca <vector73>:
.globl vector73
vector73:
  pushl $0
  100fca:	6a 00                	push   $0x0
  pushl $73
  100fcc:	6a 49                	push   $0x49
  jmp __alltraps
  100fce:	e9 e6 07 00 00       	jmp    1017b9 <__alltraps>

00100fd3 <vector74>:
.globl vector74
vector74:
  pushl $0
  100fd3:	6a 00                	push   $0x0
  pushl $74
  100fd5:	6a 4a                	push   $0x4a
  jmp __alltraps
  100fd7:	e9 dd 07 00 00       	jmp    1017b9 <__alltraps>

00100fdc <vector75>:
.globl vector75
vector75:
  pushl $0
  100fdc:	6a 00                	push   $0x0
  pushl $75
  100fde:	6a 4b                	push   $0x4b
  jmp __alltraps
  100fe0:	e9 d4 07 00 00       	jmp    1017b9 <__alltraps>

00100fe5 <vector76>:
.globl vector76
vector76:
  pushl $0
  100fe5:	6a 00                	push   $0x0
  pushl $76
  100fe7:	6a 4c                	push   $0x4c
  jmp __alltraps
  100fe9:	e9 cb 07 00 00       	jmp    1017b9 <__alltraps>

00100fee <vector77>:
.globl vector77
vector77:
  pushl $0
  100fee:	6a 00                	push   $0x0
  pushl $77
  100ff0:	6a 4d                	push   $0x4d
  jmp __alltraps
  100ff2:	e9 c2 07 00 00       	jmp    1017b9 <__alltraps>

00100ff7 <vector78>:
.globl vector78
vector78:
  pushl $0
  100ff7:	6a 00                	push   $0x0
  pushl $78
  100ff9:	6a 4e                	push   $0x4e
  jmp __alltraps
  100ffb:	e9 b9 07 00 00       	jmp    1017b9 <__alltraps>

00101000 <vector79>:
.globl vector79
vector79:
  pushl $0
  101000:	6a 00                	push   $0x0
  pushl $79
  101002:	6a 4f                	push   $0x4f
  jmp __alltraps
  101004:	e9 b0 07 00 00       	jmp    1017b9 <__alltraps>

00101009 <vector80>:
.globl vector80
vector80:
  pushl $0
  101009:	6a 00                	push   $0x0
  pushl $80
  10100b:	6a 50                	push   $0x50
  jmp __alltraps
  10100d:	e9 a7 07 00 00       	jmp    1017b9 <__alltraps>

00101012 <vector81>:
.globl vector81
vector81:
  pushl $0
  101012:	6a 00                	push   $0x0
  pushl $81
  101014:	6a 51                	push   $0x51
  jmp __alltraps
  101016:	e9 9e 07 00 00       	jmp    1017b9 <__alltraps>

0010101b <vector82>:
.globl vector82
vector82:
  pushl $0
  10101b:	6a 00                	push   $0x0
  pushl $82
  10101d:	6a 52                	push   $0x52
  jmp __alltraps
  10101f:	e9 95 07 00 00       	jmp    1017b9 <__alltraps>

00101024 <vector83>:
.globl vector83
vector83:
  pushl $0
  101024:	6a 00                	push   $0x0
  pushl $83
  101026:	6a 53                	push   $0x53
  jmp __alltraps
  101028:	e9 8c 07 00 00       	jmp    1017b9 <__alltraps>

0010102d <vector84>:
.globl vector84
vector84:
  pushl $0
  10102d:	6a 00                	push   $0x0
  pushl $84
  10102f:	6a 54                	push   $0x54
  jmp __alltraps
  101031:	e9 83 07 00 00       	jmp    1017b9 <__alltraps>

00101036 <vector85>:
.globl vector85
vector85:
  pushl $0
  101036:	6a 00                	push   $0x0
  pushl $85
  101038:	6a 55                	push   $0x55
  jmp __alltraps
  10103a:	e9 7a 07 00 00       	jmp    1017b9 <__alltraps>

0010103f <vector86>:
.globl vector86
vector86:
  pushl $0
  10103f:	6a 00                	push   $0x0
  pushl $86
  101041:	6a 56                	push   $0x56
  jmp __alltraps
  101043:	e9 71 07 00 00       	jmp    1017b9 <__alltraps>

00101048 <vector87>:
.globl vector87
vector87:
  pushl $0
  101048:	6a 00                	push   $0x0
  pushl $87
  10104a:	6a 57                	push   $0x57
  jmp __alltraps
  10104c:	e9 68 07 00 00       	jmp    1017b9 <__alltraps>

00101051 <vector88>:
.globl vector88
vector88:
  pushl $0
  101051:	6a 00                	push   $0x0
  pushl $88
  101053:	6a 58                	push   $0x58
  jmp __alltraps
  101055:	e9 5f 07 00 00       	jmp    1017b9 <__alltraps>

0010105a <vector89>:
.globl vector89
vector89:
  pushl $0
  10105a:	6a 00                	push   $0x0
  pushl $89
  10105c:	6a 59                	push   $0x59
  jmp __alltraps
  10105e:	e9 56 07 00 00       	jmp    1017b9 <__alltraps>

00101063 <vector90>:
.globl vector90
vector90:
  pushl $0
  101063:	6a 00                	push   $0x0
  pushl $90
  101065:	6a 5a                	push   $0x5a
  jmp __alltraps
  101067:	e9 4d 07 00 00       	jmp    1017b9 <__alltraps>

0010106c <vector91>:
.globl vector91
vector91:
  pushl $0
  10106c:	6a 00                	push   $0x0
  pushl $91
  10106e:	6a 5b                	push   $0x5b
  jmp __alltraps
  101070:	e9 44 07 00 00       	jmp    1017b9 <__alltraps>

00101075 <vector92>:
.globl vector92
vector92:
  pushl $0
  101075:	6a 00                	push   $0x0
  pushl $92
  101077:	6a 5c                	push   $0x5c
  jmp __alltraps
  101079:	e9 3b 07 00 00       	jmp    1017b9 <__alltraps>

0010107e <vector93>:
.globl vector93
vector93:
  pushl $0
  10107e:	6a 00                	push   $0x0
  pushl $93
  101080:	6a 5d                	push   $0x5d
  jmp __alltraps
  101082:	e9 32 07 00 00       	jmp    1017b9 <__alltraps>

00101087 <vector94>:
.globl vector94
vector94:
  pushl $0
  101087:	6a 00                	push   $0x0
  pushl $94
  101089:	6a 5e                	push   $0x5e
  jmp __alltraps
  10108b:	e9 29 07 00 00       	jmp    1017b9 <__alltraps>

00101090 <vector95>:
.globl vector95
vector95:
  pushl $0
  101090:	6a 00                	push   $0x0
  pushl $95
  101092:	6a 5f                	push   $0x5f
  jmp __alltraps
  101094:	e9 20 07 00 00       	jmp    1017b9 <__alltraps>

00101099 <vector96>:
.globl vector96
vector96:
  pushl $0
  101099:	6a 00                	push   $0x0
  pushl $96
  10109b:	6a 60                	push   $0x60
  jmp __alltraps
  10109d:	e9 17 07 00 00       	jmp    1017b9 <__alltraps>

001010a2 <vector97>:
.globl vector97
vector97:
  pushl $0
  1010a2:	6a 00                	push   $0x0
  pushl $97
  1010a4:	6a 61                	push   $0x61
  jmp __alltraps
  1010a6:	e9 0e 07 00 00       	jmp    1017b9 <__alltraps>

001010ab <vector98>:
.globl vector98
vector98:
  pushl $0
  1010ab:	6a 00                	push   $0x0
  pushl $98
  1010ad:	6a 62                	push   $0x62
  jmp __alltraps
  1010af:	e9 05 07 00 00       	jmp    1017b9 <__alltraps>

001010b4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1010b4:	6a 00                	push   $0x0
  pushl $99
  1010b6:	6a 63                	push   $0x63
  jmp __alltraps
  1010b8:	e9 fc 06 00 00       	jmp    1017b9 <__alltraps>

001010bd <vector100>:
.globl vector100
vector100:
  pushl $0
  1010bd:	6a 00                	push   $0x0
  pushl $100
  1010bf:	6a 64                	push   $0x64
  jmp __alltraps
  1010c1:	e9 f3 06 00 00       	jmp    1017b9 <__alltraps>

001010c6 <vector101>:
.globl vector101
vector101:
  pushl $0
  1010c6:	6a 00                	push   $0x0
  pushl $101
  1010c8:	6a 65                	push   $0x65
  jmp __alltraps
  1010ca:	e9 ea 06 00 00       	jmp    1017b9 <__alltraps>

001010cf <vector102>:
.globl vector102
vector102:
  pushl $0
  1010cf:	6a 00                	push   $0x0
  pushl $102
  1010d1:	6a 66                	push   $0x66
  jmp __alltraps
  1010d3:	e9 e1 06 00 00       	jmp    1017b9 <__alltraps>

001010d8 <vector103>:
.globl vector103
vector103:
  pushl $0
  1010d8:	6a 00                	push   $0x0
  pushl $103
  1010da:	6a 67                	push   $0x67
  jmp __alltraps
  1010dc:	e9 d8 06 00 00       	jmp    1017b9 <__alltraps>

001010e1 <vector104>:
.globl vector104
vector104:
  pushl $0
  1010e1:	6a 00                	push   $0x0
  pushl $104
  1010e3:	6a 68                	push   $0x68
  jmp __alltraps
  1010e5:	e9 cf 06 00 00       	jmp    1017b9 <__alltraps>

001010ea <vector105>:
.globl vector105
vector105:
  pushl $0
  1010ea:	6a 00                	push   $0x0
  pushl $105
  1010ec:	6a 69                	push   $0x69
  jmp __alltraps
  1010ee:	e9 c6 06 00 00       	jmp    1017b9 <__alltraps>

001010f3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1010f3:	6a 00                	push   $0x0
  pushl $106
  1010f5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1010f7:	e9 bd 06 00 00       	jmp    1017b9 <__alltraps>

001010fc <vector107>:
.globl vector107
vector107:
  pushl $0
  1010fc:	6a 00                	push   $0x0
  pushl $107
  1010fe:	6a 6b                	push   $0x6b
  jmp __alltraps
  101100:	e9 b4 06 00 00       	jmp    1017b9 <__alltraps>

00101105 <vector108>:
.globl vector108
vector108:
  pushl $0
  101105:	6a 00                	push   $0x0
  pushl $108
  101107:	6a 6c                	push   $0x6c
  jmp __alltraps
  101109:	e9 ab 06 00 00       	jmp    1017b9 <__alltraps>

0010110e <vector109>:
.globl vector109
vector109:
  pushl $0
  10110e:	6a 00                	push   $0x0
  pushl $109
  101110:	6a 6d                	push   $0x6d
  jmp __alltraps
  101112:	e9 a2 06 00 00       	jmp    1017b9 <__alltraps>

00101117 <vector110>:
.globl vector110
vector110:
  pushl $0
  101117:	6a 00                	push   $0x0
  pushl $110
  101119:	6a 6e                	push   $0x6e
  jmp __alltraps
  10111b:	e9 99 06 00 00       	jmp    1017b9 <__alltraps>

00101120 <vector111>:
.globl vector111
vector111:
  pushl $0
  101120:	6a 00                	push   $0x0
  pushl $111
  101122:	6a 6f                	push   $0x6f
  jmp __alltraps
  101124:	e9 90 06 00 00       	jmp    1017b9 <__alltraps>

00101129 <vector112>:
.globl vector112
vector112:
  pushl $0
  101129:	6a 00                	push   $0x0
  pushl $112
  10112b:	6a 70                	push   $0x70
  jmp __alltraps
  10112d:	e9 87 06 00 00       	jmp    1017b9 <__alltraps>

00101132 <vector113>:
.globl vector113
vector113:
  pushl $0
  101132:	6a 00                	push   $0x0
  pushl $113
  101134:	6a 71                	push   $0x71
  jmp __alltraps
  101136:	e9 7e 06 00 00       	jmp    1017b9 <__alltraps>

0010113b <vector114>:
.globl vector114
vector114:
  pushl $0
  10113b:	6a 00                	push   $0x0
  pushl $114
  10113d:	6a 72                	push   $0x72
  jmp __alltraps
  10113f:	e9 75 06 00 00       	jmp    1017b9 <__alltraps>

00101144 <vector115>:
.globl vector115
vector115:
  pushl $0
  101144:	6a 00                	push   $0x0
  pushl $115
  101146:	6a 73                	push   $0x73
  jmp __alltraps
  101148:	e9 6c 06 00 00       	jmp    1017b9 <__alltraps>

0010114d <vector116>:
.globl vector116
vector116:
  pushl $0
  10114d:	6a 00                	push   $0x0
  pushl $116
  10114f:	6a 74                	push   $0x74
  jmp __alltraps
  101151:	e9 63 06 00 00       	jmp    1017b9 <__alltraps>

00101156 <vector117>:
.globl vector117
vector117:
  pushl $0
  101156:	6a 00                	push   $0x0
  pushl $117
  101158:	6a 75                	push   $0x75
  jmp __alltraps
  10115a:	e9 5a 06 00 00       	jmp    1017b9 <__alltraps>

0010115f <vector118>:
.globl vector118
vector118:
  pushl $0
  10115f:	6a 00                	push   $0x0
  pushl $118
  101161:	6a 76                	push   $0x76
  jmp __alltraps
  101163:	e9 51 06 00 00       	jmp    1017b9 <__alltraps>

00101168 <vector119>:
.globl vector119
vector119:
  pushl $0
  101168:	6a 00                	push   $0x0
  pushl $119
  10116a:	6a 77                	push   $0x77
  jmp __alltraps
  10116c:	e9 48 06 00 00       	jmp    1017b9 <__alltraps>

00101171 <vector120>:
.globl vector120
vector120:
  pushl $0
  101171:	6a 00                	push   $0x0
  pushl $120
  101173:	6a 78                	push   $0x78
  jmp __alltraps
  101175:	e9 3f 06 00 00       	jmp    1017b9 <__alltraps>

0010117a <vector121>:
.globl vector121
vector121:
  pushl $0
  10117a:	6a 00                	push   $0x0
  pushl $121
  10117c:	6a 79                	push   $0x79
  jmp __alltraps
  10117e:	e9 36 06 00 00       	jmp    1017b9 <__alltraps>

00101183 <vector122>:
.globl vector122
vector122:
  pushl $0
  101183:	6a 00                	push   $0x0
  pushl $122
  101185:	6a 7a                	push   $0x7a
  jmp __alltraps
  101187:	e9 2d 06 00 00       	jmp    1017b9 <__alltraps>

0010118c <vector123>:
.globl vector123
vector123:
  pushl $0
  10118c:	6a 00                	push   $0x0
  pushl $123
  10118e:	6a 7b                	push   $0x7b
  jmp __alltraps
  101190:	e9 24 06 00 00       	jmp    1017b9 <__alltraps>

00101195 <vector124>:
.globl vector124
vector124:
  pushl $0
  101195:	6a 00                	push   $0x0
  pushl $124
  101197:	6a 7c                	push   $0x7c
  jmp __alltraps
  101199:	e9 1b 06 00 00       	jmp    1017b9 <__alltraps>

0010119e <vector125>:
.globl vector125
vector125:
  pushl $0
  10119e:	6a 00                	push   $0x0
  pushl $125
  1011a0:	6a 7d                	push   $0x7d
  jmp __alltraps
  1011a2:	e9 12 06 00 00       	jmp    1017b9 <__alltraps>

001011a7 <vector126>:
.globl vector126
vector126:
  pushl $0
  1011a7:	6a 00                	push   $0x0
  pushl $126
  1011a9:	6a 7e                	push   $0x7e
  jmp __alltraps
  1011ab:	e9 09 06 00 00       	jmp    1017b9 <__alltraps>

001011b0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1011b0:	6a 00                	push   $0x0
  pushl $127
  1011b2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1011b4:	e9 00 06 00 00       	jmp    1017b9 <__alltraps>

001011b9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1011b9:	6a 00                	push   $0x0
  pushl $128
  1011bb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1011c0:	e9 f4 05 00 00       	jmp    1017b9 <__alltraps>

001011c5 <vector129>:
.globl vector129
vector129:
  pushl $0
  1011c5:	6a 00                	push   $0x0
  pushl $129
  1011c7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1011cc:	e9 e8 05 00 00       	jmp    1017b9 <__alltraps>

001011d1 <vector130>:
.globl vector130
vector130:
  pushl $0
  1011d1:	6a 00                	push   $0x0
  pushl $130
  1011d3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1011d8:	e9 dc 05 00 00       	jmp    1017b9 <__alltraps>

001011dd <vector131>:
.globl vector131
vector131:
  pushl $0
  1011dd:	6a 00                	push   $0x0
  pushl $131
  1011df:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1011e4:	e9 d0 05 00 00       	jmp    1017b9 <__alltraps>

001011e9 <vector132>:
.globl vector132
vector132:
  pushl $0
  1011e9:	6a 00                	push   $0x0
  pushl $132
  1011eb:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1011f0:	e9 c4 05 00 00       	jmp    1017b9 <__alltraps>

001011f5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1011f5:	6a 00                	push   $0x0
  pushl $133
  1011f7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1011fc:	e9 b8 05 00 00       	jmp    1017b9 <__alltraps>

00101201 <vector134>:
.globl vector134
vector134:
  pushl $0
  101201:	6a 00                	push   $0x0
  pushl $134
  101203:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  101208:	e9 ac 05 00 00       	jmp    1017b9 <__alltraps>

0010120d <vector135>:
.globl vector135
vector135:
  pushl $0
  10120d:	6a 00                	push   $0x0
  pushl $135
  10120f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  101214:	e9 a0 05 00 00       	jmp    1017b9 <__alltraps>

00101219 <vector136>:
.globl vector136
vector136:
  pushl $0
  101219:	6a 00                	push   $0x0
  pushl $136
  10121b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  101220:	e9 94 05 00 00       	jmp    1017b9 <__alltraps>

00101225 <vector137>:
.globl vector137
vector137:
  pushl $0
  101225:	6a 00                	push   $0x0
  pushl $137
  101227:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10122c:	e9 88 05 00 00       	jmp    1017b9 <__alltraps>

00101231 <vector138>:
.globl vector138
vector138:
  pushl $0
  101231:	6a 00                	push   $0x0
  pushl $138
  101233:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  101238:	e9 7c 05 00 00       	jmp    1017b9 <__alltraps>

0010123d <vector139>:
.globl vector139
vector139:
  pushl $0
  10123d:	6a 00                	push   $0x0
  pushl $139
  10123f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  101244:	e9 70 05 00 00       	jmp    1017b9 <__alltraps>

00101249 <vector140>:
.globl vector140
vector140:
  pushl $0
  101249:	6a 00                	push   $0x0
  pushl $140
  10124b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  101250:	e9 64 05 00 00       	jmp    1017b9 <__alltraps>

00101255 <vector141>:
.globl vector141
vector141:
  pushl $0
  101255:	6a 00                	push   $0x0
  pushl $141
  101257:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10125c:	e9 58 05 00 00       	jmp    1017b9 <__alltraps>

00101261 <vector142>:
.globl vector142
vector142:
  pushl $0
  101261:	6a 00                	push   $0x0
  pushl $142
  101263:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  101268:	e9 4c 05 00 00       	jmp    1017b9 <__alltraps>

0010126d <vector143>:
.globl vector143
vector143:
  pushl $0
  10126d:	6a 00                	push   $0x0
  pushl $143
  10126f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  101274:	e9 40 05 00 00       	jmp    1017b9 <__alltraps>

00101279 <vector144>:
.globl vector144
vector144:
  pushl $0
  101279:	6a 00                	push   $0x0
  pushl $144
  10127b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  101280:	e9 34 05 00 00       	jmp    1017b9 <__alltraps>

00101285 <vector145>:
.globl vector145
vector145:
  pushl $0
  101285:	6a 00                	push   $0x0
  pushl $145
  101287:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10128c:	e9 28 05 00 00       	jmp    1017b9 <__alltraps>

00101291 <vector146>:
.globl vector146
vector146:
  pushl $0
  101291:	6a 00                	push   $0x0
  pushl $146
  101293:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  101298:	e9 1c 05 00 00       	jmp    1017b9 <__alltraps>

0010129d <vector147>:
.globl vector147
vector147:
  pushl $0
  10129d:	6a 00                	push   $0x0
  pushl $147
  10129f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1012a4:	e9 10 05 00 00       	jmp    1017b9 <__alltraps>

001012a9 <vector148>:
.globl vector148
vector148:
  pushl $0
  1012a9:	6a 00                	push   $0x0
  pushl $148
  1012ab:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1012b0:	e9 04 05 00 00       	jmp    1017b9 <__alltraps>

001012b5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1012b5:	6a 00                	push   $0x0
  pushl $149
  1012b7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1012bc:	e9 f8 04 00 00       	jmp    1017b9 <__alltraps>

001012c1 <vector150>:
.globl vector150
vector150:
  pushl $0
  1012c1:	6a 00                	push   $0x0
  pushl $150
  1012c3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1012c8:	e9 ec 04 00 00       	jmp    1017b9 <__alltraps>

001012cd <vector151>:
.globl vector151
vector151:
  pushl $0
  1012cd:	6a 00                	push   $0x0
  pushl $151
  1012cf:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1012d4:	e9 e0 04 00 00       	jmp    1017b9 <__alltraps>

001012d9 <vector152>:
.globl vector152
vector152:
  pushl $0
  1012d9:	6a 00                	push   $0x0
  pushl $152
  1012db:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1012e0:	e9 d4 04 00 00       	jmp    1017b9 <__alltraps>

001012e5 <vector153>:
.globl vector153
vector153:
  pushl $0
  1012e5:	6a 00                	push   $0x0
  pushl $153
  1012e7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1012ec:	e9 c8 04 00 00       	jmp    1017b9 <__alltraps>

001012f1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1012f1:	6a 00                	push   $0x0
  pushl $154
  1012f3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1012f8:	e9 bc 04 00 00       	jmp    1017b9 <__alltraps>

001012fd <vector155>:
.globl vector155
vector155:
  pushl $0
  1012fd:	6a 00                	push   $0x0
  pushl $155
  1012ff:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  101304:	e9 b0 04 00 00       	jmp    1017b9 <__alltraps>

00101309 <vector156>:
.globl vector156
vector156:
  pushl $0
  101309:	6a 00                	push   $0x0
  pushl $156
  10130b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  101310:	e9 a4 04 00 00       	jmp    1017b9 <__alltraps>

00101315 <vector157>:
.globl vector157
vector157:
  pushl $0
  101315:	6a 00                	push   $0x0
  pushl $157
  101317:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10131c:	e9 98 04 00 00       	jmp    1017b9 <__alltraps>

00101321 <vector158>:
.globl vector158
vector158:
  pushl $0
  101321:	6a 00                	push   $0x0
  pushl $158
  101323:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  101328:	e9 8c 04 00 00       	jmp    1017b9 <__alltraps>

0010132d <vector159>:
.globl vector159
vector159:
  pushl $0
  10132d:	6a 00                	push   $0x0
  pushl $159
  10132f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  101334:	e9 80 04 00 00       	jmp    1017b9 <__alltraps>

00101339 <vector160>:
.globl vector160
vector160:
  pushl $0
  101339:	6a 00                	push   $0x0
  pushl $160
  10133b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  101340:	e9 74 04 00 00       	jmp    1017b9 <__alltraps>

00101345 <vector161>:
.globl vector161
vector161:
  pushl $0
  101345:	6a 00                	push   $0x0
  pushl $161
  101347:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10134c:	e9 68 04 00 00       	jmp    1017b9 <__alltraps>

00101351 <vector162>:
.globl vector162
vector162:
  pushl $0
  101351:	6a 00                	push   $0x0
  pushl $162
  101353:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  101358:	e9 5c 04 00 00       	jmp    1017b9 <__alltraps>

0010135d <vector163>:
.globl vector163
vector163:
  pushl $0
  10135d:	6a 00                	push   $0x0
  pushl $163
  10135f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  101364:	e9 50 04 00 00       	jmp    1017b9 <__alltraps>

00101369 <vector164>:
.globl vector164
vector164:
  pushl $0
  101369:	6a 00                	push   $0x0
  pushl $164
  10136b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  101370:	e9 44 04 00 00       	jmp    1017b9 <__alltraps>

00101375 <vector165>:
.globl vector165
vector165:
  pushl $0
  101375:	6a 00                	push   $0x0
  pushl $165
  101377:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10137c:	e9 38 04 00 00       	jmp    1017b9 <__alltraps>

00101381 <vector166>:
.globl vector166
vector166:
  pushl $0
  101381:	6a 00                	push   $0x0
  pushl $166
  101383:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  101388:	e9 2c 04 00 00       	jmp    1017b9 <__alltraps>

0010138d <vector167>:
.globl vector167
vector167:
  pushl $0
  10138d:	6a 00                	push   $0x0
  pushl $167
  10138f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  101394:	e9 20 04 00 00       	jmp    1017b9 <__alltraps>

00101399 <vector168>:
.globl vector168
vector168:
  pushl $0
  101399:	6a 00                	push   $0x0
  pushl $168
  10139b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1013a0:	e9 14 04 00 00       	jmp    1017b9 <__alltraps>

001013a5 <vector169>:
.globl vector169
vector169:
  pushl $0
  1013a5:	6a 00                	push   $0x0
  pushl $169
  1013a7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1013ac:	e9 08 04 00 00       	jmp    1017b9 <__alltraps>

001013b1 <vector170>:
.globl vector170
vector170:
  pushl $0
  1013b1:	6a 00                	push   $0x0
  pushl $170
  1013b3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1013b8:	e9 fc 03 00 00       	jmp    1017b9 <__alltraps>

001013bd <vector171>:
.globl vector171
vector171:
  pushl $0
  1013bd:	6a 00                	push   $0x0
  pushl $171
  1013bf:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1013c4:	e9 f0 03 00 00       	jmp    1017b9 <__alltraps>

001013c9 <vector172>:
.globl vector172
vector172:
  pushl $0
  1013c9:	6a 00                	push   $0x0
  pushl $172
  1013cb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1013d0:	e9 e4 03 00 00       	jmp    1017b9 <__alltraps>

001013d5 <vector173>:
.globl vector173
vector173:
  pushl $0
  1013d5:	6a 00                	push   $0x0
  pushl $173
  1013d7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1013dc:	e9 d8 03 00 00       	jmp    1017b9 <__alltraps>

001013e1 <vector174>:
.globl vector174
vector174:
  pushl $0
  1013e1:	6a 00                	push   $0x0
  pushl $174
  1013e3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1013e8:	e9 cc 03 00 00       	jmp    1017b9 <__alltraps>

001013ed <vector175>:
.globl vector175
vector175:
  pushl $0
  1013ed:	6a 00                	push   $0x0
  pushl $175
  1013ef:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1013f4:	e9 c0 03 00 00       	jmp    1017b9 <__alltraps>

001013f9 <vector176>:
.globl vector176
vector176:
  pushl $0
  1013f9:	6a 00                	push   $0x0
  pushl $176
  1013fb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  101400:	e9 b4 03 00 00       	jmp    1017b9 <__alltraps>

00101405 <vector177>:
.globl vector177
vector177:
  pushl $0
  101405:	6a 00                	push   $0x0
  pushl $177
  101407:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10140c:	e9 a8 03 00 00       	jmp    1017b9 <__alltraps>

00101411 <vector178>:
.globl vector178
vector178:
  pushl $0
  101411:	6a 00                	push   $0x0
  pushl $178
  101413:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  101418:	e9 9c 03 00 00       	jmp    1017b9 <__alltraps>

0010141d <vector179>:
.globl vector179
vector179:
  pushl $0
  10141d:	6a 00                	push   $0x0
  pushl $179
  10141f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  101424:	e9 90 03 00 00       	jmp    1017b9 <__alltraps>

00101429 <vector180>:
.globl vector180
vector180:
  pushl $0
  101429:	6a 00                	push   $0x0
  pushl $180
  10142b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  101430:	e9 84 03 00 00       	jmp    1017b9 <__alltraps>

00101435 <vector181>:
.globl vector181
vector181:
  pushl $0
  101435:	6a 00                	push   $0x0
  pushl $181
  101437:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10143c:	e9 78 03 00 00       	jmp    1017b9 <__alltraps>

00101441 <vector182>:
.globl vector182
vector182:
  pushl $0
  101441:	6a 00                	push   $0x0
  pushl $182
  101443:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  101448:	e9 6c 03 00 00       	jmp    1017b9 <__alltraps>

0010144d <vector183>:
.globl vector183
vector183:
  pushl $0
  10144d:	6a 00                	push   $0x0
  pushl $183
  10144f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  101454:	e9 60 03 00 00       	jmp    1017b9 <__alltraps>

00101459 <vector184>:
.globl vector184
vector184:
  pushl $0
  101459:	6a 00                	push   $0x0
  pushl $184
  10145b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  101460:	e9 54 03 00 00       	jmp    1017b9 <__alltraps>

00101465 <vector185>:
.globl vector185
vector185:
  pushl $0
  101465:	6a 00                	push   $0x0
  pushl $185
  101467:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10146c:	e9 48 03 00 00       	jmp    1017b9 <__alltraps>

00101471 <vector186>:
.globl vector186
vector186:
  pushl $0
  101471:	6a 00                	push   $0x0
  pushl $186
  101473:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  101478:	e9 3c 03 00 00       	jmp    1017b9 <__alltraps>

0010147d <vector187>:
.globl vector187
vector187:
  pushl $0
  10147d:	6a 00                	push   $0x0
  pushl $187
  10147f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  101484:	e9 30 03 00 00       	jmp    1017b9 <__alltraps>

00101489 <vector188>:
.globl vector188
vector188:
  pushl $0
  101489:	6a 00                	push   $0x0
  pushl $188
  10148b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  101490:	e9 24 03 00 00       	jmp    1017b9 <__alltraps>

00101495 <vector189>:
.globl vector189
vector189:
  pushl $0
  101495:	6a 00                	push   $0x0
  pushl $189
  101497:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10149c:	e9 18 03 00 00       	jmp    1017b9 <__alltraps>

001014a1 <vector190>:
.globl vector190
vector190:
  pushl $0
  1014a1:	6a 00                	push   $0x0
  pushl $190
  1014a3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1014a8:	e9 0c 03 00 00       	jmp    1017b9 <__alltraps>

001014ad <vector191>:
.globl vector191
vector191:
  pushl $0
  1014ad:	6a 00                	push   $0x0
  pushl $191
  1014af:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1014b4:	e9 00 03 00 00       	jmp    1017b9 <__alltraps>

001014b9 <vector192>:
.globl vector192
vector192:
  pushl $0
  1014b9:	6a 00                	push   $0x0
  pushl $192
  1014bb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1014c0:	e9 f4 02 00 00       	jmp    1017b9 <__alltraps>

001014c5 <vector193>:
.globl vector193
vector193:
  pushl $0
  1014c5:	6a 00                	push   $0x0
  pushl $193
  1014c7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1014cc:	e9 e8 02 00 00       	jmp    1017b9 <__alltraps>

001014d1 <vector194>:
.globl vector194
vector194:
  pushl $0
  1014d1:	6a 00                	push   $0x0
  pushl $194
  1014d3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1014d8:	e9 dc 02 00 00       	jmp    1017b9 <__alltraps>

001014dd <vector195>:
.globl vector195
vector195:
  pushl $0
  1014dd:	6a 00                	push   $0x0
  pushl $195
  1014df:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1014e4:	e9 d0 02 00 00       	jmp    1017b9 <__alltraps>

001014e9 <vector196>:
.globl vector196
vector196:
  pushl $0
  1014e9:	6a 00                	push   $0x0
  pushl $196
  1014eb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1014f0:	e9 c4 02 00 00       	jmp    1017b9 <__alltraps>

001014f5 <vector197>:
.globl vector197
vector197:
  pushl $0
  1014f5:	6a 00                	push   $0x0
  pushl $197
  1014f7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1014fc:	e9 b8 02 00 00       	jmp    1017b9 <__alltraps>

00101501 <vector198>:
.globl vector198
vector198:
  pushl $0
  101501:	6a 00                	push   $0x0
  pushl $198
  101503:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  101508:	e9 ac 02 00 00       	jmp    1017b9 <__alltraps>

0010150d <vector199>:
.globl vector199
vector199:
  pushl $0
  10150d:	6a 00                	push   $0x0
  pushl $199
  10150f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  101514:	e9 a0 02 00 00       	jmp    1017b9 <__alltraps>

00101519 <vector200>:
.globl vector200
vector200:
  pushl $0
  101519:	6a 00                	push   $0x0
  pushl $200
  10151b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  101520:	e9 94 02 00 00       	jmp    1017b9 <__alltraps>

00101525 <vector201>:
.globl vector201
vector201:
  pushl $0
  101525:	6a 00                	push   $0x0
  pushl $201
  101527:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10152c:	e9 88 02 00 00       	jmp    1017b9 <__alltraps>

00101531 <vector202>:
.globl vector202
vector202:
  pushl $0
  101531:	6a 00                	push   $0x0
  pushl $202
  101533:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  101538:	e9 7c 02 00 00       	jmp    1017b9 <__alltraps>

0010153d <vector203>:
.globl vector203
vector203:
  pushl $0
  10153d:	6a 00                	push   $0x0
  pushl $203
  10153f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  101544:	e9 70 02 00 00       	jmp    1017b9 <__alltraps>

00101549 <vector204>:
.globl vector204
vector204:
  pushl $0
  101549:	6a 00                	push   $0x0
  pushl $204
  10154b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  101550:	e9 64 02 00 00       	jmp    1017b9 <__alltraps>

00101555 <vector205>:
.globl vector205
vector205:
  pushl $0
  101555:	6a 00                	push   $0x0
  pushl $205
  101557:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10155c:	e9 58 02 00 00       	jmp    1017b9 <__alltraps>

00101561 <vector206>:
.globl vector206
vector206:
  pushl $0
  101561:	6a 00                	push   $0x0
  pushl $206
  101563:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  101568:	e9 4c 02 00 00       	jmp    1017b9 <__alltraps>

0010156d <vector207>:
.globl vector207
vector207:
  pushl $0
  10156d:	6a 00                	push   $0x0
  pushl $207
  10156f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  101574:	e9 40 02 00 00       	jmp    1017b9 <__alltraps>

00101579 <vector208>:
.globl vector208
vector208:
  pushl $0
  101579:	6a 00                	push   $0x0
  pushl $208
  10157b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  101580:	e9 34 02 00 00       	jmp    1017b9 <__alltraps>

00101585 <vector209>:
.globl vector209
vector209:
  pushl $0
  101585:	6a 00                	push   $0x0
  pushl $209
  101587:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10158c:	e9 28 02 00 00       	jmp    1017b9 <__alltraps>

00101591 <vector210>:
.globl vector210
vector210:
  pushl $0
  101591:	6a 00                	push   $0x0
  pushl $210
  101593:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  101598:	e9 1c 02 00 00       	jmp    1017b9 <__alltraps>

0010159d <vector211>:
.globl vector211
vector211:
  pushl $0
  10159d:	6a 00                	push   $0x0
  pushl $211
  10159f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1015a4:	e9 10 02 00 00       	jmp    1017b9 <__alltraps>

001015a9 <vector212>:
.globl vector212
vector212:
  pushl $0
  1015a9:	6a 00                	push   $0x0
  pushl $212
  1015ab:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1015b0:	e9 04 02 00 00       	jmp    1017b9 <__alltraps>

001015b5 <vector213>:
.globl vector213
vector213:
  pushl $0
  1015b5:	6a 00                	push   $0x0
  pushl $213
  1015b7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1015bc:	e9 f8 01 00 00       	jmp    1017b9 <__alltraps>

001015c1 <vector214>:
.globl vector214
vector214:
  pushl $0
  1015c1:	6a 00                	push   $0x0
  pushl $214
  1015c3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1015c8:	e9 ec 01 00 00       	jmp    1017b9 <__alltraps>

001015cd <vector215>:
.globl vector215
vector215:
  pushl $0
  1015cd:	6a 00                	push   $0x0
  pushl $215
  1015cf:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1015d4:	e9 e0 01 00 00       	jmp    1017b9 <__alltraps>

001015d9 <vector216>:
.globl vector216
vector216:
  pushl $0
  1015d9:	6a 00                	push   $0x0
  pushl $216
  1015db:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1015e0:	e9 d4 01 00 00       	jmp    1017b9 <__alltraps>

001015e5 <vector217>:
.globl vector217
vector217:
  pushl $0
  1015e5:	6a 00                	push   $0x0
  pushl $217
  1015e7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1015ec:	e9 c8 01 00 00       	jmp    1017b9 <__alltraps>

001015f1 <vector218>:
.globl vector218
vector218:
  pushl $0
  1015f1:	6a 00                	push   $0x0
  pushl $218
  1015f3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1015f8:	e9 bc 01 00 00       	jmp    1017b9 <__alltraps>

001015fd <vector219>:
.globl vector219
vector219:
  pushl $0
  1015fd:	6a 00                	push   $0x0
  pushl $219
  1015ff:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  101604:	e9 b0 01 00 00       	jmp    1017b9 <__alltraps>

00101609 <vector220>:
.globl vector220
vector220:
  pushl $0
  101609:	6a 00                	push   $0x0
  pushl $220
  10160b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  101610:	e9 a4 01 00 00       	jmp    1017b9 <__alltraps>

00101615 <vector221>:
.globl vector221
vector221:
  pushl $0
  101615:	6a 00                	push   $0x0
  pushl $221
  101617:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10161c:	e9 98 01 00 00       	jmp    1017b9 <__alltraps>

00101621 <vector222>:
.globl vector222
vector222:
  pushl $0
  101621:	6a 00                	push   $0x0
  pushl $222
  101623:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  101628:	e9 8c 01 00 00       	jmp    1017b9 <__alltraps>

0010162d <vector223>:
.globl vector223
vector223:
  pushl $0
  10162d:	6a 00                	push   $0x0
  pushl $223
  10162f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  101634:	e9 80 01 00 00       	jmp    1017b9 <__alltraps>

00101639 <vector224>:
.globl vector224
vector224:
  pushl $0
  101639:	6a 00                	push   $0x0
  pushl $224
  10163b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  101640:	e9 74 01 00 00       	jmp    1017b9 <__alltraps>

00101645 <vector225>:
.globl vector225
vector225:
  pushl $0
  101645:	6a 00                	push   $0x0
  pushl $225
  101647:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10164c:	e9 68 01 00 00       	jmp    1017b9 <__alltraps>

00101651 <vector226>:
.globl vector226
vector226:
  pushl $0
  101651:	6a 00                	push   $0x0
  pushl $226
  101653:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  101658:	e9 5c 01 00 00       	jmp    1017b9 <__alltraps>

0010165d <vector227>:
.globl vector227
vector227:
  pushl $0
  10165d:	6a 00                	push   $0x0
  pushl $227
  10165f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  101664:	e9 50 01 00 00       	jmp    1017b9 <__alltraps>

00101669 <vector228>:
.globl vector228
vector228:
  pushl $0
  101669:	6a 00                	push   $0x0
  pushl $228
  10166b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  101670:	e9 44 01 00 00       	jmp    1017b9 <__alltraps>

00101675 <vector229>:
.globl vector229
vector229:
  pushl $0
  101675:	6a 00                	push   $0x0
  pushl $229
  101677:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10167c:	e9 38 01 00 00       	jmp    1017b9 <__alltraps>

00101681 <vector230>:
.globl vector230
vector230:
  pushl $0
  101681:	6a 00                	push   $0x0
  pushl $230
  101683:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  101688:	e9 2c 01 00 00       	jmp    1017b9 <__alltraps>

0010168d <vector231>:
.globl vector231
vector231:
  pushl $0
  10168d:	6a 00                	push   $0x0
  pushl $231
  10168f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  101694:	e9 20 01 00 00       	jmp    1017b9 <__alltraps>

00101699 <vector232>:
.globl vector232
vector232:
  pushl $0
  101699:	6a 00                	push   $0x0
  pushl $232
  10169b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1016a0:	e9 14 01 00 00       	jmp    1017b9 <__alltraps>

001016a5 <vector233>:
.globl vector233
vector233:
  pushl $0
  1016a5:	6a 00                	push   $0x0
  pushl $233
  1016a7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1016ac:	e9 08 01 00 00       	jmp    1017b9 <__alltraps>

001016b1 <vector234>:
.globl vector234
vector234:
  pushl $0
  1016b1:	6a 00                	push   $0x0
  pushl $234
  1016b3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1016b8:	e9 fc 00 00 00       	jmp    1017b9 <__alltraps>

001016bd <vector235>:
.globl vector235
vector235:
  pushl $0
  1016bd:	6a 00                	push   $0x0
  pushl $235
  1016bf:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1016c4:	e9 f0 00 00 00       	jmp    1017b9 <__alltraps>

001016c9 <vector236>:
.globl vector236
vector236:
  pushl $0
  1016c9:	6a 00                	push   $0x0
  pushl $236
  1016cb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1016d0:	e9 e4 00 00 00       	jmp    1017b9 <__alltraps>

001016d5 <vector237>:
.globl vector237
vector237:
  pushl $0
  1016d5:	6a 00                	push   $0x0
  pushl $237
  1016d7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1016dc:	e9 d8 00 00 00       	jmp    1017b9 <__alltraps>

001016e1 <vector238>:
.globl vector238
vector238:
  pushl $0
  1016e1:	6a 00                	push   $0x0
  pushl $238
  1016e3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1016e8:	e9 cc 00 00 00       	jmp    1017b9 <__alltraps>

001016ed <vector239>:
.globl vector239
vector239:
  pushl $0
  1016ed:	6a 00                	push   $0x0
  pushl $239
  1016ef:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1016f4:	e9 c0 00 00 00       	jmp    1017b9 <__alltraps>

001016f9 <vector240>:
.globl vector240
vector240:
  pushl $0
  1016f9:	6a 00                	push   $0x0
  pushl $240
  1016fb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  101700:	e9 b4 00 00 00       	jmp    1017b9 <__alltraps>

00101705 <vector241>:
.globl vector241
vector241:
  pushl $0
  101705:	6a 00                	push   $0x0
  pushl $241
  101707:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10170c:	e9 a8 00 00 00       	jmp    1017b9 <__alltraps>

00101711 <vector242>:
.globl vector242
vector242:
  pushl $0
  101711:	6a 00                	push   $0x0
  pushl $242
  101713:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  101718:	e9 9c 00 00 00       	jmp    1017b9 <__alltraps>

0010171d <vector243>:
.globl vector243
vector243:
  pushl $0
  10171d:	6a 00                	push   $0x0
  pushl $243
  10171f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  101724:	e9 90 00 00 00       	jmp    1017b9 <__alltraps>

00101729 <vector244>:
.globl vector244
vector244:
  pushl $0
  101729:	6a 00                	push   $0x0
  pushl $244
  10172b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  101730:	e9 84 00 00 00       	jmp    1017b9 <__alltraps>

00101735 <vector245>:
.globl vector245
vector245:
  pushl $0
  101735:	6a 00                	push   $0x0
  pushl $245
  101737:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10173c:	e9 78 00 00 00       	jmp    1017b9 <__alltraps>

00101741 <vector246>:
.globl vector246
vector246:
  pushl $0
  101741:	6a 00                	push   $0x0
  pushl $246
  101743:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  101748:	e9 6c 00 00 00       	jmp    1017b9 <__alltraps>

0010174d <vector247>:
.globl vector247
vector247:
  pushl $0
  10174d:	6a 00                	push   $0x0
  pushl $247
  10174f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  101754:	e9 60 00 00 00       	jmp    1017b9 <__alltraps>

00101759 <vector248>:
.globl vector248
vector248:
  pushl $0
  101759:	6a 00                	push   $0x0
  pushl $248
  10175b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  101760:	e9 54 00 00 00       	jmp    1017b9 <__alltraps>

00101765 <vector249>:
.globl vector249
vector249:
  pushl $0
  101765:	6a 00                	push   $0x0
  pushl $249
  101767:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10176c:	e9 48 00 00 00       	jmp    1017b9 <__alltraps>

00101771 <vector250>:
.globl vector250
vector250:
  pushl $0
  101771:	6a 00                	push   $0x0
  pushl $250
  101773:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  101778:	e9 3c 00 00 00       	jmp    1017b9 <__alltraps>

0010177d <vector251>:
.globl vector251
vector251:
  pushl $0
  10177d:	6a 00                	push   $0x0
  pushl $251
  10177f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  101784:	e9 30 00 00 00       	jmp    1017b9 <__alltraps>

00101789 <vector252>:
.globl vector252
vector252:
  pushl $0
  101789:	6a 00                	push   $0x0
  pushl $252
  10178b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  101790:	e9 24 00 00 00       	jmp    1017b9 <__alltraps>

00101795 <vector253>:
.globl vector253
vector253:
  pushl $0
  101795:	6a 00                	push   $0x0
  pushl $253
  101797:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10179c:	e9 18 00 00 00       	jmp    1017b9 <__alltraps>

001017a1 <vector254>:
.globl vector254
vector254:
  pushl $0
  1017a1:	6a 00                	push   $0x0
  pushl $254
  1017a3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1017a8:	e9 0c 00 00 00       	jmp    1017b9 <__alltraps>

001017ad <vector255>:
.globl vector255
vector255:
  pushl $0
  1017ad:	6a 00                	push   $0x0
  pushl $255
  1017af:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1017b4:	e9 00 00 00 00       	jmp    1017b9 <__alltraps>

001017b9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1017b9:	1e                   	push   %ds
    pushl %es
  1017ba:	06                   	push   %es
    pushal
  1017bb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1017bc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1017c1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1017c3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1017c5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1017c6:	e8 67 f5 ff ff       	call   100d32 <trap>

    # pop the pushed stack pointer
    popl %esp
  1017cb:	5c                   	pop    %esp

001017cc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1017cc:	61                   	popa   

    # restore %ds and %es
    popl %es
  1017cd:	07                   	pop    %es
    popl %ds
  1017ce:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1017cf:	83 c4 08             	add    $0x8,%esp
    iret
  1017d2:	cf                   	iret   

001017d3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1017d3:	55                   	push   %ebp
  1017d4:	89 e5                	mov    %esp,%ebp
  1017d6:	83 ec 10             	sub    $0x10,%esp
	size_t cnt = 0;
  1017d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (*s ++ != '\0') {
  1017e0:	eb 04                	jmp    1017e6 <strlen+0x13>
		cnt++;
  1017e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
	size_t cnt = 0;
	while (*s ++ != '\0') {
  1017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e9:	8d 50 01             	lea    0x1(%eax),%edx
  1017ec:	89 55 08             	mov    %edx,0x8(%ebp)
  1017ef:	0f b6 00             	movzbl (%eax),%eax
  1017f2:	84 c0                	test   %al,%al
  1017f4:	75 ec                	jne    1017e2 <strlen+0xf>
		cnt++;
	}
	return cnt;
  1017f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1017f9:	c9                   	leave  
  1017fa:	c3                   	ret    

001017fb <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  1017fb:	55                   	push   %ebp
  1017fc:	89 e5                	mov    %esp,%ebp
  1017fe:	83 ec 14             	sub    $0x14,%esp
  101801:	8b 45 0c             	mov    0xc(%ebp),%eax
  101804:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  101807:	8b 45 08             	mov    0x8(%ebp),%eax
  10180a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  10180d:	eb 0f                	jmp    10181e <memset+0x23>
		*p ++ = c;
  10180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101812:	8d 50 01             	lea    0x1(%eax),%edx
  101815:	89 55 fc             	mov    %edx,-0x4(%ebp)
  101818:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  10181c:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  10181e:	8b 45 10             	mov    0x10(%ebp),%eax
  101821:	8d 50 ff             	lea    -0x1(%eax),%edx
  101824:	89 55 10             	mov    %edx,0x10(%ebp)
  101827:	85 c0                	test   %eax,%eax
  101829:	75 e4                	jne    10180f <memset+0x14>
		*p ++ = c;
	}
	return s;
  10182b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10182e:	c9                   	leave  
  10182f:	c3                   	ret    

00101830 <memmove>:
/*
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
  101830:	55                   	push   %ebp
  101831:	89 e5                	mov    %esp,%ebp
  101833:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  101836:	8b 45 0c             	mov    0xc(%ebp),%eax
  101839:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  10183c:	8b 45 08             	mov    0x8(%ebp),%eax
  10183f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101845:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101848:	73 54                	jae    10189e <memmove+0x6e>
  10184a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10184d:	8b 45 10             	mov    0x10(%ebp),%eax
  101850:	01 d0                	add    %edx,%eax
  101852:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101855:	76 47                	jbe    10189e <memmove+0x6e>
        s += n, d += n;
  101857:	8b 45 10             	mov    0x10(%ebp),%eax
  10185a:	01 45 fc             	add    %eax,-0x4(%ebp)
  10185d:	8b 45 10             	mov    0x10(%ebp),%eax
  101860:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  101863:	eb 13                	jmp    101878 <memmove+0x48>
            *-- d = *-- s;
  101865:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  101869:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101870:	0f b6 10             	movzbl (%eax),%edx
  101873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101876:	88 10                	mov    %dl,(%eax)
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  101878:	8b 45 10             	mov    0x10(%ebp),%eax
  10187b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10187e:	89 55 10             	mov    %edx,0x10(%ebp)
  101881:	85 c0                	test   %eax,%eax
  101883:	75 e0                	jne    101865 <memmove+0x35>
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  101885:	eb 24                	jmp    1018ab <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  101887:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10188a:	8d 50 01             	lea    0x1(%eax),%edx
  10188d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  101890:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101893:	8d 4a 01             	lea    0x1(%edx),%ecx
  101896:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  101899:	0f b6 12             	movzbl (%edx),%edx
  10189c:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  10189e:	8b 45 10             	mov    0x10(%ebp),%eax
  1018a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1018a4:	89 55 10             	mov    %edx,0x10(%ebp)
  1018a7:	85 c0                	test   %eax,%eax
  1018a9:	75 dc                	jne    101887 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  1018ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1018ae:	c9                   	leave  
  1018af:	c3                   	ret    

001018b0 <test_memset>:
#include <string.h>

/*
 * void *memset(void *s, char c, size_t n);
 * */
int test_memset() {
  1018b0:	55                   	push   %ebp
  1018b1:	89 e5                	mov    %esp,%ebp
  1018b3:	83 ec 18             	sub    $0x18,%esp
	char *p = "abcdefg";
  1018b6:	c7 45 f4 62 19 10 00 	movl   $0x101962,-0xc(%ebp)
	char *s = memset(p, 'c', 3);
  1018bd:	83 ec 04             	sub    $0x4,%esp
  1018c0:	6a 03                	push   $0x3
  1018c2:	6a 63                	push   $0x63
  1018c4:	ff 75 f4             	pushl  -0xc(%ebp)
  1018c7:	e8 2f ff ff ff       	call   1017fb <memset>
  1018cc:	83 c4 10             	add    $0x10,%esp
  1018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return 0;
  1018d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1018d7:	c9                   	leave  
  1018d8:	c3                   	ret    

001018d9 <testmain>:


int testmain() {
  1018d9:	55                   	push   %ebp
  1018da:	89 e5                	mov    %esp,%ebp
  1018dc:	83 ec 08             	sub    $0x8,%esp

	test_memset();
  1018df:	e8 cc ff ff ff       	call   1018b0 <test_memset>
	return 0;
  1018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1018e9:	c9                   	leave  
  1018ea:	c3                   	ret    
