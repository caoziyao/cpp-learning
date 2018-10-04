#include <proc.h>
#include <pmm.h>
#include <stdio.h>
#include <defs.h>
#include <string.h>

// idle proc
//struct proc_struct *idleproc = NULL;
//// init proc
//struct proc_struct *initproc = NULL;
//// current proc
//struct proc_struct *current = NULL;
task_struct *current = NULL;

void switch_to(struct context *from, struct context *to);

// do_fork - parent process for a new child process
//    1. call alloc_proc to allocate a proc_struct
//    2. call setup_kstack to allocate a kernel stack for child process
//    3. call copy_mm to dup OR share mm according clone_flag
//    4. call wakup_proc to make the new child process RUNNABLE
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


task_struct *
alloc_thread(){
	int n = sizeof(task_struct) ;  // PG_SIZE
	task_struct *p = (task_struct *)alloc(n);
	if (p != NULL) {
		p->status = EnumProcUnint;
	}
//	p->cr3 = boot_cr3;
	return p;
}


// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to
//       proc->tf in do_fork-->copy_thread function
//int
//kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
//	return 0;
//}

// 初始化线程基本信息
void
init_thread(task_struct* pthread, char* name, int prio) {
	memset(pthread, 0, sizeof(*pthread));
//	memset(&(proc->context), 0, sizeof(struct context));
	strcpy(pthread->name, name);

//	pthread->pgdir = NULL;

//	if (pthread->name == main_thread) {
//		pthread->status = EnumProcRunning;
//	} else {
//		pthread->status = EnumProcReady;
//	}
	pthread->status = EnumProcReady;

	pthread->priority = prio;
	pthread->ticks = prio;
	pthread->elapsed_ticks = 0;

	// self_kstack是线程自己在内核态下使用的栈顶地址
	pthread->self_kstack = (uint32_t*)((uint32_t)pthread + PG_SIZE);;
	pthread->stack_magic = 0x19971234;     // 自定义的魔数，检查栈溢出
}

static void
kernel_thread(thread_func function, void *func_arg)
{
//	function(func_arg);
	print("aaaaaaa");
}

// 创建线程
void
thread_create(task_struct* pthread, thread_func function, void* func_arg) {
	// 先预留中断使用栈的空间
//	pthread->self_kstack -= sizeof(intr_stack);

	// 留出线程栈空间
//	pthread->self_kstack -= sizeof(thread_stack);

	pthread->function = function;
	pthread->func_arg = func_arg;

	pthread->context.eip = &kernel_thread;
//	pthread->content.eip = kernel_thread;
//	pthread->content.eip = kernel_thread;
//	pthread->content.eip = kernel_thread;
//	pthread->content.eip = kernel_thread;

//	thread_stack* kthread_stack = (thread_stack*)pthread->self_kstack;
//	kthread_stack->eip = kernel_thread;
//	kthread_stack->thread_func = function;
//	kthread_stack->func_arg = func_arg;
//	kthread_stack->ebp = kthread_stack->ebx = kthread_stack->esi = kthread_stack->edi = 0;
}

// 创建一优先级为prio的线程,线程名为name,线程所执行的函数是function(func_arg)
task_struct*
thread_start(char* name, int prio, thread_func function, void*  func_arg) {
	// pcb都位于内核空间,包括用户进程的pcb也是在内核空间
//	task_struct* thread = get_kernel_pages(1);
	task_struct* thread = alloc_thread();
	if (thread == NULL) {
		print("error thread_start\n");
		return NULL;
	}

	init_thread(thread, name, prio);
	thread_create(thread, function, func_arg);

	/*
	 * 准备好数据之后执行ret，此时会从栈顶会得到返回地址，该地址也就是上面赋值的eip，也就是kernelthread的地址，然后执行该函数，
	 * kernel_thread从栈中得到参数，也就是栈顶+4的真正要执行的线程函数地址，和栈顶+8的线程函数所需的参数。
	 * */
//	asm volatile ("movl %0, %%esp; pop %%ebp; pop %%ebx; pop %%edi; pop %%esi; ret"  : : "g" (thread->self_kstack) : "memory");

	switch_to(&(current->context), &(thread->context));
	return thread;
}

// 执行线程
task_struct *
running_thread() {

}

//
void
proc_init(void) {
//	idleproc = alloc_proc();
//	if (idleproc == NULL) {
//		print("cannot alloc idleproc.\n");
//		return ;
//	}
	current = alloc_thread();
	if (current == NULL) {
		print("cannot alloc current.\n");
		return ;
	}
	init_thread(current, "main", 1);


//	idleproc->pid = 0;
//	idleproc->state = EnumProcReady;
//	current = idleproc;
}


