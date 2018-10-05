#include <stdio.h>
#include <proc.h>
#include <defs.h>
#include <pmm.h>

void
threadFunc(void *arg) {
	print("thread function\n");
}
int
kern_init(void) {
	int a = 1;
	cons_init();
//	proc_init();
	print("main ssss");
	page_init();
//	struct proc_struct *p = alloc_proc();
//	proc_init();
//	thread_start("other", 2, threadFunc, NULL);
//	_beginthread(threadFunc, 0, NULL);

	a = 2;

    while (1) {
    	;
    }
	return 0;
}

