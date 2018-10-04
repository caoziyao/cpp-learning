#include <string.h>


/*
 * 复制内存内容（可以处理重叠的内存块）
 * 复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上
 * 先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存
 * */
void *
memmove(void *dst, const void *src, size_t n) {
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
        }
    }
    return dst;
}

/*
 * 将内存的前n个字节设置为特定的值
 * s 为要操作的内存的指针。
 * c 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
 * n 为 ptr 的前 num 个字节，size_t 就是unsigned int。
 * */
void *memset(void *s, char c, size_t n){
	char *p = s;
	while(n-- > 0) {
		*p ++ = c;
	}
	return s;
}


char *
strcpy(char *dst, const char *src){
	char *ret = dst;
	while ((*dst++=*src++)!='\0') {
		;
	}

	return ret;
}
