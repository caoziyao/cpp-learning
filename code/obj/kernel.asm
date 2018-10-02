
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <init_driver>:
// x86_64-linux-gnu-gdb bin/kernel
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));

void init_driver() {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 08             	sub    $0x8,%esp
	pic_init();                 // init interrupt controller, 中断控制器的初始化工作
  100006:	e8 b8 06 00 00       	call   1006c3 <pic_init>
//	idt_init();                 // init interrupt descriptor table, 对整个中断门描述符表的创建
	cons_init();                // init the console, 对串口、键盘和时钟外设的中断初始化
  10000b:	e8 ed 05 00 00       	call   1005fd <cons_init>
}
  100010:	90                   	nop
  100011:	c9                   	leave  
  100012:	c3                   	ret    

00100013 <unite_test>:

void unite_test() {
  100013:	55                   	push   %ebp
  100014:	89 e5                	mov    %esp,%ebp
  100016:	83 ec 08             	sub    $0x8,%esp
	testmain();
  100019:	e8 89 13 00 00       	call   1013a7 <testmain>
}
  10001e:	90                   	nop
  10001f:	c9                   	leave  
  100020:	c3                   	ret    

00100021 <kern_init>:

int
kern_init(void) {
  100021:	55                   	push   %ebp
  100022:	89 e5                	mov    %esp,%ebp
  100024:	83 ec 18             	sub    $0x18,%esp
	init_driver();
  100027:	e8 d4 ff ff ff       	call   100000 <init_driver>
	unite_test();
  10002c:	e8 e2 ff ff ff       	call   100013 <unite_test>
	int a = 1;
  100031:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	a = a + 3;
  100038:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
	char *s = "ddss";
  10003c:	c7 45 f0 b9 13 10 00 	movl   $0x1013b9,-0x10(%ebp)
	int l = strlen(s);
  100043:	83 ec 0c             	sub    $0xc,%esp
  100046:	ff 75 f0             	pushl  -0x10(%ebp)
  100049:	e8 53 12 00 00       	call   1012a1 <strlen>
  10004e:	83 c4 10             	add    $0x10,%esp
  100051:	89 45 ec             	mov    %eax,-0x14(%ebp)

	const char *msg = "hello lmo-os";
  100054:	c7 45 e8 be 13 10 00 	movl   $0x1013be,-0x18(%ebp)
	cprintf(msg);
  10005b:	83 ec 0c             	sub    $0xc,%esp
  10005e:	ff 75 e8             	pushl  -0x18(%ebp)
  100061:	e8 6a 00 00 00       	call   1000d0 <cprintf>
  100066:	83 c4 10             	add    $0x10,%esp

     while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x48>

0010006b <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100071:	83 ec 0c             	sub    $0xc,%esp
  100074:	ff 75 08             	pushl  0x8(%ebp)
  100077:	e8 91 05 00 00       	call   10060d <cons_putc>
  10007c:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10007f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100082:	8b 00                	mov    (%eax),%eax
  100084:	8d 50 01             	lea    0x1(%eax),%edx
  100087:	8b 45 0c             	mov    0xc(%ebp),%eax
  10008a:	89 10                	mov    %edx,(%eax)
}
  10008c:	90                   	nop
  10008d:	c9                   	leave  
  10008e:	c3                   	ret    

0010008f <vcprintf>:
/*
 * todo
 * 格式化输出
 * */
int
vcprintf(const char *msg) {
  10008f:	55                   	push   %ebp
  100090:	89 e5                	mov    %esp,%ebp
  100092:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
  100095:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
  10009c:	8b 45 08             	mov    0x8(%ebp),%eax
  10009f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  1000a2:	eb 1d                	jmp    1000c1 <vcprintf+0x32>
		cputch(*s, &cnt);
  1000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000a7:	0f b6 00             	movzbl (%eax),%eax
  1000aa:	0f be c0             	movsbl %al,%eax
  1000ad:	83 ec 08             	sub    $0x8,%esp
  1000b0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1000b3:	52                   	push   %edx
  1000b4:	50                   	push   %eax
  1000b5:	e8 b1 ff ff ff       	call   10006b <cputch>
  1000ba:	83 c4 10             	add    $0x10,%esp
		s++;
  1000bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
vcprintf(const char *msg) {
	int cnt = 0;
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
	while (*s != '\0') {
  1000c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000c4:	0f b6 00             	movzbl (%eax),%eax
  1000c7:	84 c0                	test   %al,%al
  1000c9:	75 d9                	jne    1000a4 <vcprintf+0x15>
		cputch(*s, &cnt);
		s++;
	}
	return cnt;
  1000cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1000ce:	c9                   	leave  
  1000cf:	c3                   	ret    

001000d0 <cprintf>:
/*
 * cprintf - formats a string and writes it to stdout
 * todo
 * */
int
cprintf(const char *msg) {
  1000d0:	55                   	push   %ebp
  1000d1:	89 e5                	mov    %esp,%ebp
  1000d3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	cnt = vcprintf(msg);
  1000d6:	83 ec 0c             	sub    $0xc,%esp
  1000d9:	ff 75 08             	pushl  0x8(%ebp)
  1000dc:	e8 ae ff ff ff       	call   10008f <vcprintf>
  1000e1:	83 c4 10             	add    $0x10,%esp
  1000e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return cnt;
  1000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1000ea:	c9                   	leave  
  1000eb:	c3                   	ret    

001000ec <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  1000ec:	55                   	push   %ebp
  1000ed:	89 e5                	mov    %esp,%ebp
  1000ef:	83 ec 18             	sub    $0x18,%esp
  1000f2:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  1000f8:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1000fc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100100:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100104:	ee                   	out    %al,(%dx)
  100105:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  10010b:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  10010f:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100113:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100117:	ee                   	out    %al,(%dx)
  100118:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  10011e:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100122:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100126:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10012a:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  10012b:	c7 05 3c 2b 10 00 00 	movl   $0x0,0x102b3c
  100132:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100135:	83 ec 0c             	sub    $0xc,%esp
  100138:	68 cb 13 10 00       	push   $0x1013cb
  10013d:	e8 8e ff ff ff       	call   1000d0 <cprintf>
  100142:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100145:	83 ec 0c             	sub    $0xc,%esp
  100148:	6a 00                	push   $0x0
  10014a:	e8 47 05 00 00       	call   100696 <pic_enable>
  10014f:	83 c4 10             	add    $0x10,%esp
}
  100152:	90                   	nop
  100153:	c9                   	leave  
  100154:	c3                   	ret    

00100155 <delay>:
// #include <stdio.h>
 #include <string.h>
// 实现了对串口和键盘的中断方式的处理操作；
 /* stupid I/O delay routine necessitated by historical PC design flaws */
 static void
 delay(void) {
  100155:	55                   	push   %ebp
  100156:	89 e5                	mov    %esp,%ebp
  100158:	83 ec 10             	sub    $0x10,%esp
  10015b:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100161:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100165:	89 c2                	mov    %eax,%edx
  100167:	ec                   	in     (%dx),%al
  100168:	88 45 f4             	mov    %al,-0xc(%ebp)
  10016b:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100171:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100175:	89 c2                	mov    %eax,%edx
  100177:	ec                   	in     (%dx),%al
  100178:	88 45 f5             	mov    %al,-0xb(%ebp)
  10017b:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100181:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100185:	89 c2                	mov    %eax,%edx
  100187:	ec                   	in     (%dx),%al
  100188:	88 45 f6             	mov    %al,-0xa(%ebp)
  10018b:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100191:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100195:	89 c2                	mov    %eax,%edx
  100197:	ec                   	in     (%dx),%al
  100198:	88 45 f7             	mov    %al,-0x9(%ebp)
     inb(0x84);
     inb(0x84);
     inb(0x84);
     inb(0x84);
 }
  10019b:	90                   	nop
  10019c:	c9                   	leave  
  10019d:	c3                   	ret    

0010019e <cga_init>:
 static uint16_t addr_6845;

 /* TEXT-mode CGA/VGA display output */

 static void
 cga_init(void) {
  10019e:	55                   	push   %ebp
  10019f:	89 e5                	mov    %esp,%ebp
  1001a1:	83 ec 20             	sub    $0x20,%esp
     volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  1001a4:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
     uint16_t was = *cp;
  1001ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001ae:	0f b7 00             	movzwl (%eax),%eax
  1001b1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
     *cp = (uint16_t) 0xA55A;
  1001b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001b8:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
     if (*cp != 0xA55A) {
  1001bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001c0:	0f b7 00             	movzwl (%eax),%eax
  1001c3:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1001c7:	74 12                	je     1001db <cga_init+0x3d>
         cp = (uint16_t*)MONO_BUF;
  1001c9:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
         addr_6845 = MONO_BASE;
  1001d0:	66 c7 05 32 2b 10 00 	movw   $0x3b4,0x102b32
  1001d7:	b4 03 
  1001d9:	eb 13                	jmp    1001ee <cga_init+0x50>
     } else {
         *cp = was;
  1001db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001de:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1001e2:	66 89 10             	mov    %dx,(%eax)
         addr_6845 = CGA_BASE;
  1001e5:	66 c7 05 32 2b 10 00 	movw   $0x3d4,0x102b32
  1001ec:	d4 03 
     }

     // Extract cursor location
     uint32_t pos;
     outb(addr_6845, 14);
  1001ee:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  1001f5:	0f b7 c0             	movzwl %ax,%eax
  1001f8:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  1001fc:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100200:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100204:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100208:	ee                   	out    %al,(%dx)
     pos = inb(addr_6845 + 1) << 8;
  100209:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  100210:	83 c0 01             	add    $0x1,%eax
  100213:	0f b7 c0             	movzwl %ax,%eax
  100216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10021a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10021e:	89 c2                	mov    %eax,%edx
  100220:	ec                   	in     (%dx),%al
  100221:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100224:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100228:	0f b6 c0             	movzbl %al,%eax
  10022b:	c1 e0 08             	shl    $0x8,%eax
  10022e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     outb(addr_6845, 15);
  100231:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  100238:	0f b7 c0             	movzwl %ax,%eax
  10023b:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  10023f:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100243:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100247:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10024b:	ee                   	out    %al,(%dx)
     pos |= inb(addr_6845 + 1);
  10024c:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  100253:	83 c0 01             	add    $0x1,%eax
  100256:	0f b7 c0             	movzwl %ax,%eax
  100259:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10025d:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100261:	89 c2                	mov    %eax,%edx
  100263:	ec                   	in     (%dx),%al
  100264:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100267:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10026b:	0f b6 c0             	movzbl %al,%eax
  10026e:	09 45 f4             	or     %eax,-0xc(%ebp)

     crt_buf = (uint16_t*) cp;
  100271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100274:	a3 2c 2b 10 00       	mov    %eax,0x102b2c
     crt_pos = pos;
  100279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10027c:	66 a3 30 2b 10 00    	mov    %ax,0x102b30
 }
  100282:	90                   	nop
  100283:	c9                   	leave  
  100284:	c3                   	ret    

00100285 <serial_init>:

 static bool serial_exists = 0;

 static void
 serial_init(void) {
  100285:	55                   	push   %ebp
  100286:	89 e5                	mov    %esp,%ebp
  100288:	83 ec 20             	sub    $0x20,%esp
  10028b:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  100291:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100295:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100299:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10029d:	ee                   	out    %al,(%dx)
  10029e:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  1002a4:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  1002a8:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1002ac:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1002b0:	ee                   	out    %al,(%dx)
  1002b1:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1002b7:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  1002bb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  1002bf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1002c3:	ee                   	out    %al,(%dx)
  1002c4:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  1002ca:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  1002ce:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1002d2:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1002d6:	ee                   	out    %al,(%dx)
  1002d7:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  1002dd:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  1002e1:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  1002e5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1002e9:	ee                   	out    %al,(%dx)
  1002ea:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  1002f0:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  1002f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1002f8:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1002fc:	ee                   	out    %al,(%dx)
  1002fd:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  100303:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  100307:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10030b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10030f:	ee                   	out    %al,(%dx)
  100310:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100316:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10031a:	89 c2                	mov    %eax,%edx
  10031c:	ec                   	in     (%dx),%al
  10031d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100320:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
     // Enable rcv interrupts
     outb(COM1 + COM_IER, COM_IER_RDI);

     // Clear any preexisting overrun indications and interrupts
     // Serial port doesn't exist if COM_LSR returns 0xFF
     serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100324:	3c ff                	cmp    $0xff,%al
  100326:	0f 95 c0             	setne  %al
  100329:	0f b6 c0             	movzbl %al,%eax
  10032c:	a3 34 2b 10 00       	mov    %eax,0x102b34
  100331:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100337:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10033b:	89 c2                	mov    %eax,%edx
  10033d:	ec                   	in     (%dx),%al
  10033e:	88 45 ea             	mov    %al,-0x16(%ebp)
  100341:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  100347:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10034b:	89 c2                	mov    %eax,%edx
  10034d:	ec                   	in     (%dx),%al
  10034e:	88 45 eb             	mov    %al,-0x15(%ebp)

     (void) inb(COM1+COM_IIR);
     (void) inb(COM1+COM_RX);
 }
  100351:	90                   	nop
  100352:	c9                   	leave  
  100353:	c3                   	ret    

00100354 <lpt_putc>:

 /* lpt_putc - copy console output to parallel port */
 static void
 lpt_putc(int c) {
  100354:	55                   	push   %ebp
  100355:	89 e5                	mov    %esp,%ebp
  100357:	83 ec 10             	sub    $0x10,%esp
     int i;
     for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10035a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100361:	eb 09                	jmp    10036c <lpt_putc+0x18>
         delay();
  100363:	e8 ed fd ff ff       	call   100155 <delay>

 /* lpt_putc - copy console output to parallel port */
 static void
 lpt_putc(int c) {
     int i;
     for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100368:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10036c:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100372:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100376:	89 c2                	mov    %eax,%edx
  100378:	ec                   	in     (%dx),%al
  100379:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10037c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100380:	84 c0                	test   %al,%al
  100382:	78 09                	js     10038d <lpt_putc+0x39>
  100384:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10038b:	7e d6                	jle    100363 <lpt_putc+0xf>
         delay();
     }
     outb(LPTPORT + 0, c);
  10038d:	8b 45 08             	mov    0x8(%ebp),%eax
  100390:	0f b6 c0             	movzbl %al,%eax
  100393:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100399:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10039c:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  1003a0:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1003a4:	ee                   	out    %al,(%dx)
  1003a5:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1003ab:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1003af:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1003b3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1003b7:	ee                   	out    %al,(%dx)
  1003b8:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  1003be:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  1003c2:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  1003c6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1003ca:	ee                   	out    %al,(%dx)
     outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
     outb(LPTPORT + 2, 0x08);
 }
  1003cb:	90                   	nop
  1003cc:	c9                   	leave  
  1003cd:	c3                   	ret    

001003ce <cga_putc>:

 /* cga_putc - print character to console */
 static void
 cga_putc(int c) {
  1003ce:	55                   	push   %ebp
  1003cf:	89 e5                	mov    %esp,%ebp
  1003d1:	53                   	push   %ebx
  1003d2:	83 ec 14             	sub    $0x14,%esp
     // set black on white
     if (!(c & ~0xFF)) {
  1003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1003d8:	b0 00                	mov    $0x0,%al
  1003da:	85 c0                	test   %eax,%eax
  1003dc:	75 07                	jne    1003e5 <cga_putc+0x17>
         c |= 0x0700;
  1003de:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
     }

     switch (c & 0xff) {
  1003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1003e8:	0f b6 c0             	movzbl %al,%eax
  1003eb:	83 f8 0a             	cmp    $0xa,%eax
  1003ee:	74 4e                	je     10043e <cga_putc+0x70>
  1003f0:	83 f8 0d             	cmp    $0xd,%eax
  1003f3:	74 59                	je     10044e <cga_putc+0x80>
  1003f5:	83 f8 08             	cmp    $0x8,%eax
  1003f8:	0f 85 8a 00 00 00    	jne    100488 <cga_putc+0xba>
     case '\b':
         if (crt_pos > 0) {
  1003fe:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  100405:	66 85 c0             	test   %ax,%ax
  100408:	0f 84 a0 00 00 00    	je     1004ae <cga_putc+0xe0>
             crt_pos --;
  10040e:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  100415:	83 e8 01             	sub    $0x1,%eax
  100418:	66 a3 30 2b 10 00    	mov    %ax,0x102b30
             crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10041e:	a1 2c 2b 10 00       	mov    0x102b2c,%eax
  100423:	0f b7 15 30 2b 10 00 	movzwl 0x102b30,%edx
  10042a:	0f b7 d2             	movzwl %dx,%edx
  10042d:	01 d2                	add    %edx,%edx
  10042f:	01 d0                	add    %edx,%eax
  100431:	8b 55 08             	mov    0x8(%ebp),%edx
  100434:	b2 00                	mov    $0x0,%dl
  100436:	83 ca 20             	or     $0x20,%edx
  100439:	66 89 10             	mov    %dx,(%eax)
         }
         break;
  10043c:	eb 70                	jmp    1004ae <cga_putc+0xe0>
     case '\n':
         crt_pos += CRT_COLS;
  10043e:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  100445:	83 c0 50             	add    $0x50,%eax
  100448:	66 a3 30 2b 10 00    	mov    %ax,0x102b30
     case '\r':
         crt_pos -= (crt_pos % CRT_COLS);
  10044e:	0f b7 1d 30 2b 10 00 	movzwl 0x102b30,%ebx
  100455:	0f b7 0d 30 2b 10 00 	movzwl 0x102b30,%ecx
  10045c:	0f b7 c1             	movzwl %cx,%eax
  10045f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100465:	c1 e8 10             	shr    $0x10,%eax
  100468:	89 c2                	mov    %eax,%edx
  10046a:	66 c1 ea 06          	shr    $0x6,%dx
  10046e:	89 d0                	mov    %edx,%eax
  100470:	c1 e0 02             	shl    $0x2,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 04             	shl    $0x4,%eax
  100478:	29 c1                	sub    %eax,%ecx
  10047a:	89 ca                	mov    %ecx,%edx
  10047c:	89 d8                	mov    %ebx,%eax
  10047e:	29 d0                	sub    %edx,%eax
  100480:	66 a3 30 2b 10 00    	mov    %ax,0x102b30
         break;
  100486:	eb 27                	jmp    1004af <cga_putc+0xe1>
     default:
         crt_buf[crt_pos ++] = c;     // write the character
  100488:	8b 0d 2c 2b 10 00    	mov    0x102b2c,%ecx
  10048e:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  100495:	8d 50 01             	lea    0x1(%eax),%edx
  100498:	66 89 15 30 2b 10 00 	mov    %dx,0x102b30
  10049f:	0f b7 c0             	movzwl %ax,%eax
  1004a2:	01 c0                	add    %eax,%eax
  1004a4:	01 c8                	add    %ecx,%eax
  1004a6:	8b 55 08             	mov    0x8(%ebp),%edx
  1004a9:	66 89 10             	mov    %dx,(%eax)
         break;
  1004ac:	eb 01                	jmp    1004af <cga_putc+0xe1>
     case '\b':
         if (crt_pos > 0) {
             crt_pos --;
             crt_buf[crt_pos] = (c & ~0xff) | ' ';
         }
         break;
  1004ae:	90                   	nop
         crt_buf[crt_pos ++] = c;     // write the character
         break;
     }

     // What is the purpose of this?
     if (crt_pos >= CRT_SIZE) {
  1004af:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  1004b6:	66 3d cf 07          	cmp    $0x7cf,%ax
  1004ba:	76 59                	jbe    100515 <cga_putc+0x147>
         int i;
         memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1004bc:	a1 2c 2b 10 00       	mov    0x102b2c,%eax
  1004c1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1004c7:	a1 2c 2b 10 00       	mov    0x102b2c,%eax
  1004cc:	83 ec 04             	sub    $0x4,%esp
  1004cf:	68 00 0f 00 00       	push   $0xf00
  1004d4:	52                   	push   %edx
  1004d5:	50                   	push   %eax
  1004d6:	e8 23 0e 00 00       	call   1012fe <memmove>
  1004db:	83 c4 10             	add    $0x10,%esp
         for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1004de:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1004e5:	eb 15                	jmp    1004fc <cga_putc+0x12e>
             crt_buf[i] = 0x0700 | ' ';
  1004e7:	a1 2c 2b 10 00       	mov    0x102b2c,%eax
  1004ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1004ef:	01 d2                	add    %edx,%edx
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	66 c7 00 20 07       	movw   $0x720,(%eax)

     // What is the purpose of this?
     if (crt_pos >= CRT_SIZE) {
         int i;
         memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
         for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1004f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1004fc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  100503:	7e e2                	jle    1004e7 <cga_putc+0x119>
             crt_buf[i] = 0x0700 | ' ';
         }
         crt_pos -= CRT_COLS;
  100505:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  10050c:	83 e8 50             	sub    $0x50,%eax
  10050f:	66 a3 30 2b 10 00    	mov    %ax,0x102b30
     }

     // move that little blinky thing
     outb(addr_6845, 14);
  100515:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  10051c:	0f b7 c0             	movzwl %ax,%eax
  10051f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100523:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  100527:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10052b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10052f:	ee                   	out    %al,(%dx)
     outb(addr_6845 + 1, crt_pos >> 8);
  100530:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  100537:	66 c1 e8 08          	shr    $0x8,%ax
  10053b:	0f b6 c0             	movzbl %al,%eax
  10053e:	0f b7 15 32 2b 10 00 	movzwl 0x102b32,%edx
  100545:	83 c2 01             	add    $0x1,%edx
  100548:	0f b7 d2             	movzwl %dx,%edx
  10054b:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10054f:	88 45 e9             	mov    %al,-0x17(%ebp)
  100552:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100556:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10055a:	ee                   	out    %al,(%dx)
     outb(addr_6845, 15);
  10055b:	0f b7 05 32 2b 10 00 	movzwl 0x102b32,%eax
  100562:	0f b7 c0             	movzwl %ax,%eax
  100565:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100569:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10056d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100571:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100575:	ee                   	out    %al,(%dx)
     outb(addr_6845 + 1, crt_pos);
  100576:	0f b7 05 30 2b 10 00 	movzwl 0x102b30,%eax
  10057d:	0f b6 c0             	movzbl %al,%eax
  100580:	0f b7 15 32 2b 10 00 	movzwl 0x102b32,%edx
  100587:	83 c2 01             	add    $0x1,%edx
  10058a:	0f b7 d2             	movzwl %dx,%edx
  10058d:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  100591:	88 45 eb             	mov    %al,-0x15(%ebp)
  100594:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100598:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10059c:	ee                   	out    %al,(%dx)
 }
  10059d:	90                   	nop
  10059e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005a1:	c9                   	leave  
  1005a2:	c3                   	ret    

001005a3 <serial_putc>:

 /* serial_putc - print character to serial port */
 static void
 serial_putc(int c) {
  1005a3:	55                   	push   %ebp
  1005a4:	89 e5                	mov    %esp,%ebp
  1005a6:	83 ec 10             	sub    $0x10,%esp
     int i;
     for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1005a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1005b0:	eb 09                	jmp    1005bb <serial_putc+0x18>
         delay();
  1005b2:	e8 9e fb ff ff       	call   100155 <delay>

 /* serial_putc - print character to serial port */
 static void
 serial_putc(int c) {
     int i;
     for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1005b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1005bb:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1005c1:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	ec                   	in     (%dx),%al
  1005c8:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1005cb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1005cf:	0f b6 c0             	movzbl %al,%eax
  1005d2:	83 e0 20             	and    $0x20,%eax
  1005d5:	85 c0                	test   %eax,%eax
  1005d7:	75 09                	jne    1005e2 <serial_putc+0x3f>
  1005d9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1005e0:	7e d0                	jle    1005b2 <serial_putc+0xf>
         delay();
     }
     outb(COM1 + COM_TX, c);
  1005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e5:	0f b6 c0             	movzbl %al,%eax
  1005e8:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1005ee:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1005f1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1005f5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1005f9:	ee                   	out    %al,(%dx)
 }
  1005fa:	90                   	nop
  1005fb:	c9                   	leave  
  1005fc:	c3                   	ret    

001005fd <cons_init>:

 /* cons_init - initializes the console devices */
 void
 cons_init(void) {
  1005fd:	55                   	push   %ebp
  1005fe:	89 e5                	mov    %esp,%ebp
     cga_init();
  100600:	e8 99 fb ff ff       	call   10019e <cga_init>
     serial_init();
  100605:	e8 7b fc ff ff       	call   100285 <serial_init>
     if (!serial_exists) {
//         cprintf("serial port does not exist!!\n");
     }
 }
  10060a:	90                   	nop
  10060b:	5d                   	pop    %ebp
  10060c:	c3                   	ret    

0010060d <cons_putc>:

 /* cons_putc - print a single character @c to console devices */
 void
 cons_putc(int c) {
  10060d:	55                   	push   %ebp
  10060e:	89 e5                	mov    %esp,%ebp
  100610:	83 ec 08             	sub    $0x8,%esp
     lpt_putc(c);
  100613:	ff 75 08             	pushl  0x8(%ebp)
  100616:	e8 39 fd ff ff       	call   100354 <lpt_putc>
  10061b:	83 c4 04             	add    $0x4,%esp
     cga_putc(c);
  10061e:	83 ec 0c             	sub    $0xc,%esp
  100621:	ff 75 08             	pushl  0x8(%ebp)
  100624:	e8 a5 fd ff ff       	call   1003ce <cga_putc>
  100629:	83 c4 10             	add    $0x10,%esp
     serial_putc(c);
  10062c:	83 ec 0c             	sub    $0xc,%esp
  10062f:	ff 75 08             	pushl  0x8(%ebp)
  100632:	e8 6c ff ff ff       	call   1005a3 <serial_putc>
  100637:	83 c4 10             	add    $0x10,%esp
 }
  10063a:	90                   	nop
  10063b:	c9                   	leave  
  10063c:	c3                   	ret    

0010063d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10063d:	55                   	push   %ebp
  10063e:	89 e5                	mov    %esp,%ebp
  100640:	83 ec 14             	sub    $0x14,%esp
  100643:	8b 45 08             	mov    0x8(%ebp),%eax
  100646:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10064a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10064e:	66 a3 28 27 10 00    	mov    %ax,0x102728
    if (did_init) {
  100654:	a1 38 2b 10 00       	mov    0x102b38,%eax
  100659:	85 c0                	test   %eax,%eax
  10065b:	74 36                	je     100693 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10065d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100661:	0f b6 c0             	movzbl %al,%eax
  100664:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10066a:	88 45 fa             	mov    %al,-0x6(%ebp)
  10066d:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  100671:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100675:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  100676:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10067a:	66 c1 e8 08          	shr    $0x8,%ax
  10067e:	0f b6 c0             	movzbl %al,%eax
  100681:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100687:	88 45 fb             	mov    %al,-0x5(%ebp)
  10068a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10068e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100692:	ee                   	out    %al,(%dx)
    }
}
  100693:	90                   	nop
  100694:	c9                   	leave  
  100695:	c3                   	ret    

00100696 <pic_enable>:

void
pic_enable(unsigned int irq) {
  100696:	55                   	push   %ebp
  100697:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  100699:	8b 45 08             	mov    0x8(%ebp),%eax
  10069c:	ba 01 00 00 00       	mov    $0x1,%edx
  1006a1:	89 c1                	mov    %eax,%ecx
  1006a3:	d3 e2                	shl    %cl,%edx
  1006a5:	89 d0                	mov    %edx,%eax
  1006a7:	f7 d0                	not    %eax
  1006a9:	89 c2                	mov    %eax,%edx
  1006ab:	0f b7 05 28 27 10 00 	movzwl 0x102728,%eax
  1006b2:	21 d0                	and    %edx,%eax
  1006b4:	0f b7 c0             	movzwl %ax,%eax
  1006b7:	50                   	push   %eax
  1006b8:	e8 80 ff ff ff       	call   10063d <pic_setmask>
  1006bd:	83 c4 04             	add    $0x4,%esp
}
  1006c0:	90                   	nop
  1006c1:	c9                   	leave  
  1006c2:	c3                   	ret    

001006c3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1006c3:	55                   	push   %ebp
  1006c4:	89 e5                	mov    %esp,%ebp
  1006c6:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1006c9:	c7 05 38 2b 10 00 01 	movl   $0x1,0x102b38
  1006d0:	00 00 00 
  1006d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1006d9:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1006dd:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1006e1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1006e5:	ee                   	out    %al,(%dx)
  1006e6:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1006ec:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1006f0:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1006f4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1006f8:	ee                   	out    %al,(%dx)
  1006f9:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1006ff:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  100703:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  100707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10070b:	ee                   	out    %al,(%dx)
  10070c:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100712:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  100716:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10071a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10071e:	ee                   	out    %al,(%dx)
  10071f:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100725:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100729:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10072d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100731:	ee                   	out    %al,(%dx)
  100732:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100738:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10073c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100740:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100744:	ee                   	out    %al,(%dx)
  100745:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  10074b:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10074f:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100753:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100757:	ee                   	out    %al,(%dx)
  100758:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10075e:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100762:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100766:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10076a:	ee                   	out    %al,(%dx)
  10076b:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100771:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100775:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100779:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10077d:	ee                   	out    %al,(%dx)
  10077e:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100784:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  100788:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  10078c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100790:	ee                   	out    %al,(%dx)
  100791:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  100797:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  10079b:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10079f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1007a3:	ee                   	out    %al,(%dx)
  1007a4:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  1007aa:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1007ae:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1007b2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1007b6:	ee                   	out    %al,(%dx)
  1007b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1007bd:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  1007c1:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  1007c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1007c9:	ee                   	out    %al,(%dx)
  1007ca:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1007d0:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1007d4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1007d8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1007dc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1007dd:	0f b7 05 28 27 10 00 	movzwl 0x102728,%eax
  1007e4:	66 83 f8 ff          	cmp    $0xffff,%ax
  1007e8:	74 13                	je     1007fd <pic_init+0x13a>
        pic_setmask(irq_mask);
  1007ea:	0f b7 05 28 27 10 00 	movzwl 0x102728,%eax
  1007f1:	0f b7 c0             	movzwl %ax,%eax
  1007f4:	50                   	push   %eax
  1007f5:	e8 43 fe ff ff       	call   10063d <pic_setmask>
  1007fa:	83 c4 04             	add    $0x4,%esp
    }
}
  1007fd:	90                   	nop
  1007fe:	c9                   	leave  
  1007ff:	c3                   	ret    

00100800 <trap_dispatch>:



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  100800:	55                   	push   %ebp
  100801:	89 e5                	mov    %esp,%ebp
//        if ((tf->tf_cs & 3) == 0) {
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
//        }
//    }
}
  100803:	90                   	nop
  100804:	5d                   	pop    %ebp
  100805:	c3                   	ret    

00100806 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  100806:	55                   	push   %ebp
  100807:	89 e5                	mov    %esp,%ebp
    trap_dispatch(tf);
  100809:	ff 75 08             	pushl  0x8(%ebp)
  10080c:	e8 ef ff ff ff       	call   100800 <trap_dispatch>
  100811:	83 c4 04             	add    $0x4,%esp
}
  100814:	90                   	nop
  100815:	c9                   	leave  
  100816:	c3                   	ret    

00100817 <vector0>:
# 包括256个中断服务例程的入口地址和第一步初步处理实现；
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  100817:	6a 00                	push   $0x0
  pushl $0
  100819:	6a 00                	push   $0x0
  jmp __alltraps
  10081b:	e9 67 0a 00 00       	jmp    101287 <__alltraps>

00100820 <vector1>:
.globl vector1
vector1:
  pushl $0
  100820:	6a 00                	push   $0x0
  pushl $1
  100822:	6a 01                	push   $0x1
  jmp __alltraps
  100824:	e9 5e 0a 00 00       	jmp    101287 <__alltraps>

00100829 <vector2>:
.globl vector2
vector2:
  pushl $0
  100829:	6a 00                	push   $0x0
  pushl $2
  10082b:	6a 02                	push   $0x2
  jmp __alltraps
  10082d:	e9 55 0a 00 00       	jmp    101287 <__alltraps>

00100832 <vector3>:
.globl vector3
vector3:
  pushl $0
  100832:	6a 00                	push   $0x0
  pushl $3
  100834:	6a 03                	push   $0x3
  jmp __alltraps
  100836:	e9 4c 0a 00 00       	jmp    101287 <__alltraps>

0010083b <vector4>:
.globl vector4
vector4:
  pushl $0
  10083b:	6a 00                	push   $0x0
  pushl $4
  10083d:	6a 04                	push   $0x4
  jmp __alltraps
  10083f:	e9 43 0a 00 00       	jmp    101287 <__alltraps>

00100844 <vector5>:
.globl vector5
vector5:
  pushl $0
  100844:	6a 00                	push   $0x0
  pushl $5
  100846:	6a 05                	push   $0x5
  jmp __alltraps
  100848:	e9 3a 0a 00 00       	jmp    101287 <__alltraps>

0010084d <vector6>:
.globl vector6
vector6:
  pushl $0
  10084d:	6a 00                	push   $0x0
  pushl $6
  10084f:	6a 06                	push   $0x6
  jmp __alltraps
  100851:	e9 31 0a 00 00       	jmp    101287 <__alltraps>

00100856 <vector7>:
.globl vector7
vector7:
  pushl $0
  100856:	6a 00                	push   $0x0
  pushl $7
  100858:	6a 07                	push   $0x7
  jmp __alltraps
  10085a:	e9 28 0a 00 00       	jmp    101287 <__alltraps>

0010085f <vector8>:
.globl vector8
vector8:
  pushl $8
  10085f:	6a 08                	push   $0x8
  jmp __alltraps
  100861:	e9 21 0a 00 00       	jmp    101287 <__alltraps>

00100866 <vector9>:
.globl vector9
vector9:
  pushl $9
  100866:	6a 09                	push   $0x9
  jmp __alltraps
  100868:	e9 1a 0a 00 00       	jmp    101287 <__alltraps>

0010086d <vector10>:
.globl vector10
vector10:
  pushl $10
  10086d:	6a 0a                	push   $0xa
  jmp __alltraps
  10086f:	e9 13 0a 00 00       	jmp    101287 <__alltraps>

00100874 <vector11>:
.globl vector11
vector11:
  pushl $11
  100874:	6a 0b                	push   $0xb
  jmp __alltraps
  100876:	e9 0c 0a 00 00       	jmp    101287 <__alltraps>

0010087b <vector12>:
.globl vector12
vector12:
  pushl $12
  10087b:	6a 0c                	push   $0xc
  jmp __alltraps
  10087d:	e9 05 0a 00 00       	jmp    101287 <__alltraps>

00100882 <vector13>:
.globl vector13
vector13:
  pushl $13
  100882:	6a 0d                	push   $0xd
  jmp __alltraps
  100884:	e9 fe 09 00 00       	jmp    101287 <__alltraps>

00100889 <vector14>:
.globl vector14
vector14:
  pushl $14
  100889:	6a 0e                	push   $0xe
  jmp __alltraps
  10088b:	e9 f7 09 00 00       	jmp    101287 <__alltraps>

00100890 <vector15>:
.globl vector15
vector15:
  pushl $0
  100890:	6a 00                	push   $0x0
  pushl $15
  100892:	6a 0f                	push   $0xf
  jmp __alltraps
  100894:	e9 ee 09 00 00       	jmp    101287 <__alltraps>

00100899 <vector16>:
.globl vector16
vector16:
  pushl $0
  100899:	6a 00                	push   $0x0
  pushl $16
  10089b:	6a 10                	push   $0x10
  jmp __alltraps
  10089d:	e9 e5 09 00 00       	jmp    101287 <__alltraps>

001008a2 <vector17>:
.globl vector17
vector17:
  pushl $17
  1008a2:	6a 11                	push   $0x11
  jmp __alltraps
  1008a4:	e9 de 09 00 00       	jmp    101287 <__alltraps>

001008a9 <vector18>:
.globl vector18
vector18:
  pushl $0
  1008a9:	6a 00                	push   $0x0
  pushl $18
  1008ab:	6a 12                	push   $0x12
  jmp __alltraps
  1008ad:	e9 d5 09 00 00       	jmp    101287 <__alltraps>

001008b2 <vector19>:
.globl vector19
vector19:
  pushl $0
  1008b2:	6a 00                	push   $0x0
  pushl $19
  1008b4:	6a 13                	push   $0x13
  jmp __alltraps
  1008b6:	e9 cc 09 00 00       	jmp    101287 <__alltraps>

001008bb <vector20>:
.globl vector20
vector20:
  pushl $0
  1008bb:	6a 00                	push   $0x0
  pushl $20
  1008bd:	6a 14                	push   $0x14
  jmp __alltraps
  1008bf:	e9 c3 09 00 00       	jmp    101287 <__alltraps>

001008c4 <vector21>:
.globl vector21
vector21:
  pushl $0
  1008c4:	6a 00                	push   $0x0
  pushl $21
  1008c6:	6a 15                	push   $0x15
  jmp __alltraps
  1008c8:	e9 ba 09 00 00       	jmp    101287 <__alltraps>

001008cd <vector22>:
.globl vector22
vector22:
  pushl $0
  1008cd:	6a 00                	push   $0x0
  pushl $22
  1008cf:	6a 16                	push   $0x16
  jmp __alltraps
  1008d1:	e9 b1 09 00 00       	jmp    101287 <__alltraps>

001008d6 <vector23>:
.globl vector23
vector23:
  pushl $0
  1008d6:	6a 00                	push   $0x0
  pushl $23
  1008d8:	6a 17                	push   $0x17
  jmp __alltraps
  1008da:	e9 a8 09 00 00       	jmp    101287 <__alltraps>

001008df <vector24>:
.globl vector24
vector24:
  pushl $0
  1008df:	6a 00                	push   $0x0
  pushl $24
  1008e1:	6a 18                	push   $0x18
  jmp __alltraps
  1008e3:	e9 9f 09 00 00       	jmp    101287 <__alltraps>

001008e8 <vector25>:
.globl vector25
vector25:
  pushl $0
  1008e8:	6a 00                	push   $0x0
  pushl $25
  1008ea:	6a 19                	push   $0x19
  jmp __alltraps
  1008ec:	e9 96 09 00 00       	jmp    101287 <__alltraps>

001008f1 <vector26>:
.globl vector26
vector26:
  pushl $0
  1008f1:	6a 00                	push   $0x0
  pushl $26
  1008f3:	6a 1a                	push   $0x1a
  jmp __alltraps
  1008f5:	e9 8d 09 00 00       	jmp    101287 <__alltraps>

001008fa <vector27>:
.globl vector27
vector27:
  pushl $0
  1008fa:	6a 00                	push   $0x0
  pushl $27
  1008fc:	6a 1b                	push   $0x1b
  jmp __alltraps
  1008fe:	e9 84 09 00 00       	jmp    101287 <__alltraps>

00100903 <vector28>:
.globl vector28
vector28:
  pushl $0
  100903:	6a 00                	push   $0x0
  pushl $28
  100905:	6a 1c                	push   $0x1c
  jmp __alltraps
  100907:	e9 7b 09 00 00       	jmp    101287 <__alltraps>

0010090c <vector29>:
.globl vector29
vector29:
  pushl $0
  10090c:	6a 00                	push   $0x0
  pushl $29
  10090e:	6a 1d                	push   $0x1d
  jmp __alltraps
  100910:	e9 72 09 00 00       	jmp    101287 <__alltraps>

00100915 <vector30>:
.globl vector30
vector30:
  pushl $0
  100915:	6a 00                	push   $0x0
  pushl $30
  100917:	6a 1e                	push   $0x1e
  jmp __alltraps
  100919:	e9 69 09 00 00       	jmp    101287 <__alltraps>

0010091e <vector31>:
.globl vector31
vector31:
  pushl $0
  10091e:	6a 00                	push   $0x0
  pushl $31
  100920:	6a 1f                	push   $0x1f
  jmp __alltraps
  100922:	e9 60 09 00 00       	jmp    101287 <__alltraps>

00100927 <vector32>:
.globl vector32
vector32:
  pushl $0
  100927:	6a 00                	push   $0x0
  pushl $32
  100929:	6a 20                	push   $0x20
  jmp __alltraps
  10092b:	e9 57 09 00 00       	jmp    101287 <__alltraps>

00100930 <vector33>:
.globl vector33
vector33:
  pushl $0
  100930:	6a 00                	push   $0x0
  pushl $33
  100932:	6a 21                	push   $0x21
  jmp __alltraps
  100934:	e9 4e 09 00 00       	jmp    101287 <__alltraps>

00100939 <vector34>:
.globl vector34
vector34:
  pushl $0
  100939:	6a 00                	push   $0x0
  pushl $34
  10093b:	6a 22                	push   $0x22
  jmp __alltraps
  10093d:	e9 45 09 00 00       	jmp    101287 <__alltraps>

00100942 <vector35>:
.globl vector35
vector35:
  pushl $0
  100942:	6a 00                	push   $0x0
  pushl $35
  100944:	6a 23                	push   $0x23
  jmp __alltraps
  100946:	e9 3c 09 00 00       	jmp    101287 <__alltraps>

0010094b <vector36>:
.globl vector36
vector36:
  pushl $0
  10094b:	6a 00                	push   $0x0
  pushl $36
  10094d:	6a 24                	push   $0x24
  jmp __alltraps
  10094f:	e9 33 09 00 00       	jmp    101287 <__alltraps>

00100954 <vector37>:
.globl vector37
vector37:
  pushl $0
  100954:	6a 00                	push   $0x0
  pushl $37
  100956:	6a 25                	push   $0x25
  jmp __alltraps
  100958:	e9 2a 09 00 00       	jmp    101287 <__alltraps>

0010095d <vector38>:
.globl vector38
vector38:
  pushl $0
  10095d:	6a 00                	push   $0x0
  pushl $38
  10095f:	6a 26                	push   $0x26
  jmp __alltraps
  100961:	e9 21 09 00 00       	jmp    101287 <__alltraps>

00100966 <vector39>:
.globl vector39
vector39:
  pushl $0
  100966:	6a 00                	push   $0x0
  pushl $39
  100968:	6a 27                	push   $0x27
  jmp __alltraps
  10096a:	e9 18 09 00 00       	jmp    101287 <__alltraps>

0010096f <vector40>:
.globl vector40
vector40:
  pushl $0
  10096f:	6a 00                	push   $0x0
  pushl $40
  100971:	6a 28                	push   $0x28
  jmp __alltraps
  100973:	e9 0f 09 00 00       	jmp    101287 <__alltraps>

00100978 <vector41>:
.globl vector41
vector41:
  pushl $0
  100978:	6a 00                	push   $0x0
  pushl $41
  10097a:	6a 29                	push   $0x29
  jmp __alltraps
  10097c:	e9 06 09 00 00       	jmp    101287 <__alltraps>

00100981 <vector42>:
.globl vector42
vector42:
  pushl $0
  100981:	6a 00                	push   $0x0
  pushl $42
  100983:	6a 2a                	push   $0x2a
  jmp __alltraps
  100985:	e9 fd 08 00 00       	jmp    101287 <__alltraps>

0010098a <vector43>:
.globl vector43
vector43:
  pushl $0
  10098a:	6a 00                	push   $0x0
  pushl $43
  10098c:	6a 2b                	push   $0x2b
  jmp __alltraps
  10098e:	e9 f4 08 00 00       	jmp    101287 <__alltraps>

00100993 <vector44>:
.globl vector44
vector44:
  pushl $0
  100993:	6a 00                	push   $0x0
  pushl $44
  100995:	6a 2c                	push   $0x2c
  jmp __alltraps
  100997:	e9 eb 08 00 00       	jmp    101287 <__alltraps>

0010099c <vector45>:
.globl vector45
vector45:
  pushl $0
  10099c:	6a 00                	push   $0x0
  pushl $45
  10099e:	6a 2d                	push   $0x2d
  jmp __alltraps
  1009a0:	e9 e2 08 00 00       	jmp    101287 <__alltraps>

001009a5 <vector46>:
.globl vector46
vector46:
  pushl $0
  1009a5:	6a 00                	push   $0x0
  pushl $46
  1009a7:	6a 2e                	push   $0x2e
  jmp __alltraps
  1009a9:	e9 d9 08 00 00       	jmp    101287 <__alltraps>

001009ae <vector47>:
.globl vector47
vector47:
  pushl $0
  1009ae:	6a 00                	push   $0x0
  pushl $47
  1009b0:	6a 2f                	push   $0x2f
  jmp __alltraps
  1009b2:	e9 d0 08 00 00       	jmp    101287 <__alltraps>

001009b7 <vector48>:
.globl vector48
vector48:
  pushl $0
  1009b7:	6a 00                	push   $0x0
  pushl $48
  1009b9:	6a 30                	push   $0x30
  jmp __alltraps
  1009bb:	e9 c7 08 00 00       	jmp    101287 <__alltraps>

001009c0 <vector49>:
.globl vector49
vector49:
  pushl $0
  1009c0:	6a 00                	push   $0x0
  pushl $49
  1009c2:	6a 31                	push   $0x31
  jmp __alltraps
  1009c4:	e9 be 08 00 00       	jmp    101287 <__alltraps>

001009c9 <vector50>:
.globl vector50
vector50:
  pushl $0
  1009c9:	6a 00                	push   $0x0
  pushl $50
  1009cb:	6a 32                	push   $0x32
  jmp __alltraps
  1009cd:	e9 b5 08 00 00       	jmp    101287 <__alltraps>

001009d2 <vector51>:
.globl vector51
vector51:
  pushl $0
  1009d2:	6a 00                	push   $0x0
  pushl $51
  1009d4:	6a 33                	push   $0x33
  jmp __alltraps
  1009d6:	e9 ac 08 00 00       	jmp    101287 <__alltraps>

001009db <vector52>:
.globl vector52
vector52:
  pushl $0
  1009db:	6a 00                	push   $0x0
  pushl $52
  1009dd:	6a 34                	push   $0x34
  jmp __alltraps
  1009df:	e9 a3 08 00 00       	jmp    101287 <__alltraps>

001009e4 <vector53>:
.globl vector53
vector53:
  pushl $0
  1009e4:	6a 00                	push   $0x0
  pushl $53
  1009e6:	6a 35                	push   $0x35
  jmp __alltraps
  1009e8:	e9 9a 08 00 00       	jmp    101287 <__alltraps>

001009ed <vector54>:
.globl vector54
vector54:
  pushl $0
  1009ed:	6a 00                	push   $0x0
  pushl $54
  1009ef:	6a 36                	push   $0x36
  jmp __alltraps
  1009f1:	e9 91 08 00 00       	jmp    101287 <__alltraps>

001009f6 <vector55>:
.globl vector55
vector55:
  pushl $0
  1009f6:	6a 00                	push   $0x0
  pushl $55
  1009f8:	6a 37                	push   $0x37
  jmp __alltraps
  1009fa:	e9 88 08 00 00       	jmp    101287 <__alltraps>

001009ff <vector56>:
.globl vector56
vector56:
  pushl $0
  1009ff:	6a 00                	push   $0x0
  pushl $56
  100a01:	6a 38                	push   $0x38
  jmp __alltraps
  100a03:	e9 7f 08 00 00       	jmp    101287 <__alltraps>

00100a08 <vector57>:
.globl vector57
vector57:
  pushl $0
  100a08:	6a 00                	push   $0x0
  pushl $57
  100a0a:	6a 39                	push   $0x39
  jmp __alltraps
  100a0c:	e9 76 08 00 00       	jmp    101287 <__alltraps>

00100a11 <vector58>:
.globl vector58
vector58:
  pushl $0
  100a11:	6a 00                	push   $0x0
  pushl $58
  100a13:	6a 3a                	push   $0x3a
  jmp __alltraps
  100a15:	e9 6d 08 00 00       	jmp    101287 <__alltraps>

00100a1a <vector59>:
.globl vector59
vector59:
  pushl $0
  100a1a:	6a 00                	push   $0x0
  pushl $59
  100a1c:	6a 3b                	push   $0x3b
  jmp __alltraps
  100a1e:	e9 64 08 00 00       	jmp    101287 <__alltraps>

00100a23 <vector60>:
.globl vector60
vector60:
  pushl $0
  100a23:	6a 00                	push   $0x0
  pushl $60
  100a25:	6a 3c                	push   $0x3c
  jmp __alltraps
  100a27:	e9 5b 08 00 00       	jmp    101287 <__alltraps>

00100a2c <vector61>:
.globl vector61
vector61:
  pushl $0
  100a2c:	6a 00                	push   $0x0
  pushl $61
  100a2e:	6a 3d                	push   $0x3d
  jmp __alltraps
  100a30:	e9 52 08 00 00       	jmp    101287 <__alltraps>

00100a35 <vector62>:
.globl vector62
vector62:
  pushl $0
  100a35:	6a 00                	push   $0x0
  pushl $62
  100a37:	6a 3e                	push   $0x3e
  jmp __alltraps
  100a39:	e9 49 08 00 00       	jmp    101287 <__alltraps>

00100a3e <vector63>:
.globl vector63
vector63:
  pushl $0
  100a3e:	6a 00                	push   $0x0
  pushl $63
  100a40:	6a 3f                	push   $0x3f
  jmp __alltraps
  100a42:	e9 40 08 00 00       	jmp    101287 <__alltraps>

00100a47 <vector64>:
.globl vector64
vector64:
  pushl $0
  100a47:	6a 00                	push   $0x0
  pushl $64
  100a49:	6a 40                	push   $0x40
  jmp __alltraps
  100a4b:	e9 37 08 00 00       	jmp    101287 <__alltraps>

00100a50 <vector65>:
.globl vector65
vector65:
  pushl $0
  100a50:	6a 00                	push   $0x0
  pushl $65
  100a52:	6a 41                	push   $0x41
  jmp __alltraps
  100a54:	e9 2e 08 00 00       	jmp    101287 <__alltraps>

00100a59 <vector66>:
.globl vector66
vector66:
  pushl $0
  100a59:	6a 00                	push   $0x0
  pushl $66
  100a5b:	6a 42                	push   $0x42
  jmp __alltraps
  100a5d:	e9 25 08 00 00       	jmp    101287 <__alltraps>

00100a62 <vector67>:
.globl vector67
vector67:
  pushl $0
  100a62:	6a 00                	push   $0x0
  pushl $67
  100a64:	6a 43                	push   $0x43
  jmp __alltraps
  100a66:	e9 1c 08 00 00       	jmp    101287 <__alltraps>

00100a6b <vector68>:
.globl vector68
vector68:
  pushl $0
  100a6b:	6a 00                	push   $0x0
  pushl $68
  100a6d:	6a 44                	push   $0x44
  jmp __alltraps
  100a6f:	e9 13 08 00 00       	jmp    101287 <__alltraps>

00100a74 <vector69>:
.globl vector69
vector69:
  pushl $0
  100a74:	6a 00                	push   $0x0
  pushl $69
  100a76:	6a 45                	push   $0x45
  jmp __alltraps
  100a78:	e9 0a 08 00 00       	jmp    101287 <__alltraps>

00100a7d <vector70>:
.globl vector70
vector70:
  pushl $0
  100a7d:	6a 00                	push   $0x0
  pushl $70
  100a7f:	6a 46                	push   $0x46
  jmp __alltraps
  100a81:	e9 01 08 00 00       	jmp    101287 <__alltraps>

00100a86 <vector71>:
.globl vector71
vector71:
  pushl $0
  100a86:	6a 00                	push   $0x0
  pushl $71
  100a88:	6a 47                	push   $0x47
  jmp __alltraps
  100a8a:	e9 f8 07 00 00       	jmp    101287 <__alltraps>

00100a8f <vector72>:
.globl vector72
vector72:
  pushl $0
  100a8f:	6a 00                	push   $0x0
  pushl $72
  100a91:	6a 48                	push   $0x48
  jmp __alltraps
  100a93:	e9 ef 07 00 00       	jmp    101287 <__alltraps>

00100a98 <vector73>:
.globl vector73
vector73:
  pushl $0
  100a98:	6a 00                	push   $0x0
  pushl $73
  100a9a:	6a 49                	push   $0x49
  jmp __alltraps
  100a9c:	e9 e6 07 00 00       	jmp    101287 <__alltraps>

00100aa1 <vector74>:
.globl vector74
vector74:
  pushl $0
  100aa1:	6a 00                	push   $0x0
  pushl $74
  100aa3:	6a 4a                	push   $0x4a
  jmp __alltraps
  100aa5:	e9 dd 07 00 00       	jmp    101287 <__alltraps>

00100aaa <vector75>:
.globl vector75
vector75:
  pushl $0
  100aaa:	6a 00                	push   $0x0
  pushl $75
  100aac:	6a 4b                	push   $0x4b
  jmp __alltraps
  100aae:	e9 d4 07 00 00       	jmp    101287 <__alltraps>

00100ab3 <vector76>:
.globl vector76
vector76:
  pushl $0
  100ab3:	6a 00                	push   $0x0
  pushl $76
  100ab5:	6a 4c                	push   $0x4c
  jmp __alltraps
  100ab7:	e9 cb 07 00 00       	jmp    101287 <__alltraps>

00100abc <vector77>:
.globl vector77
vector77:
  pushl $0
  100abc:	6a 00                	push   $0x0
  pushl $77
  100abe:	6a 4d                	push   $0x4d
  jmp __alltraps
  100ac0:	e9 c2 07 00 00       	jmp    101287 <__alltraps>

00100ac5 <vector78>:
.globl vector78
vector78:
  pushl $0
  100ac5:	6a 00                	push   $0x0
  pushl $78
  100ac7:	6a 4e                	push   $0x4e
  jmp __alltraps
  100ac9:	e9 b9 07 00 00       	jmp    101287 <__alltraps>

00100ace <vector79>:
.globl vector79
vector79:
  pushl $0
  100ace:	6a 00                	push   $0x0
  pushl $79
  100ad0:	6a 4f                	push   $0x4f
  jmp __alltraps
  100ad2:	e9 b0 07 00 00       	jmp    101287 <__alltraps>

00100ad7 <vector80>:
.globl vector80
vector80:
  pushl $0
  100ad7:	6a 00                	push   $0x0
  pushl $80
  100ad9:	6a 50                	push   $0x50
  jmp __alltraps
  100adb:	e9 a7 07 00 00       	jmp    101287 <__alltraps>

00100ae0 <vector81>:
.globl vector81
vector81:
  pushl $0
  100ae0:	6a 00                	push   $0x0
  pushl $81
  100ae2:	6a 51                	push   $0x51
  jmp __alltraps
  100ae4:	e9 9e 07 00 00       	jmp    101287 <__alltraps>

00100ae9 <vector82>:
.globl vector82
vector82:
  pushl $0
  100ae9:	6a 00                	push   $0x0
  pushl $82
  100aeb:	6a 52                	push   $0x52
  jmp __alltraps
  100aed:	e9 95 07 00 00       	jmp    101287 <__alltraps>

00100af2 <vector83>:
.globl vector83
vector83:
  pushl $0
  100af2:	6a 00                	push   $0x0
  pushl $83
  100af4:	6a 53                	push   $0x53
  jmp __alltraps
  100af6:	e9 8c 07 00 00       	jmp    101287 <__alltraps>

00100afb <vector84>:
.globl vector84
vector84:
  pushl $0
  100afb:	6a 00                	push   $0x0
  pushl $84
  100afd:	6a 54                	push   $0x54
  jmp __alltraps
  100aff:	e9 83 07 00 00       	jmp    101287 <__alltraps>

00100b04 <vector85>:
.globl vector85
vector85:
  pushl $0
  100b04:	6a 00                	push   $0x0
  pushl $85
  100b06:	6a 55                	push   $0x55
  jmp __alltraps
  100b08:	e9 7a 07 00 00       	jmp    101287 <__alltraps>

00100b0d <vector86>:
.globl vector86
vector86:
  pushl $0
  100b0d:	6a 00                	push   $0x0
  pushl $86
  100b0f:	6a 56                	push   $0x56
  jmp __alltraps
  100b11:	e9 71 07 00 00       	jmp    101287 <__alltraps>

00100b16 <vector87>:
.globl vector87
vector87:
  pushl $0
  100b16:	6a 00                	push   $0x0
  pushl $87
  100b18:	6a 57                	push   $0x57
  jmp __alltraps
  100b1a:	e9 68 07 00 00       	jmp    101287 <__alltraps>

00100b1f <vector88>:
.globl vector88
vector88:
  pushl $0
  100b1f:	6a 00                	push   $0x0
  pushl $88
  100b21:	6a 58                	push   $0x58
  jmp __alltraps
  100b23:	e9 5f 07 00 00       	jmp    101287 <__alltraps>

00100b28 <vector89>:
.globl vector89
vector89:
  pushl $0
  100b28:	6a 00                	push   $0x0
  pushl $89
  100b2a:	6a 59                	push   $0x59
  jmp __alltraps
  100b2c:	e9 56 07 00 00       	jmp    101287 <__alltraps>

00100b31 <vector90>:
.globl vector90
vector90:
  pushl $0
  100b31:	6a 00                	push   $0x0
  pushl $90
  100b33:	6a 5a                	push   $0x5a
  jmp __alltraps
  100b35:	e9 4d 07 00 00       	jmp    101287 <__alltraps>

00100b3a <vector91>:
.globl vector91
vector91:
  pushl $0
  100b3a:	6a 00                	push   $0x0
  pushl $91
  100b3c:	6a 5b                	push   $0x5b
  jmp __alltraps
  100b3e:	e9 44 07 00 00       	jmp    101287 <__alltraps>

00100b43 <vector92>:
.globl vector92
vector92:
  pushl $0
  100b43:	6a 00                	push   $0x0
  pushl $92
  100b45:	6a 5c                	push   $0x5c
  jmp __alltraps
  100b47:	e9 3b 07 00 00       	jmp    101287 <__alltraps>

00100b4c <vector93>:
.globl vector93
vector93:
  pushl $0
  100b4c:	6a 00                	push   $0x0
  pushl $93
  100b4e:	6a 5d                	push   $0x5d
  jmp __alltraps
  100b50:	e9 32 07 00 00       	jmp    101287 <__alltraps>

00100b55 <vector94>:
.globl vector94
vector94:
  pushl $0
  100b55:	6a 00                	push   $0x0
  pushl $94
  100b57:	6a 5e                	push   $0x5e
  jmp __alltraps
  100b59:	e9 29 07 00 00       	jmp    101287 <__alltraps>

00100b5e <vector95>:
.globl vector95
vector95:
  pushl $0
  100b5e:	6a 00                	push   $0x0
  pushl $95
  100b60:	6a 5f                	push   $0x5f
  jmp __alltraps
  100b62:	e9 20 07 00 00       	jmp    101287 <__alltraps>

00100b67 <vector96>:
.globl vector96
vector96:
  pushl $0
  100b67:	6a 00                	push   $0x0
  pushl $96
  100b69:	6a 60                	push   $0x60
  jmp __alltraps
  100b6b:	e9 17 07 00 00       	jmp    101287 <__alltraps>

00100b70 <vector97>:
.globl vector97
vector97:
  pushl $0
  100b70:	6a 00                	push   $0x0
  pushl $97
  100b72:	6a 61                	push   $0x61
  jmp __alltraps
  100b74:	e9 0e 07 00 00       	jmp    101287 <__alltraps>

00100b79 <vector98>:
.globl vector98
vector98:
  pushl $0
  100b79:	6a 00                	push   $0x0
  pushl $98
  100b7b:	6a 62                	push   $0x62
  jmp __alltraps
  100b7d:	e9 05 07 00 00       	jmp    101287 <__alltraps>

00100b82 <vector99>:
.globl vector99
vector99:
  pushl $0
  100b82:	6a 00                	push   $0x0
  pushl $99
  100b84:	6a 63                	push   $0x63
  jmp __alltraps
  100b86:	e9 fc 06 00 00       	jmp    101287 <__alltraps>

00100b8b <vector100>:
.globl vector100
vector100:
  pushl $0
  100b8b:	6a 00                	push   $0x0
  pushl $100
  100b8d:	6a 64                	push   $0x64
  jmp __alltraps
  100b8f:	e9 f3 06 00 00       	jmp    101287 <__alltraps>

00100b94 <vector101>:
.globl vector101
vector101:
  pushl $0
  100b94:	6a 00                	push   $0x0
  pushl $101
  100b96:	6a 65                	push   $0x65
  jmp __alltraps
  100b98:	e9 ea 06 00 00       	jmp    101287 <__alltraps>

00100b9d <vector102>:
.globl vector102
vector102:
  pushl $0
  100b9d:	6a 00                	push   $0x0
  pushl $102
  100b9f:	6a 66                	push   $0x66
  jmp __alltraps
  100ba1:	e9 e1 06 00 00       	jmp    101287 <__alltraps>

00100ba6 <vector103>:
.globl vector103
vector103:
  pushl $0
  100ba6:	6a 00                	push   $0x0
  pushl $103
  100ba8:	6a 67                	push   $0x67
  jmp __alltraps
  100baa:	e9 d8 06 00 00       	jmp    101287 <__alltraps>

00100baf <vector104>:
.globl vector104
vector104:
  pushl $0
  100baf:	6a 00                	push   $0x0
  pushl $104
  100bb1:	6a 68                	push   $0x68
  jmp __alltraps
  100bb3:	e9 cf 06 00 00       	jmp    101287 <__alltraps>

00100bb8 <vector105>:
.globl vector105
vector105:
  pushl $0
  100bb8:	6a 00                	push   $0x0
  pushl $105
  100bba:	6a 69                	push   $0x69
  jmp __alltraps
  100bbc:	e9 c6 06 00 00       	jmp    101287 <__alltraps>

00100bc1 <vector106>:
.globl vector106
vector106:
  pushl $0
  100bc1:	6a 00                	push   $0x0
  pushl $106
  100bc3:	6a 6a                	push   $0x6a
  jmp __alltraps
  100bc5:	e9 bd 06 00 00       	jmp    101287 <__alltraps>

00100bca <vector107>:
.globl vector107
vector107:
  pushl $0
  100bca:	6a 00                	push   $0x0
  pushl $107
  100bcc:	6a 6b                	push   $0x6b
  jmp __alltraps
  100bce:	e9 b4 06 00 00       	jmp    101287 <__alltraps>

00100bd3 <vector108>:
.globl vector108
vector108:
  pushl $0
  100bd3:	6a 00                	push   $0x0
  pushl $108
  100bd5:	6a 6c                	push   $0x6c
  jmp __alltraps
  100bd7:	e9 ab 06 00 00       	jmp    101287 <__alltraps>

00100bdc <vector109>:
.globl vector109
vector109:
  pushl $0
  100bdc:	6a 00                	push   $0x0
  pushl $109
  100bde:	6a 6d                	push   $0x6d
  jmp __alltraps
  100be0:	e9 a2 06 00 00       	jmp    101287 <__alltraps>

00100be5 <vector110>:
.globl vector110
vector110:
  pushl $0
  100be5:	6a 00                	push   $0x0
  pushl $110
  100be7:	6a 6e                	push   $0x6e
  jmp __alltraps
  100be9:	e9 99 06 00 00       	jmp    101287 <__alltraps>

00100bee <vector111>:
.globl vector111
vector111:
  pushl $0
  100bee:	6a 00                	push   $0x0
  pushl $111
  100bf0:	6a 6f                	push   $0x6f
  jmp __alltraps
  100bf2:	e9 90 06 00 00       	jmp    101287 <__alltraps>

00100bf7 <vector112>:
.globl vector112
vector112:
  pushl $0
  100bf7:	6a 00                	push   $0x0
  pushl $112
  100bf9:	6a 70                	push   $0x70
  jmp __alltraps
  100bfb:	e9 87 06 00 00       	jmp    101287 <__alltraps>

00100c00 <vector113>:
.globl vector113
vector113:
  pushl $0
  100c00:	6a 00                	push   $0x0
  pushl $113
  100c02:	6a 71                	push   $0x71
  jmp __alltraps
  100c04:	e9 7e 06 00 00       	jmp    101287 <__alltraps>

00100c09 <vector114>:
.globl vector114
vector114:
  pushl $0
  100c09:	6a 00                	push   $0x0
  pushl $114
  100c0b:	6a 72                	push   $0x72
  jmp __alltraps
  100c0d:	e9 75 06 00 00       	jmp    101287 <__alltraps>

00100c12 <vector115>:
.globl vector115
vector115:
  pushl $0
  100c12:	6a 00                	push   $0x0
  pushl $115
  100c14:	6a 73                	push   $0x73
  jmp __alltraps
  100c16:	e9 6c 06 00 00       	jmp    101287 <__alltraps>

00100c1b <vector116>:
.globl vector116
vector116:
  pushl $0
  100c1b:	6a 00                	push   $0x0
  pushl $116
  100c1d:	6a 74                	push   $0x74
  jmp __alltraps
  100c1f:	e9 63 06 00 00       	jmp    101287 <__alltraps>

00100c24 <vector117>:
.globl vector117
vector117:
  pushl $0
  100c24:	6a 00                	push   $0x0
  pushl $117
  100c26:	6a 75                	push   $0x75
  jmp __alltraps
  100c28:	e9 5a 06 00 00       	jmp    101287 <__alltraps>

00100c2d <vector118>:
.globl vector118
vector118:
  pushl $0
  100c2d:	6a 00                	push   $0x0
  pushl $118
  100c2f:	6a 76                	push   $0x76
  jmp __alltraps
  100c31:	e9 51 06 00 00       	jmp    101287 <__alltraps>

00100c36 <vector119>:
.globl vector119
vector119:
  pushl $0
  100c36:	6a 00                	push   $0x0
  pushl $119
  100c38:	6a 77                	push   $0x77
  jmp __alltraps
  100c3a:	e9 48 06 00 00       	jmp    101287 <__alltraps>

00100c3f <vector120>:
.globl vector120
vector120:
  pushl $0
  100c3f:	6a 00                	push   $0x0
  pushl $120
  100c41:	6a 78                	push   $0x78
  jmp __alltraps
  100c43:	e9 3f 06 00 00       	jmp    101287 <__alltraps>

00100c48 <vector121>:
.globl vector121
vector121:
  pushl $0
  100c48:	6a 00                	push   $0x0
  pushl $121
  100c4a:	6a 79                	push   $0x79
  jmp __alltraps
  100c4c:	e9 36 06 00 00       	jmp    101287 <__alltraps>

00100c51 <vector122>:
.globl vector122
vector122:
  pushl $0
  100c51:	6a 00                	push   $0x0
  pushl $122
  100c53:	6a 7a                	push   $0x7a
  jmp __alltraps
  100c55:	e9 2d 06 00 00       	jmp    101287 <__alltraps>

00100c5a <vector123>:
.globl vector123
vector123:
  pushl $0
  100c5a:	6a 00                	push   $0x0
  pushl $123
  100c5c:	6a 7b                	push   $0x7b
  jmp __alltraps
  100c5e:	e9 24 06 00 00       	jmp    101287 <__alltraps>

00100c63 <vector124>:
.globl vector124
vector124:
  pushl $0
  100c63:	6a 00                	push   $0x0
  pushl $124
  100c65:	6a 7c                	push   $0x7c
  jmp __alltraps
  100c67:	e9 1b 06 00 00       	jmp    101287 <__alltraps>

00100c6c <vector125>:
.globl vector125
vector125:
  pushl $0
  100c6c:	6a 00                	push   $0x0
  pushl $125
  100c6e:	6a 7d                	push   $0x7d
  jmp __alltraps
  100c70:	e9 12 06 00 00       	jmp    101287 <__alltraps>

00100c75 <vector126>:
.globl vector126
vector126:
  pushl $0
  100c75:	6a 00                	push   $0x0
  pushl $126
  100c77:	6a 7e                	push   $0x7e
  jmp __alltraps
  100c79:	e9 09 06 00 00       	jmp    101287 <__alltraps>

00100c7e <vector127>:
.globl vector127
vector127:
  pushl $0
  100c7e:	6a 00                	push   $0x0
  pushl $127
  100c80:	6a 7f                	push   $0x7f
  jmp __alltraps
  100c82:	e9 00 06 00 00       	jmp    101287 <__alltraps>

00100c87 <vector128>:
.globl vector128
vector128:
  pushl $0
  100c87:	6a 00                	push   $0x0
  pushl $128
  100c89:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  100c8e:	e9 f4 05 00 00       	jmp    101287 <__alltraps>

00100c93 <vector129>:
.globl vector129
vector129:
  pushl $0
  100c93:	6a 00                	push   $0x0
  pushl $129
  100c95:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  100c9a:	e9 e8 05 00 00       	jmp    101287 <__alltraps>

00100c9f <vector130>:
.globl vector130
vector130:
  pushl $0
  100c9f:	6a 00                	push   $0x0
  pushl $130
  100ca1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  100ca6:	e9 dc 05 00 00       	jmp    101287 <__alltraps>

00100cab <vector131>:
.globl vector131
vector131:
  pushl $0
  100cab:	6a 00                	push   $0x0
  pushl $131
  100cad:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  100cb2:	e9 d0 05 00 00       	jmp    101287 <__alltraps>

00100cb7 <vector132>:
.globl vector132
vector132:
  pushl $0
  100cb7:	6a 00                	push   $0x0
  pushl $132
  100cb9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  100cbe:	e9 c4 05 00 00       	jmp    101287 <__alltraps>

00100cc3 <vector133>:
.globl vector133
vector133:
  pushl $0
  100cc3:	6a 00                	push   $0x0
  pushl $133
  100cc5:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  100cca:	e9 b8 05 00 00       	jmp    101287 <__alltraps>

00100ccf <vector134>:
.globl vector134
vector134:
  pushl $0
  100ccf:	6a 00                	push   $0x0
  pushl $134
  100cd1:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  100cd6:	e9 ac 05 00 00       	jmp    101287 <__alltraps>

00100cdb <vector135>:
.globl vector135
vector135:
  pushl $0
  100cdb:	6a 00                	push   $0x0
  pushl $135
  100cdd:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  100ce2:	e9 a0 05 00 00       	jmp    101287 <__alltraps>

00100ce7 <vector136>:
.globl vector136
vector136:
  pushl $0
  100ce7:	6a 00                	push   $0x0
  pushl $136
  100ce9:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  100cee:	e9 94 05 00 00       	jmp    101287 <__alltraps>

00100cf3 <vector137>:
.globl vector137
vector137:
  pushl $0
  100cf3:	6a 00                	push   $0x0
  pushl $137
  100cf5:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  100cfa:	e9 88 05 00 00       	jmp    101287 <__alltraps>

00100cff <vector138>:
.globl vector138
vector138:
  pushl $0
  100cff:	6a 00                	push   $0x0
  pushl $138
  100d01:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  100d06:	e9 7c 05 00 00       	jmp    101287 <__alltraps>

00100d0b <vector139>:
.globl vector139
vector139:
  pushl $0
  100d0b:	6a 00                	push   $0x0
  pushl $139
  100d0d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  100d12:	e9 70 05 00 00       	jmp    101287 <__alltraps>

00100d17 <vector140>:
.globl vector140
vector140:
  pushl $0
  100d17:	6a 00                	push   $0x0
  pushl $140
  100d19:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  100d1e:	e9 64 05 00 00       	jmp    101287 <__alltraps>

00100d23 <vector141>:
.globl vector141
vector141:
  pushl $0
  100d23:	6a 00                	push   $0x0
  pushl $141
  100d25:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  100d2a:	e9 58 05 00 00       	jmp    101287 <__alltraps>

00100d2f <vector142>:
.globl vector142
vector142:
  pushl $0
  100d2f:	6a 00                	push   $0x0
  pushl $142
  100d31:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  100d36:	e9 4c 05 00 00       	jmp    101287 <__alltraps>

00100d3b <vector143>:
.globl vector143
vector143:
  pushl $0
  100d3b:	6a 00                	push   $0x0
  pushl $143
  100d3d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  100d42:	e9 40 05 00 00       	jmp    101287 <__alltraps>

00100d47 <vector144>:
.globl vector144
vector144:
  pushl $0
  100d47:	6a 00                	push   $0x0
  pushl $144
  100d49:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  100d4e:	e9 34 05 00 00       	jmp    101287 <__alltraps>

00100d53 <vector145>:
.globl vector145
vector145:
  pushl $0
  100d53:	6a 00                	push   $0x0
  pushl $145
  100d55:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  100d5a:	e9 28 05 00 00       	jmp    101287 <__alltraps>

00100d5f <vector146>:
.globl vector146
vector146:
  pushl $0
  100d5f:	6a 00                	push   $0x0
  pushl $146
  100d61:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  100d66:	e9 1c 05 00 00       	jmp    101287 <__alltraps>

00100d6b <vector147>:
.globl vector147
vector147:
  pushl $0
  100d6b:	6a 00                	push   $0x0
  pushl $147
  100d6d:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  100d72:	e9 10 05 00 00       	jmp    101287 <__alltraps>

00100d77 <vector148>:
.globl vector148
vector148:
  pushl $0
  100d77:	6a 00                	push   $0x0
  pushl $148
  100d79:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  100d7e:	e9 04 05 00 00       	jmp    101287 <__alltraps>

00100d83 <vector149>:
.globl vector149
vector149:
  pushl $0
  100d83:	6a 00                	push   $0x0
  pushl $149
  100d85:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  100d8a:	e9 f8 04 00 00       	jmp    101287 <__alltraps>

00100d8f <vector150>:
.globl vector150
vector150:
  pushl $0
  100d8f:	6a 00                	push   $0x0
  pushl $150
  100d91:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  100d96:	e9 ec 04 00 00       	jmp    101287 <__alltraps>

00100d9b <vector151>:
.globl vector151
vector151:
  pushl $0
  100d9b:	6a 00                	push   $0x0
  pushl $151
  100d9d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  100da2:	e9 e0 04 00 00       	jmp    101287 <__alltraps>

00100da7 <vector152>:
.globl vector152
vector152:
  pushl $0
  100da7:	6a 00                	push   $0x0
  pushl $152
  100da9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  100dae:	e9 d4 04 00 00       	jmp    101287 <__alltraps>

00100db3 <vector153>:
.globl vector153
vector153:
  pushl $0
  100db3:	6a 00                	push   $0x0
  pushl $153
  100db5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  100dba:	e9 c8 04 00 00       	jmp    101287 <__alltraps>

00100dbf <vector154>:
.globl vector154
vector154:
  pushl $0
  100dbf:	6a 00                	push   $0x0
  pushl $154
  100dc1:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  100dc6:	e9 bc 04 00 00       	jmp    101287 <__alltraps>

00100dcb <vector155>:
.globl vector155
vector155:
  pushl $0
  100dcb:	6a 00                	push   $0x0
  pushl $155
  100dcd:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  100dd2:	e9 b0 04 00 00       	jmp    101287 <__alltraps>

00100dd7 <vector156>:
.globl vector156
vector156:
  pushl $0
  100dd7:	6a 00                	push   $0x0
  pushl $156
  100dd9:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  100dde:	e9 a4 04 00 00       	jmp    101287 <__alltraps>

00100de3 <vector157>:
.globl vector157
vector157:
  pushl $0
  100de3:	6a 00                	push   $0x0
  pushl $157
  100de5:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  100dea:	e9 98 04 00 00       	jmp    101287 <__alltraps>

00100def <vector158>:
.globl vector158
vector158:
  pushl $0
  100def:	6a 00                	push   $0x0
  pushl $158
  100df1:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  100df6:	e9 8c 04 00 00       	jmp    101287 <__alltraps>

00100dfb <vector159>:
.globl vector159
vector159:
  pushl $0
  100dfb:	6a 00                	push   $0x0
  pushl $159
  100dfd:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  100e02:	e9 80 04 00 00       	jmp    101287 <__alltraps>

00100e07 <vector160>:
.globl vector160
vector160:
  pushl $0
  100e07:	6a 00                	push   $0x0
  pushl $160
  100e09:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  100e0e:	e9 74 04 00 00       	jmp    101287 <__alltraps>

00100e13 <vector161>:
.globl vector161
vector161:
  pushl $0
  100e13:	6a 00                	push   $0x0
  pushl $161
  100e15:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  100e1a:	e9 68 04 00 00       	jmp    101287 <__alltraps>

00100e1f <vector162>:
.globl vector162
vector162:
  pushl $0
  100e1f:	6a 00                	push   $0x0
  pushl $162
  100e21:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  100e26:	e9 5c 04 00 00       	jmp    101287 <__alltraps>

00100e2b <vector163>:
.globl vector163
vector163:
  pushl $0
  100e2b:	6a 00                	push   $0x0
  pushl $163
  100e2d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  100e32:	e9 50 04 00 00       	jmp    101287 <__alltraps>

00100e37 <vector164>:
.globl vector164
vector164:
  pushl $0
  100e37:	6a 00                	push   $0x0
  pushl $164
  100e39:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  100e3e:	e9 44 04 00 00       	jmp    101287 <__alltraps>

00100e43 <vector165>:
.globl vector165
vector165:
  pushl $0
  100e43:	6a 00                	push   $0x0
  pushl $165
  100e45:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  100e4a:	e9 38 04 00 00       	jmp    101287 <__alltraps>

00100e4f <vector166>:
.globl vector166
vector166:
  pushl $0
  100e4f:	6a 00                	push   $0x0
  pushl $166
  100e51:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  100e56:	e9 2c 04 00 00       	jmp    101287 <__alltraps>

00100e5b <vector167>:
.globl vector167
vector167:
  pushl $0
  100e5b:	6a 00                	push   $0x0
  pushl $167
  100e5d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  100e62:	e9 20 04 00 00       	jmp    101287 <__alltraps>

00100e67 <vector168>:
.globl vector168
vector168:
  pushl $0
  100e67:	6a 00                	push   $0x0
  pushl $168
  100e69:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  100e6e:	e9 14 04 00 00       	jmp    101287 <__alltraps>

00100e73 <vector169>:
.globl vector169
vector169:
  pushl $0
  100e73:	6a 00                	push   $0x0
  pushl $169
  100e75:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  100e7a:	e9 08 04 00 00       	jmp    101287 <__alltraps>

00100e7f <vector170>:
.globl vector170
vector170:
  pushl $0
  100e7f:	6a 00                	push   $0x0
  pushl $170
  100e81:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  100e86:	e9 fc 03 00 00       	jmp    101287 <__alltraps>

00100e8b <vector171>:
.globl vector171
vector171:
  pushl $0
  100e8b:	6a 00                	push   $0x0
  pushl $171
  100e8d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  100e92:	e9 f0 03 00 00       	jmp    101287 <__alltraps>

00100e97 <vector172>:
.globl vector172
vector172:
  pushl $0
  100e97:	6a 00                	push   $0x0
  pushl $172
  100e99:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  100e9e:	e9 e4 03 00 00       	jmp    101287 <__alltraps>

00100ea3 <vector173>:
.globl vector173
vector173:
  pushl $0
  100ea3:	6a 00                	push   $0x0
  pushl $173
  100ea5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  100eaa:	e9 d8 03 00 00       	jmp    101287 <__alltraps>

00100eaf <vector174>:
.globl vector174
vector174:
  pushl $0
  100eaf:	6a 00                	push   $0x0
  pushl $174
  100eb1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  100eb6:	e9 cc 03 00 00       	jmp    101287 <__alltraps>

00100ebb <vector175>:
.globl vector175
vector175:
  pushl $0
  100ebb:	6a 00                	push   $0x0
  pushl $175
  100ebd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  100ec2:	e9 c0 03 00 00       	jmp    101287 <__alltraps>

00100ec7 <vector176>:
.globl vector176
vector176:
  pushl $0
  100ec7:	6a 00                	push   $0x0
  pushl $176
  100ec9:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  100ece:	e9 b4 03 00 00       	jmp    101287 <__alltraps>

00100ed3 <vector177>:
.globl vector177
vector177:
  pushl $0
  100ed3:	6a 00                	push   $0x0
  pushl $177
  100ed5:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  100eda:	e9 a8 03 00 00       	jmp    101287 <__alltraps>

00100edf <vector178>:
.globl vector178
vector178:
  pushl $0
  100edf:	6a 00                	push   $0x0
  pushl $178
  100ee1:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  100ee6:	e9 9c 03 00 00       	jmp    101287 <__alltraps>

00100eeb <vector179>:
.globl vector179
vector179:
  pushl $0
  100eeb:	6a 00                	push   $0x0
  pushl $179
  100eed:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  100ef2:	e9 90 03 00 00       	jmp    101287 <__alltraps>

00100ef7 <vector180>:
.globl vector180
vector180:
  pushl $0
  100ef7:	6a 00                	push   $0x0
  pushl $180
  100ef9:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  100efe:	e9 84 03 00 00       	jmp    101287 <__alltraps>

00100f03 <vector181>:
.globl vector181
vector181:
  pushl $0
  100f03:	6a 00                	push   $0x0
  pushl $181
  100f05:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  100f0a:	e9 78 03 00 00       	jmp    101287 <__alltraps>

00100f0f <vector182>:
.globl vector182
vector182:
  pushl $0
  100f0f:	6a 00                	push   $0x0
  pushl $182
  100f11:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  100f16:	e9 6c 03 00 00       	jmp    101287 <__alltraps>

00100f1b <vector183>:
.globl vector183
vector183:
  pushl $0
  100f1b:	6a 00                	push   $0x0
  pushl $183
  100f1d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  100f22:	e9 60 03 00 00       	jmp    101287 <__alltraps>

00100f27 <vector184>:
.globl vector184
vector184:
  pushl $0
  100f27:	6a 00                	push   $0x0
  pushl $184
  100f29:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  100f2e:	e9 54 03 00 00       	jmp    101287 <__alltraps>

00100f33 <vector185>:
.globl vector185
vector185:
  pushl $0
  100f33:	6a 00                	push   $0x0
  pushl $185
  100f35:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  100f3a:	e9 48 03 00 00       	jmp    101287 <__alltraps>

00100f3f <vector186>:
.globl vector186
vector186:
  pushl $0
  100f3f:	6a 00                	push   $0x0
  pushl $186
  100f41:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  100f46:	e9 3c 03 00 00       	jmp    101287 <__alltraps>

00100f4b <vector187>:
.globl vector187
vector187:
  pushl $0
  100f4b:	6a 00                	push   $0x0
  pushl $187
  100f4d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  100f52:	e9 30 03 00 00       	jmp    101287 <__alltraps>

00100f57 <vector188>:
.globl vector188
vector188:
  pushl $0
  100f57:	6a 00                	push   $0x0
  pushl $188
  100f59:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  100f5e:	e9 24 03 00 00       	jmp    101287 <__alltraps>

00100f63 <vector189>:
.globl vector189
vector189:
  pushl $0
  100f63:	6a 00                	push   $0x0
  pushl $189
  100f65:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  100f6a:	e9 18 03 00 00       	jmp    101287 <__alltraps>

00100f6f <vector190>:
.globl vector190
vector190:
  pushl $0
  100f6f:	6a 00                	push   $0x0
  pushl $190
  100f71:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  100f76:	e9 0c 03 00 00       	jmp    101287 <__alltraps>

00100f7b <vector191>:
.globl vector191
vector191:
  pushl $0
  100f7b:	6a 00                	push   $0x0
  pushl $191
  100f7d:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  100f82:	e9 00 03 00 00       	jmp    101287 <__alltraps>

00100f87 <vector192>:
.globl vector192
vector192:
  pushl $0
  100f87:	6a 00                	push   $0x0
  pushl $192
  100f89:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  100f8e:	e9 f4 02 00 00       	jmp    101287 <__alltraps>

00100f93 <vector193>:
.globl vector193
vector193:
  pushl $0
  100f93:	6a 00                	push   $0x0
  pushl $193
  100f95:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  100f9a:	e9 e8 02 00 00       	jmp    101287 <__alltraps>

00100f9f <vector194>:
.globl vector194
vector194:
  pushl $0
  100f9f:	6a 00                	push   $0x0
  pushl $194
  100fa1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  100fa6:	e9 dc 02 00 00       	jmp    101287 <__alltraps>

00100fab <vector195>:
.globl vector195
vector195:
  pushl $0
  100fab:	6a 00                	push   $0x0
  pushl $195
  100fad:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  100fb2:	e9 d0 02 00 00       	jmp    101287 <__alltraps>

00100fb7 <vector196>:
.globl vector196
vector196:
  pushl $0
  100fb7:	6a 00                	push   $0x0
  pushl $196
  100fb9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  100fbe:	e9 c4 02 00 00       	jmp    101287 <__alltraps>

00100fc3 <vector197>:
.globl vector197
vector197:
  pushl $0
  100fc3:	6a 00                	push   $0x0
  pushl $197
  100fc5:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  100fca:	e9 b8 02 00 00       	jmp    101287 <__alltraps>

00100fcf <vector198>:
.globl vector198
vector198:
  pushl $0
  100fcf:	6a 00                	push   $0x0
  pushl $198
  100fd1:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  100fd6:	e9 ac 02 00 00       	jmp    101287 <__alltraps>

00100fdb <vector199>:
.globl vector199
vector199:
  pushl $0
  100fdb:	6a 00                	push   $0x0
  pushl $199
  100fdd:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  100fe2:	e9 a0 02 00 00       	jmp    101287 <__alltraps>

00100fe7 <vector200>:
.globl vector200
vector200:
  pushl $0
  100fe7:	6a 00                	push   $0x0
  pushl $200
  100fe9:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  100fee:	e9 94 02 00 00       	jmp    101287 <__alltraps>

00100ff3 <vector201>:
.globl vector201
vector201:
  pushl $0
  100ff3:	6a 00                	push   $0x0
  pushl $201
  100ff5:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  100ffa:	e9 88 02 00 00       	jmp    101287 <__alltraps>

00100fff <vector202>:
.globl vector202
vector202:
  pushl $0
  100fff:	6a 00                	push   $0x0
  pushl $202
  101001:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  101006:	e9 7c 02 00 00       	jmp    101287 <__alltraps>

0010100b <vector203>:
.globl vector203
vector203:
  pushl $0
  10100b:	6a 00                	push   $0x0
  pushl $203
  10100d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  101012:	e9 70 02 00 00       	jmp    101287 <__alltraps>

00101017 <vector204>:
.globl vector204
vector204:
  pushl $0
  101017:	6a 00                	push   $0x0
  pushl $204
  101019:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10101e:	e9 64 02 00 00       	jmp    101287 <__alltraps>

00101023 <vector205>:
.globl vector205
vector205:
  pushl $0
  101023:	6a 00                	push   $0x0
  pushl $205
  101025:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10102a:	e9 58 02 00 00       	jmp    101287 <__alltraps>

0010102f <vector206>:
.globl vector206
vector206:
  pushl $0
  10102f:	6a 00                	push   $0x0
  pushl $206
  101031:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  101036:	e9 4c 02 00 00       	jmp    101287 <__alltraps>

0010103b <vector207>:
.globl vector207
vector207:
  pushl $0
  10103b:	6a 00                	push   $0x0
  pushl $207
  10103d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  101042:	e9 40 02 00 00       	jmp    101287 <__alltraps>

00101047 <vector208>:
.globl vector208
vector208:
  pushl $0
  101047:	6a 00                	push   $0x0
  pushl $208
  101049:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10104e:	e9 34 02 00 00       	jmp    101287 <__alltraps>

00101053 <vector209>:
.globl vector209
vector209:
  pushl $0
  101053:	6a 00                	push   $0x0
  pushl $209
  101055:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10105a:	e9 28 02 00 00       	jmp    101287 <__alltraps>

0010105f <vector210>:
.globl vector210
vector210:
  pushl $0
  10105f:	6a 00                	push   $0x0
  pushl $210
  101061:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  101066:	e9 1c 02 00 00       	jmp    101287 <__alltraps>

0010106b <vector211>:
.globl vector211
vector211:
  pushl $0
  10106b:	6a 00                	push   $0x0
  pushl $211
  10106d:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  101072:	e9 10 02 00 00       	jmp    101287 <__alltraps>

00101077 <vector212>:
.globl vector212
vector212:
  pushl $0
  101077:	6a 00                	push   $0x0
  pushl $212
  101079:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10107e:	e9 04 02 00 00       	jmp    101287 <__alltraps>

00101083 <vector213>:
.globl vector213
vector213:
  pushl $0
  101083:	6a 00                	push   $0x0
  pushl $213
  101085:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10108a:	e9 f8 01 00 00       	jmp    101287 <__alltraps>

0010108f <vector214>:
.globl vector214
vector214:
  pushl $0
  10108f:	6a 00                	push   $0x0
  pushl $214
  101091:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  101096:	e9 ec 01 00 00       	jmp    101287 <__alltraps>

0010109b <vector215>:
.globl vector215
vector215:
  pushl $0
  10109b:	6a 00                	push   $0x0
  pushl $215
  10109d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1010a2:	e9 e0 01 00 00       	jmp    101287 <__alltraps>

001010a7 <vector216>:
.globl vector216
vector216:
  pushl $0
  1010a7:	6a 00                	push   $0x0
  pushl $216
  1010a9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1010ae:	e9 d4 01 00 00       	jmp    101287 <__alltraps>

001010b3 <vector217>:
.globl vector217
vector217:
  pushl $0
  1010b3:	6a 00                	push   $0x0
  pushl $217
  1010b5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1010ba:	e9 c8 01 00 00       	jmp    101287 <__alltraps>

001010bf <vector218>:
.globl vector218
vector218:
  pushl $0
  1010bf:	6a 00                	push   $0x0
  pushl $218
  1010c1:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1010c6:	e9 bc 01 00 00       	jmp    101287 <__alltraps>

001010cb <vector219>:
.globl vector219
vector219:
  pushl $0
  1010cb:	6a 00                	push   $0x0
  pushl $219
  1010cd:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1010d2:	e9 b0 01 00 00       	jmp    101287 <__alltraps>

001010d7 <vector220>:
.globl vector220
vector220:
  pushl $0
  1010d7:	6a 00                	push   $0x0
  pushl $220
  1010d9:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1010de:	e9 a4 01 00 00       	jmp    101287 <__alltraps>

001010e3 <vector221>:
.globl vector221
vector221:
  pushl $0
  1010e3:	6a 00                	push   $0x0
  pushl $221
  1010e5:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1010ea:	e9 98 01 00 00       	jmp    101287 <__alltraps>

001010ef <vector222>:
.globl vector222
vector222:
  pushl $0
  1010ef:	6a 00                	push   $0x0
  pushl $222
  1010f1:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1010f6:	e9 8c 01 00 00       	jmp    101287 <__alltraps>

001010fb <vector223>:
.globl vector223
vector223:
  pushl $0
  1010fb:	6a 00                	push   $0x0
  pushl $223
  1010fd:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  101102:	e9 80 01 00 00       	jmp    101287 <__alltraps>

00101107 <vector224>:
.globl vector224
vector224:
  pushl $0
  101107:	6a 00                	push   $0x0
  pushl $224
  101109:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10110e:	e9 74 01 00 00       	jmp    101287 <__alltraps>

00101113 <vector225>:
.globl vector225
vector225:
  pushl $0
  101113:	6a 00                	push   $0x0
  pushl $225
  101115:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10111a:	e9 68 01 00 00       	jmp    101287 <__alltraps>

0010111f <vector226>:
.globl vector226
vector226:
  pushl $0
  10111f:	6a 00                	push   $0x0
  pushl $226
  101121:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  101126:	e9 5c 01 00 00       	jmp    101287 <__alltraps>

0010112b <vector227>:
.globl vector227
vector227:
  pushl $0
  10112b:	6a 00                	push   $0x0
  pushl $227
  10112d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  101132:	e9 50 01 00 00       	jmp    101287 <__alltraps>

00101137 <vector228>:
.globl vector228
vector228:
  pushl $0
  101137:	6a 00                	push   $0x0
  pushl $228
  101139:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10113e:	e9 44 01 00 00       	jmp    101287 <__alltraps>

00101143 <vector229>:
.globl vector229
vector229:
  pushl $0
  101143:	6a 00                	push   $0x0
  pushl $229
  101145:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10114a:	e9 38 01 00 00       	jmp    101287 <__alltraps>

0010114f <vector230>:
.globl vector230
vector230:
  pushl $0
  10114f:	6a 00                	push   $0x0
  pushl $230
  101151:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  101156:	e9 2c 01 00 00       	jmp    101287 <__alltraps>

0010115b <vector231>:
.globl vector231
vector231:
  pushl $0
  10115b:	6a 00                	push   $0x0
  pushl $231
  10115d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  101162:	e9 20 01 00 00       	jmp    101287 <__alltraps>

00101167 <vector232>:
.globl vector232
vector232:
  pushl $0
  101167:	6a 00                	push   $0x0
  pushl $232
  101169:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10116e:	e9 14 01 00 00       	jmp    101287 <__alltraps>

00101173 <vector233>:
.globl vector233
vector233:
  pushl $0
  101173:	6a 00                	push   $0x0
  pushl $233
  101175:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10117a:	e9 08 01 00 00       	jmp    101287 <__alltraps>

0010117f <vector234>:
.globl vector234
vector234:
  pushl $0
  10117f:	6a 00                	push   $0x0
  pushl $234
  101181:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  101186:	e9 fc 00 00 00       	jmp    101287 <__alltraps>

0010118b <vector235>:
.globl vector235
vector235:
  pushl $0
  10118b:	6a 00                	push   $0x0
  pushl $235
  10118d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  101192:	e9 f0 00 00 00       	jmp    101287 <__alltraps>

00101197 <vector236>:
.globl vector236
vector236:
  pushl $0
  101197:	6a 00                	push   $0x0
  pushl $236
  101199:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10119e:	e9 e4 00 00 00       	jmp    101287 <__alltraps>

001011a3 <vector237>:
.globl vector237
vector237:
  pushl $0
  1011a3:	6a 00                	push   $0x0
  pushl $237
  1011a5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1011aa:	e9 d8 00 00 00       	jmp    101287 <__alltraps>

001011af <vector238>:
.globl vector238
vector238:
  pushl $0
  1011af:	6a 00                	push   $0x0
  pushl $238
  1011b1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1011b6:	e9 cc 00 00 00       	jmp    101287 <__alltraps>

001011bb <vector239>:
.globl vector239
vector239:
  pushl $0
  1011bb:	6a 00                	push   $0x0
  pushl $239
  1011bd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1011c2:	e9 c0 00 00 00       	jmp    101287 <__alltraps>

001011c7 <vector240>:
.globl vector240
vector240:
  pushl $0
  1011c7:	6a 00                	push   $0x0
  pushl $240
  1011c9:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1011ce:	e9 b4 00 00 00       	jmp    101287 <__alltraps>

001011d3 <vector241>:
.globl vector241
vector241:
  pushl $0
  1011d3:	6a 00                	push   $0x0
  pushl $241
  1011d5:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1011da:	e9 a8 00 00 00       	jmp    101287 <__alltraps>

001011df <vector242>:
.globl vector242
vector242:
  pushl $0
  1011df:	6a 00                	push   $0x0
  pushl $242
  1011e1:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1011e6:	e9 9c 00 00 00       	jmp    101287 <__alltraps>

001011eb <vector243>:
.globl vector243
vector243:
  pushl $0
  1011eb:	6a 00                	push   $0x0
  pushl $243
  1011ed:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1011f2:	e9 90 00 00 00       	jmp    101287 <__alltraps>

001011f7 <vector244>:
.globl vector244
vector244:
  pushl $0
  1011f7:	6a 00                	push   $0x0
  pushl $244
  1011f9:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1011fe:	e9 84 00 00 00       	jmp    101287 <__alltraps>

00101203 <vector245>:
.globl vector245
vector245:
  pushl $0
  101203:	6a 00                	push   $0x0
  pushl $245
  101205:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10120a:	e9 78 00 00 00       	jmp    101287 <__alltraps>

0010120f <vector246>:
.globl vector246
vector246:
  pushl $0
  10120f:	6a 00                	push   $0x0
  pushl $246
  101211:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  101216:	e9 6c 00 00 00       	jmp    101287 <__alltraps>

0010121b <vector247>:
.globl vector247
vector247:
  pushl $0
  10121b:	6a 00                	push   $0x0
  pushl $247
  10121d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  101222:	e9 60 00 00 00       	jmp    101287 <__alltraps>

00101227 <vector248>:
.globl vector248
vector248:
  pushl $0
  101227:	6a 00                	push   $0x0
  pushl $248
  101229:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10122e:	e9 54 00 00 00       	jmp    101287 <__alltraps>

00101233 <vector249>:
.globl vector249
vector249:
  pushl $0
  101233:	6a 00                	push   $0x0
  pushl $249
  101235:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10123a:	e9 48 00 00 00       	jmp    101287 <__alltraps>

0010123f <vector250>:
.globl vector250
vector250:
  pushl $0
  10123f:	6a 00                	push   $0x0
  pushl $250
  101241:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  101246:	e9 3c 00 00 00       	jmp    101287 <__alltraps>

0010124b <vector251>:
.globl vector251
vector251:
  pushl $0
  10124b:	6a 00                	push   $0x0
  pushl $251
  10124d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  101252:	e9 30 00 00 00       	jmp    101287 <__alltraps>

00101257 <vector252>:
.globl vector252
vector252:
  pushl $0
  101257:	6a 00                	push   $0x0
  pushl $252
  101259:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10125e:	e9 24 00 00 00       	jmp    101287 <__alltraps>

00101263 <vector253>:
.globl vector253
vector253:
  pushl $0
  101263:	6a 00                	push   $0x0
  pushl $253
  101265:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10126a:	e9 18 00 00 00       	jmp    101287 <__alltraps>

0010126f <vector254>:
.globl vector254
vector254:
  pushl $0
  10126f:	6a 00                	push   $0x0
  pushl $254
  101271:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  101276:	e9 0c 00 00 00       	jmp    101287 <__alltraps>

0010127b <vector255>:
.globl vector255
vector255:
  pushl $0
  10127b:	6a 00                	push   $0x0
  pushl $255
  10127d:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  101282:	e9 00 00 00 00       	jmp    101287 <__alltraps>

00101287 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101287:	1e                   	push   %ds
    pushl %es
  101288:	06                   	push   %es
    pushal
  101289:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10128a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10128f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101291:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101293:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101294:	e8 6d f5 ff ff       	call   100806 <trap>

    # pop the pushed stack pointer
    popl %esp
  101299:	5c                   	pop    %esp

0010129a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10129a:	61                   	popa   

    # restore %ds and %es
    popl %es
  10129b:	07                   	pop    %es
    popl %ds
  10129c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10129d:	83 c4 08             	add    $0x8,%esp
    iret
  1012a0:	cf                   	iret   

001012a1 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1012a1:	55                   	push   %ebp
  1012a2:	89 e5                	mov    %esp,%ebp
  1012a4:	83 ec 10             	sub    $0x10,%esp
	size_t cnt = 0;
  1012a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (*s ++ != '\0') {
  1012ae:	eb 04                	jmp    1012b4 <strlen+0x13>
		cnt++;
  1012b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
	size_t cnt = 0;
	while (*s ++ != '\0') {
  1012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b7:	8d 50 01             	lea    0x1(%eax),%edx
  1012ba:	89 55 08             	mov    %edx,0x8(%ebp)
  1012bd:	0f b6 00             	movzbl (%eax),%eax
  1012c0:	84 c0                	test   %al,%al
  1012c2:	75 ec                	jne    1012b0 <strlen+0xf>
		cnt++;
	}
	return cnt;
  1012c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1012c7:	c9                   	leave  
  1012c8:	c3                   	ret    

001012c9 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  1012c9:	55                   	push   %ebp
  1012ca:	89 e5                	mov    %esp,%ebp
  1012cc:	83 ec 14             	sub    $0x14,%esp
  1012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1012d2:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  1012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  1012db:	eb 0f                	jmp    1012ec <memset+0x23>
		*p ++ = c;
  1012dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1012e0:	8d 50 01             	lea    0x1(%eax),%edx
  1012e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  1012e6:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  1012ea:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  1012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1012ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1012f2:	89 55 10             	mov    %edx,0x10(%ebp)
  1012f5:	85 c0                	test   %eax,%eax
  1012f7:	75 e4                	jne    1012dd <memset+0x14>
		*p ++ = c;
	}
	return s;
  1012f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1012fc:	c9                   	leave  
  1012fd:	c3                   	ret    

001012fe <memmove>:
/*
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
  1012fe:	55                   	push   %ebp
  1012ff:	89 e5                	mov    %esp,%ebp
  101301:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  101304:	8b 45 0c             	mov    0xc(%ebp),%eax
  101307:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  10130a:	8b 45 08             	mov    0x8(%ebp),%eax
  10130d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  101310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101313:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101316:	73 54                	jae    10136c <memmove+0x6e>
  101318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10131b:	8b 45 10             	mov    0x10(%ebp),%eax
  10131e:	01 d0                	add    %edx,%eax
  101320:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101323:	76 47                	jbe    10136c <memmove+0x6e>
        s += n, d += n;
  101325:	8b 45 10             	mov    0x10(%ebp),%eax
  101328:	01 45 fc             	add    %eax,-0x4(%ebp)
  10132b:	8b 45 10             	mov    0x10(%ebp),%eax
  10132e:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  101331:	eb 13                	jmp    101346 <memmove+0x48>
            *-- d = *-- s;
  101333:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  101337:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10133e:	0f b6 10             	movzbl (%eax),%edx
  101341:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101344:	88 10                	mov    %dl,(%eax)
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  101346:	8b 45 10             	mov    0x10(%ebp),%eax
  101349:	8d 50 ff             	lea    -0x1(%eax),%edx
  10134c:	89 55 10             	mov    %edx,0x10(%ebp)
  10134f:	85 c0                	test   %eax,%eax
  101351:	75 e0                	jne    101333 <memmove+0x35>
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  101353:	eb 24                	jmp    101379 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  101355:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101358:	8d 50 01             	lea    0x1(%eax),%edx
  10135b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10135e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101361:	8d 4a 01             	lea    0x1(%edx),%ecx
  101364:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  101367:	0f b6 12             	movzbl (%edx),%edx
  10136a:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  10136c:	8b 45 10             	mov    0x10(%ebp),%eax
  10136f:	8d 50 ff             	lea    -0x1(%eax),%edx
  101372:	89 55 10             	mov    %edx,0x10(%ebp)
  101375:	85 c0                	test   %eax,%eax
  101377:	75 dc                	jne    101355 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  101379:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10137c:	c9                   	leave  
  10137d:	c3                   	ret    

0010137e <test_memset>:
#include <string.h>

/*
 * void *memset(void *s, char c, size_t n);
 * */
int test_memset() {
  10137e:	55                   	push   %ebp
  10137f:	89 e5                	mov    %esp,%ebp
  101381:	83 ec 18             	sub    $0x18,%esp
	char *p = "abcdefg";
  101384:	c7 45 f4 e6 13 10 00 	movl   $0x1013e6,-0xc(%ebp)
	char *s = memset(p, 'c', 3);
  10138b:	83 ec 04             	sub    $0x4,%esp
  10138e:	6a 03                	push   $0x3
  101390:	6a 63                	push   $0x63
  101392:	ff 75 f4             	pushl  -0xc(%ebp)
  101395:	e8 2f ff ff ff       	call   1012c9 <memset>
  10139a:	83 c4 10             	add    $0x10,%esp
  10139d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return 0;
  1013a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1013a5:	c9                   	leave  
  1013a6:	c3                   	ret    

001013a7 <testmain>:


int testmain() {
  1013a7:	55                   	push   %ebp
  1013a8:	89 e5                	mov    %esp,%ebp
  1013aa:	83 ec 08             	sub    $0x8,%esp

	test_memset();
  1013ad:	e8 cc ff ff ff       	call   10137e <test_memset>
	return 0;
  1013b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    
