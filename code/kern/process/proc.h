#ifndef _proc_h_
#define _proc_h_

// 进程状态
enum proc_state {
	EnumProcUnint = 0,	// uninitialized
	EnumProcSleeping,	// sleeping
	EnumProcRunning,	// running
	EnumProcRunnable,	// runnable
	EnumProcZombie,		 // almost dead, and wait parent proc to reclaim his resource
};

// 进程控制块 pcb
struct proc_struct {
	enum proc_state state;        // Process state
	int pid;	// Process ID
};

void pmm_init(void);
int do_fork();
struct proc_struct *alloc_proc();
void kmalloc_proc();

#endif // _proc_h_
