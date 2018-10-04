#include <proc.h>
#include <pmm.h>
#include <stdio.h>
#include <defs.h>

// idle proc
struct proc_struct *idleproc = NULL;
// init proc
struct proc_struct *initproc = NULL;
// current proc
struct proc_struct *current = NULL;

/*
 * 创建进程
 * ret == 0 // child
 * ret >0  // parent
 * ret < 0 // error
 * */
int
do_fork() {
	return 0;
}

//
struct proc_struct *
alloc_proc(){
	int n = sizeof(struct proc_struct);
	struct proc_struct *p = (struct proc_struct *)alloc(n);
	if (p != NULL) {
		p->state = EnumProcUnint;
		p->pid = -1;
	}
//	p->cr3 = boot_cr3;
	return p;
}


//
void
proc_init(void) {
	idleproc = alloc_proc();
	if (idleproc != NULL) {
		idleproc->pid = 0;
		idleproc->state = EnumProcRunnable;
	} else {
		print("cannot alloc idleproc.\n");
	}
}


