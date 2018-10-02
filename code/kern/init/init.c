#include <types.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>

// qemu-system-i386 -hda bin/ucore.img -S -s
// x86_64-linux-gnu-gdb bin/kernel
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));


void init_driver() {
	cons_init();                // init the console, 对串口、键盘和时钟外设的中断初始化
	pic_init();                 // init interrupt controller, 中断控制器的初始化工作
	idt_init();                 // init interrupt descriptor table, 对整个中断门描述符表的创建

	sti();                      // enable irq interrupt
}


void unite_test() {
	testmain();
}


int
kern_init(void) {
	init_driver();
	unite_test();
	int a = 1;
	a = a + 3;
	char *s = "ddss";
	int l = strlen(s);

	const char *msg = "hello lmo-os";
	cprintf(msg);

     while (1);
//		return 0;
}
