#include <stdio.h>

int
kern_init(void) {
	cons_init();

	print("hello");

    while (1) {
    	;
    }
	return 0;
}

