
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 f8 07 00 00       	push   $0x7f8
  1e:	6a 02                	push   $0x2
  20:	e8 1d 04 00 00       	call   442 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 0b 08 00 00       	push   $0x80b
  65:	6a 02                	push   $0x2
  67:	e8 d6 03 00 00       	call   442 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 18             	sub    $0x18,%esp
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 377:	83 ec 04             	sub    $0x4,%esp
 37a:	6a 01                	push   $0x1
 37c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37f:	50                   	push   %eax
 380:	ff 75 08             	pushl  0x8(%ebp)
 383:	e8 63 ff ff ff       	call   2eb <write>
 388:	83 c4 10             	add    $0x10,%esp
}
 38b:	90                   	nop
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	53                   	push   %ebx
 392:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 395:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a0:	74 17                	je     3b9 <printint+0x2b>
 3a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a6:	79 11                	jns    3b9 <printint+0x2b>
    neg = 1;
 3a8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3af:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b2:	f7 d8                	neg    %eax
 3b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b7:	eb 06                	jmp    3bf <printint+0x31>
  } else {
    x = xx;
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c9:	8d 41 01             	lea    0x1(%ecx),%eax
 3cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d5:	ba 00 00 00 00       	mov    $0x0,%edx
 3da:	f7 f3                	div    %ebx
 3dc:	89 d0                	mov    %edx,%eax
 3de:	0f b6 80 74 0a 00 00 	movzbl 0xa74(%eax),%eax
 3e5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ef:	ba 00 00 00 00       	mov    $0x0,%edx
 3f4:	f7 f3                	div    %ebx
 3f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fd:	75 c7                	jne    3c6 <printint+0x38>
  if(neg)
 3ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 403:	74 2d                	je     432 <printint+0xa4>
    buf[i++] = '-';
 405:	8b 45 f4             	mov    -0xc(%ebp),%eax
 408:	8d 50 01             	lea    0x1(%eax),%edx
 40b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 413:	eb 1d                	jmp    432 <printint+0xa4>
    putc(fd, buf[i]);
 415:	8d 55 dc             	lea    -0x24(%ebp),%edx
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	0f be c0             	movsbl %al,%eax
 423:	83 ec 08             	sub    $0x8,%esp
 426:	50                   	push   %eax
 427:	ff 75 08             	pushl  0x8(%ebp)
 42a:	e8 3c ff ff ff       	call   36b <putc>
 42f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 432:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43a:	79 d9                	jns    415 <printint+0x87>
    putc(fd, buf[i]);
}
 43c:	90                   	nop
 43d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 440:	c9                   	leave  
 441:	c3                   	ret    

00000442 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp
 445:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 448:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44f:	8d 45 0c             	lea    0xc(%ebp),%eax
 452:	83 c0 04             	add    $0x4,%eax
 455:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 458:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45f:	e9 59 01 00 00       	jmp    5bd <printf+0x17b>
    c = fmt[i] & 0xff;
 464:	8b 55 0c             	mov    0xc(%ebp),%edx
 467:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46a:	01 d0                	add    %edx,%eax
 46c:	0f b6 00             	movzbl (%eax),%eax
 46f:	0f be c0             	movsbl %al,%eax
 472:	25 ff 00 00 00       	and    $0xff,%eax
 477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47e:	75 2c                	jne    4ac <printf+0x6a>
      if(c == '%'){
 480:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 484:	75 0c                	jne    492 <printf+0x50>
        state = '%';
 486:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48d:	e9 27 01 00 00       	jmp    5b9 <printf+0x177>
      } else {
        putc(fd, c);
 492:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 495:	0f be c0             	movsbl %al,%eax
 498:	83 ec 08             	sub    $0x8,%esp
 49b:	50                   	push   %eax
 49c:	ff 75 08             	pushl  0x8(%ebp)
 49f:	e8 c7 fe ff ff       	call   36b <putc>
 4a4:	83 c4 10             	add    $0x10,%esp
 4a7:	e9 0d 01 00 00       	jmp    5b9 <printf+0x177>
      }
    } else if(state == '%'){
 4ac:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b0:	0f 85 03 01 00 00    	jne    5b9 <printf+0x177>
      if(c == 'd'){
 4b6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ba:	75 1e                	jne    4da <printf+0x98>
        printint(fd, *ap, 10, 1);
 4bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bf:	8b 00                	mov    (%eax),%eax
 4c1:	6a 01                	push   $0x1
 4c3:	6a 0a                	push   $0xa
 4c5:	50                   	push   %eax
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 c0 fe ff ff       	call   38e <printint>
 4ce:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d5:	e9 d8 00 00 00       	jmp    5b2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4de:	74 06                	je     4e6 <printf+0xa4>
 4e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e4:	75 1e                	jne    504 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	6a 00                	push   $0x0
 4ed:	6a 10                	push   $0x10
 4ef:	50                   	push   %eax
 4f0:	ff 75 08             	pushl  0x8(%ebp)
 4f3:	e8 96 fe ff ff       	call   38e <printint>
 4f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ff:	e9 ae 00 00 00       	jmp    5b2 <printf+0x170>
      } else if(c == 's'){
 504:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 508:	75 43                	jne    54d <printf+0x10b>
        s = (char*)*ap;
 50a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50d:	8b 00                	mov    (%eax),%eax
 50f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51a:	75 25                	jne    541 <printf+0xff>
          s = "(null)";
 51c:	c7 45 f4 1f 08 00 00 	movl   $0x81f,-0xc(%ebp)
        while(*s != 0){
 523:	eb 1c                	jmp    541 <printf+0xff>
          putc(fd, *s);
 525:	8b 45 f4             	mov    -0xc(%ebp),%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	0f be c0             	movsbl %al,%eax
 52e:	83 ec 08             	sub    $0x8,%esp
 531:	50                   	push   %eax
 532:	ff 75 08             	pushl  0x8(%ebp)
 535:	e8 31 fe ff ff       	call   36b <putc>
 53a:	83 c4 10             	add    $0x10,%esp
          s++;
 53d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	84 c0                	test   %al,%al
 549:	75 da                	jne    525 <printf+0xe3>
 54b:	eb 65                	jmp    5b2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 551:	75 1d                	jne    570 <printf+0x12e>
        putc(fd, *ap);
 553:	8b 45 e8             	mov    -0x18(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	83 ec 08             	sub    $0x8,%esp
 55e:	50                   	push   %eax
 55f:	ff 75 08             	pushl  0x8(%ebp)
 562:	e8 04 fe ff ff       	call   36b <putc>
 567:	83 c4 10             	add    $0x10,%esp
        ap++;
 56a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56e:	eb 42                	jmp    5b2 <printf+0x170>
      } else if(c == '%'){
 570:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 574:	75 17                	jne    58d <printf+0x14b>
        putc(fd, c);
 576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	50                   	push   %eax
 580:	ff 75 08             	pushl  0x8(%ebp)
 583:	e8 e3 fd ff ff       	call   36b <putc>
 588:	83 c4 10             	add    $0x10,%esp
 58b:	eb 25                	jmp    5b2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58d:	83 ec 08             	sub    $0x8,%esp
 590:	6a 25                	push   $0x25
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 d1 fd ff ff       	call   36b <putc>
 59a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 59d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	83 ec 08             	sub    $0x8,%esp
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 bc fd ff ff       	call   36b <putc>
 5af:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5bd:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c3:	01 d0                	add    %edx,%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	84 c0                	test   %al,%al
 5ca:	0f 85 94 fe ff ff    	jne    464 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d0:	90                   	nop
 5d1:	c9                   	leave  
 5d2:	c3                   	ret    

000005d3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d3:	55                   	push   %ebp
 5d4:	89 e5                	mov    %esp,%ebp
 5d6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	83 e8 08             	sub    $0x8,%eax
 5df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e2:	a1 90 0a 00 00       	mov    0xa90,%eax
 5e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ea:	eb 24                	jmp    610 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ef:	8b 00                	mov    (%eax),%eax
 5f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f4:	77 12                	ja     608 <free+0x35>
 5f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fc:	77 24                	ja     622 <free+0x4f>
 5fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 606:	77 1a                	ja     622 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 610:	8b 45 f8             	mov    -0x8(%ebp),%eax
 613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 616:	76 d4                	jbe    5ec <free+0x19>
 618:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 620:	76 ca                	jbe    5ec <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 622:	8b 45 f8             	mov    -0x8(%ebp),%eax
 625:	8b 40 04             	mov    0x4(%eax),%eax
 628:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	01 c2                	add    %eax,%edx
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	39 c2                	cmp    %eax,%edx
 63b:	75 24                	jne    661 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	8b 50 04             	mov    0x4(%eax),%edx
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	8b 40 04             	mov    0x4(%eax),%eax
 64b:	01 c2                	add    %eax,%edx
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	8b 10                	mov    (%eax),%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	89 10                	mov    %edx,(%eax)
 65f:	eb 0a                	jmp    66b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 10                	mov    (%eax),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 680:	75 20                	jne    6a2 <free+0xcf>
    p->s.size += bp->s.size;
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	8b 40 04             	mov    0x4(%eax),%eax
 68e:	01 c2                	add    %eax,%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
 6a0:	eb 08                	jmp    6aa <free+0xd7>
  } else
    p->s.ptr = bp;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6b2:	90                   	nop
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    

000006b5 <morecore>:

static Header*
morecore(uint nu)
{
 6b5:	55                   	push   %ebp
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6bb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c2:	77 07                	ja     6cb <morecore+0x16>
    nu = 4096;
 6c4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6cb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ce:	c1 e0 03             	shl    $0x3,%eax
 6d1:	83 ec 0c             	sub    $0xc,%esp
 6d4:	50                   	push   %eax
 6d5:	e8 79 fc ff ff       	call   353 <sbrk>
 6da:	83 c4 10             	add    $0x10,%esp
 6dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e4:	75 07                	jne    6ed <morecore+0x38>
    return 0;
 6e6:	b8 00 00 00 00       	mov    $0x0,%eax
 6eb:	eb 26                	jmp    713 <morecore+0x5e>
  hp = (Header*)p;
 6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	8b 55 08             	mov    0x8(%ebp),%edx
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	83 c0 08             	add    $0x8,%eax
 702:	83 ec 0c             	sub    $0xc,%esp
 705:	50                   	push   %eax
 706:	e8 c8 fe ff ff       	call   5d3 <free>
 70b:	83 c4 10             	add    $0x10,%esp
  return freep;
 70e:	a1 90 0a 00 00       	mov    0xa90,%eax
}
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <malloc>:

void*
malloc(uint nbytes)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	83 c0 07             	add    $0x7,%eax
 721:	c1 e8 03             	shr    $0x3,%eax
 724:	83 c0 01             	add    $0x1,%eax
 727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72a:	a1 90 0a 00 00       	mov    0xa90,%eax
 72f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 736:	75 23                	jne    75b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 738:	c7 45 f0 88 0a 00 00 	movl   $0xa88,-0x10(%ebp)
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	a3 90 0a 00 00       	mov    %eax,0xa90
 747:	a1 90 0a 00 00       	mov    0xa90,%eax
 74c:	a3 88 0a 00 00       	mov    %eax,0xa88
    base.s.size = 0;
 751:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 758:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76c:	72 4d                	jb     7bb <malloc+0xa6>
      if(p->s.size == nunits)
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 777:	75 0c                	jne    785 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
 783:	eb 26                	jmp    7ab <malloc+0x96>
      else {
        p->s.size -= nunits;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78e:	89 c2                	mov    %eax,%edx
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	c1 e0 03             	shl    $0x3,%eax
 79f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	a3 90 0a 00 00       	mov    %eax,0xa90
      return (void*)(p + 1);
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	83 c0 08             	add    $0x8,%eax
 7b9:	eb 3b                	jmp    7f6 <malloc+0xe1>
    }
    if(p == freep)
 7bb:	a1 90 0a 00 00       	mov    0xa90,%eax
 7c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c3:	75 1e                	jne    7e3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c5:	83 ec 0c             	sub    $0xc,%esp
 7c8:	ff 75 ec             	pushl  -0x14(%ebp)
 7cb:	e8 e5 fe ff ff       	call   6b5 <morecore>
 7d0:	83 c4 10             	add    $0x10,%esp
 7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7da:	75 07                	jne    7e3 <malloc+0xce>
        return 0;
 7dc:	b8 00 00 00 00       	mov    $0x0,%eax
 7e1:	eb 13                	jmp    7f6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f1:	e9 6d ff ff ff       	jmp    763 <malloc+0x4e>
}
 7f6:	c9                   	leave  
 7f7:	c3                   	ret    
