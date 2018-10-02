
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <init_driver>:
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));
 static void switch_test(void);

void init_driver() {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 08             	sub    $0x8,%esp
	cons_init();                // init the console, 对串口、键盘和时钟外设的中断初始化
  100006:	e8 39 09 00 00       	call   100944 <cons_init>
	pic_init();                 // init interrupt controller, 中断控制器的初始化工作
  10000b:	e8 77 0a 00 00       	call   100a87 <pic_init>
	idt_init();                 // init interrupt descriptor table, 对整个中断门描述符表的创建
  100010:	e8 d6 0b 00 00       	call   100beb <idt_init>
	intr_enable();				 // enable irq interrupt
  100015:	e8 aa 0b 00 00       	call   100bc4 <intr_enable>
//	sti();
}
  10001a:	90                   	nop
  10001b:	c9                   	leave  
  10001c:	c3                   	ret    

0010001d <unite_test>:


void unite_test() {
  10001d:	55                   	push   %ebp
  10001e:	89 e5                	mov    %esp,%ebp
  100020:	83 ec 08             	sub    $0x8,%esp
	testmain();
  100023:	e8 55 1a 00 00       	call   101a7d <testmain>
}
  100028:	90                   	nop
  100029:	c9                   	leave  
  10002a:	c3                   	ret    

0010002b <kern_init>:


int
kern_init(void) {
  10002b:	55                   	push   %ebp
  10002c:	89 e5                	mov    %esp,%ebp
  10002e:	83 ec 18             	sub    $0x18,%esp
	init_driver();
  100031:	e8 ca ff ff ff       	call   100000 <init_driver>
	unite_test();
  100036:	e8 e2 ff ff ff       	call   10001d <unite_test>
	int a = 1;
  10003b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	a = a + 3;
  100042:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
	char *s = "ddss";
  100046:	c7 45 f0 90 1a 10 00 	movl   $0x101a90,-0x10(%ebp)
	int l = strlen(s);
  10004d:	83 ec 0c             	sub    $0xc,%esp
  100050:	ff 75 f0             	pushl  -0x10(%ebp)
  100053:	e8 1f 19 00 00       	call   101977 <strlen>
  100058:	83 c4 10             	add    $0x10,%esp
  10005b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	const char *msg = "hello lmo-os";
  10005e:	c7 45 e8 95 1a 10 00 	movl   $0x101a95,-0x18(%ebp)
	cprintf(msg);
  100065:	83 ec 0c             	sub    $0xc,%esp
  100068:	ff 75 e8             	pushl  -0x18(%ebp)
  10006b:	e8 ad 00 00 00       	call   10011d <cprintf>
  100070:	83 c4 10             	add    $0x10,%esp

	// user/kernel mode switch test
//	    switch_test();

     while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x48>

00100075 <switch_to_user>:
//		return 0;
}

static void
switch_to_user(void) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
    asm volatile ("int %0\n" :: "i" (T_SWITCH_TOU));  // 120
  100078:	cd 78                	int    $0x78
}
  10007a:	90                   	nop
  10007b:	5d                   	pop    %ebp
  10007c:	c3                   	ret    

0010007d <switch_to_kernel>:

static void
switch_to_kernel(void) {
  10007d:	55                   	push   %ebp
  10007e:	89 e5                	mov    %esp,%ebp
    asm volatile ("int %0\n" :: "i" (T_SWITCH_TOK));  // 121
  100080:	cd 79                	int    $0x79
}
  100082:	90                   	nop
  100083:	5d                   	pop    %ebp
  100084:	c3                   	ret    

00100085 <switch_test>:


static void
switch_test(void) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	83 ec 08             	sub    $0x8,%esp
//    print_cur_status();
    cprintf("+++ switch to  user  mode +++\n");
  10008b:	83 ec 0c             	sub    $0xc,%esp
  10008e:	68 a4 1a 10 00       	push   $0x101aa4
  100093:	e8 85 00 00 00       	call   10011d <cprintf>
  100098:	83 c4 10             	add    $0x10,%esp
    switch_to_user();
  10009b:	e8 d5 ff ff ff       	call   100075 <switch_to_user>
//    print_cur_status();
    cprintf("+++ switch to kernel mode +++\n");
  1000a0:	83 ec 0c             	sub    $0xc,%esp
  1000a3:	68 c4 1a 10 00       	push   $0x101ac4
  1000a8:	e8 70 00 00 00       	call   10011d <cprintf>
  1000ad:	83 c4 10             	add    $0x10,%esp
    switch_to_kernel();
  1000b0:	e8 c8 ff ff ff       	call   10007d <switch_to_kernel>
//    print_cur_status();
}
  1000b5:	90                   	nop
  1000b6:	c9                   	leave  
  1000b7:	c3                   	ret    

001000b8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1000b8:	55                   	push   %ebp
  1000b9:	89 e5                	mov    %esp,%ebp
  1000bb:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1000be:	83 ec 0c             	sub    $0xc,%esp
  1000c1:	ff 75 08             	pushl  0x8(%ebp)
  1000c4:	e8 ac 08 00 00       	call   100975 <cons_putc>
  1000c9:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1000cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1000cf:	8b 00                	mov    (%eax),%eax
  1000d1:	8d 50 01             	lea    0x1(%eax),%edx
  1000d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1000d7:	89 10                	mov    %edx,(%eax)
}
  1000d9:	90                   	nop
  1000da:	c9                   	leave  
  1000db:	c3                   	ret    

001000dc <vcprintf>:
/*
 * todo
 * 格式化输出
 * */
int
vcprintf(const char *msg) {
  1000dc:	55                   	push   %ebp
  1000dd:	89 e5                	mov    %esp,%ebp
  1000df:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
  1000e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
  1000e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  1000ef:	eb 1d                	jmp    10010e <vcprintf+0x32>
		cputch(*s, &cnt);
  1000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000f4:	0f b6 00             	movzbl (%eax),%eax
  1000f7:	0f be c0             	movsbl %al,%eax
  1000fa:	83 ec 08             	sub    $0x8,%esp
  1000fd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100100:	52                   	push   %edx
  100101:	50                   	push   %eax
  100102:	e8 b1 ff ff ff       	call   1000b8 <cputch>
  100107:	83 c4 10             	add    $0x10,%esp
		s++;
  10010a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
vcprintf(const char *msg) {
	int cnt = 0;
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
	while (*s != '\0') {
  10010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100111:	0f b6 00             	movzbl (%eax),%eax
  100114:	84 c0                	test   %al,%al
  100116:	75 d9                	jne    1000f1 <vcprintf+0x15>
		cputch(*s, &cnt);
		s++;
	}
	return cnt;
  100118:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10011b:	c9                   	leave  
  10011c:	c3                   	ret    

0010011d <cprintf>:
/*
 * cprintf - formats a string and writes it to stdout
 * todo
 * */
int
cprintf(const char *msg) {
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	cnt = vcprintf(msg);
  100123:	83 ec 0c             	sub    $0xc,%esp
  100126:	ff 75 08             	pushl  0x8(%ebp)
  100129:	e8 ae ff ff ff       	call   1000dc <vcprintf>
  10012e:	83 c4 10             	add    $0x10,%esp
  100131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return cnt;
  100134:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100137:	c9                   	leave  
  100138:	c3                   	ret    

00100139 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100139:	55                   	push   %ebp
  10013a:	89 e5                	mov    %esp,%ebp
  10013c:	83 ec 18             	sub    $0x18,%esp
  10013f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100145:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100149:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  10014d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100151:	ee                   	out    %al,(%dx)
  100152:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100158:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  10015c:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100160:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100164:	ee                   	out    %al,(%dx)
  100165:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  10016b:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  10016f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100173:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100177:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100178:	c7 05 00 44 10 00 00 	movl   $0x0,0x104400
  10017f:	00 00 00 

//    cprintf("++ setup timer interrupts\n");
    pic_enable(IRQ_TIMER);
  100182:	83 ec 0c             	sub    $0xc,%esp
  100185:	6a 00                	push   $0x0
  100187:	e8 ce 08 00 00       	call   100a5a <pic_enable>
  10018c:	83 c4 10             	add    $0x10,%esp
}
  10018f:	90                   	nop
  100190:	c9                   	leave  
  100191:	c3                   	ret    

00100192 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100192:	55                   	push   %ebp
  100193:	89 e5                	mov    %esp,%ebp
  100195:	83 ec 10             	sub    $0x10,%esp
  100198:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10019e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1001a2:	89 c2                	mov    %eax,%edx
  1001a4:	ec                   	in     (%dx),%al
  1001a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  1001a8:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  1001ae:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	ec                   	in     (%dx),%al
  1001b5:	88 45 f5             	mov    %al,-0xb(%ebp)
  1001b8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  1001be:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1001c2:	89 c2                	mov    %eax,%edx
  1001c4:	ec                   	in     (%dx),%al
  1001c5:	88 45 f6             	mov    %al,-0xa(%ebp)
  1001c8:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  1001ce:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1001d2:	89 c2                	mov    %eax,%edx
  1001d4:	ec                   	in     (%dx),%al
  1001d5:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  1001db:	55                   	push   %ebp
  1001dc:	89 e5                	mov    %esp,%ebp
  1001de:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  1001e1:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  1001e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001eb:	0f b7 00             	movzwl (%eax),%eax
  1001ee:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1001f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001f5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1001fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001fd:	0f b7 00             	movzwl (%eax),%eax
  100200:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100204:	74 12                	je     100218 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100206:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  10020d:	66 c7 05 c6 39 10 00 	movw   $0x3b4,0x1039c6
  100214:	b4 03 
  100216:	eb 13                	jmp    10022b <cga_init+0x50>
    } else {
        *cp = was;
  100218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10021b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10021f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100222:	66 c7 05 c6 39 10 00 	movw   $0x3d4,0x1039c6
  100229:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  10022b:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  100232:	0f b7 c0             	movzwl %ax,%eax
  100235:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100239:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10023d:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100241:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100245:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100246:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  10024d:	83 c0 01             	add    $0x1,%eax
  100250:	0f b7 c0             	movzwl %ax,%eax
  100253:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100257:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10025b:	89 c2                	mov    %eax,%edx
  10025d:	ec                   	in     (%dx),%al
  10025e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100261:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100265:	0f b6 c0             	movzbl %al,%eax
  100268:	c1 e0 08             	shl    $0x8,%eax
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  10026e:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  100275:	0f b7 c0             	movzwl %ax,%eax
  100278:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  10027c:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100280:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100284:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100288:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100289:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  100290:	83 c0 01             	add    $0x1,%eax
  100293:	0f b7 c0             	movzwl %ax,%eax
  100296:	66 89 45 ee          	mov    %ax,-0x12(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10029a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10029e:	89 c2                	mov    %eax,%edx
  1002a0:	ec                   	in     (%dx),%al
  1002a1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1002a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1002a8:	0f b6 c0             	movzbl %al,%eax
  1002ab:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  1002ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1002b1:	a3 c0 39 10 00       	mov    %eax,0x1039c0
    crt_pos = pos;
  1002b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b9:	66 a3 c4 39 10 00    	mov    %ax,0x1039c4
}
  1002bf:	90                   	nop
  1002c0:	c9                   	leave  
  1002c1:	c3                   	ret    

001002c2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 28             	sub    $0x28,%esp
  1002c8:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  1002ce:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1002d2:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  1002d6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1002da:	ee                   	out    %al,(%dx)
  1002db:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  1002e1:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  1002e5:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1002e9:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1002ed:	ee                   	out    %al,(%dx)
  1002ee:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  1002f4:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  1002f8:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1002fc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100300:	ee                   	out    %al,(%dx)
  100301:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100307:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  10030b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10030f:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100313:	ee                   	out    %al,(%dx)
  100314:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  10031a:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  10031e:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100322:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100326:	ee                   	out    %al,(%dx)
  100327:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  10032d:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100331:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100335:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100339:	ee                   	out    %al,(%dx)
  10033a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100340:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100344:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100348:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10034c:	ee                   	out    %al,(%dx)
  10034d:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100353:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100357:	89 c2                	mov    %eax,%edx
  100359:	ec                   	in     (%dx),%al
  10035a:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  10035d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100361:	3c ff                	cmp    $0xff,%al
  100363:	0f 95 c0             	setne  %al
  100366:	0f b6 c0             	movzbl %al,%eax
  100369:	a3 c8 39 10 00       	mov    %eax,0x1039c8
  10036e:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100374:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100378:	89 c2                	mov    %eax,%edx
  10037a:	ec                   	in     (%dx),%al
  10037b:	88 45 e2             	mov    %al,-0x1e(%ebp)
  10037e:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100384:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100388:	89 c2                	mov    %eax,%edx
  10038a:	ec                   	in     (%dx),%al
  10038b:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10038e:	a1 c8 39 10 00       	mov    0x1039c8,%eax
  100393:	85 c0                	test   %eax,%eax
  100395:	74 0d                	je     1003a4 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100397:	83 ec 0c             	sub    $0xc,%esp
  10039a:	6a 04                	push   $0x4
  10039c:	e8 b9 06 00 00       	call   100a5a <pic_enable>
  1003a1:	83 c4 10             	add    $0x10,%esp
    }
}
  1003a4:	90                   	nop
  1003a5:	c9                   	leave  
  1003a6:	c3                   	ret    

001003a7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1003a7:	55                   	push   %ebp
  1003a8:	89 e5                	mov    %esp,%ebp
  1003aa:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1003ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1003b4:	eb 09                	jmp    1003bf <lpt_putc_sub+0x18>
        delay();
  1003b6:	e8 d7 fd ff ff       	call   100192 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1003bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1003bf:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  1003c5:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1003c9:	89 c2                	mov    %eax,%edx
  1003cb:	ec                   	in     (%dx),%al
  1003cc:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  1003cf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1003d3:	84 c0                	test   %al,%al
  1003d5:	78 09                	js     1003e0 <lpt_putc_sub+0x39>
  1003d7:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1003de:	7e d6                	jle    1003b6 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  1003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1003e3:	0f b6 c0             	movzbl %al,%eax
  1003e6:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  1003ec:	88 45 f0             	mov    %al,-0x10(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1003ef:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  1003f3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1003f7:	ee                   	out    %al,(%dx)
  1003f8:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1003fe:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100402:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100406:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10040a:	ee                   	out    %al,(%dx)
  10040b:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100411:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  100415:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100419:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10041d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10041e:	90                   	nop
  10041f:	c9                   	leave  
  100420:	c3                   	ret    

00100421 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100421:	55                   	push   %ebp
  100422:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  100424:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100428:	74 0d                	je     100437 <lpt_putc+0x16>
        lpt_putc_sub(c);
  10042a:	ff 75 08             	pushl  0x8(%ebp)
  10042d:	e8 75 ff ff ff       	call   1003a7 <lpt_putc_sub>
  100432:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  100435:	eb 1e                	jmp    100455 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  100437:	6a 08                	push   $0x8
  100439:	e8 69 ff ff ff       	call   1003a7 <lpt_putc_sub>
  10043e:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  100441:	6a 20                	push   $0x20
  100443:	e8 5f ff ff ff       	call   1003a7 <lpt_putc_sub>
  100448:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10044b:	6a 08                	push   $0x8
  10044d:	e8 55 ff ff ff       	call   1003a7 <lpt_putc_sub>
  100452:	83 c4 04             	add    $0x4,%esp
    }
}
  100455:	90                   	nop
  100456:	c9                   	leave  
  100457:	c3                   	ret    

00100458 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
  10045b:	53                   	push   %ebx
  10045c:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10045f:	8b 45 08             	mov    0x8(%ebp),%eax
  100462:	b0 00                	mov    $0x0,%al
  100464:	85 c0                	test   %eax,%eax
  100466:	75 07                	jne    10046f <cga_putc+0x17>
        c |= 0x0700;
  100468:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10046f:	8b 45 08             	mov    0x8(%ebp),%eax
  100472:	0f b6 c0             	movzbl %al,%eax
  100475:	83 f8 0a             	cmp    $0xa,%eax
  100478:	74 4e                	je     1004c8 <cga_putc+0x70>
  10047a:	83 f8 0d             	cmp    $0xd,%eax
  10047d:	74 59                	je     1004d8 <cga_putc+0x80>
  10047f:	83 f8 08             	cmp    $0x8,%eax
  100482:	0f 85 8a 00 00 00    	jne    100512 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  100488:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  10048f:	66 85 c0             	test   %ax,%ax
  100492:	0f 84 a0 00 00 00    	je     100538 <cga_putc+0xe0>
            crt_pos --;
  100498:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  10049f:	83 e8 01             	sub    $0x1,%eax
  1004a2:	66 a3 c4 39 10 00    	mov    %ax,0x1039c4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1004a8:	a1 c0 39 10 00       	mov    0x1039c0,%eax
  1004ad:	0f b7 15 c4 39 10 00 	movzwl 0x1039c4,%edx
  1004b4:	0f b7 d2             	movzwl %dx,%edx
  1004b7:	01 d2                	add    %edx,%edx
  1004b9:	01 d0                	add    %edx,%eax
  1004bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1004be:	b2 00                	mov    $0x0,%dl
  1004c0:	83 ca 20             	or     $0x20,%edx
  1004c3:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1004c6:	eb 70                	jmp    100538 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1004c8:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  1004cf:	83 c0 50             	add    $0x50,%eax
  1004d2:	66 a3 c4 39 10 00    	mov    %ax,0x1039c4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1004d8:	0f b7 1d c4 39 10 00 	movzwl 0x1039c4,%ebx
  1004df:	0f b7 0d c4 39 10 00 	movzwl 0x1039c4,%ecx
  1004e6:	0f b7 c1             	movzwl %cx,%eax
  1004e9:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1004ef:	c1 e8 10             	shr    $0x10,%eax
  1004f2:	89 c2                	mov    %eax,%edx
  1004f4:	66 c1 ea 06          	shr    $0x6,%dx
  1004f8:	89 d0                	mov    %edx,%eax
  1004fa:	c1 e0 02             	shl    $0x2,%eax
  1004fd:	01 d0                	add    %edx,%eax
  1004ff:	c1 e0 04             	shl    $0x4,%eax
  100502:	29 c1                	sub    %eax,%ecx
  100504:	89 ca                	mov    %ecx,%edx
  100506:	89 d8                	mov    %ebx,%eax
  100508:	29 d0                	sub    %edx,%eax
  10050a:	66 a3 c4 39 10 00    	mov    %ax,0x1039c4
        break;
  100510:	eb 27                	jmp    100539 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  100512:	8b 0d c0 39 10 00    	mov    0x1039c0,%ecx
  100518:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  10051f:	8d 50 01             	lea    0x1(%eax),%edx
  100522:	66 89 15 c4 39 10 00 	mov    %dx,0x1039c4
  100529:	0f b7 c0             	movzwl %ax,%eax
  10052c:	01 c0                	add    %eax,%eax
  10052e:	01 c8                	add    %ecx,%eax
  100530:	8b 55 08             	mov    0x8(%ebp),%edx
  100533:	66 89 10             	mov    %dx,(%eax)
        break;
  100536:	eb 01                	jmp    100539 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  100538:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  100539:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  100540:	66 3d cf 07          	cmp    $0x7cf,%ax
  100544:	76 59                	jbe    10059f <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  100546:	a1 c0 39 10 00       	mov    0x1039c0,%eax
  10054b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100551:	a1 c0 39 10 00       	mov    0x1039c0,%eax
  100556:	83 ec 04             	sub    $0x4,%esp
  100559:	68 00 0f 00 00       	push   $0xf00
  10055e:	52                   	push   %edx
  10055f:	50                   	push   %eax
  100560:	e8 6f 14 00 00       	call   1019d4 <memmove>
  100565:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100568:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10056f:	eb 15                	jmp    100586 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  100571:	a1 c0 39 10 00       	mov    0x1039c0,%eax
  100576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100579:	01 d2                	add    %edx,%edx
  10057b:	01 d0                	add    %edx,%eax
  10057d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100586:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10058d:	7e e2                	jle    100571 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10058f:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  100596:	83 e8 50             	sub    $0x50,%eax
  100599:	66 a3 c4 39 10 00    	mov    %ax,0x1039c4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10059f:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  1005a6:	0f b7 c0             	movzwl %ax,%eax
  1005a9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1005ad:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1005b1:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1005b5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1005b9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1005ba:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  1005c1:	66 c1 e8 08          	shr    $0x8,%ax
  1005c5:	0f b6 c0             	movzbl %al,%eax
  1005c8:	0f b7 15 c6 39 10 00 	movzwl 0x1039c6,%edx
  1005cf:	83 c2 01             	add    $0x1,%edx
  1005d2:	0f b7 d2             	movzwl %dx,%edx
  1005d5:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1005d9:	88 45 e9             	mov    %al,-0x17(%ebp)
  1005dc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1005e0:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1005e4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1005e5:	0f b7 05 c6 39 10 00 	movzwl 0x1039c6,%eax
  1005ec:	0f b7 c0             	movzwl %ax,%eax
  1005ef:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1005f3:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1005f7:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1005fb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1005ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  100600:	0f b7 05 c4 39 10 00 	movzwl 0x1039c4,%eax
  100607:	0f b6 c0             	movzbl %al,%eax
  10060a:	0f b7 15 c6 39 10 00 	movzwl 0x1039c6,%edx
  100611:	83 c2 01             	add    $0x1,%edx
  100614:	0f b7 d2             	movzwl %dx,%edx
  100617:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  10061b:	88 45 eb             	mov    %al,-0x15(%ebp)
  10061e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100622:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100626:	ee                   	out    %al,(%dx)
}
  100627:	90                   	nop
  100628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10062d:	55                   	push   %ebp
  10062e:	89 e5                	mov    %esp,%ebp
  100630:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10063a:	eb 09                	jmp    100645 <serial_putc_sub+0x18>
        delay();
  10063c:	e8 51 fb ff ff       	call   100192 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100641:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100645:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10064b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10064f:	89 c2                	mov    %eax,%edx
  100651:	ec                   	in     (%dx),%al
  100652:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  100655:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100659:	0f b6 c0             	movzbl %al,%eax
  10065c:	83 e0 20             	and    $0x20,%eax
  10065f:	85 c0                	test   %eax,%eax
  100661:	75 09                	jne    10066c <serial_putc_sub+0x3f>
  100663:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10066a:	7e d0                	jle    10063c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10066c:	8b 45 08             	mov    0x8(%ebp),%eax
  10066f:	0f b6 c0             	movzbl %al,%eax
  100672:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100678:	88 45 f6             	mov    %al,-0xa(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10067b:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  10067f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100683:	ee                   	out    %al,(%dx)
}
  100684:	90                   	nop
  100685:	c9                   	leave  
  100686:	c3                   	ret    

00100687 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  100687:	55                   	push   %ebp
  100688:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10068a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10068e:	74 0d                	je     10069d <serial_putc+0x16>
        serial_putc_sub(c);
  100690:	ff 75 08             	pushl  0x8(%ebp)
  100693:	e8 95 ff ff ff       	call   10062d <serial_putc_sub>
  100698:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10069b:	eb 1e                	jmp    1006bb <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  10069d:	6a 08                	push   $0x8
  10069f:	e8 89 ff ff ff       	call   10062d <serial_putc_sub>
  1006a4:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1006a7:	6a 20                	push   $0x20
  1006a9:	e8 7f ff ff ff       	call   10062d <serial_putc_sub>
  1006ae:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1006b1:	6a 08                	push   $0x8
  1006b3:	e8 75 ff ff ff       	call   10062d <serial_putc_sub>
  1006b8:	83 c4 04             	add    $0x4,%esp
    }
}
  1006bb:	90                   	nop
  1006bc:	c9                   	leave  
  1006bd:	c3                   	ret    

001006be <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1006be:	55                   	push   %ebp
  1006bf:	89 e5                	mov    %esp,%ebp
  1006c1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1006c4:	eb 33                	jmp    1006f9 <cons_intr+0x3b>
        if (c != 0) {
  1006c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1006ca:	74 2d                	je     1006f9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1006cc:	a1 e4 3b 10 00       	mov    0x103be4,%eax
  1006d1:	8d 50 01             	lea    0x1(%eax),%edx
  1006d4:	89 15 e4 3b 10 00    	mov    %edx,0x103be4
  1006da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1006dd:	88 90 e0 39 10 00    	mov    %dl,0x1039e0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1006e3:	a1 e4 3b 10 00       	mov    0x103be4,%eax
  1006e8:	3d 00 02 00 00       	cmp    $0x200,%eax
  1006ed:	75 0a                	jne    1006f9 <cons_intr+0x3b>
                cons.wpos = 0;
  1006ef:	c7 05 e4 3b 10 00 00 	movl   $0x0,0x103be4
  1006f6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fc:	ff d0                	call   *%eax
  1006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100701:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  100705:	75 bf                	jne    1006c6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  100707:	90                   	nop
  100708:	c9                   	leave  
  100709:	c3                   	ret    

0010070a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10070a:	55                   	push   %ebp
  10070b:	89 e5                	mov    %esp,%ebp
  10070d:	83 ec 10             	sub    $0x10,%esp
  100710:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100716:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	ec                   	in     (%dx),%al
  10071d:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  100720:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  100724:	0f b6 c0             	movzbl %al,%eax
  100727:	83 e0 01             	and    $0x1,%eax
  10072a:	85 c0                	test   %eax,%eax
  10072c:	75 07                	jne    100735 <serial_proc_data+0x2b>
        return -1;
  10072e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100733:	eb 2a                	jmp    10075f <serial_proc_data+0x55>
  100735:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10073b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10073f:	89 c2                	mov    %eax,%edx
  100741:	ec                   	in     (%dx),%al
  100742:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  100745:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  100749:	0f b6 c0             	movzbl %al,%eax
  10074c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10074f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100753:	75 07                	jne    10075c <serial_proc_data+0x52>
        c = '\b';
  100755:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10075c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10075f:	c9                   	leave  
  100760:	c3                   	ret    

00100761 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  100761:	55                   	push   %ebp
  100762:	89 e5                	mov    %esp,%ebp
  100764:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  100767:	a1 c8 39 10 00       	mov    0x1039c8,%eax
  10076c:	85 c0                	test   %eax,%eax
  10076e:	74 10                	je     100780 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  100770:	83 ec 0c             	sub    $0xc,%esp
  100773:	68 0a 07 10 00       	push   $0x10070a
  100778:	e8 41 ff ff ff       	call   1006be <cons_intr>
  10077d:	83 c4 10             	add    $0x10,%esp
    }
}
  100780:	90                   	nop
  100781:	c9                   	leave  
  100782:	c3                   	ret    

00100783 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  100783:	55                   	push   %ebp
  100784:	89 e5                	mov    %esp,%ebp
  100786:	83 ec 18             	sub    $0x18,%esp
  100789:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10078f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100793:	89 c2                	mov    %eax,%edx
  100795:	ec                   	in     (%dx),%al
  100796:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100799:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10079d:	0f b6 c0             	movzbl %al,%eax
  1007a0:	83 e0 01             	and    $0x1,%eax
  1007a3:	85 c0                	test   %eax,%eax
  1007a5:	75 0a                	jne    1007b1 <kbd_proc_data+0x2e>
        return -1;
  1007a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ac:	e9 5d 01 00 00       	jmp    10090e <kbd_proc_data+0x18b>
  1007b1:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)

/* inb/outb:读/写字节端口(8位宽)*/
static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1007b7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	ec                   	in     (%dx),%al
  1007be:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1007c1:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1007c5:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1007c8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1007cc:	75 17                	jne    1007e5 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1007ce:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  1007d3:	83 c8 40             	or     $0x40,%eax
  1007d6:	a3 e8 3b 10 00       	mov    %eax,0x103be8
        return 0;
  1007db:	b8 00 00 00 00       	mov    $0x0,%eax
  1007e0:	e9 29 01 00 00       	jmp    10090e <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1007e5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007e9:	84 c0                	test   %al,%al
  1007eb:	79 47                	jns    100834 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1007ed:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  1007f2:	83 e0 40             	and    $0x40,%eax
  1007f5:	85 c0                	test   %eax,%eax
  1007f7:	75 09                	jne    100802 <kbd_proc_data+0x7f>
  1007f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1007fd:	83 e0 7f             	and    $0x7f,%eax
  100800:	eb 04                	jmp    100806 <kbd_proc_data+0x83>
  100802:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100806:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  100809:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10080d:	0f b6 80 a0 30 10 00 	movzbl 0x1030a0(%eax),%eax
  100814:	83 c8 40             	or     $0x40,%eax
  100817:	0f b6 c0             	movzbl %al,%eax
  10081a:	f7 d0                	not    %eax
  10081c:	89 c2                	mov    %eax,%edx
  10081e:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  100823:	21 d0                	and    %edx,%eax
  100825:	a3 e8 3b 10 00       	mov    %eax,0x103be8
        return 0;
  10082a:	b8 00 00 00 00       	mov    $0x0,%eax
  10082f:	e9 da 00 00 00       	jmp    10090e <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  100834:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  100839:	83 e0 40             	and    $0x40,%eax
  10083c:	85 c0                	test   %eax,%eax
  10083e:	74 11                	je     100851 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  100840:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  100844:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  100849:	83 e0 bf             	and    $0xffffffbf,%eax
  10084c:	a3 e8 3b 10 00       	mov    %eax,0x103be8
    }

    shift |= shiftcode[data];
  100851:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100855:	0f b6 80 a0 30 10 00 	movzbl 0x1030a0(%eax),%eax
  10085c:	0f b6 d0             	movzbl %al,%edx
  10085f:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  100864:	09 d0                	or     %edx,%eax
  100866:	a3 e8 3b 10 00       	mov    %eax,0x103be8
    shift ^= togglecode[data];
  10086b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10086f:	0f b6 80 a0 31 10 00 	movzbl 0x1031a0(%eax),%eax
  100876:	0f b6 d0             	movzbl %al,%edx
  100879:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  10087e:	31 d0                	xor    %edx,%eax
  100880:	a3 e8 3b 10 00       	mov    %eax,0x103be8

    c = charcode[shift & (CTL | SHIFT)][data];
  100885:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  10088a:	83 e0 03             	and    $0x3,%eax
  10088d:	8b 14 85 a0 35 10 00 	mov    0x1035a0(,%eax,4),%edx
  100894:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	0f b6 00             	movzbl (%eax),%eax
  10089d:	0f b6 c0             	movzbl %al,%eax
  1008a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1008a3:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  1008a8:	83 e0 08             	and    $0x8,%eax
  1008ab:	85 c0                	test   %eax,%eax
  1008ad:	74 22                	je     1008d1 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1008af:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1008b3:	7e 0c                	jle    1008c1 <kbd_proc_data+0x13e>
  1008b5:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1008b9:	7f 06                	jg     1008c1 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1008bb:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1008bf:	eb 10                	jmp    1008d1 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1008c1:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1008c5:	7e 0a                	jle    1008d1 <kbd_proc_data+0x14e>
  1008c7:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1008cb:	7f 04                	jg     1008d1 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1008cd:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1008d1:	a1 e8 3b 10 00       	mov    0x103be8,%eax
  1008d6:	f7 d0                	not    %eax
  1008d8:	83 e0 06             	and    $0x6,%eax
  1008db:	85 c0                	test   %eax,%eax
  1008dd:	75 2c                	jne    10090b <kbd_proc_data+0x188>
  1008df:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1008e6:	75 23                	jne    10090b <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1008e8:	83 ec 0c             	sub    $0xc,%esp
  1008eb:	68 e3 1a 10 00       	push   $0x101ae3
  1008f0:	e8 28 f8 ff ff       	call   10011d <cprintf>
  1008f5:	83 c4 10             	add    $0x10,%esp
  1008f8:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  1008fe:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
outw() I/O 上写入 16 位数据 ( 2 字节 )；
outl () I/O 上写入 32 位数据 ( 4 字节)。
 * */
static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100902:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100906:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10090a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10090e:	c9                   	leave  
  10090f:	c3                   	ret    

00100910 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  100910:	55                   	push   %ebp
  100911:	89 e5                	mov    %esp,%ebp
  100913:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  100916:	83 ec 0c             	sub    $0xc,%esp
  100919:	68 83 07 10 00       	push   $0x100783
  10091e:	e8 9b fd ff ff       	call   1006be <cons_intr>
  100923:	83 c4 10             	add    $0x10,%esp
}
  100926:	90                   	nop
  100927:	c9                   	leave  
  100928:	c3                   	ret    

00100929 <kbd_init>:

static void
kbd_init(void) {
  100929:	55                   	push   %ebp
  10092a:	89 e5                	mov    %esp,%ebp
  10092c:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  10092f:	e8 dc ff ff ff       	call   100910 <kbd_intr>
    pic_enable(IRQ_KBD);
  100934:	83 ec 0c             	sub    $0xc,%esp
  100937:	6a 01                	push   $0x1
  100939:	e8 1c 01 00 00       	call   100a5a <pic_enable>
  10093e:	83 c4 10             	add    $0x10,%esp
}
  100941:	90                   	nop
  100942:	c9                   	leave  
  100943:	c3                   	ret    

00100944 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  100944:	55                   	push   %ebp
  100945:	89 e5                	mov    %esp,%ebp
  100947:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10094a:	e8 8c f8 ff ff       	call   1001db <cga_init>
    serial_init();
  10094f:	e8 6e f9 ff ff       	call   1002c2 <serial_init>
    kbd_init();
  100954:	e8 d0 ff ff ff       	call   100929 <kbd_init>
    if (!serial_exists) {
  100959:	a1 c8 39 10 00       	mov    0x1039c8,%eax
  10095e:	85 c0                	test   %eax,%eax
  100960:	75 10                	jne    100972 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  100962:	83 ec 0c             	sub    $0xc,%esp
  100965:	68 ef 1a 10 00       	push   $0x101aef
  10096a:	e8 ae f7 ff ff       	call   10011d <cprintf>
  10096f:	83 c4 10             	add    $0x10,%esp
    }
}
  100972:	90                   	nop
  100973:	c9                   	leave  
  100974:	c3                   	ret    

00100975 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  100975:	55                   	push   %ebp
  100976:	89 e5                	mov    %esp,%ebp
  100978:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10097b:	ff 75 08             	pushl  0x8(%ebp)
  10097e:	e8 9e fa ff ff       	call   100421 <lpt_putc>
  100983:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  100986:	83 ec 0c             	sub    $0xc,%esp
  100989:	ff 75 08             	pushl  0x8(%ebp)
  10098c:	e8 c7 fa ff ff       	call   100458 <cga_putc>
  100991:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  100994:	83 ec 0c             	sub    $0xc,%esp
  100997:	ff 75 08             	pushl  0x8(%ebp)
  10099a:	e8 e8 fc ff ff       	call   100687 <serial_putc>
  10099f:	83 c4 10             	add    $0x10,%esp
}
  1009a2:	90                   	nop
  1009a3:	c9                   	leave  
  1009a4:	c3                   	ret    

001009a5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1009a5:	55                   	push   %ebp
  1009a6:	89 e5                	mov    %esp,%ebp
  1009a8:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1009ab:	e8 b1 fd ff ff       	call   100761 <serial_intr>
    kbd_intr();
  1009b0:	e8 5b ff ff ff       	call   100910 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1009b5:	8b 15 e0 3b 10 00    	mov    0x103be0,%edx
  1009bb:	a1 e4 3b 10 00       	mov    0x103be4,%eax
  1009c0:	39 c2                	cmp    %eax,%edx
  1009c2:	74 36                	je     1009fa <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1009c4:	a1 e0 3b 10 00       	mov    0x103be0,%eax
  1009c9:	8d 50 01             	lea    0x1(%eax),%edx
  1009cc:	89 15 e0 3b 10 00    	mov    %edx,0x103be0
  1009d2:	0f b6 80 e0 39 10 00 	movzbl 0x1039e0(%eax),%eax
  1009d9:	0f b6 c0             	movzbl %al,%eax
  1009dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1009df:	a1 e0 3b 10 00       	mov    0x103be0,%eax
  1009e4:	3d 00 02 00 00       	cmp    $0x200,%eax
  1009e9:	75 0a                	jne    1009f5 <cons_getc+0x50>
            cons.rpos = 0;
  1009eb:	c7 05 e0 3b 10 00 00 	movl   $0x0,0x103be0
  1009f2:	00 00 00 
        }
        return c;
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	eb 05                	jmp    1009ff <cons_getc+0x5a>
    }
    return 0;
  1009fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1009ff:	c9                   	leave  
  100a00:	c3                   	ret    

00100a01 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  100a01:	55                   	push   %ebp
  100a02:	89 e5                	mov    %esp,%ebp
  100a04:	83 ec 14             	sub    $0x14,%esp
  100a07:	8b 45 08             	mov    0x8(%ebp),%eax
  100a0a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  100a0e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100a12:	66 a3 b0 35 10 00    	mov    %ax,0x1035b0
    if (did_init) {
  100a18:	a1 ec 3b 10 00       	mov    0x103bec,%eax
  100a1d:	85 c0                	test   %eax,%eax
  100a1f:	74 36                	je     100a57 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  100a21:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100a25:	0f b6 c0             	movzbl %al,%eax
  100a28:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100a2e:	88 45 fa             	mov    %al,-0x6(%ebp)
  100a31:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  100a35:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100a39:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  100a3a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100a3e:	66 c1 e8 08          	shr    $0x8,%ax
  100a42:	0f b6 c0             	movzbl %al,%eax
  100a45:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100a4b:	88 45 fb             	mov    %al,-0x5(%ebp)
  100a4e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100a52:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100a56:	ee                   	out    %al,(%dx)
    }
}
  100a57:	90                   	nop
  100a58:	c9                   	leave  
  100a59:	c3                   	ret    

00100a5a <pic_enable>:

void
pic_enable(unsigned int irq) {
  100a5a:	55                   	push   %ebp
  100a5b:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  100a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a60:	ba 01 00 00 00       	mov    $0x1,%edx
  100a65:	89 c1                	mov    %eax,%ecx
  100a67:	d3 e2                	shl    %cl,%edx
  100a69:	89 d0                	mov    %edx,%eax
  100a6b:	f7 d0                	not    %eax
  100a6d:	89 c2                	mov    %eax,%edx
  100a6f:	0f b7 05 b0 35 10 00 	movzwl 0x1035b0,%eax
  100a76:	21 d0                	and    %edx,%eax
  100a78:	0f b7 c0             	movzwl %ax,%eax
  100a7b:	50                   	push   %eax
  100a7c:	e8 80 ff ff ff       	call   100a01 <pic_setmask>
  100a81:	83 c4 04             	add    $0x4,%esp
}
  100a84:	90                   	nop
  100a85:	c9                   	leave  
  100a86:	c3                   	ret    

00100a87 <pic_init>:
ICW3： 8259的级联命令字，用来区分主片和从片。
ICW4：指定中断嵌套方式、数据缓冲选择、中断结束方式和CPU类型。
 * */
/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  100a87:	55                   	push   %ebp
  100a88:	89 e5                	mov    %esp,%ebp
  100a8a:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  100a8d:	c7 05 ec 3b 10 00 01 	movl   $0x1,0x103bec
  100a94:	00 00 00 
  100a97:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  100a9d:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  100aa1:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  100aa5:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  100aa9:	ee                   	out    %al,(%dx)
  100aaa:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  100ab0:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  100ab4:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100ab8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100abc:	ee                   	out    %al,(%dx)
  100abd:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  100ac3:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  100ac7:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  100acb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100acf:	ee                   	out    %al,(%dx)
  100ad0:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  100ad6:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  100ada:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100ade:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100ae2:	ee                   	out    %al,(%dx)
  100ae3:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  100ae9:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  100aed:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100af1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100af5:	ee                   	out    %al,(%dx)
  100af6:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  100afc:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  100b00:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100b04:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100b08:	ee                   	out    %al,(%dx)
  100b09:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  100b0f:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  100b13:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100b17:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100b1b:	ee                   	out    %al,(%dx)
  100b1c:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  100b22:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  100b26:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100b2a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100b2e:	ee                   	out    %al,(%dx)
  100b2f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  100b35:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  100b39:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100b3d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100b41:	ee                   	out    %al,(%dx)
  100b42:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  100b48:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  100b4c:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100b50:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100b54:	ee                   	out    %al,(%dx)
  100b55:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  100b5b:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  100b5f:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100b63:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100b67:	ee                   	out    %al,(%dx)
  100b68:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  100b6e:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  100b72:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100b76:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  100b7a:	ee                   	out    %al,(%dx)
  100b7b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  100b81:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  100b85:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  100b89:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100b8d:	ee                   	out    %al,(%dx)
  100b8e:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  100b94:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  100b98:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100b9c:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  100ba0:	ee                   	out    %al,(%dx)

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    // 初始化完毕，使能主从8259A的所有中断
    if (irq_mask != 0xFFFF) {
  100ba1:	0f b7 05 b0 35 10 00 	movzwl 0x1035b0,%eax
  100ba8:	66 83 f8 ff          	cmp    $0xffff,%ax
  100bac:	74 13                	je     100bc1 <pic_init+0x13a>
        pic_setmask(irq_mask);
  100bae:	0f b7 05 b0 35 10 00 	movzwl 0x1035b0,%eax
  100bb5:	0f b7 c0             	movzwl %ax,%eax
  100bb8:	50                   	push   %eax
  100bb9:	e8 43 fe ff ff       	call   100a01 <pic_setmask>
  100bbe:	83 c4 04             	add    $0x4,%esp
    }
}
  100bc1:	90                   	nop
  100bc2:	c9                   	leave  
  100bc3:	c3                   	ret    

00100bc4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  100bc4:	55                   	push   %ebp
  100bc5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  100bc7:	fb                   	sti    
    sti();
}
  100bc8:	90                   	nop
  100bc9:	5d                   	pop    %ebp
  100bca:	c3                   	ret    

00100bcb <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  100bcb:	55                   	push   %ebp
  100bcc:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  100bce:	fa                   	cli    
    cli();
}
  100bcf:	90                   	nop
  100bd0:	5d                   	pop    %ebp
  100bd1:	c3                   	ret    

00100bd2 <print_ticks>:
};

/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

static void print_ticks() {
  100bd2:	55                   	push   %ebp
  100bd3:	89 e5                	mov    %esp,%ebp
  100bd5:	83 ec 08             	sub    $0x8,%esp
    cprintf("ticks\n");
  100bd8:	83 ec 0c             	sub    $0xc,%esp
  100bdb:	68 10 1b 10 00       	push   $0x101b10
  100be0:	e8 38 f5 ff ff       	call   10011d <cprintf>
  100be5:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    cprintf("EOT: kernel seems ok.");
#endif
}
  100be8:	90                   	nop
  100be9:	c9                   	leave  
  100bea:	c3                   	ret    

00100beb <idt_init>:


/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  100beb:	55                   	push   %ebp
  100bec:	89 e5                	mov    %esp,%ebp
  100bee:	83 ec 10             	sub    $0x10,%esp
	// 保存在vectors.S中的256个中断处理例程的入口地址数组
    extern uintptr_t __vectors[];

    // 在中断门描述符表中通过建立中断门描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量\__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  100bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100bf8:	e9 c3 00 00 00       	jmp    100cc0 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  100bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c00:	8b 04 85 ba 35 10 00 	mov    0x1035ba(,%eax,4),%eax
  100c07:	89 c2                	mov    %eax,%edx
  100c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c0c:	66 89 14 c5 00 3c 10 	mov    %dx,0x103c00(,%eax,8)
  100c13:	00 
  100c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c17:	66 c7 04 c5 02 3c 10 	movw   $0x8,0x103c02(,%eax,8)
  100c1e:	00 08 00 
  100c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c24:	0f b6 14 c5 04 3c 10 	movzbl 0x103c04(,%eax,8),%edx
  100c2b:	00 
  100c2c:	83 e2 e0             	and    $0xffffffe0,%edx
  100c2f:	88 14 c5 04 3c 10 00 	mov    %dl,0x103c04(,%eax,8)
  100c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c39:	0f b6 14 c5 04 3c 10 	movzbl 0x103c04(,%eax,8),%edx
  100c40:	00 
  100c41:	83 e2 1f             	and    $0x1f,%edx
  100c44:	88 14 c5 04 3c 10 00 	mov    %dl,0x103c04(,%eax,8)
  100c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c4e:	0f b6 14 c5 05 3c 10 	movzbl 0x103c05(,%eax,8),%edx
  100c55:	00 
  100c56:	83 e2 f0             	and    $0xfffffff0,%edx
  100c59:	83 ca 0e             	or     $0xe,%edx
  100c5c:	88 14 c5 05 3c 10 00 	mov    %dl,0x103c05(,%eax,8)
  100c63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c66:	0f b6 14 c5 05 3c 10 	movzbl 0x103c05(,%eax,8),%edx
  100c6d:	00 
  100c6e:	83 e2 ef             	and    $0xffffffef,%edx
  100c71:	88 14 c5 05 3c 10 00 	mov    %dl,0x103c05(,%eax,8)
  100c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c7b:	0f b6 14 c5 05 3c 10 	movzbl 0x103c05(,%eax,8),%edx
  100c82:	00 
  100c83:	83 e2 9f             	and    $0xffffff9f,%edx
  100c86:	88 14 c5 05 3c 10 00 	mov    %dl,0x103c05(,%eax,8)
  100c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100c90:	0f b6 14 c5 05 3c 10 	movzbl 0x103c05(,%eax,8),%edx
  100c97:	00 
  100c98:	83 ca 80             	or     $0xffffff80,%edx
  100c9b:	88 14 c5 05 3c 10 00 	mov    %dl,0x103c05(,%eax,8)
  100ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ca5:	8b 04 85 ba 35 10 00 	mov    0x1035ba(,%eax,4),%eax
  100cac:	c1 e8 10             	shr    $0x10,%eax
  100caf:	89 c2                	mov    %eax,%edx
  100cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100cb4:	66 89 14 c5 06 3c 10 	mov    %dx,0x103c06(,%eax,8)
  100cbb:	00 
	// 保存在vectors.S中的256个中断处理例程的入口地址数组
    extern uintptr_t __vectors[];

    // 在中断门描述符表中通过建立中断门描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量\__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  100cbc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100cc3:	3d ff 00 00 00       	cmp    $0xff,%eax
  100cc8:	0f 86 2f ff ff ff    	jbe    100bfd <idt_init+0x12>
  100cce:	c7 45 f8 b4 35 10 00 	movl   $0x1035b4,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  100cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100cd8:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
    /*
     * 读由idtr寄存器指向的IDT表中的第i项门描述符。
从gdtr寄存器获得GDT的基地址，并在GDT中查找，以读取IDT表项中的选择符所标识的段描述符，这个描述符指定只哦你果断或异常处理程序所在的段的基地址。
     * */
}
  100cdb:	90                   	nop
  100cdc:	c9                   	leave  
  100cdd:	c3                   	ret    

00100cde <trap_dispatch>:



/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  100cde:	55                   	push   %ebp
  100cdf:	89 e5                	mov    %esp,%ebp
  100ce1:	57                   	push   %edi
  100ce2:	56                   	push   %esi
  100ce3:	53                   	push   %ebx
  100ce4:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  100ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cea:	8b 40 28             	mov    0x28(%eax),%eax
  100ced:	83 f8 24             	cmp    $0x24,%eax
  100cf0:	74 65                	je     100d57 <trap_dispatch+0x79>
  100cf2:	83 f8 24             	cmp    $0x24,%eax
  100cf5:	77 0f                	ja     100d06 <trap_dispatch+0x28>
  100cf7:	83 f8 20             	cmp    $0x20,%eax
  100cfa:	74 21                	je     100d1d <trap_dispatch+0x3f>
  100cfc:	83 f8 21             	cmp    $0x21,%eax
  100cff:	74 73                	je     100d74 <trap_dispatch+0x96>
  100d01:	e9 9d 01 00 00       	jmp    100ea3 <trap_dispatch+0x1c5>
  100d06:	83 f8 78             	cmp    $0x78,%eax
  100d09:	0f 84 82 00 00 00    	je     100d91 <trap_dispatch+0xb3>
  100d0f:	83 f8 79             	cmp    $0x79,%eax
  100d12:	0f 84 15 01 00 00    	je     100e2d <trap_dispatch+0x14f>
  100d18:	e9 86 01 00 00       	jmp    100ea3 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
  100d1d:	a1 00 44 10 00       	mov    0x104400,%eax
  100d22:	83 c0 01             	add    $0x1,%eax
  100d25:	a3 00 44 10 00       	mov    %eax,0x104400
        if (ticks % TICK_NUM == 0) {
  100d2a:	8b 0d 00 44 10 00    	mov    0x104400,%ecx
  100d30:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  100d35:	89 c8                	mov    %ecx,%eax
  100d37:	f7 e2                	mul    %edx
  100d39:	89 d0                	mov    %edx,%eax
  100d3b:	c1 e8 05             	shr    $0x5,%eax
  100d3e:	6b c0 64             	imul   $0x64,%eax,%eax
  100d41:	29 c1                	sub    %eax,%ecx
  100d43:	89 c8                	mov    %ecx,%eax
  100d45:	85 c0                	test   %eax,%eax
  100d47:	0f 85 79 01 00 00    	jne    100ec6 <trap_dispatch+0x1e8>
            print_ticks();
  100d4d:	e8 80 fe ff ff       	call   100bd2 <print_ticks>
        }
        break;
  100d52:	e9 6f 01 00 00       	jmp    100ec6 <trap_dispatch+0x1e8>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  100d57:	e8 49 fc ff ff       	call   1009a5 <cons_getc>
  100d5c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial \n");
  100d5f:	83 ec 0c             	sub    $0xc,%esp
  100d62:	68 17 1b 10 00       	push   $0x101b17
  100d67:	e8 b1 f3 ff ff       	call   10011d <cprintf>
  100d6c:	83 c4 10             	add    $0x10,%esp
        break;
  100d6f:	e9 59 01 00 00       	jmp    100ecd <trap_dispatch+0x1ef>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  100d74:	e8 2c fc ff ff       	call   1009a5 <cons_getc>
  100d79:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd \n");
  100d7c:	83 ec 0c             	sub    $0xc,%esp
  100d7f:	68 20 1b 10 00       	push   $0x101b20
  100d84:	e8 94 f3 ff ff       	call   10011d <cprintf>
  100d89:	83 c4 10             	add    $0x10,%esp
        break;
  100d8c:	e9 3c 01 00 00       	jmp    100ecd <trap_dispatch+0x1ef>
    case T_SWITCH_TOU:
		if (tf->tf_cs != USER_CS) {
  100d91:	8b 45 08             	mov    0x8(%ebp),%eax
  100d94:	0f b7 40 34          	movzwl 0x34(%eax),%eax
  100d98:	66 83 f8 1b          	cmp    $0x1b,%ax
  100d9c:	0f 84 27 01 00 00    	je     100ec9 <trap_dispatch+0x1eb>
			switchk2u = *tf;
  100da2:	8b 55 08             	mov    0x8(%ebp),%edx
  100da5:	b8 20 44 10 00       	mov    $0x104420,%eax
  100daa:	89 d3                	mov    %edx,%ebx
  100dac:	ba 44 00 00 00       	mov    $0x44,%edx
  100db1:	8b 0b                	mov    (%ebx),%ecx
  100db3:	89 08                	mov    %ecx,(%eax)
  100db5:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  100db9:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  100dbd:	8d 78 04             	lea    0x4(%eax),%edi
  100dc0:	83 e7 fc             	and    $0xfffffffc,%edi
  100dc3:	29 f8                	sub    %edi,%eax
  100dc5:	29 c3                	sub    %eax,%ebx
  100dc7:	01 c2                	add    %eax,%edx
  100dc9:	83 e2 fc             	and    $0xfffffffc,%edx
  100dcc:	89 d0                	mov    %edx,%eax
  100dce:	c1 e8 02             	shr    $0x2,%eax
  100dd1:	89 de                	mov    %ebx,%esi
  100dd3:	89 c1                	mov    %eax,%ecx
  100dd5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			switchk2u.tf_cs = USER_CS;
  100dd7:	66 c7 05 54 44 10 00 	movw   $0x1b,0x104454
  100dde:	1b 00 
			switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  100de0:	66 c7 05 60 44 10 00 	movw   $0x23,0x104460
  100de7:	23 00 
  100de9:	0f b7 05 60 44 10 00 	movzwl 0x104460,%eax
  100df0:	66 a3 40 44 10 00    	mov    %ax,0x104440
  100df6:	0f b7 05 40 44 10 00 	movzwl 0x104440,%eax
  100dfd:	66 a3 44 44 10 00    	mov    %ax,0x104444
			switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  100e03:	8b 45 08             	mov    0x8(%ebp),%eax
  100e06:	83 c0 3c             	add    $0x3c,%eax
  100e09:	a3 5c 44 10 00       	mov    %eax,0x10445c

			// set eflags, make sure ucore can use io under user mode.
			// if CPL > IOPL, then cpu will generate a general protection.
			switchk2u.tf_eflags |= FL_IOPL_MASK;
  100e0e:	a1 58 44 10 00       	mov    0x104458,%eax
  100e13:	80 cc 30             	or     $0x30,%ah
  100e16:	a3 58 44 10 00       	mov    %eax,0x104458

			// set temporary stack
			// then iret will jump to the right stack
			*((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  100e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100e1e:	83 e8 04             	sub    $0x4,%eax
  100e21:	ba 20 44 10 00       	mov    $0x104420,%edx
  100e26:	89 10                	mov    %edx,(%eax)
		}
		break;
  100e28:	e9 9c 00 00 00       	jmp    100ec9 <trap_dispatch+0x1eb>
	case T_SWITCH_TOK:
		//发出中断时，CPU处于用户态，我们希望处理完此中断后，CPU继续在内核态运行，
		//所以把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
		if (tf->tf_cs != KERNEL_CS) {
  100e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100e30:	0f b7 40 34          	movzwl 0x34(%eax),%eax
  100e34:	66 83 f8 08          	cmp    $0x8,%ax
  100e38:	0f 84 8e 00 00 00    	je     100ecc <trap_dispatch+0x1ee>
			tf->tf_cs = KERNEL_CS;
  100e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100e41:	66 c7 40 34 08 00    	movw   $0x8,0x34(%eax)
			tf->tf_ds = tf->tf_es = KERNEL_DS;
  100e47:	8b 45 08             	mov    0x8(%ebp),%eax
  100e4a:	66 c7 40 20 10 00    	movw   $0x10,0x20(%eax)
  100e50:	8b 45 08             	mov    0x8(%ebp),%eax
  100e53:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  100e57:	8b 45 08             	mov    0x8(%ebp),%eax
  100e5a:	66 89 50 24          	mov    %dx,0x24(%eax)
			//设置EFLAGS，让用户态不能执行in/out指令
			tf->tf_eflags &= ~FL_IOPL_MASK;
  100e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100e61:	8b 40 38             	mov    0x38(%eax),%eax
  100e64:	80 e4 cf             	and    $0xcf,%ah
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	8b 45 08             	mov    0x8(%ebp),%eax
  100e6c:	89 50 38             	mov    %edx,0x38(%eax)
			switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  100e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100e72:	8b 40 3c             	mov    0x3c(%eax),%eax
  100e75:	83 e8 3c             	sub    $0x3c,%eax
  100e78:	a3 64 44 10 00       	mov    %eax,0x104464
			 //设置临时栈，指向switchu2k，这样iret返回时，CPU会从switchu2k恢复数据，
			//而不是从现有栈恢复数据。
			memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  100e7d:	a1 64 44 10 00       	mov    0x104464,%eax
  100e82:	83 ec 04             	sub    $0x4,%esp
  100e85:	6a 3c                	push   $0x3c
  100e87:	ff 75 08             	pushl  0x8(%ebp)
  100e8a:	50                   	push   %eax
  100e8b:	e8 44 0b 00 00       	call   1019d4 <memmove>
  100e90:	83 c4 10             	add    $0x10,%esp
			*((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  100e93:	8b 45 08             	mov    0x8(%ebp),%eax
  100e96:	83 e8 04             	sub    $0x4,%eax
  100e99:	8b 15 64 44 10 00    	mov    0x104464,%edx
  100e9f:	89 10                	mov    %edx,(%eax)
		}
		break;
  100ea1:	eb 29                	jmp    100ecc <trap_dispatch+0x1ee>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  100ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ea6:	0f b7 40 34          	movzwl 0x34(%eax),%eax
  100eaa:	0f b7 c0             	movzwl %ax,%eax
  100ead:	83 e0 03             	and    $0x3,%eax
  100eb0:	85 c0                	test   %eax,%eax
  100eb2:	75 19                	jne    100ecd <trap_dispatch+0x1ef>
        	cprintf("in kernel, it must be a mistake \n");
  100eb4:	83 ec 0c             	sub    $0xc,%esp
  100eb7:	68 28 1b 10 00       	push   $0x101b28
  100ebc:	e8 5c f2 ff ff       	call   10011d <cprintf>
  100ec1:	83 c4 10             	add    $0x10,%esp
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
        }
    }
}
  100ec4:	eb 07                	jmp    100ecd <trap_dispatch+0x1ef>
    case IRQ_OFFSET + IRQ_TIMER:
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  100ec6:	90                   	nop
  100ec7:	eb 04                	jmp    100ecd <trap_dispatch+0x1ef>

			// set temporary stack
			// then iret will jump to the right stack
			*((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
		}
		break;
  100ec9:	90                   	nop
  100eca:	eb 01                	jmp    100ecd <trap_dispatch+0x1ef>
			 //设置临时栈，指向switchu2k，这样iret返回时，CPU会从switchu2k恢复数据，
			//而不是从现有栈恢复数据。
			memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
			*((uint32_t *)tf - 1) = (uint32_t)switchu2k;
		}
		break;
  100ecc:	90                   	nop
        	cprintf("in kernel, it must be a mistake \n");
//            print_trapframe(tf);
//            panic("unexpected trap in kernel.\n");
        }
    }
}
  100ecd:	90                   	nop
  100ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100ed1:	5b                   	pop    %ebx
  100ed2:	5e                   	pop    %esi
  100ed3:	5f                   	pop    %edi
  100ed4:	5d                   	pop    %ebp
  100ed5:	c3                   	ret    

00100ed6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  100ed6:	55                   	push   %ebp
  100ed7:	89 e5                	mov    %esp,%ebp
  100ed9:	83 ec 08             	sub    $0x8,%esp
    trap_dispatch(tf);
  100edc:	83 ec 0c             	sub    $0xc,%esp
  100edf:	ff 75 08             	pushl  0x8(%ebp)
  100ee2:	e8 f7 fd ff ff       	call   100cde <trap_dispatch>
  100ee7:	83 c4 10             	add    $0x10,%esp
}
  100eea:	90                   	nop
  100eeb:	c9                   	leave  
  100eec:	c3                   	ret    

00100eed <vector0>:
# __vectors地址处开始处连续存储了256个中断处理例程的入口地址数组
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  100eed:	6a 00                	push   $0x0
  pushl $0
  100eef:	6a 00                	push   $0x0
  jmp __alltraps
  100ef1:	e9 67 0a 00 00       	jmp    10195d <__alltraps>

00100ef6 <vector1>:
.globl vector1
vector1:
  pushl $0
  100ef6:	6a 00                	push   $0x0
  pushl $1
  100ef8:	6a 01                	push   $0x1
  jmp __alltraps
  100efa:	e9 5e 0a 00 00       	jmp    10195d <__alltraps>

00100eff <vector2>:
.globl vector2
vector2:
  pushl $0
  100eff:	6a 00                	push   $0x0
  pushl $2
  100f01:	6a 02                	push   $0x2
  jmp __alltraps
  100f03:	e9 55 0a 00 00       	jmp    10195d <__alltraps>

00100f08 <vector3>:
.globl vector3
vector3:
  pushl $0
  100f08:	6a 00                	push   $0x0
  pushl $3
  100f0a:	6a 03                	push   $0x3
  jmp __alltraps
  100f0c:	e9 4c 0a 00 00       	jmp    10195d <__alltraps>

00100f11 <vector4>:
.globl vector4
vector4:
  pushl $0
  100f11:	6a 00                	push   $0x0
  pushl $4
  100f13:	6a 04                	push   $0x4
  jmp __alltraps
  100f15:	e9 43 0a 00 00       	jmp    10195d <__alltraps>

00100f1a <vector5>:
.globl vector5
vector5:
  pushl $0
  100f1a:	6a 00                	push   $0x0
  pushl $5
  100f1c:	6a 05                	push   $0x5
  jmp __alltraps
  100f1e:	e9 3a 0a 00 00       	jmp    10195d <__alltraps>

00100f23 <vector6>:
.globl vector6
vector6:
  pushl $0
  100f23:	6a 00                	push   $0x0
  pushl $6
  100f25:	6a 06                	push   $0x6
  jmp __alltraps
  100f27:	e9 31 0a 00 00       	jmp    10195d <__alltraps>

00100f2c <vector7>:
.globl vector7
vector7:
  pushl $0
  100f2c:	6a 00                	push   $0x0
  pushl $7
  100f2e:	6a 07                	push   $0x7
  jmp __alltraps
  100f30:	e9 28 0a 00 00       	jmp    10195d <__alltraps>

00100f35 <vector8>:
.globl vector8
vector8:
  pushl $8
  100f35:	6a 08                	push   $0x8
  jmp __alltraps
  100f37:	e9 21 0a 00 00       	jmp    10195d <__alltraps>

00100f3c <vector9>:
.globl vector9
vector9:
  pushl $9
  100f3c:	6a 09                	push   $0x9
  jmp __alltraps
  100f3e:	e9 1a 0a 00 00       	jmp    10195d <__alltraps>

00100f43 <vector10>:
.globl vector10
vector10:
  pushl $10
  100f43:	6a 0a                	push   $0xa
  jmp __alltraps
  100f45:	e9 13 0a 00 00       	jmp    10195d <__alltraps>

00100f4a <vector11>:
.globl vector11
vector11:
  pushl $11
  100f4a:	6a 0b                	push   $0xb
  jmp __alltraps
  100f4c:	e9 0c 0a 00 00       	jmp    10195d <__alltraps>

00100f51 <vector12>:
.globl vector12
vector12:
  pushl $12
  100f51:	6a 0c                	push   $0xc
  jmp __alltraps
  100f53:	e9 05 0a 00 00       	jmp    10195d <__alltraps>

00100f58 <vector13>:
.globl vector13
vector13:
  pushl $13
  100f58:	6a 0d                	push   $0xd
  jmp __alltraps
  100f5a:	e9 fe 09 00 00       	jmp    10195d <__alltraps>

00100f5f <vector14>:
.globl vector14
vector14:
  pushl $14
  100f5f:	6a 0e                	push   $0xe
  jmp __alltraps
  100f61:	e9 f7 09 00 00       	jmp    10195d <__alltraps>

00100f66 <vector15>:
.globl vector15
vector15:
  pushl $0
  100f66:	6a 00                	push   $0x0
  pushl $15
  100f68:	6a 0f                	push   $0xf
  jmp __alltraps
  100f6a:	e9 ee 09 00 00       	jmp    10195d <__alltraps>

00100f6f <vector16>:
.globl vector16
vector16:
  pushl $0
  100f6f:	6a 00                	push   $0x0
  pushl $16
  100f71:	6a 10                	push   $0x10
  jmp __alltraps
  100f73:	e9 e5 09 00 00       	jmp    10195d <__alltraps>

00100f78 <vector17>:
.globl vector17
vector17:
  pushl $17
  100f78:	6a 11                	push   $0x11
  jmp __alltraps
  100f7a:	e9 de 09 00 00       	jmp    10195d <__alltraps>

00100f7f <vector18>:
.globl vector18
vector18:
  pushl $0
  100f7f:	6a 00                	push   $0x0
  pushl $18
  100f81:	6a 12                	push   $0x12
  jmp __alltraps
  100f83:	e9 d5 09 00 00       	jmp    10195d <__alltraps>

00100f88 <vector19>:
.globl vector19
vector19:
  pushl $0
  100f88:	6a 00                	push   $0x0
  pushl $19
  100f8a:	6a 13                	push   $0x13
  jmp __alltraps
  100f8c:	e9 cc 09 00 00       	jmp    10195d <__alltraps>

00100f91 <vector20>:
.globl vector20
vector20:
  pushl $0
  100f91:	6a 00                	push   $0x0
  pushl $20
  100f93:	6a 14                	push   $0x14
  jmp __alltraps
  100f95:	e9 c3 09 00 00       	jmp    10195d <__alltraps>

00100f9a <vector21>:
.globl vector21
vector21:
  pushl $0
  100f9a:	6a 00                	push   $0x0
  pushl $21
  100f9c:	6a 15                	push   $0x15
  jmp __alltraps
  100f9e:	e9 ba 09 00 00       	jmp    10195d <__alltraps>

00100fa3 <vector22>:
.globl vector22
vector22:
  pushl $0
  100fa3:	6a 00                	push   $0x0
  pushl $22
  100fa5:	6a 16                	push   $0x16
  jmp __alltraps
  100fa7:	e9 b1 09 00 00       	jmp    10195d <__alltraps>

00100fac <vector23>:
.globl vector23
vector23:
  pushl $0
  100fac:	6a 00                	push   $0x0
  pushl $23
  100fae:	6a 17                	push   $0x17
  jmp __alltraps
  100fb0:	e9 a8 09 00 00       	jmp    10195d <__alltraps>

00100fb5 <vector24>:
.globl vector24
vector24:
  pushl $0
  100fb5:	6a 00                	push   $0x0
  pushl $24
  100fb7:	6a 18                	push   $0x18
  jmp __alltraps
  100fb9:	e9 9f 09 00 00       	jmp    10195d <__alltraps>

00100fbe <vector25>:
.globl vector25
vector25:
  pushl $0
  100fbe:	6a 00                	push   $0x0
  pushl $25
  100fc0:	6a 19                	push   $0x19
  jmp __alltraps
  100fc2:	e9 96 09 00 00       	jmp    10195d <__alltraps>

00100fc7 <vector26>:
.globl vector26
vector26:
  pushl $0
  100fc7:	6a 00                	push   $0x0
  pushl $26
  100fc9:	6a 1a                	push   $0x1a
  jmp __alltraps
  100fcb:	e9 8d 09 00 00       	jmp    10195d <__alltraps>

00100fd0 <vector27>:
.globl vector27
vector27:
  pushl $0
  100fd0:	6a 00                	push   $0x0
  pushl $27
  100fd2:	6a 1b                	push   $0x1b
  jmp __alltraps
  100fd4:	e9 84 09 00 00       	jmp    10195d <__alltraps>

00100fd9 <vector28>:
.globl vector28
vector28:
  pushl $0
  100fd9:	6a 00                	push   $0x0
  pushl $28
  100fdb:	6a 1c                	push   $0x1c
  jmp __alltraps
  100fdd:	e9 7b 09 00 00       	jmp    10195d <__alltraps>

00100fe2 <vector29>:
.globl vector29
vector29:
  pushl $0
  100fe2:	6a 00                	push   $0x0
  pushl $29
  100fe4:	6a 1d                	push   $0x1d
  jmp __alltraps
  100fe6:	e9 72 09 00 00       	jmp    10195d <__alltraps>

00100feb <vector30>:
.globl vector30
vector30:
  pushl $0
  100feb:	6a 00                	push   $0x0
  pushl $30
  100fed:	6a 1e                	push   $0x1e
  jmp __alltraps
  100fef:	e9 69 09 00 00       	jmp    10195d <__alltraps>

00100ff4 <vector31>:
.globl vector31
vector31:
  pushl $0
  100ff4:	6a 00                	push   $0x0
  pushl $31
  100ff6:	6a 1f                	push   $0x1f
  jmp __alltraps
  100ff8:	e9 60 09 00 00       	jmp    10195d <__alltraps>

00100ffd <vector32>:
.globl vector32
vector32:
  pushl $0
  100ffd:	6a 00                	push   $0x0
  pushl $32
  100fff:	6a 20                	push   $0x20
  jmp __alltraps
  101001:	e9 57 09 00 00       	jmp    10195d <__alltraps>

00101006 <vector33>:
.globl vector33
vector33:
  pushl $0
  101006:	6a 00                	push   $0x0
  pushl $33
  101008:	6a 21                	push   $0x21
  jmp __alltraps
  10100a:	e9 4e 09 00 00       	jmp    10195d <__alltraps>

0010100f <vector34>:
.globl vector34
vector34:
  pushl $0
  10100f:	6a 00                	push   $0x0
  pushl $34
  101011:	6a 22                	push   $0x22
  jmp __alltraps
  101013:	e9 45 09 00 00       	jmp    10195d <__alltraps>

00101018 <vector35>:
.globl vector35
vector35:
  pushl $0
  101018:	6a 00                	push   $0x0
  pushl $35
  10101a:	6a 23                	push   $0x23
  jmp __alltraps
  10101c:	e9 3c 09 00 00       	jmp    10195d <__alltraps>

00101021 <vector36>:
.globl vector36
vector36:
  pushl $0
  101021:	6a 00                	push   $0x0
  pushl $36
  101023:	6a 24                	push   $0x24
  jmp __alltraps
  101025:	e9 33 09 00 00       	jmp    10195d <__alltraps>

0010102a <vector37>:
.globl vector37
vector37:
  pushl $0
  10102a:	6a 00                	push   $0x0
  pushl $37
  10102c:	6a 25                	push   $0x25
  jmp __alltraps
  10102e:	e9 2a 09 00 00       	jmp    10195d <__alltraps>

00101033 <vector38>:
.globl vector38
vector38:
  pushl $0
  101033:	6a 00                	push   $0x0
  pushl $38
  101035:	6a 26                	push   $0x26
  jmp __alltraps
  101037:	e9 21 09 00 00       	jmp    10195d <__alltraps>

0010103c <vector39>:
.globl vector39
vector39:
  pushl $0
  10103c:	6a 00                	push   $0x0
  pushl $39
  10103e:	6a 27                	push   $0x27
  jmp __alltraps
  101040:	e9 18 09 00 00       	jmp    10195d <__alltraps>

00101045 <vector40>:
.globl vector40
vector40:
  pushl $0
  101045:	6a 00                	push   $0x0
  pushl $40
  101047:	6a 28                	push   $0x28
  jmp __alltraps
  101049:	e9 0f 09 00 00       	jmp    10195d <__alltraps>

0010104e <vector41>:
.globl vector41
vector41:
  pushl $0
  10104e:	6a 00                	push   $0x0
  pushl $41
  101050:	6a 29                	push   $0x29
  jmp __alltraps
  101052:	e9 06 09 00 00       	jmp    10195d <__alltraps>

00101057 <vector42>:
.globl vector42
vector42:
  pushl $0
  101057:	6a 00                	push   $0x0
  pushl $42
  101059:	6a 2a                	push   $0x2a
  jmp __alltraps
  10105b:	e9 fd 08 00 00       	jmp    10195d <__alltraps>

00101060 <vector43>:
.globl vector43
vector43:
  pushl $0
  101060:	6a 00                	push   $0x0
  pushl $43
  101062:	6a 2b                	push   $0x2b
  jmp __alltraps
  101064:	e9 f4 08 00 00       	jmp    10195d <__alltraps>

00101069 <vector44>:
.globl vector44
vector44:
  pushl $0
  101069:	6a 00                	push   $0x0
  pushl $44
  10106b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10106d:	e9 eb 08 00 00       	jmp    10195d <__alltraps>

00101072 <vector45>:
.globl vector45
vector45:
  pushl $0
  101072:	6a 00                	push   $0x0
  pushl $45
  101074:	6a 2d                	push   $0x2d
  jmp __alltraps
  101076:	e9 e2 08 00 00       	jmp    10195d <__alltraps>

0010107b <vector46>:
.globl vector46
vector46:
  pushl $0
  10107b:	6a 00                	push   $0x0
  pushl $46
  10107d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10107f:	e9 d9 08 00 00       	jmp    10195d <__alltraps>

00101084 <vector47>:
.globl vector47
vector47:
  pushl $0
  101084:	6a 00                	push   $0x0
  pushl $47
  101086:	6a 2f                	push   $0x2f
  jmp __alltraps
  101088:	e9 d0 08 00 00       	jmp    10195d <__alltraps>

0010108d <vector48>:
.globl vector48
vector48:
  pushl $0
  10108d:	6a 00                	push   $0x0
  pushl $48
  10108f:	6a 30                	push   $0x30
  jmp __alltraps
  101091:	e9 c7 08 00 00       	jmp    10195d <__alltraps>

00101096 <vector49>:
.globl vector49
vector49:
  pushl $0
  101096:	6a 00                	push   $0x0
  pushl $49
  101098:	6a 31                	push   $0x31
  jmp __alltraps
  10109a:	e9 be 08 00 00       	jmp    10195d <__alltraps>

0010109f <vector50>:
.globl vector50
vector50:
  pushl $0
  10109f:	6a 00                	push   $0x0
  pushl $50
  1010a1:	6a 32                	push   $0x32
  jmp __alltraps
  1010a3:	e9 b5 08 00 00       	jmp    10195d <__alltraps>

001010a8 <vector51>:
.globl vector51
vector51:
  pushl $0
  1010a8:	6a 00                	push   $0x0
  pushl $51
  1010aa:	6a 33                	push   $0x33
  jmp __alltraps
  1010ac:	e9 ac 08 00 00       	jmp    10195d <__alltraps>

001010b1 <vector52>:
.globl vector52
vector52:
  pushl $0
  1010b1:	6a 00                	push   $0x0
  pushl $52
  1010b3:	6a 34                	push   $0x34
  jmp __alltraps
  1010b5:	e9 a3 08 00 00       	jmp    10195d <__alltraps>

001010ba <vector53>:
.globl vector53
vector53:
  pushl $0
  1010ba:	6a 00                	push   $0x0
  pushl $53
  1010bc:	6a 35                	push   $0x35
  jmp __alltraps
  1010be:	e9 9a 08 00 00       	jmp    10195d <__alltraps>

001010c3 <vector54>:
.globl vector54
vector54:
  pushl $0
  1010c3:	6a 00                	push   $0x0
  pushl $54
  1010c5:	6a 36                	push   $0x36
  jmp __alltraps
  1010c7:	e9 91 08 00 00       	jmp    10195d <__alltraps>

001010cc <vector55>:
.globl vector55
vector55:
  pushl $0
  1010cc:	6a 00                	push   $0x0
  pushl $55
  1010ce:	6a 37                	push   $0x37
  jmp __alltraps
  1010d0:	e9 88 08 00 00       	jmp    10195d <__alltraps>

001010d5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1010d5:	6a 00                	push   $0x0
  pushl $56
  1010d7:	6a 38                	push   $0x38
  jmp __alltraps
  1010d9:	e9 7f 08 00 00       	jmp    10195d <__alltraps>

001010de <vector57>:
.globl vector57
vector57:
  pushl $0
  1010de:	6a 00                	push   $0x0
  pushl $57
  1010e0:	6a 39                	push   $0x39
  jmp __alltraps
  1010e2:	e9 76 08 00 00       	jmp    10195d <__alltraps>

001010e7 <vector58>:
.globl vector58
vector58:
  pushl $0
  1010e7:	6a 00                	push   $0x0
  pushl $58
  1010e9:	6a 3a                	push   $0x3a
  jmp __alltraps
  1010eb:	e9 6d 08 00 00       	jmp    10195d <__alltraps>

001010f0 <vector59>:
.globl vector59
vector59:
  pushl $0
  1010f0:	6a 00                	push   $0x0
  pushl $59
  1010f2:	6a 3b                	push   $0x3b
  jmp __alltraps
  1010f4:	e9 64 08 00 00       	jmp    10195d <__alltraps>

001010f9 <vector60>:
.globl vector60
vector60:
  pushl $0
  1010f9:	6a 00                	push   $0x0
  pushl $60
  1010fb:	6a 3c                	push   $0x3c
  jmp __alltraps
  1010fd:	e9 5b 08 00 00       	jmp    10195d <__alltraps>

00101102 <vector61>:
.globl vector61
vector61:
  pushl $0
  101102:	6a 00                	push   $0x0
  pushl $61
  101104:	6a 3d                	push   $0x3d
  jmp __alltraps
  101106:	e9 52 08 00 00       	jmp    10195d <__alltraps>

0010110b <vector62>:
.globl vector62
vector62:
  pushl $0
  10110b:	6a 00                	push   $0x0
  pushl $62
  10110d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10110f:	e9 49 08 00 00       	jmp    10195d <__alltraps>

00101114 <vector63>:
.globl vector63
vector63:
  pushl $0
  101114:	6a 00                	push   $0x0
  pushl $63
  101116:	6a 3f                	push   $0x3f
  jmp __alltraps
  101118:	e9 40 08 00 00       	jmp    10195d <__alltraps>

0010111d <vector64>:
.globl vector64
vector64:
  pushl $0
  10111d:	6a 00                	push   $0x0
  pushl $64
  10111f:	6a 40                	push   $0x40
  jmp __alltraps
  101121:	e9 37 08 00 00       	jmp    10195d <__alltraps>

00101126 <vector65>:
.globl vector65
vector65:
  pushl $0
  101126:	6a 00                	push   $0x0
  pushl $65
  101128:	6a 41                	push   $0x41
  jmp __alltraps
  10112a:	e9 2e 08 00 00       	jmp    10195d <__alltraps>

0010112f <vector66>:
.globl vector66
vector66:
  pushl $0
  10112f:	6a 00                	push   $0x0
  pushl $66
  101131:	6a 42                	push   $0x42
  jmp __alltraps
  101133:	e9 25 08 00 00       	jmp    10195d <__alltraps>

00101138 <vector67>:
.globl vector67
vector67:
  pushl $0
  101138:	6a 00                	push   $0x0
  pushl $67
  10113a:	6a 43                	push   $0x43
  jmp __alltraps
  10113c:	e9 1c 08 00 00       	jmp    10195d <__alltraps>

00101141 <vector68>:
.globl vector68
vector68:
  pushl $0
  101141:	6a 00                	push   $0x0
  pushl $68
  101143:	6a 44                	push   $0x44
  jmp __alltraps
  101145:	e9 13 08 00 00       	jmp    10195d <__alltraps>

0010114a <vector69>:
.globl vector69
vector69:
  pushl $0
  10114a:	6a 00                	push   $0x0
  pushl $69
  10114c:	6a 45                	push   $0x45
  jmp __alltraps
  10114e:	e9 0a 08 00 00       	jmp    10195d <__alltraps>

00101153 <vector70>:
.globl vector70
vector70:
  pushl $0
  101153:	6a 00                	push   $0x0
  pushl $70
  101155:	6a 46                	push   $0x46
  jmp __alltraps
  101157:	e9 01 08 00 00       	jmp    10195d <__alltraps>

0010115c <vector71>:
.globl vector71
vector71:
  pushl $0
  10115c:	6a 00                	push   $0x0
  pushl $71
  10115e:	6a 47                	push   $0x47
  jmp __alltraps
  101160:	e9 f8 07 00 00       	jmp    10195d <__alltraps>

00101165 <vector72>:
.globl vector72
vector72:
  pushl $0
  101165:	6a 00                	push   $0x0
  pushl $72
  101167:	6a 48                	push   $0x48
  jmp __alltraps
  101169:	e9 ef 07 00 00       	jmp    10195d <__alltraps>

0010116e <vector73>:
.globl vector73
vector73:
  pushl $0
  10116e:	6a 00                	push   $0x0
  pushl $73
  101170:	6a 49                	push   $0x49
  jmp __alltraps
  101172:	e9 e6 07 00 00       	jmp    10195d <__alltraps>

00101177 <vector74>:
.globl vector74
vector74:
  pushl $0
  101177:	6a 00                	push   $0x0
  pushl $74
  101179:	6a 4a                	push   $0x4a
  jmp __alltraps
  10117b:	e9 dd 07 00 00       	jmp    10195d <__alltraps>

00101180 <vector75>:
.globl vector75
vector75:
  pushl $0
  101180:	6a 00                	push   $0x0
  pushl $75
  101182:	6a 4b                	push   $0x4b
  jmp __alltraps
  101184:	e9 d4 07 00 00       	jmp    10195d <__alltraps>

00101189 <vector76>:
.globl vector76
vector76:
  pushl $0
  101189:	6a 00                	push   $0x0
  pushl $76
  10118b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10118d:	e9 cb 07 00 00       	jmp    10195d <__alltraps>

00101192 <vector77>:
.globl vector77
vector77:
  pushl $0
  101192:	6a 00                	push   $0x0
  pushl $77
  101194:	6a 4d                	push   $0x4d
  jmp __alltraps
  101196:	e9 c2 07 00 00       	jmp    10195d <__alltraps>

0010119b <vector78>:
.globl vector78
vector78:
  pushl $0
  10119b:	6a 00                	push   $0x0
  pushl $78
  10119d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10119f:	e9 b9 07 00 00       	jmp    10195d <__alltraps>

001011a4 <vector79>:
.globl vector79
vector79:
  pushl $0
  1011a4:	6a 00                	push   $0x0
  pushl $79
  1011a6:	6a 4f                	push   $0x4f
  jmp __alltraps
  1011a8:	e9 b0 07 00 00       	jmp    10195d <__alltraps>

001011ad <vector80>:
.globl vector80
vector80:
  pushl $0
  1011ad:	6a 00                	push   $0x0
  pushl $80
  1011af:	6a 50                	push   $0x50
  jmp __alltraps
  1011b1:	e9 a7 07 00 00       	jmp    10195d <__alltraps>

001011b6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1011b6:	6a 00                	push   $0x0
  pushl $81
  1011b8:	6a 51                	push   $0x51
  jmp __alltraps
  1011ba:	e9 9e 07 00 00       	jmp    10195d <__alltraps>

001011bf <vector82>:
.globl vector82
vector82:
  pushl $0
  1011bf:	6a 00                	push   $0x0
  pushl $82
  1011c1:	6a 52                	push   $0x52
  jmp __alltraps
  1011c3:	e9 95 07 00 00       	jmp    10195d <__alltraps>

001011c8 <vector83>:
.globl vector83
vector83:
  pushl $0
  1011c8:	6a 00                	push   $0x0
  pushl $83
  1011ca:	6a 53                	push   $0x53
  jmp __alltraps
  1011cc:	e9 8c 07 00 00       	jmp    10195d <__alltraps>

001011d1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1011d1:	6a 00                	push   $0x0
  pushl $84
  1011d3:	6a 54                	push   $0x54
  jmp __alltraps
  1011d5:	e9 83 07 00 00       	jmp    10195d <__alltraps>

001011da <vector85>:
.globl vector85
vector85:
  pushl $0
  1011da:	6a 00                	push   $0x0
  pushl $85
  1011dc:	6a 55                	push   $0x55
  jmp __alltraps
  1011de:	e9 7a 07 00 00       	jmp    10195d <__alltraps>

001011e3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1011e3:	6a 00                	push   $0x0
  pushl $86
  1011e5:	6a 56                	push   $0x56
  jmp __alltraps
  1011e7:	e9 71 07 00 00       	jmp    10195d <__alltraps>

001011ec <vector87>:
.globl vector87
vector87:
  pushl $0
  1011ec:	6a 00                	push   $0x0
  pushl $87
  1011ee:	6a 57                	push   $0x57
  jmp __alltraps
  1011f0:	e9 68 07 00 00       	jmp    10195d <__alltraps>

001011f5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1011f5:	6a 00                	push   $0x0
  pushl $88
  1011f7:	6a 58                	push   $0x58
  jmp __alltraps
  1011f9:	e9 5f 07 00 00       	jmp    10195d <__alltraps>

001011fe <vector89>:
.globl vector89
vector89:
  pushl $0
  1011fe:	6a 00                	push   $0x0
  pushl $89
  101200:	6a 59                	push   $0x59
  jmp __alltraps
  101202:	e9 56 07 00 00       	jmp    10195d <__alltraps>

00101207 <vector90>:
.globl vector90
vector90:
  pushl $0
  101207:	6a 00                	push   $0x0
  pushl $90
  101209:	6a 5a                	push   $0x5a
  jmp __alltraps
  10120b:	e9 4d 07 00 00       	jmp    10195d <__alltraps>

00101210 <vector91>:
.globl vector91
vector91:
  pushl $0
  101210:	6a 00                	push   $0x0
  pushl $91
  101212:	6a 5b                	push   $0x5b
  jmp __alltraps
  101214:	e9 44 07 00 00       	jmp    10195d <__alltraps>

00101219 <vector92>:
.globl vector92
vector92:
  pushl $0
  101219:	6a 00                	push   $0x0
  pushl $92
  10121b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10121d:	e9 3b 07 00 00       	jmp    10195d <__alltraps>

00101222 <vector93>:
.globl vector93
vector93:
  pushl $0
  101222:	6a 00                	push   $0x0
  pushl $93
  101224:	6a 5d                	push   $0x5d
  jmp __alltraps
  101226:	e9 32 07 00 00       	jmp    10195d <__alltraps>

0010122b <vector94>:
.globl vector94
vector94:
  pushl $0
  10122b:	6a 00                	push   $0x0
  pushl $94
  10122d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10122f:	e9 29 07 00 00       	jmp    10195d <__alltraps>

00101234 <vector95>:
.globl vector95
vector95:
  pushl $0
  101234:	6a 00                	push   $0x0
  pushl $95
  101236:	6a 5f                	push   $0x5f
  jmp __alltraps
  101238:	e9 20 07 00 00       	jmp    10195d <__alltraps>

0010123d <vector96>:
.globl vector96
vector96:
  pushl $0
  10123d:	6a 00                	push   $0x0
  pushl $96
  10123f:	6a 60                	push   $0x60
  jmp __alltraps
  101241:	e9 17 07 00 00       	jmp    10195d <__alltraps>

00101246 <vector97>:
.globl vector97
vector97:
  pushl $0
  101246:	6a 00                	push   $0x0
  pushl $97
  101248:	6a 61                	push   $0x61
  jmp __alltraps
  10124a:	e9 0e 07 00 00       	jmp    10195d <__alltraps>

0010124f <vector98>:
.globl vector98
vector98:
  pushl $0
  10124f:	6a 00                	push   $0x0
  pushl $98
  101251:	6a 62                	push   $0x62
  jmp __alltraps
  101253:	e9 05 07 00 00       	jmp    10195d <__alltraps>

00101258 <vector99>:
.globl vector99
vector99:
  pushl $0
  101258:	6a 00                	push   $0x0
  pushl $99
  10125a:	6a 63                	push   $0x63
  jmp __alltraps
  10125c:	e9 fc 06 00 00       	jmp    10195d <__alltraps>

00101261 <vector100>:
.globl vector100
vector100:
  pushl $0
  101261:	6a 00                	push   $0x0
  pushl $100
  101263:	6a 64                	push   $0x64
  jmp __alltraps
  101265:	e9 f3 06 00 00       	jmp    10195d <__alltraps>

0010126a <vector101>:
.globl vector101
vector101:
  pushl $0
  10126a:	6a 00                	push   $0x0
  pushl $101
  10126c:	6a 65                	push   $0x65
  jmp __alltraps
  10126e:	e9 ea 06 00 00       	jmp    10195d <__alltraps>

00101273 <vector102>:
.globl vector102
vector102:
  pushl $0
  101273:	6a 00                	push   $0x0
  pushl $102
  101275:	6a 66                	push   $0x66
  jmp __alltraps
  101277:	e9 e1 06 00 00       	jmp    10195d <__alltraps>

0010127c <vector103>:
.globl vector103
vector103:
  pushl $0
  10127c:	6a 00                	push   $0x0
  pushl $103
  10127e:	6a 67                	push   $0x67
  jmp __alltraps
  101280:	e9 d8 06 00 00       	jmp    10195d <__alltraps>

00101285 <vector104>:
.globl vector104
vector104:
  pushl $0
  101285:	6a 00                	push   $0x0
  pushl $104
  101287:	6a 68                	push   $0x68
  jmp __alltraps
  101289:	e9 cf 06 00 00       	jmp    10195d <__alltraps>

0010128e <vector105>:
.globl vector105
vector105:
  pushl $0
  10128e:	6a 00                	push   $0x0
  pushl $105
  101290:	6a 69                	push   $0x69
  jmp __alltraps
  101292:	e9 c6 06 00 00       	jmp    10195d <__alltraps>

00101297 <vector106>:
.globl vector106
vector106:
  pushl $0
  101297:	6a 00                	push   $0x0
  pushl $106
  101299:	6a 6a                	push   $0x6a
  jmp __alltraps
  10129b:	e9 bd 06 00 00       	jmp    10195d <__alltraps>

001012a0 <vector107>:
.globl vector107
vector107:
  pushl $0
  1012a0:	6a 00                	push   $0x0
  pushl $107
  1012a2:	6a 6b                	push   $0x6b
  jmp __alltraps
  1012a4:	e9 b4 06 00 00       	jmp    10195d <__alltraps>

001012a9 <vector108>:
.globl vector108
vector108:
  pushl $0
  1012a9:	6a 00                	push   $0x0
  pushl $108
  1012ab:	6a 6c                	push   $0x6c
  jmp __alltraps
  1012ad:	e9 ab 06 00 00       	jmp    10195d <__alltraps>

001012b2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1012b2:	6a 00                	push   $0x0
  pushl $109
  1012b4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1012b6:	e9 a2 06 00 00       	jmp    10195d <__alltraps>

001012bb <vector110>:
.globl vector110
vector110:
  pushl $0
  1012bb:	6a 00                	push   $0x0
  pushl $110
  1012bd:	6a 6e                	push   $0x6e
  jmp __alltraps
  1012bf:	e9 99 06 00 00       	jmp    10195d <__alltraps>

001012c4 <vector111>:
.globl vector111
vector111:
  pushl $0
  1012c4:	6a 00                	push   $0x0
  pushl $111
  1012c6:	6a 6f                	push   $0x6f
  jmp __alltraps
  1012c8:	e9 90 06 00 00       	jmp    10195d <__alltraps>

001012cd <vector112>:
.globl vector112
vector112:
  pushl $0
  1012cd:	6a 00                	push   $0x0
  pushl $112
  1012cf:	6a 70                	push   $0x70
  jmp __alltraps
  1012d1:	e9 87 06 00 00       	jmp    10195d <__alltraps>

001012d6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1012d6:	6a 00                	push   $0x0
  pushl $113
  1012d8:	6a 71                	push   $0x71
  jmp __alltraps
  1012da:	e9 7e 06 00 00       	jmp    10195d <__alltraps>

001012df <vector114>:
.globl vector114
vector114:
  pushl $0
  1012df:	6a 00                	push   $0x0
  pushl $114
  1012e1:	6a 72                	push   $0x72
  jmp __alltraps
  1012e3:	e9 75 06 00 00       	jmp    10195d <__alltraps>

001012e8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1012e8:	6a 00                	push   $0x0
  pushl $115
  1012ea:	6a 73                	push   $0x73
  jmp __alltraps
  1012ec:	e9 6c 06 00 00       	jmp    10195d <__alltraps>

001012f1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1012f1:	6a 00                	push   $0x0
  pushl $116
  1012f3:	6a 74                	push   $0x74
  jmp __alltraps
  1012f5:	e9 63 06 00 00       	jmp    10195d <__alltraps>

001012fa <vector117>:
.globl vector117
vector117:
  pushl $0
  1012fa:	6a 00                	push   $0x0
  pushl $117
  1012fc:	6a 75                	push   $0x75
  jmp __alltraps
  1012fe:	e9 5a 06 00 00       	jmp    10195d <__alltraps>

00101303 <vector118>:
.globl vector118
vector118:
  pushl $0
  101303:	6a 00                	push   $0x0
  pushl $118
  101305:	6a 76                	push   $0x76
  jmp __alltraps
  101307:	e9 51 06 00 00       	jmp    10195d <__alltraps>

0010130c <vector119>:
.globl vector119
vector119:
  pushl $0
  10130c:	6a 00                	push   $0x0
  pushl $119
  10130e:	6a 77                	push   $0x77
  jmp __alltraps
  101310:	e9 48 06 00 00       	jmp    10195d <__alltraps>

00101315 <vector120>:
.globl vector120
vector120:
  pushl $0
  101315:	6a 00                	push   $0x0
  pushl $120
  101317:	6a 78                	push   $0x78
  jmp __alltraps
  101319:	e9 3f 06 00 00       	jmp    10195d <__alltraps>

0010131e <vector121>:
.globl vector121
vector121:
  pushl $0
  10131e:	6a 00                	push   $0x0
  pushl $121
  101320:	6a 79                	push   $0x79
  jmp __alltraps
  101322:	e9 36 06 00 00       	jmp    10195d <__alltraps>

00101327 <vector122>:
.globl vector122
vector122:
  pushl $0
  101327:	6a 00                	push   $0x0
  pushl $122
  101329:	6a 7a                	push   $0x7a
  jmp __alltraps
  10132b:	e9 2d 06 00 00       	jmp    10195d <__alltraps>

00101330 <vector123>:
.globl vector123
vector123:
  pushl $0
  101330:	6a 00                	push   $0x0
  pushl $123
  101332:	6a 7b                	push   $0x7b
  jmp __alltraps
  101334:	e9 24 06 00 00       	jmp    10195d <__alltraps>

00101339 <vector124>:
.globl vector124
vector124:
  pushl $0
  101339:	6a 00                	push   $0x0
  pushl $124
  10133b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10133d:	e9 1b 06 00 00       	jmp    10195d <__alltraps>

00101342 <vector125>:
.globl vector125
vector125:
  pushl $0
  101342:	6a 00                	push   $0x0
  pushl $125
  101344:	6a 7d                	push   $0x7d
  jmp __alltraps
  101346:	e9 12 06 00 00       	jmp    10195d <__alltraps>

0010134b <vector126>:
.globl vector126
vector126:
  pushl $0
  10134b:	6a 00                	push   $0x0
  pushl $126
  10134d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10134f:	e9 09 06 00 00       	jmp    10195d <__alltraps>

00101354 <vector127>:
.globl vector127
vector127:
  pushl $0
  101354:	6a 00                	push   $0x0
  pushl $127
  101356:	6a 7f                	push   $0x7f
  jmp __alltraps
  101358:	e9 00 06 00 00       	jmp    10195d <__alltraps>

0010135d <vector128>:
.globl vector128
vector128:
  pushl $0
  10135d:	6a 00                	push   $0x0
  pushl $128
  10135f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  101364:	e9 f4 05 00 00       	jmp    10195d <__alltraps>

00101369 <vector129>:
.globl vector129
vector129:
  pushl $0
  101369:	6a 00                	push   $0x0
  pushl $129
  10136b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  101370:	e9 e8 05 00 00       	jmp    10195d <__alltraps>

00101375 <vector130>:
.globl vector130
vector130:
  pushl $0
  101375:	6a 00                	push   $0x0
  pushl $130
  101377:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10137c:	e9 dc 05 00 00       	jmp    10195d <__alltraps>

00101381 <vector131>:
.globl vector131
vector131:
  pushl $0
  101381:	6a 00                	push   $0x0
  pushl $131
  101383:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  101388:	e9 d0 05 00 00       	jmp    10195d <__alltraps>

0010138d <vector132>:
.globl vector132
vector132:
  pushl $0
  10138d:	6a 00                	push   $0x0
  pushl $132
  10138f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  101394:	e9 c4 05 00 00       	jmp    10195d <__alltraps>

00101399 <vector133>:
.globl vector133
vector133:
  pushl $0
  101399:	6a 00                	push   $0x0
  pushl $133
  10139b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1013a0:	e9 b8 05 00 00       	jmp    10195d <__alltraps>

001013a5 <vector134>:
.globl vector134
vector134:
  pushl $0
  1013a5:	6a 00                	push   $0x0
  pushl $134
  1013a7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1013ac:	e9 ac 05 00 00       	jmp    10195d <__alltraps>

001013b1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1013b1:	6a 00                	push   $0x0
  pushl $135
  1013b3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1013b8:	e9 a0 05 00 00       	jmp    10195d <__alltraps>

001013bd <vector136>:
.globl vector136
vector136:
  pushl $0
  1013bd:	6a 00                	push   $0x0
  pushl $136
  1013bf:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1013c4:	e9 94 05 00 00       	jmp    10195d <__alltraps>

001013c9 <vector137>:
.globl vector137
vector137:
  pushl $0
  1013c9:	6a 00                	push   $0x0
  pushl $137
  1013cb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1013d0:	e9 88 05 00 00       	jmp    10195d <__alltraps>

001013d5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1013d5:	6a 00                	push   $0x0
  pushl $138
  1013d7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1013dc:	e9 7c 05 00 00       	jmp    10195d <__alltraps>

001013e1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1013e1:	6a 00                	push   $0x0
  pushl $139
  1013e3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1013e8:	e9 70 05 00 00       	jmp    10195d <__alltraps>

001013ed <vector140>:
.globl vector140
vector140:
  pushl $0
  1013ed:	6a 00                	push   $0x0
  pushl $140
  1013ef:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1013f4:	e9 64 05 00 00       	jmp    10195d <__alltraps>

001013f9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1013f9:	6a 00                	push   $0x0
  pushl $141
  1013fb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  101400:	e9 58 05 00 00       	jmp    10195d <__alltraps>

00101405 <vector142>:
.globl vector142
vector142:
  pushl $0
  101405:	6a 00                	push   $0x0
  pushl $142
  101407:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10140c:	e9 4c 05 00 00       	jmp    10195d <__alltraps>

00101411 <vector143>:
.globl vector143
vector143:
  pushl $0
  101411:	6a 00                	push   $0x0
  pushl $143
  101413:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  101418:	e9 40 05 00 00       	jmp    10195d <__alltraps>

0010141d <vector144>:
.globl vector144
vector144:
  pushl $0
  10141d:	6a 00                	push   $0x0
  pushl $144
  10141f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  101424:	e9 34 05 00 00       	jmp    10195d <__alltraps>

00101429 <vector145>:
.globl vector145
vector145:
  pushl $0
  101429:	6a 00                	push   $0x0
  pushl $145
  10142b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  101430:	e9 28 05 00 00       	jmp    10195d <__alltraps>

00101435 <vector146>:
.globl vector146
vector146:
  pushl $0
  101435:	6a 00                	push   $0x0
  pushl $146
  101437:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10143c:	e9 1c 05 00 00       	jmp    10195d <__alltraps>

00101441 <vector147>:
.globl vector147
vector147:
  pushl $0
  101441:	6a 00                	push   $0x0
  pushl $147
  101443:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  101448:	e9 10 05 00 00       	jmp    10195d <__alltraps>

0010144d <vector148>:
.globl vector148
vector148:
  pushl $0
  10144d:	6a 00                	push   $0x0
  pushl $148
  10144f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  101454:	e9 04 05 00 00       	jmp    10195d <__alltraps>

00101459 <vector149>:
.globl vector149
vector149:
  pushl $0
  101459:	6a 00                	push   $0x0
  pushl $149
  10145b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  101460:	e9 f8 04 00 00       	jmp    10195d <__alltraps>

00101465 <vector150>:
.globl vector150
vector150:
  pushl $0
  101465:	6a 00                	push   $0x0
  pushl $150
  101467:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10146c:	e9 ec 04 00 00       	jmp    10195d <__alltraps>

00101471 <vector151>:
.globl vector151
vector151:
  pushl $0
  101471:	6a 00                	push   $0x0
  pushl $151
  101473:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  101478:	e9 e0 04 00 00       	jmp    10195d <__alltraps>

0010147d <vector152>:
.globl vector152
vector152:
  pushl $0
  10147d:	6a 00                	push   $0x0
  pushl $152
  10147f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  101484:	e9 d4 04 00 00       	jmp    10195d <__alltraps>

00101489 <vector153>:
.globl vector153
vector153:
  pushl $0
  101489:	6a 00                	push   $0x0
  pushl $153
  10148b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  101490:	e9 c8 04 00 00       	jmp    10195d <__alltraps>

00101495 <vector154>:
.globl vector154
vector154:
  pushl $0
  101495:	6a 00                	push   $0x0
  pushl $154
  101497:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10149c:	e9 bc 04 00 00       	jmp    10195d <__alltraps>

001014a1 <vector155>:
.globl vector155
vector155:
  pushl $0
  1014a1:	6a 00                	push   $0x0
  pushl $155
  1014a3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1014a8:	e9 b0 04 00 00       	jmp    10195d <__alltraps>

001014ad <vector156>:
.globl vector156
vector156:
  pushl $0
  1014ad:	6a 00                	push   $0x0
  pushl $156
  1014af:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1014b4:	e9 a4 04 00 00       	jmp    10195d <__alltraps>

001014b9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1014b9:	6a 00                	push   $0x0
  pushl $157
  1014bb:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1014c0:	e9 98 04 00 00       	jmp    10195d <__alltraps>

001014c5 <vector158>:
.globl vector158
vector158:
  pushl $0
  1014c5:	6a 00                	push   $0x0
  pushl $158
  1014c7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1014cc:	e9 8c 04 00 00       	jmp    10195d <__alltraps>

001014d1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1014d1:	6a 00                	push   $0x0
  pushl $159
  1014d3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1014d8:	e9 80 04 00 00       	jmp    10195d <__alltraps>

001014dd <vector160>:
.globl vector160
vector160:
  pushl $0
  1014dd:	6a 00                	push   $0x0
  pushl $160
  1014df:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1014e4:	e9 74 04 00 00       	jmp    10195d <__alltraps>

001014e9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1014e9:	6a 00                	push   $0x0
  pushl $161
  1014eb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1014f0:	e9 68 04 00 00       	jmp    10195d <__alltraps>

001014f5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1014f5:	6a 00                	push   $0x0
  pushl $162
  1014f7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1014fc:	e9 5c 04 00 00       	jmp    10195d <__alltraps>

00101501 <vector163>:
.globl vector163
vector163:
  pushl $0
  101501:	6a 00                	push   $0x0
  pushl $163
  101503:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  101508:	e9 50 04 00 00       	jmp    10195d <__alltraps>

0010150d <vector164>:
.globl vector164
vector164:
  pushl $0
  10150d:	6a 00                	push   $0x0
  pushl $164
  10150f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  101514:	e9 44 04 00 00       	jmp    10195d <__alltraps>

00101519 <vector165>:
.globl vector165
vector165:
  pushl $0
  101519:	6a 00                	push   $0x0
  pushl $165
  10151b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  101520:	e9 38 04 00 00       	jmp    10195d <__alltraps>

00101525 <vector166>:
.globl vector166
vector166:
  pushl $0
  101525:	6a 00                	push   $0x0
  pushl $166
  101527:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10152c:	e9 2c 04 00 00       	jmp    10195d <__alltraps>

00101531 <vector167>:
.globl vector167
vector167:
  pushl $0
  101531:	6a 00                	push   $0x0
  pushl $167
  101533:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  101538:	e9 20 04 00 00       	jmp    10195d <__alltraps>

0010153d <vector168>:
.globl vector168
vector168:
  pushl $0
  10153d:	6a 00                	push   $0x0
  pushl $168
  10153f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  101544:	e9 14 04 00 00       	jmp    10195d <__alltraps>

00101549 <vector169>:
.globl vector169
vector169:
  pushl $0
  101549:	6a 00                	push   $0x0
  pushl $169
  10154b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  101550:	e9 08 04 00 00       	jmp    10195d <__alltraps>

00101555 <vector170>:
.globl vector170
vector170:
  pushl $0
  101555:	6a 00                	push   $0x0
  pushl $170
  101557:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10155c:	e9 fc 03 00 00       	jmp    10195d <__alltraps>

00101561 <vector171>:
.globl vector171
vector171:
  pushl $0
  101561:	6a 00                	push   $0x0
  pushl $171
  101563:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  101568:	e9 f0 03 00 00       	jmp    10195d <__alltraps>

0010156d <vector172>:
.globl vector172
vector172:
  pushl $0
  10156d:	6a 00                	push   $0x0
  pushl $172
  10156f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  101574:	e9 e4 03 00 00       	jmp    10195d <__alltraps>

00101579 <vector173>:
.globl vector173
vector173:
  pushl $0
  101579:	6a 00                	push   $0x0
  pushl $173
  10157b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  101580:	e9 d8 03 00 00       	jmp    10195d <__alltraps>

00101585 <vector174>:
.globl vector174
vector174:
  pushl $0
  101585:	6a 00                	push   $0x0
  pushl $174
  101587:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10158c:	e9 cc 03 00 00       	jmp    10195d <__alltraps>

00101591 <vector175>:
.globl vector175
vector175:
  pushl $0
  101591:	6a 00                	push   $0x0
  pushl $175
  101593:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  101598:	e9 c0 03 00 00       	jmp    10195d <__alltraps>

0010159d <vector176>:
.globl vector176
vector176:
  pushl $0
  10159d:	6a 00                	push   $0x0
  pushl $176
  10159f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1015a4:	e9 b4 03 00 00       	jmp    10195d <__alltraps>

001015a9 <vector177>:
.globl vector177
vector177:
  pushl $0
  1015a9:	6a 00                	push   $0x0
  pushl $177
  1015ab:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1015b0:	e9 a8 03 00 00       	jmp    10195d <__alltraps>

001015b5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1015b5:	6a 00                	push   $0x0
  pushl $178
  1015b7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1015bc:	e9 9c 03 00 00       	jmp    10195d <__alltraps>

001015c1 <vector179>:
.globl vector179
vector179:
  pushl $0
  1015c1:	6a 00                	push   $0x0
  pushl $179
  1015c3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1015c8:	e9 90 03 00 00       	jmp    10195d <__alltraps>

001015cd <vector180>:
.globl vector180
vector180:
  pushl $0
  1015cd:	6a 00                	push   $0x0
  pushl $180
  1015cf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1015d4:	e9 84 03 00 00       	jmp    10195d <__alltraps>

001015d9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1015d9:	6a 00                	push   $0x0
  pushl $181
  1015db:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1015e0:	e9 78 03 00 00       	jmp    10195d <__alltraps>

001015e5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1015e5:	6a 00                	push   $0x0
  pushl $182
  1015e7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1015ec:	e9 6c 03 00 00       	jmp    10195d <__alltraps>

001015f1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1015f1:	6a 00                	push   $0x0
  pushl $183
  1015f3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1015f8:	e9 60 03 00 00       	jmp    10195d <__alltraps>

001015fd <vector184>:
.globl vector184
vector184:
  pushl $0
  1015fd:	6a 00                	push   $0x0
  pushl $184
  1015ff:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  101604:	e9 54 03 00 00       	jmp    10195d <__alltraps>

00101609 <vector185>:
.globl vector185
vector185:
  pushl $0
  101609:	6a 00                	push   $0x0
  pushl $185
  10160b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  101610:	e9 48 03 00 00       	jmp    10195d <__alltraps>

00101615 <vector186>:
.globl vector186
vector186:
  pushl $0
  101615:	6a 00                	push   $0x0
  pushl $186
  101617:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10161c:	e9 3c 03 00 00       	jmp    10195d <__alltraps>

00101621 <vector187>:
.globl vector187
vector187:
  pushl $0
  101621:	6a 00                	push   $0x0
  pushl $187
  101623:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  101628:	e9 30 03 00 00       	jmp    10195d <__alltraps>

0010162d <vector188>:
.globl vector188
vector188:
  pushl $0
  10162d:	6a 00                	push   $0x0
  pushl $188
  10162f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  101634:	e9 24 03 00 00       	jmp    10195d <__alltraps>

00101639 <vector189>:
.globl vector189
vector189:
  pushl $0
  101639:	6a 00                	push   $0x0
  pushl $189
  10163b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  101640:	e9 18 03 00 00       	jmp    10195d <__alltraps>

00101645 <vector190>:
.globl vector190
vector190:
  pushl $0
  101645:	6a 00                	push   $0x0
  pushl $190
  101647:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10164c:	e9 0c 03 00 00       	jmp    10195d <__alltraps>

00101651 <vector191>:
.globl vector191
vector191:
  pushl $0
  101651:	6a 00                	push   $0x0
  pushl $191
  101653:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  101658:	e9 00 03 00 00       	jmp    10195d <__alltraps>

0010165d <vector192>:
.globl vector192
vector192:
  pushl $0
  10165d:	6a 00                	push   $0x0
  pushl $192
  10165f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  101664:	e9 f4 02 00 00       	jmp    10195d <__alltraps>

00101669 <vector193>:
.globl vector193
vector193:
  pushl $0
  101669:	6a 00                	push   $0x0
  pushl $193
  10166b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  101670:	e9 e8 02 00 00       	jmp    10195d <__alltraps>

00101675 <vector194>:
.globl vector194
vector194:
  pushl $0
  101675:	6a 00                	push   $0x0
  pushl $194
  101677:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10167c:	e9 dc 02 00 00       	jmp    10195d <__alltraps>

00101681 <vector195>:
.globl vector195
vector195:
  pushl $0
  101681:	6a 00                	push   $0x0
  pushl $195
  101683:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  101688:	e9 d0 02 00 00       	jmp    10195d <__alltraps>

0010168d <vector196>:
.globl vector196
vector196:
  pushl $0
  10168d:	6a 00                	push   $0x0
  pushl $196
  10168f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  101694:	e9 c4 02 00 00       	jmp    10195d <__alltraps>

00101699 <vector197>:
.globl vector197
vector197:
  pushl $0
  101699:	6a 00                	push   $0x0
  pushl $197
  10169b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1016a0:	e9 b8 02 00 00       	jmp    10195d <__alltraps>

001016a5 <vector198>:
.globl vector198
vector198:
  pushl $0
  1016a5:	6a 00                	push   $0x0
  pushl $198
  1016a7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1016ac:	e9 ac 02 00 00       	jmp    10195d <__alltraps>

001016b1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1016b1:	6a 00                	push   $0x0
  pushl $199
  1016b3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1016b8:	e9 a0 02 00 00       	jmp    10195d <__alltraps>

001016bd <vector200>:
.globl vector200
vector200:
  pushl $0
  1016bd:	6a 00                	push   $0x0
  pushl $200
  1016bf:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1016c4:	e9 94 02 00 00       	jmp    10195d <__alltraps>

001016c9 <vector201>:
.globl vector201
vector201:
  pushl $0
  1016c9:	6a 00                	push   $0x0
  pushl $201
  1016cb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1016d0:	e9 88 02 00 00       	jmp    10195d <__alltraps>

001016d5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1016d5:	6a 00                	push   $0x0
  pushl $202
  1016d7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1016dc:	e9 7c 02 00 00       	jmp    10195d <__alltraps>

001016e1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1016e1:	6a 00                	push   $0x0
  pushl $203
  1016e3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1016e8:	e9 70 02 00 00       	jmp    10195d <__alltraps>

001016ed <vector204>:
.globl vector204
vector204:
  pushl $0
  1016ed:	6a 00                	push   $0x0
  pushl $204
  1016ef:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1016f4:	e9 64 02 00 00       	jmp    10195d <__alltraps>

001016f9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1016f9:	6a 00                	push   $0x0
  pushl $205
  1016fb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  101700:	e9 58 02 00 00       	jmp    10195d <__alltraps>

00101705 <vector206>:
.globl vector206
vector206:
  pushl $0
  101705:	6a 00                	push   $0x0
  pushl $206
  101707:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10170c:	e9 4c 02 00 00       	jmp    10195d <__alltraps>

00101711 <vector207>:
.globl vector207
vector207:
  pushl $0
  101711:	6a 00                	push   $0x0
  pushl $207
  101713:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  101718:	e9 40 02 00 00       	jmp    10195d <__alltraps>

0010171d <vector208>:
.globl vector208
vector208:
  pushl $0
  10171d:	6a 00                	push   $0x0
  pushl $208
  10171f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  101724:	e9 34 02 00 00       	jmp    10195d <__alltraps>

00101729 <vector209>:
.globl vector209
vector209:
  pushl $0
  101729:	6a 00                	push   $0x0
  pushl $209
  10172b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  101730:	e9 28 02 00 00       	jmp    10195d <__alltraps>

00101735 <vector210>:
.globl vector210
vector210:
  pushl $0
  101735:	6a 00                	push   $0x0
  pushl $210
  101737:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10173c:	e9 1c 02 00 00       	jmp    10195d <__alltraps>

00101741 <vector211>:
.globl vector211
vector211:
  pushl $0
  101741:	6a 00                	push   $0x0
  pushl $211
  101743:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  101748:	e9 10 02 00 00       	jmp    10195d <__alltraps>

0010174d <vector212>:
.globl vector212
vector212:
  pushl $0
  10174d:	6a 00                	push   $0x0
  pushl $212
  10174f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  101754:	e9 04 02 00 00       	jmp    10195d <__alltraps>

00101759 <vector213>:
.globl vector213
vector213:
  pushl $0
  101759:	6a 00                	push   $0x0
  pushl $213
  10175b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  101760:	e9 f8 01 00 00       	jmp    10195d <__alltraps>

00101765 <vector214>:
.globl vector214
vector214:
  pushl $0
  101765:	6a 00                	push   $0x0
  pushl $214
  101767:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10176c:	e9 ec 01 00 00       	jmp    10195d <__alltraps>

00101771 <vector215>:
.globl vector215
vector215:
  pushl $0
  101771:	6a 00                	push   $0x0
  pushl $215
  101773:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  101778:	e9 e0 01 00 00       	jmp    10195d <__alltraps>

0010177d <vector216>:
.globl vector216
vector216:
  pushl $0
  10177d:	6a 00                	push   $0x0
  pushl $216
  10177f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  101784:	e9 d4 01 00 00       	jmp    10195d <__alltraps>

00101789 <vector217>:
.globl vector217
vector217:
  pushl $0
  101789:	6a 00                	push   $0x0
  pushl $217
  10178b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  101790:	e9 c8 01 00 00       	jmp    10195d <__alltraps>

00101795 <vector218>:
.globl vector218
vector218:
  pushl $0
  101795:	6a 00                	push   $0x0
  pushl $218
  101797:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10179c:	e9 bc 01 00 00       	jmp    10195d <__alltraps>

001017a1 <vector219>:
.globl vector219
vector219:
  pushl $0
  1017a1:	6a 00                	push   $0x0
  pushl $219
  1017a3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1017a8:	e9 b0 01 00 00       	jmp    10195d <__alltraps>

001017ad <vector220>:
.globl vector220
vector220:
  pushl $0
  1017ad:	6a 00                	push   $0x0
  pushl $220
  1017af:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1017b4:	e9 a4 01 00 00       	jmp    10195d <__alltraps>

001017b9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1017b9:	6a 00                	push   $0x0
  pushl $221
  1017bb:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1017c0:	e9 98 01 00 00       	jmp    10195d <__alltraps>

001017c5 <vector222>:
.globl vector222
vector222:
  pushl $0
  1017c5:	6a 00                	push   $0x0
  pushl $222
  1017c7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1017cc:	e9 8c 01 00 00       	jmp    10195d <__alltraps>

001017d1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1017d1:	6a 00                	push   $0x0
  pushl $223
  1017d3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1017d8:	e9 80 01 00 00       	jmp    10195d <__alltraps>

001017dd <vector224>:
.globl vector224
vector224:
  pushl $0
  1017dd:	6a 00                	push   $0x0
  pushl $224
  1017df:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1017e4:	e9 74 01 00 00       	jmp    10195d <__alltraps>

001017e9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1017e9:	6a 00                	push   $0x0
  pushl $225
  1017eb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1017f0:	e9 68 01 00 00       	jmp    10195d <__alltraps>

001017f5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1017f5:	6a 00                	push   $0x0
  pushl $226
  1017f7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1017fc:	e9 5c 01 00 00       	jmp    10195d <__alltraps>

00101801 <vector227>:
.globl vector227
vector227:
  pushl $0
  101801:	6a 00                	push   $0x0
  pushl $227
  101803:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  101808:	e9 50 01 00 00       	jmp    10195d <__alltraps>

0010180d <vector228>:
.globl vector228
vector228:
  pushl $0
  10180d:	6a 00                	push   $0x0
  pushl $228
  10180f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  101814:	e9 44 01 00 00       	jmp    10195d <__alltraps>

00101819 <vector229>:
.globl vector229
vector229:
  pushl $0
  101819:	6a 00                	push   $0x0
  pushl $229
  10181b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  101820:	e9 38 01 00 00       	jmp    10195d <__alltraps>

00101825 <vector230>:
.globl vector230
vector230:
  pushl $0
  101825:	6a 00                	push   $0x0
  pushl $230
  101827:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10182c:	e9 2c 01 00 00       	jmp    10195d <__alltraps>

00101831 <vector231>:
.globl vector231
vector231:
  pushl $0
  101831:	6a 00                	push   $0x0
  pushl $231
  101833:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  101838:	e9 20 01 00 00       	jmp    10195d <__alltraps>

0010183d <vector232>:
.globl vector232
vector232:
  pushl $0
  10183d:	6a 00                	push   $0x0
  pushl $232
  10183f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  101844:	e9 14 01 00 00       	jmp    10195d <__alltraps>

00101849 <vector233>:
.globl vector233
vector233:
  pushl $0
  101849:	6a 00                	push   $0x0
  pushl $233
  10184b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  101850:	e9 08 01 00 00       	jmp    10195d <__alltraps>

00101855 <vector234>:
.globl vector234
vector234:
  pushl $0
  101855:	6a 00                	push   $0x0
  pushl $234
  101857:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10185c:	e9 fc 00 00 00       	jmp    10195d <__alltraps>

00101861 <vector235>:
.globl vector235
vector235:
  pushl $0
  101861:	6a 00                	push   $0x0
  pushl $235
  101863:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  101868:	e9 f0 00 00 00       	jmp    10195d <__alltraps>

0010186d <vector236>:
.globl vector236
vector236:
  pushl $0
  10186d:	6a 00                	push   $0x0
  pushl $236
  10186f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  101874:	e9 e4 00 00 00       	jmp    10195d <__alltraps>

00101879 <vector237>:
.globl vector237
vector237:
  pushl $0
  101879:	6a 00                	push   $0x0
  pushl $237
  10187b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  101880:	e9 d8 00 00 00       	jmp    10195d <__alltraps>

00101885 <vector238>:
.globl vector238
vector238:
  pushl $0
  101885:	6a 00                	push   $0x0
  pushl $238
  101887:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10188c:	e9 cc 00 00 00       	jmp    10195d <__alltraps>

00101891 <vector239>:
.globl vector239
vector239:
  pushl $0
  101891:	6a 00                	push   $0x0
  pushl $239
  101893:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  101898:	e9 c0 00 00 00       	jmp    10195d <__alltraps>

0010189d <vector240>:
.globl vector240
vector240:
  pushl $0
  10189d:	6a 00                	push   $0x0
  pushl $240
  10189f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1018a4:	e9 b4 00 00 00       	jmp    10195d <__alltraps>

001018a9 <vector241>:
.globl vector241
vector241:
  pushl $0
  1018a9:	6a 00                	push   $0x0
  pushl $241
  1018ab:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1018b0:	e9 a8 00 00 00       	jmp    10195d <__alltraps>

001018b5 <vector242>:
.globl vector242
vector242:
  pushl $0
  1018b5:	6a 00                	push   $0x0
  pushl $242
  1018b7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1018bc:	e9 9c 00 00 00       	jmp    10195d <__alltraps>

001018c1 <vector243>:
.globl vector243
vector243:
  pushl $0
  1018c1:	6a 00                	push   $0x0
  pushl $243
  1018c3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1018c8:	e9 90 00 00 00       	jmp    10195d <__alltraps>

001018cd <vector244>:
.globl vector244
vector244:
  pushl $0
  1018cd:	6a 00                	push   $0x0
  pushl $244
  1018cf:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1018d4:	e9 84 00 00 00       	jmp    10195d <__alltraps>

001018d9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1018d9:	6a 00                	push   $0x0
  pushl $245
  1018db:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1018e0:	e9 78 00 00 00       	jmp    10195d <__alltraps>

001018e5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1018e5:	6a 00                	push   $0x0
  pushl $246
  1018e7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1018ec:	e9 6c 00 00 00       	jmp    10195d <__alltraps>

001018f1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1018f1:	6a 00                	push   $0x0
  pushl $247
  1018f3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1018f8:	e9 60 00 00 00       	jmp    10195d <__alltraps>

001018fd <vector248>:
.globl vector248
vector248:
  pushl $0
  1018fd:	6a 00                	push   $0x0
  pushl $248
  1018ff:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  101904:	e9 54 00 00 00       	jmp    10195d <__alltraps>

00101909 <vector249>:
.globl vector249
vector249:
  pushl $0
  101909:	6a 00                	push   $0x0
  pushl $249
  10190b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  101910:	e9 48 00 00 00       	jmp    10195d <__alltraps>

00101915 <vector250>:
.globl vector250
vector250:
  pushl $0
  101915:	6a 00                	push   $0x0
  pushl $250
  101917:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10191c:	e9 3c 00 00 00       	jmp    10195d <__alltraps>

00101921 <vector251>:
.globl vector251
vector251:
  pushl $0
  101921:	6a 00                	push   $0x0
  pushl $251
  101923:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  101928:	e9 30 00 00 00       	jmp    10195d <__alltraps>

0010192d <vector252>:
.globl vector252
vector252:
  pushl $0
  10192d:	6a 00                	push   $0x0
  pushl $252
  10192f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  101934:	e9 24 00 00 00       	jmp    10195d <__alltraps>

00101939 <vector253>:
.globl vector253
vector253:
  pushl $0
  101939:	6a 00                	push   $0x0
  pushl $253
  10193b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  101940:	e9 18 00 00 00       	jmp    10195d <__alltraps>

00101945 <vector254>:
.globl vector254
vector254:
  pushl $0
  101945:	6a 00                	push   $0x0
  pushl $254
  101947:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10194c:	e9 0c 00 00 00       	jmp    10195d <__alltraps>

00101951 <vector255>:
.globl vector255
vector255:
  pushl $0
  101951:	6a 00                	push   $0x0
  pushl $255
  101953:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  101958:	e9 00 00 00 00       	jmp    10195d <__alltraps>

0010195d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10195d:	1e                   	push   %ds
    pushl %es
  10195e:	06                   	push   %es
    pushal
  10195f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101960:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101965:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101967:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101969:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10196a:	e8 67 f5 ff ff       	call   100ed6 <trap>

    # pop the pushed stack pointer
    popl %esp
  10196f:	5c                   	pop    %esp

00101970 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101970:	61                   	popa   

    # restore %ds and %es
    popl %es
  101971:	07                   	pop    %es
    popl %ds
  101972:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101973:	83 c4 08             	add    $0x8,%esp
    iret
  101976:	cf                   	iret   

00101977 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  101977:	55                   	push   %ebp
  101978:	89 e5                	mov    %esp,%ebp
  10197a:	83 ec 10             	sub    $0x10,%esp
	size_t cnt = 0;
  10197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (*s ++ != '\0') {
  101984:	eb 04                	jmp    10198a <strlen+0x13>
		cnt++;
  101986:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
	size_t cnt = 0;
	while (*s ++ != '\0') {
  10198a:	8b 45 08             	mov    0x8(%ebp),%eax
  10198d:	8d 50 01             	lea    0x1(%eax),%edx
  101990:	89 55 08             	mov    %edx,0x8(%ebp)
  101993:	0f b6 00             	movzbl (%eax),%eax
  101996:	84 c0                	test   %al,%al
  101998:	75 ec                	jne    101986 <strlen+0xf>
		cnt++;
	}
	return cnt;
  10199a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10199d:	c9                   	leave  
  10199e:	c3                   	ret    

0010199f <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  10199f:	55                   	push   %ebp
  1019a0:	89 e5                	mov    %esp,%ebp
  1019a2:	83 ec 14             	sub    $0x14,%esp
  1019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1019a8:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  1019b1:	eb 0f                	jmp    1019c2 <memset+0x23>
		*p ++ = c;
  1019b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b6:	8d 50 01             	lea    0x1(%eax),%edx
  1019b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  1019bc:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  1019c0:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  1019c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1019c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1019c8:	89 55 10             	mov    %edx,0x10(%ebp)
  1019cb:	85 c0                	test   %eax,%eax
  1019cd:	75 e4                	jne    1019b3 <memset+0x14>
		*p ++ = c;
	}
	return s;
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1019d2:	c9                   	leave  
  1019d3:	c3                   	ret    

001019d4 <memmove>:
/*
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
  1019d4:	55                   	push   %ebp
  1019d5:	89 e5                	mov    %esp,%ebp
  1019d7:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  1019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1019dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  1019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1019ec:	73 54                	jae    101a42 <memmove+0x6e>
  1019ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1019f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1019f4:	01 d0                	add    %edx,%eax
  1019f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1019f9:	76 47                	jbe    101a42 <memmove+0x6e>
        s += n, d += n;
  1019fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1019fe:	01 45 fc             	add    %eax,-0x4(%ebp)
  101a01:	8b 45 10             	mov    0x10(%ebp),%eax
  101a04:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  101a07:	eb 13                	jmp    101a1c <memmove+0x48>
            *-- d = *-- s;
  101a09:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  101a0d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  101a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a14:	0f b6 10             	movzbl (%eax),%edx
  101a17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a1a:	88 10                	mov    %dl,(%eax)
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  101a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  101a1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  101a22:	89 55 10             	mov    %edx,0x10(%ebp)
  101a25:	85 c0                	test   %eax,%eax
  101a27:	75 e0                	jne    101a09 <memmove+0x35>
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  101a29:	eb 24                	jmp    101a4f <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  101a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a2e:	8d 50 01             	lea    0x1(%eax),%edx
  101a31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  101a34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101a37:	8d 4a 01             	lea    0x1(%edx),%ecx
  101a3a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  101a3d:	0f b6 12             	movzbl (%edx),%edx
  101a40:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  101a42:	8b 45 10             	mov    0x10(%ebp),%eax
  101a45:	8d 50 ff             	lea    -0x1(%eax),%edx
  101a48:	89 55 10             	mov    %edx,0x10(%ebp)
  101a4b:	85 c0                	test   %eax,%eax
  101a4d:	75 dc                	jne    101a2b <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  101a52:	c9                   	leave  
  101a53:	c3                   	ret    

00101a54 <test_memset>:
#include <string.h>

/*
 * void *memset(void *s, char c, size_t n);
 * */
int test_memset() {
  101a54:	55                   	push   %ebp
  101a55:	89 e5                	mov    %esp,%ebp
  101a57:	83 ec 18             	sub    $0x18,%esp
	char *p = "abcdefg";
  101a5a:	c7 45 f4 4a 1b 10 00 	movl   $0x101b4a,-0xc(%ebp)
	char *s = memset(p, 'c', 3);
  101a61:	83 ec 04             	sub    $0x4,%esp
  101a64:	6a 03                	push   $0x3
  101a66:	6a 63                	push   $0x63
  101a68:	ff 75 f4             	pushl  -0xc(%ebp)
  101a6b:	e8 2f ff ff ff       	call   10199f <memset>
  101a70:	83 c4 10             	add    $0x10,%esp
  101a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return 0;
  101a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101a7b:	c9                   	leave  
  101a7c:	c3                   	ret    

00101a7d <testmain>:


int testmain() {
  101a7d:	55                   	push   %ebp
  101a7e:	89 e5                	mov    %esp,%ebp
  101a80:	83 ec 08             	sub    $0x8,%esp

	test_memset();
  101a83:	e8 cc ff ff ff       	call   101a54 <test_memset>
	return 0;
  101a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101a8d:	c9                   	leave  
  101a8e:	c3                   	ret    
