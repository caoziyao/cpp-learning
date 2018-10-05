#ifndef _memlayout_h_
#define _memlayout_h_

#include <list.h>
#include <atomic.h>

// some constants for bios interrupt 15h AX = 0xE820
#define E820MAX             20      // number of entries in E820MAP
#define E820_ARM            1       // address range memory
#define E820_ARR            2       // address range reserved


/* All physical memory mapped at this address */
//#define KERNBASE            0xC0000000
#define KERNBASE            0x0
#define KMEMSIZE            0x38000000                  // the maximum amount of physical memory
#define KERNTOP             (KERNBASE + KMEMSIZE)


/* Flags describing the status of a page frame */
#define PG_reserved                 0       // the page descriptor is reserved for kernel or unusable

#define SetPageReserved(page)       set_bit(PG_reserved, &((page)->flags))
#define ClearPageReserved(page)     clear_bit(PG_reserved, &((page)->flags))
#define PageReserved(page)          test_bit(PG_reserved, &((page)->flags))

/*
 * 由ucore的page_init函数来根据struct e820map的memmap（定义了起始地址为0x8000）
 * 来完成对整个机器中的物理内存的总体管理
 * */
struct e820map {
    int nr_map;
    // 20 字节
    struct {
        uint64_t addr;
        uint64_t size;
        uint32_t type;
    } __attribute__((packed)) map[E820MAX];
};

/*
 * 双向链表结构 描述每个物理页（也称页帧）
 * */
/* free_area_t - maintains a doubly linked list to record free (unused) pages */
typedef struct {
    list_entry_t free_list;            // the list header
    unsigned int nr_free;            // # of free pages in this free list
} free_area_t;

// 每一个物理页的属性用结构Page来表示
struct Page {
    atomic_t ref;    // page frame's reference counter
    uint32_t flags;    // array of flags that describe the status of the page frame
    list_entry_t page_link;    // free list link
};

#endif // _memlayout_h_
