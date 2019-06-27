
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 1){
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 f6 07 00 00       	push   $0x7f6
  21:	6a 02                	push   $0x2
  23:	e8 18 04 00 00       	call   440 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 18             	sub    $0x18,%esp
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 375:	83 ec 04             	sub    $0x4,%esp
 378:	6a 01                	push   $0x1
 37a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37d:	50                   	push   %eax
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 63 ff ff ff       	call   2e9 <write>
 386:	83 c4 10             	add    $0x10,%esp
}
 389:	90                   	nop
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	53                   	push   %ebx
 390:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39e:	74 17                	je     3b7 <printint+0x2b>
 3a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a4:	79 11                	jns    3b7 <printint+0x2b>
    neg = 1;
 3a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	f7 d8                	neg    %eax
 3b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b5:	eb 06                	jmp    3bd <printint+0x31>
  } else {
    x = xx;
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c7:	8d 41 01             	lea    0x1(%ecx),%eax
 3ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d3:	ba 00 00 00 00       	mov    $0x0,%edx
 3d8:	f7 f3                	div    %ebx
 3da:	89 d0                	mov    %edx,%eax
 3dc:	0f b6 80 60 0a 00 00 	movzbl 0xa60(%eax),%eax
 3e3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 f3                	div    %ebx
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fb:	75 c7                	jne    3c4 <printint+0x38>
  if(neg)
 3fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 401:	74 2d                	je     430 <printint+0xa4>
    buf[i++] = '-';
 403:	8b 45 f4             	mov    -0xc(%ebp),%eax
 406:	8d 50 01             	lea    0x1(%eax),%edx
 409:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 411:	eb 1d                	jmp    430 <printint+0xa4>
    putc(fd, buf[i]);
 413:	8d 55 dc             	lea    -0x24(%ebp),%edx
 416:	8b 45 f4             	mov    -0xc(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	0f b6 00             	movzbl (%eax),%eax
 41e:	0f be c0             	movsbl %al,%eax
 421:	83 ec 08             	sub    $0x8,%esp
 424:	50                   	push   %eax
 425:	ff 75 08             	pushl  0x8(%ebp)
 428:	e8 3c ff ff ff       	call   369 <putc>
 42d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 430:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 438:	79 d9                	jns    413 <printint+0x87>
    putc(fd, buf[i]);
}
 43a:	90                   	nop
 43b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 446:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44d:	8d 45 0c             	lea    0xc(%ebp),%eax
 450:	83 c0 04             	add    $0x4,%eax
 453:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 456:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45d:	e9 59 01 00 00       	jmp    5bb <printf+0x17b>
    c = fmt[i] & 0xff;
 462:	8b 55 0c             	mov    0xc(%ebp),%edx
 465:	8b 45 f0             	mov    -0x10(%ebp),%eax
 468:	01 d0                	add    %edx,%eax
 46a:	0f b6 00             	movzbl (%eax),%eax
 46d:	0f be c0             	movsbl %al,%eax
 470:	25 ff 00 00 00       	and    $0xff,%eax
 475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47c:	75 2c                	jne    4aa <printf+0x6a>
      if(c == '%'){
 47e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 482:	75 0c                	jne    490 <printf+0x50>
        state = '%';
 484:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48b:	e9 27 01 00 00       	jmp    5b7 <printf+0x177>
      } else {
        putc(fd, c);
 490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	83 ec 08             	sub    $0x8,%esp
 499:	50                   	push   %eax
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 c7 fe ff ff       	call   369 <putc>
 4a2:	83 c4 10             	add    $0x10,%esp
 4a5:	e9 0d 01 00 00       	jmp    5b7 <printf+0x177>
      }
    } else if(state == '%'){
 4aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ae:	0f 85 03 01 00 00    	jne    5b7 <printf+0x177>
      if(c == 'd'){
 4b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b8:	75 1e                	jne    4d8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bd:	8b 00                	mov    (%eax),%eax
 4bf:	6a 01                	push   $0x1
 4c1:	6a 0a                	push   $0xa
 4c3:	50                   	push   %eax
 4c4:	ff 75 08             	pushl  0x8(%ebp)
 4c7:	e8 c0 fe ff ff       	call   38c <printint>
 4cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d3:	e9 d8 00 00 00       	jmp    5b0 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4dc:	74 06                	je     4e4 <printf+0xa4>
 4de:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e2:	75 1e                	jne    502 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e7:	8b 00                	mov    (%eax),%eax
 4e9:	6a 00                	push   $0x0
 4eb:	6a 10                	push   $0x10
 4ed:	50                   	push   %eax
 4ee:	ff 75 08             	pushl  0x8(%ebp)
 4f1:	e8 96 fe ff ff       	call   38c <printint>
 4f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fd:	e9 ae 00 00 00       	jmp    5b0 <printf+0x170>
      } else if(c == 's'){
 502:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 506:	75 43                	jne    54b <printf+0x10b>
        s = (char*)*ap;
 508:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50b:	8b 00                	mov    (%eax),%eax
 50d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 518:	75 25                	jne    53f <printf+0xff>
          s = "(null)";
 51a:	c7 45 f4 0a 08 00 00 	movl   $0x80a,-0xc(%ebp)
        while(*s != 0){
 521:	eb 1c                	jmp    53f <printf+0xff>
          putc(fd, *s);
 523:	8b 45 f4             	mov    -0xc(%ebp),%eax
 526:	0f b6 00             	movzbl (%eax),%eax
 529:	0f be c0             	movsbl %al,%eax
 52c:	83 ec 08             	sub    $0x8,%esp
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 31 fe ff ff       	call   369 <putc>
 538:	83 c4 10             	add    $0x10,%esp
          s++;
 53b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	84 c0                	test   %al,%al
 547:	75 da                	jne    523 <printf+0xe3>
 549:	eb 65                	jmp    5b0 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54f:	75 1d                	jne    56e <printf+0x12e>
        putc(fd, *ap);
 551:	8b 45 e8             	mov    -0x18(%ebp),%eax
 554:	8b 00                	mov    (%eax),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	50                   	push   %eax
 55d:	ff 75 08             	pushl  0x8(%ebp)
 560:	e8 04 fe ff ff       	call   369 <putc>
 565:	83 c4 10             	add    $0x10,%esp
        ap++;
 568:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56c:	eb 42                	jmp    5b0 <printf+0x170>
      } else if(c == '%'){
 56e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 572:	75 17                	jne    58b <printf+0x14b>
        putc(fd, c);
 574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 577:	0f be c0             	movsbl %al,%eax
 57a:	83 ec 08             	sub    $0x8,%esp
 57d:	50                   	push   %eax
 57e:	ff 75 08             	pushl  0x8(%ebp)
 581:	e8 e3 fd ff ff       	call   369 <putc>
 586:	83 c4 10             	add    $0x10,%esp
 589:	eb 25                	jmp    5b0 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58b:	83 ec 08             	sub    $0x8,%esp
 58e:	6a 25                	push   $0x25
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 d1 fd ff ff       	call   369 <putc>
 598:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 59b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 bc fd ff ff       	call   369 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c1:	01 d0                	add    %edx,%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	84 c0                	test   %al,%al
 5c8:	0f 85 94 fe ff ff    	jne    462 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ce:	90                   	nop
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	83 e8 08             	sub    $0x8,%eax
 5dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e0:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e8:	eb 24                	jmp    60e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f2:	77 12                	ja     606 <free+0x35>
 5f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fa:	77 24                	ja     620 <free+0x4f>
 5fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 604:	77 1a                	ja     620 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 606:	8b 45 fc             	mov    -0x4(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 614:	76 d4                	jbe    5ea <free+0x19>
 616:	8b 45 fc             	mov    -0x4(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61e:	76 ca                	jbe    5ea <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 620:	8b 45 f8             	mov    -0x8(%ebp),%eax
 623:	8b 40 04             	mov    0x4(%eax),%eax
 626:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	01 c2                	add    %eax,%edx
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	39 c2                	cmp    %eax,%edx
 639:	75 24                	jne    65f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	8b 50 04             	mov    0x4(%eax),%edx
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	8b 40 04             	mov    0x4(%eax),%eax
 649:	01 c2                	add    %eax,%edx
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	89 10                	mov    %edx,(%eax)
 65d:	eb 0a                	jmp    669 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 10                	mov    (%eax),%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	01 d0                	add    %edx,%eax
 67b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67e:	75 20                	jne    6a0 <free+0xcf>
    p->s.size += bp->s.size;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 50 04             	mov    0x4(%eax),%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	01 c2                	add    %eax,%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	8b 10                	mov    (%eax),%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	89 10                	mov    %edx,(%eax)
 69e:	eb 08                	jmp    6a8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6b0:	90                   	nop
 6b1:	c9                   	leave  
 6b2:	c3                   	ret    

000006b3 <morecore>:

static Header*
morecore(uint nu)
{
 6b3:	55                   	push   %ebp
 6b4:	89 e5                	mov    %esp,%ebp
 6b6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c0:	77 07                	ja     6c9 <morecore+0x16>
    nu = 4096;
 6c2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	c1 e0 03             	shl    $0x3,%eax
 6cf:	83 ec 0c             	sub    $0xc,%esp
 6d2:	50                   	push   %eax
 6d3:	e8 79 fc ff ff       	call   351 <sbrk>
 6d8:	83 c4 10             	add    $0x10,%esp
 6db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6de:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e2:	75 07                	jne    6eb <morecore+0x38>
    return 0;
 6e4:	b8 00 00 00 00       	mov    $0x0,%eax
 6e9:	eb 26                	jmp    711 <morecore+0x5e>
  hp = (Header*)p;
 6eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f4:	8b 55 08             	mov    0x8(%ebp),%edx
 6f7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fd:	83 c0 08             	add    $0x8,%eax
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	50                   	push   %eax
 704:	e8 c8 fe ff ff       	call   5d1 <free>
 709:	83 c4 10             	add    $0x10,%esp
  return freep;
 70c:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <malloc>:

void*
malloc(uint nbytes)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	83 c0 07             	add    $0x7,%eax
 71f:	c1 e8 03             	shr    $0x3,%eax
 722:	83 c0 01             	add    $0x1,%eax
 725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 728:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 72d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 734:	75 23                	jne    759 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 736:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 745:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 74a:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 74f:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 756:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76a:	72 4d                	jb     7b9 <malloc+0xa6>
      if(p->s.size == nunits)
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 775:	75 0c                	jne    783 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 26                	jmp    7a9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78c:	89 c2                	mov    %eax,%edx
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	c1 e0 03             	shl    $0x3,%eax
 79d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	eb 3b                	jmp    7f4 <malloc+0xe1>
    }
    if(p == freep)
 7b9:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c1:	75 1e                	jne    7e1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	ff 75 ec             	pushl  -0x14(%ebp)
 7c9:	e8 e5 fe ff ff       	call   6b3 <morecore>
 7ce:	83 c4 10             	add    $0x10,%esp
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <malloc+0xce>
        return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 13                	jmp    7f4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ef:	e9 6d ff ff ff       	jmp    761 <malloc+0x4e>
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    
