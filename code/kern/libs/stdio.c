#include <types.h>
#include <stdio.h>
#include <console.h>


/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
    cons_putc(c);
    (*cnt) ++;
}

/*
 * todo
 * 格式化输出
 * */
int
vcprintf(const char *msg) {
	int cnt = 0;
//	vprintfmt((void*)cputch, &cnt, fmt, ap);
	const char *s = msg;
	while (*s != '\0') {
		cputch(*s, &cnt);
		s++;
	}
	return cnt;
}


/*
 * cprintf - formats a string and writes it to stdout
 * todo
 * */
int
cprintf(const char *msg) {
	int cnt;
	cnt = vcprintf(msg);
	return cnt;
}


