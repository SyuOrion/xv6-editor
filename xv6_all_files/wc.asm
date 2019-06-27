
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 20 0c 00 00       	add    $0xc20,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 20 0c 00 00       	add    $0xc20,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 41 09 00 00       	push   $0x941
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 20 0c 00 00       	push   $0xc20
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 8c 03 00 00       	call   42c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 47 09 00 00       	push   $0x947
  be:	6a 01                	push   $0x1
  c0:	e8 c6 04 00 00       	call   58b <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 47 03 00 00       	call   414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 57 09 00 00       	push   $0x957
  e1:	6a 01                	push   $0x1
  e3:	e8 a3 04 00 00       	call   58b <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 64 09 00 00       	push   $0x964
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 f6 02 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 0e 03 00 00       	call   454 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 65 09 00 00       	push   $0x965
 16c:	6a 01                	push   $0x1
 16e:	e8 18 04 00 00       	call   58b <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 99 02 00 00       	call   414 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 96 02 00 00       	call   43c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 57 02 00 00       	call   414 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 47 01 00 00       	call   42c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 0c 01 00 00       	call   454 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 03 01 00 00       	call   46c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 c2 00 00 00       	call   43c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ef:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	83 ec 18             	sub    $0x18,%esp
 4ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	6a 01                	push   $0x1
 4c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c8:	50                   	push   %eax
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 63 ff ff ff       	call   434 <write>
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	90                   	nop
 4d5:	c9                   	leave  
 4d6:	c3                   	ret    

000004d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	53                   	push   %ebx
 4db:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e9:	74 17                	je     502 <printint+0x2b>
 4eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ef:	79 11                	jns    502 <printint+0x2b>
    neg = 1;
 4f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	f7 d8                	neg    %eax
 4fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 500:	eb 06                	jmp    508 <printint+0x31>
  } else {
    x = xx;
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 508:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 50f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 512:	8d 41 01             	lea    0x1(%ecx),%eax
 515:	89 45 f4             	mov    %eax,-0xc(%ebp)
 518:	8b 5d 10             	mov    0x10(%ebp),%ebx
 51b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51e:	ba 00 00 00 00       	mov    $0x0,%edx
 523:	f7 f3                	div    %ebx
 525:	89 d0                	mov    %edx,%eax
 527:	0f b6 80 ec 0b 00 00 	movzbl 0xbec(%eax),%eax
 52e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 532:	8b 5d 10             	mov    0x10(%ebp),%ebx
 535:	8b 45 ec             	mov    -0x14(%ebp),%eax
 538:	ba 00 00 00 00       	mov    $0x0,%edx
 53d:	f7 f3                	div    %ebx
 53f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 542:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 546:	75 c7                	jne    50f <printint+0x38>
  if(neg)
 548:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54c:	74 2d                	je     57b <printint+0xa4>
    buf[i++] = '-';
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	8d 50 01             	lea    0x1(%eax),%edx
 554:	89 55 f4             	mov    %edx,-0xc(%ebp)
 557:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 55c:	eb 1d                	jmp    57b <printint+0xa4>
    putc(fd, buf[i]);
 55e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 561:	8b 45 f4             	mov    -0xc(%ebp),%eax
 564:	01 d0                	add    %edx,%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	83 ec 08             	sub    $0x8,%esp
 56f:	50                   	push   %eax
 570:	ff 75 08             	pushl  0x8(%ebp)
 573:	e8 3c ff ff ff       	call   4b4 <putc>
 578:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 57f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 583:	79 d9                	jns    55e <printint+0x87>
    putc(fd, buf[i]);
}
 585:	90                   	nop
 586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 589:	c9                   	leave  
 58a:	c3                   	ret    

0000058b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp
 58e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 598:	8d 45 0c             	lea    0xc(%ebp),%eax
 59b:	83 c0 04             	add    $0x4,%eax
 59e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a8:	e9 59 01 00 00       	jmp    706 <printf+0x17b>
    c = fmt[i] & 0xff;
 5ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b3:	01 d0                	add    %edx,%eax
 5b5:	0f b6 00             	movzbl (%eax),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	25 ff 00 00 00       	and    $0xff,%eax
 5c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c7:	75 2c                	jne    5f5 <printf+0x6a>
      if(c == '%'){
 5c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cd:	75 0c                	jne    5db <printf+0x50>
        state = '%';
 5cf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5d6:	e9 27 01 00 00       	jmp    702 <printf+0x177>
      } else {
        putc(fd, c);
 5db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 c7 fe ff ff       	call   4b4 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	e9 0d 01 00 00       	jmp    702 <printf+0x177>
      }
    } else if(state == '%'){
 5f5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f9:	0f 85 03 01 00 00    	jne    702 <printf+0x177>
      if(c == 'd'){
 5ff:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 603:	75 1e                	jne    623 <printf+0x98>
        printint(fd, *ap, 10, 1);
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	6a 01                	push   $0x1
 60c:	6a 0a                	push   $0xa
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 c0 fe ff ff       	call   4d7 <printint>
 617:	83 c4 10             	add    $0x10,%esp
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	e9 d8 00 00 00       	jmp    6fb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 623:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 627:	74 06                	je     62f <printf+0xa4>
 629:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 62d:	75 1e                	jne    64d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 62f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	6a 00                	push   $0x0
 636:	6a 10                	push   $0x10
 638:	50                   	push   %eax
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 96 fe ff ff       	call   4d7 <printint>
 641:	83 c4 10             	add    $0x10,%esp
        ap++;
 644:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 648:	e9 ae 00 00 00       	jmp    6fb <printf+0x170>
      } else if(c == 's'){
 64d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 651:	75 43                	jne    696 <printf+0x10b>
        s = (char*)*ap;
 653:	8b 45 e8             	mov    -0x18(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 65b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 65f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 663:	75 25                	jne    68a <printf+0xff>
          s = "(null)";
 665:	c7 45 f4 79 09 00 00 	movl   $0x979,-0xc(%ebp)
        while(*s != 0){
 66c:	eb 1c                	jmp    68a <printf+0xff>
          putc(fd, *s);
 66e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 671:	0f b6 00             	movzbl (%eax),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	83 ec 08             	sub    $0x8,%esp
 67a:	50                   	push   %eax
 67b:	ff 75 08             	pushl  0x8(%ebp)
 67e:	e8 31 fe ff ff       	call   4b4 <putc>
 683:	83 c4 10             	add    $0x10,%esp
          s++;
 686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68d:	0f b6 00             	movzbl (%eax),%eax
 690:	84 c0                	test   %al,%al
 692:	75 da                	jne    66e <printf+0xe3>
 694:	eb 65                	jmp    6fb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 696:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69a:	75 1d                	jne    6b9 <printf+0x12e>
        putc(fd, *ap);
 69c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	83 ec 08             	sub    $0x8,%esp
 6a7:	50                   	push   %eax
 6a8:	ff 75 08             	pushl  0x8(%ebp)
 6ab:	e8 04 fe ff ff       	call   4b4 <putc>
 6b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b7:	eb 42                	jmp    6fb <printf+0x170>
      } else if(c == '%'){
 6b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6bd:	75 17                	jne    6d6 <printf+0x14b>
        putc(fd, c);
 6bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	50                   	push   %eax
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 e3 fd ff ff       	call   4b4 <putc>
 6d1:	83 c4 10             	add    $0x10,%esp
 6d4:	eb 25                	jmp    6fb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	6a 25                	push   $0x25
 6db:	ff 75 08             	pushl  0x8(%ebp)
 6de:	e8 d1 fd ff ff       	call   4b4 <putc>
 6e3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e9:	0f be c0             	movsbl %al,%eax
 6ec:	83 ec 08             	sub    $0x8,%esp
 6ef:	50                   	push   %eax
 6f0:	ff 75 08             	pushl  0x8(%ebp)
 6f3:	e8 bc fd ff ff       	call   4b4 <putc>
 6f8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 702:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 706:	8b 55 0c             	mov    0xc(%ebp),%edx
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	0f b6 00             	movzbl (%eax),%eax
 711:	84 c0                	test   %al,%al
 713:	0f 85 94 fe ff ff    	jne    5ad <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 719:	90                   	nop
 71a:	c9                   	leave  
 71b:	c3                   	ret    

0000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	83 e8 08             	sub    $0x8,%eax
 728:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72b:	a1 08 0c 00 00       	mov    0xc08,%eax
 730:	89 45 fc             	mov    %eax,-0x4(%ebp)
 733:	eb 24                	jmp    759 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73d:	77 12                	ja     751 <free+0x35>
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 745:	77 24                	ja     76b <free+0x4f>
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74f:	77 1a                	ja     76b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	89 45 fc             	mov    %eax,-0x4(%ebp)
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75f:	76 d4                	jbe    735 <free+0x19>
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	8b 00                	mov    (%eax),%eax
 766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 769:	76 ca                	jbe    735 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	8b 40 04             	mov    0x4(%eax),%eax
 771:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 778:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77b:	01 c2                	add    %eax,%edx
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	39 c2                	cmp    %eax,%edx
 784:	75 24                	jne    7aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	8b 50 04             	mov    0x4(%eax),%edx
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	01 c2                	add    %eax,%edx
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	8b 10                	mov    (%eax),%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	89 10                	mov    %edx,(%eax)
 7a8:	eb 0a                	jmp    7b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 10                	mov    (%eax),%edx
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	01 d0                	add    %edx,%eax
 7c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c9:	75 20                	jne    7eb <free+0xcf>
    p->s.size += bp->s.size;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 50 04             	mov    0x4(%eax),%edx
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	01 c2                	add    %eax,%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	89 10                	mov    %edx,(%eax)
 7e9:	eb 08                	jmp    7f3 <free+0xd7>
  } else
    p->s.ptr = bp;
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7fb:	90                   	nop
 7fc:	c9                   	leave  
 7fd:	c3                   	ret    

000007fe <morecore>:

static Header*
morecore(uint nu)
{
 7fe:	55                   	push   %ebp
 7ff:	89 e5                	mov    %esp,%ebp
 801:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 804:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80b:	77 07                	ja     814 <morecore+0x16>
    nu = 4096;
 80d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	c1 e0 03             	shl    $0x3,%eax
 81a:	83 ec 0c             	sub    $0xc,%esp
 81d:	50                   	push   %eax
 81e:	e8 79 fc ff ff       	call   49c <sbrk>
 823:	83 c4 10             	add    $0x10,%esp
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 829:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82d:	75 07                	jne    836 <morecore+0x38>
    return 0;
 82f:	b8 00 00 00 00       	mov    $0x0,%eax
 834:	eb 26                	jmp    85c <morecore+0x5e>
  hp = (Header*)p;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	8b 55 08             	mov    0x8(%ebp),%edx
 842:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	50                   	push   %eax
 84f:	e8 c8 fe ff ff       	call   71c <free>
 854:	83 c4 10             	add    $0x10,%esp
  return freep;
 857:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 85c:	c9                   	leave  
 85d:	c3                   	ret    

0000085e <malloc>:

void*
malloc(uint nbytes)
{
 85e:	55                   	push   %ebp
 85f:	89 e5                	mov    %esp,%ebp
 861:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	83 c0 07             	add    $0x7,%eax
 86a:	c1 e8 03             	shr    $0x3,%eax
 86d:	83 c0 01             	add    $0x1,%eax
 870:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 873:	a1 08 0c 00 00       	mov    0xc08,%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87f:	75 23                	jne    8a4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 881:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	a3 08 0c 00 00       	mov    %eax,0xc08
 890:	a1 08 0c 00 00       	mov    0xc08,%eax
 895:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 89a:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 8a1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b5:	72 4d                	jb     904 <malloc+0xa6>
      if(p->s.size == nunits)
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c0:	75 0c                	jne    8ce <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	8b 10                	mov    (%eax),%edx
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ca:	89 10                	mov    %edx,(%eax)
 8cc:	eb 26                	jmp    8f4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	8b 40 04             	mov    0x4(%eax),%eax
 8d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d7:	89 c2                	mov    %eax,%edx
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	c1 e0 03             	shl    $0x3,%eax
 8e8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f7:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	83 c0 08             	add    $0x8,%eax
 902:	eb 3b                	jmp    93f <malloc+0xe1>
    }
    if(p == freep)
 904:	a1 08 0c 00 00       	mov    0xc08,%eax
 909:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 90c:	75 1e                	jne    92c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 90e:	83 ec 0c             	sub    $0xc,%esp
 911:	ff 75 ec             	pushl  -0x14(%ebp)
 914:	e8 e5 fe ff ff       	call   7fe <morecore>
 919:	83 c4 10             	add    $0x10,%esp
 91c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 91f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 923:	75 07                	jne    92c <malloc+0xce>
        return 0;
 925:	b8 00 00 00 00       	mov    $0x0,%eax
 92a:	eb 13                	jmp    93f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	8b 00                	mov    (%eax),%eax
 937:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 93a:	e9 6d ff ff ff       	jmp    8ac <malloc+0x4e>
}
 93f:	c9                   	leave  
 940:	c3                   	ret    
