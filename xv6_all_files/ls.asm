
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c9 03 00 00       	call   3db <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 95 03 00 00       	call   3db <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7d 03 00 00       	call   3db <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 d0 0d 00 00       	push   $0xdd0
  6d:	e8 e6 04 00 00       	call   558 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5b 03 00 00       	call   3db <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 44 03 00 00       	call   3db <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 d0 0d 00 00       	add    $0xdd0,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 d0 0d 00 00       	mov    $0xdd0,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 0c 05 00 00       	call   5dd <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 ca 0a 00 00       	push   $0xaca
  e8:	6a 02                	push   $0x2
  ea:	e8 25 06 00 00       	call   714 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 ec 04 00 00       	call   5f5 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 de 0a 00 00       	push   $0xade
 11b:	6a 02                	push   $0x2
 11d:	e8 f2 05 00 00       	call   714 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 95 04 00 00       	call   5c5 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 f2 0a 00 00       	push   $0xaf2
 17e:	6a 01                	push   $0x1
 180:	e8 8f 05 00 00       	call   714 <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 43 02 00 00       	call   3db <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 ff 0a 00 00       	push   $0xaff
 1ad:	6a 01                	push   $0x1
 1af:	e8 60 05 00 00       	call   714 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9e 01 00 00       	call   36c <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fb 01 00 00       	call   3db <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 2f 03 00 00       	call   558 <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 73 02 00 00       	call   4be <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 de 0a 00 00       	push   $0xade
 261:	6a 01                	push   $0x1
 263:	e8 ac 04 00 00       	call   714 <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 f2 0a 00 00       	push   $0xaf2
 2a1:	6a 01                	push   $0x1
 2a3:	e8 6c 04 00 00       	call   714 <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 f6 02 00 00       	call   5b5 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 ee 02 00 00       	call   5c5 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 12 0b 00 00       	push   $0xb12
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 8d 02 00 00       	call   59d <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 57 02 00 00       	call   59d <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	90                   	nop
 368:	5b                   	pop    %ebx
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 378:	90                   	nop
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8d 50 01             	lea    0x1(%eax),%edx
 37f:	89 55 08             	mov    %edx,0x8(%ebp)
 382:	8b 55 0c             	mov    0xc(%ebp),%edx
 385:	8d 4a 01             	lea    0x1(%edx),%ecx
 388:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strcpy+0xd>
    ;
  return os;
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39f:	eb 08                	jmp    3a9 <strcmp+0xd>
    p++, q++;
 3a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 10                	je     3c3 <strcmp+0x27>
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 10             	movzbl (%eax),%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	38 c2                	cmp    %al,%dl
 3c1:	74 de                	je     3a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	0f b6 d0             	movzbl %al,%edx
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	0f b6 c0             	movzbl %al,%eax
 3d5:	29 c2                	sub    %eax,%edx
 3d7:	89 d0                	mov    %edx,%eax
}
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <strlen>:

uint
strlen(char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e8:	eb 04                	jmp    3ee <strlen+0x13>
 3ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	75 ed                	jne    3ea <strlen+0xf>
    ;
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 0c             	pushl  0xc(%ebp)
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 32 ff ff ff       	call   346 <stosb>
 414:	83 c4 0c             	add    $0xc,%esp
  return dst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 428:	eb 14                	jmp    43e <strchr+0x22>
    if(*s == c)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3a 45 fc             	cmp    -0x4(%ebp),%al
 433:	75 05                	jne    43a <strchr+0x1e>
      return (char*)s;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	eb 13                	jmp    44d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 448:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <gets>:

char*
gets(char *buf, int max)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45c:	eb 42                	jmp    4a0 <gets+0x51>
    cc = read(0, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 ef             	lea    -0x11(%ebp),%eax
 466:	50                   	push   %eax
 467:	6a 00                	push   $0x0
 469:	e8 47 01 00 00       	call   5b5 <read>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	7e 33                	jle    4ad <gets+0x5e>
      break;
    buf[i++] = c;
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 c2                	add    %eax,%edx
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 16                	je     4ae <gets+0x5f>
 498:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49c:	3c 0d                	cmp    $0xd,%al
 49e:	74 0e                	je     4ae <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	83 c0 01             	add    $0x1,%eax
 4a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a9:	7c b3                	jl     45e <gets+0xf>
 4ab:	eb 01                	jmp    4ae <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4ad:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	c9                   	leave  
 4bd:	c3                   	ret    

000004be <stat>:

int
stat(char *n, struct stat *st)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 0c 01 00 00       	call   5dd <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x26>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4b>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	pushl  0xc(%ebp)
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 03 01 00 00       	call   5f5 <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	pushl  -0xc(%ebp)
 4fe:	e8 c2 00 00 00       	call   5c5 <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 518:	eb 25                	jmp    53f <atoi+0x34>
    n = n*10 + *s++ - '0';
 51a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51d:	89 d0                	mov    %edx,%eax
 51f:	c1 e0 02             	shl    $0x2,%eax
 522:	01 d0                	add    %edx,%eax
 524:	01 c0                	add    %eax,%eax
 526:	89 c1                	mov    %eax,%ecx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	8d 50 01             	lea    0x1(%eax),%edx
 52e:	89 55 08             	mov    %edx,0x8(%ebp)
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	01 c8                	add    %ecx,%eax
 539:	83 e8 30             	sub    $0x30,%eax
 53c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	3c 2f                	cmp    $0x2f,%al
 547:	7e 0a                	jle    553 <atoi+0x48>
 549:	8b 45 08             	mov    0x8(%ebp),%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	3c 39                	cmp    $0x39,%al
 551:	7e c7                	jle    51a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 553:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 556:	c9                   	leave  
 557:	c3                   	ret    

00000558 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 564:	8b 45 0c             	mov    0xc(%ebp),%eax
 567:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 56a:	eb 17                	jmp    583 <memmove+0x2b>
    *dst++ = *src++;
 56c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56f:	8d 50 01             	lea    0x1(%eax),%edx
 572:	89 55 fc             	mov    %edx,-0x4(%ebp)
 575:	8b 55 f8             	mov    -0x8(%ebp),%edx
 578:	8d 4a 01             	lea    0x1(%edx),%ecx
 57b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 57e:	0f b6 12             	movzbl (%edx),%edx
 581:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 583:	8b 45 10             	mov    0x10(%ebp),%eax
 586:	8d 50 ff             	lea    -0x1(%eax),%edx
 589:	89 55 10             	mov    %edx,0x10(%ebp)
 58c:	85 c0                	test   %eax,%eax
 58e:	7f dc                	jg     56c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 590:	8b 45 08             	mov    0x8(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 595:	b8 01 00 00 00       	mov    $0x1,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <exit>:
SYSCALL(exit)
 59d:	b8 02 00 00 00       	mov    $0x2,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <wait>:
SYSCALL(wait)
 5a5:	b8 03 00 00 00       	mov    $0x3,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <pipe>:
SYSCALL(pipe)
 5ad:	b8 04 00 00 00       	mov    $0x4,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <read>:
SYSCALL(read)
 5b5:	b8 05 00 00 00       	mov    $0x5,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <write>:
SYSCALL(write)
 5bd:	b8 10 00 00 00       	mov    $0x10,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <close>:
SYSCALL(close)
 5c5:	b8 15 00 00 00       	mov    $0x15,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <kill>:
SYSCALL(kill)
 5cd:	b8 06 00 00 00       	mov    $0x6,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <exec>:
SYSCALL(exec)
 5d5:	b8 07 00 00 00       	mov    $0x7,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <open>:
SYSCALL(open)
 5dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <mknod>:
SYSCALL(mknod)
 5e5:	b8 11 00 00 00       	mov    $0x11,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <unlink>:
SYSCALL(unlink)
 5ed:	b8 12 00 00 00       	mov    $0x12,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <fstat>:
SYSCALL(fstat)
 5f5:	b8 08 00 00 00       	mov    $0x8,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <link>:
SYSCALL(link)
 5fd:	b8 13 00 00 00       	mov    $0x13,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <mkdir>:
SYSCALL(mkdir)
 605:	b8 14 00 00 00       	mov    $0x14,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <chdir>:
SYSCALL(chdir)
 60d:	b8 09 00 00 00       	mov    $0x9,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <dup>:
SYSCALL(dup)
 615:	b8 0a 00 00 00       	mov    $0xa,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <getpid>:
SYSCALL(getpid)
 61d:	b8 0b 00 00 00       	mov    $0xb,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <sbrk>:
SYSCALL(sbrk)
 625:	b8 0c 00 00 00       	mov    $0xc,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <sleep>:
SYSCALL(sleep)
 62d:	b8 0d 00 00 00       	mov    $0xd,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <uptime>:
SYSCALL(uptime)
 635:	b8 0e 00 00 00       	mov    $0xe,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 18             	sub    $0x18,%esp
 643:	8b 45 0c             	mov    0xc(%ebp),%eax
 646:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 649:	83 ec 04             	sub    $0x4,%esp
 64c:	6a 01                	push   $0x1
 64e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 651:	50                   	push   %eax
 652:	ff 75 08             	pushl  0x8(%ebp)
 655:	e8 63 ff ff ff       	call   5bd <write>
 65a:	83 c4 10             	add    $0x10,%esp
}
 65d:	90                   	nop
 65e:	c9                   	leave  
 65f:	c3                   	ret    

00000660 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	53                   	push   %ebx
 664:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 667:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 66e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 672:	74 17                	je     68b <printint+0x2b>
 674:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 678:	79 11                	jns    68b <printint+0x2b>
    neg = 1;
 67a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 681:	8b 45 0c             	mov    0xc(%ebp),%eax
 684:	f7 d8                	neg    %eax
 686:	89 45 ec             	mov    %eax,-0x14(%ebp)
 689:	eb 06                	jmp    691 <printint+0x31>
  } else {
    x = xx;
 68b:	8b 45 0c             	mov    0xc(%ebp),%eax
 68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 698:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 69b:	8d 41 01             	lea    0x1(%ecx),%eax
 69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a7:	ba 00 00 00 00       	mov    $0x0,%edx
 6ac:	f7 f3                	div    %ebx
 6ae:	89 d0                	mov    %edx,%eax
 6b0:	0f b6 80 bc 0d 00 00 	movzbl 0xdbc(%eax),%eax
 6b7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c1:	ba 00 00 00 00       	mov    $0x0,%edx
 6c6:	f7 f3                	div    %ebx
 6c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6cf:	75 c7                	jne    698 <printint+0x38>
  if(neg)
 6d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d5:	74 2d                	je     704 <printint+0xa4>
    buf[i++] = '-';
 6d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6da:	8d 50 01             	lea    0x1(%eax),%edx
 6dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e5:	eb 1d                	jmp    704 <printint+0xa4>
    putc(fd, buf[i]);
 6e7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ed:	01 d0                	add    %edx,%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 3c ff ff ff       	call   63d <putc>
 701:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 704:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70c:	79 d9                	jns    6e7 <printint+0x87>
    putc(fd, buf[i]);
}
 70e:	90                   	nop
 70f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 712:	c9                   	leave  
 713:	c3                   	ret    

00000714 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 71a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 721:	8d 45 0c             	lea    0xc(%ebp),%eax
 724:	83 c0 04             	add    $0x4,%eax
 727:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 72a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 731:	e9 59 01 00 00       	jmp    88f <printf+0x17b>
    c = fmt[i] & 0xff;
 736:	8b 55 0c             	mov    0xc(%ebp),%edx
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	01 d0                	add    %edx,%eax
 73e:	0f b6 00             	movzbl (%eax),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	25 ff 00 00 00       	and    $0xff,%eax
 749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 74c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 750:	75 2c                	jne    77e <printf+0x6a>
      if(c == '%'){
 752:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 756:	75 0c                	jne    764 <printf+0x50>
        state = '%';
 758:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 75f:	e9 27 01 00 00       	jmp    88b <printf+0x177>
      } else {
        putc(fd, c);
 764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 c7 fe ff ff       	call   63d <putc>
 776:	83 c4 10             	add    $0x10,%esp
 779:	e9 0d 01 00 00       	jmp    88b <printf+0x177>
      }
    } else if(state == '%'){
 77e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 782:	0f 85 03 01 00 00    	jne    88b <printf+0x177>
      if(c == 'd'){
 788:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 78c:	75 1e                	jne    7ac <printf+0x98>
        printint(fd, *ap, 10, 1);
 78e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	6a 01                	push   $0x1
 795:	6a 0a                	push   $0xa
 797:	50                   	push   %eax
 798:	ff 75 08             	pushl  0x8(%ebp)
 79b:	e8 c0 fe ff ff       	call   660 <printint>
 7a0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a7:	e9 d8 00 00 00       	jmp    884 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7ac:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b0:	74 06                	je     7b8 <printf+0xa4>
 7b2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b6:	75 1e                	jne    7d6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	6a 00                	push   $0x0
 7bf:	6a 10                	push   $0x10
 7c1:	50                   	push   %eax
 7c2:	ff 75 08             	pushl  0x8(%ebp)
 7c5:	e8 96 fe ff ff       	call   660 <printint>
 7ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d1:	e9 ae 00 00 00       	jmp    884 <printf+0x170>
      } else if(c == 's'){
 7d6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7da:	75 43                	jne    81f <printf+0x10b>
        s = (char*)*ap;
 7dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ec:	75 25                	jne    813 <printf+0xff>
          s = "(null)";
 7ee:	c7 45 f4 14 0b 00 00 	movl   $0xb14,-0xc(%ebp)
        while(*s != 0){
 7f5:	eb 1c                	jmp    813 <printf+0xff>
          putc(fd, *s);
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	0f b6 00             	movzbl (%eax),%eax
 7fd:	0f be c0             	movsbl %al,%eax
 800:	83 ec 08             	sub    $0x8,%esp
 803:	50                   	push   %eax
 804:	ff 75 08             	pushl  0x8(%ebp)
 807:	e8 31 fe ff ff       	call   63d <putc>
 80c:	83 c4 10             	add    $0x10,%esp
          s++;
 80f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	0f b6 00             	movzbl (%eax),%eax
 819:	84 c0                	test   %al,%al
 81b:	75 da                	jne    7f7 <printf+0xe3>
 81d:	eb 65                	jmp    884 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 823:	75 1d                	jne    842 <printf+0x12e>
        putc(fd, *ap);
 825:	8b 45 e8             	mov    -0x18(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	0f be c0             	movsbl %al,%eax
 82d:	83 ec 08             	sub    $0x8,%esp
 830:	50                   	push   %eax
 831:	ff 75 08             	pushl  0x8(%ebp)
 834:	e8 04 fe ff ff       	call   63d <putc>
 839:	83 c4 10             	add    $0x10,%esp
        ap++;
 83c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 840:	eb 42                	jmp    884 <printf+0x170>
      } else if(c == '%'){
 842:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 846:	75 17                	jne    85f <printf+0x14b>
        putc(fd, c);
 848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84b:	0f be c0             	movsbl %al,%eax
 84e:	83 ec 08             	sub    $0x8,%esp
 851:	50                   	push   %eax
 852:	ff 75 08             	pushl  0x8(%ebp)
 855:	e8 e3 fd ff ff       	call   63d <putc>
 85a:	83 c4 10             	add    $0x10,%esp
 85d:	eb 25                	jmp    884 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 85f:	83 ec 08             	sub    $0x8,%esp
 862:	6a 25                	push   $0x25
 864:	ff 75 08             	pushl  0x8(%ebp)
 867:	e8 d1 fd ff ff       	call   63d <putc>
 86c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 86f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 872:	0f be c0             	movsbl %al,%eax
 875:	83 ec 08             	sub    $0x8,%esp
 878:	50                   	push   %eax
 879:	ff 75 08             	pushl  0x8(%ebp)
 87c:	e8 bc fd ff ff       	call   63d <putc>
 881:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 884:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 88b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 88f:	8b 55 0c             	mov    0xc(%ebp),%edx
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	01 d0                	add    %edx,%eax
 897:	0f b6 00             	movzbl (%eax),%eax
 89a:	84 c0                	test   %al,%al
 89c:	0f 85 94 fe ff ff    	jne    736 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a2:	90                   	nop
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    

000008a5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a5:	55                   	push   %ebp
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ab:	8b 45 08             	mov    0x8(%ebp),%eax
 8ae:	83 e8 08             	sub    $0x8,%eax
 8b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	a1 e8 0d 00 00       	mov    0xde8,%eax
 8b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8bc:	eb 24                	jmp    8e2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c6:	77 12                	ja     8da <free+0x35>
 8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ce:	77 24                	ja     8f4 <free+0x4f>
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d8:	77 1a                	ja     8f4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	8b 00                	mov    (%eax),%eax
 8df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e8:	76 d4                	jbe    8be <free+0x19>
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f2:	76 ca                	jbe    8be <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	8b 40 04             	mov    0x4(%eax),%eax
 8fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 901:	8b 45 f8             	mov    -0x8(%ebp),%eax
 904:	01 c2                	add    %eax,%edx
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	8b 00                	mov    (%eax),%eax
 90b:	39 c2                	cmp    %eax,%edx
 90d:	75 24                	jne    933 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	8b 50 04             	mov    0x4(%eax),%edx
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	8b 40 04             	mov    0x4(%eax),%eax
 91d:	01 c2                	add    %eax,%edx
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	8b 10                	mov    (%eax),%edx
 92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92f:	89 10                	mov    %edx,(%eax)
 931:	eb 0a                	jmp    93d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 10                	mov    (%eax),%edx
 938:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	01 d0                	add    %edx,%eax
 94f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 952:	75 20                	jne    974 <free+0xcf>
    p->s.size += bp->s.size;
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 50 04             	mov    0x4(%eax),%edx
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	8b 40 04             	mov    0x4(%eax),%eax
 960:	01 c2                	add    %eax,%edx
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 968:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96b:	8b 10                	mov    (%eax),%edx
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	89 10                	mov    %edx,(%eax)
 972:	eb 08                	jmp    97c <free+0xd7>
  } else
    p->s.ptr = bp;
 974:	8b 45 fc             	mov    -0x4(%ebp),%eax
 977:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97a:	89 10                	mov    %edx,(%eax)
  freep = p;
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 984:	90                   	nop
 985:	c9                   	leave  
 986:	c3                   	ret    

00000987 <morecore>:

static Header*
morecore(uint nu)
{
 987:	55                   	push   %ebp
 988:	89 e5                	mov    %esp,%ebp
 98a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 98d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 994:	77 07                	ja     99d <morecore+0x16>
    nu = 4096;
 996:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 99d:	8b 45 08             	mov    0x8(%ebp),%eax
 9a0:	c1 e0 03             	shl    $0x3,%eax
 9a3:	83 ec 0c             	sub    $0xc,%esp
 9a6:	50                   	push   %eax
 9a7:	e8 79 fc ff ff       	call   625 <sbrk>
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b6:	75 07                	jne    9bf <morecore+0x38>
    return 0;
 9b8:	b8 00 00 00 00       	mov    $0x0,%eax
 9bd:	eb 26                	jmp    9e5 <morecore+0x5e>
  hp = (Header*)p;
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c8:	8b 55 08             	mov    0x8(%ebp),%edx
 9cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d1:	83 c0 08             	add    $0x8,%eax
 9d4:	83 ec 0c             	sub    $0xc,%esp
 9d7:	50                   	push   %eax
 9d8:	e8 c8 fe ff ff       	call   8a5 <free>
 9dd:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e0:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 9e5:	c9                   	leave  
 9e6:	c3                   	ret    

000009e7 <malloc>:

void*
malloc(uint nbytes)
{
 9e7:	55                   	push   %ebp
 9e8:	89 e5                	mov    %esp,%ebp
 9ea:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	83 c0 07             	add    $0x7,%eax
 9f3:	c1 e8 03             	shr    $0x3,%eax
 9f6:	83 c0 01             	add    $0x1,%eax
 9f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fc:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a08:	75 23                	jne    a2d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0a:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a14:	a3 e8 0d 00 00       	mov    %eax,0xde8
 a19:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a1e:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 a23:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 a2a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a30:	8b 00                	mov    (%eax),%eax
 a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3e:	72 4d                	jb     a8d <malloc+0xa6>
      if(p->s.size == nunits)
 a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a43:	8b 40 04             	mov    0x4(%eax),%eax
 a46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a49:	75 0c                	jne    a57 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 10                	mov    (%eax),%edx
 a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a53:	89 10                	mov    %edx,(%eax)
 a55:	eb 26                	jmp    a7d <malloc+0x96>
      else {
        p->s.size -= nunits;
 a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5a:	8b 40 04             	mov    0x4(%eax),%eax
 a5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a60:	89 c2                	mov    %eax,%edx
 a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a65:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6b:	8b 40 04             	mov    0x4(%eax),%eax
 a6e:	c1 e0 03             	shl    $0x3,%eax
 a71:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a80:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	83 c0 08             	add    $0x8,%eax
 a8b:	eb 3b                	jmp    ac8 <malloc+0xe1>
    }
    if(p == freep)
 a8d:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a92:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a95:	75 1e                	jne    ab5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a97:	83 ec 0c             	sub    $0xc,%esp
 a9a:	ff 75 ec             	pushl  -0x14(%ebp)
 a9d:	e8 e5 fe ff ff       	call   987 <morecore>
 aa2:	83 c4 10             	add    $0x10,%esp
 aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aac:	75 07                	jne    ab5 <malloc+0xce>
        return 0;
 aae:	b8 00 00 00 00       	mov    $0x0,%eax
 ab3:	eb 13                	jmp    ac8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	8b 00                	mov    (%eax),%eax
 ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac3:	e9 6d ff ff ff       	jmp    a35 <malloc+0x4e>
}
 ac8:	c9                   	leave  
 ac9:	c3                   	ret    
