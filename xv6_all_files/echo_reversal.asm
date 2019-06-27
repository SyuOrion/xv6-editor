
_echo_reversal:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
    for (int i =1; i < argc; i++){
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	e9 92 00 00 00       	jmp    b2 <main+0xb2>
        int l = strlen(argv[i]) - 1;
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  2a:	8b 43 04             	mov    0x4(%ebx),%eax
  2d:	01 d0                	add    %edx,%eax
  2f:	8b 00                	mov    (%eax),%eax
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	50                   	push   %eax
  35:	e8 1d 01 00 00       	call   157 <strlen>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	83 e8 01             	sub    $0x1,%eax
  40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        for(; l >= 0; l--){
  43:	eb 33                	jmp    78 <main+0x78>
            printf(1, "%c", argv[i][l]);
  45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  4f:	8b 43 04             	mov    0x4(%ebx),%eax
  52:	01 d0                	add    %edx,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	01 d0                	add    %edx,%eax
  5b:	0f b6 00             	movzbl (%eax),%eax
  5e:	0f be c0             	movsbl %al,%eax
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	68 46 08 00 00       	push   $0x846
  6a:	6a 01                	push   $0x1
  6c:	e8 1f 04 00 00       	call   490 <printf>
  71:	83 c4 10             	add    $0x10,%esp
#include "user.h"

int main(int argc, char *argv[]){
    for (int i =1; i < argc; i++){
        int l = strlen(argv[i]) - 1;
        for(; l >= 0; l--){
  74:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  7c:	79 c7                	jns    45 <main+0x45>
            printf(1, "%c", argv[i][l]);
        }
        if (i+1 < argc)
  7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  81:	83 c0 01             	add    $0x1,%eax
  84:	3b 03                	cmp    (%ebx),%eax
  86:	7d 14                	jge    9c <main+0x9c>
            printf(1, " ");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 49 08 00 00       	push   $0x849
  90:	6a 01                	push   $0x1
  92:	e8 f9 03 00 00       	call   490 <printf>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	eb 12                	jmp    ae <main+0xae>
        else
            printf(1, "\n");
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	68 4b 08 00 00       	push   $0x84b
  a4:	6a 01                	push   $0x1
  a6:	e8 e5 03 00 00       	call   490 <printf>
  ab:	83 c4 10             	add    $0x10,%esp
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    for (int i =1; i < argc; i++){
  ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b5:	3b 03                	cmp    (%ebx),%eax
  b7:	0f 8c 63 ff ff ff    	jl     20 <main+0x20>
        if (i+1 < argc)
            printf(1, " ");
        else
            printf(1, "\n");
    }
    exit();
  bd:	e8 57 02 00 00       	call   319 <exit>

000000c2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	57                   	push   %edi
  c6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ca:	8b 55 10             	mov    0x10(%ebp),%edx
  cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  d0:	89 cb                	mov    %ecx,%ebx
  d2:	89 df                	mov    %ebx,%edi
  d4:	89 d1                	mov    %edx,%ecx
  d6:	fc                   	cld    
  d7:	f3 aa                	rep stos %al,%es:(%edi)
  d9:	89 ca                	mov    %ecx,%edx
  db:	89 fb                	mov    %edi,%ebx
  dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e3:	90                   	nop
  e4:	5b                   	pop    %ebx
  e5:	5f                   	pop    %edi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    

000000e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f4:	90                   	nop
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8d 50 01             	lea    0x1(%eax),%edx
  fb:	89 55 08             	mov    %edx,0x8(%ebp)
  fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 101:	8d 4a 01             	lea    0x1(%edx),%ecx
 104:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 107:	0f b6 12             	movzbl (%edx),%edx
 10a:	88 10                	mov    %dl,(%eax)
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	75 e2                	jne    f5 <strcpy+0xd>
    ;
  return os;
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11b:	eb 08                	jmp    125 <strcmp+0xd>
    p++, q++;
 11d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 121:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	74 10                	je     13f <strcmp+0x27>
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 10             	movzbl (%eax),%edx
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	38 c2                	cmp    %al,%dl
 13d:	74 de                	je     11d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	0f b6 d0             	movzbl %al,%edx
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	0f b6 c0             	movzbl %al,%eax
 151:	29 c2                	sub    %eax,%edx
 153:	89 d0                	mov    %edx,%eax
}
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    

00000157 <strlen>:

uint
strlen(char *s)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 164:	eb 04                	jmp    16a <strlen+0x13>
 166:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	84 c0                	test   %al,%al
 177:	75 ed                	jne    166 <strlen+0xf>
    ;
  return n;
 179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 181:	8b 45 10             	mov    0x10(%ebp),%eax
 184:	50                   	push   %eax
 185:	ff 75 0c             	pushl  0xc(%ebp)
 188:	ff 75 08             	pushl  0x8(%ebp)
 18b:	e8 32 ff ff ff       	call   c2 <stosb>
 190:	83 c4 0c             	add    $0xc,%esp
  return dst;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a4:	eb 14                	jmp    1ba <strchr+0x22>
    if(*s == c)
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1af:	75 05                	jne    1b6 <strchr+0x1e>
      return (char*)s;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	eb 13                	jmp    1c9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	84 c0                	test   %al,%al
 1c2:	75 e2                	jne    1a6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <gets>:

char*
gets(char *buf, int max)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d8:	eb 42                	jmp    21c <gets+0x51>
    cc = read(0, &c, 1);
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	6a 01                	push   $0x1
 1df:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e2:	50                   	push   %eax
 1e3:	6a 00                	push   $0x0
 1e5:	e8 47 01 00 00       	call   331 <read>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f4:	7e 33                	jle    229 <gets+0x5e>
      break;
    buf[i++] = c;
 1f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f9:	8d 50 01             	lea    0x1(%eax),%edx
 1fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ff:	89 c2                	mov    %eax,%edx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	01 c2                	add    %eax,%edx
 206:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0a                	cmp    $0xa,%al
 212:	74 16                	je     22a <gets+0x5f>
 214:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 218:	3c 0d                	cmp    $0xd,%al
 21a:	74 0e                	je     22a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21f:	83 c0 01             	add    $0x1,%eax
 222:	3b 45 0c             	cmp    0xc(%ebp),%eax
 225:	7c b3                	jl     1da <gets+0xf>
 227:	eb 01                	jmp    22a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 229:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 d0                	add    %edx,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <stat>:

int
stat(char *n, struct stat *st)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	83 ec 08             	sub    $0x8,%esp
 243:	6a 00                	push   $0x0
 245:	ff 75 08             	pushl  0x8(%ebp)
 248:	e8 0c 01 00 00       	call   359 <open>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 257:	79 07                	jns    260 <stat+0x26>
    return -1;
 259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25e:	eb 25                	jmp    285 <stat+0x4b>
  r = fstat(fd, st);
 260:	83 ec 08             	sub    $0x8,%esp
 263:	ff 75 0c             	pushl  0xc(%ebp)
 266:	ff 75 f4             	pushl  -0xc(%ebp)
 269:	e8 03 01 00 00       	call   371 <fstat>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 274:	83 ec 0c             	sub    $0xc,%esp
 277:	ff 75 f4             	pushl  -0xc(%ebp)
 27a:	e8 c2 00 00 00       	call   341 <close>
 27f:	83 c4 10             	add    $0x10,%esp
  return r;
 282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <atoi>:

int
atoi(const char *s)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 28d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 294:	eb 25                	jmp    2bb <atoi+0x34>
    n = n*10 + *s++ - '0';
 296:	8b 55 fc             	mov    -0x4(%ebp),%edx
 299:	89 d0                	mov    %edx,%eax
 29b:	c1 e0 02             	shl    $0x2,%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	01 c0                	add    %eax,%eax
 2a2:	89 c1                	mov    %eax,%ecx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8d 50 01             	lea    0x1(%eax),%edx
 2aa:	89 55 08             	mov    %edx,0x8(%ebp)
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	0f be c0             	movsbl %al,%eax
 2b3:	01 c8                	add    %ecx,%eax
 2b5:	83 e8 30             	sub    $0x30,%eax
 2b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 2f                	cmp    $0x2f,%al
 2c3:	7e 0a                	jle    2cf <atoi+0x48>
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	3c 39                	cmp    $0x39,%al
 2cd:	7e c7                	jle    296 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2e6:	eb 17                	jmp    2ff <memmove+0x2b>
    *dst++ = *src++;
 2e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2eb:	8d 50 01             	lea    0x1(%eax),%edx
 2ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2f7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2fa:	0f b6 12             	movzbl (%edx),%edx
 2fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ff:	8b 45 10             	mov    0x10(%ebp),%eax
 302:	8d 50 ff             	lea    -0x1(%eax),%edx
 305:	89 55 10             	mov    %edx,0x10(%ebp)
 308:	85 c0                	test   %eax,%eax
 30a:	7f dc                	jg     2e8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 311:	b8 01 00 00 00       	mov    $0x1,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <exit>:
SYSCALL(exit)
 319:	b8 02 00 00 00       	mov    $0x2,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <wait>:
SYSCALL(wait)
 321:	b8 03 00 00 00       	mov    $0x3,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <pipe>:
SYSCALL(pipe)
 329:	b8 04 00 00 00       	mov    $0x4,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <read>:
SYSCALL(read)
 331:	b8 05 00 00 00       	mov    $0x5,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <write>:
SYSCALL(write)
 339:	b8 10 00 00 00       	mov    $0x10,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <close>:
SYSCALL(close)
 341:	b8 15 00 00 00       	mov    $0x15,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <kill>:
SYSCALL(kill)
 349:	b8 06 00 00 00       	mov    $0x6,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <exec>:
SYSCALL(exec)
 351:	b8 07 00 00 00       	mov    $0x7,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <open>:
SYSCALL(open)
 359:	b8 0f 00 00 00       	mov    $0xf,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mknod>:
SYSCALL(mknod)
 361:	b8 11 00 00 00       	mov    $0x11,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <unlink>:
SYSCALL(unlink)
 369:	b8 12 00 00 00       	mov    $0x12,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <fstat>:
SYSCALL(fstat)
 371:	b8 08 00 00 00       	mov    $0x8,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <link>:
SYSCALL(link)
 379:	b8 13 00 00 00       	mov    $0x13,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <mkdir>:
SYSCALL(mkdir)
 381:	b8 14 00 00 00       	mov    $0x14,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <chdir>:
SYSCALL(chdir)
 389:	b8 09 00 00 00       	mov    $0x9,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <dup>:
SYSCALL(dup)
 391:	b8 0a 00 00 00       	mov    $0xa,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <getpid>:
SYSCALL(getpid)
 399:	b8 0b 00 00 00       	mov    $0xb,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <sbrk>:
SYSCALL(sbrk)
 3a1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <sleep>:
SYSCALL(sleep)
 3a9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <uptime>:
SYSCALL(uptime)
 3b1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	83 ec 18             	sub    $0x18,%esp
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c5:	83 ec 04             	sub    $0x4,%esp
 3c8:	6a 01                	push   $0x1
 3ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3cd:	50                   	push   %eax
 3ce:	ff 75 08             	pushl  0x8(%ebp)
 3d1:	e8 63 ff ff ff       	call   339 <write>
 3d6:	83 c4 10             	add    $0x10,%esp
}
 3d9:	90                   	nop
 3da:	c9                   	leave  
 3db:	c3                   	ret    

000003dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	53                   	push   %ebx
 3e0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ee:	74 17                	je     407 <printint+0x2b>
 3f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f4:	79 11                	jns    407 <printint+0x2b>
    neg = 1;
 3f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	f7 d8                	neg    %eax
 402:	89 45 ec             	mov    %eax,-0x14(%ebp)
 405:	eb 06                	jmp    40d <printint+0x31>
  } else {
    x = xx;
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 414:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 417:	8d 41 01             	lea    0x1(%ecx),%eax
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 420:	8b 45 ec             	mov    -0x14(%ebp),%eax
 423:	ba 00 00 00 00       	mov    $0x0,%edx
 428:	f7 f3                	div    %ebx
 42a:	89 d0                	mov    %edx,%eax
 42c:	0f b6 80 a0 0a 00 00 	movzbl 0xaa0(%eax),%eax
 433:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 437:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43d:	ba 00 00 00 00       	mov    $0x0,%edx
 442:	f7 f3                	div    %ebx
 444:	89 45 ec             	mov    %eax,-0x14(%ebp)
 447:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44b:	75 c7                	jne    414 <printint+0x38>
  if(neg)
 44d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 451:	74 2d                	je     480 <printint+0xa4>
    buf[i++] = '-';
 453:	8b 45 f4             	mov    -0xc(%ebp),%eax
 456:	8d 50 01             	lea    0x1(%eax),%edx
 459:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 461:	eb 1d                	jmp    480 <printint+0xa4>
    putc(fd, buf[i]);
 463:	8d 55 dc             	lea    -0x24(%ebp),%edx
 466:	8b 45 f4             	mov    -0xc(%ebp),%eax
 469:	01 d0                	add    %edx,%eax
 46b:	0f b6 00             	movzbl (%eax),%eax
 46e:	0f be c0             	movsbl %al,%eax
 471:	83 ec 08             	sub    $0x8,%esp
 474:	50                   	push   %eax
 475:	ff 75 08             	pushl  0x8(%ebp)
 478:	e8 3c ff ff ff       	call   3b9 <putc>
 47d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 480:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 488:	79 d9                	jns    463 <printint+0x87>
    putc(fd, buf[i]);
}
 48a:	90                   	nop
 48b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48e:	c9                   	leave  
 48f:	c3                   	ret    

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49d:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a0:	83 c0 04             	add    $0x4,%eax
 4a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ad:	e9 59 01 00 00       	jmp    60b <printf+0x17b>
    c = fmt[i] & 0xff;
 4b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b8:	01 d0                	add    %edx,%eax
 4ba:	0f b6 00             	movzbl (%eax),%eax
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	25 ff 00 00 00       	and    $0xff,%eax
 4c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cc:	75 2c                	jne    4fa <printf+0x6a>
      if(c == '%'){
 4ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d2:	75 0c                	jne    4e0 <printf+0x50>
        state = '%';
 4d4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4db:	e9 27 01 00 00       	jmp    607 <printf+0x177>
      } else {
        putc(fd, c);
 4e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e3:	0f be c0             	movsbl %al,%eax
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 c7 fe ff ff       	call   3b9 <putc>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	e9 0d 01 00 00       	jmp    607 <printf+0x177>
      }
    } else if(state == '%'){
 4fa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fe:	0f 85 03 01 00 00    	jne    607 <printf+0x177>
      if(c == 'd'){
 504:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 508:	75 1e                	jne    528 <printf+0x98>
        printint(fd, *ap, 10, 1);
 50a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50d:	8b 00                	mov    (%eax),%eax
 50f:	6a 01                	push   $0x1
 511:	6a 0a                	push   $0xa
 513:	50                   	push   %eax
 514:	ff 75 08             	pushl  0x8(%ebp)
 517:	e8 c0 fe ff ff       	call   3dc <printint>
 51c:	83 c4 10             	add    $0x10,%esp
        ap++;
 51f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 523:	e9 d8 00 00 00       	jmp    600 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 528:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 52c:	74 06                	je     534 <printf+0xa4>
 52e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 532:	75 1e                	jne    552 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 534:	8b 45 e8             	mov    -0x18(%ebp),%eax
 537:	8b 00                	mov    (%eax),%eax
 539:	6a 00                	push   $0x0
 53b:	6a 10                	push   $0x10
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 96 fe ff ff       	call   3dc <printint>
 546:	83 c4 10             	add    $0x10,%esp
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	e9 ae 00 00 00       	jmp    600 <printf+0x170>
      } else if(c == 's'){
 552:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 556:	75 43                	jne    59b <printf+0x10b>
        s = (char*)*ap;
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 568:	75 25                	jne    58f <printf+0xff>
          s = "(null)";
 56a:	c7 45 f4 4d 08 00 00 	movl   $0x84d,-0xc(%ebp)
        while(*s != 0){
 571:	eb 1c                	jmp    58f <printf+0xff>
          putc(fd, *s);
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	50                   	push   %eax
 580:	ff 75 08             	pushl  0x8(%ebp)
 583:	e8 31 fe ff ff       	call   3b9 <putc>
 588:	83 c4 10             	add    $0x10,%esp
          s++;
 58b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	84 c0                	test   %al,%al
 597:	75 da                	jne    573 <printf+0xe3>
 599:	eb 65                	jmp    600 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59f:	75 1d                	jne    5be <printf+0x12e>
        putc(fd, *ap);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 04 fe ff ff       	call   3b9 <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	eb 42                	jmp    600 <printf+0x170>
      } else if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 17                	jne    5db <printf+0x14b>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	83 ec 08             	sub    $0x8,%esp
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 e3 fd ff ff       	call   3b9 <putc>
 5d6:	83 c4 10             	add    $0x10,%esp
 5d9:	eb 25                	jmp    600 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	83 ec 08             	sub    $0x8,%esp
 5de:	6a 25                	push   $0x25
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 d1 fd ff ff       	call   3b9 <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 bc fd ff ff       	call   3b9 <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 600:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 607:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60b:	8b 55 0c             	mov    0xc(%ebp),%edx
 60e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 611:	01 d0                	add    %edx,%eax
 613:	0f b6 00             	movzbl (%eax),%eax
 616:	84 c0                	test   %al,%al
 618:	0f 85 94 fe ff ff    	jne    4b2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61e:	90                   	nop
 61f:	c9                   	leave  
 620:	c3                   	ret    

00000621 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 621:	55                   	push   %ebp
 622:	89 e5                	mov    %esp,%ebp
 624:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	83 e8 08             	sub    $0x8,%eax
 62d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	a1 bc 0a 00 00       	mov    0xabc,%eax
 635:	89 45 fc             	mov    %eax,-0x4(%ebp)
 638:	eb 24                	jmp    65e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 12                	ja     656 <free+0x35>
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64a:	77 24                	ja     670 <free+0x4f>
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 654:	77 1a                	ja     670 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 664:	76 d4                	jbe    63a <free+0x19>
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66e:	76 ca                	jbe    63a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	01 c2                	add    %eax,%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	39 c2                	cmp    %eax,%edx
 689:	75 24                	jne    6af <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	8b 40 04             	mov    0x4(%eax),%eax
 699:	01 c2                	add    %eax,%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 0a                	jmp    6b9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	01 d0                	add    %edx,%eax
 6cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ce:	75 20                	jne    6f0 <free+0xcf>
    p->s.size += bp->s.size;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 10                	mov    (%eax),%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 10                	mov    %edx,(%eax)
 6ee:	eb 08                	jmp    6f8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	a3 bc 0a 00 00       	mov    %eax,0xabc
}
 700:	90                   	nop
 701:	c9                   	leave  
 702:	c3                   	ret    

00000703 <morecore>:

static Header*
morecore(uint nu)
{
 703:	55                   	push   %ebp
 704:	89 e5                	mov    %esp,%ebp
 706:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 709:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 710:	77 07                	ja     719 <morecore+0x16>
    nu = 4096;
 712:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	c1 e0 03             	shl    $0x3,%eax
 71f:	83 ec 0c             	sub    $0xc,%esp
 722:	50                   	push   %eax
 723:	e8 79 fc ff ff       	call   3a1 <sbrk>
 728:	83 c4 10             	add    $0x10,%esp
 72b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 732:	75 07                	jne    73b <morecore+0x38>
    return 0;
 734:	b8 00 00 00 00       	mov    $0x0,%eax
 739:	eb 26                	jmp    761 <morecore+0x5e>
  hp = (Header*)p;
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	8b 55 08             	mov    0x8(%ebp),%edx
 747:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	83 c0 08             	add    $0x8,%eax
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	50                   	push   %eax
 754:	e8 c8 fe ff ff       	call   621 <free>
 759:	83 c4 10             	add    $0x10,%esp
  return freep;
 75c:	a1 bc 0a 00 00       	mov    0xabc,%eax
}
 761:	c9                   	leave  
 762:	c3                   	ret    

00000763 <malloc>:

void*
malloc(uint nbytes)
{
 763:	55                   	push   %ebp
 764:	89 e5                	mov    %esp,%ebp
 766:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	83 c0 07             	add    $0x7,%eax
 76f:	c1 e8 03             	shr    $0x3,%eax
 772:	83 c0 01             	add    $0x1,%eax
 775:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 778:	a1 bc 0a 00 00       	mov    0xabc,%eax
 77d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 780:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 784:	75 23                	jne    7a9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 786:	c7 45 f0 b4 0a 00 00 	movl   $0xab4,-0x10(%ebp)
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	a3 bc 0a 00 00       	mov    %eax,0xabc
 795:	a1 bc 0a 00 00       	mov    0xabc,%eax
 79a:	a3 b4 0a 00 00       	mov    %eax,0xab4
    base.s.size = 0;
 79f:	c7 05 b8 0a 00 00 00 	movl   $0x0,0xab8
 7a6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ba:	72 4d                	jb     809 <malloc+0xa6>
      if(p->s.size == nunits)
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c5:	75 0c                	jne    7d3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 10                	mov    (%eax),%edx
 7cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cf:	89 10                	mov    %edx,(%eax)
 7d1:	eb 26                	jmp    7f9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7dc:	89 c2                	mov    %eax,%edx
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	c1 e0 03             	shl    $0x3,%eax
 7ed:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	a3 bc 0a 00 00       	mov    %eax,0xabc
      return (void*)(p + 1);
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	83 c0 08             	add    $0x8,%eax
 807:	eb 3b                	jmp    844 <malloc+0xe1>
    }
    if(p == freep)
 809:	a1 bc 0a 00 00       	mov    0xabc,%eax
 80e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 811:	75 1e                	jne    831 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 813:	83 ec 0c             	sub    $0xc,%esp
 816:	ff 75 ec             	pushl  -0x14(%ebp)
 819:	e8 e5 fe ff ff       	call   703 <morecore>
 81e:	83 c4 10             	add    $0x10,%esp
 821:	89 45 f4             	mov    %eax,-0xc(%ebp)
 824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 828:	75 07                	jne    831 <malloc+0xce>
        return 0;
 82a:	b8 00 00 00 00       	mov    $0x0,%eax
 82f:	eb 13                	jmp    844 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	89 45 f0             	mov    %eax,-0x10(%ebp)
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83f:	e9 6d ff ff ff       	jmp    7b1 <malloc+0x4e>
}
 844:	c9                   	leave  
 845:	c3                   	ret    
