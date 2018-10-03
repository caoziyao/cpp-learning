#include <console.h>
#include <x86.h>

int
kern_init(void) {
	cons_init();

	cons_putc('h');
	cons_putc('e');
	cons_putc('l');

	int a = 0;
	a = a + 3;
    while (1);
	return 0;
}

