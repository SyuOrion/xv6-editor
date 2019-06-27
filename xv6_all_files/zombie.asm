
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	83 ec 18             	sub    $0x18,%esp
 329:	8b 45 0c             	mov    0xc(%ebp),%eax
 32c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 32f:	83 ec 04             	sub    $0x4,%esp
 332:	6a 01                	push   $0x1
 334:	8d 45 f4             	lea    -0xc(%ebp),%eax
 337:	50                   	push   %eax
 338:	ff 75 08             	pushl  0x8(%ebp)
 33b:	e8 63 ff ff ff       	call   2a3 <write>
 340:	83 c4 10             	add    $0x10,%esp
}
 343:	90                   	nop
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	53                   	push   %ebx
 34a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 34d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 354:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 358:	74 17                	je     371 <printint+0x2b>
 35a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 35e:	79 11                	jns    371 <printint+0x2b>
    neg = 1;
 360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	f7 d8                	neg    %eax
 36c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 36f:	eb 06                	jmp    377 <printint+0x31>
  } else {
    x = xx;
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 37e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 381:	8d 41 01             	lea    0x1(%ecx),%eax
 384:	89 45 f4             	mov    %eax,-0xc(%ebp)
 387:	8b 5d 10             	mov    0x10(%ebp),%ebx
 38a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38d:	ba 00 00 00 00       	mov    $0x0,%edx
 392:	f7 f3                	div    %ebx
 394:	89 d0                	mov    %edx,%eax
 396:	0f b6 80 00 0a 00 00 	movzbl 0xa00(%eax),%eax
 39d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ac:	f7 f3                	div    %ebx
 3ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3b5:	75 c7                	jne    37e <printint+0x38>
  if(neg)
 3b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3bb:	74 2d                	je     3ea <printint+0xa4>
    buf[i++] = '-';
 3bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c0:	8d 50 01             	lea    0x1(%eax),%edx
 3c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3cb:	eb 1d                	jmp    3ea <printint+0xa4>
    putc(fd, buf[i]);
 3cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d3:	01 d0                	add    %edx,%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f be c0             	movsbl %al,%eax
 3db:	83 ec 08             	sub    $0x8,%esp
 3de:	50                   	push   %eax
 3df:	ff 75 08             	pushl  0x8(%ebp)
 3e2:	e8 3c ff ff ff       	call   323 <putc>
 3e7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f2:	79 d9                	jns    3cd <printint+0x87>
    putc(fd, buf[i]);
}
 3f4:	90                   	nop
 3f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f8:	c9                   	leave  
 3f9:	c3                   	ret    

000003fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 45 0c             	lea    0xc(%ebp),%eax
 40a:	83 c0 04             	add    $0x4,%eax
 40d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 410:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 417:	e9 59 01 00 00       	jmp    575 <printf+0x17b>
    c = fmt[i] & 0xff;
 41c:	8b 55 0c             	mov    0xc(%ebp),%edx
 41f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 422:	01 d0                	add    %edx,%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	0f be c0             	movsbl %al,%eax
 42a:	25 ff 00 00 00       	and    $0xff,%eax
 42f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 432:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 436:	75 2c                	jne    464 <printf+0x6a>
      if(c == '%'){
 438:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 43c:	75 0c                	jne    44a <printf+0x50>
        state = '%';
 43e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 445:	e9 27 01 00 00       	jmp    571 <printf+0x177>
      } else {
        putc(fd, c);
 44a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 44d:	0f be c0             	movsbl %al,%eax
 450:	83 ec 08             	sub    $0x8,%esp
 453:	50                   	push   %eax
 454:	ff 75 08             	pushl  0x8(%ebp)
 457:	e8 c7 fe ff ff       	call   323 <putc>
 45c:	83 c4 10             	add    $0x10,%esp
 45f:	e9 0d 01 00 00       	jmp    571 <printf+0x177>
      }
    } else if(state == '%'){
 464:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 468:	0f 85 03 01 00 00    	jne    571 <printf+0x177>
      if(c == 'd'){
 46e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 472:	75 1e                	jne    492 <printf+0x98>
        printint(fd, *ap, 10, 1);
 474:	8b 45 e8             	mov    -0x18(%ebp),%eax
 477:	8b 00                	mov    (%eax),%eax
 479:	6a 01                	push   $0x1
 47b:	6a 0a                	push   $0xa
 47d:	50                   	push   %eax
 47e:	ff 75 08             	pushl  0x8(%ebp)
 481:	e8 c0 fe ff ff       	call   346 <printint>
 486:	83 c4 10             	add    $0x10,%esp
        ap++;
 489:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 48d:	e9 d8 00 00 00       	jmp    56a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 492:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 496:	74 06                	je     49e <printf+0xa4>
 498:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 49c:	75 1e                	jne    4bc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 49e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a1:	8b 00                	mov    (%eax),%eax
 4a3:	6a 00                	push   $0x0
 4a5:	6a 10                	push   $0x10
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 96 fe ff ff       	call   346 <printint>
 4b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b7:	e9 ae 00 00 00       	jmp    56a <printf+0x170>
      } else if(c == 's'){
 4bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4c0:	75 43                	jne    505 <printf+0x10b>
        s = (char*)*ap;
 4c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c5:	8b 00                	mov    (%eax),%eax
 4c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d2:	75 25                	jne    4f9 <printf+0xff>
          s = "(null)";
 4d4:	c7 45 f4 b0 07 00 00 	movl   $0x7b0,-0xc(%ebp)
        while(*s != 0){
 4db:	eb 1c                	jmp    4f9 <printf+0xff>
          putc(fd, *s);
 4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e0:	0f b6 00             	movzbl (%eax),%eax
 4e3:	0f be c0             	movsbl %al,%eax
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 31 fe ff ff       	call   323 <putc>
 4f2:	83 c4 10             	add    $0x10,%esp
          s++;
 4f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	84 c0                	test   %al,%al
 501:	75 da                	jne    4dd <printf+0xe3>
 503:	eb 65                	jmp    56a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 505:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 509:	75 1d                	jne    528 <printf+0x12e>
        putc(fd, *ap);
 50b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50e:	8b 00                	mov    (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	83 ec 08             	sub    $0x8,%esp
 516:	50                   	push   %eax
 517:	ff 75 08             	pushl  0x8(%ebp)
 51a:	e8 04 fe ff ff       	call   323 <putc>
 51f:	83 c4 10             	add    $0x10,%esp
        ap++;
 522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 526:	eb 42                	jmp    56a <printf+0x170>
      } else if(c == '%'){
 528:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52c:	75 17                	jne    545 <printf+0x14b>
        putc(fd, c);
 52e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 531:	0f be c0             	movsbl %al,%eax
 534:	83 ec 08             	sub    $0x8,%esp
 537:	50                   	push   %eax
 538:	ff 75 08             	pushl  0x8(%ebp)
 53b:	e8 e3 fd ff ff       	call   323 <putc>
 540:	83 c4 10             	add    $0x10,%esp
 543:	eb 25                	jmp    56a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 545:	83 ec 08             	sub    $0x8,%esp
 548:	6a 25                	push   $0x25
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 d1 fd ff ff       	call   323 <putc>
 552:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	83 ec 08             	sub    $0x8,%esp
 55e:	50                   	push   %eax
 55f:	ff 75 08             	pushl  0x8(%ebp)
 562:	e8 bc fd ff ff       	call   323 <putc>
 567:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 56a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 571:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 575:	8b 55 0c             	mov    0xc(%ebp),%edx
 578:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57b:	01 d0                	add    %edx,%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	84 c0                	test   %al,%al
 582:	0f 85 94 fe ff ff    	jne    41c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 588:	90                   	nop
 589:	c9                   	leave  
 58a:	c3                   	ret    

0000058b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp
 58e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	83 e8 08             	sub    $0x8,%eax
 597:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59a:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 59f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5a2:	eb 24                	jmp    5c8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a7:	8b 00                	mov    (%eax),%eax
 5a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ac:	77 12                	ja     5c0 <free+0x35>
 5ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b4:	77 24                	ja     5da <free+0x4f>
 5b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5be:	77 1a                	ja     5da <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ce:	76 d4                	jbe    5a4 <free+0x19>
 5d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d8:	76 ca                	jbe    5a4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5dd:	8b 40 04             	mov    0x4(%eax),%eax
 5e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ea:	01 c2                	add    %eax,%edx
 5ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ef:	8b 00                	mov    (%eax),%eax
 5f1:	39 c2                	cmp    %eax,%edx
 5f3:	75 24                	jne    619 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f8:	8b 50 04             	mov    0x4(%eax),%edx
 5fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	8b 40 04             	mov    0x4(%eax),%eax
 603:	01 c2                	add    %eax,%edx
 605:	8b 45 f8             	mov    -0x8(%ebp),%eax
 608:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	8b 10                	mov    (%eax),%edx
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	89 10                	mov    %edx,(%eax)
 617:	eb 0a                	jmp    623 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 10                	mov    (%eax),%edx
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 40 04             	mov    0x4(%eax),%eax
 629:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 638:	75 20                	jne    65a <free+0xcf>
    p->s.size += bp->s.size;
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	8b 40 04             	mov    0x4(%eax),%eax
 646:	01 c2                	add    %eax,%edx
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	89 10                	mov    %edx,(%eax)
 658:	eb 08                	jmp    662 <free+0xd7>
  } else
    p->s.ptr = bp;
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 660:	89 10                	mov    %edx,(%eax)
  freep = p;
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	a3 1c 0a 00 00       	mov    %eax,0xa1c
}
 66a:	90                   	nop
 66b:	c9                   	leave  
 66c:	c3                   	ret    

0000066d <morecore>:

static Header*
morecore(uint nu)
{
 66d:	55                   	push   %ebp
 66e:	89 e5                	mov    %esp,%ebp
 670:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 673:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 67a:	77 07                	ja     683 <morecore+0x16>
    nu = 4096;
 67c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	c1 e0 03             	shl    $0x3,%eax
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	50                   	push   %eax
 68d:	e8 79 fc ff ff       	call   30b <sbrk>
 692:	83 c4 10             	add    $0x10,%esp
 695:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 698:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 69c:	75 07                	jne    6a5 <morecore+0x38>
    return 0;
 69e:	b8 00 00 00 00       	mov    $0x0,%eax
 6a3:	eb 26                	jmp    6cb <morecore+0x5e>
  hp = (Header*)p;
 6a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ae:	8b 55 08             	mov    0x8(%ebp),%edx
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b7:	83 c0 08             	add    $0x8,%eax
 6ba:	83 ec 0c             	sub    $0xc,%esp
 6bd:	50                   	push   %eax
 6be:	e8 c8 fe ff ff       	call   58b <free>
 6c3:	83 c4 10             	add    $0x10,%esp
  return freep;
 6c6:	a1 1c 0a 00 00       	mov    0xa1c,%eax
}
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <malloc>:

void*
malloc(uint nbytes)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	83 c0 07             	add    $0x7,%eax
 6d9:	c1 e8 03             	shr    $0x3,%eax
 6dc:	83 c0 01             	add    $0x1,%eax
 6df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6e2:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 6e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ee:	75 23                	jne    713 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6f0:	c7 45 f0 14 0a 00 00 	movl   $0xa14,-0x10(%ebp)
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	a3 1c 0a 00 00       	mov    %eax,0xa1c
 6ff:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 704:	a3 14 0a 00 00       	mov    %eax,0xa14
    base.s.size = 0;
 709:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 710:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 724:	72 4d                	jb     773 <malloc+0xa6>
      if(p->s.size == nunits)
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 72f:	75 0c                	jne    73d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 731:	8b 45 f4             	mov    -0xc(%ebp),%eax
 734:	8b 10                	mov    (%eax),%edx
 736:	8b 45 f0             	mov    -0x10(%ebp),%eax
 739:	89 10                	mov    %edx,(%eax)
 73b:	eb 26                	jmp    763 <malloc+0x96>
      else {
        p->s.size -= nunits;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	2b 45 ec             	sub    -0x14(%ebp),%eax
 746:	89 c2                	mov    %eax,%edx
 748:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	c1 e0 03             	shl    $0x3,%eax
 757:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 760:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	a3 1c 0a 00 00       	mov    %eax,0xa1c
      return (void*)(p + 1);
 76b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76e:	83 c0 08             	add    $0x8,%eax
 771:	eb 3b                	jmp    7ae <malloc+0xe1>
    }
    if(p == freep)
 773:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 778:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 77b:	75 1e                	jne    79b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 77d:	83 ec 0c             	sub    $0xc,%esp
 780:	ff 75 ec             	pushl  -0x14(%ebp)
 783:	e8 e5 fe ff ff       	call   66d <morecore>
 788:	83 c4 10             	add    $0x10,%esp
 78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 78e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 792:	75 07                	jne    79b <malloc+0xce>
        return 0;
 794:	b8 00 00 00 00       	mov    $0x0,%eax
 799:	eb 13                	jmp    7ae <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7a9:	e9 6d ff ff ff       	jmp    71b <malloc+0x4e>
}
 7ae:	c9                   	leave  
 7af:	c3                   	ret    
