#ifndef _string_h_
#define _string_h_

#include <defs.h>

size_t strlen(const char *s);
size_t strnlen(const char *s, size_t len);

void *memset(void *s, char c, size_t n);
void *memmove(void *dst, const void *src, size_t n);
void *memcpy(void *dst, const void *src, size_t n);

#endif // _string_h_
