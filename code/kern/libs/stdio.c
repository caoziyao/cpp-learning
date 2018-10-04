
#include <stdio.h>
#include <defs.h>
/* HIGH level console I/O */


/*
 * 打印
 * */
void
print(const char *msg) {
	const char *s = msg;
	while (*s != '\0') {
		cons_putc(*s);
		s++;
	}
}
