
obj/__user_sh.out:     file format elf32-i386


Disassembly of section .text:

00800020 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	83 ec 18             	sub    $0x18,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800026:	8d 45 14             	lea    0x14(%ebp),%eax
  800029:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80002c:	83 ec 04             	sub    $0x4,%esp
  80002f:	ff 75 0c             	pushl  0xc(%ebp)
  800032:	ff 75 08             	pushl  0x8(%ebp)
  800035:	68 e0 1d 80 00       	push   $0x801de0
  80003a:	e8 96 05 00 00       	call   8005d5 <cprintf>
  80003f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  800042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800045:	83 ec 08             	sub    $0x8,%esp
  800048:	50                   	push   %eax
  800049:	ff 75 10             	pushl  0x10(%ebp)
  80004c:	e8 53 05 00 00       	call   8005a4 <vcprintf>
  800051:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 fa 1d 80 00       	push   $0x801dfa
  80005c:	e8 74 05 00 00       	call   8005d5 <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
    exit(-E_PANIC);
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	6a f6                	push   $0xfffffff6
  800069:	e8 37 08 00 00       	call   8008a5 <exit>

0080006e <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  80006e:	55                   	push   %ebp
  80006f:	89 e5                	mov    %esp,%ebp
  800071:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  800074:	8d 45 14             	lea    0x14(%ebp),%eax
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user warning at %s:%d:\n    ", file, line);
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 0c             	pushl  0xc(%ebp)
  800080:	ff 75 08             	pushl  0x8(%ebp)
  800083:	68 fc 1d 80 00       	push   $0x801dfc
  800088:	e8 48 05 00 00       	call   8005d5 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  800090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	ff 75 10             	pushl  0x10(%ebp)
  80009a:	e8 05 05 00 00       	call   8005a4 <vcprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 fa 1d 80 00       	push   $0x801dfa
  8000aa:	e8 26 05 00 00       	call   8005d5 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  8000b2:	90                   	nop
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <syscall>:


#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	57                   	push   %edi
  8000b9:	56                   	push   %esi
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 20             	sub    $0x20,%esp
    va_list ap;
    va_start(ap, num);
  8000be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8000c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8000c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000cb:	eb 16                	jmp    8000e3 <syscall+0x2e>
        a[i] = va_arg(ap, uint32_t);
  8000cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d0:	8d 50 04             	lea    0x4(%eax),%edx
  8000d3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  8000d6:	8b 10                	mov    (%eax),%edx
  8000d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000db:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8000df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8000e3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8000e7:	7e e4                	jle    8000cd <syscall+0x18>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  8000e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  8000ec:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  8000ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  8000f2:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  8000f5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
  8000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000fb:	cd 80                	int    $0x80
  8000fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
          "c" (a[1]),
          "b" (a[2]),
          "D" (a[3]),
          "S" (a[4])
        : "cc", "memory");
    return ret;
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  800103:	83 c4 20             	add    $0x20,%esp
  800106:	5b                   	pop    %ebx
  800107:	5e                   	pop    %esi
  800108:	5f                   	pop    %edi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    

0080010b <sys_exit>:

int
sys_exit(int error_code) {
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_exit, error_code);
  80010e:	ff 75 08             	pushl  0x8(%ebp)
  800111:	6a 01                	push   $0x1
  800113:	e8 9d ff ff ff       	call   8000b5 <syscall>
  800118:	83 c4 08             	add    $0x8,%esp
}
  80011b:	c9                   	leave  
  80011c:	c3                   	ret    

0080011d <sys_fork>:

int
sys_fork(void) {
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_fork);
  800120:	6a 02                	push   $0x2
  800122:	e8 8e ff ff ff       	call   8000b5 <syscall>
  800127:	83 c4 04             	add    $0x4,%esp
}
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <sys_wait>:

int
sys_wait(int pid, int *store) {
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_wait, pid, store);
  80012f:	ff 75 0c             	pushl  0xc(%ebp)
  800132:	ff 75 08             	pushl  0x8(%ebp)
  800135:	6a 03                	push   $0x3
  800137:	e8 79 ff ff ff       	call   8000b5 <syscall>
  80013c:	83 c4 0c             	add    $0xc,%esp
}
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <sys_yield>:

int
sys_yield(void) {
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_yield);
  800144:	6a 0a                	push   $0xa
  800146:	e8 6a ff ff ff       	call   8000b5 <syscall>
  80014b:	83 c4 04             	add    $0x4,%esp
}
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <sys_kill>:

int
sys_kill(int pid) {
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_kill, pid);
  800153:	ff 75 08             	pushl  0x8(%ebp)
  800156:	6a 0c                	push   $0xc
  800158:	e8 58 ff ff ff       	call   8000b5 <syscall>
  80015d:	83 c4 08             	add    $0x8,%esp
}
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <sys_getpid>:

int
sys_getpid(void) {
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_getpid);
  800165:	6a 12                	push   $0x12
  800167:	e8 49 ff ff ff       	call   8000b5 <syscall>
  80016c:	83 c4 04             	add    $0x4,%esp
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <sys_putc>:

int
sys_putc(int c) {
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_putc, c);
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	6a 1e                	push   $0x1e
  800179:	e8 37 ff ff ff       	call   8000b5 <syscall>
  80017e:	83 c4 08             	add    $0x8,%esp
}
  800181:	c9                   	leave  
  800182:	c3                   	ret    

00800183 <sys_pgdir>:

int
sys_pgdir(void) {
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_pgdir);
  800186:	6a 1f                	push   $0x1f
  800188:	e8 28 ff ff ff       	call   8000b5 <syscall>
  80018d:	83 c4 04             	add    $0x4,%esp
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
    syscall(SYS_lab6_set_priority, priority);
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	68 ff 00 00 00       	push   $0xff
  80019d:	e8 13 ff ff ff       	call   8000b5 <syscall>
  8001a2:	83 c4 08             	add    $0x8,%esp
}
  8001a5:	90                   	nop
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_sleep, time);
  8001ab:	ff 75 08             	pushl  0x8(%ebp)
  8001ae:	6a 0b                	push   $0xb
  8001b0:	e8 00 ff ff ff       	call   8000b5 <syscall>
  8001b5:	83 c4 08             	add    $0x8,%esp
}
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    

008001ba <sys_gettime>:

int
sys_gettime(void) {
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_gettime);
  8001bd:	6a 11                	push   $0x11
  8001bf:	e8 f1 fe ff ff       	call   8000b5 <syscall>
  8001c4:	83 c4 04             	add    $0x4,%esp
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <sys_exec>:

int
sys_exec(const char *name, int argc, const char **argv) {
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_exec, name, argc, argv);
  8001cc:	ff 75 10             	pushl  0x10(%ebp)
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	6a 04                	push   $0x4
  8001d7:	e8 d9 fe ff ff       	call   8000b5 <syscall>
  8001dc:	83 c4 10             	add    $0x10,%esp
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <sys_open>:

int
sys_open(const char *path, uint32_t open_flags) {
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_open, path, open_flags);
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	6a 64                	push   $0x64
  8001ec:	e8 c4 fe ff ff       	call   8000b5 <syscall>
  8001f1:	83 c4 0c             	add    $0xc,%esp
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <sys_close>:

int
sys_close(int fd) {
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_close, fd);
  8001f9:	ff 75 08             	pushl  0x8(%ebp)
  8001fc:	6a 65                	push   $0x65
  8001fe:	e8 b2 fe ff ff       	call   8000b5 <syscall>
  800203:	83 c4 08             	add    $0x8,%esp
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <sys_read>:

int
sys_read(int fd, void *base, size_t len) {
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_read, fd, base, len);
  80020b:	ff 75 10             	pushl  0x10(%ebp)
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	6a 66                	push   $0x66
  800216:	e8 9a fe ff ff       	call   8000b5 <syscall>
  80021b:	83 c4 10             	add    $0x10,%esp
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <sys_write>:

int
sys_write(int fd, void *base, size_t len) {
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_write, fd, base, len);
  800223:	ff 75 10             	pushl  0x10(%ebp)
  800226:	ff 75 0c             	pushl  0xc(%ebp)
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	6a 67                	push   $0x67
  80022e:	e8 82 fe ff ff       	call   8000b5 <syscall>
  800233:	83 c4 10             	add    $0x10,%esp
}
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <sys_seek>:

int
sys_seek(int fd, off_t pos, int whence) {
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_seek, fd, pos, whence);
  80023b:	ff 75 10             	pushl  0x10(%ebp)
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	6a 68                	push   $0x68
  800246:	e8 6a fe ff ff       	call   8000b5 <syscall>
  80024b:	83 c4 10             	add    $0x10,%esp
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <sys_fstat>:

int
sys_fstat(int fd, struct stat *stat) {
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_fstat, fd, stat);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	6a 6e                	push   $0x6e
  80025b:	e8 55 fe ff ff       	call   8000b5 <syscall>
  800260:	83 c4 0c             	add    $0xc,%esp
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <sys_fsync>:

int
sys_fsync(int fd) {
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_fsync, fd);
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	6a 6f                	push   $0x6f
  80026d:	e8 43 fe ff ff       	call   8000b5 <syscall>
  800272:	83 c4 08             	add    $0x8,%esp
}
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <sys_getcwd>:

int
sys_getcwd(char *buffer, size_t len) {
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_getcwd, buffer, len);
  80027a:	ff 75 0c             	pushl  0xc(%ebp)
  80027d:	ff 75 08             	pushl  0x8(%ebp)
  800280:	6a 79                	push   $0x79
  800282:	e8 2e fe ff ff       	call   8000b5 <syscall>
  800287:	83 c4 0c             	add    $0xc,%esp
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <sys_getdirentry>:

int
sys_getdirentry(int fd, struct dirent *dirent) {
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_getdirentry, fd, dirent);
  80028f:	ff 75 0c             	pushl  0xc(%ebp)
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	68 80 00 00 00       	push   $0x80
  80029a:	e8 16 fe ff ff       	call   8000b5 <syscall>
  80029f:	83 c4 0c             	add    $0xc,%esp
}
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <sys_dup>:

int
sys_dup(int fd1, int fd2) {
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
    return syscall(SYS_dup, fd1, fd2);
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	68 82 00 00 00       	push   $0x82
  8002b2:	e8 fe fd ff ff       	call   8000b5 <syscall>
  8002b7:	83 c4 0c             	add    $0xc,%esp
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <opendir>:
#include <error.h>
#include <unistd.h>

DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 24             	sub    $0x24,%esp

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
  8002c3:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	6a 00                	push   $0x0
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	e8 d6 00 00 00       	call   8003ac <open>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 03                	mov    %eax,(%ebx)
  8002db:	8b 03                	mov    (%ebx),%eax
  8002dd:	85 c0                	test   %eax,%eax
  8002df:	78 44                	js     800325 <opendir+0x69>
        goto failed;
    }
    struct stat __stat, *stat = &__stat;
  8002e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (fstat(dirp->fd, stat) != 0 || !S_ISDIR(stat->st_mode)) {
  8002e7:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f4:	50                   	push   %eax
  8002f5:	e8 35 01 00 00       	call   80042f <fstat>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	75 25                	jne    800326 <opendir+0x6a>
  800301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800304:	8b 00                	mov    (%eax),%eax
  800306:	25 00 70 00 00       	and    $0x7000,%eax
  80030b:	3d 00 20 00 00       	cmp    $0x2000,%eax
  800310:	75 14                	jne    800326 <opendir+0x6a>
        goto failed;
    }
    dirp->dirent.offset = 0;
  800312:	a1 00 30 80 00       	mov    0x803000,%eax
  800317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    return dirp;
  80031e:	a1 00 30 80 00       	mov    0x803000,%eax
  800323:	eb 06                	jmp    80032b <opendir+0x6f>
DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
        goto failed;
  800325:	90                   	nop
    }
    dirp->dirent.offset = 0;
    return dirp;

failed:
    return NULL;
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80032b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <readdir>:

struct dirent *
readdir(DIR *dirp) {
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	83 ec 08             	sub    $0x8,%esp
    if (sys_getdirentry(dirp->fd, &(dirp->dirent)) == 0) {
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	8d 50 04             	lea    0x4(%eax),%edx
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	52                   	push   %edx
  800345:	50                   	push   %eax
  800346:	e8 41 ff ff ff       	call   80028c <sys_getdirentry>
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	85 c0                	test   %eax,%eax
  800350:	75 08                	jne    80035a <readdir+0x2a>
        return &(dirp->dirent);
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	83 c0 04             	add    $0x4,%eax
  800358:	eb 05                	jmp    80035f <readdir+0x2f>
    }
    return NULL;
  80035a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <closedir>:

void
closedir(DIR *dirp) {
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	83 ec 08             	sub    $0x8,%esp
    close(dirp->fd);
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	e8 50 00 00 00       	call   8003c5 <close>
  800375:	83 c4 10             	add    $0x10,%esp
}
  800378:	90                   	nop
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <getcwd>:

int
getcwd(char *buffer, size_t len) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 08             	sub    $0x8,%esp
    return sys_getcwd(buffer, len);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	ff 75 0c             	pushl  0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 e8 fe ff ff       	call   800277 <sys_getcwd>
  80038f:	83 c4 10             	add    $0x10,%esp
}
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  800394:	bd 00 00 00 00       	mov    $0x0,%ebp

    # load argc and argv
    movl (%esp), %ebx
  800399:	8b 1c 24             	mov    (%esp),%ebx
    lea 0x4(%esp), %ecx
  80039c:	8d 4c 24 04          	lea    0x4(%esp),%ecx


    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  8003a0:	83 ec 20             	sub    $0x20,%esp

    # save argc and argv on stack
    pushl %ecx
  8003a3:	51                   	push   %ecx
    pushl %ebx
  8003a4:	53                   	push   %ebx

    # call user-program function
    call umain
  8003a5:	e8 89 03 00 00       	call   800733 <umain>
1:  jmp 1b
  8003aa:	eb fe                	jmp    8003aa <_start+0x16>

008003ac <open>:
#include <stat.h>
#include <error.h>
#include <unistd.h>

int
open(const char *path, uint32_t open_flags) {
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 08             	sub    $0x8,%esp
    return sys_open(path, open_flags);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	e8 21 fe ff ff       	call   8001e1 <sys_open>
  8003c0:	83 c4 10             	add    $0x10,%esp
}
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <close>:

int
close(int fd) {
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 08             	sub    $0x8,%esp
    return sys_close(fd);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	e8 20 fe ff ff       	call   8001f6 <sys_close>
  8003d6:	83 c4 10             	add    $0x10,%esp
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <read>:

int
read(int fd, void *base, size_t len) {
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	83 ec 08             	sub    $0x8,%esp
    return sys_read(fd, base, len);
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	ff 75 10             	pushl  0x10(%ebp)
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 16 fe ff ff       	call   800208 <sys_read>
  8003f2:	83 c4 10             	add    $0x10,%esp
}
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <write>:

int
write(int fd, void *base, size_t len) {
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	83 ec 08             	sub    $0x8,%esp
    return sys_write(fd, base, len);
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	ff 75 10             	pushl  0x10(%ebp)
  800403:	ff 75 0c             	pushl  0xc(%ebp)
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	e8 12 fe ff ff       	call   800220 <sys_write>
  80040e:	83 c4 10             	add    $0x10,%esp
}
  800411:	c9                   	leave  
  800412:	c3                   	ret    

00800413 <seek>:

int
seek(int fd, off_t pos, int whence) {
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	83 ec 08             	sub    $0x8,%esp
    return sys_seek(fd, pos, whence);
  800419:	83 ec 04             	sub    $0x4,%esp
  80041c:	ff 75 10             	pushl  0x10(%ebp)
  80041f:	ff 75 0c             	pushl  0xc(%ebp)
  800422:	ff 75 08             	pushl  0x8(%ebp)
  800425:	e8 0e fe ff ff       	call   800238 <sys_seek>
  80042a:	83 c4 10             	add    $0x10,%esp
}
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

0080042f <fstat>:

int
fstat(int fd, struct stat *stat) {
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
    return sys_fstat(fd, stat);
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	ff 75 0c             	pushl  0xc(%ebp)
  80043b:	ff 75 08             	pushl  0x8(%ebp)
  80043e:	e8 0d fe ff ff       	call   800250 <sys_fstat>
  800443:	83 c4 10             	add    $0x10,%esp
}
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <fsync>:

int
fsync(int fd) {
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	83 ec 08             	sub    $0x8,%esp
    return sys_fsync(fd);
  80044e:	83 ec 0c             	sub    $0xc,%esp
  800451:	ff 75 08             	pushl  0x8(%ebp)
  800454:	e8 0c fe ff ff       	call   800265 <sys_fsync>
  800459:	83 c4 10             	add    $0x10,%esp
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <dup2>:

int
dup2(int fd1, int fd2) {
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
    return sys_dup(fd1, fd2);
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	ff 75 0c             	pushl  0xc(%ebp)
  80046a:	ff 75 08             	pushl  0x8(%ebp)
  80046d:	e8 32 fe ff ff       	call   8002a4 <sys_dup>
  800472:	83 c4 10             	add    $0x10,%esp
}
  800475:	c9                   	leave  
  800476:	c3                   	ret    

00800477 <transmode>:

static char
transmode(struct stat *stat) {
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 10             	sub    $0x10,%esp
    uint32_t mode = stat->st_mode;
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (S_ISREG(mode)) return 'r';
  800485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800488:	25 00 70 00 00       	and    $0x7000,%eax
  80048d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800492:	75 07                	jne    80049b <transmode+0x24>
  800494:	b8 72 00 00 00       	mov    $0x72,%eax
  800499:	eb 5d                	jmp    8004f8 <transmode+0x81>
    if (S_ISDIR(mode)) return 'd';
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	25 00 70 00 00       	and    $0x7000,%eax
  8004a3:	3d 00 20 00 00       	cmp    $0x2000,%eax
  8004a8:	75 07                	jne    8004b1 <transmode+0x3a>
  8004aa:	b8 64 00 00 00       	mov    $0x64,%eax
  8004af:	eb 47                	jmp    8004f8 <transmode+0x81>
    if (S_ISLNK(mode)) return 'l';
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	25 00 70 00 00       	and    $0x7000,%eax
  8004b9:	3d 00 30 00 00       	cmp    $0x3000,%eax
  8004be:	75 07                	jne    8004c7 <transmode+0x50>
  8004c0:	b8 6c 00 00 00       	mov    $0x6c,%eax
  8004c5:	eb 31                	jmp    8004f8 <transmode+0x81>
    if (S_ISCHR(mode)) return 'c';
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	25 00 70 00 00       	and    $0x7000,%eax
  8004cf:	3d 00 40 00 00       	cmp    $0x4000,%eax
  8004d4:	75 07                	jne    8004dd <transmode+0x66>
  8004d6:	b8 63 00 00 00       	mov    $0x63,%eax
  8004db:	eb 1b                	jmp    8004f8 <transmode+0x81>
    if (S_ISBLK(mode)) return 'b';
  8004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e0:	25 00 70 00 00       	and    $0x7000,%eax
  8004e5:	3d 00 50 00 00       	cmp    $0x5000,%eax
  8004ea:	75 07                	jne    8004f3 <transmode+0x7c>
  8004ec:	b8 62 00 00 00       	mov    $0x62,%eax
  8004f1:	eb 05                	jmp    8004f8 <transmode+0x81>
    return '-';
  8004f3:	b8 2d 00 00 00       	mov    $0x2d,%eax
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <print_stat>:

void
print_stat(const char *name, int fd, struct stat *stat) {
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 08             	sub    $0x8,%esp
    cprintf("[%03d] %s\n", fd, name);
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	ff 75 08             	pushl  0x8(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	68 18 1e 80 00       	push   $0x801e18
  80050e:	e8 c2 00 00 00       	call   8005d5 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
    cprintf("    mode    : %c\n", transmode(stat));
  800516:	83 ec 0c             	sub    $0xc,%esp
  800519:	ff 75 10             	pushl  0x10(%ebp)
  80051c:	e8 56 ff ff ff       	call   800477 <transmode>
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	0f be c0             	movsbl %al,%eax
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	50                   	push   %eax
  80052b:	68 23 1e 80 00       	push   $0x801e23
  800530:	e8 a0 00 00 00       	call   8005d5 <cprintf>
  800535:	83 c4 10             	add    $0x10,%esp
    cprintf("    links   : %lu\n", stat->st_nlinks);
  800538:	8b 45 10             	mov    0x10(%ebp),%eax
  80053b:	8b 40 04             	mov    0x4(%eax),%eax
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	50                   	push   %eax
  800542:	68 35 1e 80 00       	push   $0x801e35
  800547:	e8 89 00 00 00       	call   8005d5 <cprintf>
  80054c:	83 c4 10             	add    $0x10,%esp
    cprintf("    blocks  : %lu\n", stat->st_blocks);
  80054f:	8b 45 10             	mov    0x10(%ebp),%eax
  800552:	8b 40 08             	mov    0x8(%eax),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	50                   	push   %eax
  800559:	68 48 1e 80 00       	push   $0x801e48
  80055e:	e8 72 00 00 00       	call   8005d5 <cprintf>
  800563:	83 c4 10             	add    $0x10,%esp
    cprintf("    size    : %lu\n", stat->st_size);
  800566:	8b 45 10             	mov    0x10(%ebp),%eax
  800569:	8b 40 0c             	mov    0xc(%eax),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	50                   	push   %eax
  800570:	68 5b 1e 80 00       	push   $0x801e5b
  800575:	e8 5b 00 00 00       	call   8005d5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
}
  80057d:	90                   	nop
  80057e:	c9                   	leave  
  80057f:	c3                   	ret    

00800580 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	83 ec 08             	sub    $0x8,%esp
    sys_putc(c);
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	ff 75 08             	pushl  0x8(%ebp)
  80058c:	e8 e0 fb ff ff       	call   800171 <sys_putc>
  800591:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	8d 50 01             	lea    0x1(%eax),%edx
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	89 10                	mov    %edx,(%eax)
}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  8005aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, NO_FD, &cnt, fmt, ap);
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	ff 75 08             	pushl  0x8(%ebp)
  8005ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	68 d9 6a ff ff       	push   $0xffff6ad9
  8005c3:	68 80 05 80 00       	push   $0x800580
  8005c8:	e8 8e 0a 00 00       	call   80105b <vprintfmt>
  8005cd:	83 c4 20             	add    $0x20,%esp
    return cnt;
  8005d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005d3:	c9                   	leave  
  8005d4:	c3                   	ret    

008005d5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  8005db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vcprintf(fmt, ap);
  8005e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	e8 b4 ff ff ff       	call   8005a4 <vcprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  8005f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  800601:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  800608:	eb 14                	jmp    80061e <cputs+0x23>
        cputch(c, &cnt);
  80060a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800614:	52                   	push   %edx
  800615:	50                   	push   %eax
  800616:	e8 65 ff ff ff       	call   800580 <cputch>
  80061b:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8d 50 01             	lea    0x1(%eax),%edx
  800624:	89 55 08             	mov    %edx,0x8(%ebp)
  800627:	0f b6 00             	movzbl (%eax),%eax
  80062a:	88 45 f7             	mov    %al,-0x9(%ebp)
  80062d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800631:	75 d7                	jne    80060a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800639:	50                   	push   %eax
  80063a:	6a 0a                	push   $0xa
  80063c:	e8 3f ff ff ff       	call   800580 <cputch>
  800641:	83 c4 10             	add    $0x10,%esp
    return cnt;
  800644:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <fputch>:


static void
fputch(char c, int *cnt, int fd) {
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	83 ec 18             	sub    $0x18,%esp
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	88 45 f4             	mov    %al,-0xc(%ebp)
    write(fd, &c, sizeof(char));
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	6a 01                	push   $0x1
  80065a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80065d:	50                   	push   %eax
  80065e:	ff 75 10             	pushl  0x10(%ebp)
  800661:	e8 91 fd ff ff       	call   8003f7 <write>
  800666:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  800669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	8d 50 01             	lea    0x1(%eax),%edx
  800671:	8b 45 0c             	mov    0xc(%ebp),%eax
  800674:	89 10                	mov    %edx,(%eax)
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  80067f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)fputch, fd, &cnt, fmt, ap);
  800686:	83 ec 0c             	sub    $0xc,%esp
  800689:	ff 75 10             	pushl  0x10(%ebp)
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800692:	50                   	push   %eax
  800693:	ff 75 08             	pushl  0x8(%ebp)
  800696:	68 49 06 80 00       	push   $0x800649
  80069b:	e8 bb 09 00 00       	call   80105b <vprintfmt>
  8006a0:	83 c4 20             	add    $0x20,%esp
    return cnt;
  8006a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  8006ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8006b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vfprintf(fd, fmt, ap);
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b7:	83 ec 04             	sub    $0x4,%esp
  8006ba:	50                   	push   %eax
  8006bb:	ff 75 0c             	pushl  0xc(%ebp)
  8006be:	ff 75 08             	pushl  0x8(%ebp)
  8006c1:	e8 b3 ff ff ff       	call   800679 <vfprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  8006cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <initfd>:
#include <stat.h>

int main(int argc, char *argv[]);

static int
initfd(int fd2, const char *path, uint32_t open_flags) {
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	83 ec 18             	sub    $0x18,%esp
    int fd1, ret;
    if ((fd1 = open(path, open_flags)) < 0) {
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 10             	pushl  0x10(%ebp)
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	e8 c7 fc ff ff       	call   8003ac <open>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006ef:	79 05                	jns    8006f6 <initfd+0x25>
        return fd1;
  8006f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f4:	eb 3b                	jmp    800731 <initfd+0x60>
    }
    if (fd1 != fd2) {
  8006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8006fc:	74 30                	je     80072e <initfd+0x5d>
        close(fd2);
  8006fe:	83 ec 0c             	sub    $0xc,%esp
  800701:	ff 75 08             	pushl  0x8(%ebp)
  800704:	e8 bc fc ff ff       	call   8003c5 <close>
  800709:	83 c4 10             	add    $0x10,%esp
        ret = dup2(fd1, fd2);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 08             	pushl  0x8(%ebp)
  800712:	ff 75 f0             	pushl  -0x10(%ebp)
  800715:	e8 44 fd ff ff       	call   80045e <dup2>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        close(fd1);
  800720:	83 ec 0c             	sub    $0xc,%esp
  800723:	ff 75 f0             	pushl  -0x10(%ebp)
  800726:	e8 9a fc ff ff       	call   8003c5 <close>
  80072b:	83 c4 10             	add    $0x10,%esp
    }
    return ret;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800731:	c9                   	leave  
  800732:	c3                   	ret    

00800733 <umain>:

void
umain(int argc, char *argv[]) {
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 18             	sub    $0x18,%esp
    int fd;
    if ((fd = initfd(0, "stdin:", O_RDONLY)) < 0) {
  800739:	83 ec 04             	sub    $0x4,%esp
  80073c:	6a 00                	push   $0x0
  80073e:	68 6e 1e 80 00       	push   $0x801e6e
  800743:	6a 00                	push   $0x0
  800745:	e8 87 ff ff ff       	call   8006d1 <initfd>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800754:	79 17                	jns    80076d <umain+0x3a>
        warn("open <stdin> failed: %e.\n", fd);
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	68 75 1e 80 00       	push   $0x801e75
  80075e:	6a 1a                	push   $0x1a
  800760:	68 8f 1e 80 00       	push   $0x801e8f
  800765:	e8 04 f9 ff ff       	call   80006e <__warn>
  80076a:	83 c4 10             	add    $0x10,%esp
    }
    if ((fd = initfd(1, "stdout:", O_WRONLY)) < 0) {
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	6a 01                	push   $0x1
  800772:	68 a1 1e 80 00       	push   $0x801ea1
  800777:	6a 01                	push   $0x1
  800779:	e8 53 ff ff ff       	call   8006d1 <initfd>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	79 17                	jns    8007a1 <umain+0x6e>
        warn("open <stdout> failed: %e.\n", fd);
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	68 a9 1e 80 00       	push   $0x801ea9
  800792:	6a 1d                	push   $0x1d
  800794:	68 8f 1e 80 00       	push   $0x801e8f
  800799:	e8 d0 f8 ff ff       	call   80006e <__warn>
  80079e:	83 c4 10             	add    $0x10,%esp
    }
    int ret = main(argc, argv);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	e8 c8 14 00 00       	call   801c77 <main>
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    exit(ret);
  8007b5:	83 ec 0c             	sub    $0xc,%esp
  8007b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bb:	e8 e5 00 00 00       	call   8008a5 <exit>

008007c0 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	0f ab 02             	bts    %eax,(%edx)
  8007cf:	19 c0                	sbb    %eax,%eax
  8007d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
  8007d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8007d8:	0f 95 c0             	setne  %al
  8007db:	0f b6 c0             	movzbl %al,%eax
}
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  8007e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	0f b3 02             	btr    %eax,(%edx)
  8007ef:	19 c0                	sbb    %eax,%eax
  8007f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
  8007f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8007f8:	0f 95 c0             	setne  %al
  8007fb:	0f b6 c0             	movzbl %al,%eax
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <try_lock>:
lock_init(lock_t *l) {
    *l = 0;
}

static inline bool
try_lock(lock_t *l) {
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
    return test_and_set_bit(0, l);
  800803:	ff 75 08             	pushl  0x8(%ebp)
  800806:	6a 00                	push   $0x0
  800808:	e8 b3 ff ff ff       	call   8007c0 <test_and_set_bit>
  80080d:	83 c4 08             	add    $0x8,%esp
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <lock>:

static inline void
lock(lock_t *l) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 18             	sub    $0x18,%esp
    if (try_lock(l)) {
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	e8 e0 ff ff ff       	call   800800 <try_lock>
  800820:	83 c4 04             	add    $0x4,%esp
  800823:	85 c0                	test   %eax,%eax
  800825:	74 3c                	je     800863 <lock+0x51>
        int step = 0;
  800827:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        do {
            yield();
  80082e:	e8 d5 00 00 00       	call   800908 <yield>
            if (++ step == 100) {
  800833:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800837:	83 7d f4 64          	cmpl   $0x64,-0xc(%ebp)
  80083b:	75 14                	jne    800851 <lock+0x3f>
                step = 0;
  80083d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                sleep(10);
  800844:	83 ec 0c             	sub    $0xc,%esp
  800847:	6a 0a                	push   $0xa
  800849:	e8 10 01 00 00       	call   80095e <sleep>
  80084e:	83 c4 10             	add    $0x10,%esp
            }
        } while (try_lock(l));
  800851:	83 ec 0c             	sub    $0xc,%esp
  800854:	ff 75 08             	pushl  0x8(%ebp)
  800857:	e8 a4 ff ff ff       	call   800800 <try_lock>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	85 c0                	test   %eax,%eax
  800861:	75 cb                	jne    80082e <lock+0x1c>
    }
}
  800863:	90                   	nop
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <unlock>:

static inline void
unlock(lock_t *l) {
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
    test_and_clear_bit(0, l);
  800869:	ff 75 08             	pushl  0x8(%ebp)
  80086c:	6a 00                	push   $0x0
  80086e:	e8 6d ff ff ff       	call   8007e0 <test_and_clear_bit>
  800873:	83 c4 08             	add    $0x8,%esp
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <lock_fork>:
#include <lock.h>

static lock_t fork_lock = INIT_LOCK;

void
lock_fork(void) {
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
    lock(&fork_lock);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	68 20 30 80 00       	push   $0x803020
  800887:	e8 86 ff ff ff       	call   800812 <lock>
  80088c:	83 c4 10             	add    $0x10,%esp
}
  80088f:	90                   	nop
  800890:	c9                   	leave  
  800891:	c3                   	ret    

00800892 <unlock_fork>:

void
unlock_fork(void) {
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
    unlock(&fork_lock);
  800895:	68 20 30 80 00       	push   $0x803020
  80089a:	e8 c7 ff ff ff       	call   800866 <unlock>
  80089f:	83 c4 04             	add    $0x4,%esp
}
  8008a2:	90                   	nop
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <exit>:

void
exit(int error_code) {
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	83 ec 08             	sub    $0x8,%esp
    sys_exit(error_code);
  8008ab:	83 ec 0c             	sub    $0xc,%esp
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 55 f8 ff ff       	call   80010b <sys_exit>
  8008b6:	83 c4 10             	add    $0x10,%esp
    cprintf("BUG: exit failed.\n");
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	68 c4 1e 80 00       	push   $0x801ec4
  8008c1:	e8 0f fd ff ff       	call   8005d5 <cprintf>
  8008c6:	83 c4 10             	add    $0x10,%esp
    while (1);
  8008c9:	eb fe                	jmp    8008c9 <exit+0x24>

008008cb <fork>:
}

int
fork(void) {
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  8008d1:	e8 47 f8 ff ff       	call   80011d <sys_fork>
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <wait>:

int
wait(void) {
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 08             	sub    $0x8,%esp
    return sys_wait(0, NULL);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	6a 00                	push   $0x0
  8008e3:	6a 00                	push   $0x0
  8008e5:	e8 42 f8 ff ff       	call   80012c <sys_wait>
  8008ea:	83 c4 10             	add    $0x10,%esp
}
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <waitpid>:

int
waitpid(int pid, int *store) {
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	83 ec 08             	sub    $0x8,%esp
    return sys_wait(pid, store);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	ff 75 08             	pushl  0x8(%ebp)
  8008fe:	e8 29 f8 ff ff       	call   80012c <sys_wait>
  800903:	83 c4 10             	add    $0x10,%esp
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <yield>:

void
yield(void) {
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  80090e:	e8 2e f8 ff ff       	call   800141 <sys_yield>
}
  800913:	90                   	nop
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <kill>:

int
kill(int pid) {
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	83 ec 08             	sub    $0x8,%esp
    return sys_kill(pid);
  80091c:	83 ec 0c             	sub    $0xc,%esp
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 29 f8 ff ff       	call   800150 <sys_kill>
  800927:	83 c4 10             	add    $0x10,%esp
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <getpid>:

int
getpid(void) {
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800932:	e8 2b f8 ff ff       	call   800162 <sys_getpid>
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  80093f:	e8 3f f8 ff ff       	call   800183 <sys_pgdir>
}
  800944:	90                   	nop
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 08             	sub    $0x8,%esp
    sys_lab6_set_priority(priority);
  80094d:	83 ec 0c             	sub    $0xc,%esp
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 3a f8 ff ff       	call   800192 <sys_lab6_set_priority>
  800958:	83 c4 10             	add    $0x10,%esp
}
  80095b:	90                   	nop
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <sleep>:

int
sleep(unsigned int time) {
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 08             	sub    $0x8,%esp
    return sys_sleep(time);
  800964:	83 ec 0c             	sub    $0xc,%esp
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	e8 39 f8 ff ff       	call   8001a8 <sys_sleep>
  80096f:	83 c4 10             	add    $0x10,%esp
}
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <gettime_msec>:

unsigned int
gettime_msec(void) {
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  80097a:	e8 3b f8 ff ff       	call   8001ba <sys_gettime>
}
  80097f:	c9                   	leave  
  800980:	c3                   	ret    

00800981 <__exec>:

int
__exec(const char *name, const char **argv) {
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  800987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (argv[argc] != NULL) {
  80098e:	eb 04                	jmp    800994 <__exec+0x13>
        argc ++;
  800990:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
}

int
__exec(const char *name, const char **argv) {
    int argc = 0;
    while (argv[argc] != NULL) {
  800994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800997:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	75 e7                	jne    800990 <__exec+0xf>
        argc ++;
    }
    return sys_exec(name, argc, argv);
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 0f f8 ff ff       	call   8001c9 <sys_exec>
  8009ba:	83 c4 10             	add    $0x10,%esp
}
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  8009c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  8009cc:	eb 04                	jmp    8009d2 <strlen+0x13>
        cnt ++;
  8009ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8d 50 01             	lea    0x1(%eax),%edx
  8009d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009db:	0f b6 00             	movzbl (%eax),%eax
  8009de:	84 c0                	test   %al,%al
  8009e0:	75 ec                	jne    8009ce <strlen+0xf>
        cnt ++;
    }
    return cnt;
  8009e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  8009ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  8009f4:	eb 04                	jmp    8009fa <strnlen+0x13>
        cnt ++;
  8009f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  8009fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a00:	73 10                	jae    800a12 <strnlen+0x2b>
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8d 50 01             	lea    0x1(%eax),%edx
  800a08:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0b:	0f b6 00             	movzbl (%eax),%eax
  800a0e:	84 c0                	test   %al,%al
  800a10:	75 e4                	jne    8009f6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a15:	c9                   	leave  
  800a16:	c3                   	ret    

00800a17 <strcat>:
 * @dst:    pointer to the @dst array, which should be large enough to contain the concatenated
 *          resulting string.
 * @src:    string to be appended, this should not overlap @dst
 * */
char *
strcat(char *dst, const char *src) {
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	83 ec 08             	sub    $0x8,%esp
    return strcpy(dst + strlen(dst), src);
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 9a ff ff ff       	call   8009bf <strlen>
  800a25:	83 c4 04             	add    $0x4,%esp
  800a28:	89 c2                	mov    %eax,%edx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	e8 05 00 00 00       	call   800a40 <strcpy>
  800a3b:	83 c4 10             	add    $0x10,%esp
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	83 ec 20             	sub    $0x20,%esp
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a5a:	89 d1                	mov    %edx,%ecx
  800a5c:	89 c2                	mov    %eax,%edx
  800a5e:	89 ce                	mov    %ecx,%esi
  800a60:	89 d7                	mov    %edx,%edi
  800a62:	ac                   	lods   %ds:(%esi),%al
  800a63:	aa                   	stos   %al,%es:(%edi)
  800a64:	84 c0                	test   %al,%al
  800a66:	75 fa                	jne    800a62 <strcpy+0x22>
  800a68:	89 fa                	mov    %edi,%edx
  800a6a:	89 f1                	mov    %esi,%ecx
  800a6c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800a6f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  800a78:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800a79:	83 c4 20             	add    $0x20,%esp
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800a8c:	eb 21                	jmp    800aaf <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a91:	0f b6 10             	movzbl (%eax),%edx
  800a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a97:	88 10                	mov    %dl,(%eax)
  800a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a9c:	0f b6 00             	movzbl (%eax),%eax
  800a9f:	84 c0                	test   %al,%al
  800aa1:	74 04                	je     800aa7 <strncpy+0x27>
            src ++;
  800aa3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800aa7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800aab:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800aaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab3:	75 d9                	jne    800a8e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	83 ec 20             	sub    $0x20,%esp
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad4:	89 d1                	mov    %edx,%ecx
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	89 ce                	mov    %ecx,%esi
  800ada:	89 d7                	mov    %edx,%edi
  800adc:	ac                   	lods   %ds:(%esi),%al
  800add:	ae                   	scas   %es:(%edi),%al
  800ade:	75 08                	jne    800ae8 <strcmp+0x2e>
  800ae0:	84 c0                	test   %al,%al
  800ae2:	75 f8                	jne    800adc <strcmp+0x22>
  800ae4:	31 c0                	xor    %eax,%eax
  800ae6:	eb 04                	jmp    800aec <strcmp+0x32>
  800ae8:	19 c0                	sbb    %eax,%eax
  800aea:	0c 01                	or     $0x1,%al
  800aec:	89 fa                	mov    %edi,%edx
  800aee:	89 f1                	mov    %esi,%ecx
  800af0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800af6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  800afc:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800afd:	83 c4 20             	add    $0x20,%esp
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800b07:	eb 0c                	jmp    800b15 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800b09:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b11:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800b15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b19:	74 1a                	je     800b35 <strncmp+0x31>
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	0f b6 00             	movzbl (%eax),%eax
  800b21:	84 c0                	test   %al,%al
  800b23:	74 10                	je     800b35 <strncmp+0x31>
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	0f b6 10             	movzbl (%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	0f b6 00             	movzbl (%eax),%eax
  800b31:	38 c2                	cmp    %al,%dl
  800b33:	74 d4                	je     800b09 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b39:	74 18                	je     800b53 <strncmp+0x4f>
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	0f b6 00             	movzbl (%eax),%eax
  800b41:	0f b6 d0             	movzbl %al,%edx
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	0f b6 00             	movzbl (%eax),%eax
  800b4a:	0f b6 c0             	movzbl %al,%eax
  800b4d:	29 c2                	sub    %eax,%edx
  800b4f:	89 d0                	mov    %edx,%eax
  800b51:	eb 05                	jmp    800b58 <strncmp+0x54>
  800b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800b66:	eb 14                	jmp    800b7c <strchr+0x22>
        if (*s == c) {
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	0f b6 00             	movzbl (%eax),%eax
  800b6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b71:	75 05                	jne    800b78 <strchr+0x1e>
            return (char *)s;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	eb 13                	jmp    800b8b <strchr+0x31>
        }
        s ++;
  800b78:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	0f b6 00             	movzbl (%eax),%eax
  800b82:	84 c0                	test   %al,%al
  800b84:	75 e2                	jne    800b68 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 04             	sub    $0x4,%esp
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800b99:	eb 0f                	jmp    800baa <strfind+0x1d>
        if (*s == c) {
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	0f b6 00             	movzbl (%eax),%eax
  800ba1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba4:	74 10                	je     800bb6 <strfind+0x29>
            break;
        }
        s ++;
  800ba6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	0f b6 00             	movzbl (%eax),%eax
  800bb0:	84 c0                	test   %al,%al
  800bb2:	75 e7                	jne    800b9b <strfind+0xe>
  800bb4:	eb 01                	jmp    800bb7 <strfind+0x2a>
        if (*s == c) {
            break;
  800bb6:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800bc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800bc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800bd0:	eb 04                	jmp    800bd6 <strtol+0x1a>
        s ++;
  800bd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	0f b6 00             	movzbl (%eax),%eax
  800bdc:	3c 20                	cmp    $0x20,%al
  800bde:	74 f2                	je     800bd2 <strtol+0x16>
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	0f b6 00             	movzbl (%eax),%eax
  800be6:	3c 09                	cmp    $0x9,%al
  800be8:	74 e8                	je     800bd2 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	0f b6 00             	movzbl (%eax),%eax
  800bf0:	3c 2b                	cmp    $0x2b,%al
  800bf2:	75 06                	jne    800bfa <strtol+0x3e>
        s ++;
  800bf4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bf8:	eb 15                	jmp    800c0f <strtol+0x53>
    }
    else if (*s == '-') {
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	0f b6 00             	movzbl (%eax),%eax
  800c00:	3c 2d                	cmp    $0x2d,%al
  800c02:	75 0b                	jne    800c0f <strtol+0x53>
        s ++, neg = 1;
  800c04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c08:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800c0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c13:	74 06                	je     800c1b <strtol+0x5f>
  800c15:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c19:	75 24                	jne    800c3f <strtol+0x83>
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	0f b6 00             	movzbl (%eax),%eax
  800c21:	3c 30                	cmp    $0x30,%al
  800c23:	75 1a                	jne    800c3f <strtol+0x83>
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	83 c0 01             	add    $0x1,%eax
  800c2b:	0f b6 00             	movzbl (%eax),%eax
  800c2e:	3c 78                	cmp    $0x78,%al
  800c30:	75 0d                	jne    800c3f <strtol+0x83>
        s += 2, base = 16;
  800c32:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c36:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c3d:	eb 2a                	jmp    800c69 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800c3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c43:	75 17                	jne    800c5c <strtol+0xa0>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	0f b6 00             	movzbl (%eax),%eax
  800c4b:	3c 30                	cmp    $0x30,%al
  800c4d:	75 0d                	jne    800c5c <strtol+0xa0>
        s ++, base = 8;
  800c4f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c53:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c5a:	eb 0d                	jmp    800c69 <strtol+0xad>
    }
    else if (base == 0) {
  800c5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c60:	75 07                	jne    800c69 <strtol+0xad>
        base = 10;
  800c62:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	0f b6 00             	movzbl (%eax),%eax
  800c6f:	3c 2f                	cmp    $0x2f,%al
  800c71:	7e 1b                	jle    800c8e <strtol+0xd2>
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	0f b6 00             	movzbl (%eax),%eax
  800c79:	3c 39                	cmp    $0x39,%al
  800c7b:	7f 11                	jg     800c8e <strtol+0xd2>
            dig = *s - '0';
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	0f b6 00             	movzbl (%eax),%eax
  800c83:	0f be c0             	movsbl %al,%eax
  800c86:	83 e8 30             	sub    $0x30,%eax
  800c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c8c:	eb 48                	jmp    800cd6 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	0f b6 00             	movzbl (%eax),%eax
  800c94:	3c 60                	cmp    $0x60,%al
  800c96:	7e 1b                	jle    800cb3 <strtol+0xf7>
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	0f b6 00             	movzbl (%eax),%eax
  800c9e:	3c 7a                	cmp    $0x7a,%al
  800ca0:	7f 11                	jg     800cb3 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	0f b6 00             	movzbl (%eax),%eax
  800ca8:	0f be c0             	movsbl %al,%eax
  800cab:	83 e8 57             	sub    $0x57,%eax
  800cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cb1:	eb 23                	jmp    800cd6 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	0f b6 00             	movzbl (%eax),%eax
  800cb9:	3c 40                	cmp    $0x40,%al
  800cbb:	7e 3c                	jle    800cf9 <strtol+0x13d>
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	0f b6 00             	movzbl (%eax),%eax
  800cc3:	3c 5a                	cmp    $0x5a,%al
  800cc5:	7f 32                	jg     800cf9 <strtol+0x13d>
            dig = *s - 'A' + 10;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	0f b6 00             	movzbl (%eax),%eax
  800ccd:	0f be c0             	movsbl %al,%eax
  800cd0:	83 e8 37             	sub    $0x37,%eax
  800cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cdc:	7d 1a                	jge    800cf8 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  800cde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	01 d0                	add    %edx,%eax
  800cf0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800cf3:	e9 71 ff ff ff       	jmp    800c69 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  800cf8:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 08                	je     800d07 <strtol+0x14b>
        *endptr = (char *) s;
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800d07:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d0b:	74 07                	je     800d14 <strtol+0x158>
  800d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d10:	f7 d8                	neg    %eax
  800d12:	eb 03                	jmp    800d17 <strtol+0x15b>
  800d14:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	83 ec 24             	sub    $0x24,%esp
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800d26:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d30:	88 45 f7             	mov    %al,-0x9(%ebp)
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800d39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800d3c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800d40:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800d43:	89 d7                	mov    %edx,%edi
  800d45:	f3 aa                	rep stos %al,%es:(%edi)
  800d47:	89 fa                	mov    %edi,%edx
  800d49:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800d4c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d52:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800d53:	83 c4 24             	add    $0x24,%esp
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 30             	sub    $0x30,%esp
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d7a:	73 42                	jae    800dbe <memmove+0x65>
  800d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800d8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d91:	c1 e8 02             	shr    $0x2,%eax
  800d94:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800d96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	89 d7                	mov    %edx,%edi
  800d9e:	89 c6                	mov    %eax,%esi
  800da0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800da5:	83 e1 03             	and    $0x3,%ecx
  800da8:	74 02                	je     800dac <memmove+0x53>
  800daa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800dac:	89 f0                	mov    %esi,%eax
  800dae:	89 fa                	mov    %edi,%edx
  800db0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800db3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800db6:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  800dbc:	eb 36                	jmp    800df4 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800dbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc7:	01 c2                	add    %eax,%edx
  800dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dcc:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	89 d8                	mov    %ebx,%eax
  800ddc:	89 d6                	mov    %edx,%esi
  800dde:	89 c7                	mov    %eax,%edi
  800de0:	fd                   	std    
  800de1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800de3:	fc                   	cld    
  800de4:	89 f8                	mov    %edi,%eax
  800de6:	89 f2                	mov    %esi,%edx
  800de8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800deb:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800dee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  800df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800df4:	83 c4 30             	add    $0x30,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	83 ec 20             	sub    $0x20,%esp
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e10:	8b 45 10             	mov    0x10(%ebp),%eax
  800e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e19:	c1 e8 02             	shr    $0x2,%eax
  800e1c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e24:	89 d7                	mov    %edx,%edi
  800e26:	89 c6                	mov    %eax,%esi
  800e28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e2a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  800e2d:	83 e1 03             	and    $0x3,%ecx
  800e30:	74 02                	je     800e34 <memcpy+0x38>
  800e32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800e34:	89 f0                	mov    %esi,%eax
  800e36:	89 fa                	mov    %edi,%edx
  800e38:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800e3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  800e44:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800e45:	83 c4 20             	add    $0x20,%esp
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  800e5e:	eb 30                	jmp    800e90 <memcmp+0x44>
        if (*s1 != *s2) {
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	0f b6 10             	movzbl (%eax),%edx
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	0f b6 00             	movzbl (%eax),%eax
  800e6c:	38 c2                	cmp    %al,%dl
  800e6e:	74 18                	je     800e88 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	0f b6 00             	movzbl (%eax),%eax
  800e76:	0f b6 d0             	movzbl %al,%edx
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	0f b6 00             	movzbl (%eax),%eax
  800e7f:	0f b6 c0             	movzbl %al,%eax
  800e82:	29 c2                	sub    %eax,%edx
  800e84:	89 d0                	mov    %edx,%eax
  800e86:	eb 1a                	jmp    800ea2 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  800e88:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e8c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e96:	89 55 10             	mov    %edx,0x10(%ebp)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 c3                	jne    800e60 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*, int), int fd, void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 38             	sub    $0x38,%esp
  800eaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800ead:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800eb0:	8b 45 18             	mov    0x18(%ebp),%eax
  800eb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800eb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800eb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ebc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800ebf:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800ec2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ece:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ed1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ede:	74 1c                	je     800efc <printnum+0x58>
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee8:	f7 75 e4             	divl   -0x1c(%ebp)
  800eeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef6:	f7 75 e4             	divl   -0x1c(%ebp)
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f02:	f7 75 e4             	divl   -0x1c(%ebp)
  800f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f08:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800f14:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800f17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f1a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800f1d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f20:	ba 00 00 00 00       	mov    $0x0,%edx
  800f25:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800f28:	77 44                	ja     800f6e <printnum+0xca>
  800f2a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800f2d:	72 05                	jb     800f34 <printnum+0x90>
  800f2f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f32:	77 3a                	ja     800f6e <printnum+0xca>
        printnum(putch, fd, putdat, result, base, width - 1, padc);
  800f34:	8b 45 20             	mov    0x20(%ebp),%eax
  800f37:	83 e8 01             	sub    $0x1,%eax
  800f3a:	ff 75 24             	pushl  0x24(%ebp)
  800f3d:	50                   	push   %eax
  800f3e:	ff 75 1c             	pushl  0x1c(%ebp)
  800f41:	ff 75 ec             	pushl  -0x14(%ebp)
  800f44:	ff 75 e8             	pushl  -0x18(%ebp)
  800f47:	ff 75 10             	pushl  0x10(%ebp)
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	ff 75 08             	pushl  0x8(%ebp)
  800f50:	e8 4f ff ff ff       	call   800ea4 <printnum>
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	eb 1e                	jmp    800f78 <printnum+0xd4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat, fd);
  800f5a:	83 ec 04             	sub    $0x4,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	ff 75 10             	pushl  0x10(%ebp)
  800f63:	ff 75 24             	pushl  0x24(%ebp)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, fd, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800f6e:	83 6d 20 01          	subl   $0x1,0x20(%ebp)
  800f72:	83 7d 20 00          	cmpl   $0x0,0x20(%ebp)
  800f76:	7f e2                	jg     800f5a <printnum+0xb6>
            putch(padc, putdat, fd);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat, fd);
  800f78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f7b:	05 e4 20 80 00       	add    $0x8020e4,%eax
  800f80:	0f b6 00             	movzbl (%eax),%eax
  800f83:	0f be c0             	movsbl %al,%eax
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	ff 75 10             	pushl  0x10(%ebp)
  800f8f:	50                   	push   %eax
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	ff d0                	call   *%eax
  800f95:	83 c4 10             	add    $0x10,%esp
}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800f9e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800fa2:	7e 14                	jle    800fb8 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8b 00                	mov    (%eax),%eax
  800fa9:	8d 48 08             	lea    0x8(%eax),%ecx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	89 0a                	mov    %ecx,(%edx)
  800fb1:	8b 50 04             	mov    0x4(%eax),%edx
  800fb4:	8b 00                	mov    (%eax),%eax
  800fb6:	eb 30                	jmp    800fe8 <getuint+0x4d>
    }
    else if (lflag) {
  800fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fbc:	74 16                	je     800fd4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	8d 48 04             	lea    0x4(%eax),%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 0a                	mov    %ecx,(%edx)
  800fcb:	8b 00                	mov    (%eax),%eax
  800fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd2:	eb 14                	jmp    800fe8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8d 48 04             	lea    0x4(%eax),%ecx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	89 0a                	mov    %ecx,(%edx)
  800fe1:	8b 00                	mov    (%eax),%eax
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800fed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ff1:	7e 14                	jle    801007 <getint+0x1d>
        return va_arg(*ap, long long);
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8b 00                	mov    (%eax),%eax
  800ff8:	8d 48 08             	lea    0x8(%eax),%ecx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	89 0a                	mov    %ecx,(%edx)
  801000:	8b 50 04             	mov    0x4(%eax),%edx
  801003:	8b 00                	mov    (%eax),%eax
  801005:	eb 28                	jmp    80102f <getint+0x45>
    }
    else if (lflag) {
  801007:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100b:	74 12                	je     80101f <getint+0x35>
        return va_arg(*ap, long);
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8b 00                	mov    (%eax),%eax
  801012:	8d 48 04             	lea    0x4(%eax),%ecx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	89 0a                	mov    %ecx,(%edx)
  80101a:	8b 00                	mov    (%eax),%eax
  80101c:	99                   	cltd   
  80101d:	eb 10                	jmp    80102f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 04             	lea    0x4(%eax),%ecx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 00                	mov    (%eax),%eax
  80102e:	99                   	cltd   
    }
}
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <printfmt>:
 * @fd:         file descriptor
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, ...) {
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  801037:	8d 45 18             	lea    0x18(%ebp),%eax
  80103a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, fd, putdat, fmt, ap);
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	83 ec 0c             	sub    $0xc,%esp
  801043:	50                   	push   %eax
  801044:	ff 75 14             	pushl  0x14(%ebp)
  801047:	ff 75 10             	pushl  0x10(%ebp)
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	ff 75 08             	pushl  0x8(%ebp)
  801050:	e8 06 00 00 00       	call   80105b <vprintfmt>
  801055:	83 c4 20             	add    $0x20,%esp
    va_end(ap);
}
  801058:	90                   	nop
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, va_list ap) {
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  801063:	eb 1a                	jmp    80107f <vprintfmt+0x24>
            if (ch == '\0') {
  801065:	85 db                	test   %ebx,%ebx
  801067:	0f 84 be 03 00 00    	je     80142b <vprintfmt+0x3d0>
                return;
            }
            putch(ch, putdat, fd);
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	ff 75 10             	pushl  0x10(%ebp)
  801076:	53                   	push   %ebx
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	ff d0                	call   *%eax
  80107c:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	8d 50 01             	lea    0x1(%eax),%edx
  801085:	89 55 14             	mov    %edx,0x14(%ebp)
  801088:	0f b6 00             	movzbl (%eax),%eax
  80108b:	0f b6 d8             	movzbl %al,%ebx
  80108e:	83 fb 25             	cmp    $0x25,%ebx
  801091:	75 d2                	jne    801065 <vprintfmt+0xa>
            }
            putch(ch, putdat, fd);
        }

        // Process a %-escape sequence
        char padc = ' ';
  801093:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  801097:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80109e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  8010a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8010ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8010b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b4:	8d 50 01             	lea    0x1(%eax),%edx
  8010b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8010ba:	0f b6 00             	movzbl (%eax),%eax
  8010bd:	0f b6 d8             	movzbl %al,%ebx
  8010c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8010c3:	83 f8 55             	cmp    $0x55,%eax
  8010c6:	0f 87 2f 03 00 00    	ja     8013fb <vprintfmt+0x3a0>
  8010cc:	8b 04 85 08 21 80 00 	mov    0x802108(,%eax,4),%eax
  8010d3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  8010d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  8010d9:	eb d6                	jmp    8010b1 <vprintfmt+0x56>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  8010db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  8010df:	eb d0                	jmp    8010b1 <vprintfmt+0x56>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8010e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  8010e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010eb:	89 d0                	mov    %edx,%eax
  8010ed:	c1 e0 02             	shl    $0x2,%eax
  8010f0:	01 d0                	add    %edx,%eax
  8010f2:	01 c0                	add    %eax,%eax
  8010f4:	01 d8                	add    %ebx,%eax
  8010f6:	83 e8 30             	sub    $0x30,%eax
  8010f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  8010fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ff:	0f b6 00             	movzbl (%eax),%eax
  801102:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  801105:	83 fb 2f             	cmp    $0x2f,%ebx
  801108:	7e 39                	jle    801143 <vprintfmt+0xe8>
  80110a:	83 fb 39             	cmp    $0x39,%ebx
  80110d:	7f 34                	jg     801143 <vprintfmt+0xe8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  80110f:	83 45 14 01          	addl   $0x1,0x14(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  801113:	eb d3                	jmp    8010e8 <vprintfmt+0x8d>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  801115:	8b 45 18             	mov    0x18(%ebp),%eax
  801118:	8d 50 04             	lea    0x4(%eax),%edx
  80111b:	89 55 18             	mov    %edx,0x18(%ebp)
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  801123:	eb 1f                	jmp    801144 <vprintfmt+0xe9>

        case '.':
            if (width < 0)
  801125:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801129:	79 86                	jns    8010b1 <vprintfmt+0x56>
                width = 0;
  80112b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  801132:	e9 7a ff ff ff       	jmp    8010b1 <vprintfmt+0x56>

        case '#':
            altflag = 1;
  801137:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  80113e:	e9 6e ff ff ff       	jmp    8010b1 <vprintfmt+0x56>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  801143:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  801144:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801148:	0f 89 63 ff ff ff    	jns    8010b1 <vprintfmt+0x56>
                width = precision, precision = -1;
  80114e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801151:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801154:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  80115b:	e9 51 ff ff ff       	jmp    8010b1 <vprintfmt+0x56>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  801160:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  801164:	e9 48 ff ff ff       	jmp    8010b1 <vprintfmt+0x56>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat, fd);
  801169:	8b 45 18             	mov    0x18(%ebp),%eax
  80116c:	8d 50 04             	lea    0x4(%eax),%edx
  80116f:	89 55 18             	mov    %edx,0x18(%ebp)
  801172:	8b 00                	mov    (%eax),%eax
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	ff 75 10             	pushl  0x10(%ebp)
  80117d:	50                   	push   %eax
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	ff d0                	call   *%eax
  801183:	83 c4 10             	add    $0x10,%esp
            break;
  801186:	e9 9b 02 00 00       	jmp    801426 <vprintfmt+0x3cb>

        // error message
        case 'e':
            err = va_arg(ap, int);
  80118b:	8b 45 18             	mov    0x18(%ebp),%eax
  80118e:	8d 50 04             	lea    0x4(%eax),%edx
  801191:	89 55 18             	mov    %edx,0x18(%ebp)
  801194:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  801196:	85 db                	test   %ebx,%ebx
  801198:	79 02                	jns    80119c <vprintfmt+0x141>
                err = -err;
  80119a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80119c:	83 fb 18             	cmp    $0x18,%ebx
  80119f:	7f 0b                	jg     8011ac <vprintfmt+0x151>
  8011a1:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  8011a8:	85 f6                	test   %esi,%esi
  8011aa:	75 1f                	jne    8011cb <vprintfmt+0x170>
                printfmt(putch, fd, putdat, "error %d", err);
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	53                   	push   %ebx
  8011b0:	68 f5 20 80 00       	push   $0x8020f5
  8011b5:	ff 75 10             	pushl  0x10(%ebp)
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	ff 75 08             	pushl  0x8(%ebp)
  8011be:	e8 6e fe ff ff       	call   801031 <printfmt>
  8011c3:	83 c4 20             	add    $0x20,%esp
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
            }
            break;
  8011c6:	e9 5b 02 00 00       	jmp    801426 <vprintfmt+0x3cb>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, fd, putdat, "error %d", err);
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
  8011cb:	83 ec 0c             	sub    $0xc,%esp
  8011ce:	56                   	push   %esi
  8011cf:	68 fe 20 80 00       	push   $0x8020fe
  8011d4:	ff 75 10             	pushl  0x10(%ebp)
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	ff 75 08             	pushl  0x8(%ebp)
  8011dd:	e8 4f fe ff ff       	call   801031 <printfmt>
  8011e2:	83 c4 20             	add    $0x20,%esp
            }
            break;
  8011e5:	e9 3c 02 00 00       	jmp    801426 <vprintfmt+0x3cb>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  8011ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8011ed:	8d 50 04             	lea    0x4(%eax),%edx
  8011f0:	89 55 18             	mov    %edx,0x18(%ebp)
  8011f3:	8b 30                	mov    (%eax),%esi
  8011f5:	85 f6                	test   %esi,%esi
  8011f7:	75 05                	jne    8011fe <vprintfmt+0x1a3>
                p = "(null)";
  8011f9:	be 01 21 80 00       	mov    $0x802101,%esi
            }
            if (width > 0 && padc != '-') {
  8011fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801202:	7e 7f                	jle    801283 <vprintfmt+0x228>
  801204:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801208:	74 79                	je     801283 <vprintfmt+0x228>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80120a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	50                   	push   %eax
  801211:	56                   	push   %esi
  801212:	e8 d0 f7 ff ff       	call   8009e7 <strnlen>
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	89 c2                	mov    %eax,%edx
  80121c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80121f:	29 d0                	sub    %edx,%eax
  801221:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801224:	eb 1a                	jmp    801240 <vprintfmt+0x1e5>
                    putch(padc, putdat, fd);
  801226:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 10             	pushl  0x10(%ebp)
  801233:	50                   	push   %eax
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	ff d0                	call   *%eax
  801239:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  80123c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  801240:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801244:	7f e0                	jg     801226 <vprintfmt+0x1cb>
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  801246:	eb 3b                	jmp    801283 <vprintfmt+0x228>
                if (altflag && (ch < ' ' || ch > '~')) {
  801248:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80124c:	74 1f                	je     80126d <vprintfmt+0x212>
  80124e:	83 fb 1f             	cmp    $0x1f,%ebx
  801251:	7e 05                	jle    801258 <vprintfmt+0x1fd>
  801253:	83 fb 7e             	cmp    $0x7e,%ebx
  801256:	7e 15                	jle    80126d <vprintfmt+0x212>
                    putch('?', putdat, fd);
  801258:	83 ec 04             	sub    $0x4,%esp
  80125b:	ff 75 0c             	pushl  0xc(%ebp)
  80125e:	ff 75 10             	pushl  0x10(%ebp)
  801261:	6a 3f                	push   $0x3f
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	ff d0                	call   *%eax
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	eb 12                	jmp    80127f <vprintfmt+0x224>
                }
                else {
                    putch(ch, putdat, fd);
  80126d:	83 ec 04             	sub    $0x4,%esp
  801270:	ff 75 0c             	pushl  0xc(%ebp)
  801273:	ff 75 10             	pushl  0x10(%ebp)
  801276:	53                   	push   %ebx
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	ff d0                	call   *%eax
  80127c:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80127f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	8d 70 01             	lea    0x1(%eax),%esi
  801288:	0f b6 00             	movzbl (%eax),%eax
  80128b:	0f be d8             	movsbl %al,%ebx
  80128e:	85 db                	test   %ebx,%ebx
  801290:	74 29                	je     8012bb <vprintfmt+0x260>
  801292:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801296:	78 b0                	js     801248 <vprintfmt+0x1ed>
  801298:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80129c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a0:	79 a6                	jns    801248 <vprintfmt+0x1ed>
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  8012a2:	eb 17                	jmp    8012bb <vprintfmt+0x260>
                putch(' ', putdat, fd);
  8012a4:	83 ec 04             	sub    $0x4,%esp
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	ff 75 10             	pushl  0x10(%ebp)
  8012ad:	6a 20                	push   $0x20
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	ff d0                	call   *%eax
  8012b4:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  8012b7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8012bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8012bf:	7f e3                	jg     8012a4 <vprintfmt+0x249>
                putch(' ', putdat, fd);
            }
            break;
  8012c1:	e9 60 01 00 00       	jmp    801426 <vprintfmt+0x3cb>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  8012c6:	83 ec 08             	sub    $0x8,%esp
  8012c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8012cc:	8d 45 18             	lea    0x18(%ebp),%eax
  8012cf:	50                   	push   %eax
  8012d0:	e8 15 fd ff ff       	call   800fea <getint>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012db:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  8012de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e4:	85 d2                	test   %edx,%edx
  8012e6:	79 26                	jns    80130e <vprintfmt+0x2b3>
                putch('-', putdat, fd);
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	ff 75 10             	pushl  0x10(%ebp)
  8012f1:	6a 2d                	push   $0x2d
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  8012fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801301:	f7 d8                	neg    %eax
  801303:	83 d2 00             	adc    $0x0,%edx
  801306:	f7 da                	neg    %edx
  801308:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80130b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  80130e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  801315:	e9 a8 00 00 00       	jmp    8013c2 <vprintfmt+0x367>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	ff 75 e0             	pushl  -0x20(%ebp)
  801320:	8d 45 18             	lea    0x18(%ebp),%eax
  801323:	50                   	push   %eax
  801324:	e8 72 fc ff ff       	call   800f9b <getuint>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80132f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  801332:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  801339:	e9 84 00 00 00       	jmp    8013c2 <vprintfmt+0x367>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	ff 75 e0             	pushl  -0x20(%ebp)
  801344:	8d 45 18             	lea    0x18(%ebp),%eax
  801347:	50                   	push   %eax
  801348:	e8 4e fc ff ff       	call   800f9b <getuint>
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801353:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  801356:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  80135d:	eb 63                	jmp    8013c2 <vprintfmt+0x367>

        // pointer
        case 'p':
            putch('0', putdat, fd);
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	ff 75 10             	pushl  0x10(%ebp)
  801368:	6a 30                	push   $0x30
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	ff d0                	call   *%eax
  80136f:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat, fd);
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	ff 75 10             	pushl  0x10(%ebp)
  80137b:	6a 78                	push   $0x78
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	ff d0                	call   *%eax
  801382:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  801385:	8b 45 18             	mov    0x18(%ebp),%eax
  801388:	8d 50 04             	lea    0x4(%eax),%edx
  80138b:	89 55 18             	mov    %edx,0x18(%ebp)
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  80139a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  8013a1:	eb 1f                	jmp    8013c2 <vprintfmt+0x367>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  8013a3:	83 ec 08             	sub    $0x8,%esp
  8013a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8013a9:	8d 45 18             	lea    0x18(%ebp),%eax
  8013ac:	50                   	push   %eax
  8013ad:	e8 e9 fb ff ff       	call   800f9b <getuint>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  8013bb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, fd, putdat, num, base, width, padc);
  8013c2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8013c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c9:	52                   	push   %edx
  8013ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d4:	ff 75 10             	pushl  0x10(%ebp)
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 c2 fa ff ff       	call   800ea4 <printnum>
  8013e2:	83 c4 20             	add    $0x20,%esp
            break;
  8013e5:	eb 3f                	jmp    801426 <vprintfmt+0x3cb>

        // escaped '%' character
        case '%':
            putch(ch, putdat, fd);
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	ff 75 10             	pushl  0x10(%ebp)
  8013f0:	53                   	push   %ebx
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	ff d0                	call   *%eax
  8013f6:	83 c4 10             	add    $0x10,%esp
            break;
  8013f9:	eb 2b                	jmp    801426 <vprintfmt+0x3cb>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat, fd);
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	ff 75 10             	pushl  0x10(%ebp)
  801404:	6a 25                	push   $0x25
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	ff d0                	call   *%eax
  80140b:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  80140e:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  801412:	eb 04                	jmp    801418 <vprintfmt+0x3bd>
  801414:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  801418:	8b 45 14             	mov    0x14(%ebp),%eax
  80141b:	83 e8 01             	sub    $0x1,%eax
  80141e:	0f b6 00             	movzbl (%eax),%eax
  801421:	3c 25                	cmp    $0x25,%al
  801423:	75 ef                	jne    801414 <vprintfmt+0x3b9>
                /* do nothing */;
            break;
  801425:	90                   	nop
        }
    }
  801426:	e9 38 fc ff ff       	jmp    801063 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  80142b:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142f:	5b                   	pop    %ebx
  801430:	5e                   	pop    %esi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	8b 40 08             	mov    0x8(%eax),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	8b 10                	mov    (%eax),%edx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	39 c2                	cmp    %eax,%edx
  801452:	73 12                	jae    801466 <sprintputch+0x33>
        *b->buf ++ = ch;
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	8b 00                	mov    (%eax),%eax
  801459:	8d 48 01             	lea    0x1(%eax),%ecx
  80145c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145f:	89 0a                	mov    %ecx,(%edx)
  801461:	8b 55 08             	mov    0x8(%ebp),%edx
  801464:	88 10                	mov    %dl,(%eax)
    }
}
  801466:	90                   	nop
  801467:	5d                   	pop    %ebp
  801468:	c3                   	ret    

00801469 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  80146f:	8d 45 14             	lea    0x14(%ebp),%eax
  801472:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 75 10             	pushl  0x10(%ebp)
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	ff 75 08             	pushl  0x8(%ebp)
  801482:	e8 0b 00 00 00       	call   801492 <vsnprintf>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80149e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	01 d0                	add    %edx,%eax
  8014a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  8014b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b7:	74 0a                	je     8014c3 <vsnprintf+0x31>
  8014b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bf:	39 c2                	cmp    %eax,%edx
  8014c1:	76 07                	jbe    8014ca <vsnprintf+0x38>
        return -E_INVAL;
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb 28                	jmp    8014f2 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, NO_FD, &b, fmt, ap);
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	ff 75 14             	pushl  0x14(%ebp)
  8014d0:	ff 75 10             	pushl  0x10(%ebp)
  8014d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	68 d9 6a ff ff       	push   $0xffff6ad9
  8014dc:	68 33 14 80 00       	push   $0x801433
  8014e1:	e8 75 fb ff ff       	call   80105b <vprintfmt>
  8014e6:	83 c4 20             	add    $0x20,%esp
    // null terminate the buffer
    *b.buf = '\0';
  8014e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ec:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  801503:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
  801506:	b8 20 00 00 00       	mov    $0x20,%eax
  80150b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80150e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801511:	89 c1                	mov    %eax,%ecx
  801513:	d3 ea                	shr    %cl,%edx
  801515:	89 d0                	mov    %edx,%eax
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	57                   	push   %edi
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  801522:	a1 08 30 80 00       	mov    0x803008,%eax
  801527:	8b 15 0c 30 80 00    	mov    0x80300c,%edx
  80152d:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  801533:	6b f0 05             	imul   $0x5,%eax,%esi
  801536:	01 fe                	add    %edi,%esi
  801538:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
  80153d:	f7 e7                	mul    %edi
  80153f:	01 d6                	add    %edx,%esi
  801541:	89 f2                	mov    %esi,%edx
  801543:	83 c0 0b             	add    $0xb,%eax
  801546:	83 d2 00             	adc    $0x0,%edx
  801549:	89 c7                	mov    %eax,%edi
  80154b:	83 e7 ff             	and    $0xffffffff,%edi
  80154e:	89 f9                	mov    %edi,%ecx
  801550:	0f b7 da             	movzwl %dx,%ebx
  801553:	89 0d 08 30 80 00    	mov    %ecx,0x803008
  801559:	89 1d 0c 30 80 00    	mov    %ebx,0x80300c
    unsigned long long result = (next >> 12);
  80155f:	a1 08 30 80 00       	mov    0x803008,%eax
  801564:	8b 15 0c 30 80 00    	mov    0x80300c,%edx
  80156a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  80156e:	c1 ea 0c             	shr    $0xc,%edx
  801571:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801574:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  801577:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  80157e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801581:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801584:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801587:	89 55 e8             	mov    %edx,-0x18(%ebp)
  80158a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801594:	74 1c                	je     8015b2 <rand+0x99>
  801596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801599:	ba 00 00 00 00       	mov    $0x0,%edx
  80159e:	f7 75 dc             	divl   -0x24(%ebp)
  8015a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8015a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	f7 75 dc             	divl   -0x24(%ebp)
  8015af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b8:	f7 75 dc             	divl   -0x24(%ebp)
  8015bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8015c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8015cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  8015d0:	83 c4 24             	add    $0x24,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
    next = seed;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	a3 08 30 80 00       	mov    %eax,0x803008
  8015e8:	89 15 0c 30 80 00    	mov    %edx,0x80300c
}
  8015ee:	90                   	nop
  8015ef:	5d                   	pop    %ebp
  8015f0:	c3                   	ret    

008015f1 <gettoken>:
#define SYMBOLS                         "<|>&;"

char shcwd[BUFSIZE];

int
gettoken(char **p1, char **p2) {
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 18             	sub    $0x18,%esp
    char *s;
    if ((s = *p1) == NULL) {
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8b 00                	mov    (%eax),%eax
  8015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801603:	75 16                	jne    80161b <gettoken+0x2a>
        return 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	e9 f9 00 00 00       	jmp    801708 <gettoken+0x117>
    }
    while (strchr(WHITESPACE, *s) != NULL) {
        *s ++ = '\0';
  80160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801612:	8d 50 01             	lea    0x1(%eax),%edx
  801615:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801618:	c6 00 00             	movb   $0x0,(%eax)
gettoken(char **p1, char **p2) {
    char *s;
    if ((s = *p1) == NULL) {
        return 0;
    }
    while (strchr(WHITESPACE, *s) != NULL) {
  80161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161e:	0f b6 00             	movzbl (%eax),%eax
  801621:	0f be c0             	movsbl %al,%eax
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	50                   	push   %eax
  801628:	68 60 22 80 00       	push   $0x802260
  80162d:	e8 28 f5 ff ff       	call   800b5a <strchr>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	75 d6                	jne    80160f <gettoken+0x1e>
        *s ++ = '\0';
    }
    if (*s == '\0') {
  801639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163c:	0f b6 00             	movzbl (%eax),%eax
  80163f:	84 c0                	test   %al,%al
  801641:	75 0a                	jne    80164d <gettoken+0x5c>
        return 0;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	e9 bb 00 00 00       	jmp    801708 <gettoken+0x117>
    }

    *p2 = s;
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801653:	89 10                	mov    %edx,(%eax)
    int token = 'w';
  801655:	c7 45 f0 77 00 00 00 	movl   $0x77,-0x10(%ebp)
    if (strchr(SYMBOLS, *s) != NULL) {
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	0f b6 00             	movzbl (%eax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	50                   	push   %eax
  801669:	68 65 22 80 00       	push   $0x802265
  80166e:	e8 e7 f4 ff ff       	call   800b5a <strchr>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	74 1a                	je     801694 <gettoken+0xa3>
        token = *s, *s ++ = '\0';
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	0f b6 00             	movzbl (%eax),%eax
  801680:	0f be c0             	movsbl %al,%eax
  801683:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801689:	8d 50 01             	lea    0x1(%eax),%edx
  80168c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80168f:	c6 00 00             	movb   $0x0,(%eax)
  801692:	eb 58                	jmp    8016ec <gettoken+0xfb>
    }
    else {
        bool flag = 0;
  801694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
        while (*s != '\0' && (flag || strchr(WHITESPACE SYMBOLS, *s) == NULL)) {
  80169b:	eb 21                	jmp    8016be <gettoken+0xcd>
            if (*s == '"') {
  80169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a0:	0f b6 00             	movzbl (%eax),%eax
  8016a3:	3c 22                	cmp    $0x22,%al
  8016a5:	75 13                	jne    8016ba <gettoken+0xc9>
                *s = ' ', flag = !flag;
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	c6 00 20             	movb   $0x20,(%eax)
  8016ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016b1:	0f 94 c0             	sete   %al
  8016b4:	0f b6 c0             	movzbl %al,%eax
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            }
            s ++;
  8016ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if (strchr(SYMBOLS, *s) != NULL) {
        token = *s, *s ++ = '\0';
    }
    else {
        bool flag = 0;
        while (*s != '\0' && (flag || strchr(WHITESPACE SYMBOLS, *s) == NULL)) {
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	0f b6 00             	movzbl (%eax),%eax
  8016c4:	84 c0                	test   %al,%al
  8016c6:	74 24                	je     8016ec <gettoken+0xfb>
  8016c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016cc:	75 cf                	jne    80169d <gettoken+0xac>
  8016ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d1:	0f b6 00             	movzbl (%eax),%eax
  8016d4:	0f be c0             	movsbl %al,%eax
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	50                   	push   %eax
  8016db:	68 6b 22 80 00       	push   $0x80226b
  8016e0:	e8 75 f4 ff ff       	call   800b5a <strchr>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 b1                	je     80169d <gettoken+0xac>
                *s = ' ', flag = !flag;
            }
            s ++;
        }
    }
    *p1 = (*s != '\0' ? s : NULL);
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	0f b6 00             	movzbl (%eax),%eax
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 05                	je     8016fb <gettoken+0x10a>
  8016f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f9:	eb 05                	jmp    801700 <gettoken+0x10f>
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	8b 55 08             	mov    0x8(%ebp),%edx
  801703:	89 02                	mov    %eax,(%edx)
    return token;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <readline>:

char *
readline(const char *prompt) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
    static char buffer[BUFSIZE];
    if (prompt != NULL) {
  801710:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801714:	74 15                	je     80172b <readline+0x21>
        printf("%s", prompt);
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	68 75 22 80 00       	push   $0x802275
  801721:	6a 01                	push   $0x1
  801723:	e8 80 ef ff ff       	call   8006a8 <fprintf>
  801728:	83 c4 10             	add    $0x10,%esp
    }
    int ret, i = 0;
  80172b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        char c;
        if ((ret = read(0, &c, sizeof(char))) < 0) {
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	6a 01                	push   $0x1
  801737:	8d 45 ef             	lea    -0x11(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	6a 00                	push   $0x0
  80173d:	e8 99 ec ff ff       	call   8003db <read>
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174c:	79 0a                	jns    801758 <readline+0x4e>
            return NULL;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
  801753:	e9 eb 00 00 00       	jmp    801843 <readline+0x139>
        }
        else if (ret == 0) {
  801758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175c:	75 20                	jne    80177e <readline+0x74>
            if (i > 0) {
  80175e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801762:	7e 10                	jle    801774 <readline+0x6a>
                buffer[i] = '\0';
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	05 40 30 80 00       	add    $0x803040,%eax
  80176c:	c6 00 00             	movb   $0x0,(%eax)
                break;
  80176f:	e9 ca 00 00 00       	jmp    80183e <readline+0x134>
            }
            return NULL;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	e9 c5 00 00 00       	jmp    801843 <readline+0x139>
        }

        if (c == 3) {
  80177e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  801782:	3c 03                	cmp    $0x3,%al
  801784:	75 0a                	jne    801790 <readline+0x86>
            return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	e9 b3 00 00 00       	jmp    801843 <readline+0x139>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  801790:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  801794:	3c 1f                	cmp    $0x1f,%al
  801796:	7e 38                	jle    8017d0 <readline+0xc6>
  801798:	81 7d f4 fe 0f 00 00 	cmpl   $0xffe,-0xc(%ebp)
  80179f:	7f 2f                	jg     8017d0 <readline+0xc6>
            putc(c);
  8017a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  8017a5:	0f be c0             	movsbl %al,%eax
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	50                   	push   %eax
  8017ac:	68 78 22 80 00       	push   $0x802278
  8017b1:	6a 01                	push   $0x1
  8017b3:	e8 f0 ee ff ff       	call   8006a8 <fprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
            buffer[i ++] = c;
  8017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8017c4:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
  8017c8:	88 90 40 30 80 00    	mov    %dl,0x803040(%eax)
  8017ce:	eb 69                	jmp    801839 <readline+0x12f>
        }
        else if (c == '\b' && i > 0) {
  8017d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  8017d4:	3c 08                	cmp    $0x8,%al
  8017d6:	75 26                	jne    8017fe <readline+0xf4>
  8017d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017dc:	7e 20                	jle    8017fe <readline+0xf4>
            putc(c);
  8017de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  8017e2:	0f be c0             	movsbl %al,%eax
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	50                   	push   %eax
  8017e9:	68 78 22 80 00       	push   $0x802278
  8017ee:	6a 01                	push   $0x1
  8017f0:	e8 b3 ee ff ff       	call   8006a8 <fprintf>
  8017f5:	83 c4 10             	add    $0x10,%esp
            i --;
  8017f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  8017fc:	eb 3b                	jmp    801839 <readline+0x12f>
        }
        else if (c == '\n' || c == '\r') {
  8017fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  801802:	3c 0a                	cmp    $0xa,%al
  801804:	74 0c                	je     801812 <readline+0x108>
  801806:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  80180a:	3c 0d                	cmp    $0xd,%al
  80180c:	0f 85 20 ff ff ff    	jne    801732 <readline+0x28>
            putc(c);
  801812:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  801816:	0f be c0             	movsbl %al,%eax
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	50                   	push   %eax
  80181d:	68 78 22 80 00       	push   $0x802278
  801822:	6a 01                	push   $0x1
  801824:	e8 7f ee ff ff       	call   8006a8 <fprintf>
  801829:	83 c4 10             	add    $0x10,%esp
            buffer[i] = '\0';
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	05 40 30 80 00       	add    $0x803040,%eax
  801834:	c6 00 00             	movb   $0x0,(%eax)
            break;
  801837:	eb 05                	jmp    80183e <readline+0x134>
        }
    }
  801839:	e9 f4 fe ff ff       	jmp    801732 <readline+0x28>
    return buffer;
  80183e:	b8 40 30 80 00       	mov    $0x803040,%eax
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <usage>:

void
usage(void) {
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
    printf("usage: sh [command-file]\n");
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	68 7b 22 80 00       	push   $0x80227b
  801853:	6a 01                	push   $0x1
  801855:	e8 4e ee ff ff       	call   8006a8 <fprintf>
  80185a:	83 c4 10             	add    $0x10,%esp
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <reopen>:

int
reopen(int fd2, const char *filename, uint32_t open_flags) {
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 18             	sub    $0x18,%esp
    int ret, fd1;
    close(fd2);
  801866:	83 ec 0c             	sub    $0xc,%esp
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	e8 54 eb ff ff       	call   8003c5 <close>
  801871:	83 c4 10             	add    $0x10,%esp
    if ((ret = open(filename, open_flags)) >= 0 && ret != fd2) {
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	ff 75 10             	pushl  0x10(%ebp)
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	e8 2a eb ff ff       	call   8003ac <open>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80188c:	78 3e                	js     8018cc <reopen+0x6c>
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	3b 45 08             	cmp    0x8(%ebp),%eax
  801894:	74 36                	je     8018cc <reopen+0x6c>
        close(fd2);
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	e8 24 eb ff ff       	call   8003c5 <close>
  8018a1:	83 c4 10             	add    $0x10,%esp
        fd1 = ret, ret = dup2(fd1, fd2);
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b3:	e8 a6 eb ff ff       	call   80045e <dup2>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        close(fd1);
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018c4:	e8 fc ea ff ff       	call   8003c5 <close>
  8018c9:	83 c4 10             	add    $0x10,%esp
    }
    return ret < 0 ? ret : 0;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018d5:	0f 4e 45 f4          	cmovle -0xc(%ebp),%eax
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <testfile>:

int
testfile(const char *name) {
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 18             	sub    $0x18,%esp
    int ret;
    if ((ret = open(name, O_RDONLY)) < 0) {
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	e8 be ea ff ff       	call   8003ac <open>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018f8:	79 05                	jns    8018ff <testfile+0x24>
        return ret;
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	eb 13                	jmp    801912 <testfile+0x37>
    }
    close(ret);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 75 f4             	pushl  -0xc(%ebp)
  801905:	e8 bb ea ff ff       	call   8003c5 <close>
  80190a:	83 c4 10             	add    $0x10,%esp
    return 0;
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <runcmd>:

int
runcmd(char *cmd) {
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    static char argv0[BUFSIZE];
    const char *argv[EXEC_MAX_ARG_NUM + 1];
    char *t;
    int argc, token, ret, p[2];
again:
    argc = 0;
  80191d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        switch (token = gettoken(&cmd, &t)) {
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  80192d:	50                   	push   %eax
  80192e:	8d 45 08             	lea    0x8(%ebp),%eax
  801931:	50                   	push   %eax
  801932:	e8 ba fc ff ff       	call   8015f1 <gettoken>
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801940:	83 f8 3c             	cmp    $0x3c,%eax
  801943:	74 74                	je     8019b9 <runcmd+0xa5>
  801945:	83 f8 3c             	cmp    $0x3c,%eax
  801948:	7f 16                	jg     801960 <runcmd+0x4c>
  80194a:	85 c0                	test   %eax,%eax
  80194c:	0f 84 56 02 00 00    	je     801ba8 <runcmd+0x294>
  801952:	83 f8 3b             	cmp    $0x3b,%eax
  801955:	0f 84 f1 01 00 00    	je     801b4c <runcmd+0x238>
  80195b:	e9 1d 02 00 00       	jmp    801b7d <runcmd+0x269>
  801960:	83 f8 77             	cmp    $0x77,%eax
  801963:	74 17                	je     80197c <runcmd+0x68>
  801965:	83 f8 7c             	cmp    $0x7c,%eax
  801968:	0f 84 0f 01 00 00    	je     801a7d <runcmd+0x169>
  80196e:	83 f8 3e             	cmp    $0x3e,%eax
  801971:	0f 84 a4 00 00 00    	je     801a1b <runcmd+0x107>
  801977:	e9 01 02 00 00       	jmp    801b7d <runcmd+0x269>
        case 'w':
            if (argc == EXEC_MAX_ARG_NUM) {
  80197c:	83 7d f4 20          	cmpl   $0x20,-0xc(%ebp)
  801980:	75 1c                	jne    80199e <runcmd+0x8a>
                printf("sh error: too many arguments\n");
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	68 95 22 80 00       	push   $0x802295
  80198a:	6a 01                	push   $0x1
  80198c:	e8 17 ed ff ff       	call   8006a8 <fprintf>
  801991:	83 c4 10             	add    $0x10,%esp
                return -1;
  801994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801999:	e9 d7 02 00 00       	jmp    801c75 <runcmd+0x361>
            }
            argv[argc ++] = t;
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	8d 50 01             	lea    0x1(%eax),%edx
  8019a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8019a7:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8019ad:	89 94 85 68 ff ff ff 	mov    %edx,-0x98(%ebp,%eax,4)
            break;
  8019b4:	e9 ea 01 00 00       	jmp    801ba3 <runcmd+0x28f>
        case '<':
            if (gettoken(&cmd, &t) != 'w') {
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	8d 45 08             	lea    0x8(%ebp),%eax
  8019c6:	50                   	push   %eax
  8019c7:	e8 25 fc ff ff       	call   8015f1 <gettoken>
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	83 f8 77             	cmp    $0x77,%eax
  8019d2:	74 1c                	je     8019f0 <runcmd+0xdc>
                printf("sh error: syntax error: < not followed by word\n");
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	68 b4 22 80 00       	push   $0x8022b4
  8019dc:	6a 01                	push   $0x1
  8019de:	e8 c5 ec ff ff       	call   8006a8 <fprintf>
  8019e3:	83 c4 10             	add    $0x10,%esp
                return -1;
  8019e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8019eb:	e9 85 02 00 00       	jmp    801c75 <runcmd+0x361>
            }
            if ((ret = reopen(0, t, O_RDONLY)) != 0) {
  8019f0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	6a 00                	push   $0x0
  8019fb:	50                   	push   %eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	e8 5d fe ff ff       	call   801860 <reopen>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a0d:	0f 84 89 01 00 00    	je     801b9c <runcmd+0x288>
                return ret;
  801a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a16:	e9 5a 02 00 00       	jmp    801c75 <runcmd+0x361>
            }
            break;
        case '>':
            if (gettoken(&cmd, &t) != 'w') {
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	8d 45 08             	lea    0x8(%ebp),%eax
  801a28:	50                   	push   %eax
  801a29:	e8 c3 fb ff ff       	call   8015f1 <gettoken>
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	83 f8 77             	cmp    $0x77,%eax
  801a34:	74 1c                	je     801a52 <runcmd+0x13e>
                printf("sh error: syntax error: > not followed by word\n");
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	68 e4 22 80 00       	push   $0x8022e4
  801a3e:	6a 01                	push   $0x1
  801a40:	e8 63 ec ff ff       	call   8006a8 <fprintf>
  801a45:	83 c4 10             	add    $0x10,%esp
                return -1;
  801a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801a4d:	e9 23 02 00 00       	jmp    801c75 <runcmd+0x361>
            }
            if ((ret = reopen(1, t, O_RDWR | O_TRUNC | O_CREAT)) != 0) {
  801a52:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	6a 16                	push   $0x16
  801a5d:	50                   	push   %eax
  801a5e:	6a 01                	push   $0x1
  801a60:	e8 fb fd ff ff       	call   801860 <reopen>
  801a65:	83 c4 10             	add    $0x10,%esp
  801a68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a6f:	0f 84 2d 01 00 00    	je     801ba2 <runcmd+0x28e>
                return ret;
  801a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a78:	e9 f8 01 00 00       	jmp    801c75 <runcmd+0x361>
            break;
        case '|':
          //  if ((ret = pipe(p)) != 0) {
          //      return ret;
          //  }
            if ((ret = fork()) == 0) {
  801a7d:	e8 49 ee ff ff       	call   8008cb <fork>
  801a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a89:	75 5b                	jne    801ae6 <runcmd+0x1d2>
                close(0);
  801a8b:	83 ec 0c             	sub    $0xc,%esp
  801a8e:	6a 00                	push   $0x0
  801a90:	e8 30 e9 ff ff       	call   8003c5 <close>
  801a95:	83 c4 10             	add    $0x10,%esp
                if ((ret = dup2(p[0], 0)) < 0) {
  801a98:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801a9e:	83 ec 08             	sub    $0x8,%esp
  801aa1:	6a 00                	push   $0x0
  801aa3:	50                   	push   %eax
  801aa4:	e8 b5 e9 ff ff       	call   80045e <dup2>
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab3:	79 08                	jns    801abd <runcmd+0x1a9>
                    return ret;
  801ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab8:	e9 b8 01 00 00       	jmp    801c75 <runcmd+0x361>
                }
                close(p[0]), close(p[1]);
  801abd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	50                   	push   %eax
  801ac7:	e8 f9 e8 ff ff       	call   8003c5 <close>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	50                   	push   %eax
  801ad9:	e8 e7 e8 ff ff       	call   8003c5 <close>
  801ade:	83 c4 10             	add    $0x10,%esp
                goto again;
  801ae1:	e9 37 fe ff ff       	jmp    80191d <runcmd+0x9>
            }
            else {
                if (ret < 0) {
  801ae6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aea:	79 08                	jns    801af4 <runcmd+0x1e0>
                    return ret;
  801aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aef:	e9 81 01 00 00       	jmp    801c75 <runcmd+0x361>
                }
                close(1);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	6a 01                	push   $0x1
  801af9:	e8 c7 e8 ff ff       	call   8003c5 <close>
  801afe:	83 c4 10             	add    $0x10,%esp
                if ((ret = dup2(p[1], 1)) < 0) {
  801b01:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	6a 01                	push   $0x1
  801b0c:	50                   	push   %eax
  801b0d:	e8 4c e9 ff ff       	call   80045e <dup2>
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b1c:	79 08                	jns    801b26 <runcmd+0x212>
                    return ret;
  801b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b21:	e9 4f 01 00 00       	jmp    801c75 <runcmd+0x361>
                }
                close(p[0]), close(p[1]);
  801b26:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	50                   	push   %eax
  801b30:	e8 90 e8 ff ff       	call   8003c5 <close>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	50                   	push   %eax
  801b42:	e8 7e e8 ff ff       	call   8003c5 <close>
  801b47:	83 c4 10             	add    $0x10,%esp
                goto runit;
  801b4a:	eb 60                	jmp    801bac <runcmd+0x298>
            }
            break;
        case 0:
            goto runit;
        case ';':
            if ((ret = fork()) == 0) {
  801b4c:	e8 7a ed ff ff       	call   8008cb <fork>
  801b51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b58:	74 51                	je     801bab <runcmd+0x297>
                goto runit;
            }
            else {
                if (ret < 0) {
  801b5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b5e:	79 08                	jns    801b68 <runcmd+0x254>
                    return ret;
  801b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b63:	e9 0d 01 00 00       	jmp    801c75 <runcmd+0x361>
                }
                waitpid(ret, NULL);
  801b68:	83 ec 08             	sub    $0x8,%esp
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 ec             	pushl  -0x14(%ebp)
  801b70:	e8 7a ed ff ff       	call   8008ef <waitpid>
  801b75:	83 c4 10             	add    $0x10,%esp
                goto again;
  801b78:	e9 a0 fd ff ff       	jmp    80191d <runcmd+0x9>
            }
            break;
        default:
            printf("sh error: bad return %d from gettoken\n", token);
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	ff 75 f0             	pushl  -0x10(%ebp)
  801b83:	68 14 23 80 00       	push   $0x802314
  801b88:	6a 01                	push   $0x1
  801b8a:	e8 19 eb ff ff       	call   8006a8 <fprintf>
  801b8f:	83 c4 10             	add    $0x10,%esp
            return -1;
  801b92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b97:	e9 d9 00 00 00       	jmp    801c75 <runcmd+0x361>
                return -1;
            }
            if ((ret = reopen(0, t, O_RDONLY)) != 0) {
                return ret;
            }
            break;
  801b9c:	90                   	nop
  801b9d:	e9 82 fd ff ff       	jmp    801924 <runcmd+0x10>
                return -1;
            }
            if ((ret = reopen(1, t, O_RDWR | O_TRUNC | O_CREAT)) != 0) {
                return ret;
            }
            break;
  801ba2:	90                   	nop
            break;
        default:
            printf("sh error: bad return %d from gettoken\n", token);
            return -1;
        }
    }
  801ba3:	e9 7c fd ff ff       	jmp    801924 <runcmd+0x10>
                close(p[0]), close(p[1]);
                goto runit;
            }
            break;
        case 0:
            goto runit;
  801ba8:	90                   	nop
  801ba9:	eb 01                	jmp    801bac <runcmd+0x298>
        case ';':
            if ((ret = fork()) == 0) {
                goto runit;
  801bab:	90                   	nop
            return -1;
        }
    }

runit:
    if (argc == 0) {
  801bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb0:	75 0a                	jne    801bbc <runcmd+0x2a8>
        return 0;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb7:	e9 b9 00 00 00       	jmp    801c75 <runcmd+0x361>
    }
    else if (strcmp(argv[0], "cd") == 0) {
  801bbc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bc2:	83 ec 08             	sub    $0x8,%esp
  801bc5:	68 3b 23 80 00       	push   $0x80233b
  801bca:	50                   	push   %eax
  801bcb:	e8 ea ee ff ff       	call   800aba <strcmp>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	75 2e                	jne    801c05 <runcmd+0x2f1>
        if (argc != 2) {
  801bd7:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  801bdb:	74 0a                	je     801be7 <runcmd+0x2d3>
            return -1;
  801bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801be2:	e9 8e 00 00 00       	jmp    801c75 <runcmd+0x361>
        }
        strcpy(shcwd, argv[1]);
  801be7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801bed:	83 ec 08             	sub    $0x8,%esp
  801bf0:	50                   	push   %eax
  801bf1:	68 60 51 80 00       	push   $0x805160
  801bf6:	e8 45 ee ff ff       	call   800a40 <strcpy>
  801bfb:	83 c4 10             	add    $0x10,%esp
        return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801c03:	eb 70                	jmp    801c75 <runcmd+0x361>
    }
    if ((ret = testfile(argv[0])) != 0) {
  801c05:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	50                   	push   %eax
  801c0f:	e8 c7 fc ff ff       	call   8018db <testfile>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c1e:	74 33                	je     801c53 <runcmd+0x33f>
        if (ret != -E_NOENT) {
  801c20:	83 7d ec f0          	cmpl   $0xfffffff0,-0x14(%ebp)
  801c24:	74 05                	je     801c2b <runcmd+0x317>
            return ret;
  801c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c29:	eb 4a                	jmp    801c75 <runcmd+0x361>
        }
        snprintf(argv0, sizeof(argv0), "/%s", argv[0]);
  801c2b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801c31:	50                   	push   %eax
  801c32:	68 3e 23 80 00       	push   $0x80233e
  801c37:	68 00 10 00 00       	push   $0x1000
  801c3c:	68 40 40 80 00       	push   $0x804040
  801c41:	e8 23 f8 ff ff       	call   801469 <snprintf>
  801c46:	83 c4 10             	add    $0x10,%esp
        argv[0] = argv0;
  801c49:	c7 85 68 ff ff ff 40 	movl   $0x804040,-0x98(%ebp)
  801c50:	40 80 00 
    }
    argv[argc] = NULL;
  801c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c56:	c7 84 85 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%eax,4)
  801c5d:	00 00 00 00 
    return __exec(NULL, argv);
  801c61:	83 ec 08             	sub    $0x8,%esp
  801c64:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801c6a:	50                   	push   %eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	e8 0f ed ff ff       	call   800981 <__exec>
  801c72:	83 c4 10             	add    $0x10,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <main>:

int
main(int argc, char **argv) {
  801c77:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  801c7b:	83 e4 f0             	and    $0xfffffff0,%esp
  801c7e:	ff 71 fc             	pushl  -0x4(%ecx)
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	53                   	push   %ebx
  801c85:	51                   	push   %ecx
  801c86:	83 ec 10             	sub    $0x10,%esp
  801c89:	89 cb                	mov    %ecx,%ebx
    printf("user sh is running!!!");
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	68 42 23 80 00       	push   $0x802342
  801c93:	6a 01                	push   $0x1
  801c95:	e8 0e ea ff ff       	call   8006a8 <fprintf>
  801c9a:	83 c4 10             	add    $0x10,%esp
    int ret, interactive = 1;
  801c9d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    if (argc == 2) {
  801ca4:	83 3b 02             	cmpl   $0x2,(%ebx)
  801ca7:	75 36                	jne    801cdf <main+0x68>
        if ((ret = reopen(0, argv[1], O_RDONLY)) != 0) {
  801ca9:	8b 43 04             	mov    0x4(%ebx),%eax
  801cac:	83 c0 04             	add    $0x4,%eax
  801caf:	8b 00                	mov    (%eax),%eax
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	e8 a2 fb ff ff       	call   801860 <reopen>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	74 08                	je     801cd3 <main+0x5c>
            return ret;
  801ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cce:	e9 f2 00 00 00       	jmp    801dc5 <main+0x14e>
        }
        interactive = 0;
  801cd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cda:	e9 b6 00 00 00       	jmp    801d95 <main+0x11e>
    }
    else if (argc > 2) {
  801cdf:	83 3b 02             	cmpl   $0x2,(%ebx)
  801ce2:	0f 8e ad 00 00 00    	jle    801d95 <main+0x11e>
        usage();
  801ce8:	e8 58 fb ff ff       	call   801845 <usage>
        return -1;
  801ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cf2:	e9 ce 00 00 00       	jmp    801dc5 <main+0x14e>
    //shcwd = malloc(BUFSIZE);
    assert(shcwd != NULL);

    char *buffer;
    while ((buffer = readline((interactive) ? "$ " : NULL)) != NULL) {
        shcwd[0] = '\0';
  801cf7:	c6 05 60 51 80 00 00 	movb   $0x0,0x805160
        int pid;
        if ((pid = fork()) == 0) {
  801cfe:	e8 c8 eb ff ff       	call   8008cb <fork>
  801d03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d0a:	75 1d                	jne    801d29 <main+0xb2>
            ret = runcmd(buffer);
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	ff 75 f0             	pushl  -0x10(%ebp)
  801d12:	e8 fd fb ff ff       	call   801914 <runcmd>
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            exit(ret);
  801d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	50                   	push   %eax
  801d24:	e8 7c eb ff ff       	call   8008a5 <exit>
        }
        assert(pid >= 0);
  801d29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d2d:	79 19                	jns    801d48 <main+0xd1>
  801d2f:	68 58 23 80 00       	push   $0x802358
  801d34:	68 61 23 80 00       	push   $0x802361
  801d39:	68 f2 00 00 00       	push   $0xf2
  801d3e:	68 76 23 80 00       	push   $0x802376
  801d43:	e8 d8 e2 ff ff       	call   800020 <__panic>
        if (waitpid(pid, &ret) == 0) {
  801d48:	83 ec 08             	sub    $0x8,%esp
  801d4b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d4e:	50                   	push   %eax
  801d4f:	ff 75 ec             	pushl  -0x14(%ebp)
  801d52:	e8 98 eb ff ff       	call   8008ef <waitpid>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	75 37                	jne    801d95 <main+0x11e>
            if (ret == 0 && shcwd[0] != '\0') {
  801d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d61:	85 c0                	test   %eax,%eax
  801d63:	75 12                	jne    801d77 <main+0x100>
  801d65:	0f b6 05 60 51 80 00 	movzbl 0x805160,%eax
  801d6c:	84 c0                	test   %al,%al
  801d6e:	74 07                	je     801d77 <main+0x100>
                ret = 0;
  801d70:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            }
            if (ret != 0) {
  801d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	74 17                	je     801d95 <main+0x11e>
                printf("error: %d - %e\n", ret, ret);
  801d7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d84:	52                   	push   %edx
  801d85:	50                   	push   %eax
  801d86:	68 80 23 80 00       	push   $0x802380
  801d8b:	6a 01                	push   $0x1
  801d8d:	e8 16 e9 ff ff       	call   8006a8 <fprintf>
  801d92:	83 c4 10             	add    $0x10,%esp
    }
    //shcwd = malloc(BUFSIZE);
    assert(shcwd != NULL);

    char *buffer;
    while ((buffer = readline((interactive) ? "$ " : NULL)) != NULL) {
  801d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d99:	74 07                	je     801da2 <main+0x12b>
  801d9b:	b8 90 23 80 00       	mov    $0x802390,%eax
  801da0:	eb 05                	jmp    801da7 <main+0x130>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	50                   	push   %eax
  801dab:	e8 5a f9 ff ff       	call   80170a <readline>
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dba:	0f 85 37 ff ff ff    	jne    801cf7 <main+0x80>
            if (ret != 0) {
                printf("error: %d - %e\n", ret, ret);
            }
        }
    }
    return 0;
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc8:	59                   	pop    %ecx
  801dc9:	5b                   	pop    %ebx
  801dca:	5d                   	pop    %ebp
  801dcb:	8d 61 fc             	lea    -0x4(%ecx),%esp
  801dce:	c3                   	ret    