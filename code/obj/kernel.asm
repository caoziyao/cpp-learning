
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
	 cons_init();                // init the console
  100006:	e8 84 05 00 00       	call   10058f <cons_init>
}
  10000b:	90                   	nop
  10000c:	c9                   	leave  
  10000d:	c3                   	ret    

0010000e <unite_test>:

void unite_test() {
  10000e:	55                   	push   %ebp
  10000f:	89 e5                	mov    %esp,%ebp
  100011:	83 ec 08             	sub    $0x8,%esp
	testmain();
  100014:	e8 bc 06 00 00       	call   1006d5 <testmain>
}
  100019:	90                   	nop
  10001a:	c9                   	leave  
  10001b:	c3                   	ret    

0010001c <kern_init>:

int
kern_init(void) {
  10001c:	55                   	push   %ebp
  10001d:	89 e5                	mov    %esp,%ebp
  10001f:	83 ec 18             	sub    $0x18,%esp
	init_driver();
  100022:	e8 d9 ff ff ff       	call   100000 <init_driver>
	unite_test();
  100027:	e8 e2 ff ff ff       	call   10000e <unite_test>
	int a = 1;
  10002c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	a = a + 3;
  100033:	83 45 f4 03          	addl   $0x3,-0xc(%ebp)
	char *s = "ddss";
  100037:	c7 45 f0 e7 06 10 00 	movl   $0x1006e7,-0x10(%ebp)
	int l = strlen(s);
  10003e:	83 ec 0c             	sub    $0xc,%esp
  100041:	ff 75 f0             	pushl  -0x10(%ebp)
  100044:	e8 86 05 00 00       	call   1005cf <strlen>
  100049:	83 c4 10             	add    $0x10,%esp
  10004c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	const char *msg = "hello lmo-os";
  10004f:	c7 45 e8 ec 06 10 00 	movl   $0x1006ec,-0x18(%ebp)
	cprintf(msg);
  100056:	83 ec 0c             	sub    $0xc,%esp
  100059:	ff 75 e8             	pushl  -0x18(%ebp)
  10005c:	e8 6a 00 00 00       	call   1000cb <cprintf>
  100061:	83 c4 10             	add    $0x10,%esp

     while (1);
  100064:	eb fe                	jmp    100064 <kern_init+0x48>

00100066 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100066:	55                   	push   %ebp
  100067:	89 e5                	mov    %esp,%ebp
  100069:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  10006c:	83 ec 0c             	sub    $0xc,%esp
  10006f:	ff 75 08             	pushl  0x8(%ebp)
  100072:	e8 28 05 00 00       	call   10059f <cons_putc>
  100077:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10007a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10007d:	8b 00                	mov    (%eax),%eax
  10007f:	8d 50 01             	lea    0x1(%eax),%edx
  100082:	8b 45 0c             	mov    0xc(%ebp),%eax
  100085:	89 10                	mov    %edx,(%eax)
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <vcprintf>:
/*
 * todo
 * 格式化输出
 * */
int
vcprintf(const char *msg) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
  100090:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
  100097:	8b 45 08             	mov    0x8(%ebp),%eax
  10009a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while (*s != '\0') {
  10009d:	eb 1d                	jmp    1000bc <vcprintf+0x32>
		cputch(*s, &cnt);
  10009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000a2:	0f b6 00             	movzbl (%eax),%eax
  1000a5:	0f be c0             	movsbl %al,%eax
  1000a8:	83 ec 08             	sub    $0x8,%esp
  1000ab:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1000ae:	52                   	push   %edx
  1000af:	50                   	push   %eax
  1000b0:	e8 b1 ff ff ff       	call   100066 <cputch>
  1000b5:	83 c4 10             	add    $0x10,%esp
		s++;
  1000b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
vcprintf(const char *msg) {
	int cnt = 0;
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
	while (*s != '\0') {
  1000bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000bf:	0f b6 00             	movzbl (%eax),%eax
  1000c2:	84 c0                	test   %al,%al
  1000c4:	75 d9                	jne    10009f <vcprintf+0x15>
		cputch(*s, &cnt);
		s++;
	}
	return cnt;
  1000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1000c9:	c9                   	leave  
  1000ca:	c3                   	ret    

001000cb <cprintf>:
/*
 * cprintf - formats a string and writes it to stdout
 * todo
 * */
int
cprintf(const char *msg) {
  1000cb:	55                   	push   %ebp
  1000cc:	89 e5                	mov    %esp,%ebp
  1000ce:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	cnt = vcprintf(msg);
  1000d1:	83 ec 0c             	sub    $0xc,%esp
  1000d4:	ff 75 08             	pushl  0x8(%ebp)
  1000d7:	e8 ae ff ff ff       	call   10008a <vcprintf>
  1000dc:	83 c4 10             	add    $0x10,%esp
  1000df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return cnt;
  1000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1000e5:	c9                   	leave  
  1000e6:	c3                   	ret    

001000e7 <delay>:
// #include <stdio.h>
 #include <string.h>

 /* stupid I/O delay routine necessitated by historical PC design flaws */
 static void
 delay(void) {
  1000e7:	55                   	push   %ebp
  1000e8:	89 e5                	mov    %esp,%ebp
  1000ea:	83 ec 10             	sub    $0x10,%esp
  1000ed:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1000f3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1000f7:	89 c2                	mov    %eax,%edx
  1000f9:	ec                   	in     (%dx),%al
  1000fa:	88 45 f4             	mov    %al,-0xc(%ebp)
  1000fd:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100103:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100107:	89 c2                	mov    %eax,%edx
  100109:	ec                   	in     (%dx),%al
  10010a:	88 45 f5             	mov    %al,-0xb(%ebp)
  10010d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100113:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100117:	89 c2                	mov    %eax,%edx
  100119:	ec                   	in     (%dx),%al
  10011a:	88 45 f6             	mov    %al,-0xa(%ebp)
  10011d:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100123:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100127:	89 c2                	mov    %eax,%edx
  100129:	ec                   	in     (%dx),%al
  10012a:	88 45 f7             	mov    %al,-0x9(%ebp)
     inb(0x84);
     inb(0x84);
     inb(0x84);
     inb(0x84);
 }
  10012d:	90                   	nop
  10012e:	c9                   	leave  
  10012f:	c3                   	ret    

00100130 <cga_init>:
 static uint16_t addr_6845;

 /* TEXT-mode CGA/VGA display output */

 static void
 cga_init(void) {
  100130:	55                   	push   %ebp
  100131:	89 e5                	mov    %esp,%ebp
  100133:	83 ec 20             	sub    $0x20,%esp
     volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100136:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
     uint16_t was = *cp;
  10013d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100140:	0f b7 00             	movzwl (%eax),%eax
  100143:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
     *cp = (uint16_t) 0xA55A;
  100147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10014a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
     if (*cp != 0xA55A) {
  10014f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100152:	0f b7 00             	movzwl (%eax),%eax
  100155:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100159:	74 12                	je     10016d <cga_init+0x3d>
         cp = (uint16_t*)MONO_BUF;
  10015b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
         addr_6845 = MONO_BASE;
  100162:	66 c7 05 82 19 10 00 	movw   $0x3b4,0x101982
  100169:	b4 03 
  10016b:	eb 13                	jmp    100180 <cga_init+0x50>
     } else {
         *cp = was;
  10016d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100170:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100174:	66 89 10             	mov    %dx,(%eax)
         addr_6845 = CGA_BASE;
  100177:	66 c7 05 82 19 10 00 	movw   $0x3d4,0x101982
  10017e:	d4 03 
     }

     // Extract cursor location
     uint32_t pos;
     outb(addr_6845, 14);
  100180:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  100187:	0f b7 c0             	movzwl %ax,%eax
  10018a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  10018e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100192:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100196:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10019a:	ee                   	out    %al,(%dx)
     pos = inb(addr_6845 + 1) << 8;
  10019b:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  1001a2:	83 c0 01             	add    $0x1,%eax
  1001a5:	0f b7 c0             	movzwl %ax,%eax
  1001a8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1001ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b0:	89 c2                	mov    %eax,%edx
  1001b2:	ec                   	in     (%dx),%al
  1001b3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1001b6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1001ba:	0f b6 c0             	movzbl %al,%eax
  1001bd:	c1 e0 08             	shl    $0x8,%eax
  1001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     outb(addr_6845, 15);
  1001c3:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  1001ca:	0f b7 c0             	movzwl %ax,%eax
  1001cd:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  1001d1:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1001d5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  1001d9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1001dd:	ee                   	out    %al,(%dx)
     pos |= inb(addr_6845 + 1);
  1001de:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  1001e5:	83 c0 01             	add    $0x1,%eax
  1001e8:	0f b7 c0             	movzwl %ax,%eax
  1001eb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1001ef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1001f3:	89 c2                	mov    %eax,%edx
  1001f5:	ec                   	in     (%dx),%al
  1001f6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1001f9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1001fd:	0f b6 c0             	movzbl %al,%eax
  100200:	09 45 f4             	or     %eax,-0xc(%ebp)

     crt_buf = (uint16_t*) cp;
  100203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100206:	a3 7c 19 10 00       	mov    %eax,0x10197c
     crt_pos = pos;
  10020b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10020e:	66 a3 80 19 10 00    	mov    %ax,0x101980
 }
  100214:	90                   	nop
  100215:	c9                   	leave  
  100216:	c3                   	ret    

00100217 <serial_init>:

 static bool serial_exists = 0;

 static void
 serial_init(void) {
  100217:	55                   	push   %ebp
  100218:	89 e5                	mov    %esp,%ebp
  10021a:	83 ec 20             	sub    $0x20,%esp
  10021d:	66 c7 45 fe fa 03    	movw   $0x3fa,-0x2(%ebp)
  100223:	c6 45 e2 00          	movb   $0x0,-0x1e(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100227:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10022b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10022f:	ee                   	out    %al,(%dx)
  100230:	66 c7 45 fc fb 03    	movw   $0x3fb,-0x4(%ebp)
  100236:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
  10023a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10023e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100242:	ee                   	out    %al,(%dx)
  100243:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100249:	c6 45 e4 0c          	movb   $0xc,-0x1c(%ebp)
  10024d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  100251:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100255:	ee                   	out    %al,(%dx)
  100256:	66 c7 45 f8 f9 03    	movw   $0x3f9,-0x8(%ebp)
  10025c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100260:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100264:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100268:	ee                   	out    %al,(%dx)
  100269:	66 c7 45 f6 fb 03    	movw   $0x3fb,-0xa(%ebp)
  10026f:	c6 45 e6 03          	movb   $0x3,-0x1a(%ebp)
  100273:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  100277:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10027b:	ee                   	out    %al,(%dx)
  10027c:	66 c7 45 f4 fc 03    	movw   $0x3fc,-0xc(%ebp)
  100282:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  100286:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10028a:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10028e:	ee                   	out    %al,(%dx)
  10028f:	66 c7 45 f2 f9 03    	movw   $0x3f9,-0xe(%ebp)
  100295:	c6 45 e8 01          	movb   $0x1,-0x18(%ebp)
  100299:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10029d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1002a1:	ee                   	out    %al,(%dx)
  1002a2:	66 c7 45 f0 fd 03    	movw   $0x3fd,-0x10(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1002a8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1002ac:	89 c2                	mov    %eax,%edx
  1002ae:	ec                   	in     (%dx),%al
  1002af:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  1002b2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
     // Enable rcv interrupts
     outb(COM1 + COM_IER, COM_IER_RDI);

     // Clear any preexisting overrun indications and interrupts
     // Serial port doesn't exist if COM_LSR returns 0xFF
     serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1002b6:	3c ff                	cmp    $0xff,%al
  1002b8:	0f 95 c0             	setne  %al
  1002bb:	0f b6 c0             	movzbl %al,%eax
  1002be:	a3 84 19 10 00       	mov    %eax,0x101984
  1002c3:	66 c7 45 ee fa 03    	movw   $0x3fa,-0x12(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1002c9:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1002cd:	89 c2                	mov    %eax,%edx
  1002cf:	ec                   	in     (%dx),%al
  1002d0:	88 45 ea             	mov    %al,-0x16(%ebp)
  1002d3:	66 c7 45 ec f8 03    	movw   $0x3f8,-0x14(%ebp)
  1002d9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1002dd:	89 c2                	mov    %eax,%edx
  1002df:	ec                   	in     (%dx),%al
  1002e0:	88 45 eb             	mov    %al,-0x15(%ebp)

     (void) inb(COM1+COM_IIR);
     (void) inb(COM1+COM_RX);
 }
  1002e3:	90                   	nop
  1002e4:	c9                   	leave  
  1002e5:	c3                   	ret    

001002e6 <lpt_putc>:

 /* lpt_putc - copy console output to parallel port */
 static void
 lpt_putc(int c) {
  1002e6:	55                   	push   %ebp
  1002e7:	89 e5                	mov    %esp,%ebp
  1002e9:	83 ec 10             	sub    $0x10,%esp
     int i;
     for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1002ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1002f3:	eb 09                	jmp    1002fe <lpt_putc+0x18>
         delay();
  1002f5:	e8 ed fd ff ff       	call   1000e7 <delay>

 /* lpt_putc - copy console output to parallel port */
 static void
 lpt_putc(int c) {
     int i;
     for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1002fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1002fe:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100304:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100308:	89 c2                	mov    %eax,%edx
  10030a:	ec                   	in     (%dx),%al
  10030b:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10030e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100312:	84 c0                	test   %al,%al
  100314:	78 09                	js     10031f <lpt_putc+0x39>
  100316:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10031d:	7e d6                	jle    1002f5 <lpt_putc+0xf>
         delay();
     }
     outb(LPTPORT + 0, c);
  10031f:	8b 45 08             	mov    0x8(%ebp),%eax
  100322:	0f b6 c0             	movzbl %al,%eax
  100325:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  10032b:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10032e:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100332:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100336:	ee                   	out    %al,(%dx)
  100337:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10033d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100341:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100345:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100349:	ee                   	out    %al,(%dx)
  10034a:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100350:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  100354:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100358:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10035c:	ee                   	out    %al,(%dx)
     outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
     outb(LPTPORT + 2, 0x08);
 }
  10035d:	90                   	nop
  10035e:	c9                   	leave  
  10035f:	c3                   	ret    

00100360 <cga_putc>:

 /* cga_putc - print character to console */
 static void
 cga_putc(int c) {
  100360:	55                   	push   %ebp
  100361:	89 e5                	mov    %esp,%ebp
  100363:	53                   	push   %ebx
  100364:	83 ec 14             	sub    $0x14,%esp
     // set black on white
     if (!(c & ~0xFF)) {
  100367:	8b 45 08             	mov    0x8(%ebp),%eax
  10036a:	b0 00                	mov    $0x0,%al
  10036c:	85 c0                	test   %eax,%eax
  10036e:	75 07                	jne    100377 <cga_putc+0x17>
         c |= 0x0700;
  100370:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
     }

     switch (c & 0xff) {
  100377:	8b 45 08             	mov    0x8(%ebp),%eax
  10037a:	0f b6 c0             	movzbl %al,%eax
  10037d:	83 f8 0a             	cmp    $0xa,%eax
  100380:	74 4e                	je     1003d0 <cga_putc+0x70>
  100382:	83 f8 0d             	cmp    $0xd,%eax
  100385:	74 59                	je     1003e0 <cga_putc+0x80>
  100387:	83 f8 08             	cmp    $0x8,%eax
  10038a:	0f 85 8a 00 00 00    	jne    10041a <cga_putc+0xba>
     case '\b':
         if (crt_pos > 0) {
  100390:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  100397:	66 85 c0             	test   %ax,%ax
  10039a:	0f 84 a0 00 00 00    	je     100440 <cga_putc+0xe0>
             crt_pos --;
  1003a0:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  1003a7:	83 e8 01             	sub    $0x1,%eax
  1003aa:	66 a3 80 19 10 00    	mov    %ax,0x101980
             crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1003b0:	a1 7c 19 10 00       	mov    0x10197c,%eax
  1003b5:	0f b7 15 80 19 10 00 	movzwl 0x101980,%edx
  1003bc:	0f b7 d2             	movzwl %dx,%edx
  1003bf:	01 d2                	add    %edx,%edx
  1003c1:	01 d0                	add    %edx,%eax
  1003c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1003c6:	b2 00                	mov    $0x0,%dl
  1003c8:	83 ca 20             	or     $0x20,%edx
  1003cb:	66 89 10             	mov    %dx,(%eax)
         }
         break;
  1003ce:	eb 70                	jmp    100440 <cga_putc+0xe0>
     case '\n':
         crt_pos += CRT_COLS;
  1003d0:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  1003d7:	83 c0 50             	add    $0x50,%eax
  1003da:	66 a3 80 19 10 00    	mov    %ax,0x101980
     case '\r':
         crt_pos -= (crt_pos % CRT_COLS);
  1003e0:	0f b7 1d 80 19 10 00 	movzwl 0x101980,%ebx
  1003e7:	0f b7 0d 80 19 10 00 	movzwl 0x101980,%ecx
  1003ee:	0f b7 c1             	movzwl %cx,%eax
  1003f1:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1003f7:	c1 e8 10             	shr    $0x10,%eax
  1003fa:	89 c2                	mov    %eax,%edx
  1003fc:	66 c1 ea 06          	shr    $0x6,%dx
  100400:	89 d0                	mov    %edx,%eax
  100402:	c1 e0 02             	shl    $0x2,%eax
  100405:	01 d0                	add    %edx,%eax
  100407:	c1 e0 04             	shl    $0x4,%eax
  10040a:	29 c1                	sub    %eax,%ecx
  10040c:	89 ca                	mov    %ecx,%edx
  10040e:	89 d8                	mov    %ebx,%eax
  100410:	29 d0                	sub    %edx,%eax
  100412:	66 a3 80 19 10 00    	mov    %ax,0x101980
         break;
  100418:	eb 27                	jmp    100441 <cga_putc+0xe1>
     default:
         crt_buf[crt_pos ++] = c;     // write the character
  10041a:	8b 0d 7c 19 10 00    	mov    0x10197c,%ecx
  100420:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  100427:	8d 50 01             	lea    0x1(%eax),%edx
  10042a:	66 89 15 80 19 10 00 	mov    %dx,0x101980
  100431:	0f b7 c0             	movzwl %ax,%eax
  100434:	01 c0                	add    %eax,%eax
  100436:	01 c8                	add    %ecx,%eax
  100438:	8b 55 08             	mov    0x8(%ebp),%edx
  10043b:	66 89 10             	mov    %dx,(%eax)
         break;
  10043e:	eb 01                	jmp    100441 <cga_putc+0xe1>
     case '\b':
         if (crt_pos > 0) {
             crt_pos --;
             crt_buf[crt_pos] = (c & ~0xff) | ' ';
         }
         break;
  100440:	90                   	nop
         crt_buf[crt_pos ++] = c;     // write the character
         break;
     }

     // What is the purpose of this?
     if (crt_pos >= CRT_SIZE) {
  100441:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  100448:	66 3d cf 07          	cmp    $0x7cf,%ax
  10044c:	76 59                	jbe    1004a7 <cga_putc+0x147>
         int i;
         memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10044e:	a1 7c 19 10 00       	mov    0x10197c,%eax
  100453:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100459:	a1 7c 19 10 00       	mov    0x10197c,%eax
  10045e:	83 ec 04             	sub    $0x4,%esp
  100461:	68 00 0f 00 00       	push   $0xf00
  100466:	52                   	push   %edx
  100467:	50                   	push   %eax
  100468:	e8 bf 01 00 00       	call   10062c <memmove>
  10046d:	83 c4 10             	add    $0x10,%esp
         for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  100470:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  100477:	eb 15                	jmp    10048e <cga_putc+0x12e>
             crt_buf[i] = 0x0700 | ' ';
  100479:	a1 7c 19 10 00       	mov    0x10197c,%eax
  10047e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100481:	01 d2                	add    %edx,%edx
  100483:	01 d0                	add    %edx,%eax
  100485:	66 c7 00 20 07       	movw   $0x720,(%eax)

     // What is the purpose of this?
     if (crt_pos >= CRT_SIZE) {
         int i;
         memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
         for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10048a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10048e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  100495:	7e e2                	jle    100479 <cga_putc+0x119>
             crt_buf[i] = 0x0700 | ' ';
         }
         crt_pos -= CRT_COLS;
  100497:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  10049e:	83 e8 50             	sub    $0x50,%eax
  1004a1:	66 a3 80 19 10 00    	mov    %ax,0x101980
     }

     // move that little blinky thing
     outb(addr_6845, 14);
  1004a7:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  1004ae:	0f b7 c0             	movzwl %ax,%eax
  1004b1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1004b5:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1004b9:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1004bd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1004c1:	ee                   	out    %al,(%dx)
     outb(addr_6845 + 1, crt_pos >> 8);
  1004c2:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  1004c9:	66 c1 e8 08          	shr    $0x8,%ax
  1004cd:	0f b6 c0             	movzbl %al,%eax
  1004d0:	0f b7 15 82 19 10 00 	movzwl 0x101982,%edx
  1004d7:	83 c2 01             	add    $0x1,%edx
  1004da:	0f b7 d2             	movzwl %dx,%edx
  1004dd:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1004e1:	88 45 e9             	mov    %al,-0x17(%ebp)
  1004e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1004e8:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1004ec:	ee                   	out    %al,(%dx)
     outb(addr_6845, 15);
  1004ed:	0f b7 05 82 19 10 00 	movzwl 0x101982,%eax
  1004f4:	0f b7 c0             	movzwl %ax,%eax
  1004f7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1004fb:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1004ff:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100503:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100507:	ee                   	out    %al,(%dx)
     outb(addr_6845 + 1, crt_pos);
  100508:	0f b7 05 80 19 10 00 	movzwl 0x101980,%eax
  10050f:	0f b6 c0             	movzbl %al,%eax
  100512:	0f b7 15 82 19 10 00 	movzwl 0x101982,%edx
  100519:	83 c2 01             	add    $0x1,%edx
  10051c:	0f b7 d2             	movzwl %dx,%edx
  10051f:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  100523:	88 45 eb             	mov    %al,-0x15(%ebp)
  100526:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10052a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10052e:	ee                   	out    %al,(%dx)
 }
  10052f:	90                   	nop
  100530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100533:	c9                   	leave  
  100534:	c3                   	ret    

00100535 <serial_putc>:

 /* serial_putc - print character to serial port */
 static void
 serial_putc(int c) {
  100535:	55                   	push   %ebp
  100536:	89 e5                	mov    %esp,%ebp
  100538:	83 ec 10             	sub    $0x10,%esp
     int i;
     for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10053b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100542:	eb 09                	jmp    10054d <serial_putc+0x18>
         delay();
  100544:	e8 9e fb ff ff       	call   1000e7 <delay>

 /* serial_putc - print character to serial port */
 static void
 serial_putc(int c) {
     int i;
     for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  100549:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10054d:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100553:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100557:	89 c2                	mov    %eax,%edx
  100559:	ec                   	in     (%dx),%al
  10055a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10055d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100561:	0f b6 c0             	movzbl %al,%eax
  100564:	83 e0 20             	and    $0x20,%eax
  100567:	85 c0                	test   %eax,%eax
  100569:	75 09                	jne    100574 <serial_putc+0x3f>
  10056b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100572:	7e d0                	jle    100544 <serial_putc+0xf>
         delay();
     }
     outb(COM1 + COM_TX, c);
  100574:	8b 45 08             	mov    0x8(%ebp),%eax
  100577:	0f b6 c0             	movzbl %al,%eax
  10057a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  100580:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100583:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  100587:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10058b:	ee                   	out    %al,(%dx)
 }
  10058c:	90                   	nop
  10058d:	c9                   	leave  
  10058e:	c3                   	ret    

0010058f <cons_init>:

 /* cons_init - initializes the console devices */
 void
 cons_init(void) {
  10058f:	55                   	push   %ebp
  100590:	89 e5                	mov    %esp,%ebp
     cga_init();
  100592:	e8 99 fb ff ff       	call   100130 <cga_init>
     serial_init();
  100597:	e8 7b fc ff ff       	call   100217 <serial_init>
     if (!serial_exists) {
//         cprintf("serial port does not exist!!\n");
     }
 }
  10059c:	90                   	nop
  10059d:	5d                   	pop    %ebp
  10059e:	c3                   	ret    

0010059f <cons_putc>:

 /* cons_putc - print a single character @c to console devices */
 void
 cons_putc(int c) {
  10059f:	55                   	push   %ebp
  1005a0:	89 e5                	mov    %esp,%ebp
  1005a2:	83 ec 08             	sub    $0x8,%esp
     lpt_putc(c);
  1005a5:	ff 75 08             	pushl  0x8(%ebp)
  1005a8:	e8 39 fd ff ff       	call   1002e6 <lpt_putc>
  1005ad:	83 c4 04             	add    $0x4,%esp
     cga_putc(c);
  1005b0:	83 ec 0c             	sub    $0xc,%esp
  1005b3:	ff 75 08             	pushl  0x8(%ebp)
  1005b6:	e8 a5 fd ff ff       	call   100360 <cga_putc>
  1005bb:	83 c4 10             	add    $0x10,%esp
     serial_putc(c);
  1005be:	83 ec 0c             	sub    $0xc,%esp
  1005c1:	ff 75 08             	pushl  0x8(%ebp)
  1005c4:	e8 6c ff ff ff       	call   100535 <serial_putc>
  1005c9:	83 c4 10             	add    $0x10,%esp
 }
  1005cc:	90                   	nop
  1005cd:	c9                   	leave  
  1005ce:	c3                   	ret    

001005cf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1005cf:	55                   	push   %ebp
  1005d0:	89 e5                	mov    %esp,%ebp
  1005d2:	83 ec 10             	sub    $0x10,%esp
	size_t cnt = 0;
  1005d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (*s ++ != '\0') {
  1005dc:	eb 04                	jmp    1005e2 <strlen+0x13>
		cnt++;
  1005de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
	size_t cnt = 0;
	while (*s ++ != '\0') {
  1005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e5:	8d 50 01             	lea    0x1(%eax),%edx
  1005e8:	89 55 08             	mov    %edx,0x8(%ebp)
  1005eb:	0f b6 00             	movzbl (%eax),%eax
  1005ee:	84 c0                	test   %al,%al
  1005f0:	75 ec                	jne    1005de <strlen+0xf>
		cnt++;
	}
	return cnt;
  1005f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1005f5:	c9                   	leave  
  1005f6:	c3                   	ret    

001005f7 <memset>:
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
  1005f7:	55                   	push   %ebp
  1005f8:	89 e5                	mov    %esp,%ebp
  1005fa:	83 ec 14             	sub    $0x14,%esp
  1005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100600:	88 45 ec             	mov    %al,-0x14(%ebp)
	char *p = s;
  100603:	8b 45 08             	mov    0x8(%ebp),%eax
  100606:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(n-- > 0) {
  100609:	eb 0f                	jmp    10061a <memset+0x23>
		*p ++ = c;
  10060b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10060e:	8d 50 01             	lea    0x1(%eax),%edx
  100611:	89 55 fc             	mov    %edx,-0x4(%ebp)
  100614:	0f b6 55 ec          	movzbl -0x14(%ebp),%edx
  100618:	88 10                	mov    %dl,(%eax)
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
  10061a:	8b 45 10             	mov    0x10(%ebp),%eax
  10061d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100620:	89 55 10             	mov    %edx,0x10(%ebp)
  100623:	85 c0                	test   %eax,%eax
  100625:	75 e4                	jne    10060b <memset+0x14>
		*p ++ = c;
	}
	return s;
  100627:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10062a:	c9                   	leave  
  10062b:	c3                   	ret    

0010062c <memmove>:
/*
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
  10062c:	55                   	push   %ebp
  10062d:	89 e5                	mov    %esp,%ebp
  10062f:	83 ec 10             	sub    $0x10,%esp
    const char *s = src;
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	89 45 fc             	mov    %eax,-0x4(%ebp)
    char *d = dst;
  100638:	8b 45 08             	mov    0x8(%ebp),%eax
  10063b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (s < d && s + n > d) {
  10063e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100641:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100644:	73 54                	jae    10069a <memmove+0x6e>
  100646:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100649:	8b 45 10             	mov    0x10(%ebp),%eax
  10064c:	01 d0                	add    %edx,%eax
  10064e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100651:	76 47                	jbe    10069a <memmove+0x6e>
        s += n, d += n;
  100653:	8b 45 10             	mov    0x10(%ebp),%eax
  100656:	01 45 fc             	add    %eax,-0x4(%ebp)
  100659:	8b 45 10             	mov    0x10(%ebp),%eax
  10065c:	01 45 f8             	add    %eax,-0x8(%ebp)
        while (n -- > 0) {
  10065f:	eb 13                	jmp    100674 <memmove+0x48>
            *-- d = *-- s;
  100661:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100665:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100669:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10066c:	0f b6 10             	movzbl (%eax),%edx
  10066f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100672:	88 10                	mov    %dl,(%eax)
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  100674:	8b 45 10             	mov    0x10(%ebp),%eax
  100677:	8d 50 ff             	lea    -0x1(%eax),%edx
  10067a:	89 55 10             	mov    %edx,0x10(%ebp)
  10067d:	85 c0                	test   %eax,%eax
  10067f:	75 e0                	jne    100661 <memmove+0x35>
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  100681:	eb 24                	jmp    1006a7 <memmove+0x7b>
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
  100683:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100686:	8d 50 01             	lea    0x1(%eax),%edx
  100689:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10068c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10068f:	8d 4a 01             	lea    0x1(%edx),%ecx
  100692:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  100695:	0f b6 12             	movzbl (%edx),%edx
  100698:	88 10                	mov    %dl,(%eax)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  10069a:	8b 45 10             	mov    0x10(%ebp),%eax
  10069d:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006a0:	89 55 10             	mov    %edx,0x10(%ebp)
  1006a3:	85 c0                	test   %eax,%eax
  1006a5:	75 dc                	jne    100683 <memmove+0x57>
            *d ++ = *s ++;
        }
    }
    return dst;
  1006a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1006aa:	c9                   	leave  
  1006ab:	c3                   	ret    

001006ac <test_memset>:
#include <string.h>

/*
 * void *memset(void *s, char c, size_t n);
 * */
int test_memset() {
  1006ac:	55                   	push   %ebp
  1006ad:	89 e5                	mov    %esp,%ebp
  1006af:	83 ec 18             	sub    $0x18,%esp
	char *p = "abcdefg";
  1006b2:	c7 45 f4 f9 06 10 00 	movl   $0x1006f9,-0xc(%ebp)
	char *s = memset(p, 'c', 3);
  1006b9:	83 ec 04             	sub    $0x4,%esp
  1006bc:	6a 03                	push   $0x3
  1006be:	6a 63                	push   $0x63
  1006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c3:	e8 2f ff ff ff       	call   1005f7 <memset>
  1006c8:	83 c4 10             	add    $0x10,%esp
  1006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return 0;
  1006ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1006d3:	c9                   	leave  
  1006d4:	c3                   	ret    

001006d5 <testmain>:


int testmain() {
  1006d5:	55                   	push   %ebp
  1006d6:	89 e5                	mov    %esp,%ebp
  1006d8:	83 ec 08             	sub    $0x8,%esp

	test_memset();
  1006db:	e8 cc ff ff ff       	call   1006ac <test_memset>
	return 0;
  1006e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1006e5:	c9                   	leave  
  1006e6:	c3                   	ret    
