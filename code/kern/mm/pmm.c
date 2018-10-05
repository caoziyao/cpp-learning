#include <pmm.h>
#include <mmu.h>
#include <defs.h>
#include <memlayout.h>
#include <stdio.h>

#define AllocSize 10000
static char allocbuf[AllocSize];    /*storage for alloc*/
static char *allocp = allocbuf;    /*next free position*/

// virtual address of physicall page array
struct Page *pages;
// amount of physical memory (in pages)
size_t npage = 0;

/*
 * */
char
*alloc(int n) {
	int size = allocbuf+AllocSize - allocp;
	if(size >= n) {
		allocp += n;
//		return alloc - n;
		return allocp;
	} else {
		return NULL;
	}

}

/*
 * */
void
afree(char *p) {
    if (p >= allocbuf && p<allocbuf + AllocSize) {
    	 allocp = p;
    }
}

/* pmm_init - initialize the physical memory management */
void
page_init(void) {
//	 KERNBASE 0x100000
	struct e820map *memmap = (struct e820map *)(0x8000);
	uint64_t maxpa = 0;

	int i;
	int nr_map = memmap->nr_map;
	for (i = 0; i < nr_map; i++) {
		uint64_t begin = memmap->map[i].addr;
		uint64_t end = begin + memmap->map[i].size;
		uint32_t type = memmap->map[i].type;
		if (type == E820_ARM) {
			// address range memory
		  if (maxpa < end && begin < KMEMSIZE) {
			maxpa = end;
		  }
		}
	}

	// 最大的物理内存地址maxpa
	if (maxpa > KMEMSIZE) {
		maxpa = KMEMSIZE;
	}

	// bootloader加载ucore的结束地址（用全局指针变量end记录）
	extern char end[];

	//	需要管理的物理页个数
	npage = maxpa / PGSIZE;
	// 把end按页大小为边界去整后，作为管理页级物理内存空间所需的Page结构的内存空间
	pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

//	for (i = 0; i < npage; i ++) {
//		SetPageReserved(pages + i);
//	}
//
//	uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
//	for (i = 0; i < memmap->nr_map; i ++) {
//		uint64_t begin = memmap->map[i].addr;
//		uint64_t end = begin + memmap->map[i].size;
//		uint32_t type = memmap->map[i].type;
//		if (type == E820_ARM) {
//			if (begin < freemem) {
//				begin = freemem;
//			}
//			if (end > KMEMSIZE) {
//				end = KMEMSIZE;
//			}
//			if (begin < end) {
//				begin = ROUNDUP(begin, PGSIZE);
//				end = ROUNDDOWN(end, PGSIZE);
//				if (begin < end) {
////					init_memmap(pa2page(begin), (end - begin) / PGSIZE);
//				}
//			}
//		}
//	}

	print("e820map:\n");
}
