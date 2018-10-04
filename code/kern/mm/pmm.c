#include <pmm.h>
#include <mmu.h>
#include <defs.h>

#define AllocSize 10000
static char allocbuf[AllocSize];    /*storage for alloc*/
static char *allocp = allocbuf;    /*next free position*/

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


//
void
pmm_init() {

}
