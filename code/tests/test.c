#include <string.h>

/*
 * void *memset(void *s, char c, size_t n);
 * */
int test_memset() {
	char *p = "abcdefg";
	char *s = memset(p, 'c', 3);
	return 0;
}


int testmain() {

	test_memset();
	return 0;
}
