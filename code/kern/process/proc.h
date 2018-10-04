#ifndef _proc_h_
#define _proc_h_

#include <defs.h>
#include <list.h>

# define PG_SIZE 1024
//void *(*thread_func)(void *);
typedef void (*thread_func)(void *);  //此种方式最容易理解，定义了一个函数指针类型；函数名就是指针。

// 进程状态
typedef enum proc_state {
	EnumProcUnint = 0,	// uninitialized
	EnumProcSleeping,	// sleeping
	EnumProcRunning,	// running
	EnumProcReady,		// runnable
	EnumProcBlocked,	// blocked
	EnumProcWaiting,	// waiting
	EnumProcHanging,	// hanging
	EnumProcZombie,		 // almost dead, and wait parent proc to reclaim his resource
}proc_state;


struct context {
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};

// 线程栈
//typedef struct tag_thread_stack
//{
////    uint32_t ebp;
////    uint32_t ebx;
////    uint32_t edi;
////    uint32_t esi;
//
//    void (*eip)(void *thread_func, void *func_arg);
//
//    void *unused_retaddr;
//    void *thread_func;
//    void *func_arg;
//}thread_stack;

// 中断使用的线程栈
//typedef struct tag_intr_stack
//{
//
////    uint32_t ebp;
////    uint32_t ebx;
////    uint32_t edi;
////    uint32_t esi;
//
////    void (*eip)(thread_func *func, void *func_arg);
//    void (*eip)(thread_func *func, void *func_arg);
//
//    void *unused_retaddr;
//    thread_func *function;
//    void *thread_func;
//    void *func_arg;
//}intr_stack;

typedef struct tag_task_struct
{
    uint32_t *self_kstack; // 内核线程的栈顶地址
    proc_state status;    // 当前线程的状态
    char name[16];
    uint8_t priority;	// 优先级

    uint8_t ticks;  // 线程执行的时间
    uint32_t elapsed_ticks;  // 线程已经执行的时间

    struct list_elem general_tag;  // 就绪线程节点
    struct list_elem all_list_tag; // 所有线程的节点

    struct context context;    // Switch here to run process

    void (*eip)(thread_func *func, void *func_arg); // function
    thread_func *function;
    void *func_arg;

    uint32_t stack_magic;   // 栈的边界标记，用来检测栈溢出
}task_struct;



// 进程控制块 pcb
struct proc_struct {
	enum proc_state state;        // Process state
	int pid;	// Process ID
};

// 初始化线程基本信息
void init_thread(task_struct* pthread, char* name, int prio);
// 线程创建
void thread_create(task_struct* pthread, thread_func function, void* func_arg);
// 启动线程
task_struct* thread_start(char* name, int prio, thread_func function, void*  func_arg);

void proc_init(void);
int do_fork(void);
struct proc_struct *alloc_proc(void);
void kmalloc_proc(void);

#endif // _proc_h_
