#include <types.h>
#include <string.h>
#include <test.h>
#include <console.h>
#include <stdio.h>
// qemu-system-i386 -hda bin/ucore.img -S -s
// x86_64-linux-gnu-gdb bin/kernel
// target remote :1234
// break kern_init
 int kern_init(void) __attribute__((noreturn));

void init_driver() {
	 cons_init();                // init the console
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
