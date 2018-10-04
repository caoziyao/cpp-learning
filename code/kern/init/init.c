#include <stdio.h>
#include <proc.h>
#include <defs.h>

int
kern_init(void) {
	int a = 1;
	cons_init();

	print("hello");

//	struct proc_struct *p = alloc_proc();
	proc_init();

	a = 2;

    while (1) {
    	;
    }
	return 0;
}

