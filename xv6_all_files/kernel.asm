
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 99 34 10 80       	mov    $0x80103499,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 14 81 10 80       	push   $0x80108114
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 ba 4b 00 00       	call   80104c06 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100056:	db 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
80100060:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 db 10 80       	mov    $0x8010db84,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 60 c6 10 80       	push   $0x8010c660
801000c1:	e8 62 4b 00 00       	call   80104c28 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 60 c6 10 80       	push   $0x8010c660
8010010c:	e8 7e 4b 00 00       	call   80104c8f <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 60 c6 10 80       	push   $0x8010c660
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 aa 47 00 00       	call   801048d6 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 db 10 80       	mov    0x8010db90,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 60 c6 10 80       	push   $0x8010c660
80100188:	e8 02 4b 00 00       	call   80104c8f <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 1b 81 10 80       	push   $0x8010811b
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 80 26 00 00       	call   80102867 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 2c 81 10 80       	push   $0x8010812c
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 3f 26 00 00       	call   80102867 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 33 81 10 80       	push   $0x80108133
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 60 c6 10 80       	push   $0x8010c660
80100255:	e8 ce 49 00 00       	call   80104c28 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 03 47 00 00       	call   801049c1 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 60 c6 10 80       	push   $0x8010c660
801002c9:	e8 c1 49 00 00       	call   80104c8f <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 c3 03 00 00       	call   80100776 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 c0 b5 10 80       	push   $0x8010b5c0
801003e2:	e8 41 48 00 00       	call   80104c28 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 3a 81 10 80       	push   $0x8010813a
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 43 81 10 80 	movl   $0x80108143,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 8e 02 00 00       	call   80100776 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 71 02 00 00       	call   80100776 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 62 02 00 00       	call   80100776 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 54 02 00 00       	call   80100776 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 c0 b5 10 80       	push   $0x8010b5c0
8010055b:	e8 2f 47 00 00       	call   80104c8f <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 4a 81 10 80       	push   $0x8010814a
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 59 81 10 80       	push   $0x80108159
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 1a 47 00 00       	call   80104ce1 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 5b 81 10 80       	push   $0x8010815b
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006b8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006bf:	7e 4c                	jle    8010070d <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006c1:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cc:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d1:	83 ec 04             	sub    $0x4,%esp
801006d4:	68 60 0e 00 00       	push   $0xe60
801006d9:	52                   	push   %edx
801006da:	50                   	push   %eax
801006db:	e8 6a 48 00 00       	call   80104f4a <memmove>
801006e0:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e7:	b8 80 07 00 00       	mov    $0x780,%eax
801006ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006f2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fa:	01 c9                	add    %ecx,%ecx
801006fc:	01 c8                	add    %ecx,%eax
801006fe:	83 ec 04             	sub    $0x4,%esp
80100701:	52                   	push   %edx
80100702:	6a 00                	push   $0x0
80100704:	50                   	push   %eax
80100705:	e8 81 47 00 00       	call   80104e8b <memset>
8010070a:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010070d:	83 ec 08             	sub    $0x8,%esp
80100710:	6a 0e                	push   $0xe
80100712:	68 d4 03 00 00       	push   $0x3d4
80100717:	e8 d5 fb ff ff       	call   801002f1 <outb>
8010071c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100722:	c1 f8 08             	sar    $0x8,%eax
80100725:	0f b6 c0             	movzbl %al,%eax
80100728:	83 ec 08             	sub    $0x8,%esp
8010072b:	50                   	push   %eax
8010072c:	68 d5 03 00 00       	push   $0x3d5
80100731:	e8 bb fb ff ff       	call   801002f1 <outb>
80100736:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100739:	83 ec 08             	sub    $0x8,%esp
8010073c:	6a 0f                	push   $0xf
8010073e:	68 d4 03 00 00       	push   $0x3d4
80100743:	e8 a9 fb ff ff       	call   801002f1 <outb>
80100748:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074e:	0f b6 c0             	movzbl %al,%eax
80100751:	83 ec 08             	sub    $0x8,%esp
80100754:	50                   	push   %eax
80100755:	68 d5 03 00 00       	push   $0x3d5
8010075a:	e8 92 fb ff ff       	call   801002f1 <outb>
8010075f:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100762:	a1 00 90 10 80       	mov    0x80109000,%eax
80100767:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076a:	01 d2                	add    %edx,%edx
8010076c:	01 d0                	add    %edx,%eax
8010076e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100773:	90                   	nop
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:

void
consputc(int c)
{
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010077c:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
    cli();
80100785:	e8 86 fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 04 60 00 00       	call   801067a3 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 f7 5f 00 00       	call   801067a3 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 ea 5f 00 00       	call   801067a3 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 da 5f 00 00       	call   801067a3 <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 2a fe ff ff       	call   80100601 <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
}
801007da:	90                   	nop
801007db:	c9                   	leave  
801007dc:	c3                   	ret    

801007dd <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007dd:	55                   	push   %ebp
801007de:	89 e5                	mov    %esp,%ebp
801007e0:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 a0 dd 10 80       	push   $0x8010dda0
801007eb:	e8 38 44 00 00       	call   80104c28 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 51 01 00 00       	jmp    80100949 <consoleintr+0x16c>
    switch(c){
801007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007fb:	83 f8 12             	cmp    $0x12,%eax
801007fe:	74 2d                	je     8010082d <consoleintr+0x50>
80100800:	83 f8 12             	cmp    $0x12,%eax
80100803:	7f 0f                	jg     80100814 <consoleintr+0x37>
80100805:	83 f8 08             	cmp    $0x8,%eax
80100808:	74 78                	je     80100882 <consoleintr+0xa5>
8010080a:	83 f8 10             	cmp    $0x10,%eax
8010080d:	74 14                	je     80100823 <consoleintr+0x46>
8010080f:	e9 a3 00 00 00       	jmp    801008b7 <consoleintr+0xda>
80100814:	83 f8 15             	cmp    $0x15,%eax
80100817:	74 3b                	je     80100854 <consoleintr+0x77>
80100819:	83 f8 7f             	cmp    $0x7f,%eax
8010081c:	74 64                	je     80100882 <consoleintr+0xa5>
8010081e:	e9 94 00 00 00       	jmp    801008b7 <consoleintr+0xda>
    case C('P'):  // Process listing.
      procdump();
80100823:	e8 54 42 00 00       	call   80104a7c <procdump>
      break;
80100828:	e9 1c 01 00 00       	jmp    80100949 <consoleintr+0x16c>
    case C('R'): // list sleeping processes
      sleep_proc_list(); // by ShaunFong
8010082d:	e8 43 43 00 00       	call   80104b75 <sleep_proc_list>
      break;
80100832:	e9 12 01 00 00       	jmp    80100949 <consoleintr+0x16c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100837:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010083c:	83 e8 01             	sub    $0x1,%eax
8010083f:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100844:	83 ec 0c             	sub    $0xc,%esp
80100847:	68 00 01 00 00       	push   $0x100
8010084c:	e8 25 ff ff ff       	call   80100776 <consputc>
80100851:	83 c4 10             	add    $0x10,%esp
      break;
    case C('R'): // list sleeping processes
      sleep_proc_list(); // by ShaunFong
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100854:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010085a:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010085f:	39 c2                	cmp    %eax,%edx
80100861:	0f 84 e2 00 00 00    	je     80100949 <consoleintr+0x16c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100867:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010086c:	83 e8 01             	sub    $0x1,%eax
8010086f:	83 e0 7f             	and    $0x7f,%eax
80100872:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
      break;
    case C('R'): // list sleeping processes
      sleep_proc_list(); // by ShaunFong
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100879:	3c 0a                	cmp    $0xa,%al
8010087b:	75 ba                	jne    80100837 <consoleintr+0x5a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010087d:	e9 c7 00 00 00       	jmp    80100949 <consoleintr+0x16c>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100882:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100888:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010088d:	39 c2                	cmp    %eax,%edx
8010088f:	0f 84 b4 00 00 00    	je     80100949 <consoleintr+0x16c>
        input.e--;
80100895:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010089a:	83 e8 01             	sub    $0x1,%eax
8010089d:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
801008a2:	83 ec 0c             	sub    $0xc,%esp
801008a5:	68 00 01 00 00       	push   $0x100
801008aa:	e8 c7 fe ff ff       	call   80100776 <consputc>
801008af:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008b2:	e9 92 00 00 00       	jmp    80100949 <consoleintr+0x16c>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008bb:	0f 84 87 00 00 00    	je     80100948 <consoleintr+0x16b>
801008c1:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
801008c7:	a1 54 de 10 80       	mov    0x8010de54,%eax
801008cc:	29 c2                	sub    %eax,%edx
801008ce:	89 d0                	mov    %edx,%eax
801008d0:	83 f8 7f             	cmp    $0x7f,%eax
801008d3:	77 73                	ja     80100948 <consoleintr+0x16b>
        c = (c == '\r') ? '\n' : c;
801008d5:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008d9:	74 05                	je     801008e0 <consoleintr+0x103>
801008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008de:	eb 05                	jmp    801008e5 <consoleintr+0x108>
801008e0:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e8:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008ed:	8d 50 01             	lea    0x1(%eax),%edx
801008f0:	89 15 5c de 10 80    	mov    %edx,0x8010de5c
801008f6:	83 e0 7f             	and    $0x7f,%eax
801008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008fc:	88 90 d4 dd 10 80    	mov    %dl,-0x7fef222c(%eax)
        consputc(c);
80100902:	83 ec 0c             	sub    $0xc,%esp
80100905:	ff 75 f4             	pushl  -0xc(%ebp)
80100908:	e8 69 fe ff ff       	call   80100776 <consputc>
8010090d:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100910:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100914:	74 18                	je     8010092e <consoleintr+0x151>
80100916:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010091a:	74 12                	je     8010092e <consoleintr+0x151>
8010091c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100921:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
80100927:	83 ea 80             	sub    $0xffffff80,%edx
8010092a:	39 d0                	cmp    %edx,%eax
8010092c:	75 1a                	jne    80100948 <consoleintr+0x16b>
          input.w = input.e;
8010092e:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100933:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
80100938:	83 ec 0c             	sub    $0xc,%esp
8010093b:	68 54 de 10 80       	push   $0x8010de54
80100940:	e8 7c 40 00 00       	call   801049c1 <wakeup>
80100945:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100948:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100949:	8b 45 08             	mov    0x8(%ebp),%eax
8010094c:	ff d0                	call   *%eax
8010094e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100955:	0f 89 9d fe ff ff    	jns    801007f8 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010095b:	83 ec 0c             	sub    $0xc,%esp
8010095e:	68 a0 dd 10 80       	push   $0x8010dda0
80100963:	e8 27 43 00 00       	call   80104c8f <release>
80100968:	83 c4 10             	add    $0x10,%esp
}
8010096b:	90                   	nop
8010096c:	c9                   	leave  
8010096d:	c3                   	ret    

8010096e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010096e:	55                   	push   %ebp
8010096f:	89 e5                	mov    %esp,%ebp
80100971:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100974:	83 ec 0c             	sub    $0xc,%esp
80100977:	ff 75 08             	pushl  0x8(%ebp)
8010097a:	e8 df 10 00 00       	call   80101a5e <iunlock>
8010097f:	83 c4 10             	add    $0x10,%esp
  target = n;
80100982:	8b 45 10             	mov    0x10(%ebp),%eax
80100985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100988:	83 ec 0c             	sub    $0xc,%esp
8010098b:	68 a0 dd 10 80       	push   $0x8010dda0
80100990:	e8 93 42 00 00       	call   80104c28 <acquire>
80100995:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100998:	e9 ac 00 00 00       	jmp    80100a49 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
8010099d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009a3:	8b 40 24             	mov    0x24(%eax),%eax
801009a6:	85 c0                	test   %eax,%eax
801009a8:	74 28                	je     801009d2 <consoleread+0x64>
        release(&input.lock);
801009aa:	83 ec 0c             	sub    $0xc,%esp
801009ad:	68 a0 dd 10 80       	push   $0x8010dda0
801009b2:	e8 d8 42 00 00       	call   80104c8f <release>
801009b7:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009ba:	83 ec 0c             	sub    $0xc,%esp
801009bd:	ff 75 08             	pushl  0x8(%ebp)
801009c0:	e8 41 0f 00 00       	call   80101906 <ilock>
801009c5:	83 c4 10             	add    $0x10,%esp
        return -1;
801009c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009cd:	e9 ab 00 00 00       	jmp    80100a7d <consoleread+0x10f>
      }
      sleep(&input.r, &input.lock);
801009d2:	83 ec 08             	sub    $0x8,%esp
801009d5:	68 a0 dd 10 80       	push   $0x8010dda0
801009da:	68 54 de 10 80       	push   $0x8010de54
801009df:	e8 f2 3e 00 00       	call   801048d6 <sleep>
801009e4:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009e7:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801009ed:	a1 58 de 10 80       	mov    0x8010de58,%eax
801009f2:	39 c2                	cmp    %eax,%edx
801009f4:	74 a7                	je     8010099d <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009f6:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009fb:	8d 50 01             	lea    0x1(%eax),%edx
801009fe:	89 15 54 de 10 80    	mov    %edx,0x8010de54
80100a04:	83 e0 7f             	and    $0x7f,%eax
80100a07:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
80100a0e:	0f be c0             	movsbl %al,%eax
80100a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a14:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a18:	75 17                	jne    80100a31 <consoleread+0xc3>
      if(n < target){
80100a1a:	8b 45 10             	mov    0x10(%ebp),%eax
80100a1d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a20:	73 2f                	jae    80100a51 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a22:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100a27:	83 e8 01             	sub    $0x1,%eax
80100a2a:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
80100a2f:	eb 20                	jmp    80100a51 <consoleread+0xe3>
    }
    *dst++ = c;
80100a31:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a34:	8d 50 01             	lea    0x1(%eax),%edx
80100a37:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a3d:	88 10                	mov    %dl,(%eax)
    --n;
80100a3f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a43:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a47:	74 0b                	je     80100a54 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a4d:	7f 98                	jg     801009e7 <consoleread+0x79>
80100a4f:	eb 04                	jmp    80100a55 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a51:	90                   	nop
80100a52:	eb 01                	jmp    80100a55 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a54:	90                   	nop
  }
  release(&input.lock);
80100a55:	83 ec 0c             	sub    $0xc,%esp
80100a58:	68 a0 dd 10 80       	push   $0x8010dda0
80100a5d:	e8 2d 42 00 00       	call   80104c8f <release>
80100a62:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a65:	83 ec 0c             	sub    $0xc,%esp
80100a68:	ff 75 08             	pushl  0x8(%ebp)
80100a6b:	e8 96 0e 00 00       	call   80101906 <ilock>
80100a70:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a73:	8b 45 10             	mov    0x10(%ebp),%eax
80100a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a79:	29 c2                	sub    %eax,%edx
80100a7b:	89 d0                	mov    %edx,%eax
}
80100a7d:	c9                   	leave  
80100a7e:	c3                   	ret    

80100a7f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a7f:	55                   	push   %ebp
80100a80:	89 e5                	mov    %esp,%ebp
80100a82:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a85:	83 ec 0c             	sub    $0xc,%esp
80100a88:	ff 75 08             	pushl  0x8(%ebp)
80100a8b:	e8 ce 0f 00 00       	call   80101a5e <iunlock>
80100a90:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a93:	83 ec 0c             	sub    $0xc,%esp
80100a96:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a9b:	e8 88 41 00 00       	call   80104c28 <acquire>
80100aa0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100aaa:	eb 21                	jmp    80100acd <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab2:	01 d0                	add    %edx,%eax
80100ab4:	0f b6 00             	movzbl (%eax),%eax
80100ab7:	0f be c0             	movsbl %al,%eax
80100aba:	0f b6 c0             	movzbl %al,%eax
80100abd:	83 ec 0c             	sub    $0xc,%esp
80100ac0:	50                   	push   %eax
80100ac1:	e8 b0 fc ff ff       	call   80100776 <consputc>
80100ac6:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ac9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ad0:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ad3:	7c d7                	jl     80100aac <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ad5:	83 ec 0c             	sub    $0xc,%esp
80100ad8:	68 c0 b5 10 80       	push   $0x8010b5c0
80100add:	e8 ad 41 00 00       	call   80104c8f <release>
80100ae2:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ae5:	83 ec 0c             	sub    $0xc,%esp
80100ae8:	ff 75 08             	pushl  0x8(%ebp)
80100aeb:	e8 16 0e 00 00       	call   80101906 <ilock>
80100af0:	83 c4 10             	add    $0x10,%esp

  return n;
80100af3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100af6:	c9                   	leave  
80100af7:	c3                   	ret    

80100af8 <consoleinit>:

void
consoleinit(void)
{
80100af8:	55                   	push   %ebp
80100af9:	89 e5                	mov    %esp,%ebp
80100afb:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100afe:	83 ec 08             	sub    $0x8,%esp
80100b01:	68 5f 81 10 80       	push   $0x8010815f
80100b06:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b0b:	e8 f6 40 00 00       	call   80104c06 <initlock>
80100b10:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b13:	83 ec 08             	sub    $0x8,%esp
80100b16:	68 67 81 10 80       	push   $0x80108167
80100b1b:	68 a0 dd 10 80       	push   $0x8010dda0
80100b20:	e8 e1 40 00 00       	call   80104c06 <initlock>
80100b25:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b28:	c7 05 0c e8 10 80 7f 	movl   $0x80100a7f,0x8010e80c
80100b2f:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b32:	c7 05 08 e8 10 80 6e 	movl   $0x8010096e,0x8010e808
80100b39:	09 10 80 
  cons.locking = 1;
80100b3c:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b43:	00 00 00 

  picenable(IRQ_KBD);
80100b46:	83 ec 0c             	sub    $0xc,%esp
80100b49:	6a 01                	push   $0x1
80100b4b:	e8 ea 2f 00 00       	call   80103b3a <picenable>
80100b50:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b53:	83 ec 08             	sub    $0x8,%esp
80100b56:	6a 00                	push   $0x0
80100b58:	6a 01                	push   $0x1
80100b5a:	e8 d5 1e 00 00       	call   80102a34 <ioapicenable>
80100b5f:	83 c4 10             	add    $0x10,%esp
}
80100b62:	90                   	nop
80100b63:	c9                   	leave  
80100b64:	c3                   	ret    

80100b65 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b65:	55                   	push   %ebp
80100b66:	89 e5                	mov    %esp,%ebp
80100b68:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	ff 75 08             	pushl  0x8(%ebp)
80100b74:	e8 45 19 00 00       	call   801024be <namei>
80100b79:	83 c4 10             	add    $0x10,%esp
80100b7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b7f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b83:	75 0a                	jne    80100b8f <exec+0x2a>
    return -1;
80100b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8a:	e9 c4 03 00 00       	jmp    80100f53 <exec+0x3ee>
  ilock(ip);
80100b8f:	83 ec 0c             	sub    $0xc,%esp
80100b92:	ff 75 d8             	pushl  -0x28(%ebp)
80100b95:	e8 6c 0d 00 00       	call   80101906 <ilock>
80100b9a:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b9d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ba4:	6a 34                	push   $0x34
80100ba6:	6a 00                	push   $0x0
80100ba8:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bae:	50                   	push   %eax
80100baf:	ff 75 d8             	pushl  -0x28(%ebp)
80100bb2:	e8 b7 12 00 00       	call   80101e6e <readi>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	83 f8 33             	cmp    $0x33,%eax
80100bbd:	0f 86 44 03 00 00    	jbe    80100f07 <exec+0x3a2>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bc3:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bc9:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bce:	0f 85 36 03 00 00    	jne    80100f0a <exec+0x3a5>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bd4:	e8 1f 6d 00 00       	call   801078f8 <setupkvm>
80100bd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bdc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100be0:	0f 84 27 03 00 00    	je     80100f0d <exec+0x3a8>
    goto bad;

  // Load program into memory.
  sz = 0;
80100be6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bf4:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bfd:	e9 ab 00 00 00       	jmp    80100cad <exec+0x148>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c05:	6a 20                	push   $0x20
80100c07:	50                   	push   %eax
80100c08:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c0e:	50                   	push   %eax
80100c0f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c12:	e8 57 12 00 00       	call   80101e6e <readi>
80100c17:	83 c4 10             	add    $0x10,%esp
80100c1a:	83 f8 20             	cmp    $0x20,%eax
80100c1d:	0f 85 ed 02 00 00    	jne    80100f10 <exec+0x3ab>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c23:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c29:	83 f8 01             	cmp    $0x1,%eax
80100c2c:	75 71                	jne    80100c9f <exec+0x13a>
      continue;
    if(ph.memsz < ph.filesz)
80100c2e:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c34:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c3a:	39 c2                	cmp    %eax,%edx
80100c3c:	0f 82 d1 02 00 00    	jb     80100f13 <exec+0x3ae>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c42:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c48:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c4e:	01 d0                	add    %edx,%eax
80100c50:	83 ec 04             	sub    $0x4,%esp
80100c53:	50                   	push   %eax
80100c54:	ff 75 e0             	pushl  -0x20(%ebp)
80100c57:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c5a:	e8 4a 70 00 00       	call   80107ca9 <allocuvm>
80100c5f:	83 c4 10             	add    $0x10,%esp
80100c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c69:	0f 84 a7 02 00 00    	je     80100f16 <exec+0x3b1>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6f:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c7b:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c81:	83 ec 0c             	sub    $0xc,%esp
80100c84:	52                   	push   %edx
80100c85:	50                   	push   %eax
80100c86:	ff 75 d8             	pushl  -0x28(%ebp)
80100c89:	51                   	push   %ecx
80100c8a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c8d:	e8 40 6f 00 00       	call   80107bd2 <loaduvm>
80100c92:	83 c4 20             	add    $0x20,%esp
80100c95:	85 c0                	test   %eax,%eax
80100c97:	0f 88 7c 02 00 00    	js     80100f19 <exec+0x3b4>
80100c9d:	eb 01                	jmp    80100ca0 <exec+0x13b>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c9f:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca7:	83 c0 20             	add    $0x20,%eax
80100caa:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cad:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cb4:	0f b7 c0             	movzwl %ax,%eax
80100cb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cba:	0f 8f 42 ff ff ff    	jg     80100c02 <exec+0x9d>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	e8 f5 0e 00 00       	call   80101bc0 <iunlockput>
80100ccb:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100cce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	05 00 20 00 00       	add    $0x2000,%eax
80100ced:	83 ec 04             	sub    $0x4,%esp
80100cf0:	50                   	push   %eax
80100cf1:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf7:	e8 ad 6f 00 00       	call   80107ca9 <allocuvm>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d06:	0f 84 10 02 00 00    	je     80100f1c <exec+0x3b7>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 af 71 00 00       	call   80107ecf <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 96 00 00 00       	jmp    80100dcb <exec+0x266>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	0f 87 e0 01 00 00    	ja     80100f1f <exec+0x3ba>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 d0                	add    %edx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	50                   	push   %eax
80100d54:	e8 7f 43 00 00       	call   801050d8 <strlen>
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	89 c2                	mov    %eax,%edx
80100d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d61:	29 d0                	sub    %edx,%eax
80100d63:	83 e8 01             	sub    $0x1,%eax
80100d66:	83 e0 fc             	and    $0xfffffffc,%eax
80100d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d79:	01 d0                	add    %edx,%eax
80100d7b:	8b 00                	mov    (%eax),%eax
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	50                   	push   %eax
80100d81:	e8 52 43 00 00       	call   801050d8 <strlen>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	83 c0 01             	add    $0x1,%eax
80100d8c:	89 c1                	mov    %eax,%ecx
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9b:	01 d0                	add    %edx,%eax
80100d9d:	8b 00                	mov    (%eax),%eax
80100d9f:	51                   	push   %ecx
80100da0:	50                   	push   %eax
80100da1:	ff 75 dc             	pushl  -0x24(%ebp)
80100da4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da7:	e8 c7 72 00 00       	call   80108073 <copyout>
80100dac:	83 c4 10             	add    $0x10,%esp
80100daf:	85 c0                	test   %eax,%eax
80100db1:	0f 88 6b 01 00 00    	js     80100f22 <exec+0x3bd>
      goto bad;
    ustack[3+argc] = sp;
80100db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dba:	8d 50 03             	lea    0x3(%eax),%edx
80100dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc0:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd8:	01 d0                	add    %edx,%eax
80100dda:	8b 00                	mov    (%eax),%eax
80100ddc:	85 c0                	test   %eax,%eax
80100dde:	0f 85 51 ff ff ff    	jne    80100d35 <exec+0x1d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de7:	83 c0 03             	add    $0x3,%eax
80100dea:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfc:	ff ff ff 
  ustack[1] = argc;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e18:	29 d0                	sub    %edx,%eax
80100e1a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	83 c0 04             	add    $0x4,%eax
80100e26:	c1 e0 02             	shl    $0x2,%eax
80100e29:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	83 c0 04             	add    $0x4,%eax
80100e32:	c1 e0 02             	shl    $0x2,%eax
80100e35:	50                   	push   %eax
80100e36:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3c:	50                   	push   %eax
80100e3d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e43:	e8 2b 72 00 00       	call   80108073 <copyout>
80100e48:	83 c4 10             	add    $0x10,%esp
80100e4b:	85 c0                	test   %eax,%eax
80100e4d:	0f 88 d2 00 00 00    	js     80100f25 <exec+0x3c0>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e53:	8b 45 08             	mov    0x8(%ebp),%eax
80100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e5f:	eb 17                	jmp    80100e78 <exec+0x313>
    if(*s == '/')
80100e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e64:	0f b6 00             	movzbl (%eax),%eax
80100e67:	3c 2f                	cmp    $0x2f,%al
80100e69:	75 09                	jne    80100e74 <exec+0x30f>
      last = s+1;
80100e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6e:	83 c0 01             	add    $0x1,%eax
80100e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7b:	0f b6 00             	movzbl (%eax),%eax
80100e7e:	84 c0                	test   %al,%al
80100e80:	75 df                	jne    80100e61 <exec+0x2fc>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e88:	83 c0 6c             	add    $0x6c,%eax
80100e8b:	83 ec 04             	sub    $0x4,%esp
80100e8e:	6a 10                	push   $0x10
80100e90:	ff 75 f0             	pushl  -0x10(%ebp)
80100e93:	50                   	push   %eax
80100e94:	e8 f5 41 00 00       	call   8010508e <safestrcpy>
80100e99:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea2:	8b 40 04             	mov    0x4(%eax),%eax
80100ea5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb1:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ebd:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec5:	8b 40 18             	mov    0x18(%eax),%eax
80100ec8:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ece:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed7:	8b 40 18             	mov    0x18(%eax),%eax
80100eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100edd:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	50                   	push   %eax
80100eea:	e8 fa 6a 00 00       	call   801079e9 <switchuvm>
80100eef:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef8:	e8 32 6f 00 00       	call   80107e2f <freevm>
80100efd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f00:	b8 00 00 00 00       	mov    $0x0,%eax
80100f05:	eb 4c                	jmp    80100f53 <exec+0x3ee>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f07:	90                   	nop
80100f08:	eb 1c                	jmp    80100f26 <exec+0x3c1>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f0a:	90                   	nop
80100f0b:	eb 19                	jmp    80100f26 <exec+0x3c1>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f0d:	90                   	nop
80100f0e:	eb 16                	jmp    80100f26 <exec+0x3c1>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f10:	90                   	nop
80100f11:	eb 13                	jmp    80100f26 <exec+0x3c1>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f13:	90                   	nop
80100f14:	eb 10                	jmp    80100f26 <exec+0x3c1>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f16:	90                   	nop
80100f17:	eb 0d                	jmp    80100f26 <exec+0x3c1>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f19:	90                   	nop
80100f1a:	eb 0a                	jmp    80100f26 <exec+0x3c1>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f1c:	90                   	nop
80100f1d:	eb 07                	jmp    80100f26 <exec+0x3c1>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f1f:	90                   	nop
80100f20:	eb 04                	jmp    80100f26 <exec+0x3c1>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f22:	90                   	nop
80100f23:	eb 01                	jmp    80100f26 <exec+0x3c1>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f25:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f26:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f2a:	74 0e                	je     80100f3a <exec+0x3d5>
    freevm(pgdir);
80100f2c:	83 ec 0c             	sub    $0xc,%esp
80100f2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f32:	e8 f8 6e 00 00       	call   80107e2f <freevm>
80100f37:	83 c4 10             	add    $0x10,%esp
  if(ip)
80100f3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f3e:	74 0e                	je     80100f4e <exec+0x3e9>
    iunlockput(ip);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d8             	pushl  -0x28(%ebp)
80100f46:	e8 75 0c 00 00       	call   80101bc0 <iunlockput>
80100f4b:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f53:	c9                   	leave  
80100f54:	c3                   	ret    

80100f55 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f55:	55                   	push   %ebp
80100f56:	89 e5                	mov    %esp,%ebp
80100f58:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f5b:	83 ec 08             	sub    $0x8,%esp
80100f5e:	68 6d 81 10 80       	push   $0x8010816d
80100f63:	68 60 de 10 80       	push   $0x8010de60
80100f68:	e8 99 3c 00 00       	call   80104c06 <initlock>
80100f6d:	83 c4 10             	add    $0x10,%esp
}
80100f70:	90                   	nop
80100f71:	c9                   	leave  
80100f72:	c3                   	ret    

80100f73 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f73:	55                   	push   %ebp
80100f74:	89 e5                	mov    %esp,%ebp
80100f76:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f79:	83 ec 0c             	sub    $0xc,%esp
80100f7c:	68 60 de 10 80       	push   $0x8010de60
80100f81:	e8 a2 3c 00 00       	call   80104c28 <acquire>
80100f86:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f89:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f90:	eb 2d                	jmp    80100fbf <filealloc+0x4c>
    if(f->ref == 0){
80100f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f95:	8b 40 04             	mov    0x4(%eax),%eax
80100f98:	85 c0                	test   %eax,%eax
80100f9a:	75 1f                	jne    80100fbb <filealloc+0x48>
      f->ref = 1;
80100f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	68 60 de 10 80       	push   $0x8010de60
80100fae:	e8 dc 3c 00 00       	call   80104c8f <release>
80100fb3:	83 c4 10             	add    $0x10,%esp
      return f;
80100fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb9:	eb 23                	jmp    80100fde <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fbb:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fbf:	b8 f4 e7 10 80       	mov    $0x8010e7f4,%eax
80100fc4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fc7:	72 c9                	jb     80100f92 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 60 de 10 80       	push   $0x8010de60
80100fd1:	e8 b9 3c 00 00       	call   80104c8f <release>
80100fd6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fde:	c9                   	leave  
80100fdf:	c3                   	ret    

80100fe0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fe6:	83 ec 0c             	sub    $0xc,%esp
80100fe9:	68 60 de 10 80       	push   $0x8010de60
80100fee:	e8 35 3c 00 00       	call   80104c28 <acquire>
80100ff3:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff9:	8b 40 04             	mov    0x4(%eax),%eax
80100ffc:	85 c0                	test   %eax,%eax
80100ffe:	7f 0d                	jg     8010100d <filedup+0x2d>
    panic("filedup");
80101000:	83 ec 0c             	sub    $0xc,%esp
80101003:	68 74 81 10 80       	push   $0x80108174
80101008:	e8 59 f5 ff ff       	call   80100566 <panic>
  f->ref++;
8010100d:	8b 45 08             	mov    0x8(%ebp),%eax
80101010:	8b 40 04             	mov    0x4(%eax),%eax
80101013:	8d 50 01             	lea    0x1(%eax),%edx
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010101c:	83 ec 0c             	sub    $0xc,%esp
8010101f:	68 60 de 10 80       	push   $0x8010de60
80101024:	e8 66 3c 00 00       	call   80104c8f <release>
80101029:	83 c4 10             	add    $0x10,%esp
  return f;
8010102c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010102f:	c9                   	leave  
80101030:	c3                   	ret    

80101031 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101031:	55                   	push   %ebp
80101032:	89 e5                	mov    %esp,%ebp
80101034:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 60 de 10 80       	push   $0x8010de60
8010103f:	e8 e4 3b 00 00       	call   80104c28 <acquire>
80101044:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101047:	8b 45 08             	mov    0x8(%ebp),%eax
8010104a:	8b 40 04             	mov    0x4(%eax),%eax
8010104d:	85 c0                	test   %eax,%eax
8010104f:	7f 0d                	jg     8010105e <fileclose+0x2d>
    panic("fileclose");
80101051:	83 ec 0c             	sub    $0xc,%esp
80101054:	68 7c 81 10 80       	push   $0x8010817c
80101059:	e8 08 f5 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010105e:	8b 45 08             	mov    0x8(%ebp),%eax
80101061:	8b 40 04             	mov    0x4(%eax),%eax
80101064:	8d 50 ff             	lea    -0x1(%eax),%edx
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
8010106a:	89 50 04             	mov    %edx,0x4(%eax)
8010106d:	8b 45 08             	mov    0x8(%ebp),%eax
80101070:	8b 40 04             	mov    0x4(%eax),%eax
80101073:	85 c0                	test   %eax,%eax
80101075:	7e 15                	jle    8010108c <fileclose+0x5b>
    release(&ftable.lock);
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 60 de 10 80       	push   $0x8010de60
8010107f:	e8 0b 3c 00 00       	call   80104c8f <release>
80101084:	83 c4 10             	add    $0x10,%esp
80101087:	e9 8b 00 00 00       	jmp    80101117 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	8b 10                	mov    (%eax),%edx
80101091:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101094:	8b 50 04             	mov    0x4(%eax),%edx
80101097:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010109a:	8b 50 08             	mov    0x8(%eax),%edx
8010109d:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010a0:	8b 50 0c             	mov    0xc(%eax),%edx
801010a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010a6:	8b 50 10             	mov    0x10(%eax),%edx
801010a9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010ac:	8b 40 14             	mov    0x14(%eax),%eax
801010af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010b2:	8b 45 08             	mov    0x8(%ebp),%eax
801010b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 60 de 10 80       	push   $0x8010de60
801010cd:	e8 bd 3b 00 00       	call   80104c8f <release>
801010d2:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d8:	83 f8 01             	cmp    $0x1,%eax
801010db:	75 19                	jne    801010f6 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010dd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e1:	0f be d0             	movsbl %al,%edx
801010e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010e7:	83 ec 08             	sub    $0x8,%esp
801010ea:	52                   	push   %edx
801010eb:	50                   	push   %eax
801010ec:	e8 b2 2c 00 00       	call   80103da3 <pipeclose>
801010f1:	83 c4 10             	add    $0x10,%esp
801010f4:	eb 21                	jmp    80101117 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 f8 02             	cmp    $0x2,%eax
801010fc:	75 19                	jne    80101117 <fileclose+0xe6>
    begin_trans();
801010fe:	e8 94 21 00 00       	call   80103297 <begin_trans>
    iput(ff.ip);
80101103:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101106:	83 ec 0c             	sub    $0xc,%esp
80101109:	50                   	push   %eax
8010110a:	e8 c1 09 00 00       	call   80101ad0 <iput>
8010110f:	83 c4 10             	add    $0x10,%esp
    commit_trans();
80101112:	e8 d3 21 00 00       	call   801032ea <commit_trans>
  }
}
80101117:	c9                   	leave  
80101118:	c3                   	ret    

80101119 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101119:	55                   	push   %ebp
8010111a:	89 e5                	mov    %esp,%ebp
8010111c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
80101122:	8b 00                	mov    (%eax),%eax
80101124:	83 f8 02             	cmp    $0x2,%eax
80101127:	75 40                	jne    80101169 <filestat+0x50>
    ilock(f->ip);
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 10             	mov    0x10(%eax),%eax
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	50                   	push   %eax
80101133:	e8 ce 07 00 00       	call   80101906 <ilock>
80101138:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010113b:	8b 45 08             	mov    0x8(%ebp),%eax
8010113e:	8b 40 10             	mov    0x10(%eax),%eax
80101141:	83 ec 08             	sub    $0x8,%esp
80101144:	ff 75 0c             	pushl  0xc(%ebp)
80101147:	50                   	push   %eax
80101148:	e8 db 0c 00 00       	call   80101e28 <stati>
8010114d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101150:	8b 45 08             	mov    0x8(%ebp),%eax
80101153:	8b 40 10             	mov    0x10(%eax),%eax
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	50                   	push   %eax
8010115a:	e8 ff 08 00 00       	call   80101a5e <iunlock>
8010115f:	83 c4 10             	add    $0x10,%esp
    return 0;
80101162:	b8 00 00 00 00       	mov    $0x0,%eax
80101167:	eb 05                	jmp    8010116e <filestat+0x55>
  }
  return -1;
80101169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010116e:	c9                   	leave  
8010116f:	c3                   	ret    

80101170 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101176:	8b 45 08             	mov    0x8(%ebp),%eax
80101179:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010117d:	84 c0                	test   %al,%al
8010117f:	75 0a                	jne    8010118b <fileread+0x1b>
    return -1;
80101181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101186:	e9 9b 00 00 00       	jmp    80101226 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	8b 00                	mov    (%eax),%eax
80101190:	83 f8 01             	cmp    $0x1,%eax
80101193:	75 1a                	jne    801011af <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	8b 40 0c             	mov    0xc(%eax),%eax
8010119b:	83 ec 04             	sub    $0x4,%esp
8010119e:	ff 75 10             	pushl  0x10(%ebp)
801011a1:	ff 75 0c             	pushl  0xc(%ebp)
801011a4:	50                   	push   %eax
801011a5:	e8 a1 2d 00 00       	call   80103f4b <piperead>
801011aa:	83 c4 10             	add    $0x10,%esp
801011ad:	eb 77                	jmp    80101226 <fileread+0xb6>
  if(f->type == FD_INODE){
801011af:	8b 45 08             	mov    0x8(%ebp),%eax
801011b2:	8b 00                	mov    (%eax),%eax
801011b4:	83 f8 02             	cmp    $0x2,%eax
801011b7:	75 60                	jne    80101219 <fileread+0xa9>
    ilock(f->ip);
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 40 10             	mov    0x10(%eax),%eax
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	50                   	push   %eax
801011c3:	e8 3e 07 00 00       	call   80101906 <ilock>
801011c8:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011ce:	8b 45 08             	mov    0x8(%ebp),%eax
801011d1:	8b 50 14             	mov    0x14(%eax),%edx
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 40 10             	mov    0x10(%eax),%eax
801011da:	51                   	push   %ecx
801011db:	52                   	push   %edx
801011dc:	ff 75 0c             	pushl  0xc(%ebp)
801011df:	50                   	push   %eax
801011e0:	e8 89 0c 00 00       	call   80101e6e <readi>
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011ef:	7e 11                	jle    80101202 <fileread+0x92>
      f->off += r;
801011f1:	8b 45 08             	mov    0x8(%ebp),%eax
801011f4:	8b 50 14             	mov    0x14(%eax),%edx
801011f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fa:	01 c2                	add    %eax,%edx
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 10             	mov    0x10(%eax),%eax
80101208:	83 ec 0c             	sub    $0xc,%esp
8010120b:	50                   	push   %eax
8010120c:	e8 4d 08 00 00       	call   80101a5e <iunlock>
80101211:	83 c4 10             	add    $0x10,%esp
    return r;
80101214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101217:	eb 0d                	jmp    80101226 <fileread+0xb6>
  }
  panic("fileread");
80101219:	83 ec 0c             	sub    $0xc,%esp
8010121c:	68 86 81 10 80       	push   $0x80108186
80101221:	e8 40 f3 ff ff       	call   80100566 <panic>
}
80101226:	c9                   	leave  
80101227:	c3                   	ret    

80101228 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101228:	55                   	push   %ebp
80101229:	89 e5                	mov    %esp,%ebp
8010122b:	53                   	push   %ebx
8010122c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101236:	84 c0                	test   %al,%al
80101238:	75 0a                	jne    80101244 <filewrite+0x1c>
    return -1;
8010123a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123f:	e9 1b 01 00 00       	jmp    8010135f <filewrite+0x137>
  if(f->type == FD_PIPE)
80101244:	8b 45 08             	mov    0x8(%ebp),%eax
80101247:	8b 00                	mov    (%eax),%eax
80101249:	83 f8 01             	cmp    $0x1,%eax
8010124c:	75 1d                	jne    8010126b <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 40 0c             	mov    0xc(%eax),%eax
80101254:	83 ec 04             	sub    $0x4,%esp
80101257:	ff 75 10             	pushl  0x10(%ebp)
8010125a:	ff 75 0c             	pushl  0xc(%ebp)
8010125d:	50                   	push   %eax
8010125e:	e8 ea 2b 00 00       	call   80103e4d <pipewrite>
80101263:	83 c4 10             	add    $0x10,%esp
80101266:	e9 f4 00 00 00       	jmp    8010135f <filewrite+0x137>
  if(f->type == FD_INODE){
8010126b:	8b 45 08             	mov    0x8(%ebp),%eax
8010126e:	8b 00                	mov    (%eax),%eax
80101270:	83 f8 02             	cmp    $0x2,%eax
80101273:	0f 85 d9 00 00 00    	jne    80101352 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101279:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101287:	e9 a3 00 00 00       	jmp    8010132f <filewrite+0x107>
      int n1 = n - i;
8010128c:	8b 45 10             	mov    0x10(%ebp),%eax
8010128f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101292:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101295:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101298:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010129b:	7e 06                	jle    801012a3 <filewrite+0x7b>
        n1 = max;
8010129d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a0:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
801012a3:	e8 ef 1f 00 00       	call   80103297 <begin_trans>
      ilock(f->ip);
801012a8:	8b 45 08             	mov    0x8(%ebp),%eax
801012ab:	8b 40 10             	mov    0x10(%eax),%eax
801012ae:	83 ec 0c             	sub    $0xc,%esp
801012b1:	50                   	push   %eax
801012b2:	e8 4f 06 00 00       	call   80101906 <ilock>
801012b7:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012ba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012bd:	8b 45 08             	mov    0x8(%ebp),%eax
801012c0:	8b 50 14             	mov    0x14(%eax),%edx
801012c3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801012c9:	01 c3                	add    %eax,%ebx
801012cb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ce:	8b 40 10             	mov    0x10(%eax),%eax
801012d1:	51                   	push   %ecx
801012d2:	52                   	push   %edx
801012d3:	53                   	push   %ebx
801012d4:	50                   	push   %eax
801012d5:	e8 eb 0c 00 00       	call   80101fc5 <writei>
801012da:	83 c4 10             	add    $0x10,%esp
801012dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012e4:	7e 11                	jle    801012f7 <filewrite+0xcf>
        f->off += r;
801012e6:	8b 45 08             	mov    0x8(%ebp),%eax
801012e9:	8b 50 14             	mov    0x14(%eax),%edx
801012ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ef:	01 c2                	add    %eax,%edx
801012f1:	8b 45 08             	mov    0x8(%ebp),%eax
801012f4:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	8b 40 10             	mov    0x10(%eax),%eax
801012fd:	83 ec 0c             	sub    $0xc,%esp
80101300:	50                   	push   %eax
80101301:	e8 58 07 00 00       	call   80101a5e <iunlock>
80101306:	83 c4 10             	add    $0x10,%esp
      commit_trans();
80101309:	e8 dc 1f 00 00       	call   801032ea <commit_trans>

      if(r < 0)
8010130e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101312:	78 29                	js     8010133d <filewrite+0x115>
        break;
      if(r != n1)
80101314:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101317:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131a:	74 0d                	je     80101329 <filewrite+0x101>
        panic("short filewrite");
8010131c:	83 ec 0c             	sub    $0xc,%esp
8010131f:	68 8f 81 10 80       	push   $0x8010818f
80101324:	e8 3d f2 ff ff       	call   80100566 <panic>
      i += r;
80101329:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010132c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101332:	3b 45 10             	cmp    0x10(%ebp),%eax
80101335:	0f 8c 51 ff ff ff    	jl     8010128c <filewrite+0x64>
8010133b:	eb 01                	jmp    8010133e <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
8010133d:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101341:	3b 45 10             	cmp    0x10(%ebp),%eax
80101344:	75 05                	jne    8010134b <filewrite+0x123>
80101346:	8b 45 10             	mov    0x10(%ebp),%eax
80101349:	eb 14                	jmp    8010135f <filewrite+0x137>
8010134b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101350:	eb 0d                	jmp    8010135f <filewrite+0x137>
  }
  panic("filewrite");
80101352:	83 ec 0c             	sub    $0xc,%esp
80101355:	68 9f 81 10 80       	push   $0x8010819f
8010135a:	e8 07 f2 ff ff       	call   80100566 <panic>
}
8010135f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101362:	c9                   	leave  
80101363:	c3                   	ret    

80101364 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101364:	55                   	push   %ebp
80101365:	89 e5                	mov    %esp,%ebp
80101367:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010136a:	8b 45 08             	mov    0x8(%ebp),%eax
8010136d:	83 ec 08             	sub    $0x8,%esp
80101370:	6a 01                	push   $0x1
80101372:	50                   	push   %eax
80101373:	e8 3e ee ff ff       	call   801001b6 <bread>
80101378:	83 c4 10             	add    $0x10,%esp
8010137b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101381:	83 c0 18             	add    $0x18,%eax
80101384:	83 ec 04             	sub    $0x4,%esp
80101387:	6a 10                	push   $0x10
80101389:	50                   	push   %eax
8010138a:	ff 75 0c             	pushl  0xc(%ebp)
8010138d:	e8 b8 3b 00 00       	call   80104f4a <memmove>
80101392:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101395:	83 ec 0c             	sub    $0xc,%esp
80101398:	ff 75 f4             	pushl  -0xc(%ebp)
8010139b:	e8 8e ee ff ff       	call   8010022e <brelse>
801013a0:	83 c4 10             	add    $0x10,%esp
}
801013a3:	90                   	nop
801013a4:	c9                   	leave  
801013a5:	c3                   	ret    

801013a6 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013a6:	55                   	push   %ebp
801013a7:	89 e5                	mov    %esp,%ebp
801013a9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801013af:	8b 45 08             	mov    0x8(%ebp),%eax
801013b2:	83 ec 08             	sub    $0x8,%esp
801013b5:	52                   	push   %edx
801013b6:	50                   	push   %eax
801013b7:	e8 fa ed ff ff       	call   801001b6 <bread>
801013bc:	83 c4 10             	add    $0x10,%esp
801013bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c5:	83 c0 18             	add    $0x18,%eax
801013c8:	83 ec 04             	sub    $0x4,%esp
801013cb:	68 00 02 00 00       	push   $0x200
801013d0:	6a 00                	push   $0x0
801013d2:	50                   	push   %eax
801013d3:	e8 b3 3a 00 00       	call   80104e8b <memset>
801013d8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013db:	83 ec 0c             	sub    $0xc,%esp
801013de:	ff 75 f4             	pushl  -0xc(%ebp)
801013e1:	e8 69 1f 00 00       	call   8010334f <log_write>
801013e6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013e9:	83 ec 0c             	sub    $0xc,%esp
801013ec:	ff 75 f4             	pushl  -0xc(%ebp)
801013ef:	e8 3a ee ff ff       	call   8010022e <brelse>
801013f4:	83 c4 10             	add    $0x10,%esp
}
801013f7:	90                   	nop
801013f8:	c9                   	leave  
801013f9:	c3                   	ret    

801013fa <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013fa:	55                   	push   %ebp
801013fb:	89 e5                	mov    %esp,%ebp
801013fd:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101407:	8b 45 08             	mov    0x8(%ebp),%eax
8010140a:	83 ec 08             	sub    $0x8,%esp
8010140d:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101410:	52                   	push   %edx
80101411:	50                   	push   %eax
80101412:	e8 4d ff ff ff       	call   80101364 <readsb>
80101417:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010141a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101421:	e9 15 01 00 00       	jmp    8010153b <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101429:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010142f:	85 c0                	test   %eax,%eax
80101431:	0f 48 c2             	cmovs  %edx,%eax
80101434:	c1 f8 0c             	sar    $0xc,%eax
80101437:	89 c2                	mov    %eax,%edx
80101439:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010143c:	c1 e8 03             	shr    $0x3,%eax
8010143f:	01 d0                	add    %edx,%eax
80101441:	83 c0 03             	add    $0x3,%eax
80101444:	83 ec 08             	sub    $0x8,%esp
80101447:	50                   	push   %eax
80101448:	ff 75 08             	pushl  0x8(%ebp)
8010144b:	e8 66 ed ff ff       	call   801001b6 <bread>
80101450:	83 c4 10             	add    $0x10,%esp
80101453:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101456:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010145d:	e9 a6 00 00 00       	jmp    80101508 <balloc+0x10e>
      m = 1 << (bi % 8);
80101462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101465:	99                   	cltd   
80101466:	c1 ea 1d             	shr    $0x1d,%edx
80101469:	01 d0                	add    %edx,%eax
8010146b:	83 e0 07             	and    $0x7,%eax
8010146e:	29 d0                	sub    %edx,%eax
80101470:	ba 01 00 00 00       	mov    $0x1,%edx
80101475:	89 c1                	mov    %eax,%ecx
80101477:	d3 e2                	shl    %cl,%edx
80101479:	89 d0                	mov    %edx,%eax
8010147b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101481:	8d 50 07             	lea    0x7(%eax),%edx
80101484:	85 c0                	test   %eax,%eax
80101486:	0f 48 c2             	cmovs  %edx,%eax
80101489:	c1 f8 03             	sar    $0x3,%eax
8010148c:	89 c2                	mov    %eax,%edx
8010148e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101491:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101496:	0f b6 c0             	movzbl %al,%eax
80101499:	23 45 e8             	and    -0x18(%ebp),%eax
8010149c:	85 c0                	test   %eax,%eax
8010149e:	75 64                	jne    80101504 <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a3:	8d 50 07             	lea    0x7(%eax),%edx
801014a6:	85 c0                	test   %eax,%eax
801014a8:	0f 48 c2             	cmovs  %edx,%eax
801014ab:	c1 f8 03             	sar    $0x3,%eax
801014ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014b1:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014b6:	89 d1                	mov    %edx,%ecx
801014b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014bb:	09 ca                	or     %ecx,%edx
801014bd:	89 d1                	mov    %edx,%ecx
801014bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c2:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014c6:	83 ec 0c             	sub    $0xc,%esp
801014c9:	ff 75 ec             	pushl  -0x14(%ebp)
801014cc:	e8 7e 1e 00 00       	call   8010334f <log_write>
801014d1:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	ff 75 ec             	pushl  -0x14(%ebp)
801014da:	e8 4f ed ff ff       	call   8010022e <brelse>
801014df:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e8:	01 c2                	add    %eax,%edx
801014ea:	8b 45 08             	mov    0x8(%ebp),%eax
801014ed:	83 ec 08             	sub    $0x8,%esp
801014f0:	52                   	push   %edx
801014f1:	50                   	push   %eax
801014f2:	e8 af fe ff ff       	call   801013a6 <bzero>
801014f7:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101500:	01 d0                	add    %edx,%eax
80101502:	eb 52                	jmp    80101556 <balloc+0x15c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101504:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101508:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010150f:	7f 15                	jg     80101526 <balloc+0x12c>
80101511:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101514:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101517:	01 d0                	add    %edx,%eax
80101519:	89 c2                	mov    %eax,%edx
8010151b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010151e:	39 c2                	cmp    %eax,%edx
80101520:	0f 82 3c ff ff ff    	jb     80101462 <balloc+0x68>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101526:	83 ec 0c             	sub    $0xc,%esp
80101529:	ff 75 ec             	pushl  -0x14(%ebp)
8010152c:	e8 fd ec ff ff       	call   8010022e <brelse>
80101531:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101534:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010153b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101541:	39 c2                	cmp    %eax,%edx
80101543:	0f 87 dd fe ff ff    	ja     80101426 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101549:	83 ec 0c             	sub    $0xc,%esp
8010154c:	68 a9 81 10 80       	push   $0x801081a9
80101551:	e8 10 f0 ff ff       	call   80100566 <panic>
}
80101556:	c9                   	leave  
80101557:	c3                   	ret    

80101558 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101558:	55                   	push   %ebp
80101559:	89 e5                	mov    %esp,%ebp
8010155b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
8010155e:	83 ec 08             	sub    $0x8,%esp
80101561:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101564:	50                   	push   %eax
80101565:	ff 75 08             	pushl  0x8(%ebp)
80101568:	e8 f7 fd ff ff       	call   80101364 <readsb>
8010156d:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101570:	8b 45 0c             	mov    0xc(%ebp),%eax
80101573:	c1 e8 0c             	shr    $0xc,%eax
80101576:	89 c2                	mov    %eax,%edx
80101578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010157b:	c1 e8 03             	shr    $0x3,%eax
8010157e:	01 d0                	add    %edx,%eax
80101580:	8d 50 03             	lea    0x3(%eax),%edx
80101583:	8b 45 08             	mov    0x8(%ebp),%eax
80101586:	83 ec 08             	sub    $0x8,%esp
80101589:	52                   	push   %edx
8010158a:	50                   	push   %eax
8010158b:	e8 26 ec ff ff       	call   801001b6 <bread>
80101590:	83 c4 10             	add    $0x10,%esp
80101593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101596:	8b 45 0c             	mov    0xc(%ebp),%eax
80101599:	25 ff 0f 00 00       	and    $0xfff,%eax
8010159e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a4:	99                   	cltd   
801015a5:	c1 ea 1d             	shr    $0x1d,%edx
801015a8:	01 d0                	add    %edx,%eax
801015aa:	83 e0 07             	and    $0x7,%eax
801015ad:	29 d0                	sub    %edx,%eax
801015af:	ba 01 00 00 00       	mov    $0x1,%edx
801015b4:	89 c1                	mov    %eax,%ecx
801015b6:	d3 e2                	shl    %cl,%edx
801015b8:	89 d0                	mov    %edx,%eax
801015ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c0:	8d 50 07             	lea    0x7(%eax),%edx
801015c3:	85 c0                	test   %eax,%eax
801015c5:	0f 48 c2             	cmovs  %edx,%eax
801015c8:	c1 f8 03             	sar    $0x3,%eax
801015cb:	89 c2                	mov    %eax,%edx
801015cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d0:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015d5:	0f b6 c0             	movzbl %al,%eax
801015d8:	23 45 ec             	and    -0x14(%ebp),%eax
801015db:	85 c0                	test   %eax,%eax
801015dd:	75 0d                	jne    801015ec <bfree+0x94>
    panic("freeing free block");
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	68 bf 81 10 80       	push   $0x801081bf
801015e7:	e8 7a ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ef:	8d 50 07             	lea    0x7(%eax),%edx
801015f2:	85 c0                	test   %eax,%eax
801015f4:	0f 48 c2             	cmovs  %edx,%eax
801015f7:	c1 f8 03             	sar    $0x3,%eax
801015fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015fd:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101602:	89 d1                	mov    %edx,%ecx
80101604:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101607:	f7 d2                	not    %edx
80101609:	21 ca                	and    %ecx,%edx
8010160b:	89 d1                	mov    %edx,%ecx
8010160d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101610:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	ff 75 f4             	pushl  -0xc(%ebp)
8010161a:	e8 30 1d 00 00       	call   8010334f <log_write>
8010161f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	ff 75 f4             	pushl  -0xc(%ebp)
80101628:	e8 01 ec ff ff       	call   8010022e <brelse>
8010162d:	83 c4 10             	add    $0x10,%esp
}
80101630:	90                   	nop
80101631:	c9                   	leave  
80101632:	c3                   	ret    

80101633 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101633:	55                   	push   %ebp
80101634:	89 e5                	mov    %esp,%ebp
80101636:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	68 d2 81 10 80       	push   $0x801081d2
80101641:	68 60 e8 10 80       	push   $0x8010e860
80101646:	e8 bb 35 00 00       	call   80104c06 <initlock>
8010164b:	83 c4 10             	add    $0x10,%esp
}
8010164e:	90                   	nop
8010164f:	c9                   	leave  
80101650:	c3                   	ret    

80101651 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101651:	55                   	push   %ebp
80101652:	89 e5                	mov    %esp,%ebp
80101654:	83 ec 38             	sub    $0x38,%esp
80101657:	8b 45 0c             	mov    0xc(%ebp),%eax
8010165a:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
8010165e:	8b 45 08             	mov    0x8(%ebp),%eax
80101661:	83 ec 08             	sub    $0x8,%esp
80101664:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101667:	52                   	push   %edx
80101668:	50                   	push   %eax
80101669:	e8 f6 fc ff ff       	call   80101364 <readsb>
8010166e:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101671:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101678:	e9 98 00 00 00       	jmp    80101715 <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
8010167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101680:	c1 e8 03             	shr    $0x3,%eax
80101683:	83 c0 02             	add    $0x2,%eax
80101686:	83 ec 08             	sub    $0x8,%esp
80101689:	50                   	push   %eax
8010168a:	ff 75 08             	pushl  0x8(%ebp)
8010168d:	e8 24 eb ff ff       	call   801001b6 <bread>
80101692:	83 c4 10             	add    $0x10,%esp
80101695:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101698:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169b:	8d 50 18             	lea    0x18(%eax),%edx
8010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a1:	83 e0 07             	and    $0x7,%eax
801016a4:	c1 e0 06             	shl    $0x6,%eax
801016a7:	01 d0                	add    %edx,%eax
801016a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016af:	0f b7 00             	movzwl (%eax),%eax
801016b2:	66 85 c0             	test   %ax,%ax
801016b5:	75 4c                	jne    80101703 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016b7:	83 ec 04             	sub    $0x4,%esp
801016ba:	6a 40                	push   $0x40
801016bc:	6a 00                	push   $0x0
801016be:	ff 75 ec             	pushl  -0x14(%ebp)
801016c1:	e8 c5 37 00 00       	call   80104e8b <memset>
801016c6:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016cc:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016d0:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016d3:	83 ec 0c             	sub    $0xc,%esp
801016d6:	ff 75 f0             	pushl  -0x10(%ebp)
801016d9:	e8 71 1c 00 00       	call   8010334f <log_write>
801016de:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016e1:	83 ec 0c             	sub    $0xc,%esp
801016e4:	ff 75 f0             	pushl  -0x10(%ebp)
801016e7:	e8 42 eb ff ff       	call   8010022e <brelse>
801016ec:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f2:	83 ec 08             	sub    $0x8,%esp
801016f5:	50                   	push   %eax
801016f6:	ff 75 08             	pushl  0x8(%ebp)
801016f9:	e8 ef 00 00 00       	call   801017ed <iget>
801016fe:	83 c4 10             	add    $0x10,%esp
80101701:	eb 2d                	jmp    80101730 <ialloc+0xdf>
    }
    brelse(bp);
80101703:	83 ec 0c             	sub    $0xc,%esp
80101706:	ff 75 f0             	pushl  -0x10(%ebp)
80101709:	e8 20 eb ff ff       	call   8010022e <brelse>
8010170e:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101711:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171b:	39 c2                	cmp    %eax,%edx
8010171d:	0f 87 5a ff ff ff    	ja     8010167d <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101723:	83 ec 0c             	sub    $0xc,%esp
80101726:	68 d9 81 10 80       	push   $0x801081d9
8010172b:	e8 36 ee ff ff       	call   80100566 <panic>
}
80101730:	c9                   	leave  
80101731:	c3                   	ret    

80101732 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101732:	55                   	push   %ebp
80101733:	89 e5                	mov    %esp,%ebp
80101735:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101738:	8b 45 08             	mov    0x8(%ebp),%eax
8010173b:	8b 40 04             	mov    0x4(%eax),%eax
8010173e:	c1 e8 03             	shr    $0x3,%eax
80101741:	8d 50 02             	lea    0x2(%eax),%edx
80101744:	8b 45 08             	mov    0x8(%ebp),%eax
80101747:	8b 00                	mov    (%eax),%eax
80101749:	83 ec 08             	sub    $0x8,%esp
8010174c:	52                   	push   %edx
8010174d:	50                   	push   %eax
8010174e:	e8 63 ea ff ff       	call   801001b6 <bread>
80101753:	83 c4 10             	add    $0x10,%esp
80101756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175c:	8d 50 18             	lea    0x18(%eax),%edx
8010175f:	8b 45 08             	mov    0x8(%ebp),%eax
80101762:	8b 40 04             	mov    0x4(%eax),%eax
80101765:	83 e0 07             	and    $0x7,%eax
80101768:	c1 e0 06             	shl    $0x6,%eax
8010176b:	01 d0                	add    %edx,%eax
8010176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101770:	8b 45 08             	mov    0x8(%ebp),%eax
80101773:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177d:	8b 45 08             	mov    0x8(%ebp),%eax
80101780:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101787:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010178b:	8b 45 08             	mov    0x8(%ebp),%eax
8010178e:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101792:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101795:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101799:	8b 45 08             	mov    0x8(%ebp),%eax
8010179c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a3:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017a7:	8b 45 08             	mov    0x8(%ebp),%eax
801017aa:	8b 50 18             	mov    0x18(%eax),%edx
801017ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b0:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	8d 50 1c             	lea    0x1c(%eax),%edx
801017b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bc:	83 c0 0c             	add    $0xc,%eax
801017bf:	83 ec 04             	sub    $0x4,%esp
801017c2:	6a 34                	push   $0x34
801017c4:	52                   	push   %edx
801017c5:	50                   	push   %eax
801017c6:	e8 7f 37 00 00       	call   80104f4a <memmove>
801017cb:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017ce:	83 ec 0c             	sub    $0xc,%esp
801017d1:	ff 75 f4             	pushl  -0xc(%ebp)
801017d4:	e8 76 1b 00 00       	call   8010334f <log_write>
801017d9:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017dc:	83 ec 0c             	sub    $0xc,%esp
801017df:	ff 75 f4             	pushl  -0xc(%ebp)
801017e2:	e8 47 ea ff ff       	call   8010022e <brelse>
801017e7:	83 c4 10             	add    $0x10,%esp
}
801017ea:	90                   	nop
801017eb:	c9                   	leave  
801017ec:	c3                   	ret    

801017ed <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017ed:	55                   	push   %ebp
801017ee:	89 e5                	mov    %esp,%ebp
801017f0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017f3:	83 ec 0c             	sub    $0xc,%esp
801017f6:	68 60 e8 10 80       	push   $0x8010e860
801017fb:	e8 28 34 00 00       	call   80104c28 <acquire>
80101800:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101803:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180a:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
80101811:	eb 5d                	jmp    80101870 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101816:	8b 40 08             	mov    0x8(%eax),%eax
80101819:	85 c0                	test   %eax,%eax
8010181b:	7e 39                	jle    80101856 <iget+0x69>
8010181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101820:	8b 00                	mov    (%eax),%eax
80101822:	3b 45 08             	cmp    0x8(%ebp),%eax
80101825:	75 2f                	jne    80101856 <iget+0x69>
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	8b 40 04             	mov    0x4(%eax),%eax
8010182d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101830:	75 24                	jne    80101856 <iget+0x69>
      ip->ref++;
80101832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101835:	8b 40 08             	mov    0x8(%eax),%eax
80101838:	8d 50 01             	lea    0x1(%eax),%edx
8010183b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101841:	83 ec 0c             	sub    $0xc,%esp
80101844:	68 60 e8 10 80       	push   $0x8010e860
80101849:	e8 41 34 00 00       	call   80104c8f <release>
8010184e:	83 c4 10             	add    $0x10,%esp
      return ip;
80101851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101854:	eb 74                	jmp    801018ca <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010185a:	75 10                	jne    8010186c <iget+0x7f>
8010185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185f:	8b 40 08             	mov    0x8(%eax),%eax
80101862:	85 c0                	test   %eax,%eax
80101864:	75 06                	jne    8010186c <iget+0x7f>
      empty = ip;
80101866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101869:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186c:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101870:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80101877:	72 9a                	jb     80101813 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010187d:	75 0d                	jne    8010188c <iget+0x9f>
    panic("iget: no inodes");
8010187f:	83 ec 0c             	sub    $0xc,%esp
80101882:	68 eb 81 10 80       	push   $0x801081eb
80101887:	e8 da ec ff ff       	call   80100566 <panic>

  ip = empty;
8010188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101895:	8b 55 08             	mov    0x8(%ebp),%edx
80101898:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189d:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 60 e8 10 80       	push   $0x8010e860
801018bf:	e8 cb 33 00 00       	call   80104c8f <release>
801018c4:	83 c4 10             	add    $0x10,%esp

  return ip;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ca:	c9                   	leave  
801018cb:	c3                   	ret    

801018cc <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018cc:	55                   	push   %ebp
801018cd:	89 e5                	mov    %esp,%ebp
801018cf:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018d2:	83 ec 0c             	sub    $0xc,%esp
801018d5:	68 60 e8 10 80       	push   $0x8010e860
801018da:	e8 49 33 00 00       	call   80104c28 <acquire>
801018df:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018e2:	8b 45 08             	mov    0x8(%ebp),%eax
801018e5:	8b 40 08             	mov    0x8(%eax),%eax
801018e8:	8d 50 01             	lea    0x1(%eax),%edx
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f1:	83 ec 0c             	sub    $0xc,%esp
801018f4:	68 60 e8 10 80       	push   $0x8010e860
801018f9:	e8 91 33 00 00       	call   80104c8f <release>
801018fe:	83 c4 10             	add    $0x10,%esp
  return ip;
80101901:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101904:	c9                   	leave  
80101905:	c3                   	ret    

80101906 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101906:	55                   	push   %ebp
80101907:	89 e5                	mov    %esp,%ebp
80101909:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010190c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101910:	74 0a                	je     8010191c <ilock+0x16>
80101912:	8b 45 08             	mov    0x8(%ebp),%eax
80101915:	8b 40 08             	mov    0x8(%eax),%eax
80101918:	85 c0                	test   %eax,%eax
8010191a:	7f 0d                	jg     80101929 <ilock+0x23>
    panic("ilock");
8010191c:	83 ec 0c             	sub    $0xc,%esp
8010191f:	68 fb 81 10 80       	push   $0x801081fb
80101924:	e8 3d ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101929:	83 ec 0c             	sub    $0xc,%esp
8010192c:	68 60 e8 10 80       	push   $0x8010e860
80101931:	e8 f2 32 00 00       	call   80104c28 <acquire>
80101936:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101939:	eb 13                	jmp    8010194e <ilock+0x48>
    sleep(ip, &icache.lock);
8010193b:	83 ec 08             	sub    $0x8,%esp
8010193e:	68 60 e8 10 80       	push   $0x8010e860
80101943:	ff 75 08             	pushl  0x8(%ebp)
80101946:	e8 8b 2f 00 00       	call   801048d6 <sleep>
8010194b:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010194e:	8b 45 08             	mov    0x8(%ebp),%eax
80101951:	8b 40 0c             	mov    0xc(%eax),%eax
80101954:	83 e0 01             	and    $0x1,%eax
80101957:	85 c0                	test   %eax,%eax
80101959:	75 e0                	jne    8010193b <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	8b 40 0c             	mov    0xc(%eax),%eax
80101961:	83 c8 01             	or     $0x1,%eax
80101964:	89 c2                	mov    %eax,%edx
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010196c:	83 ec 0c             	sub    $0xc,%esp
8010196f:	68 60 e8 10 80       	push   $0x8010e860
80101974:	e8 16 33 00 00       	call   80104c8f <release>
80101979:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	8b 40 0c             	mov    0xc(%eax),%eax
80101982:	83 e0 02             	and    $0x2,%eax
80101985:	85 c0                	test   %eax,%eax
80101987:	0f 85 ce 00 00 00    	jne    80101a5b <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	8b 40 04             	mov    0x4(%eax),%eax
80101993:	c1 e8 03             	shr    $0x3,%eax
80101996:	8d 50 02             	lea    0x2(%eax),%edx
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 00                	mov    (%eax),%eax
8010199e:	83 ec 08             	sub    $0x8,%esp
801019a1:	52                   	push   %edx
801019a2:	50                   	push   %eax
801019a3:	e8 0e e8 ff ff       	call   801001b6 <bread>
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b1:	8d 50 18             	lea    0x18(%eax),%edx
801019b4:	8b 45 08             	mov    0x8(%ebp),%eax
801019b7:	8b 40 04             	mov    0x4(%eax),%eax
801019ba:	83 e0 07             	and    $0x7,%eax
801019bd:	c1 e0 06             	shl    $0x6,%eax
801019c0:	01 d0                	add    %edx,%eax
801019c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c8:	0f b7 10             	movzwl (%eax),%edx
801019cb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ce:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e3:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f1:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ff:	8b 50 08             	mov    0x8(%eax),%edx
80101a02:	8b 45 08             	mov    0x8(%ebp),%eax
80101a05:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0b:	8d 50 0c             	lea    0xc(%eax),%edx
80101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a11:	83 c0 1c             	add    $0x1c,%eax
80101a14:	83 ec 04             	sub    $0x4,%esp
80101a17:	6a 34                	push   $0x34
80101a19:	52                   	push   %edx
80101a1a:	50                   	push   %eax
80101a1b:	e8 2a 35 00 00       	call   80104f4a <memmove>
80101a20:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a23:	83 ec 0c             	sub    $0xc,%esp
80101a26:	ff 75 f4             	pushl  -0xc(%ebp)
80101a29:	e8 00 e8 ff ff       	call   8010022e <brelse>
80101a2e:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a31:	8b 45 08             	mov    0x8(%ebp),%eax
80101a34:	8b 40 0c             	mov    0xc(%eax),%eax
80101a37:	83 c8 02             	or     $0x2,%eax
80101a3a:	89 c2                	mov    %eax,%edx
80101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a42:	8b 45 08             	mov    0x8(%ebp),%eax
80101a45:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a49:	66 85 c0             	test   %ax,%ax
80101a4c:	75 0d                	jne    80101a5b <ilock+0x155>
      panic("ilock: no type");
80101a4e:	83 ec 0c             	sub    $0xc,%esp
80101a51:	68 01 82 10 80       	push   $0x80108201
80101a56:	e8 0b eb ff ff       	call   80100566 <panic>
  }
}
80101a5b:	90                   	nop
80101a5c:	c9                   	leave  
80101a5d:	c3                   	ret    

80101a5e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a5e:	55                   	push   %ebp
80101a5f:	89 e5                	mov    %esp,%ebp
80101a61:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a68:	74 17                	je     80101a81 <iunlock+0x23>
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a70:	83 e0 01             	and    $0x1,%eax
80101a73:	85 c0                	test   %eax,%eax
80101a75:	74 0a                	je     80101a81 <iunlock+0x23>
80101a77:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7a:	8b 40 08             	mov    0x8(%eax),%eax
80101a7d:	85 c0                	test   %eax,%eax
80101a7f:	7f 0d                	jg     80101a8e <iunlock+0x30>
    panic("iunlock");
80101a81:	83 ec 0c             	sub    $0xc,%esp
80101a84:	68 10 82 10 80       	push   $0x80108210
80101a89:	e8 d8 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a8e:	83 ec 0c             	sub    $0xc,%esp
80101a91:	68 60 e8 10 80       	push   $0x8010e860
80101a96:	e8 8d 31 00 00       	call   80104c28 <acquire>
80101a9b:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa4:	83 e0 fe             	and    $0xfffffffe,%eax
80101aa7:	89 c2                	mov    %eax,%edx
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	ff 75 08             	pushl  0x8(%ebp)
80101ab5:	e8 07 2f 00 00       	call   801049c1 <wakeup>
80101aba:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101abd:	83 ec 0c             	sub    $0xc,%esp
80101ac0:	68 60 e8 10 80       	push   $0x8010e860
80101ac5:	e8 c5 31 00 00       	call   80104c8f <release>
80101aca:	83 c4 10             	add    $0x10,%esp
}
80101acd:	90                   	nop
80101ace:	c9                   	leave  
80101acf:	c3                   	ret    

80101ad0 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ad6:	83 ec 0c             	sub    $0xc,%esp
80101ad9:	68 60 e8 10 80       	push   $0x8010e860
80101ade:	e8 45 31 00 00       	call   80104c28 <acquire>
80101ae3:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	8b 40 08             	mov    0x8(%eax),%eax
80101aec:	83 f8 01             	cmp    $0x1,%eax
80101aef:	0f 85 a9 00 00 00    	jne    80101b9e <iput+0xce>
80101af5:	8b 45 08             	mov    0x8(%ebp),%eax
80101af8:	8b 40 0c             	mov    0xc(%eax),%eax
80101afb:	83 e0 02             	and    $0x2,%eax
80101afe:	85 c0                	test   %eax,%eax
80101b00:	0f 84 98 00 00 00    	je     80101b9e <iput+0xce>
80101b06:	8b 45 08             	mov    0x8(%ebp),%eax
80101b09:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b0d:	66 85 c0             	test   %ax,%ax
80101b10:	0f 85 88 00 00 00    	jne    80101b9e <iput+0xce>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1c:	83 e0 01             	and    $0x1,%eax
80101b1f:	85 c0                	test   %eax,%eax
80101b21:	74 0d                	je     80101b30 <iput+0x60>
      panic("iput busy");
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	68 18 82 10 80       	push   $0x80108218
80101b2b:	e8 36 ea ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	8b 40 0c             	mov    0xc(%eax),%eax
80101b36:	83 c8 01             	or     $0x1,%eax
80101b39:	89 c2                	mov    %eax,%edx
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	68 60 e8 10 80       	push   $0x8010e860
80101b49:	e8 41 31 00 00       	call   80104c8f <release>
80101b4e:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b51:	83 ec 0c             	sub    $0xc,%esp
80101b54:	ff 75 08             	pushl  0x8(%ebp)
80101b57:	e8 a8 01 00 00       	call   80101d04 <itrunc>
80101b5c:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b62:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	ff 75 08             	pushl  0x8(%ebp)
80101b6e:	e8 bf fb ff ff       	call   80101732 <iupdate>
80101b73:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	68 60 e8 10 80       	push   $0x8010e860
80101b7e:	e8 a5 30 00 00       	call   80104c28 <acquire>
80101b83:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b86:	8b 45 08             	mov    0x8(%ebp),%eax
80101b89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b90:	83 ec 0c             	sub    $0xc,%esp
80101b93:	ff 75 08             	pushl  0x8(%ebp)
80101b96:	e8 26 2e 00 00       	call   801049c1 <wakeup>
80101b9b:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba1:	8b 40 08             	mov    0x8(%eax),%eax
80101ba4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80101baa:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bad:	83 ec 0c             	sub    $0xc,%esp
80101bb0:	68 60 e8 10 80       	push   $0x8010e860
80101bb5:	e8 d5 30 00 00       	call   80104c8f <release>
80101bba:	83 c4 10             	add    $0x10,%esp
}
80101bbd:	90                   	nop
80101bbe:	c9                   	leave  
80101bbf:	c3                   	ret    

80101bc0 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bc6:	83 ec 0c             	sub    $0xc,%esp
80101bc9:	ff 75 08             	pushl  0x8(%ebp)
80101bcc:	e8 8d fe ff ff       	call   80101a5e <iunlock>
80101bd1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bd4:	83 ec 0c             	sub    $0xc,%esp
80101bd7:	ff 75 08             	pushl  0x8(%ebp)
80101bda:	e8 f1 fe ff ff       	call   80101ad0 <iput>
80101bdf:	83 c4 10             	add    $0x10,%esp
}
80101be2:	90                   	nop
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    

80101be5 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101be5:	55                   	push   %ebp
80101be6:	89 e5                	mov    %esp,%ebp
80101be8:	53                   	push   %ebx
80101be9:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bec:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf0:	77 42                	ja     80101c34 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bf8:	83 c2 04             	add    $0x4,%edx
80101bfb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c06:	75 24                	jne    80101c2c <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	8b 00                	mov    (%eax),%eax
80101c0d:	83 ec 0c             	sub    $0xc,%esp
80101c10:	50                   	push   %eax
80101c11:	e8 e4 f7 ff ff       	call   801013fa <balloc>
80101c16:	83 c4 10             	add    $0x10,%esp
80101c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c22:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c28:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2f:	e9 cb 00 00 00       	jmp    80101cff <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c34:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c38:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c3c:	0f 87 b0 00 00 00    	ja     80101cf2 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c42:	8b 45 08             	mov    0x8(%ebp),%eax
80101c45:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c4f:	75 1d                	jne    80101c6e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c51:	8b 45 08             	mov    0x8(%ebp),%eax
80101c54:	8b 00                	mov    (%eax),%eax
80101c56:	83 ec 0c             	sub    $0xc,%esp
80101c59:	50                   	push   %eax
80101c5a:	e8 9b f7 ff ff       	call   801013fa <balloc>
80101c5f:	83 c4 10             	add    $0x10,%esp
80101c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c71:	8b 00                	mov    (%eax),%eax
80101c73:	83 ec 08             	sub    $0x8,%esp
80101c76:	ff 75 f4             	pushl  -0xc(%ebp)
80101c79:	50                   	push   %eax
80101c7a:	e8 37 e5 ff ff       	call   801001b6 <bread>
80101c7f:	83 c4 10             	add    $0x10,%esp
80101c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c88:	83 c0 18             	add    $0x18,%eax
80101c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9b:	01 d0                	add    %edx,%eax
80101c9d:	8b 00                	mov    (%eax),%eax
80101c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ca6:	75 37                	jne    80101cdf <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	8b 00                	mov    (%eax),%eax
80101cbd:	83 ec 0c             	sub    $0xc,%esp
80101cc0:	50                   	push   %eax
80101cc1:	e8 34 f7 ff ff       	call   801013fa <balloc>
80101cc6:	83 c4 10             	add    $0x10,%esp
80101cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ccf:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cd1:	83 ec 0c             	sub    $0xc,%esp
80101cd4:	ff 75 f0             	pushl  -0x10(%ebp)
80101cd7:	e8 73 16 00 00       	call   8010334f <log_write>
80101cdc:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	ff 75 f0             	pushl  -0x10(%ebp)
80101ce5:	e8 44 e5 ff ff       	call   8010022e <brelse>
80101cea:	83 c4 10             	add    $0x10,%esp
    return addr;
80101ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf0:	eb 0d                	jmp    80101cff <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cf2:	83 ec 0c             	sub    $0xc,%esp
80101cf5:	68 22 82 10 80       	push   $0x80108222
80101cfa:	e8 67 e8 ff ff       	call   80100566 <panic>
}
80101cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d02:	c9                   	leave  
80101d03:	c3                   	ret    

80101d04 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d11:	eb 45                	jmp    80101d58 <itrunc+0x54>
    if(ip->addrs[i]){
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d19:	83 c2 04             	add    $0x4,%edx
80101d1c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d20:	85 c0                	test   %eax,%eax
80101d22:	74 30                	je     80101d54 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d2a:	83 c2 04             	add    $0x4,%edx
80101d2d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d31:	8b 55 08             	mov    0x8(%ebp),%edx
80101d34:	8b 12                	mov    (%edx),%edx
80101d36:	83 ec 08             	sub    $0x8,%esp
80101d39:	50                   	push   %eax
80101d3a:	52                   	push   %edx
80101d3b:	e8 18 f8 ff ff       	call   80101558 <bfree>
80101d40:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d43:	8b 45 08             	mov    0x8(%ebp),%eax
80101d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d49:	83 c2 04             	add    $0x4,%edx
80101d4c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d53:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d58:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d5c:	7e b5                	jle    80101d13 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d64:	85 c0                	test   %eax,%eax
80101d66:	0f 84 a1 00 00 00    	je     80101e0d <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d72:	8b 45 08             	mov    0x8(%ebp),%eax
80101d75:	8b 00                	mov    (%eax),%eax
80101d77:	83 ec 08             	sub    $0x8,%esp
80101d7a:	52                   	push   %edx
80101d7b:	50                   	push   %eax
80101d7c:	e8 35 e4 ff ff       	call   801001b6 <bread>
80101d81:	83 c4 10             	add    $0x10,%esp
80101d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8a:	83 c0 18             	add    $0x18,%eax
80101d8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d97:	eb 3c                	jmp    80101dd5 <itrunc+0xd1>
      if(a[j])
80101d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101da6:	01 d0                	add    %edx,%eax
80101da8:	8b 00                	mov    (%eax),%eax
80101daa:	85 c0                	test   %eax,%eax
80101dac:	74 23                	je     80101dd1 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dbb:	01 d0                	add    %edx,%eax
80101dbd:	8b 00                	mov    (%eax),%eax
80101dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc2:	8b 12                	mov    (%edx),%edx
80101dc4:	83 ec 08             	sub    $0x8,%esp
80101dc7:	50                   	push   %eax
80101dc8:	52                   	push   %edx
80101dc9:	e8 8a f7 ff ff       	call   80101558 <bfree>
80101dce:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dd1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd8:	83 f8 7f             	cmp    $0x7f,%eax
80101ddb:	76 bc                	jbe    80101d99 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ddd:	83 ec 0c             	sub    $0xc,%esp
80101de0:	ff 75 ec             	pushl  -0x14(%ebp)
80101de3:	e8 46 e4 ff ff       	call   8010022e <brelse>
80101de8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101deb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dee:	8b 40 4c             	mov    0x4c(%eax),%eax
80101df1:	8b 55 08             	mov    0x8(%ebp),%edx
80101df4:	8b 12                	mov    (%edx),%edx
80101df6:	83 ec 08             	sub    $0x8,%esp
80101df9:	50                   	push   %eax
80101dfa:	52                   	push   %edx
80101dfb:	e8 58 f7 ff ff       	call   80101558 <bfree>
80101e00:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e17:	83 ec 0c             	sub    $0xc,%esp
80101e1a:	ff 75 08             	pushl  0x8(%ebp)
80101e1d:	e8 10 f9 ff ff       	call   80101732 <iupdate>
80101e22:	83 c4 10             	add    $0x10,%esp
}
80101e25:	90                   	nop
80101e26:	c9                   	leave  
80101e27:	c3                   	ret    

80101e28 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e28:	55                   	push   %ebp
80101e29:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2e:	8b 00                	mov    (%eax),%eax
80101e30:	89 c2                	mov    %eax,%edx
80101e32:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e35:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e38:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3b:	8b 50 04             	mov    0x4(%eax),%edx
80101e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e41:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4e:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e58:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5b:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e62:	8b 50 18             	mov    0x18(%eax),%edx
80101e65:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e68:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e6b:	90                   	nop
80101e6c:	5d                   	pop    %ebp
80101e6d:	c3                   	ret    

80101e6e <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e6e:	55                   	push   %ebp
80101e6f:	89 e5                	mov    %esp,%ebp
80101e71:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e7b:	66 83 f8 03          	cmp    $0x3,%ax
80101e7f:	75 5c                	jne    80101edd <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e81:	8b 45 08             	mov    0x8(%ebp),%eax
80101e84:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e88:	66 85 c0             	test   %ax,%ax
80101e8b:	78 20                	js     80101ead <readi+0x3f>
80101e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e90:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e94:	66 83 f8 09          	cmp    $0x9,%ax
80101e98:	7f 13                	jg     80101ead <readi+0x3f>
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea1:	98                   	cwtl   
80101ea2:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101ea9:	85 c0                	test   %eax,%eax
80101eab:	75 0a                	jne    80101eb7 <readi+0x49>
      return -1;
80101ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb2:	e9 0c 01 00 00       	jmp    80101fc3 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eba:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ebe:	98                   	cwtl   
80101ebf:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101ec6:	8b 55 14             	mov    0x14(%ebp),%edx
80101ec9:	83 ec 04             	sub    $0x4,%esp
80101ecc:	52                   	push   %edx
80101ecd:	ff 75 0c             	pushl  0xc(%ebp)
80101ed0:	ff 75 08             	pushl  0x8(%ebp)
80101ed3:	ff d0                	call   *%eax
80101ed5:	83 c4 10             	add    $0x10,%esp
80101ed8:	e9 e6 00 00 00       	jmp    80101fc3 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 40 18             	mov    0x18(%eax),%eax
80101ee3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ee6:	72 0d                	jb     80101ef5 <readi+0x87>
80101ee8:	8b 55 10             	mov    0x10(%ebp),%edx
80101eeb:	8b 45 14             	mov    0x14(%ebp),%eax
80101eee:	01 d0                	add    %edx,%eax
80101ef0:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef3:	73 0a                	jae    80101eff <readi+0x91>
    return -1;
80101ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101efa:	e9 c4 00 00 00       	jmp    80101fc3 <readi+0x155>
  if(off + n > ip->size)
80101eff:	8b 55 10             	mov    0x10(%ebp),%edx
80101f02:	8b 45 14             	mov    0x14(%ebp),%eax
80101f05:	01 c2                	add    %eax,%edx
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	8b 40 18             	mov    0x18(%eax),%eax
80101f0d:	39 c2                	cmp    %eax,%edx
80101f0f:	76 0c                	jbe    80101f1d <readi+0xaf>
    n = ip->size - off;
80101f11:	8b 45 08             	mov    0x8(%ebp),%eax
80101f14:	8b 40 18             	mov    0x18(%eax),%eax
80101f17:	2b 45 10             	sub    0x10(%ebp),%eax
80101f1a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f24:	e9 8b 00 00 00       	jmp    80101fb4 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f29:	8b 45 10             	mov    0x10(%ebp),%eax
80101f2c:	c1 e8 09             	shr    $0x9,%eax
80101f2f:	83 ec 08             	sub    $0x8,%esp
80101f32:	50                   	push   %eax
80101f33:	ff 75 08             	pushl  0x8(%ebp)
80101f36:	e8 aa fc ff ff       	call   80101be5 <bmap>
80101f3b:	83 c4 10             	add    $0x10,%esp
80101f3e:	89 c2                	mov    %eax,%edx
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	8b 00                	mov    (%eax),%eax
80101f45:	83 ec 08             	sub    $0x8,%esp
80101f48:	52                   	push   %edx
80101f49:	50                   	push   %eax
80101f4a:	e8 67 e2 ff ff       	call   801001b6 <bread>
80101f4f:	83 c4 10             	add    $0x10,%esp
80101f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f55:	8b 45 10             	mov    0x10(%ebp),%eax
80101f58:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f5d:	ba 00 02 00 00       	mov    $0x200,%edx
80101f62:	29 c2                	sub    %eax,%edx
80101f64:	8b 45 14             	mov    0x14(%ebp),%eax
80101f67:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f6a:	39 c2                	cmp    %eax,%edx
80101f6c:	0f 46 c2             	cmovbe %edx,%eax
80101f6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f75:	8d 50 18             	lea    0x18(%eax),%edx
80101f78:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f80:	01 d0                	add    %edx,%eax
80101f82:	83 ec 04             	sub    $0x4,%esp
80101f85:	ff 75 ec             	pushl  -0x14(%ebp)
80101f88:	50                   	push   %eax
80101f89:	ff 75 0c             	pushl  0xc(%ebp)
80101f8c:	e8 b9 2f 00 00       	call   80104f4a <memmove>
80101f91:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f94:	83 ec 0c             	sub    $0xc,%esp
80101f97:	ff 75 f0             	pushl  -0x10(%ebp)
80101f9a:	e8 8f e2 ff ff       	call   8010022e <brelse>
80101f9f:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fa5:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fab:	01 45 10             	add    %eax,0x10(%ebp)
80101fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb1:	01 45 0c             	add    %eax,0xc(%ebp)
80101fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fb7:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fba:	0f 82 69 ff ff ff    	jb     80101f29 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fc0:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    

80101fc5 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fc5:	55                   	push   %ebp
80101fc6:	89 e5                	mov    %esp,%ebp
80101fc8:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fd2:	66 83 f8 03          	cmp    $0x3,%ax
80101fd6:	75 5c                	jne    80102034 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fdf:	66 85 c0             	test   %ax,%ax
80101fe2:	78 20                	js     80102004 <writei+0x3f>
80101fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101feb:	66 83 f8 09          	cmp    $0x9,%ax
80101fef:	7f 13                	jg     80102004 <writei+0x3f>
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ff8:	98                   	cwtl   
80101ff9:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80102000:	85 c0                	test   %eax,%eax
80102002:	75 0a                	jne    8010200e <writei+0x49>
      return -1;
80102004:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102009:	e9 3d 01 00 00       	jmp    8010214b <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010200e:	8b 45 08             	mov    0x8(%ebp),%eax
80102011:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102015:	98                   	cwtl   
80102016:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
8010201d:	8b 55 14             	mov    0x14(%ebp),%edx
80102020:	83 ec 04             	sub    $0x4,%esp
80102023:	52                   	push   %edx
80102024:	ff 75 0c             	pushl  0xc(%ebp)
80102027:	ff 75 08             	pushl  0x8(%ebp)
8010202a:	ff d0                	call   *%eax
8010202c:	83 c4 10             	add    $0x10,%esp
8010202f:	e9 17 01 00 00       	jmp    8010214b <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102034:	8b 45 08             	mov    0x8(%ebp),%eax
80102037:	8b 40 18             	mov    0x18(%eax),%eax
8010203a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010203d:	72 0d                	jb     8010204c <writei+0x87>
8010203f:	8b 55 10             	mov    0x10(%ebp),%edx
80102042:	8b 45 14             	mov    0x14(%ebp),%eax
80102045:	01 d0                	add    %edx,%eax
80102047:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204a:	73 0a                	jae    80102056 <writei+0x91>
    return -1;
8010204c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102051:	e9 f5 00 00 00       	jmp    8010214b <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102056:	8b 55 10             	mov    0x10(%ebp),%edx
80102059:	8b 45 14             	mov    0x14(%ebp),%eax
8010205c:	01 d0                	add    %edx,%eax
8010205e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102063:	76 0a                	jbe    8010206f <writei+0xaa>
    return -1;
80102065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206a:	e9 dc 00 00 00       	jmp    8010214b <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010206f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102076:	e9 99 00 00 00       	jmp    80102114 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010207b:	8b 45 10             	mov    0x10(%ebp),%eax
8010207e:	c1 e8 09             	shr    $0x9,%eax
80102081:	83 ec 08             	sub    $0x8,%esp
80102084:	50                   	push   %eax
80102085:	ff 75 08             	pushl  0x8(%ebp)
80102088:	e8 58 fb ff ff       	call   80101be5 <bmap>
8010208d:	83 c4 10             	add    $0x10,%esp
80102090:	89 c2                	mov    %eax,%edx
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	8b 00                	mov    (%eax),%eax
80102097:	83 ec 08             	sub    $0x8,%esp
8010209a:	52                   	push   %edx
8010209b:	50                   	push   %eax
8010209c:	e8 15 e1 ff ff       	call   801001b6 <bread>
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020a7:	8b 45 10             	mov    0x10(%ebp),%eax
801020aa:	25 ff 01 00 00       	and    $0x1ff,%eax
801020af:	ba 00 02 00 00       	mov    $0x200,%edx
801020b4:	29 c2                	sub    %eax,%edx
801020b6:	8b 45 14             	mov    0x14(%ebp),%eax
801020b9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020bc:	39 c2                	cmp    %eax,%edx
801020be:	0f 46 c2             	cmovbe %edx,%eax
801020c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c7:	8d 50 18             	lea    0x18(%eax),%edx
801020ca:	8b 45 10             	mov    0x10(%ebp),%eax
801020cd:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d2:	01 d0                	add    %edx,%eax
801020d4:	83 ec 04             	sub    $0x4,%esp
801020d7:	ff 75 ec             	pushl  -0x14(%ebp)
801020da:	ff 75 0c             	pushl  0xc(%ebp)
801020dd:	50                   	push   %eax
801020de:	e8 67 2e 00 00       	call   80104f4a <memmove>
801020e3:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	ff 75 f0             	pushl  -0x10(%ebp)
801020ec:	e8 5e 12 00 00       	call   8010334f <log_write>
801020f1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020f4:	83 ec 0c             	sub    $0xc,%esp
801020f7:	ff 75 f0             	pushl  -0x10(%ebp)
801020fa:	e8 2f e1 ff ff       	call   8010022e <brelse>
801020ff:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102102:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102105:	01 45 f4             	add    %eax,-0xc(%ebp)
80102108:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010210b:	01 45 10             	add    %eax,0x10(%ebp)
8010210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102111:	01 45 0c             	add    %eax,0xc(%ebp)
80102114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102117:	3b 45 14             	cmp    0x14(%ebp),%eax
8010211a:	0f 82 5b ff ff ff    	jb     8010207b <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102120:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102124:	74 22                	je     80102148 <writei+0x183>
80102126:	8b 45 08             	mov    0x8(%ebp),%eax
80102129:	8b 40 18             	mov    0x18(%eax),%eax
8010212c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010212f:	73 17                	jae    80102148 <writei+0x183>
    ip->size = off;
80102131:	8b 45 08             	mov    0x8(%ebp),%eax
80102134:	8b 55 10             	mov    0x10(%ebp),%edx
80102137:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010213a:	83 ec 0c             	sub    $0xc,%esp
8010213d:	ff 75 08             	pushl  0x8(%ebp)
80102140:	e8 ed f5 ff ff       	call   80101732 <iupdate>
80102145:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102148:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010214b:	c9                   	leave  
8010214c:	c3                   	ret    

8010214d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010214d:	55                   	push   %ebp
8010214e:	89 e5                	mov    %esp,%ebp
80102150:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102153:	83 ec 04             	sub    $0x4,%esp
80102156:	6a 0e                	push   $0xe
80102158:	ff 75 0c             	pushl  0xc(%ebp)
8010215b:	ff 75 08             	pushl  0x8(%ebp)
8010215e:	e8 7d 2e 00 00       	call   80104fe0 <strncmp>
80102163:	83 c4 10             	add    $0x10,%esp
}
80102166:	c9                   	leave  
80102167:	c3                   	ret    

80102168 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102168:	55                   	push   %ebp
80102169:	89 e5                	mov    %esp,%ebp
8010216b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010216e:	8b 45 08             	mov    0x8(%ebp),%eax
80102171:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102175:	66 83 f8 01          	cmp    $0x1,%ax
80102179:	74 0d                	je     80102188 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010217b:	83 ec 0c             	sub    $0xc,%esp
8010217e:	68 35 82 10 80       	push   $0x80108235
80102183:	e8 de e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218f:	eb 7b                	jmp    8010220c <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102191:	6a 10                	push   $0x10
80102193:	ff 75 f4             	pushl  -0xc(%ebp)
80102196:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102199:	50                   	push   %eax
8010219a:	ff 75 08             	pushl  0x8(%ebp)
8010219d:	e8 cc fc ff ff       	call   80101e6e <readi>
801021a2:	83 c4 10             	add    $0x10,%esp
801021a5:	83 f8 10             	cmp    $0x10,%eax
801021a8:	74 0d                	je     801021b7 <dirlookup+0x4f>
      panic("dirlink read");
801021aa:	83 ec 0c             	sub    $0xc,%esp
801021ad:	68 47 82 10 80       	push   $0x80108247
801021b2:	e8 af e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801021b7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021bb:	66 85 c0             	test   %ax,%ax
801021be:	74 47                	je     80102207 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021c6:	83 c0 02             	add    $0x2,%eax
801021c9:	50                   	push   %eax
801021ca:	ff 75 0c             	pushl  0xc(%ebp)
801021cd:	e8 7b ff ff ff       	call   8010214d <namecmp>
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	85 c0                	test   %eax,%eax
801021d7:	75 2f                	jne    80102208 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021dd:	74 08                	je     801021e7 <dirlookup+0x7f>
        *poff = off;
801021df:	8b 45 10             	mov    0x10(%ebp),%eax
801021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021e5:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021e7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021eb:	0f b7 c0             	movzwl %ax,%eax
801021ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021f1:	8b 45 08             	mov    0x8(%ebp),%eax
801021f4:	8b 00                	mov    (%eax),%eax
801021f6:	83 ec 08             	sub    $0x8,%esp
801021f9:	ff 75 f0             	pushl  -0x10(%ebp)
801021fc:	50                   	push   %eax
801021fd:	e8 eb f5 ff ff       	call   801017ed <iget>
80102202:	83 c4 10             	add    $0x10,%esp
80102205:	eb 19                	jmp    80102220 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102207:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102208:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010220c:	8b 45 08             	mov    0x8(%ebp),%eax
8010220f:	8b 40 18             	mov    0x18(%eax),%eax
80102212:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102215:	0f 87 76 ff ff ff    	ja     80102191 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102220:	c9                   	leave  
80102221:	c3                   	ret    

80102222 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102222:	55                   	push   %ebp
80102223:	89 e5                	mov    %esp,%ebp
80102225:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102228:	83 ec 04             	sub    $0x4,%esp
8010222b:	6a 00                	push   $0x0
8010222d:	ff 75 0c             	pushl  0xc(%ebp)
80102230:	ff 75 08             	pushl  0x8(%ebp)
80102233:	e8 30 ff ff ff       	call   80102168 <dirlookup>
80102238:	83 c4 10             	add    $0x10,%esp
8010223b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010223e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102242:	74 18                	je     8010225c <dirlink+0x3a>
    iput(ip);
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	ff 75 f0             	pushl  -0x10(%ebp)
8010224a:	e8 81 f8 ff ff       	call   80101ad0 <iput>
8010224f:	83 c4 10             	add    $0x10,%esp
    return -1;
80102252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102257:	e9 9c 00 00 00       	jmp    801022f8 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010225c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102263:	eb 39                	jmp    8010229e <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102268:	6a 10                	push   $0x10
8010226a:	50                   	push   %eax
8010226b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010226e:	50                   	push   %eax
8010226f:	ff 75 08             	pushl  0x8(%ebp)
80102272:	e8 f7 fb ff ff       	call   80101e6e <readi>
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 f8 10             	cmp    $0x10,%eax
8010227d:	74 0d                	je     8010228c <dirlink+0x6a>
      panic("dirlink read");
8010227f:	83 ec 0c             	sub    $0xc,%esp
80102282:	68 47 82 10 80       	push   $0x80108247
80102287:	e8 da e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010228c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102290:	66 85 c0             	test   %ax,%ax
80102293:	74 18                	je     801022ad <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102298:	83 c0 10             	add    $0x10,%eax
8010229b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010229e:	8b 45 08             	mov    0x8(%ebp),%eax
801022a1:	8b 50 18             	mov    0x18(%eax),%edx
801022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a7:	39 c2                	cmp    %eax,%edx
801022a9:	77 ba                	ja     80102265 <dirlink+0x43>
801022ab:	eb 01                	jmp    801022ae <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022ad:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022ae:	83 ec 04             	sub    $0x4,%esp
801022b1:	6a 0e                	push   $0xe
801022b3:	ff 75 0c             	pushl  0xc(%ebp)
801022b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b9:	83 c0 02             	add    $0x2,%eax
801022bc:	50                   	push   %eax
801022bd:	e8 74 2d 00 00       	call   80105036 <strncpy>
801022c2:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022c5:	8b 45 10             	mov    0x10(%ebp),%eax
801022c8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cf:	6a 10                	push   $0x10
801022d1:	50                   	push   %eax
801022d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d5:	50                   	push   %eax
801022d6:	ff 75 08             	pushl  0x8(%ebp)
801022d9:	e8 e7 fc ff ff       	call   80101fc5 <writei>
801022de:	83 c4 10             	add    $0x10,%esp
801022e1:	83 f8 10             	cmp    $0x10,%eax
801022e4:	74 0d                	je     801022f3 <dirlink+0xd1>
    panic("dirlink");
801022e6:	83 ec 0c             	sub    $0xc,%esp
801022e9:	68 54 82 10 80       	push   $0x80108254
801022ee:	e8 73 e2 ff ff       	call   80100566 <panic>
  
  return 0;
801022f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022f8:	c9                   	leave  
801022f9:	c3                   	ret    

801022fa <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022fa:	55                   	push   %ebp
801022fb:	89 e5                	mov    %esp,%ebp
801022fd:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102300:	eb 04                	jmp    80102306 <skipelem+0xc>
    path++;
80102302:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102306:	8b 45 08             	mov    0x8(%ebp),%eax
80102309:	0f b6 00             	movzbl (%eax),%eax
8010230c:	3c 2f                	cmp    $0x2f,%al
8010230e:	74 f2                	je     80102302 <skipelem+0x8>
    path++;
  if(*path == 0)
80102310:	8b 45 08             	mov    0x8(%ebp),%eax
80102313:	0f b6 00             	movzbl (%eax),%eax
80102316:	84 c0                	test   %al,%al
80102318:	75 07                	jne    80102321 <skipelem+0x27>
    return 0;
8010231a:	b8 00 00 00 00       	mov    $0x0,%eax
8010231f:	eb 7b                	jmp    8010239c <skipelem+0xa2>
  s = path;
80102321:	8b 45 08             	mov    0x8(%ebp),%eax
80102324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102327:	eb 04                	jmp    8010232d <skipelem+0x33>
    path++;
80102329:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010232d:	8b 45 08             	mov    0x8(%ebp),%eax
80102330:	0f b6 00             	movzbl (%eax),%eax
80102333:	3c 2f                	cmp    $0x2f,%al
80102335:	74 0a                	je     80102341 <skipelem+0x47>
80102337:	8b 45 08             	mov    0x8(%ebp),%eax
8010233a:	0f b6 00             	movzbl (%eax),%eax
8010233d:	84 c0                	test   %al,%al
8010233f:	75 e8                	jne    80102329 <skipelem+0x2f>
    path++;
  len = path - s;
80102341:	8b 55 08             	mov    0x8(%ebp),%edx
80102344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102347:	29 c2                	sub    %eax,%edx
80102349:	89 d0                	mov    %edx,%eax
8010234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010234e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102352:	7e 15                	jle    80102369 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	6a 0e                	push   $0xe
80102359:	ff 75 f4             	pushl  -0xc(%ebp)
8010235c:	ff 75 0c             	pushl  0xc(%ebp)
8010235f:	e8 e6 2b 00 00       	call   80104f4a <memmove>
80102364:	83 c4 10             	add    $0x10,%esp
80102367:	eb 26                	jmp    8010238f <skipelem+0x95>
  else {
    memmove(name, s, len);
80102369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010236c:	83 ec 04             	sub    $0x4,%esp
8010236f:	50                   	push   %eax
80102370:	ff 75 f4             	pushl  -0xc(%ebp)
80102373:	ff 75 0c             	pushl  0xc(%ebp)
80102376:	e8 cf 2b 00 00       	call   80104f4a <memmove>
8010237b:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010237e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102381:	8b 45 0c             	mov    0xc(%ebp),%eax
80102384:	01 d0                	add    %edx,%eax
80102386:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102389:	eb 04                	jmp    8010238f <skipelem+0x95>
    path++;
8010238b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010238f:	8b 45 08             	mov    0x8(%ebp),%eax
80102392:	0f b6 00             	movzbl (%eax),%eax
80102395:	3c 2f                	cmp    $0x2f,%al
80102397:	74 f2                	je     8010238b <skipelem+0x91>
    path++;
  return path;
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010239c:	c9                   	leave  
8010239d:	c3                   	ret    

8010239e <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010239e:	55                   	push   %ebp
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023a4:	8b 45 08             	mov    0x8(%ebp),%eax
801023a7:	0f b6 00             	movzbl (%eax),%eax
801023aa:	3c 2f                	cmp    $0x2f,%al
801023ac:	75 17                	jne    801023c5 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023ae:	83 ec 08             	sub    $0x8,%esp
801023b1:	6a 01                	push   $0x1
801023b3:	6a 01                	push   $0x1
801023b5:	e8 33 f4 ff ff       	call   801017ed <iget>
801023ba:	83 c4 10             	add    $0x10,%esp
801023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023c0:	e9 bb 00 00 00       	jmp    80102480 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023cb:	8b 40 68             	mov    0x68(%eax),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
801023d1:	50                   	push   %eax
801023d2:	e8 f5 f4 ff ff       	call   801018cc <idup>
801023d7:	83 c4 10             	add    $0x10,%esp
801023da:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023dd:	e9 9e 00 00 00       	jmp    80102480 <namex+0xe2>
    ilock(ip);
801023e2:	83 ec 0c             	sub    $0xc,%esp
801023e5:	ff 75 f4             	pushl  -0xc(%ebp)
801023e8:	e8 19 f5 ff ff       	call   80101906 <ilock>
801023ed:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023f7:	66 83 f8 01          	cmp    $0x1,%ax
801023fb:	74 18                	je     80102415 <namex+0x77>
      iunlockput(ip);
801023fd:	83 ec 0c             	sub    $0xc,%esp
80102400:	ff 75 f4             	pushl  -0xc(%ebp)
80102403:	e8 b8 f7 ff ff       	call   80101bc0 <iunlockput>
80102408:	83 c4 10             	add    $0x10,%esp
      return 0;
8010240b:	b8 00 00 00 00       	mov    $0x0,%eax
80102410:	e9 a7 00 00 00       	jmp    801024bc <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102419:	74 20                	je     8010243b <namex+0x9d>
8010241b:	8b 45 08             	mov    0x8(%ebp),%eax
8010241e:	0f b6 00             	movzbl (%eax),%eax
80102421:	84 c0                	test   %al,%al
80102423:	75 16                	jne    8010243b <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102425:	83 ec 0c             	sub    $0xc,%esp
80102428:	ff 75 f4             	pushl  -0xc(%ebp)
8010242b:	e8 2e f6 ff ff       	call   80101a5e <iunlock>
80102430:	83 c4 10             	add    $0x10,%esp
      return ip;
80102433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102436:	e9 81 00 00 00       	jmp    801024bc <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010243b:	83 ec 04             	sub    $0x4,%esp
8010243e:	6a 00                	push   $0x0
80102440:	ff 75 10             	pushl  0x10(%ebp)
80102443:	ff 75 f4             	pushl  -0xc(%ebp)
80102446:	e8 1d fd ff ff       	call   80102168 <dirlookup>
8010244b:	83 c4 10             	add    $0x10,%esp
8010244e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102455:	75 15                	jne    8010246c <namex+0xce>
      iunlockput(ip);
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	ff 75 f4             	pushl  -0xc(%ebp)
8010245d:	e8 5e f7 ff ff       	call   80101bc0 <iunlockput>
80102462:	83 c4 10             	add    $0x10,%esp
      return 0;
80102465:	b8 00 00 00 00       	mov    $0x0,%eax
8010246a:	eb 50                	jmp    801024bc <namex+0x11e>
    }
    iunlockput(ip);
8010246c:	83 ec 0c             	sub    $0xc,%esp
8010246f:	ff 75 f4             	pushl  -0xc(%ebp)
80102472:	e8 49 f7 ff ff       	call   80101bc0 <iunlockput>
80102477:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102480:	83 ec 08             	sub    $0x8,%esp
80102483:	ff 75 10             	pushl  0x10(%ebp)
80102486:	ff 75 08             	pushl  0x8(%ebp)
80102489:	e8 6c fe ff ff       	call   801022fa <skipelem>
8010248e:	83 c4 10             	add    $0x10,%esp
80102491:	89 45 08             	mov    %eax,0x8(%ebp)
80102494:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102498:	0f 85 44 ff ff ff    	jne    801023e2 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010249e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024a2:	74 15                	je     801024b9 <namex+0x11b>
    iput(ip);
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	ff 75 f4             	pushl  -0xc(%ebp)
801024aa:	e8 21 f6 ff ff       	call   80101ad0 <iput>
801024af:	83 c4 10             	add    $0x10,%esp
    return 0;
801024b2:	b8 00 00 00 00       	mov    $0x0,%eax
801024b7:	eb 03                	jmp    801024bc <namex+0x11e>
  }
  return ip;
801024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024bc:	c9                   	leave  
801024bd:	c3                   	ret    

801024be <namei>:

struct inode*
namei(char *path)
{
801024be:	55                   	push   %ebp
801024bf:	89 e5                	mov    %esp,%ebp
801024c1:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024ca:	50                   	push   %eax
801024cb:	6a 00                	push   $0x0
801024cd:	ff 75 08             	pushl  0x8(%ebp)
801024d0:	e8 c9 fe ff ff       	call   8010239e <namex>
801024d5:	83 c4 10             	add    $0x10,%esp
}
801024d8:	c9                   	leave  
801024d9:	c3                   	ret    

801024da <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024da:	55                   	push   %ebp
801024db:	89 e5                	mov    %esp,%ebp
801024dd:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024e0:	83 ec 04             	sub    $0x4,%esp
801024e3:	ff 75 0c             	pushl  0xc(%ebp)
801024e6:	6a 01                	push   $0x1
801024e8:	ff 75 08             	pushl  0x8(%ebp)
801024eb:	e8 ae fe ff ff       	call   8010239e <namex>
801024f0:	83 c4 10             	add    $0x10,%esp
}
801024f3:	c9                   	leave  
801024f4:	c3                   	ret    

801024f5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024f5:	55                   	push   %ebp
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	83 ec 14             	sub    $0x14,%esp
801024fb:	8b 45 08             	mov    0x8(%ebp),%eax
801024fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102502:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102506:	89 c2                	mov    %eax,%edx
80102508:	ec                   	in     (%dx),%al
80102509:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010250c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102510:	c9                   	leave  
80102511:	c3                   	ret    

80102512 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102512:	55                   	push   %ebp
80102513:	89 e5                	mov    %esp,%ebp
80102515:	57                   	push   %edi
80102516:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102517:	8b 55 08             	mov    0x8(%ebp),%edx
8010251a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251d:	8b 45 10             	mov    0x10(%ebp),%eax
80102520:	89 cb                	mov    %ecx,%ebx
80102522:	89 df                	mov    %ebx,%edi
80102524:	89 c1                	mov    %eax,%ecx
80102526:	fc                   	cld    
80102527:	f3 6d                	rep insl (%dx),%es:(%edi)
80102529:	89 c8                	mov    %ecx,%eax
8010252b:	89 fb                	mov    %edi,%ebx
8010252d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102530:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102533:	90                   	nop
80102534:	5b                   	pop    %ebx
80102535:	5f                   	pop    %edi
80102536:	5d                   	pop    %ebp
80102537:	c3                   	ret    

80102538 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	83 ec 08             	sub    $0x8,%esp
8010253e:	8b 55 08             	mov    0x8(%ebp),%edx
80102541:	8b 45 0c             	mov    0xc(%ebp),%eax
80102544:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102548:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010254b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010254f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102553:	ee                   	out    %al,(%dx)
}
80102554:	90                   	nop
80102555:	c9                   	leave  
80102556:	c3                   	ret    

80102557 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102557:	55                   	push   %ebp
80102558:	89 e5                	mov    %esp,%ebp
8010255a:	56                   	push   %esi
8010255b:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010255c:	8b 55 08             	mov    0x8(%ebp),%edx
8010255f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102562:	8b 45 10             	mov    0x10(%ebp),%eax
80102565:	89 cb                	mov    %ecx,%ebx
80102567:	89 de                	mov    %ebx,%esi
80102569:	89 c1                	mov    %eax,%ecx
8010256b:	fc                   	cld    
8010256c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010256e:	89 c8                	mov    %ecx,%eax
80102570:	89 f3                	mov    %esi,%ebx
80102572:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102575:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102578:	90                   	nop
80102579:	5b                   	pop    %ebx
8010257a:	5e                   	pop    %esi
8010257b:	5d                   	pop    %ebp
8010257c:	c3                   	ret    

8010257d <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010257d:	55                   	push   %ebp
8010257e:	89 e5                	mov    %esp,%ebp
80102580:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102583:	90                   	nop
80102584:	68 f7 01 00 00       	push   $0x1f7
80102589:	e8 67 ff ff ff       	call   801024f5 <inb>
8010258e:	83 c4 04             	add    $0x4,%esp
80102591:	0f b6 c0             	movzbl %al,%eax
80102594:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102597:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010259a:	25 c0 00 00 00       	and    $0xc0,%eax
8010259f:	83 f8 40             	cmp    $0x40,%eax
801025a2:	75 e0                	jne    80102584 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a8:	74 11                	je     801025bb <idewait+0x3e>
801025aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025ad:	83 e0 21             	and    $0x21,%eax
801025b0:	85 c0                	test   %eax,%eax
801025b2:	74 07                	je     801025bb <idewait+0x3e>
    return -1;
801025b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025b9:	eb 05                	jmp    801025c0 <idewait+0x43>
  return 0;
801025bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025c0:	c9                   	leave  
801025c1:	c3                   	ret    

801025c2 <ideinit>:

void
ideinit(void)
{
801025c2:	55                   	push   %ebp
801025c3:	89 e5                	mov    %esp,%ebp
801025c5:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025c8:	83 ec 08             	sub    $0x8,%esp
801025cb:	68 5c 82 10 80       	push   $0x8010825c
801025d0:	68 00 b6 10 80       	push   $0x8010b600
801025d5:	e8 2c 26 00 00       	call   80104c06 <initlock>
801025da:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025dd:	83 ec 0c             	sub    $0xc,%esp
801025e0:	6a 0e                	push   $0xe
801025e2:	e8 53 15 00 00       	call   80103b3a <picenable>
801025e7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025ea:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801025ef:	83 e8 01             	sub    $0x1,%eax
801025f2:	83 ec 08             	sub    $0x8,%esp
801025f5:	50                   	push   %eax
801025f6:	6a 0e                	push   $0xe
801025f8:	e8 37 04 00 00       	call   80102a34 <ioapicenable>
801025fd:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	6a 00                	push   $0x0
80102605:	e8 73 ff ff ff       	call   8010257d <idewait>
8010260a:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010260d:	83 ec 08             	sub    $0x8,%esp
80102610:	68 f0 00 00 00       	push   $0xf0
80102615:	68 f6 01 00 00       	push   $0x1f6
8010261a:	e8 19 ff ff ff       	call   80102538 <outb>
8010261f:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102629:	eb 24                	jmp    8010264f <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010262b:	83 ec 0c             	sub    $0xc,%esp
8010262e:	68 f7 01 00 00       	push   $0x1f7
80102633:	e8 bd fe ff ff       	call   801024f5 <inb>
80102638:	83 c4 10             	add    $0x10,%esp
8010263b:	84 c0                	test   %al,%al
8010263d:	74 0c                	je     8010264b <ideinit+0x89>
      havedisk1 = 1;
8010263f:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102646:	00 00 00 
      break;
80102649:	eb 0d                	jmp    80102658 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010264b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010264f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102656:	7e d3                	jle    8010262b <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102658:	83 ec 08             	sub    $0x8,%esp
8010265b:	68 e0 00 00 00       	push   $0xe0
80102660:	68 f6 01 00 00       	push   $0x1f6
80102665:	e8 ce fe ff ff       	call   80102538 <outb>
8010266a:	83 c4 10             	add    $0x10,%esp
}
8010266d:	90                   	nop
8010266e:	c9                   	leave  
8010266f:	c3                   	ret    

80102670 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010267a:	75 0d                	jne    80102689 <idestart+0x19>
    panic("idestart");
8010267c:	83 ec 0c             	sub    $0xc,%esp
8010267f:	68 60 82 10 80       	push   $0x80108260
80102684:	e8 dd de ff ff       	call   80100566 <panic>

  idewait(0);
80102689:	83 ec 0c             	sub    $0xc,%esp
8010268c:	6a 00                	push   $0x0
8010268e:	e8 ea fe ff ff       	call   8010257d <idewait>
80102693:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102696:	83 ec 08             	sub    $0x8,%esp
80102699:	6a 00                	push   $0x0
8010269b:	68 f6 03 00 00       	push   $0x3f6
801026a0:	e8 93 fe ff ff       	call   80102538 <outb>
801026a5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801026a8:	83 ec 08             	sub    $0x8,%esp
801026ab:	6a 01                	push   $0x1
801026ad:	68 f2 01 00 00       	push   $0x1f2
801026b2:	e8 81 fe ff ff       	call   80102538 <outb>
801026b7:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	8b 40 08             	mov    0x8(%eax),%eax
801026c0:	0f b6 c0             	movzbl %al,%eax
801026c3:	83 ec 08             	sub    $0x8,%esp
801026c6:	50                   	push   %eax
801026c7:	68 f3 01 00 00       	push   $0x1f3
801026cc:	e8 67 fe ff ff       	call   80102538 <outb>
801026d1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026d4:	8b 45 08             	mov    0x8(%ebp),%eax
801026d7:	8b 40 08             	mov    0x8(%eax),%eax
801026da:	c1 e8 08             	shr    $0x8,%eax
801026dd:	0f b6 c0             	movzbl %al,%eax
801026e0:	83 ec 08             	sub    $0x8,%esp
801026e3:	50                   	push   %eax
801026e4:	68 f4 01 00 00       	push   $0x1f4
801026e9:	e8 4a fe ff ff       	call   80102538 <outb>
801026ee:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026f1:	8b 45 08             	mov    0x8(%ebp),%eax
801026f4:	8b 40 08             	mov    0x8(%eax),%eax
801026f7:	c1 e8 10             	shr    $0x10,%eax
801026fa:	0f b6 c0             	movzbl %al,%eax
801026fd:	83 ec 08             	sub    $0x8,%esp
80102700:	50                   	push   %eax
80102701:	68 f5 01 00 00       	push   $0x1f5
80102706:	e8 2d fe ff ff       	call   80102538 <outb>
8010270b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010270e:	8b 45 08             	mov    0x8(%ebp),%eax
80102711:	8b 40 04             	mov    0x4(%eax),%eax
80102714:	83 e0 01             	and    $0x1,%eax
80102717:	c1 e0 04             	shl    $0x4,%eax
8010271a:	89 c2                	mov    %eax,%edx
8010271c:	8b 45 08             	mov    0x8(%ebp),%eax
8010271f:	8b 40 08             	mov    0x8(%eax),%eax
80102722:	c1 e8 18             	shr    $0x18,%eax
80102725:	83 e0 0f             	and    $0xf,%eax
80102728:	09 d0                	or     %edx,%eax
8010272a:	83 c8 e0             	or     $0xffffffe0,%eax
8010272d:	0f b6 c0             	movzbl %al,%eax
80102730:	83 ec 08             	sub    $0x8,%esp
80102733:	50                   	push   %eax
80102734:	68 f6 01 00 00       	push   $0x1f6
80102739:	e8 fa fd ff ff       	call   80102538 <outb>
8010273e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102741:	8b 45 08             	mov    0x8(%ebp),%eax
80102744:	8b 00                	mov    (%eax),%eax
80102746:	83 e0 04             	and    $0x4,%eax
80102749:	85 c0                	test   %eax,%eax
8010274b:	74 30                	je     8010277d <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
8010274d:	83 ec 08             	sub    $0x8,%esp
80102750:	6a 30                	push   $0x30
80102752:	68 f7 01 00 00       	push   $0x1f7
80102757:	e8 dc fd ff ff       	call   80102538 <outb>
8010275c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
8010275f:	8b 45 08             	mov    0x8(%ebp),%eax
80102762:	83 c0 18             	add    $0x18,%eax
80102765:	83 ec 04             	sub    $0x4,%esp
80102768:	68 80 00 00 00       	push   $0x80
8010276d:	50                   	push   %eax
8010276e:	68 f0 01 00 00       	push   $0x1f0
80102773:	e8 df fd ff ff       	call   80102557 <outsl>
80102778:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
8010277b:	eb 12                	jmp    8010278f <idestart+0x11f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010277d:	83 ec 08             	sub    $0x8,%esp
80102780:	6a 20                	push   $0x20
80102782:	68 f7 01 00 00       	push   $0x1f7
80102787:	e8 ac fd ff ff       	call   80102538 <outb>
8010278c:	83 c4 10             	add    $0x10,%esp
  }
}
8010278f:	90                   	nop
80102790:	c9                   	leave  
80102791:	c3                   	ret    

80102792 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102792:	55                   	push   %ebp
80102793:	89 e5                	mov    %esp,%ebp
80102795:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102798:	83 ec 0c             	sub    $0xc,%esp
8010279b:	68 00 b6 10 80       	push   $0x8010b600
801027a0:	e8 83 24 00 00       	call   80104c28 <acquire>
801027a5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027a8:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027b4:	75 15                	jne    801027cb <ideintr+0x39>
    release(&idelock);
801027b6:	83 ec 0c             	sub    $0xc,%esp
801027b9:	68 00 b6 10 80       	push   $0x8010b600
801027be:	e8 cc 24 00 00       	call   80104c8f <release>
801027c3:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027c6:	e9 9a 00 00 00       	jmp    80102865 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ce:	8b 40 14             	mov    0x14(%eax),%eax
801027d1:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d9:	8b 00                	mov    (%eax),%eax
801027db:	83 e0 04             	and    $0x4,%eax
801027de:	85 c0                	test   %eax,%eax
801027e0:	75 2d                	jne    8010280f <ideintr+0x7d>
801027e2:	83 ec 0c             	sub    $0xc,%esp
801027e5:	6a 01                	push   $0x1
801027e7:	e8 91 fd ff ff       	call   8010257d <idewait>
801027ec:	83 c4 10             	add    $0x10,%esp
801027ef:	85 c0                	test   %eax,%eax
801027f1:	78 1c                	js     8010280f <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f6:	83 c0 18             	add    $0x18,%eax
801027f9:	83 ec 04             	sub    $0x4,%esp
801027fc:	68 80 00 00 00       	push   $0x80
80102801:	50                   	push   %eax
80102802:	68 f0 01 00 00       	push   $0x1f0
80102807:	e8 06 fd ff ff       	call   80102512 <insl>
8010280c:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102812:	8b 00                	mov    (%eax),%eax
80102814:	83 c8 02             	or     $0x2,%eax
80102817:	89 c2                	mov    %eax,%edx
80102819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010281c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102821:	8b 00                	mov    (%eax),%eax
80102823:	83 e0 fb             	and    $0xfffffffb,%eax
80102826:	89 c2                	mov    %eax,%edx
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010282d:	83 ec 0c             	sub    $0xc,%esp
80102830:	ff 75 f4             	pushl  -0xc(%ebp)
80102833:	e8 89 21 00 00       	call   801049c1 <wakeup>
80102838:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010283b:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102840:	85 c0                	test   %eax,%eax
80102842:	74 11                	je     80102855 <ideintr+0xc3>
    idestart(idequeue);
80102844:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102849:	83 ec 0c             	sub    $0xc,%esp
8010284c:	50                   	push   %eax
8010284d:	e8 1e fe ff ff       	call   80102670 <idestart>
80102852:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102855:	83 ec 0c             	sub    $0xc,%esp
80102858:	68 00 b6 10 80       	push   $0x8010b600
8010285d:	e8 2d 24 00 00       	call   80104c8f <release>
80102862:	83 c4 10             	add    $0x10,%esp
}
80102865:	c9                   	leave  
80102866:	c3                   	ret    

80102867 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102867:	55                   	push   %ebp
80102868:	89 e5                	mov    %esp,%ebp
8010286a:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010286d:	8b 45 08             	mov    0x8(%ebp),%eax
80102870:	8b 00                	mov    (%eax),%eax
80102872:	83 e0 01             	and    $0x1,%eax
80102875:	85 c0                	test   %eax,%eax
80102877:	75 0d                	jne    80102886 <iderw+0x1f>
    panic("iderw: buf not busy");
80102879:	83 ec 0c             	sub    $0xc,%esp
8010287c:	68 69 82 10 80       	push   $0x80108269
80102881:	e8 e0 dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102886:	8b 45 08             	mov    0x8(%ebp),%eax
80102889:	8b 00                	mov    (%eax),%eax
8010288b:	83 e0 06             	and    $0x6,%eax
8010288e:	83 f8 02             	cmp    $0x2,%eax
80102891:	75 0d                	jne    801028a0 <iderw+0x39>
    panic("iderw: nothing to do");
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	68 7d 82 10 80       	push   $0x8010827d
8010289b:	e8 c6 dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801028a0:	8b 45 08             	mov    0x8(%ebp),%eax
801028a3:	8b 40 04             	mov    0x4(%eax),%eax
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 16                	je     801028c0 <iderw+0x59>
801028aa:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801028af:	85 c0                	test   %eax,%eax
801028b1:	75 0d                	jne    801028c0 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028b3:	83 ec 0c             	sub    $0xc,%esp
801028b6:	68 92 82 10 80       	push   $0x80108292
801028bb:	e8 a6 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	68 00 b6 10 80       	push   $0x8010b600
801028c8:	e8 5b 23 00 00       	call   80104c28 <acquire>
801028cd:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028d0:	8b 45 08             	mov    0x8(%ebp),%eax
801028d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028da:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801028e1:	eb 0b                	jmp    801028ee <iderw+0x87>
801028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e6:	8b 00                	mov    (%eax),%eax
801028e8:	83 c0 14             	add    $0x14,%eax
801028eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f1:	8b 00                	mov    (%eax),%eax
801028f3:	85 c0                	test   %eax,%eax
801028f5:	75 ec                	jne    801028e3 <iderw+0x7c>
    ;
  *pp = b;
801028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fa:	8b 55 08             	mov    0x8(%ebp),%edx
801028fd:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028ff:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102904:	3b 45 08             	cmp    0x8(%ebp),%eax
80102907:	75 23                	jne    8010292c <iderw+0xc5>
    idestart(b);
80102909:	83 ec 0c             	sub    $0xc,%esp
8010290c:	ff 75 08             	pushl  0x8(%ebp)
8010290f:	e8 5c fd ff ff       	call   80102670 <idestart>
80102914:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102917:	eb 13                	jmp    8010292c <iderw+0xc5>
    sleep(b, &idelock);
80102919:	83 ec 08             	sub    $0x8,%esp
8010291c:	68 00 b6 10 80       	push   $0x8010b600
80102921:	ff 75 08             	pushl  0x8(%ebp)
80102924:	e8 ad 1f 00 00       	call   801048d6 <sleep>
80102929:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	8b 00                	mov    (%eax),%eax
80102931:	83 e0 06             	and    $0x6,%eax
80102934:	83 f8 02             	cmp    $0x2,%eax
80102937:	75 e0                	jne    80102919 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102939:	83 ec 0c             	sub    $0xc,%esp
8010293c:	68 00 b6 10 80       	push   $0x8010b600
80102941:	e8 49 23 00 00       	call   80104c8f <release>
80102946:	83 c4 10             	add    $0x10,%esp
}
80102949:	90                   	nop
8010294a:	c9                   	leave  
8010294b:	c3                   	ret    

8010294c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010294c:	55                   	push   %ebp
8010294d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010294f:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102954:	8b 55 08             	mov    0x8(%ebp),%edx
80102957:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102959:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010295e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102961:	5d                   	pop    %ebp
80102962:	c3                   	ret    

80102963 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102963:	55                   	push   %ebp
80102964:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102966:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010296b:	8b 55 08             	mov    0x8(%ebp),%edx
8010296e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102970:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102975:	8b 55 0c             	mov    0xc(%ebp),%edx
80102978:	89 50 10             	mov    %edx,0x10(%eax)
}
8010297b:	90                   	nop
8010297c:	5d                   	pop    %ebp
8010297d:	c3                   	ret    

8010297e <ioapicinit>:

void
ioapicinit(void)
{
8010297e:	55                   	push   %ebp
8010297f:	89 e5                	mov    %esp,%ebp
80102981:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102984:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102989:	85 c0                	test   %eax,%eax
8010298b:	0f 84 a0 00 00 00    	je     80102a31 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102991:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
80102998:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010299b:	6a 01                	push   $0x1
8010299d:	e8 aa ff ff ff       	call   8010294c <ioapicread>
801029a2:	83 c4 04             	add    $0x4,%esp
801029a5:	c1 e8 10             	shr    $0x10,%eax
801029a8:	25 ff 00 00 00       	and    $0xff,%eax
801029ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029b0:	6a 00                	push   $0x0
801029b2:	e8 95 ff ff ff       	call   8010294c <ioapicread>
801029b7:	83 c4 04             	add    $0x4,%esp
801029ba:	c1 e8 18             	shr    $0x18,%eax
801029bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029c0:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
801029c7:	0f b6 c0             	movzbl %al,%eax
801029ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029cd:	74 10                	je     801029df <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029cf:	83 ec 0c             	sub    $0xc,%esp
801029d2:	68 b0 82 10 80       	push   $0x801082b0
801029d7:	e8 ea d9 ff ff       	call   801003c6 <cprintf>
801029dc:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029e6:	eb 3f                	jmp    80102a27 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029eb:	83 c0 20             	add    $0x20,%eax
801029ee:	0d 00 00 01 00       	or     $0x10000,%eax
801029f3:	89 c2                	mov    %eax,%edx
801029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f8:	83 c0 08             	add    $0x8,%eax
801029fb:	01 c0                	add    %eax,%eax
801029fd:	83 ec 08             	sub    $0x8,%esp
80102a00:	52                   	push   %edx
80102a01:	50                   	push   %eax
80102a02:	e8 5c ff ff ff       	call   80102963 <ioapicwrite>
80102a07:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a0d:	83 c0 08             	add    $0x8,%eax
80102a10:	01 c0                	add    %eax,%eax
80102a12:	83 c0 01             	add    $0x1,%eax
80102a15:	83 ec 08             	sub    $0x8,%esp
80102a18:	6a 00                	push   $0x0
80102a1a:	50                   	push   %eax
80102a1b:	e8 43 ff ff ff       	call   80102963 <ioapicwrite>
80102a20:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a2d:	7e b9                	jle    801029e8 <ioapicinit+0x6a>
80102a2f:	eb 01                	jmp    80102a32 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a31:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a32:	c9                   	leave  
80102a33:	c3                   	ret    

80102a34 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a37:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102a3c:	85 c0                	test   %eax,%eax
80102a3e:	74 39                	je     80102a79 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	83 c0 20             	add    $0x20,%eax
80102a46:	89 c2                	mov    %eax,%edx
80102a48:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4b:	83 c0 08             	add    $0x8,%eax
80102a4e:	01 c0                	add    %eax,%eax
80102a50:	52                   	push   %edx
80102a51:	50                   	push   %eax
80102a52:	e8 0c ff ff ff       	call   80102963 <ioapicwrite>
80102a57:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a5d:	c1 e0 18             	shl    $0x18,%eax
80102a60:	89 c2                	mov    %eax,%edx
80102a62:	8b 45 08             	mov    0x8(%ebp),%eax
80102a65:	83 c0 08             	add    $0x8,%eax
80102a68:	01 c0                	add    %eax,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	52                   	push   %edx
80102a6e:	50                   	push   %eax
80102a6f:	e8 ef fe ff ff       	call   80102963 <ioapicwrite>
80102a74:	83 c4 08             	add    $0x8,%esp
80102a77:	eb 01                	jmp    80102a7a <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a79:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a7a:	c9                   	leave  
80102a7b:	c3                   	ret    

80102a7c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a7c:	55                   	push   %ebp
80102a7d:	89 e5                	mov    %esp,%ebp
80102a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a82:	05 00 00 00 80       	add    $0x80000000,%eax
80102a87:	5d                   	pop    %ebp
80102a88:	c3                   	ret    

80102a89 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a89:	55                   	push   %ebp
80102a8a:	89 e5                	mov    %esp,%ebp
80102a8c:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a8f:	83 ec 08             	sub    $0x8,%esp
80102a92:	68 e2 82 10 80       	push   $0x801082e2
80102a97:	68 40 f8 10 80       	push   $0x8010f840
80102a9c:	e8 65 21 00 00       	call   80104c06 <initlock>
80102aa1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa4:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102aab:	00 00 00 
  freerange(vstart, vend);
80102aae:	83 ec 08             	sub    $0x8,%esp
80102ab1:	ff 75 0c             	pushl  0xc(%ebp)
80102ab4:	ff 75 08             	pushl  0x8(%ebp)
80102ab7:	e8 2a 00 00 00       	call   80102ae6 <freerange>
80102abc:	83 c4 10             	add    $0x10,%esp
}
80102abf:	90                   	nop
80102ac0:	c9                   	leave  
80102ac1:	c3                   	ret    

80102ac2 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ac2:	55                   	push   %ebp
80102ac3:	89 e5                	mov    %esp,%ebp
80102ac5:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ac8:	83 ec 08             	sub    $0x8,%esp
80102acb:	ff 75 0c             	pushl  0xc(%ebp)
80102ace:	ff 75 08             	pushl  0x8(%ebp)
80102ad1:	e8 10 00 00 00       	call   80102ae6 <freerange>
80102ad6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ad9:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102ae0:	00 00 00 
}
80102ae3:	90                   	nop
80102ae4:	c9                   	leave  
80102ae5:	c3                   	ret    

80102ae6 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ae6:	55                   	push   %ebp
80102ae7:	89 e5                	mov    %esp,%ebp
80102ae9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aec:	8b 45 08             	mov    0x8(%ebp),%eax
80102aef:	05 ff 0f 00 00       	add    $0xfff,%eax
80102af4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afc:	eb 15                	jmp    80102b13 <freerange+0x2d>
    kfree(p);
80102afe:	83 ec 0c             	sub    $0xc,%esp
80102b01:	ff 75 f4             	pushl  -0xc(%ebp)
80102b04:	e8 1a 00 00 00       	call   80102b23 <kfree>
80102b09:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b16:	05 00 10 00 00       	add    $0x1000,%eax
80102b1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b1e:	76 de                	jbe    80102afe <freerange+0x18>
    kfree(p);
}
80102b20:	90                   	nop
80102b21:	c9                   	leave  
80102b22:	c3                   	ret    

80102b23 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b23:	55                   	push   %ebp
80102b24:	89 e5                	mov    %esp,%ebp
80102b26:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b29:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b31:	85 c0                	test   %eax,%eax
80102b33:	75 1b                	jne    80102b50 <kfree+0x2d>
80102b35:	81 7d 08 00 27 11 80 	cmpl   $0x80112700,0x8(%ebp)
80102b3c:	72 12                	jb     80102b50 <kfree+0x2d>
80102b3e:	ff 75 08             	pushl  0x8(%ebp)
80102b41:	e8 36 ff ff ff       	call   80102a7c <v2p>
80102b46:	83 c4 04             	add    $0x4,%esp
80102b49:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b4e:	76 0d                	jbe    80102b5d <kfree+0x3a>
    panic("kfree");
80102b50:	83 ec 0c             	sub    $0xc,%esp
80102b53:	68 e7 82 10 80       	push   $0x801082e7
80102b58:	e8 09 da ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b5d:	83 ec 04             	sub    $0x4,%esp
80102b60:	68 00 10 00 00       	push   $0x1000
80102b65:	6a 01                	push   $0x1
80102b67:	ff 75 08             	pushl  0x8(%ebp)
80102b6a:	e8 1c 23 00 00       	call   80104e8b <memset>
80102b6f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b72:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b77:	85 c0                	test   %eax,%eax
80102b79:	74 10                	je     80102b8b <kfree+0x68>
    acquire(&kmem.lock);
80102b7b:	83 ec 0c             	sub    $0xc,%esp
80102b7e:	68 40 f8 10 80       	push   $0x8010f840
80102b83:	e8 a0 20 00 00       	call   80104c28 <acquire>
80102b88:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b91:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9f:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102ba4:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ba9:	85 c0                	test   %eax,%eax
80102bab:	74 10                	je     80102bbd <kfree+0x9a>
    release(&kmem.lock);
80102bad:	83 ec 0c             	sub    $0xc,%esp
80102bb0:	68 40 f8 10 80       	push   $0x8010f840
80102bb5:	e8 d5 20 00 00       	call   80104c8f <release>
80102bba:	83 c4 10             	add    $0x10,%esp
}
80102bbd:	90                   	nop
80102bbe:	c9                   	leave  
80102bbf:	c3                   	ret    

80102bc0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102bc6:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102bcb:	85 c0                	test   %eax,%eax
80102bcd:	74 10                	je     80102bdf <kalloc+0x1f>
    acquire(&kmem.lock);
80102bcf:	83 ec 0c             	sub    $0xc,%esp
80102bd2:	68 40 f8 10 80       	push   $0x8010f840
80102bd7:	e8 4c 20 00 00       	call   80104c28 <acquire>
80102bdc:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102bdf:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102beb:	74 0a                	je     80102bf7 <kalloc+0x37>
    kmem.freelist = r->next;
80102bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf0:	8b 00                	mov    (%eax),%eax
80102bf2:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102bf7:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102bfc:	85 c0                	test   %eax,%eax
80102bfe:	74 10                	je     80102c10 <kalloc+0x50>
    release(&kmem.lock);
80102c00:	83 ec 0c             	sub    $0xc,%esp
80102c03:	68 40 f8 10 80       	push   $0x8010f840
80102c08:	e8 82 20 00 00       	call   80104c8f <release>
80102c0d:	83 c4 10             	add    $0x10,%esp

  // By ShaunFong
  // plus 1 every running
  no_of_alloc++;
80102c10:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102c15:	83 c0 01             	add    $0x1,%eax
80102c18:	a3 fc 26 11 80       	mov    %eax,0x801126fc
  return (char*)r;
80102c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c20:	c9                   	leave  
80102c21:	c3                   	ret    

80102c22 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c22:	55                   	push   %ebp
80102c23:	89 e5                	mov    %esp,%ebp
80102c25:	83 ec 14             	sub    $0x14,%esp
80102c28:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c33:	89 c2                	mov    %eax,%edx
80102c35:	ec                   	in     (%dx),%al
80102c36:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c39:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c3d:	c9                   	leave  
80102c3e:	c3                   	ret    

80102c3f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c3f:	55                   	push   %ebp
80102c40:	89 e5                	mov    %esp,%ebp
80102c42:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c45:	6a 64                	push   $0x64
80102c47:	e8 d6 ff ff ff       	call   80102c22 <inb>
80102c4c:	83 c4 04             	add    $0x4,%esp
80102c4f:	0f b6 c0             	movzbl %al,%eax
80102c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	83 e0 01             	and    $0x1,%eax
80102c5b:	85 c0                	test   %eax,%eax
80102c5d:	75 0a                	jne    80102c69 <kbdgetc+0x2a>
    return -1;
80102c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c64:	e9 23 01 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c69:	6a 60                	push   $0x60
80102c6b:	e8 b2 ff ff ff       	call   80102c22 <inb>
80102c70:	83 c4 04             	add    $0x4,%esp
80102c73:	0f b6 c0             	movzbl %al,%eax
80102c76:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c79:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c80:	75 17                	jne    80102c99 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c82:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c87:	83 c8 40             	or     $0x40,%eax
80102c8a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c8f:	b8 00 00 00 00       	mov    $0x0,%eax
80102c94:	e9 f3 00 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9c:	25 80 00 00 00       	and    $0x80,%eax
80102ca1:	85 c0                	test   %eax,%eax
80102ca3:	74 45                	je     80102cea <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ca5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102caa:	83 e0 40             	and    $0x40,%eax
80102cad:	85 c0                	test   %eax,%eax
80102caf:	75 08                	jne    80102cb9 <kbdgetc+0x7a>
80102cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb4:	83 e0 7f             	and    $0x7f,%eax
80102cb7:	eb 03                	jmp    80102cbc <kbdgetc+0x7d>
80102cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc2:	05 20 90 10 80       	add    $0x80109020,%eax
80102cc7:	0f b6 00             	movzbl (%eax),%eax
80102cca:	83 c8 40             	or     $0x40,%eax
80102ccd:	0f b6 c0             	movzbl %al,%eax
80102cd0:	f7 d0                	not    %eax
80102cd2:	89 c2                	mov    %eax,%edx
80102cd4:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cd9:	21 d0                	and    %edx,%eax
80102cdb:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80102ce5:	e9 a2 00 00 00       	jmp    80102d8c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102cea:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cef:	83 e0 40             	and    $0x40,%eax
80102cf2:	85 c0                	test   %eax,%eax
80102cf4:	74 14                	je     80102d0a <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cf6:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cfd:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d02:	83 e0 bf             	and    $0xffffffbf,%eax
80102d05:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0d:	05 20 90 10 80       	add    $0x80109020,%eax
80102d12:	0f b6 00             	movzbl (%eax),%eax
80102d15:	0f b6 d0             	movzbl %al,%edx
80102d18:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d1d:	09 d0                	or     %edx,%eax
80102d1f:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d27:	05 20 91 10 80       	add    $0x80109120,%eax
80102d2c:	0f b6 00             	movzbl (%eax),%eax
80102d2f:	0f b6 d0             	movzbl %al,%edx
80102d32:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d37:	31 d0                	xor    %edx,%eax
80102d39:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d3e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d43:	83 e0 03             	and    $0x3,%eax
80102d46:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d50:	01 d0                	add    %edx,%eax
80102d52:	0f b6 00             	movzbl (%eax),%eax
80102d55:	0f b6 c0             	movzbl %al,%eax
80102d58:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d5b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d60:	83 e0 08             	and    $0x8,%eax
80102d63:	85 c0                	test   %eax,%eax
80102d65:	74 22                	je     80102d89 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d67:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d6b:	76 0c                	jbe    80102d79 <kbdgetc+0x13a>
80102d6d:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d71:	77 06                	ja     80102d79 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d73:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d77:	eb 10                	jmp    80102d89 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d79:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d7d:	76 0a                	jbe    80102d89 <kbdgetc+0x14a>
80102d7f:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d83:	77 04                	ja     80102d89 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d85:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d8c:	c9                   	leave  
80102d8d:	c3                   	ret    

80102d8e <kbdintr>:

void
kbdintr(void)
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d94:	83 ec 0c             	sub    $0xc,%esp
80102d97:	68 3f 2c 10 80       	push   $0x80102c3f
80102d9c:	e8 3c da ff ff       	call   801007dd <consoleintr>
80102da1:	83 c4 10             	add    $0x10,%esp
}
80102da4:	90                   	nop
80102da5:	c9                   	leave  
80102da6:	c3                   	ret    

80102da7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102da7:	55                   	push   %ebp
80102da8:	89 e5                	mov    %esp,%ebp
80102daa:	83 ec 08             	sub    $0x8,%esp
80102dad:	8b 55 08             	mov    0x8(%ebp),%edx
80102db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102db3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102db7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dba:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dbe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dc2:	ee                   	out    %al,(%dx)
}
80102dc3:	90                   	nop
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    

80102dc6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102dc6:	55                   	push   %ebp
80102dc7:	89 e5                	mov    %esp,%ebp
80102dc9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102dcc:	9c                   	pushf  
80102dcd:	58                   	pop    %eax
80102dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    

80102dd6 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102dd6:	55                   	push   %ebp
80102dd7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dd9:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102dde:	8b 55 08             	mov    0x8(%ebp),%edx
80102de1:	c1 e2 02             	shl    $0x2,%edx
80102de4:	01 c2                	add    %eax,%edx
80102de6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102de9:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102deb:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102df0:	83 c0 20             	add    $0x20,%eax
80102df3:	8b 00                	mov    (%eax),%eax
}
80102df5:	90                   	nop
80102df6:	5d                   	pop    %ebp
80102df7:	c3                   	ret    

80102df8 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102df8:	55                   	push   %ebp
80102df9:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102dfb:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e00:	85 c0                	test   %eax,%eax
80102e02:	0f 84 0b 01 00 00    	je     80102f13 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e08:	68 3f 01 00 00       	push   $0x13f
80102e0d:	6a 3c                	push   $0x3c
80102e0f:	e8 c2 ff ff ff       	call   80102dd6 <lapicw>
80102e14:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e17:	6a 0b                	push   $0xb
80102e19:	68 f8 00 00 00       	push   $0xf8
80102e1e:	e8 b3 ff ff ff       	call   80102dd6 <lapicw>
80102e23:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e26:	68 20 00 02 00       	push   $0x20020
80102e2b:	68 c8 00 00 00       	push   $0xc8
80102e30:	e8 a1 ff ff ff       	call   80102dd6 <lapicw>
80102e35:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e38:	68 80 96 98 00       	push   $0x989680
80102e3d:	68 e0 00 00 00       	push   $0xe0
80102e42:	e8 8f ff ff ff       	call   80102dd6 <lapicw>
80102e47:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e4a:	68 00 00 01 00       	push   $0x10000
80102e4f:	68 d4 00 00 00       	push   $0xd4
80102e54:	e8 7d ff ff ff       	call   80102dd6 <lapicw>
80102e59:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102e5c:	68 00 00 01 00       	push   $0x10000
80102e61:	68 d8 00 00 00       	push   $0xd8
80102e66:	e8 6b ff ff ff       	call   80102dd6 <lapicw>
80102e6b:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e6e:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e73:	83 c0 30             	add    $0x30,%eax
80102e76:	8b 00                	mov    (%eax),%eax
80102e78:	c1 e8 10             	shr    $0x10,%eax
80102e7b:	0f b6 c0             	movzbl %al,%eax
80102e7e:	83 f8 03             	cmp    $0x3,%eax
80102e81:	76 12                	jbe    80102e95 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102e83:	68 00 00 01 00       	push   $0x10000
80102e88:	68 d0 00 00 00       	push   $0xd0
80102e8d:	e8 44 ff ff ff       	call   80102dd6 <lapicw>
80102e92:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e95:	6a 33                	push   $0x33
80102e97:	68 dc 00 00 00       	push   $0xdc
80102e9c:	e8 35 ff ff ff       	call   80102dd6 <lapicw>
80102ea1:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ea4:	6a 00                	push   $0x0
80102ea6:	68 a0 00 00 00       	push   $0xa0
80102eab:	e8 26 ff ff ff       	call   80102dd6 <lapicw>
80102eb0:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102eb3:	6a 00                	push   $0x0
80102eb5:	68 a0 00 00 00       	push   $0xa0
80102eba:	e8 17 ff ff ff       	call   80102dd6 <lapicw>
80102ebf:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ec2:	6a 00                	push   $0x0
80102ec4:	6a 2c                	push   $0x2c
80102ec6:	e8 0b ff ff ff       	call   80102dd6 <lapicw>
80102ecb:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ece:	6a 00                	push   $0x0
80102ed0:	68 c4 00 00 00       	push   $0xc4
80102ed5:	e8 fc fe ff ff       	call   80102dd6 <lapicw>
80102eda:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102edd:	68 00 85 08 00       	push   $0x88500
80102ee2:	68 c0 00 00 00       	push   $0xc0
80102ee7:	e8 ea fe ff ff       	call   80102dd6 <lapicw>
80102eec:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102eef:	90                   	nop
80102ef0:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ef5:	05 00 03 00 00       	add    $0x300,%eax
80102efa:	8b 00                	mov    (%eax),%eax
80102efc:	25 00 10 00 00       	and    $0x1000,%eax
80102f01:	85 c0                	test   %eax,%eax
80102f03:	75 eb                	jne    80102ef0 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f05:	6a 00                	push   $0x0
80102f07:	6a 20                	push   $0x20
80102f09:	e8 c8 fe ff ff       	call   80102dd6 <lapicw>
80102f0e:	83 c4 08             	add    $0x8,%esp
80102f11:	eb 01                	jmp    80102f14 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f13:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f14:	c9                   	leave  
80102f15:	c3                   	ret    

80102f16 <cpunum>:

int
cpunum(void)
{
80102f16:	55                   	push   %ebp
80102f17:	89 e5                	mov    %esp,%ebp
80102f19:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f1c:	e8 a5 fe ff ff       	call   80102dc6 <readeflags>
80102f21:	25 00 02 00 00       	and    $0x200,%eax
80102f26:	85 c0                	test   %eax,%eax
80102f28:	74 26                	je     80102f50 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f2a:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f2f:	8d 50 01             	lea    0x1(%eax),%edx
80102f32:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102f38:	85 c0                	test   %eax,%eax
80102f3a:	75 14                	jne    80102f50 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f3c:	8b 45 04             	mov    0x4(%ebp),%eax
80102f3f:	83 ec 08             	sub    $0x8,%esp
80102f42:	50                   	push   %eax
80102f43:	68 f0 82 10 80       	push   $0x801082f0
80102f48:	e8 79 d4 ff ff       	call   801003c6 <cprintf>
80102f4d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102f50:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f55:	85 c0                	test   %eax,%eax
80102f57:	74 0f                	je     80102f68 <cpunum+0x52>
    return lapic[ID]>>24;
80102f59:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f5e:	83 c0 20             	add    $0x20,%eax
80102f61:	8b 00                	mov    (%eax),%eax
80102f63:	c1 e8 18             	shr    $0x18,%eax
80102f66:	eb 05                	jmp    80102f6d <cpunum+0x57>
  return 0;
80102f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f6d:	c9                   	leave  
80102f6e:	c3                   	ret    

80102f6f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f6f:	55                   	push   %ebp
80102f70:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f72:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f77:	85 c0                	test   %eax,%eax
80102f79:	74 0c                	je     80102f87 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f7b:	6a 00                	push   $0x0
80102f7d:	6a 2c                	push   $0x2c
80102f7f:	e8 52 fe ff ff       	call   80102dd6 <lapicw>
80102f84:	83 c4 08             	add    $0x8,%esp
}
80102f87:	90                   	nop
80102f88:	c9                   	leave  
80102f89:	c3                   	ret    

80102f8a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f8a:	55                   	push   %ebp
80102f8b:	89 e5                	mov    %esp,%ebp
}
80102f8d:	90                   	nop
80102f8e:	5d                   	pop    %ebp
80102f8f:	c3                   	ret    

80102f90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	83 ec 14             	sub    $0x14,%esp
80102f96:	8b 45 08             	mov    0x8(%ebp),%eax
80102f99:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f9c:	6a 0f                	push   $0xf
80102f9e:	6a 70                	push   $0x70
80102fa0:	e8 02 fe ff ff       	call   80102da7 <outb>
80102fa5:	83 c4 08             	add    $0x8,%esp
  outb(IO_RTC+1, 0x0A);
80102fa8:	6a 0a                	push   $0xa
80102faa:	6a 71                	push   $0x71
80102fac:	e8 f6 fd ff ff       	call   80102da7 <outb>
80102fb1:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fb4:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fbe:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc6:	83 c0 02             	add    $0x2,%eax
80102fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102fcc:	c1 ea 04             	shr    $0x4,%edx
80102fcf:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fd2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd6:	c1 e0 18             	shl    $0x18,%eax
80102fd9:	50                   	push   %eax
80102fda:	68 c4 00 00 00       	push   $0xc4
80102fdf:	e8 f2 fd ff ff       	call   80102dd6 <lapicw>
80102fe4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fe7:	68 00 c5 00 00       	push   $0xc500
80102fec:	68 c0 00 00 00       	push   $0xc0
80102ff1:	e8 e0 fd ff ff       	call   80102dd6 <lapicw>
80102ff6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102ff9:	68 c8 00 00 00       	push   $0xc8
80102ffe:	e8 87 ff ff ff       	call   80102f8a <microdelay>
80103003:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103006:	68 00 85 00 00       	push   $0x8500
8010300b:	68 c0 00 00 00       	push   $0xc0
80103010:	e8 c1 fd ff ff       	call   80102dd6 <lapicw>
80103015:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103018:	6a 64                	push   $0x64
8010301a:	e8 6b ff ff ff       	call   80102f8a <microdelay>
8010301f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103029:	eb 3d                	jmp    80103068 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010302b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010302f:	c1 e0 18             	shl    $0x18,%eax
80103032:	50                   	push   %eax
80103033:	68 c4 00 00 00       	push   $0xc4
80103038:	e8 99 fd ff ff       	call   80102dd6 <lapicw>
8010303d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103040:	8b 45 0c             	mov    0xc(%ebp),%eax
80103043:	c1 e8 0c             	shr    $0xc,%eax
80103046:	80 cc 06             	or     $0x6,%ah
80103049:	50                   	push   %eax
8010304a:	68 c0 00 00 00       	push   $0xc0
8010304f:	e8 82 fd ff ff       	call   80102dd6 <lapicw>
80103054:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103057:	68 c8 00 00 00       	push   $0xc8
8010305c:	e8 29 ff ff ff       	call   80102f8a <microdelay>
80103061:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103064:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103068:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010306c:	7e bd                	jle    8010302b <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010306e:	90                   	nop
8010306f:	c9                   	leave  
80103070:	c3                   	ret    

80103071 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103071:	55                   	push   %ebp
80103072:	89 e5                	mov    %esp,%ebp
80103074:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103077:	83 ec 08             	sub    $0x8,%esp
8010307a:	68 1c 83 10 80       	push   $0x8010831c
8010307f:	68 80 f8 10 80       	push   $0x8010f880
80103084:	e8 7d 1b 00 00       	call   80104c06 <initlock>
80103089:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
8010308c:	83 ec 08             	sub    $0x8,%esp
8010308f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103092:	50                   	push   %eax
80103093:	6a 01                	push   $0x1
80103095:	e8 ca e2 ff ff       	call   80101364 <readsb>
8010309a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
8010309d:	8b 55 e8             	mov    -0x18(%ebp),%edx
801030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030a3:	29 c2                	sub    %eax,%edx
801030a5:	89 d0                	mov    %edx,%eax
801030a7:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
801030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030af:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
801030b4:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
801030bb:	00 00 00 
  recover_from_log();
801030be:	e8 b2 01 00 00       	call   80103275 <recover_from_log>
}
801030c3:	90                   	nop
801030c4:	c9                   	leave  
801030c5:	c3                   	ret    

801030c6 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801030c6:	55                   	push   %ebp
801030c7:	89 e5                	mov    %esp,%ebp
801030c9:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801030d3:	e9 95 00 00 00       	jmp    8010316d <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030d8:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
801030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030e1:	01 d0                	add    %edx,%eax
801030e3:	83 c0 01             	add    $0x1,%eax
801030e6:	89 c2                	mov    %eax,%edx
801030e8:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ed:	83 ec 08             	sub    $0x8,%esp
801030f0:	52                   	push   %edx
801030f1:	50                   	push   %eax
801030f2:	e8 bf d0 ff ff       	call   801001b6 <bread>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103100:	83 c0 10             	add    $0x10,%eax
80103103:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103111:	83 ec 08             	sub    $0x8,%esp
80103114:	52                   	push   %edx
80103115:	50                   	push   %eax
80103116:	e8 9b d0 ff ff       	call   801001b6 <bread>
8010311b:	83 c4 10             	add    $0x10,%esp
8010311e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103121:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103124:	8d 50 18             	lea    0x18(%eax),%edx
80103127:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010312a:	83 c0 18             	add    $0x18,%eax
8010312d:	83 ec 04             	sub    $0x4,%esp
80103130:	68 00 02 00 00       	push   $0x200
80103135:	52                   	push   %edx
80103136:	50                   	push   %eax
80103137:	e8 0e 1e 00 00       	call   80104f4a <memmove>
8010313c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010313f:	83 ec 0c             	sub    $0xc,%esp
80103142:	ff 75 ec             	pushl  -0x14(%ebp)
80103145:	e8 a5 d0 ff ff       	call   801001ef <bwrite>
8010314a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010314d:	83 ec 0c             	sub    $0xc,%esp
80103150:	ff 75 f0             	pushl  -0x10(%ebp)
80103153:	e8 d6 d0 ff ff       	call   8010022e <brelse>
80103158:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010315b:	83 ec 0c             	sub    $0xc,%esp
8010315e:	ff 75 ec             	pushl  -0x14(%ebp)
80103161:	e8 c8 d0 ff ff       	call   8010022e <brelse>
80103166:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103169:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010316d:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103172:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103175:	0f 8f 5d ff ff ff    	jg     801030d8 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010317b:	90                   	nop
8010317c:	c9                   	leave  
8010317d:	c3                   	ret    

8010317e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010317e:	55                   	push   %ebp
8010317f:	89 e5                	mov    %esp,%ebp
80103181:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103184:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103189:	89 c2                	mov    %eax,%edx
8010318b:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	52                   	push   %edx
80103194:	50                   	push   %eax
80103195:	e8 1c d0 ff ff       	call   801001b6 <bread>
8010319a:	83 c4 10             	add    $0x10,%esp
8010319d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a3:	83 c0 18             	add    $0x18,%eax
801031a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ac:	8b 00                	mov    (%eax),%eax
801031ae:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
801031b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031ba:	eb 1b                	jmp    801031d7 <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
801031bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031c2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801031c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031c9:	83 c2 10             	add    $0x10,%edx
801031cc:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801031d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031d7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031df:	7f db                	jg     801031bc <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801031e1:	83 ec 0c             	sub    $0xc,%esp
801031e4:	ff 75 f0             	pushl  -0x10(%ebp)
801031e7:	e8 42 d0 ff ff       	call   8010022e <brelse>
801031ec:	83 c4 10             	add    $0x10,%esp
}
801031ef:	90                   	nop
801031f0:	c9                   	leave  
801031f1:	c3                   	ret    

801031f2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031f2:	55                   	push   %ebp
801031f3:	89 e5                	mov    %esp,%ebp
801031f5:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801031f8:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801031fd:	89 c2                	mov    %eax,%edx
801031ff:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103204:	83 ec 08             	sub    $0x8,%esp
80103207:	52                   	push   %edx
80103208:	50                   	push   %eax
80103209:	e8 a8 cf ff ff       	call   801001b6 <bread>
8010320e:	83 c4 10             	add    $0x10,%esp
80103211:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103214:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103217:	83 c0 18             	add    $0x18,%eax
8010321a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010321d:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103223:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103226:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010322f:	eb 1b                	jmp    8010324c <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
80103231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103234:	83 c0 10             	add    $0x10,%eax
80103237:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
8010323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103241:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103244:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103248:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010324c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103251:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103254:	7f db                	jg     80103231 <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	ff 75 f0             	pushl  -0x10(%ebp)
8010325c:	e8 8e cf ff ff       	call   801001ef <bwrite>
80103261:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103264:	83 ec 0c             	sub    $0xc,%esp
80103267:	ff 75 f0             	pushl  -0x10(%ebp)
8010326a:	e8 bf cf ff ff       	call   8010022e <brelse>
8010326f:	83 c4 10             	add    $0x10,%esp
}
80103272:	90                   	nop
80103273:	c9                   	leave  
80103274:	c3                   	ret    

80103275 <recover_from_log>:

static void
recover_from_log(void)
{
80103275:	55                   	push   %ebp
80103276:	89 e5                	mov    %esp,%ebp
80103278:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010327b:	e8 fe fe ff ff       	call   8010317e <read_head>
  install_trans(); // if committed, copy from log to disk
80103280:	e8 41 fe ff ff       	call   801030c6 <install_trans>
  log.lh.n = 0;
80103285:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010328c:	00 00 00 
  write_head(); // clear the log
8010328f:	e8 5e ff ff ff       	call   801031f2 <write_head>
}
80103294:	90                   	nop
80103295:	c9                   	leave  
80103296:	c3                   	ret    

80103297 <begin_trans>:

void
begin_trans(void)
{
80103297:	55                   	push   %ebp
80103298:	89 e5                	mov    %esp,%ebp
8010329a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010329d:	83 ec 0c             	sub    $0xc,%esp
801032a0:	68 80 f8 10 80       	push   $0x8010f880
801032a5:	e8 7e 19 00 00       	call   80104c28 <acquire>
801032aa:	83 c4 10             	add    $0x10,%esp
  while (log.busy) {
801032ad:	eb 15                	jmp    801032c4 <begin_trans+0x2d>
    sleep(&log, &log.lock);
801032af:	83 ec 08             	sub    $0x8,%esp
801032b2:	68 80 f8 10 80       	push   $0x8010f880
801032b7:	68 80 f8 10 80       	push   $0x8010f880
801032bc:	e8 15 16 00 00       	call   801048d6 <sleep>
801032c1:	83 c4 10             	add    $0x10,%esp

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801032c4:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032c9:	85 c0                	test   %eax,%eax
801032cb:	75 e2                	jne    801032af <begin_trans+0x18>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
801032cd:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
801032d4:	00 00 00 
  release(&log.lock);
801032d7:	83 ec 0c             	sub    $0xc,%esp
801032da:	68 80 f8 10 80       	push   $0x8010f880
801032df:	e8 ab 19 00 00       	call   80104c8f <release>
801032e4:	83 c4 10             	add    $0x10,%esp
}
801032e7:	90                   	nop
801032e8:	c9                   	leave  
801032e9:	c3                   	ret    

801032ea <commit_trans>:

void
commit_trans(void)
{
801032ea:	55                   	push   %ebp
801032eb:	89 e5                	mov    %esp,%ebp
801032ed:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801032f0:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032f5:	85 c0                	test   %eax,%eax
801032f7:	7e 19                	jle    80103312 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
801032f9:	e8 f4 fe ff ff       	call   801031f2 <write_head>
    install_trans(); // Now install writes to home locations
801032fe:	e8 c3 fd ff ff       	call   801030c6 <install_trans>
    log.lh.n = 0; 
80103303:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010330a:	00 00 00 
    write_head();    // Erase the transaction from the log
8010330d:	e8 e0 fe ff ff       	call   801031f2 <write_head>
  }
  
  acquire(&log.lock);
80103312:	83 ec 0c             	sub    $0xc,%esp
80103315:	68 80 f8 10 80       	push   $0x8010f880
8010331a:	e8 09 19 00 00       	call   80104c28 <acquire>
8010331f:	83 c4 10             	add    $0x10,%esp
  log.busy = 0;
80103322:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103329:	00 00 00 
  wakeup(&log);
8010332c:	83 ec 0c             	sub    $0xc,%esp
8010332f:	68 80 f8 10 80       	push   $0x8010f880
80103334:	e8 88 16 00 00       	call   801049c1 <wakeup>
80103339:	83 c4 10             	add    $0x10,%esp
  release(&log.lock);
8010333c:	83 ec 0c             	sub    $0xc,%esp
8010333f:	68 80 f8 10 80       	push   $0x8010f880
80103344:	e8 46 19 00 00       	call   80104c8f <release>
80103349:	83 c4 10             	add    $0x10,%esp
}
8010334c:	90                   	nop
8010334d:	c9                   	leave  
8010334e:	c3                   	ret    

8010334f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010334f:	55                   	push   %ebp
80103350:	89 e5                	mov    %esp,%ebp
80103352:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103355:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010335a:	83 f8 09             	cmp    $0x9,%eax
8010335d:	7f 12                	jg     80103371 <log_write+0x22>
8010335f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103364:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
8010336a:	83 ea 01             	sub    $0x1,%edx
8010336d:	39 d0                	cmp    %edx,%eax
8010336f:	7c 0d                	jl     8010337e <log_write+0x2f>
    panic("too big a transaction");
80103371:	83 ec 0c             	sub    $0xc,%esp
80103374:	68 20 83 10 80       	push   $0x80108320
80103379:	e8 e8 d1 ff ff       	call   80100566 <panic>
  if (!log.busy)
8010337e:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103383:	85 c0                	test   %eax,%eax
80103385:	75 0d                	jne    80103394 <log_write+0x45>
    panic("write outside of trans");
80103387:	83 ec 0c             	sub    $0xc,%esp
8010338a:	68 36 83 10 80       	push   $0x80108336
8010338f:	e8 d2 d1 ff ff       	call   80100566 <panic>

  for (i = 0; i < log.lh.n; i++) {
80103394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010339b:	eb 1d                	jmp    801033ba <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033a0:	83 c0 10             	add    $0x10,%eax
801033a3:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801033aa:	89 c2                	mov    %eax,%edx
801033ac:	8b 45 08             	mov    0x8(%ebp),%eax
801033af:	8b 40 08             	mov    0x8(%eax),%eax
801033b2:	39 c2                	cmp    %eax,%edx
801033b4:	74 10                	je     801033c6 <log_write+0x77>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801033b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ba:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033c2:	7f d9                	jg     8010339d <log_write+0x4e>
801033c4:	eb 01                	jmp    801033c7 <log_write+0x78>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
801033c6:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801033c7:	8b 45 08             	mov    0x8(%ebp),%eax
801033ca:	8b 40 08             	mov    0x8(%eax),%eax
801033cd:	89 c2                	mov    %eax,%edx
801033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033d2:	83 c0 10             	add    $0x10,%eax
801033d5:	89 14 85 88 f8 10 80 	mov    %edx,-0x7fef0778(,%eax,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801033dc:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
801033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033e5:	01 d0                	add    %edx,%eax
801033e7:	83 c0 01             	add    $0x1,%eax
801033ea:	89 c2                	mov    %eax,%edx
801033ec:	8b 45 08             	mov    0x8(%ebp),%eax
801033ef:	8b 40 04             	mov    0x4(%eax),%eax
801033f2:	83 ec 08             	sub    $0x8,%esp
801033f5:	52                   	push   %edx
801033f6:	50                   	push   %eax
801033f7:	e8 ba cd ff ff       	call   801001b6 <bread>
801033fc:	83 c4 10             	add    $0x10,%esp
801033ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103402:	8b 45 08             	mov    0x8(%ebp),%eax
80103405:	8d 50 18             	lea    0x18(%eax),%edx
80103408:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010340b:	83 c0 18             	add    $0x18,%eax
8010340e:	83 ec 04             	sub    $0x4,%esp
80103411:	68 00 02 00 00       	push   $0x200
80103416:	52                   	push   %edx
80103417:	50                   	push   %eax
80103418:	e8 2d 1b 00 00       	call   80104f4a <memmove>
8010341d:	83 c4 10             	add    $0x10,%esp
  bwrite(lbuf);
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	ff 75 f0             	pushl  -0x10(%ebp)
80103426:	e8 c4 cd ff ff       	call   801001ef <bwrite>
8010342b:	83 c4 10             	add    $0x10,%esp
  brelse(lbuf);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	ff 75 f0             	pushl  -0x10(%ebp)
80103434:	e8 f5 cd ff ff       	call   8010022e <brelse>
80103439:	83 c4 10             	add    $0x10,%esp
  if (i == log.lh.n)
8010343c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103441:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103444:	75 0d                	jne    80103453 <log_write+0x104>
    log.lh.n++;
80103446:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010344b:	83 c0 01             	add    $0x1,%eax
8010344e:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103453:	8b 45 08             	mov    0x8(%ebp),%eax
80103456:	8b 00                	mov    (%eax),%eax
80103458:	83 c8 04             	or     $0x4,%eax
8010345b:	89 c2                	mov    %eax,%edx
8010345d:	8b 45 08             	mov    0x8(%ebp),%eax
80103460:	89 10                	mov    %edx,(%eax)
}
80103462:	90                   	nop
80103463:	c9                   	leave  
80103464:	c3                   	ret    

80103465 <v2p>:
80103465:	55                   	push   %ebp
80103466:	89 e5                	mov    %esp,%ebp
80103468:	8b 45 08             	mov    0x8(%ebp),%eax
8010346b:	05 00 00 00 80       	add    $0x80000000,%eax
80103470:	5d                   	pop    %ebp
80103471:	c3                   	ret    

80103472 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103472:	55                   	push   %ebp
80103473:	89 e5                	mov    %esp,%ebp
80103475:	8b 45 08             	mov    0x8(%ebp),%eax
80103478:	05 00 00 00 80       	add    $0x80000000,%eax
8010347d:	5d                   	pop    %ebp
8010347e:	c3                   	ret    

8010347f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010347f:	55                   	push   %ebp
80103480:	89 e5                	mov    %esp,%ebp
80103482:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103485:	8b 55 08             	mov    0x8(%ebp),%edx
80103488:	8b 45 0c             	mov    0xc(%ebp),%eax
8010348b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010348e:	f0 87 02             	lock xchg %eax,(%edx)
80103491:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103494:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103497:	c9                   	leave  
80103498:	c3                   	ret    

80103499 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103499:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010349d:	83 e4 f0             	and    $0xfffffff0,%esp
801034a0:	ff 71 fc             	pushl  -0x4(%ecx)
801034a3:	55                   	push   %ebp
801034a4:	89 e5                	mov    %esp,%ebp
801034a6:	51                   	push   %ecx
801034a7:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034aa:	83 ec 08             	sub    $0x8,%esp
801034ad:	68 00 00 40 80       	push   $0x80400000
801034b2:	68 00 27 11 80       	push   $0x80112700
801034b7:	e8 cd f5 ff ff       	call   80102a89 <kinit1>
801034bc:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801034bf:	e8 f0 44 00 00       	call   801079b4 <kvmalloc>
  mpinit();        // collect info about this machine
801034c4:	e8 48 04 00 00       	call   80103911 <mpinit>
  lapicinit();
801034c9:	e8 2a f9 ff ff       	call   80102df8 <lapicinit>
  seginit();       // set up segments
801034ce:	e8 80 3e 00 00       	call   80107353 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801034d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034d9:	0f b6 00             	movzbl (%eax),%eax
801034dc:	0f b6 c0             	movzbl %al,%eax
801034df:	83 ec 08             	sub    $0x8,%esp
801034e2:	50                   	push   %eax
801034e3:	68 4d 83 10 80       	push   $0x8010834d
801034e8:	e8 d9 ce ff ff       	call   801003c6 <cprintf>
801034ed:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801034f0:	e8 72 06 00 00       	call   80103b67 <picinit>
  ioapicinit();    // another interrupt controller
801034f5:	e8 84 f4 ff ff       	call   8010297e <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801034fa:	e8 f9 d5 ff ff       	call   80100af8 <consoleinit>
  uartinit();      // serial port
801034ff:	e8 ab 31 00 00       	call   801066af <uartinit>
  pinit();         // process table
80103504:	e8 5b 0b 00 00       	call   80104064 <pinit>
  tvinit();        // trap vectors
80103509:	e8 6b 2d 00 00       	call   80106279 <tvinit>
  binit();         // buffer cache
8010350e:	e8 21 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103513:	e8 3d da ff ff       	call   80100f55 <fileinit>
  iinit();         // inode cache
80103518:	e8 16 e1 ff ff       	call   80101633 <iinit>
  ideinit();       // disk
8010351d:	e8 a0 f0 ff ff       	call   801025c2 <ideinit>
  if(!ismp)
80103522:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103527:	85 c0                	test   %eax,%eax
80103529:	75 05                	jne    80103530 <main+0x97>
    timerinit();   // uniprocessor timer
8010352b:	e8 a6 2c 00 00       	call   801061d6 <timerinit>
  startothers();   // start other processors
80103530:	e8 7f 00 00 00       	call   801035b4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103535:	83 ec 08             	sub    $0x8,%esp
80103538:	68 00 00 00 8e       	push   $0x8e000000
8010353d:	68 00 00 40 80       	push   $0x80400000
80103542:	e8 7b f5 ff ff       	call   80102ac2 <kinit2>
80103547:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010354a:	e8 39 0c 00 00       	call   80104188 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010354f:	e8 1a 00 00 00       	call   8010356e <mpmain>

80103554 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010355a:	e8 6d 44 00 00       	call   801079cc <switchkvm>
  seginit();
8010355f:	e8 ef 3d 00 00       	call   80107353 <seginit>
  lapicinit();
80103564:	e8 8f f8 ff ff       	call   80102df8 <lapicinit>
  mpmain();
80103569:	e8 00 00 00 00       	call   8010356e <mpmain>

8010356e <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010356e:	55                   	push   %ebp
8010356f:	89 e5                	mov    %esp,%ebp
80103571:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103574:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010357a:	0f b6 00             	movzbl (%eax),%eax
8010357d:	0f b6 c0             	movzbl %al,%eax
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	50                   	push   %eax
80103584:	68 64 83 10 80       	push   $0x80108364
80103589:	e8 38 ce ff ff       	call   801003c6 <cprintf>
8010358e:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103591:	e8 59 2e 00 00       	call   801063ef <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103596:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010359c:	05 a8 00 00 00       	add    $0xa8,%eax
801035a1:	83 ec 08             	sub    $0x8,%esp
801035a4:	6a 01                	push   $0x1
801035a6:	50                   	push   %eax
801035a7:	e8 d3 fe ff ff       	call   8010347f <xchg>
801035ac:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801035af:	e8 55 11 00 00       	call   80104709 <scheduler>

801035b4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	53                   	push   %ebx
801035b8:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801035bb:	68 00 70 00 00       	push   $0x7000
801035c0:	e8 ad fe ff ff       	call   80103472 <p2v>
801035c5:	83 c4 04             	add    $0x4,%esp
801035c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035cb:	b8 8a 00 00 00       	mov    $0x8a,%eax
801035d0:	83 ec 04             	sub    $0x4,%esp
801035d3:	50                   	push   %eax
801035d4:	68 0c b5 10 80       	push   $0x8010b50c
801035d9:	ff 75 f0             	pushl  -0x10(%ebp)
801035dc:	e8 69 19 00 00       	call   80104f4a <memmove>
801035e1:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801035e4:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
801035eb:	e9 90 00 00 00       	jmp    80103680 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
801035f0:	e8 21 f9 ff ff       	call   80102f16 <cpunum>
801035f5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035fb:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103600:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103603:	74 73                	je     80103678 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103605:	e8 b6 f5 ff ff       	call   80102bc0 <kalloc>
8010360a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010360d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103610:	83 e8 04             	sub    $0x4,%eax
80103613:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103616:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010361c:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010361e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103621:	83 e8 08             	sub    $0x8,%eax
80103624:	c7 00 54 35 10 80    	movl   $0x80103554,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010362a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010362d:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 00 a0 10 80       	push   $0x8010a000
80103638:	e8 28 fe ff ff       	call   80103465 <v2p>
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103642:	83 ec 0c             	sub    $0xc,%esp
80103645:	ff 75 f0             	pushl  -0x10(%ebp)
80103648:	e8 18 fe ff ff       	call   80103465 <v2p>
8010364d:	83 c4 10             	add    $0x10,%esp
80103650:	89 c2                	mov    %eax,%edx
80103652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103655:	0f b6 00             	movzbl (%eax),%eax
80103658:	0f b6 c0             	movzbl %al,%eax
8010365b:	83 ec 08             	sub    $0x8,%esp
8010365e:	52                   	push   %edx
8010365f:	50                   	push   %eax
80103660:	e8 2b f9 ff ff       	call   80102f90 <lapicstartap>
80103665:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103668:	90                   	nop
80103669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010366c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103672:	85 c0                	test   %eax,%eax
80103674:	74 f3                	je     80103669 <startothers+0xb5>
80103676:	eb 01                	jmp    80103679 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103678:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103679:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103680:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103685:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010368b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103690:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103693:	0f 87 57 ff ff ff    	ja     801035f0 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103699:	90                   	nop
8010369a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010369d:	c9                   	leave  
8010369e:	c3                   	ret    

8010369f <p2v>:
8010369f:	55                   	push   %ebp
801036a0:	89 e5                	mov    %esp,%ebp
801036a2:	8b 45 08             	mov    0x8(%ebp),%eax
801036a5:	05 00 00 00 80       	add    $0x80000000,%eax
801036aa:	5d                   	pop    %ebp
801036ab:	c3                   	ret    

801036ac <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801036ac:	55                   	push   %ebp
801036ad:	89 e5                	mov    %esp,%ebp
801036af:	83 ec 14             	sub    $0x14,%esp
801036b2:	8b 45 08             	mov    0x8(%ebp),%eax
801036b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801036bd:	89 c2                	mov    %eax,%edx
801036bf:	ec                   	in     (%dx),%al
801036c0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801036c3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801036c7:	c9                   	leave  
801036c8:	c3                   	ret    

801036c9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801036c9:	55                   	push   %ebp
801036ca:	89 e5                	mov    %esp,%ebp
801036cc:	83 ec 08             	sub    $0x8,%esp
801036cf:	8b 55 08             	mov    0x8(%ebp),%edx
801036d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801036d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801036d9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801036e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801036e4:	ee                   	out    %al,(%dx)
}
801036e5:	90                   	nop
801036e6:	c9                   	leave  
801036e7:	c3                   	ret    

801036e8 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801036e8:	55                   	push   %ebp
801036e9:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801036eb:	a1 44 b6 10 80       	mov    0x8010b644,%eax
801036f0:	89 c2                	mov    %eax,%edx
801036f2:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
801036f7:	29 c2                	sub    %eax,%edx
801036f9:	89 d0                	mov    %edx,%eax
801036fb:	c1 f8 02             	sar    $0x2,%eax
801036fe:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103704:	5d                   	pop    %ebp
80103705:	c3                   	ret    

80103706 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103706:	55                   	push   %ebp
80103707:	89 e5                	mov    %esp,%ebp
80103709:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010370c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103713:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010371a:	eb 15                	jmp    80103731 <sum+0x2b>
    sum += addr[i];
8010371c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010371f:	8b 45 08             	mov    0x8(%ebp),%eax
80103722:	01 d0                	add    %edx,%eax
80103724:	0f b6 00             	movzbl (%eax),%eax
80103727:	0f b6 c0             	movzbl %al,%eax
8010372a:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
8010372d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103731:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103734:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103737:	7c e3                	jl     8010371c <sum+0x16>
    sum += addr[i];
  return sum;
80103739:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010373c:	c9                   	leave  
8010373d:	c3                   	ret    

8010373e <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010373e:	55                   	push   %ebp
8010373f:	89 e5                	mov    %esp,%ebp
80103741:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103744:	ff 75 08             	pushl  0x8(%ebp)
80103747:	e8 53 ff ff ff       	call   8010369f <p2v>
8010374c:	83 c4 04             	add    $0x4,%esp
8010374f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103752:	8b 55 0c             	mov    0xc(%ebp),%edx
80103755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103758:	01 d0                	add    %edx,%eax
8010375a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103760:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103763:	eb 36                	jmp    8010379b <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103765:	83 ec 04             	sub    $0x4,%esp
80103768:	6a 04                	push   $0x4
8010376a:	68 78 83 10 80       	push   $0x80108378
8010376f:	ff 75 f4             	pushl  -0xc(%ebp)
80103772:	e8 7b 17 00 00       	call   80104ef2 <memcmp>
80103777:	83 c4 10             	add    $0x10,%esp
8010377a:	85 c0                	test   %eax,%eax
8010377c:	75 19                	jne    80103797 <mpsearch1+0x59>
8010377e:	83 ec 08             	sub    $0x8,%esp
80103781:	6a 10                	push   $0x10
80103783:	ff 75 f4             	pushl  -0xc(%ebp)
80103786:	e8 7b ff ff ff       	call   80103706 <sum>
8010378b:	83 c4 10             	add    $0x10,%esp
8010378e:	84 c0                	test   %al,%al
80103790:	75 05                	jne    80103797 <mpsearch1+0x59>
      return (struct mp*)p;
80103792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103795:	eb 11                	jmp    801037a8 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103797:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010379e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801037a1:	72 c2                	jb     80103765 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801037a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801037a8:	c9                   	leave  
801037a9:	c3                   	ret    

801037aa <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801037aa:	55                   	push   %ebp
801037ab:	89 e5                	mov    %esp,%ebp
801037ad:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801037b0:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ba:	83 c0 0f             	add    $0xf,%eax
801037bd:	0f b6 00             	movzbl (%eax),%eax
801037c0:	0f b6 c0             	movzbl %al,%eax
801037c3:	c1 e0 08             	shl    $0x8,%eax
801037c6:	89 c2                	mov    %eax,%edx
801037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037cb:	83 c0 0e             	add    $0xe,%eax
801037ce:	0f b6 00             	movzbl (%eax),%eax
801037d1:	0f b6 c0             	movzbl %al,%eax
801037d4:	09 d0                	or     %edx,%eax
801037d6:	c1 e0 04             	shl    $0x4,%eax
801037d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801037dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801037e0:	74 21                	je     80103803 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
801037e2:	83 ec 08             	sub    $0x8,%esp
801037e5:	68 00 04 00 00       	push   $0x400
801037ea:	ff 75 f0             	pushl  -0x10(%ebp)
801037ed:	e8 4c ff ff ff       	call   8010373e <mpsearch1>
801037f2:	83 c4 10             	add    $0x10,%esp
801037f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037fc:	74 51                	je     8010384f <mpsearch+0xa5>
      return mp;
801037fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103801:	eb 61                	jmp    80103864 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103806:	83 c0 14             	add    $0x14,%eax
80103809:	0f b6 00             	movzbl (%eax),%eax
8010380c:	0f b6 c0             	movzbl %al,%eax
8010380f:	c1 e0 08             	shl    $0x8,%eax
80103812:	89 c2                	mov    %eax,%edx
80103814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103817:	83 c0 13             	add    $0x13,%eax
8010381a:	0f b6 00             	movzbl (%eax),%eax
8010381d:	0f b6 c0             	movzbl %al,%eax
80103820:	09 d0                	or     %edx,%eax
80103822:	c1 e0 0a             	shl    $0xa,%eax
80103825:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382b:	2d 00 04 00 00       	sub    $0x400,%eax
80103830:	83 ec 08             	sub    $0x8,%esp
80103833:	68 00 04 00 00       	push   $0x400
80103838:	50                   	push   %eax
80103839:	e8 00 ff ff ff       	call   8010373e <mpsearch1>
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103844:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103848:	74 05                	je     8010384f <mpsearch+0xa5>
      return mp;
8010384a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010384d:	eb 15                	jmp    80103864 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
8010384f:	83 ec 08             	sub    $0x8,%esp
80103852:	68 00 00 01 00       	push   $0x10000
80103857:	68 00 00 0f 00       	push   $0xf0000
8010385c:	e8 dd fe ff ff       	call   8010373e <mpsearch1>
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	c9                   	leave  
80103865:	c3                   	ret    

80103866 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103866:	55                   	push   %ebp
80103867:	89 e5                	mov    %esp,%ebp
80103869:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010386c:	e8 39 ff ff ff       	call   801037aa <mpsearch>
80103871:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103878:	74 0a                	je     80103884 <mpconfig+0x1e>
8010387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387d:	8b 40 04             	mov    0x4(%eax),%eax
80103880:	85 c0                	test   %eax,%eax
80103882:	75 0a                	jne    8010388e <mpconfig+0x28>
    return 0;
80103884:	b8 00 00 00 00       	mov    $0x0,%eax
80103889:	e9 81 00 00 00       	jmp    8010390f <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103891:	8b 40 04             	mov    0x4(%eax),%eax
80103894:	83 ec 0c             	sub    $0xc,%esp
80103897:	50                   	push   %eax
80103898:	e8 02 fe ff ff       	call   8010369f <p2v>
8010389d:	83 c4 10             	add    $0x10,%esp
801038a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	6a 04                	push   $0x4
801038a8:	68 7d 83 10 80       	push   $0x8010837d
801038ad:	ff 75 f0             	pushl  -0x10(%ebp)
801038b0:	e8 3d 16 00 00       	call   80104ef2 <memcmp>
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	74 07                	je     801038c3 <mpconfig+0x5d>
    return 0;
801038bc:	b8 00 00 00 00       	mov    $0x0,%eax
801038c1:	eb 4c                	jmp    8010390f <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
801038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c6:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038ca:	3c 01                	cmp    $0x1,%al
801038cc:	74 12                	je     801038e0 <mpconfig+0x7a>
801038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d1:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801038d5:	3c 04                	cmp    $0x4,%al
801038d7:	74 07                	je     801038e0 <mpconfig+0x7a>
    return 0;
801038d9:	b8 00 00 00 00       	mov    $0x0,%eax
801038de:	eb 2f                	jmp    8010390f <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
801038e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e3:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038e7:	0f b7 c0             	movzwl %ax,%eax
801038ea:	83 ec 08             	sub    $0x8,%esp
801038ed:	50                   	push   %eax
801038ee:	ff 75 f0             	pushl  -0x10(%ebp)
801038f1:	e8 10 fe ff ff       	call   80103706 <sum>
801038f6:	83 c4 10             	add    $0x10,%esp
801038f9:	84 c0                	test   %al,%al
801038fb:	74 07                	je     80103904 <mpconfig+0x9e>
    return 0;
801038fd:	b8 00 00 00 00       	mov    $0x0,%eax
80103902:	eb 0b                	jmp    8010390f <mpconfig+0xa9>
  *pmp = mp;
80103904:	8b 45 08             	mov    0x8(%ebp),%eax
80103907:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010390a:	89 10                	mov    %edx,(%eax)
  return conf;
8010390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010390f:	c9                   	leave  
80103910:	c3                   	ret    

80103911 <mpinit>:

void
mpinit(void)
{
80103911:	55                   	push   %ebp
80103912:	89 e5                	mov    %esp,%ebp
80103914:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103917:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
8010391e:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103921:	83 ec 0c             	sub    $0xc,%esp
80103924:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103927:	50                   	push   %eax
80103928:	e8 39 ff ff ff       	call   80103866 <mpconfig>
8010392d:	83 c4 10             	add    $0x10,%esp
80103930:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103933:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103937:	0f 84 96 01 00 00    	je     80103ad3 <mpinit+0x1c2>
    return;
  ismp = 1;
8010393d:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
80103944:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394a:	8b 40 24             	mov    0x24(%eax),%eax
8010394d:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103952:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103955:	83 c0 2c             	add    $0x2c,%eax
80103958:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010395e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103962:	0f b7 d0             	movzwl %ax,%edx
80103965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103968:	01 d0                	add    %edx,%eax
8010396a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010396d:	e9 f2 00 00 00       	jmp    80103a64 <mpinit+0x153>
    switch(*p){
80103972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103975:	0f b6 00             	movzbl (%eax),%eax
80103978:	0f b6 c0             	movzbl %al,%eax
8010397b:	83 f8 04             	cmp    $0x4,%eax
8010397e:	0f 87 bc 00 00 00    	ja     80103a40 <mpinit+0x12f>
80103984:	8b 04 85 c0 83 10 80 	mov    -0x7fef7c40(,%eax,4),%eax
8010398b:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
8010398d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103990:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103993:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103996:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010399a:	0f b6 d0             	movzbl %al,%edx
8010399d:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039a2:	39 c2                	cmp    %eax,%edx
801039a4:	74 2b                	je     801039d1 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801039a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039a9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039ad:	0f b6 d0             	movzbl %al,%edx
801039b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039b5:	83 ec 04             	sub    $0x4,%esp
801039b8:	52                   	push   %edx
801039b9:	50                   	push   %eax
801039ba:	68 82 83 10 80       	push   $0x80108382
801039bf:	e8 02 ca ff ff       	call   801003c6 <cprintf>
801039c4:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801039c7:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039ce:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801039d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801039d4:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801039d8:	0f b6 c0             	movzbl %al,%eax
801039db:	83 e0 02             	and    $0x2,%eax
801039de:	85 c0                	test   %eax,%eax
801039e0:	74 15                	je     801039f7 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
801039e2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039e7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039ed:	05 20 f9 10 80       	add    $0x8010f920,%eax
801039f2:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
801039f7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039fc:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
80103a02:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a08:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103a0d:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103a0f:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103a14:	83 c0 01             	add    $0x1,%eax
80103a17:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
80103a1c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103a20:	eb 42                	jmp    80103a64 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103a2f:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103a34:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a38:	eb 2a                	jmp    80103a64 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a3a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a3e:	eb 24                	jmp    80103a64 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a43:	0f b6 00             	movzbl (%eax),%eax
80103a46:	0f b6 c0             	movzbl %al,%eax
80103a49:	83 ec 08             	sub    $0x8,%esp
80103a4c:	50                   	push   %eax
80103a4d:	68 a0 83 10 80       	push   $0x801083a0
80103a52:	e8 6f c9 ff ff       	call   801003c6 <cprintf>
80103a57:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103a5a:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103a61:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a67:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a6a:	0f 82 02 ff ff ff    	jb     80103972 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103a70:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103a75:	85 c0                	test   %eax,%eax
80103a77:	75 1d                	jne    80103a96 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103a79:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103a80:	00 00 00 
    lapic = 0;
80103a83:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a8a:	00 00 00 
    ioapicid = 0;
80103a8d:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
80103a94:	eb 3e                	jmp    80103ad4 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103a96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a99:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a9d:	84 c0                	test   %al,%al
80103a9f:	74 33                	je     80103ad4 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103aa1:	83 ec 08             	sub    $0x8,%esp
80103aa4:	6a 70                	push   $0x70
80103aa6:	6a 22                	push   $0x22
80103aa8:	e8 1c fc ff ff       	call   801036c9 <outb>
80103aad:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	6a 23                	push   $0x23
80103ab5:	e8 f2 fb ff ff       	call   801036ac <inb>
80103aba:	83 c4 10             	add    $0x10,%esp
80103abd:	83 c8 01             	or     $0x1,%eax
80103ac0:	0f b6 c0             	movzbl %al,%eax
80103ac3:	83 ec 08             	sub    $0x8,%esp
80103ac6:	50                   	push   %eax
80103ac7:	6a 23                	push   $0x23
80103ac9:	e8 fb fb ff ff       	call   801036c9 <outb>
80103ace:	83 c4 10             	add    $0x10,%esp
80103ad1:	eb 01                	jmp    80103ad4 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103ad3:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103ad4:	c9                   	leave  
80103ad5:	c3                   	ret    

80103ad6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	83 ec 08             	sub    $0x8,%esp
80103adc:	8b 55 08             	mov    0x8(%ebp),%edx
80103adf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ae2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ae6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ae9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103aed:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103af1:	ee                   	out    %al,(%dx)
}
80103af2:	90                   	nop
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    

80103af5 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103af5:	55                   	push   %ebp
80103af6:	89 e5                	mov    %esp,%ebp
80103af8:	83 ec 04             	sub    $0x4,%esp
80103afb:	8b 45 08             	mov    0x8(%ebp),%eax
80103afe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103b02:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b06:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103b0c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b10:	0f b6 c0             	movzbl %al,%eax
80103b13:	50                   	push   %eax
80103b14:	6a 21                	push   $0x21
80103b16:	e8 bb ff ff ff       	call   80103ad6 <outb>
80103b1b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103b1e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103b22:	66 c1 e8 08          	shr    $0x8,%ax
80103b26:	0f b6 c0             	movzbl %al,%eax
80103b29:	50                   	push   %eax
80103b2a:	68 a1 00 00 00       	push   $0xa1
80103b2f:	e8 a2 ff ff ff       	call   80103ad6 <outb>
80103b34:	83 c4 08             	add    $0x8,%esp
}
80103b37:	90                   	nop
80103b38:	c9                   	leave  
80103b39:	c3                   	ret    

80103b3a <picenable>:

void
picenable(int irq)
{
80103b3a:	55                   	push   %ebp
80103b3b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b40:	ba 01 00 00 00       	mov    $0x1,%edx
80103b45:	89 c1                	mov    %eax,%ecx
80103b47:	d3 e2                	shl    %cl,%edx
80103b49:	89 d0                	mov    %edx,%eax
80103b4b:	f7 d0                	not    %eax
80103b4d:	89 c2                	mov    %eax,%edx
80103b4f:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b56:	21 d0                	and    %edx,%eax
80103b58:	0f b7 c0             	movzwl %ax,%eax
80103b5b:	50                   	push   %eax
80103b5c:	e8 94 ff ff ff       	call   80103af5 <picsetmask>
80103b61:	83 c4 04             	add    $0x4,%esp
}
80103b64:	90                   	nop
80103b65:	c9                   	leave  
80103b66:	c3                   	ret    

80103b67 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103b67:	55                   	push   %ebp
80103b68:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103b6a:	68 ff 00 00 00       	push   $0xff
80103b6f:	6a 21                	push   $0x21
80103b71:	e8 60 ff ff ff       	call   80103ad6 <outb>
80103b76:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103b79:	68 ff 00 00 00       	push   $0xff
80103b7e:	68 a1 00 00 00       	push   $0xa1
80103b83:	e8 4e ff ff ff       	call   80103ad6 <outb>
80103b88:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b8b:	6a 11                	push   $0x11
80103b8d:	6a 20                	push   $0x20
80103b8f:	e8 42 ff ff ff       	call   80103ad6 <outb>
80103b94:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b97:	6a 20                	push   $0x20
80103b99:	6a 21                	push   $0x21
80103b9b:	e8 36 ff ff ff       	call   80103ad6 <outb>
80103ba0:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ba3:	6a 04                	push   $0x4
80103ba5:	6a 21                	push   $0x21
80103ba7:	e8 2a ff ff ff       	call   80103ad6 <outb>
80103bac:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103baf:	6a 03                	push   $0x3
80103bb1:	6a 21                	push   $0x21
80103bb3:	e8 1e ff ff ff       	call   80103ad6 <outb>
80103bb8:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103bbb:	6a 11                	push   $0x11
80103bbd:	68 a0 00 00 00       	push   $0xa0
80103bc2:	e8 0f ff ff ff       	call   80103ad6 <outb>
80103bc7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103bca:	6a 28                	push   $0x28
80103bcc:	68 a1 00 00 00       	push   $0xa1
80103bd1:	e8 00 ff ff ff       	call   80103ad6 <outb>
80103bd6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103bd9:	6a 02                	push   $0x2
80103bdb:	68 a1 00 00 00       	push   $0xa1
80103be0:	e8 f1 fe ff ff       	call   80103ad6 <outb>
80103be5:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103be8:	6a 03                	push   $0x3
80103bea:	68 a1 00 00 00       	push   $0xa1
80103bef:	e8 e2 fe ff ff       	call   80103ad6 <outb>
80103bf4:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bf7:	6a 68                	push   $0x68
80103bf9:	6a 20                	push   $0x20
80103bfb:	e8 d6 fe ff ff       	call   80103ad6 <outb>
80103c00:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103c03:	6a 0a                	push   $0xa
80103c05:	6a 20                	push   $0x20
80103c07:	e8 ca fe ff ff       	call   80103ad6 <outb>
80103c0c:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103c0f:	6a 68                	push   $0x68
80103c11:	68 a0 00 00 00       	push   $0xa0
80103c16:	e8 bb fe ff ff       	call   80103ad6 <outb>
80103c1b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103c1e:	6a 0a                	push   $0xa
80103c20:	68 a0 00 00 00       	push   $0xa0
80103c25:	e8 ac fe ff ff       	call   80103ad6 <outb>
80103c2a:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103c2d:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c34:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c38:	74 13                	je     80103c4d <picinit+0xe6>
    picsetmask(irqmask);
80103c3a:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c41:	0f b7 c0             	movzwl %ax,%eax
80103c44:	50                   	push   %eax
80103c45:	e8 ab fe ff ff       	call   80103af5 <picsetmask>
80103c4a:	83 c4 04             	add    $0x4,%esp
}
80103c4d:	90                   	nop
80103c4e:	c9                   	leave  
80103c4f:	c3                   	ret    

80103c50 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c66:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c69:	8b 10                	mov    (%eax),%edx
80103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c6e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c70:	e8 fe d2 ff ff       	call   80100f73 <filealloc>
80103c75:	89 c2                	mov    %eax,%edx
80103c77:	8b 45 08             	mov    0x8(%ebp),%eax
80103c7a:	89 10                	mov    %edx,(%eax)
80103c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c7f:	8b 00                	mov    (%eax),%eax
80103c81:	85 c0                	test   %eax,%eax
80103c83:	0f 84 cb 00 00 00    	je     80103d54 <pipealloc+0x104>
80103c89:	e8 e5 d2 ff ff       	call   80100f73 <filealloc>
80103c8e:	89 c2                	mov    %eax,%edx
80103c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c93:	89 10                	mov    %edx,(%eax)
80103c95:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c98:	8b 00                	mov    (%eax),%eax
80103c9a:	85 c0                	test   %eax,%eax
80103c9c:	0f 84 b2 00 00 00    	je     80103d54 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ca2:	e8 19 ef ff ff       	call   80102bc0 <kalloc>
80103ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cae:	0f 84 9f 00 00 00    	je     80103d53 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103cbe:	00 00 00 
  p->writeopen = 1;
80103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ccb:	00 00 00 
  p->nwrite = 0;
80103cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cd8:	00 00 00 
  p->nread = 0;
80103cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cde:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ce5:	00 00 00 
  initlock(&p->lock, "pipe");
80103ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ceb:	83 ec 08             	sub    $0x8,%esp
80103cee:	68 d4 83 10 80       	push   $0x801083d4
80103cf3:	50                   	push   %eax
80103cf4:	e8 0d 0f 00 00       	call   80104c06 <initlock>
80103cf9:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cff:	8b 00                	mov    (%eax),%eax
80103d01:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d07:	8b 45 08             	mov    0x8(%ebp),%eax
80103d0a:	8b 00                	mov    (%eax),%eax
80103d0c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d10:	8b 45 08             	mov    0x8(%ebp),%eax
80103d13:	8b 00                	mov    (%eax),%eax
80103d15:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d19:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1c:	8b 00                	mov    (%eax),%eax
80103d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d21:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d27:	8b 00                	mov    (%eax),%eax
80103d29:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d32:	8b 00                	mov    (%eax),%eax
80103d34:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d3b:	8b 00                	mov    (%eax),%eax
80103d3d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d41:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d44:	8b 00                	mov    (%eax),%eax
80103d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d49:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d4c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d51:	eb 4e                	jmp    80103da1 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d53:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d58:	74 0e                	je     80103d68 <pipealloc+0x118>
    kfree((char*)p);
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	ff 75 f4             	pushl  -0xc(%ebp)
80103d60:	e8 be ed ff ff       	call   80102b23 <kfree>
80103d65:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103d68:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6b:	8b 00                	mov    (%eax),%eax
80103d6d:	85 c0                	test   %eax,%eax
80103d6f:	74 11                	je     80103d82 <pipealloc+0x132>
    fileclose(*f0);
80103d71:	8b 45 08             	mov    0x8(%ebp),%eax
80103d74:	8b 00                	mov    (%eax),%eax
80103d76:	83 ec 0c             	sub    $0xc,%esp
80103d79:	50                   	push   %eax
80103d7a:	e8 b2 d2 ff ff       	call   80101031 <fileclose>
80103d7f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d82:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d85:	8b 00                	mov    (%eax),%eax
80103d87:	85 c0                	test   %eax,%eax
80103d89:	74 11                	je     80103d9c <pipealloc+0x14c>
    fileclose(*f1);
80103d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d8e:	8b 00                	mov    (%eax),%eax
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	50                   	push   %eax
80103d94:	e8 98 d2 ff ff       	call   80101031 <fileclose>
80103d99:	83 c4 10             	add    $0x10,%esp
  return -1;
80103d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103da1:	c9                   	leave  
80103da2:	c3                   	ret    

80103da3 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103da3:	55                   	push   %ebp
80103da4:	89 e5                	mov    %esp,%ebp
80103da6:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103da9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dac:	83 ec 0c             	sub    $0xc,%esp
80103daf:	50                   	push   %eax
80103db0:	e8 73 0e 00 00       	call   80104c28 <acquire>
80103db5:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103dbc:	74 23                	je     80103de1 <pipeclose+0x3e>
    p->writeopen = 0;
80103dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc1:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103dc8:	00 00 00 
    wakeup(&p->nread);
80103dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dce:	05 34 02 00 00       	add    $0x234,%eax
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	50                   	push   %eax
80103dd7:	e8 e5 0b 00 00       	call   801049c1 <wakeup>
80103ddc:	83 c4 10             	add    $0x10,%esp
80103ddf:	eb 21                	jmp    80103e02 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103de1:	8b 45 08             	mov    0x8(%ebp),%eax
80103de4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103deb:	00 00 00 
    wakeup(&p->nwrite);
80103dee:	8b 45 08             	mov    0x8(%ebp),%eax
80103df1:	05 38 02 00 00       	add    $0x238,%eax
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	50                   	push   %eax
80103dfa:	e8 c2 0b 00 00       	call   801049c1 <wakeup>
80103dff:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e02:	8b 45 08             	mov    0x8(%ebp),%eax
80103e05:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	75 2c                	jne    80103e3b <pipeclose+0x98>
80103e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e12:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e18:	85 c0                	test   %eax,%eax
80103e1a:	75 1f                	jne    80103e3b <pipeclose+0x98>
    release(&p->lock);
80103e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1f:	83 ec 0c             	sub    $0xc,%esp
80103e22:	50                   	push   %eax
80103e23:	e8 67 0e 00 00       	call   80104c8f <release>
80103e28:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103e2b:	83 ec 0c             	sub    $0xc,%esp
80103e2e:	ff 75 08             	pushl  0x8(%ebp)
80103e31:	e8 ed ec ff ff       	call   80102b23 <kfree>
80103e36:	83 c4 10             	add    $0x10,%esp
80103e39:	eb 0f                	jmp    80103e4a <pipeclose+0xa7>
  } else
    release(&p->lock);
80103e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3e:	83 ec 0c             	sub    $0xc,%esp
80103e41:	50                   	push   %eax
80103e42:	e8 48 0e 00 00       	call   80104c8f <release>
80103e47:	83 c4 10             	add    $0x10,%esp
}
80103e4a:	90                   	nop
80103e4b:	c9                   	leave  
80103e4c:	c3                   	ret    

80103e4d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e4d:	55                   	push   %ebp
80103e4e:	89 e5                	mov    %esp,%ebp
80103e50:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103e53:	8b 45 08             	mov    0x8(%ebp),%eax
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	50                   	push   %eax
80103e5a:	e8 c9 0d 00 00       	call   80104c28 <acquire>
80103e5f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e69:	e9 ad 00 00 00       	jmp    80103f1b <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e71:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e77:	85 c0                	test   %eax,%eax
80103e79:	74 0d                	je     80103e88 <pipewrite+0x3b>
80103e7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e81:	8b 40 24             	mov    0x24(%eax),%eax
80103e84:	85 c0                	test   %eax,%eax
80103e86:	74 19                	je     80103ea1 <pipewrite+0x54>
        release(&p->lock);
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	50                   	push   %eax
80103e8f:	e8 fb 0d 00 00       	call   80104c8f <release>
80103e94:	83 c4 10             	add    $0x10,%esp
        return -1;
80103e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9c:	e9 a8 00 00 00       	jmp    80103f49 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80103ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea4:	05 34 02 00 00       	add    $0x234,%eax
80103ea9:	83 ec 0c             	sub    $0xc,%esp
80103eac:	50                   	push   %eax
80103ead:	e8 0f 0b 00 00       	call   801049c1 <wakeup>
80103eb2:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb8:	8b 55 08             	mov    0x8(%ebp),%edx
80103ebb:	81 c2 38 02 00 00    	add    $0x238,%edx
80103ec1:	83 ec 08             	sub    $0x8,%esp
80103ec4:	50                   	push   %eax
80103ec5:	52                   	push   %edx
80103ec6:	e8 0b 0a 00 00       	call   801048d6 <sleep>
80103ecb:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eda:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103ee0:	05 00 02 00 00       	add    $0x200,%eax
80103ee5:	39 c2                	cmp    %eax,%edx
80103ee7:	74 85                	je     80103e6e <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80103eec:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ef2:	8d 48 01             	lea    0x1(%eax),%ecx
80103ef5:	8b 55 08             	mov    0x8(%ebp),%edx
80103ef8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103efe:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f03:	89 c1                	mov    %eax,%ecx
80103f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f08:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f0b:	01 d0                	add    %edx,%eax
80103f0d:	0f b6 10             	movzbl (%eax),%edx
80103f10:	8b 45 08             	mov    0x8(%ebp),%eax
80103f13:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103f17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f1e:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f21:	7c ab                	jl     80103ece <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f23:	8b 45 08             	mov    0x8(%ebp),%eax
80103f26:	05 34 02 00 00       	add    $0x234,%eax
80103f2b:	83 ec 0c             	sub    $0xc,%esp
80103f2e:	50                   	push   %eax
80103f2f:	e8 8d 0a 00 00       	call   801049c1 <wakeup>
80103f34:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103f37:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	50                   	push   %eax
80103f3e:	e8 4c 0d 00 00       	call   80104c8f <release>
80103f43:	83 c4 10             	add    $0x10,%esp
  return n;
80103f46:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f49:	c9                   	leave  
80103f4a:	c3                   	ret    

80103f4b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f4b:	55                   	push   %ebp
80103f4c:	89 e5                	mov    %esp,%ebp
80103f4e:	53                   	push   %ebx
80103f4f:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103f52:	8b 45 08             	mov    0x8(%ebp),%eax
80103f55:	83 ec 0c             	sub    $0xc,%esp
80103f58:	50                   	push   %eax
80103f59:	e8 ca 0c 00 00       	call   80104c28 <acquire>
80103f5e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f61:	eb 3f                	jmp    80103fa2 <piperead+0x57>
    if(proc->killed){
80103f63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f69:	8b 40 24             	mov    0x24(%eax),%eax
80103f6c:	85 c0                	test   %eax,%eax
80103f6e:	74 19                	je     80103f89 <piperead+0x3e>
      release(&p->lock);
80103f70:	8b 45 08             	mov    0x8(%ebp),%eax
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	50                   	push   %eax
80103f77:	e8 13 0d 00 00       	call   80104c8f <release>
80103f7c:	83 c4 10             	add    $0x10,%esp
      return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f84:	e9 bf 00 00 00       	jmp    80104048 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f89:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8c:	8b 55 08             	mov    0x8(%ebp),%edx
80103f8f:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f95:	83 ec 08             	sub    $0x8,%esp
80103f98:	50                   	push   %eax
80103f99:	52                   	push   %edx
80103f9a:	e8 37 09 00 00       	call   801048d6 <sleep>
80103f9f:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fab:	8b 45 08             	mov    0x8(%ebp),%eax
80103fae:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fb4:	39 c2                	cmp    %eax,%edx
80103fb6:	75 0d                	jne    80103fc5 <piperead+0x7a>
80103fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbb:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103fc1:	85 c0                	test   %eax,%eax
80103fc3:	75 9e                	jne    80103f63 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fcc:	eb 49                	jmp    80104017 <piperead+0xcc>
    if(p->nread == p->nwrite)
80103fce:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd1:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fda:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fe0:	39 c2                	cmp    %eax,%edx
80103fe2:	74 3d                	je     80104021 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fe4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fea:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103fed:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff0:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103ff6:	8d 48 01             	lea    0x1(%eax),%ecx
80103ff9:	8b 55 08             	mov    0x8(%ebp),%edx
80103ffc:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104002:	25 ff 01 00 00       	and    $0x1ff,%eax
80104007:	89 c2                	mov    %eax,%edx
80104009:	8b 45 08             	mov    0x8(%ebp),%eax
8010400c:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104011:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104013:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010401d:	7c af                	jl     80103fce <piperead+0x83>
8010401f:	eb 01                	jmp    80104022 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104021:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104022:	8b 45 08             	mov    0x8(%ebp),%eax
80104025:	05 38 02 00 00       	add    $0x238,%eax
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	50                   	push   %eax
8010402e:	e8 8e 09 00 00       	call   801049c1 <wakeup>
80104033:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	83 ec 0c             	sub    $0xc,%esp
8010403c:	50                   	push   %eax
8010403d:	e8 4d 0c 00 00       	call   80104c8f <release>
80104042:	83 c4 10             	add    $0x10,%esp
  return i;
80104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010404b:	c9                   	leave  
8010404c:	c3                   	ret    

8010404d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010404d:	55                   	push   %ebp
8010404e:	89 e5                	mov    %esp,%ebp
80104050:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104053:	9c                   	pushf  
80104054:	58                   	pop    %eax
80104055:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104058:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010405b:	c9                   	leave  
8010405c:	c3                   	ret    

8010405d <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010405d:	55                   	push   %ebp
8010405e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104060:	fb                   	sti    
}
80104061:	90                   	nop
80104062:	5d                   	pop    %ebp
80104063:	c3                   	ret    

80104064 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010406a:	83 ec 08             	sub    $0x8,%esp
8010406d:	68 dc 83 10 80       	push   $0x801083dc
80104072:	68 20 ff 10 80       	push   $0x8010ff20
80104077:	e8 8a 0b 00 00       	call   80104c06 <initlock>
8010407c:	83 c4 10             	add    $0x10,%esp
}
8010407f:	90                   	nop
80104080:	c9                   	leave  
80104081:	c3                   	ret    

80104082 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104082:	55                   	push   %ebp
80104083:	89 e5                	mov    %esp,%ebp
80104085:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 20 ff 10 80       	push   $0x8010ff20
80104090:	e8 93 0b 00 00       	call   80104c28 <acquire>
80104095:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104098:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010409f:	eb 0e                	jmp    801040af <allocproc+0x2d>
    if(p->state == UNUSED)
801040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a4:	8b 40 0c             	mov    0xc(%eax),%eax
801040a7:	85 c0                	test   %eax,%eax
801040a9:	74 27                	je     801040d2 <allocproc+0x50>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ab:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801040af:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801040b6:	72 e9                	jb     801040a1 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	68 20 ff 10 80       	push   $0x8010ff20
801040c0:	e8 ca 0b 00 00       	call   80104c8f <release>
801040c5:	83 c4 10             	add    $0x10,%esp
  return 0;
801040c8:	b8 00 00 00 00       	mov    $0x0,%eax
801040cd:	e9 b4 00 00 00       	jmp    80104186 <allocproc+0x104>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801040d2:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801040d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d6:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801040dd:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040e2:	8d 50 01             	lea    0x1(%eax),%edx
801040e5:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
801040eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ee:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801040f1:	83 ec 0c             	sub    $0xc,%esp
801040f4:	68 20 ff 10 80       	push   $0x8010ff20
801040f9:	e8 91 0b 00 00       	call   80104c8f <release>
801040fe:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104101:	e8 ba ea ff ff       	call   80102bc0 <kalloc>
80104106:	89 c2                	mov    %eax,%edx
80104108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410b:	89 50 08             	mov    %edx,0x8(%eax)
8010410e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104111:	8b 40 08             	mov    0x8(%eax),%eax
80104114:	85 c0                	test   %eax,%eax
80104116:	75 11                	jne    80104129 <allocproc+0xa7>
    p->state = UNUSED;
80104118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104122:	b8 00 00 00 00       	mov    $0x0,%eax
80104127:	eb 5d                	jmp    80104186 <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
80104129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412c:	8b 40 08             	mov    0x8(%eax),%eax
8010412f:	05 00 10 00 00       	add    $0x1000,%eax
80104134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104137:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104141:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104144:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104148:	ba 33 62 10 80       	mov    $0x80106233,%edx
8010414d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104150:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104152:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104159:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010415c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010415f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104162:	8b 40 1c             	mov    0x1c(%eax),%eax
80104165:	83 ec 04             	sub    $0x4,%esp
80104168:	6a 14                	push   $0x14
8010416a:	6a 00                	push   $0x0
8010416c:	50                   	push   %eax
8010416d:	e8 19 0d 00 00       	call   80104e8b <memset>
80104172:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104178:	8b 40 1c             	mov    0x1c(%eax),%eax
8010417b:	ba a5 48 10 80       	mov    $0x801048a5,%edx
80104180:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104183:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104186:	c9                   	leave  
80104187:	c3                   	ret    

80104188 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104188:	55                   	push   %ebp
80104189:	89 e5                	mov    %esp,%ebp
8010418b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010418e:	e8 ef fe ff ff       	call   80104082 <allocproc>
80104193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104199:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
8010419e:	e8 55 37 00 00       	call   801078f8 <setupkvm>
801041a3:	89 c2                	mov    %eax,%edx
801041a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a8:	89 50 04             	mov    %edx,0x4(%eax)
801041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ae:	8b 40 04             	mov    0x4(%eax),%eax
801041b1:	85 c0                	test   %eax,%eax
801041b3:	75 0d                	jne    801041c2 <userinit+0x3a>
    panic("userinit: out of memory?");
801041b5:	83 ec 0c             	sub    $0xc,%esp
801041b8:	68 e3 83 10 80       	push   $0x801083e3
801041bd:	e8 a4 c3 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041c2:	ba 2c 00 00 00       	mov    $0x2c,%edx
801041c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ca:	8b 40 04             	mov    0x4(%eax),%eax
801041cd:	83 ec 04             	sub    $0x4,%esp
801041d0:	52                   	push   %edx
801041d1:	68 e0 b4 10 80       	push   $0x8010b4e0
801041d6:	50                   	push   %eax
801041d7:	e8 80 39 00 00       	call   80107b5c <inituvm>
801041dc:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801041e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041eb:	8b 40 18             	mov    0x18(%eax),%eax
801041ee:	83 ec 04             	sub    $0x4,%esp
801041f1:	6a 4c                	push   $0x4c
801041f3:	6a 00                	push   $0x0
801041f5:	50                   	push   %eax
801041f6:	e8 90 0c 00 00       	call   80104e8b <memset>
801041fb:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104201:	8b 40 18             	mov    0x18(%eax),%eax
80104204:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010420a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420d:	8b 40 18             	mov    0x18(%eax),%eax
80104210:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104219:	8b 40 18             	mov    0x18(%eax),%eax
8010421c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010421f:	8b 52 18             	mov    0x18(%edx),%edx
80104222:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104226:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422d:	8b 40 18             	mov    0x18(%eax),%eax
80104230:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104233:	8b 52 18             	mov    0x18(%edx),%edx
80104236:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010423a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010423e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104241:	8b 40 18             	mov    0x18(%eax),%eax
80104244:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010424b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424e:	8b 40 18             	mov    0x18(%eax),%eax
80104251:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425b:	8b 40 18             	mov    0x18(%eax),%eax
8010425e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104268:	83 c0 6c             	add    $0x6c,%eax
8010426b:	83 ec 04             	sub    $0x4,%esp
8010426e:	6a 10                	push   $0x10
80104270:	68 fc 83 10 80       	push   $0x801083fc
80104275:	50                   	push   %eax
80104276:	e8 13 0e 00 00       	call   8010508e <safestrcpy>
8010427b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	68 05 84 10 80       	push   $0x80108405
80104286:	e8 33 e2 ff ff       	call   801024be <namei>
8010428b:	83 c4 10             	add    $0x10,%esp
8010428e:	89 c2                	mov    %eax,%edx
80104290:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104293:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104299:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801042a0:	90                   	nop
801042a1:	c9                   	leave  
801042a2:	c3                   	ret    

801042a3 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801042a3:	55                   	push   %ebp
801042a4:	89 e5                	mov    %esp,%ebp
801042a6:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801042a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042af:	8b 00                	mov    (%eax),%eax
801042b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801042b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042b8:	7e 31                	jle    801042eb <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801042ba:	8b 55 08             	mov    0x8(%ebp),%edx
801042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c0:	01 c2                	add    %eax,%edx
801042c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c8:	8b 40 04             	mov    0x4(%eax),%eax
801042cb:	83 ec 04             	sub    $0x4,%esp
801042ce:	52                   	push   %edx
801042cf:	ff 75 f4             	pushl  -0xc(%ebp)
801042d2:	50                   	push   %eax
801042d3:	e8 d1 39 00 00       	call   80107ca9 <allocuvm>
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042e2:	75 3e                	jne    80104322 <growproc+0x7f>
      return -1;
801042e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042e9:	eb 59                	jmp    80104344 <growproc+0xa1>
  } else if(n < 0){
801042eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042ef:	79 31                	jns    80104322 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042f1:	8b 55 08             	mov    0x8(%ebp),%edx
801042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f7:	01 c2                	add    %eax,%edx
801042f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ff:	8b 40 04             	mov    0x4(%eax),%eax
80104302:	83 ec 04             	sub    $0x4,%esp
80104305:	52                   	push   %edx
80104306:	ff 75 f4             	pushl  -0xc(%ebp)
80104309:	50                   	push   %eax
8010430a:	e8 63 3a 00 00       	call   80107d72 <deallocuvm>
8010430f:	83 c4 10             	add    $0x10,%esp
80104312:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104319:	75 07                	jne    80104322 <growproc+0x7f>
      return -1;
8010431b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104320:	eb 22                	jmp    80104344 <growproc+0xa1>
  }
  proc->sz = sz;
80104322:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104328:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010432b:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010432d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	50                   	push   %eax
80104337:	e8 ad 36 00 00       	call   801079e9 <switchuvm>
8010433c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010433f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104344:	c9                   	leave  
80104345:	c3                   	ret    

80104346 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104346:	55                   	push   %ebp
80104347:	89 e5                	mov    %esp,%ebp
80104349:	57                   	push   %edi
8010434a:	56                   	push   %esi
8010434b:	53                   	push   %ebx
8010434c:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010434f:	e8 2e fd ff ff       	call   80104082 <allocproc>
80104354:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104357:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010435b:	75 0a                	jne    80104367 <fork+0x21>
    return -1;
8010435d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104362:	e9 48 01 00 00       	jmp    801044af <fork+0x169>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104367:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010436d:	8b 10                	mov    (%eax),%edx
8010436f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104375:	8b 40 04             	mov    0x4(%eax),%eax
80104378:	83 ec 08             	sub    $0x8,%esp
8010437b:	52                   	push   %edx
8010437c:	50                   	push   %eax
8010437d:	e8 8e 3b 00 00       	call   80107f10 <copyuvm>
80104382:	83 c4 10             	add    $0x10,%esp
80104385:	89 c2                	mov    %eax,%edx
80104387:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438a:	89 50 04             	mov    %edx,0x4(%eax)
8010438d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104390:	8b 40 04             	mov    0x4(%eax),%eax
80104393:	85 c0                	test   %eax,%eax
80104395:	75 30                	jne    801043c7 <fork+0x81>
    kfree(np->kstack);
80104397:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010439a:	8b 40 08             	mov    0x8(%eax),%eax
8010439d:	83 ec 0c             	sub    $0xc,%esp
801043a0:	50                   	push   %eax
801043a1:	e8 7d e7 ff ff       	call   80102b23 <kfree>
801043a6:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801043a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801043b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801043bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c2:	e9 e8 00 00 00       	jmp    801044af <fork+0x169>
  }
  np->sz = proc->sz;
801043c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043cd:	8b 10                	mov    (%eax),%edx
801043cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d2:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801043d4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043de:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801043e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043e4:	8b 50 18             	mov    0x18(%eax),%edx
801043e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ed:	8b 40 18             	mov    0x18(%eax),%eax
801043f0:	89 c3                	mov    %eax,%ebx
801043f2:	b8 13 00 00 00       	mov    $0x13,%eax
801043f7:	89 d7                	mov    %edx,%edi
801043f9:	89 de                	mov    %ebx,%esi
801043fb:	89 c1                	mov    %eax,%ecx
801043fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104402:	8b 40 18             	mov    0x18(%eax),%eax
80104405:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010440c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104413:	eb 43                	jmp    80104458 <fork+0x112>
    if(proc->ofile[i])
80104415:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010441b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010441e:	83 c2 08             	add    $0x8,%edx
80104421:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104425:	85 c0                	test   %eax,%eax
80104427:	74 2b                	je     80104454 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104429:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104432:	83 c2 08             	add    $0x8,%edx
80104435:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104439:	83 ec 0c             	sub    $0xc,%esp
8010443c:	50                   	push   %eax
8010443d:	e8 9e cb ff ff       	call   80100fe0 <filedup>
80104442:	83 c4 10             	add    $0x10,%esp
80104445:	89 c1                	mov    %eax,%ecx
80104447:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010444a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010444d:	83 c2 08             	add    $0x8,%edx
80104450:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104454:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104458:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010445c:	7e b7                	jle    80104415 <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010445e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104464:	8b 40 68             	mov    0x68(%eax),%eax
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	50                   	push   %eax
8010446b:	e8 5c d4 ff ff       	call   801018cc <idup>
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	89 c2                	mov    %eax,%edx
80104475:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104478:	89 50 68             	mov    %edx,0x68(%eax)
 
  pid = np->pid;
8010447b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010447e:	8b 40 10             	mov    0x10(%eax),%eax
80104481:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104484:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104487:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010448e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104494:	8d 50 6c             	lea    0x6c(%eax),%edx
80104497:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010449a:	83 c0 6c             	add    $0x6c,%eax
8010449d:	83 ec 04             	sub    $0x4,%esp
801044a0:	6a 10                	push   $0x10
801044a2:	52                   	push   %edx
801044a3:	50                   	push   %eax
801044a4:	e8 e5 0b 00 00       	call   8010508e <safestrcpy>
801044a9:	83 c4 10             	add    $0x10,%esp
  return pid;
801044ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801044af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044b2:	5b                   	pop    %ebx
801044b3:	5e                   	pop    %esi
801044b4:	5f                   	pop    %edi
801044b5:	5d                   	pop    %ebp
801044b6:	c3                   	ret    

801044b7 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801044b7:	55                   	push   %ebp
801044b8:	89 e5                	mov    %esp,%ebp
801044ba:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801044bd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044c4:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801044c9:	39 c2                	cmp    %eax,%edx
801044cb:	75 0d                	jne    801044da <exit+0x23>
    panic("init exiting");
801044cd:	83 ec 0c             	sub    $0xc,%esp
801044d0:	68 07 84 10 80       	push   $0x80108407
801044d5:	e8 8c c0 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801044e1:	eb 48                	jmp    8010452b <exit+0x74>
    if(proc->ofile[fd]){
801044e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044ec:	83 c2 08             	add    $0x8,%edx
801044ef:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044f3:	85 c0                	test   %eax,%eax
801044f5:	74 30                	je     80104527 <exit+0x70>
      fileclose(proc->ofile[fd]);
801044f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104500:	83 c2 08             	add    $0x8,%edx
80104503:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	50                   	push   %eax
8010450b:	e8 21 cb ff ff       	call   80101031 <fileclose>
80104510:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104513:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104519:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010451c:	83 c2 08             	add    $0x8,%edx
8010451f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104526:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104527:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010452b:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010452f:	7e b2                	jle    801044e3 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104531:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104537:	8b 40 68             	mov    0x68(%eax),%eax
8010453a:	83 ec 0c             	sub    $0xc,%esp
8010453d:	50                   	push   %eax
8010453e:	e8 8d d5 ff ff       	call   80101ad0 <iput>
80104543:	83 c4 10             	add    $0x10,%esp
  proc->cwd = 0;
80104546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010454c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	68 20 ff 10 80       	push   $0x8010ff20
8010455b:	e8 c8 06 00 00       	call   80104c28 <acquire>
80104560:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104563:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104569:	8b 40 14             	mov    0x14(%eax),%eax
8010456c:	83 ec 0c             	sub    $0xc,%esp
8010456f:	50                   	push   %eax
80104570:	e8 0d 04 00 00       	call   80104982 <wakeup1>
80104575:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104578:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010457f:	eb 3c                	jmp    801045bd <exit+0x106>
    if(p->parent == proc){
80104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104584:	8b 50 14             	mov    0x14(%eax),%edx
80104587:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458d:	39 c2                	cmp    %eax,%edx
8010458f:	75 28                	jne    801045b9 <exit+0x102>
      p->parent = initproc;
80104591:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459a:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a0:	8b 40 0c             	mov    0xc(%eax),%eax
801045a3:	83 f8 05             	cmp    $0x5,%eax
801045a6:	75 11                	jne    801045b9 <exit+0x102>
        wakeup1(initproc);
801045a8:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801045ad:	83 ec 0c             	sub    $0xc,%esp
801045b0:	50                   	push   %eax
801045b1:	e8 cc 03 00 00       	call   80104982 <wakeup1>
801045b6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b9:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045bd:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801045c4:	72 bb                	jb     80104581 <exit+0xca>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801045c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045cc:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801045d3:	e8 d6 01 00 00       	call   801047ae <sched>
  panic("zombie exit");
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	68 14 84 10 80       	push   $0x80108414
801045e0:	e8 81 bf ff ff       	call   80100566 <panic>

801045e5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801045e5:	55                   	push   %ebp
801045e6:	89 e5                	mov    %esp,%ebp
801045e8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801045eb:	83 ec 0c             	sub    $0xc,%esp
801045ee:	68 20 ff 10 80       	push   $0x8010ff20
801045f3:	e8 30 06 00 00       	call   80104c28 <acquire>
801045f8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801045fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104602:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104609:	e9 a6 00 00 00       	jmp    801046b4 <wait+0xcf>
      if(p->parent != proc)
8010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104611:	8b 50 14             	mov    0x14(%eax),%edx
80104614:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461a:	39 c2                	cmp    %eax,%edx
8010461c:	0f 85 8d 00 00 00    	jne    801046af <wait+0xca>
        continue;
      havekids = 1;
80104622:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462c:	8b 40 0c             	mov    0xc(%eax),%eax
8010462f:	83 f8 05             	cmp    $0x5,%eax
80104632:	75 7c                	jne    801046b0 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	8b 40 10             	mov    0x10(%eax),%eax
8010463a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010463d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104640:	8b 40 08             	mov    0x8(%eax),%eax
80104643:	83 ec 0c             	sub    $0xc,%esp
80104646:	50                   	push   %eax
80104647:	e8 d7 e4 ff ff       	call   80102b23 <kfree>
8010464c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465c:	8b 40 04             	mov    0x4(%eax),%eax
8010465f:	83 ec 0c             	sub    $0xc,%esp
80104662:	50                   	push   %eax
80104663:	e8 c7 37 00 00       	call   80107e2f <freevm>
80104668:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
8010466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104682:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104693:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	68 20 ff 10 80       	push   $0x8010ff20
801046a2:	e8 e8 05 00 00       	call   80104c8f <release>
801046a7:	83 c4 10             	add    $0x10,%esp
        return pid;
801046aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ad:	eb 58                	jmp    80104707 <wait+0x122>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
801046af:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b0:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801046b4:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801046bb:	0f 82 4d ff ff ff    	jb     8010460e <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801046c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801046c5:	74 0d                	je     801046d4 <wait+0xef>
801046c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cd:	8b 40 24             	mov    0x24(%eax),%eax
801046d0:	85 c0                	test   %eax,%eax
801046d2:	74 17                	je     801046eb <wait+0x106>
      release(&ptable.lock);
801046d4:	83 ec 0c             	sub    $0xc,%esp
801046d7:	68 20 ff 10 80       	push   $0x8010ff20
801046dc:	e8 ae 05 00 00       	call   80104c8f <release>
801046e1:	83 c4 10             	add    $0x10,%esp
      return -1;
801046e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e9:	eb 1c                	jmp    80104707 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801046eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f1:	83 ec 08             	sub    $0x8,%esp
801046f4:	68 20 ff 10 80       	push   $0x8010ff20
801046f9:	50                   	push   %eax
801046fa:	e8 d7 01 00 00       	call   801048d6 <sleep>
801046ff:	83 c4 10             	add    $0x10,%esp
  }
80104702:	e9 f4 fe ff ff       	jmp    801045fb <wait+0x16>
}
80104707:	c9                   	leave  
80104708:	c3                   	ret    

80104709 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104709:	55                   	push   %ebp
8010470a:	89 e5                	mov    %esp,%ebp
8010470c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
8010470f:	e8 49 f9 ff ff       	call   8010405d <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	68 20 ff 10 80       	push   $0x8010ff20
8010471c:	e8 07 05 00 00       	call   80104c28 <acquire>
80104721:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104724:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010472b:	eb 63                	jmp    80104790 <scheduler+0x87>
      if(p->state != RUNNABLE)
8010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104730:	8b 40 0c             	mov    0xc(%eax),%eax
80104733:	83 f8 03             	cmp    $0x3,%eax
80104736:	75 53                	jne    8010478b <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104741:	83 ec 0c             	sub    $0xc,%esp
80104744:	ff 75 f4             	pushl  -0xc(%ebp)
80104747:	e8 9d 32 00 00       	call   801079e9 <switchuvm>
8010474c:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
8010474f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104752:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104759:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010475f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104762:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104769:	83 c2 04             	add    $0x4,%edx
8010476c:	83 ec 08             	sub    $0x8,%esp
8010476f:	50                   	push   %eax
80104770:	52                   	push   %edx
80104771:	e8 89 09 00 00       	call   801050ff <swtch>
80104776:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104779:	e8 4e 32 00 00       	call   801079cc <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010477e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104785:	00 00 00 00 
80104789:	eb 01                	jmp    8010478c <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
8010478b:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010478c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104790:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104797:	72 94                	jb     8010472d <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104799:	83 ec 0c             	sub    $0xc,%esp
8010479c:	68 20 ff 10 80       	push   $0x8010ff20
801047a1:	e8 e9 04 00 00       	call   80104c8f <release>
801047a6:	83 c4 10             	add    $0x10,%esp

  }
801047a9:	e9 61 ff ff ff       	jmp    8010470f <scheduler+0x6>

801047ae <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801047ae:	55                   	push   %ebp
801047af:	89 e5                	mov    %esp,%ebp
801047b1:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 20 ff 10 80       	push   $0x8010ff20
801047bc:	e8 9a 05 00 00       	call   80104d5b <holding>
801047c1:	83 c4 10             	add    $0x10,%esp
801047c4:	85 c0                	test   %eax,%eax
801047c6:	75 0d                	jne    801047d5 <sched+0x27>
    panic("sched ptable.lock");
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	68 20 84 10 80       	push   $0x80108420
801047d0:	e8 91 bd ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
801047d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047db:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801047e1:	83 f8 01             	cmp    $0x1,%eax
801047e4:	74 0d                	je     801047f3 <sched+0x45>
    panic("sched locks");
801047e6:	83 ec 0c             	sub    $0xc,%esp
801047e9:	68 32 84 10 80       	push   $0x80108432
801047ee:	e8 73 bd ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
801047f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f9:	8b 40 0c             	mov    0xc(%eax),%eax
801047fc:	83 f8 04             	cmp    $0x4,%eax
801047ff:	75 0d                	jne    8010480e <sched+0x60>
    panic("sched running");
80104801:	83 ec 0c             	sub    $0xc,%esp
80104804:	68 3e 84 10 80       	push   $0x8010843e
80104809:	e8 58 bd ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010480e:	e8 3a f8 ff ff       	call   8010404d <readeflags>
80104813:	25 00 02 00 00       	and    $0x200,%eax
80104818:	85 c0                	test   %eax,%eax
8010481a:	74 0d                	je     80104829 <sched+0x7b>
    panic("sched interruptible");
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 4c 84 10 80       	push   $0x8010844c
80104824:	e8 3d bd ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104829:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010482f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104838:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010483e:	8b 40 04             	mov    0x4(%eax),%eax
80104841:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104848:	83 c2 1c             	add    $0x1c,%edx
8010484b:	83 ec 08             	sub    $0x8,%esp
8010484e:	50                   	push   %eax
8010484f:	52                   	push   %edx
80104850:	e8 aa 08 00 00       	call   801050ff <swtch>
80104855:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104858:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010485e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104861:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104867:	90                   	nop
80104868:	c9                   	leave  
80104869:	c3                   	ret    

8010486a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010486a:	55                   	push   %ebp
8010486b:	89 e5                	mov    %esp,%ebp
8010486d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	68 20 ff 10 80       	push   $0x8010ff20
80104878:	e8 ab 03 00 00       	call   80104c28 <acquire>
8010487d:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104880:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104886:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010488d:	e8 1c ff ff ff       	call   801047ae <sched>
  release(&ptable.lock);
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 20 ff 10 80       	push   $0x8010ff20
8010489a:	e8 f0 03 00 00       	call   80104c8f <release>
8010489f:	83 c4 10             	add    $0x10,%esp
}
801048a2:	90                   	nop
801048a3:	c9                   	leave  
801048a4:	c3                   	ret    

801048a5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801048a5:	55                   	push   %ebp
801048a6:	89 e5                	mov    %esp,%ebp
801048a8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801048ab:	83 ec 0c             	sub    $0xc,%esp
801048ae:	68 20 ff 10 80       	push   $0x8010ff20
801048b3:	e8 d7 03 00 00       	call   80104c8f <release>
801048b8:	83 c4 10             	add    $0x10,%esp

  if (first) {
801048bb:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801048c0:	85 c0                	test   %eax,%eax
801048c2:	74 0f                	je     801048d3 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801048c4:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
801048cb:	00 00 00 
    initlog();
801048ce:	e8 9e e7 ff ff       	call   80103071 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801048d3:	90                   	nop
801048d4:	c9                   	leave  
801048d5:	c3                   	ret    

801048d6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801048d6:	55                   	push   %ebp
801048d7:	89 e5                	mov    %esp,%ebp
801048d9:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801048dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e2:	85 c0                	test   %eax,%eax
801048e4:	75 0d                	jne    801048f3 <sleep+0x1d>
    panic("sleep");
801048e6:	83 ec 0c             	sub    $0xc,%esp
801048e9:	68 60 84 10 80       	push   $0x80108460
801048ee:	e8 73 bc ff ff       	call   80100566 <panic>

  if(lk == 0)
801048f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801048f7:	75 0d                	jne    80104906 <sleep+0x30>
    panic("sleep without lk");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 66 84 10 80       	push   $0x80108466
80104901:	e8 60 bc ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104906:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010490d:	74 1e                	je     8010492d <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010490f:	83 ec 0c             	sub    $0xc,%esp
80104912:	68 20 ff 10 80       	push   $0x8010ff20
80104917:	e8 0c 03 00 00       	call   80104c28 <acquire>
8010491c:	83 c4 10             	add    $0x10,%esp
    release(lk);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	ff 75 0c             	pushl  0xc(%ebp)
80104925:	e8 65 03 00 00       	call   80104c8f <release>
8010492a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010492d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104933:	8b 55 08             	mov    0x8(%ebp),%edx
80104936:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104946:	e8 63 fe ff ff       	call   801047ae <sched>

  // Tidy up.
  proc->chan = 0;
8010494b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104951:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104958:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010495f:	74 1e                	je     8010497f <sleep+0xa9>
    release(&ptable.lock);
80104961:	83 ec 0c             	sub    $0xc,%esp
80104964:	68 20 ff 10 80       	push   $0x8010ff20
80104969:	e8 21 03 00 00       	call   80104c8f <release>
8010496e:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104971:	83 ec 0c             	sub    $0xc,%esp
80104974:	ff 75 0c             	pushl  0xc(%ebp)
80104977:	e8 ac 02 00 00       	call   80104c28 <acquire>
8010497c:	83 c4 10             	add    $0x10,%esp
  }
}
8010497f:	90                   	nop
80104980:	c9                   	leave  
80104981:	c3                   	ret    

80104982 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104982:	55                   	push   %ebp
80104983:	89 e5                	mov    %esp,%ebp
80104985:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104988:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
8010498f:	eb 24                	jmp    801049b5 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104991:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104994:	8b 40 0c             	mov    0xc(%eax),%eax
80104997:	83 f8 02             	cmp    $0x2,%eax
8010499a:	75 15                	jne    801049b1 <wakeup1+0x2f>
8010499c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010499f:	8b 40 20             	mov    0x20(%eax),%eax
801049a2:	3b 45 08             	cmp    0x8(%ebp),%eax
801049a5:	75 0a                	jne    801049b1 <wakeup1+0x2f>
      p->state = RUNNABLE;
801049a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049aa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049b1:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
801049b5:	81 7d fc 54 1e 11 80 	cmpl   $0x80111e54,-0x4(%ebp)
801049bc:	72 d3                	jb     80104991 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801049be:	90                   	nop
801049bf:	c9                   	leave  
801049c0:	c3                   	ret    

801049c1 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049c1:	55                   	push   %ebp
801049c2:	89 e5                	mov    %esp,%ebp
801049c4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801049c7:	83 ec 0c             	sub    $0xc,%esp
801049ca:	68 20 ff 10 80       	push   $0x8010ff20
801049cf:	e8 54 02 00 00       	call   80104c28 <acquire>
801049d4:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801049d7:	83 ec 0c             	sub    $0xc,%esp
801049da:	ff 75 08             	pushl  0x8(%ebp)
801049dd:	e8 a0 ff ff ff       	call   80104982 <wakeup1>
801049e2:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801049e5:	83 ec 0c             	sub    $0xc,%esp
801049e8:	68 20 ff 10 80       	push   $0x8010ff20
801049ed:	e8 9d 02 00 00       	call   80104c8f <release>
801049f2:	83 c4 10             	add    $0x10,%esp
}
801049f5:	90                   	nop
801049f6:	c9                   	leave  
801049f7:	c3                   	ret    

801049f8 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049f8:	55                   	push   %ebp
801049f9:	89 e5                	mov    %esp,%ebp
801049fb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801049fe:	83 ec 0c             	sub    $0xc,%esp
80104a01:	68 20 ff 10 80       	push   $0x8010ff20
80104a06:	e8 1d 02 00 00       	call   80104c28 <acquire>
80104a0b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a0e:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104a15:	eb 45                	jmp    80104a5c <kill+0x64>
    if(p->pid == pid){
80104a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1a:	8b 40 10             	mov    0x10(%eax),%eax
80104a1d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a20:	75 36                	jne    80104a58 <kill+0x60>
      p->killed = 1;
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2f:	8b 40 0c             	mov    0xc(%eax),%eax
80104a32:	83 f8 02             	cmp    $0x2,%eax
80104a35:	75 0a                	jne    80104a41 <kill+0x49>
        p->state = RUNNABLE;
80104a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a41:	83 ec 0c             	sub    $0xc,%esp
80104a44:	68 20 ff 10 80       	push   $0x8010ff20
80104a49:	e8 41 02 00 00       	call   80104c8f <release>
80104a4e:	83 c4 10             	add    $0x10,%esp
      return 0;
80104a51:	b8 00 00 00 00       	mov    $0x0,%eax
80104a56:	eb 22                	jmp    80104a7a <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a58:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a5c:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104a63:	72 b2                	jb     80104a17 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104a65:	83 ec 0c             	sub    $0xc,%esp
80104a68:	68 20 ff 10 80       	push   $0x8010ff20
80104a6d:	e8 1d 02 00 00       	call   80104c8f <release>
80104a72:	83 c4 10             	add    $0x10,%esp
  return -1;
80104a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a7a:	c9                   	leave  
80104a7b:	c3                   	ret    

80104a7c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a7c:	55                   	push   %ebp
80104a7d:	89 e5                	mov    %esp,%ebp
80104a7f:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a82:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104a89:	e9 d7 00 00 00       	jmp    80104b65 <procdump+0xe9>
    if(p->state == UNUSED)
80104a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a91:	8b 40 0c             	mov    0xc(%eax),%eax
80104a94:	85 c0                	test   %eax,%eax
80104a96:	0f 84 c4 00 00 00    	je     80104b60 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9f:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa2:	83 f8 05             	cmp    $0x5,%eax
80104aa5:	77 23                	ja     80104aca <procdump+0x4e>
80104aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aaa:	8b 40 0c             	mov    0xc(%eax),%eax
80104aad:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104ab4:	85 c0                	test   %eax,%eax
80104ab6:	74 12                	je     80104aca <procdump+0x4e>
      state = states[p->state];
80104ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104abb:	8b 40 0c             	mov    0xc(%eax),%eax
80104abe:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ac8:	eb 07                	jmp    80104ad1 <procdump+0x55>
    else
      state = "???";
80104aca:	c7 45 ec 77 84 10 80 	movl   $0x80108477,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad4:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ada:	8b 40 10             	mov    0x10(%eax),%eax
80104add:	52                   	push   %edx
80104ade:	ff 75 ec             	pushl  -0x14(%ebp)
80104ae1:	50                   	push   %eax
80104ae2:	68 7b 84 10 80       	push   $0x8010847b
80104ae7:	e8 da b8 ff ff       	call   801003c6 <cprintf>
80104aec:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af2:	8b 40 0c             	mov    0xc(%eax),%eax
80104af5:	83 f8 02             	cmp    $0x2,%eax
80104af8:	75 54                	jne    80104b4e <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b00:	8b 40 0c             	mov    0xc(%eax),%eax
80104b03:	83 c0 08             	add    $0x8,%eax
80104b06:	89 c2                	mov    %eax,%edx
80104b08:	83 ec 08             	sub    $0x8,%esp
80104b0b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104b0e:	50                   	push   %eax
80104b0f:	52                   	push   %edx
80104b10:	e8 cc 01 00 00       	call   80104ce1 <getcallerpcs>
80104b15:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104b18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b1f:	eb 1c                	jmp    80104b3d <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b24:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b28:	83 ec 08             	sub    $0x8,%esp
80104b2b:	50                   	push   %eax
80104b2c:	68 84 84 10 80       	push   $0x80108484
80104b31:	e8 90 b8 ff ff       	call   801003c6 <cprintf>
80104b36:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104b39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104b3d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104b41:	7f 0b                	jg     80104b4e <procdump+0xd2>
80104b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b46:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	75 d3                	jne    80104b21 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	68 88 84 10 80       	push   $0x80108488
80104b56:	e8 6b b8 ff ff       	call   801003c6 <cprintf>
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	eb 01                	jmp    80104b61 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104b60:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b61:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104b65:	81 7d f0 54 1e 11 80 	cmpl   $0x80111e54,-0x10(%ebp)
80104b6c:	0f 82 1c ff ff ff    	jb     80104a8e <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104b72:	90                   	nop
80104b73:	c9                   	leave  
80104b74:	c3                   	ret    

80104b75 <sleep_proc_list>:

// the function of listing sleeping processes
// made by Shaun Fong
void sleep_proc_list(void){
80104b75:	55                   	push   %ebp
80104b76:	89 e5                	mov    %esp,%ebp
80104b78:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b7b:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104b82:	eb 3e                	jmp    80104bc2 <sleep_proc_list+0x4d>
        if(p->state == UNUSED)
80104b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b87:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8a:	85 c0                	test   %eax,%eax
80104b8c:	74 2f                	je     80104bbd <sleep_proc_list+0x48>
            continue;
        
        if(p->state == SLEEPING){
80104b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b91:	8b 40 0c             	mov    0xc(%eax),%eax
80104b94:	83 f8 02             	cmp    $0x2,%eax
80104b97:	75 25                	jne    80104bbe <sleep_proc_list+0x49>
            cprintf("SLEEPING PROC: %s.  ID: %d.     CHAN ADDR: %p\n", p->name, p->pid, p->chan);
80104b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9c:	8b 50 20             	mov    0x20(%eax),%edx
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	8b 40 10             	mov    0x10(%eax),%eax
80104ba5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104ba8:	83 c1 6c             	add    $0x6c,%ecx
80104bab:	52                   	push   %edx
80104bac:	50                   	push   %eax
80104bad:	51                   	push   %ecx
80104bae:	68 8c 84 10 80       	push   $0x8010848c
80104bb3:	e8 0e b8 ff ff       	call   801003c6 <cprintf>
80104bb8:	83 c4 10             	add    $0x10,%esp
80104bbb:	eb 01                	jmp    80104bbe <sleep_proc_list+0x49>
// made by Shaun Fong
void sleep_proc_list(void){
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80104bbd:	90                   	nop

// the function of listing sleeping processes
// made by Shaun Fong
void sleep_proc_list(void){
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bbe:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104bc2:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104bc9:	72 b9                	jb     80104b84 <sleep_proc_list+0xf>
        
        if(p->state == SLEEPING){
            cprintf("SLEEPING PROC: %s.  ID: %d.     CHAN ADDR: %p\n", p->name, p->pid, p->chan);
        }
    }
}
80104bcb:	90                   	nop
80104bcc:	c9                   	leave  
80104bcd:	c3                   	ret    

80104bce <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104bce:	55                   	push   %ebp
80104bcf:	89 e5                	mov    %esp,%ebp
80104bd1:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bd4:	9c                   	pushf  
80104bd5:	58                   	pop    %eax
80104bd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104bdc:	c9                   	leave  
80104bdd:	c3                   	ret    

80104bde <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104bde:	55                   	push   %ebp
80104bdf:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104be1:	fa                   	cli    
}
80104be2:	90                   	nop
80104be3:	5d                   	pop    %ebp
80104be4:	c3                   	ret    

80104be5 <sti>:

static inline void
sti(void)
{
80104be5:	55                   	push   %ebp
80104be6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104be8:	fb                   	sti    
}
80104be9:	90                   	nop
80104bea:	5d                   	pop    %ebp
80104beb:	c3                   	ret    

80104bec <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104bec:	55                   	push   %ebp
80104bed:	89 e5                	mov    %esp,%ebp
80104bef:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104bf2:	8b 55 08             	mov    0x8(%ebp),%edx
80104bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bfb:	f0 87 02             	lock xchg %eax,(%edx)
80104bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c04:	c9                   	leave  
80104c05:	c3                   	ret    

80104c06 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c06:	55                   	push   %ebp
80104c07:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104c09:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c0f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104c12:	8b 45 08             	mov    0x8(%ebp),%eax
80104c15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c25:	90                   	nop
80104c26:	5d                   	pop    %ebp
80104c27:	c3                   	ret    

80104c28 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c28:	55                   	push   %ebp
80104c29:	89 e5                	mov    %esp,%ebp
80104c2b:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c2e:	e8 52 01 00 00       	call   80104d85 <pushcli>
  if(holding(lk))
80104c33:	8b 45 08             	mov    0x8(%ebp),%eax
80104c36:	83 ec 0c             	sub    $0xc,%esp
80104c39:	50                   	push   %eax
80104c3a:	e8 1c 01 00 00       	call   80104d5b <holding>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	74 0d                	je     80104c53 <acquire+0x2b>
    panic("acquire");
80104c46:	83 ec 0c             	sub    $0xc,%esp
80104c49:	68 e5 84 10 80       	push   $0x801084e5
80104c4e:	e8 13 b9 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104c53:	90                   	nop
80104c54:	8b 45 08             	mov    0x8(%ebp),%eax
80104c57:	83 ec 08             	sub    $0x8,%esp
80104c5a:	6a 01                	push   $0x1
80104c5c:	50                   	push   %eax
80104c5d:	e8 8a ff ff ff       	call   80104bec <xchg>
80104c62:	83 c4 10             	add    $0x10,%esp
80104c65:	85 c0                	test   %eax,%eax
80104c67:	75 eb                	jne    80104c54 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c69:	8b 45 08             	mov    0x8(%ebp),%eax
80104c6c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c73:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104c76:	8b 45 08             	mov    0x8(%ebp),%eax
80104c79:	83 c0 0c             	add    $0xc,%eax
80104c7c:	83 ec 08             	sub    $0x8,%esp
80104c7f:	50                   	push   %eax
80104c80:	8d 45 08             	lea    0x8(%ebp),%eax
80104c83:	50                   	push   %eax
80104c84:	e8 58 00 00 00       	call   80104ce1 <getcallerpcs>
80104c89:	83 c4 10             	add    $0x10,%esp
}
80104c8c:	90                   	nop
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    

80104c8f <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104c8f:	55                   	push   %ebp
80104c90:	89 e5                	mov    %esp,%ebp
80104c92:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	ff 75 08             	pushl  0x8(%ebp)
80104c9b:	e8 bb 00 00 00       	call   80104d5b <holding>
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	85 c0                	test   %eax,%eax
80104ca5:	75 0d                	jne    80104cb4 <release+0x25>
    panic("release");
80104ca7:	83 ec 0c             	sub    $0xc,%esp
80104caa:	68 ed 84 10 80       	push   $0x801084ed
80104caf:	e8 b2 b8 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80104cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ccb:	83 ec 08             	sub    $0x8,%esp
80104cce:	6a 00                	push   $0x0
80104cd0:	50                   	push   %eax
80104cd1:	e8 16 ff ff ff       	call   80104bec <xchg>
80104cd6:	83 c4 10             	add    $0x10,%esp

  popcli();
80104cd9:	e8 ec 00 00 00       	call   80104dca <popcli>
}
80104cde:	90                   	nop
80104cdf:	c9                   	leave  
80104ce0:	c3                   	ret    

80104ce1 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ce1:	55                   	push   %ebp
80104ce2:	89 e5                	mov    %esp,%ebp
80104ce4:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cea:	83 e8 08             	sub    $0x8,%eax
80104ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104cf0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104cf7:	eb 38                	jmp    80104d31 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104cfd:	74 53                	je     80104d52 <getcallerpcs+0x71>
80104cff:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104d06:	76 4a                	jbe    80104d52 <getcallerpcs+0x71>
80104d08:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104d0c:	74 44                	je     80104d52 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d18:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1b:	01 c2                	add    %eax,%edx
80104d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d20:	8b 40 04             	mov    0x4(%eax),%eax
80104d23:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d28:	8b 00                	mov    (%eax),%eax
80104d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d2d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104d31:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d35:	7e c2                	jle    80104cf9 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d37:	eb 19                	jmp    80104d52 <getcallerpcs+0x71>
    pcs[i] = 0;
80104d39:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104d43:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d46:	01 d0                	add    %edx,%eax
80104d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d4e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104d52:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d56:	7e e1                	jle    80104d39 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104d58:	90                   	nop
80104d59:	c9                   	leave  
80104d5a:	c3                   	ret    

80104d5b <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d5b:	55                   	push   %ebp
80104d5c:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d61:	8b 00                	mov    (%eax),%eax
80104d63:	85 c0                	test   %eax,%eax
80104d65:	74 17                	je     80104d7e <holding+0x23>
80104d67:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6a:	8b 50 08             	mov    0x8(%eax),%edx
80104d6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d73:	39 c2                	cmp    %eax,%edx
80104d75:	75 07                	jne    80104d7e <holding+0x23>
80104d77:	b8 01 00 00 00       	mov    $0x1,%eax
80104d7c:	eb 05                	jmp    80104d83 <holding+0x28>
80104d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d83:	5d                   	pop    %ebp
80104d84:	c3                   	ret    

80104d85 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d85:	55                   	push   %ebp
80104d86:	89 e5                	mov    %esp,%ebp
80104d88:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104d8b:	e8 3e fe ff ff       	call   80104bce <readeflags>
80104d90:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104d93:	e8 46 fe ff ff       	call   80104bde <cli>
  if(cpu->ncli++ == 0)
80104d98:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d9f:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104da5:	8d 48 01             	lea    0x1(%eax),%ecx
80104da8:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104dae:	85 c0                	test   %eax,%eax
80104db0:	75 15                	jne    80104dc7 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104db2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104db8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dbb:	81 e2 00 02 00 00    	and    $0x200,%edx
80104dc1:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dc7:	90                   	nop
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    

80104dca <popcli>:

void
popcli(void)
{
80104dca:	55                   	push   %ebp
80104dcb:	89 e5                	mov    %esp,%ebp
80104dcd:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104dd0:	e8 f9 fd ff ff       	call   80104bce <readeflags>
80104dd5:	25 00 02 00 00       	and    $0x200,%eax
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	74 0d                	je     80104deb <popcli+0x21>
    panic("popcli - interruptible");
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	68 f5 84 10 80       	push   $0x801084f5
80104de6:	e8 7b b7 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80104deb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df1:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104df7:	83 ea 01             	sub    $0x1,%edx
80104dfa:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e00:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e06:	85 c0                	test   %eax,%eax
80104e08:	79 0d                	jns    80104e17 <popcli+0x4d>
    panic("popcli");
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	68 0c 85 10 80       	push   $0x8010850c
80104e12:	e8 4f b7 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104e17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e1d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e23:	85 c0                	test   %eax,%eax
80104e25:	75 15                	jne    80104e3c <popcli+0x72>
80104e27:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e2d:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e33:	85 c0                	test   %eax,%eax
80104e35:	74 05                	je     80104e3c <popcli+0x72>
    sti();
80104e37:	e8 a9 fd ff ff       	call   80104be5 <sti>
}
80104e3c:	90                   	nop
80104e3d:	c9                   	leave  
80104e3e:	c3                   	ret    

80104e3f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104e3f:	55                   	push   %ebp
80104e40:	89 e5                	mov    %esp,%ebp
80104e42:	57                   	push   %edi
80104e43:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104e44:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e47:	8b 55 10             	mov    0x10(%ebp),%edx
80104e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4d:	89 cb                	mov    %ecx,%ebx
80104e4f:	89 df                	mov    %ebx,%edi
80104e51:	89 d1                	mov    %edx,%ecx
80104e53:	fc                   	cld    
80104e54:	f3 aa                	rep stos %al,%es:(%edi)
80104e56:	89 ca                	mov    %ecx,%edx
80104e58:	89 fb                	mov    %edi,%ebx
80104e5a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e5d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e60:	90                   	nop
80104e61:	5b                   	pop    %ebx
80104e62:	5f                   	pop    %edi
80104e63:	5d                   	pop    %ebp
80104e64:	c3                   	ret    

80104e65 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104e65:	55                   	push   %ebp
80104e66:	89 e5                	mov    %esp,%ebp
80104e68:	57                   	push   %edi
80104e69:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104e6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e6d:	8b 55 10             	mov    0x10(%ebp),%edx
80104e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e73:	89 cb                	mov    %ecx,%ebx
80104e75:	89 df                	mov    %ebx,%edi
80104e77:	89 d1                	mov    %edx,%ecx
80104e79:	fc                   	cld    
80104e7a:	f3 ab                	rep stos %eax,%es:(%edi)
80104e7c:	89 ca                	mov    %ecx,%edx
80104e7e:	89 fb                	mov    %edi,%ebx
80104e80:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e86:	90                   	nop
80104e87:	5b                   	pop    %ebx
80104e88:	5f                   	pop    %edi
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    

80104e8b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e8b:	55                   	push   %ebp
80104e8c:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e91:	83 e0 03             	and    $0x3,%eax
80104e94:	85 c0                	test   %eax,%eax
80104e96:	75 43                	jne    80104edb <memset+0x50>
80104e98:	8b 45 10             	mov    0x10(%ebp),%eax
80104e9b:	83 e0 03             	and    $0x3,%eax
80104e9e:	85 c0                	test   %eax,%eax
80104ea0:	75 39                	jne    80104edb <memset+0x50>
    c &= 0xFF;
80104ea2:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ea9:	8b 45 10             	mov    0x10(%ebp),%eax
80104eac:	c1 e8 02             	shr    $0x2,%eax
80104eaf:	89 c1                	mov    %eax,%ecx
80104eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eb4:	c1 e0 18             	shl    $0x18,%eax
80104eb7:	89 c2                	mov    %eax,%edx
80104eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebc:	c1 e0 10             	shl    $0x10,%eax
80104ebf:	09 c2                	or     %eax,%edx
80104ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec4:	c1 e0 08             	shl    $0x8,%eax
80104ec7:	09 d0                	or     %edx,%eax
80104ec9:	0b 45 0c             	or     0xc(%ebp),%eax
80104ecc:	51                   	push   %ecx
80104ecd:	50                   	push   %eax
80104ece:	ff 75 08             	pushl  0x8(%ebp)
80104ed1:	e8 8f ff ff ff       	call   80104e65 <stosl>
80104ed6:	83 c4 0c             	add    $0xc,%esp
80104ed9:	eb 12                	jmp    80104eed <memset+0x62>
  } else
    stosb(dst, c, n);
80104edb:	8b 45 10             	mov    0x10(%ebp),%eax
80104ede:	50                   	push   %eax
80104edf:	ff 75 0c             	pushl  0xc(%ebp)
80104ee2:	ff 75 08             	pushl  0x8(%ebp)
80104ee5:	e8 55 ff ff ff       	call   80104e3f <stosb>
80104eea:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104ef0:	c9                   	leave  
80104ef1:	c3                   	ret    

80104ef2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ef2:	55                   	push   %ebp
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80104efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104f04:	eb 30                	jmp    80104f36 <memcmp+0x44>
    if(*s1 != *s2)
80104f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f09:	0f b6 10             	movzbl (%eax),%edx
80104f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f0f:	0f b6 00             	movzbl (%eax),%eax
80104f12:	38 c2                	cmp    %al,%dl
80104f14:	74 18                	je     80104f2e <memcmp+0x3c>
      return *s1 - *s2;
80104f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f19:	0f b6 00             	movzbl (%eax),%eax
80104f1c:	0f b6 d0             	movzbl %al,%edx
80104f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f22:	0f b6 00             	movzbl (%eax),%eax
80104f25:	0f b6 c0             	movzbl %al,%eax
80104f28:	29 c2                	sub    %eax,%edx
80104f2a:	89 d0                	mov    %edx,%eax
80104f2c:	eb 1a                	jmp    80104f48 <memcmp+0x56>
    s1++, s2++;
80104f2e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104f32:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f36:	8b 45 10             	mov    0x10(%ebp),%eax
80104f39:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f3c:	89 55 10             	mov    %edx,0x10(%ebp)
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	75 c3                	jne    80104f06 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f48:	c9                   	leave  
80104f49:	c3                   	ret    

80104f4a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f4a:	55                   	push   %ebp
80104f4b:	89 e5                	mov    %esp,%ebp
80104f4d:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104f50:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104f56:	8b 45 08             	mov    0x8(%ebp),%eax
80104f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f62:	73 54                	jae    80104fb8 <memmove+0x6e>
80104f64:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f67:	8b 45 10             	mov    0x10(%ebp),%eax
80104f6a:	01 d0                	add    %edx,%eax
80104f6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f6f:	76 47                	jbe    80104fb8 <memmove+0x6e>
    s += n;
80104f71:	8b 45 10             	mov    0x10(%ebp),%eax
80104f74:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104f77:	8b 45 10             	mov    0x10(%ebp),%eax
80104f7a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104f7d:	eb 13                	jmp    80104f92 <memmove+0x48>
      *--d = *--s;
80104f7f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104f83:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f8a:	0f b6 10             	movzbl (%eax),%edx
80104f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f90:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104f92:	8b 45 10             	mov    0x10(%ebp),%eax
80104f95:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f98:	89 55 10             	mov    %edx,0x10(%ebp)
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	75 e0                	jne    80104f7f <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f9f:	eb 24                	jmp    80104fc5 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fa4:	8d 50 01             	lea    0x1(%eax),%edx
80104fa7:	89 55 f8             	mov    %edx,-0x8(%ebp)
80104faa:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104fad:	8d 4a 01             	lea    0x1(%edx),%ecx
80104fb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104fb3:	0f b6 12             	movzbl (%edx),%edx
80104fb6:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104fb8:	8b 45 10             	mov    0x10(%ebp),%eax
80104fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fbe:	89 55 10             	mov    %edx,0x10(%ebp)
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	75 dc                	jne    80104fa1 <memmove+0x57>
      *d++ = *s++;

  return dst;
80104fc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104fc8:	c9                   	leave  
80104fc9:	c3                   	ret    

80104fca <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fca:	55                   	push   %ebp
80104fcb:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104fcd:	ff 75 10             	pushl  0x10(%ebp)
80104fd0:	ff 75 0c             	pushl  0xc(%ebp)
80104fd3:	ff 75 08             	pushl  0x8(%ebp)
80104fd6:	e8 6f ff ff ff       	call   80104f4a <memmove>
80104fdb:	83 c4 0c             	add    $0xc,%esp
}
80104fde:	c9                   	leave  
80104fdf:	c3                   	ret    

80104fe0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104fe3:	eb 0c                	jmp    80104ff1 <strncmp+0x11>
    n--, p++, q++;
80104fe5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fe9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104fed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ff5:	74 1a                	je     80105011 <strncmp+0x31>
80104ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80104ffa:	0f b6 00             	movzbl (%eax),%eax
80104ffd:	84 c0                	test   %al,%al
80104fff:	74 10                	je     80105011 <strncmp+0x31>
80105001:	8b 45 08             	mov    0x8(%ebp),%eax
80105004:	0f b6 10             	movzbl (%eax),%edx
80105007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500a:	0f b6 00             	movzbl (%eax),%eax
8010500d:	38 c2                	cmp    %al,%dl
8010500f:	74 d4                	je     80104fe5 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105011:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105015:	75 07                	jne    8010501e <strncmp+0x3e>
    return 0;
80105017:	b8 00 00 00 00       	mov    $0x0,%eax
8010501c:	eb 16                	jmp    80105034 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010501e:	8b 45 08             	mov    0x8(%ebp),%eax
80105021:	0f b6 00             	movzbl (%eax),%eax
80105024:	0f b6 d0             	movzbl %al,%edx
80105027:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502a:	0f b6 00             	movzbl (%eax),%eax
8010502d:	0f b6 c0             	movzbl %al,%eax
80105030:	29 c2                	sub    %eax,%edx
80105032:	89 d0                	mov    %edx,%eax
}
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    

80105036 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105036:	55                   	push   %ebp
80105037:	89 e5                	mov    %esp,%ebp
80105039:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010503c:	8b 45 08             	mov    0x8(%ebp),%eax
8010503f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105042:	90                   	nop
80105043:	8b 45 10             	mov    0x10(%ebp),%eax
80105046:	8d 50 ff             	lea    -0x1(%eax),%edx
80105049:	89 55 10             	mov    %edx,0x10(%ebp)
8010504c:	85 c0                	test   %eax,%eax
8010504e:	7e 2c                	jle    8010507c <strncpy+0x46>
80105050:	8b 45 08             	mov    0x8(%ebp),%eax
80105053:	8d 50 01             	lea    0x1(%eax),%edx
80105056:	89 55 08             	mov    %edx,0x8(%ebp)
80105059:	8b 55 0c             	mov    0xc(%ebp),%edx
8010505c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010505f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105062:	0f b6 12             	movzbl (%edx),%edx
80105065:	88 10                	mov    %dl,(%eax)
80105067:	0f b6 00             	movzbl (%eax),%eax
8010506a:	84 c0                	test   %al,%al
8010506c:	75 d5                	jne    80105043 <strncpy+0xd>
    ;
  while(n-- > 0)
8010506e:	eb 0c                	jmp    8010507c <strncpy+0x46>
    *s++ = 0;
80105070:	8b 45 08             	mov    0x8(%ebp),%eax
80105073:	8d 50 01             	lea    0x1(%eax),%edx
80105076:	89 55 08             	mov    %edx,0x8(%ebp)
80105079:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010507c:	8b 45 10             	mov    0x10(%ebp),%eax
8010507f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105082:	89 55 10             	mov    %edx,0x10(%ebp)
80105085:	85 c0                	test   %eax,%eax
80105087:	7f e7                	jg     80105070 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105089:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010508c:	c9                   	leave  
8010508d:	c3                   	ret    

8010508e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010508e:	55                   	push   %ebp
8010508f:	89 e5                	mov    %esp,%ebp
80105091:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105094:	8b 45 08             	mov    0x8(%ebp),%eax
80105097:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010509a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010509e:	7f 05                	jg     801050a5 <safestrcpy+0x17>
    return os;
801050a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a3:	eb 31                	jmp    801050d6 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801050a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050ad:	7e 1e                	jle    801050cd <safestrcpy+0x3f>
801050af:	8b 45 08             	mov    0x8(%ebp),%eax
801050b2:	8d 50 01             	lea    0x1(%eax),%edx
801050b5:	89 55 08             	mov    %edx,0x8(%ebp)
801050b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801050bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801050be:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801050c1:	0f b6 12             	movzbl (%edx),%edx
801050c4:	88 10                	mov    %dl,(%eax)
801050c6:	0f b6 00             	movzbl (%eax),%eax
801050c9:	84 c0                	test   %al,%al
801050cb:	75 d8                	jne    801050a5 <safestrcpy+0x17>
    ;
  *s = 0;
801050cd:	8b 45 08             	mov    0x8(%ebp),%eax
801050d0:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801050d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050d6:	c9                   	leave  
801050d7:	c3                   	ret    

801050d8 <strlen>:

int
strlen(const char *s)
{
801050d8:	55                   	push   %ebp
801050d9:	89 e5                	mov    %esp,%ebp
801050db:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801050de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801050e5:	eb 04                	jmp    801050eb <strlen+0x13>
801050e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801050eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050ee:	8b 45 08             	mov    0x8(%ebp),%eax
801050f1:	01 d0                	add    %edx,%eax
801050f3:	0f b6 00             	movzbl (%eax),%eax
801050f6:	84 c0                	test   %al,%al
801050f8:	75 ed                	jne    801050e7 <strlen+0xf>
    ;
  return n;
801050fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050fd:	c9                   	leave  
801050fe:	c3                   	ret    

801050ff <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050ff:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105103:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105107:	55                   	push   %ebp
  pushl %ebx
80105108:	53                   	push   %ebx
  pushl %esi
80105109:	56                   	push   %esi
  pushl %edi
8010510a:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010510b:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010510d:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010510f:	5f                   	pop    %edi
  popl %esi
80105110:	5e                   	pop    %esi
  popl %ebx
80105111:	5b                   	pop    %ebx
  popl %ebp
80105112:	5d                   	pop    %ebp
  ret
80105113:	c3                   	ret    

80105114 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105117:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010511d:	8b 00                	mov    (%eax),%eax
8010511f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105122:	76 12                	jbe    80105136 <fetchint+0x22>
80105124:	8b 45 08             	mov    0x8(%ebp),%eax
80105127:	8d 50 04             	lea    0x4(%eax),%edx
8010512a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105130:	8b 00                	mov    (%eax),%eax
80105132:	39 c2                	cmp    %eax,%edx
80105134:	76 07                	jbe    8010513d <fetchint+0x29>
    return -1;
80105136:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513b:	eb 0f                	jmp    8010514c <fetchint+0x38>
  *ip = *(int*)(addr);
8010513d:	8b 45 08             	mov    0x8(%ebp),%eax
80105140:	8b 10                	mov    (%eax),%edx
80105142:	8b 45 0c             	mov    0xc(%ebp),%eax
80105145:	89 10                	mov    %edx,(%eax)
  return 0;
80105147:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    

8010514e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010514e:	55                   	push   %ebp
8010514f:	89 e5                	mov    %esp,%ebp
80105151:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105154:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010515a:	8b 00                	mov    (%eax),%eax
8010515c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010515f:	77 07                	ja     80105168 <fetchstr+0x1a>
    return -1;
80105161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105166:	eb 46                	jmp    801051ae <fetchstr+0x60>
  *pp = (char*)addr;
80105168:	8b 55 08             	mov    0x8(%ebp),%edx
8010516b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010516e:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105170:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105176:	8b 00                	mov    (%eax),%eax
80105178:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010517b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517e:	8b 00                	mov    (%eax),%eax
80105180:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105183:	eb 1c                	jmp    801051a1 <fetchstr+0x53>
    if(*s == 0)
80105185:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105188:	0f b6 00             	movzbl (%eax),%eax
8010518b:	84 c0                	test   %al,%al
8010518d:	75 0e                	jne    8010519d <fetchstr+0x4f>
      return s - *pp;
8010518f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105192:	8b 45 0c             	mov    0xc(%ebp),%eax
80105195:	8b 00                	mov    (%eax),%eax
80105197:	29 c2                	sub    %eax,%edx
80105199:	89 d0                	mov    %edx,%eax
8010519b:	eb 11                	jmp    801051ae <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010519d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051a7:	72 dc                	jb     80105185 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801051a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ae:	c9                   	leave  
801051af:	c3                   	ret    

801051b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801051b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b9:	8b 40 18             	mov    0x18(%eax),%eax
801051bc:	8b 40 44             	mov    0x44(%eax),%eax
801051bf:	8b 55 08             	mov    0x8(%ebp),%edx
801051c2:	c1 e2 02             	shl    $0x2,%edx
801051c5:	01 d0                	add    %edx,%eax
801051c7:	83 c0 04             	add    $0x4,%eax
801051ca:	ff 75 0c             	pushl  0xc(%ebp)
801051cd:	50                   	push   %eax
801051ce:	e8 41 ff ff ff       	call   80105114 <fetchint>
801051d3:	83 c4 08             	add    $0x8,%esp
}
801051d6:	c9                   	leave  
801051d7:	c3                   	ret    

801051d8 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051d8:	55                   	push   %ebp
801051d9:	89 e5                	mov    %esp,%ebp
801051db:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801051de:	8d 45 fc             	lea    -0x4(%ebp),%eax
801051e1:	50                   	push   %eax
801051e2:	ff 75 08             	pushl  0x8(%ebp)
801051e5:	e8 c6 ff ff ff       	call   801051b0 <argint>
801051ea:	83 c4 08             	add    $0x8,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	79 07                	jns    801051f8 <argptr+0x20>
    return -1;
801051f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f6:	eb 3b                	jmp    80105233 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801051f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051fe:	8b 00                	mov    (%eax),%eax
80105200:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105203:	39 d0                	cmp    %edx,%eax
80105205:	76 16                	jbe    8010521d <argptr+0x45>
80105207:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010520a:	89 c2                	mov    %eax,%edx
8010520c:	8b 45 10             	mov    0x10(%ebp),%eax
8010520f:	01 c2                	add    %eax,%edx
80105211:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105217:	8b 00                	mov    (%eax),%eax
80105219:	39 c2                	cmp    %eax,%edx
8010521b:	76 07                	jbe    80105224 <argptr+0x4c>
    return -1;
8010521d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105222:	eb 0f                	jmp    80105233 <argptr+0x5b>
  *pp = (char*)i;
80105224:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105227:	89 c2                	mov    %eax,%edx
80105229:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522c:	89 10                	mov    %edx,(%eax)
  return 0;
8010522e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105233:	c9                   	leave  
80105234:	c3                   	ret    

80105235 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105235:	55                   	push   %ebp
80105236:	89 e5                	mov    %esp,%ebp
80105238:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010523b:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010523e:	50                   	push   %eax
8010523f:	ff 75 08             	pushl  0x8(%ebp)
80105242:	e8 69 ff ff ff       	call   801051b0 <argint>
80105247:	83 c4 08             	add    $0x8,%esp
8010524a:	85 c0                	test   %eax,%eax
8010524c:	79 07                	jns    80105255 <argstr+0x20>
    return -1;
8010524e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105253:	eb 0f                	jmp    80105264 <argstr+0x2f>
  return fetchstr(addr, pp);
80105255:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105258:	ff 75 0c             	pushl  0xc(%ebp)
8010525b:	50                   	push   %eax
8010525c:	e8 ed fe ff ff       	call   8010514e <fetchstr>
80105261:	83 c4 08             	add    $0x8,%esp
}
80105264:	c9                   	leave  
80105265:	c3                   	ret    

80105266 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105266:	55                   	push   %ebp
80105267:	89 e5                	mov    %esp,%ebp
80105269:	53                   	push   %ebx
8010526a:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
8010526d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105273:	8b 40 18             	mov    0x18(%eax),%eax
80105276:	8b 40 1c             	mov    0x1c(%eax),%eax
80105279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010527c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105280:	7e 30                	jle    801052b2 <syscall+0x4c>
80105282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105285:	83 f8 15             	cmp    $0x15,%eax
80105288:	77 28                	ja     801052b2 <syscall+0x4c>
8010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010528d:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105294:	85 c0                	test   %eax,%eax
80105296:	74 1a                	je     801052b2 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105298:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010529e:	8b 58 18             	mov    0x18(%eax),%ebx
801052a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a4:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801052ab:	ff d0                	call   *%eax
801052ad:	89 43 1c             	mov    %eax,0x1c(%ebx)
801052b0:	eb 34                	jmp    801052e6 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801052b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b8:	8d 50 6c             	lea    0x6c(%eax),%edx
801052bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801052c1:	8b 40 10             	mov    0x10(%eax),%eax
801052c4:	ff 75 f4             	pushl  -0xc(%ebp)
801052c7:	52                   	push   %edx
801052c8:	50                   	push   %eax
801052c9:	68 13 85 10 80       	push   $0x80108513
801052ce:	e8 f3 b0 ff ff       	call   801003c6 <cprintf>
801052d3:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801052d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052dc:	8b 40 18             	mov    0x18(%eax),%eax
801052df:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801052e6:	90                   	nop
801052e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    

801052ec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801052ec:	55                   	push   %ebp
801052ed:	89 e5                	mov    %esp,%ebp
801052ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052f2:	83 ec 08             	sub    $0x8,%esp
801052f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f8:	50                   	push   %eax
801052f9:	ff 75 08             	pushl  0x8(%ebp)
801052fc:	e8 af fe ff ff       	call   801051b0 <argint>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	85 c0                	test   %eax,%eax
80105306:	79 07                	jns    8010530f <argfd+0x23>
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	eb 50                	jmp    8010535f <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010530f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105312:	85 c0                	test   %eax,%eax
80105314:	78 21                	js     80105337 <argfd+0x4b>
80105316:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105319:	83 f8 0f             	cmp    $0xf,%eax
8010531c:	7f 19                	jg     80105337 <argfd+0x4b>
8010531e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105324:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105327:	83 c2 08             	add    $0x8,%edx
8010532a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010532e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105335:	75 07                	jne    8010533e <argfd+0x52>
    return -1;
80105337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533c:	eb 21                	jmp    8010535f <argfd+0x73>
  if(pfd)
8010533e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105342:	74 08                	je     8010534c <argfd+0x60>
    *pfd = fd;
80105344:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105347:	8b 45 0c             	mov    0xc(%ebp),%eax
8010534a:	89 10                	mov    %edx,(%eax)
  if(pf)
8010534c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105350:	74 08                	je     8010535a <argfd+0x6e>
    *pf = f;
80105352:	8b 45 10             	mov    0x10(%ebp),%eax
80105355:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105358:	89 10                	mov    %edx,(%eax)
  return 0;
8010535a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010535f:	c9                   	leave  
80105360:	c3                   	ret    

80105361 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105361:	55                   	push   %ebp
80105362:	89 e5                	mov    %esp,%ebp
80105364:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010536e:	eb 30                	jmp    801053a0 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105370:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105376:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105379:	83 c2 08             	add    $0x8,%edx
8010537c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105380:	85 c0                	test   %eax,%eax
80105382:	75 18                	jne    8010539c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105384:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010538a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010538d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105390:	8b 55 08             	mov    0x8(%ebp),%edx
80105393:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105397:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010539a:	eb 0f                	jmp    801053ab <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010539c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053a0:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801053a4:	7e ca                	jle    80105370 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801053a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ab:	c9                   	leave  
801053ac:	c3                   	ret    

801053ad <sys_dup>:

int
sys_dup(void)
{
801053ad:	55                   	push   %ebp
801053ae:	89 e5                	mov    %esp,%ebp
801053b0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801053b3:	83 ec 04             	sub    $0x4,%esp
801053b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053b9:	50                   	push   %eax
801053ba:	6a 00                	push   $0x0
801053bc:	6a 00                	push   $0x0
801053be:	e8 29 ff ff ff       	call   801052ec <argfd>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	79 07                	jns    801053d1 <sys_dup+0x24>
    return -1;
801053ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cf:	eb 31                	jmp    80105402 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801053d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	50                   	push   %eax
801053d8:	e8 84 ff ff ff       	call   80105361 <fdalloc>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053e7:	79 07                	jns    801053f0 <sys_dup+0x43>
    return -1;
801053e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ee:	eb 12                	jmp    80105402 <sys_dup+0x55>
  filedup(f);
801053f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f3:	83 ec 0c             	sub    $0xc,%esp
801053f6:	50                   	push   %eax
801053f7:	e8 e4 bb ff ff       	call   80100fe0 <filedup>
801053fc:	83 c4 10             	add    $0x10,%esp
  return fd;
801053ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105402:	c9                   	leave  
80105403:	c3                   	ret    

80105404 <sys_read>:

int
sys_read(void)
{
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010540a:	83 ec 04             	sub    $0x4,%esp
8010540d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105410:	50                   	push   %eax
80105411:	6a 00                	push   $0x0
80105413:	6a 00                	push   $0x0
80105415:	e8 d2 fe ff ff       	call   801052ec <argfd>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	78 2e                	js     8010544f <sys_read+0x4b>
80105421:	83 ec 08             	sub    $0x8,%esp
80105424:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105427:	50                   	push   %eax
80105428:	6a 02                	push   $0x2
8010542a:	e8 81 fd ff ff       	call   801051b0 <argint>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	78 19                	js     8010544f <sys_read+0x4b>
80105436:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105439:	83 ec 04             	sub    $0x4,%esp
8010543c:	50                   	push   %eax
8010543d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105440:	50                   	push   %eax
80105441:	6a 01                	push   $0x1
80105443:	e8 90 fd ff ff       	call   801051d8 <argptr>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	79 07                	jns    80105456 <sys_read+0x52>
    return -1;
8010544f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105454:	eb 17                	jmp    8010546d <sys_read+0x69>
  return fileread(f, p, n);
80105456:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105459:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010545c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010545f:	83 ec 04             	sub    $0x4,%esp
80105462:	51                   	push   %ecx
80105463:	52                   	push   %edx
80105464:	50                   	push   %eax
80105465:	e8 06 bd ff ff       	call   80101170 <fileread>
8010546a:	83 c4 10             	add    $0x10,%esp
}
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    

8010546f <sys_write>:

int
sys_write(void)
{
8010546f:	55                   	push   %ebp
80105470:	89 e5                	mov    %esp,%ebp
80105472:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105475:	83 ec 04             	sub    $0x4,%esp
80105478:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547b:	50                   	push   %eax
8010547c:	6a 00                	push   $0x0
8010547e:	6a 00                	push   $0x0
80105480:	e8 67 fe ff ff       	call   801052ec <argfd>
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	85 c0                	test   %eax,%eax
8010548a:	78 2e                	js     801054ba <sys_write+0x4b>
8010548c:	83 ec 08             	sub    $0x8,%esp
8010548f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105492:	50                   	push   %eax
80105493:	6a 02                	push   $0x2
80105495:	e8 16 fd ff ff       	call   801051b0 <argint>
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	85 c0                	test   %eax,%eax
8010549f:	78 19                	js     801054ba <sys_write+0x4b>
801054a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a4:	83 ec 04             	sub    $0x4,%esp
801054a7:	50                   	push   %eax
801054a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054ab:	50                   	push   %eax
801054ac:	6a 01                	push   $0x1
801054ae:	e8 25 fd ff ff       	call   801051d8 <argptr>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	79 07                	jns    801054c1 <sys_write+0x52>
    return -1;
801054ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bf:	eb 17                	jmp    801054d8 <sys_write+0x69>
  return filewrite(f, p, n);
801054c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801054c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801054c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ca:	83 ec 04             	sub    $0x4,%esp
801054cd:	51                   	push   %ecx
801054ce:	52                   	push   %edx
801054cf:	50                   	push   %eax
801054d0:	e8 53 bd ff ff       	call   80101228 <filewrite>
801054d5:	83 c4 10             	add    $0x10,%esp
}
801054d8:	c9                   	leave  
801054d9:	c3                   	ret    

801054da <sys_close>:

int
sys_close(void)
{
801054da:	55                   	push   %ebp
801054db:	89 e5                	mov    %esp,%ebp
801054dd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801054e0:	83 ec 04             	sub    $0x4,%esp
801054e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e6:	50                   	push   %eax
801054e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ea:	50                   	push   %eax
801054eb:	6a 00                	push   $0x0
801054ed:	e8 fa fd ff ff       	call   801052ec <argfd>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	79 07                	jns    80105500 <sys_close+0x26>
    return -1;
801054f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fe:	eb 28                	jmp    80105528 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105500:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105506:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105509:	83 c2 08             	add    $0x8,%edx
8010550c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105513:	00 
  fileclose(f);
80105514:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	50                   	push   %eax
8010551b:	e8 11 bb ff ff       	call   80101031 <fileclose>
80105520:	83 c4 10             	add    $0x10,%esp
  return 0;
80105523:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105528:	c9                   	leave  
80105529:	c3                   	ret    

8010552a <sys_fstat>:

int
sys_fstat(void)
{
8010552a:	55                   	push   %ebp
8010552b:	89 e5                	mov    %esp,%ebp
8010552d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105536:	50                   	push   %eax
80105537:	6a 00                	push   $0x0
80105539:	6a 00                	push   $0x0
8010553b:	e8 ac fd ff ff       	call   801052ec <argfd>
80105540:	83 c4 10             	add    $0x10,%esp
80105543:	85 c0                	test   %eax,%eax
80105545:	78 17                	js     8010555e <sys_fstat+0x34>
80105547:	83 ec 04             	sub    $0x4,%esp
8010554a:	6a 14                	push   $0x14
8010554c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010554f:	50                   	push   %eax
80105550:	6a 01                	push   $0x1
80105552:	e8 81 fc ff ff       	call   801051d8 <argptr>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	79 07                	jns    80105565 <sys_fstat+0x3b>
    return -1;
8010555e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105563:	eb 13                	jmp    80105578 <sys_fstat+0x4e>
  return filestat(f, st);
80105565:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	52                   	push   %edx
8010556f:	50                   	push   %eax
80105570:	e8 a4 bb ff ff       	call   80101119 <filestat>
80105575:	83 c4 10             	add    $0x10,%esp
}
80105578:	c9                   	leave  
80105579:	c3                   	ret    

8010557a <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010557a:	55                   	push   %ebp
8010557b:	89 e5                	mov    %esp,%ebp
8010557d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105586:	50                   	push   %eax
80105587:	6a 00                	push   $0x0
80105589:	e8 a7 fc ff ff       	call   80105235 <argstr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 15                	js     801055aa <sys_link+0x30>
80105595:	83 ec 08             	sub    $0x8,%esp
80105598:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010559b:	50                   	push   %eax
8010559c:	6a 01                	push   $0x1
8010559e:	e8 92 fc ff ff       	call   80105235 <argstr>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	79 0a                	jns    801055b4 <sys_link+0x3a>
    return -1;
801055aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055af:	e9 63 01 00 00       	jmp    80105717 <sys_link+0x19d>
  if((ip = namei(old)) == 0)
801055b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801055b7:	83 ec 0c             	sub    $0xc,%esp
801055ba:	50                   	push   %eax
801055bb:	e8 fe ce ff ff       	call   801024be <namei>
801055c0:	83 c4 10             	add    $0x10,%esp
801055c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055ca:	75 0a                	jne    801055d6 <sys_link+0x5c>
    return -1;
801055cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d1:	e9 41 01 00 00       	jmp    80105717 <sys_link+0x19d>

  begin_trans();
801055d6:	e8 bc dc ff ff       	call   80103297 <begin_trans>

  ilock(ip);
801055db:	83 ec 0c             	sub    $0xc,%esp
801055de:	ff 75 f4             	pushl  -0xc(%ebp)
801055e1:	e8 20 c3 ff ff       	call   80101906 <ilock>
801055e6:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801055e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801055f0:	66 83 f8 01          	cmp    $0x1,%ax
801055f4:	75 1d                	jne    80105613 <sys_link+0x99>
    iunlockput(ip);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	ff 75 f4             	pushl  -0xc(%ebp)
801055fc:	e8 bf c5 ff ff       	call   80101bc0 <iunlockput>
80105601:	83 c4 10             	add    $0x10,%esp
    commit_trans();
80105604:	e8 e1 dc ff ff       	call   801032ea <commit_trans>
    return -1;
80105609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560e:	e9 04 01 00 00       	jmp    80105717 <sys_link+0x19d>
  }

  ip->nlink++;
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010561a:	83 c0 01             	add    $0x1,%eax
8010561d:	89 c2                	mov    %eax,%edx
8010561f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105622:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105626:	83 ec 0c             	sub    $0xc,%esp
80105629:	ff 75 f4             	pushl  -0xc(%ebp)
8010562c:	e8 01 c1 ff ff       	call   80101732 <iupdate>
80105631:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	ff 75 f4             	pushl  -0xc(%ebp)
8010563a:	e8 1f c4 ff ff       	call   80101a5e <iunlock>
8010563f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105642:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010564b:	52                   	push   %edx
8010564c:	50                   	push   %eax
8010564d:	e8 88 ce ff ff       	call   801024da <nameiparent>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105658:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010565c:	74 71                	je     801056cf <sys_link+0x155>
    goto bad;
  ilock(dp);
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	ff 75 f0             	pushl  -0x10(%ebp)
80105664:	e8 9d c2 ff ff       	call   80101906 <ilock>
80105669:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010566c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566f:	8b 10                	mov    (%eax),%edx
80105671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105674:	8b 00                	mov    (%eax),%eax
80105676:	39 c2                	cmp    %eax,%edx
80105678:	75 1d                	jne    80105697 <sys_link+0x11d>
8010567a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567d:	8b 40 04             	mov    0x4(%eax),%eax
80105680:	83 ec 04             	sub    $0x4,%esp
80105683:	50                   	push   %eax
80105684:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105687:	50                   	push   %eax
80105688:	ff 75 f0             	pushl  -0x10(%ebp)
8010568b:	e8 92 cb ff ff       	call   80102222 <dirlink>
80105690:	83 c4 10             	add    $0x10,%esp
80105693:	85 c0                	test   %eax,%eax
80105695:	79 10                	jns    801056a7 <sys_link+0x12d>
    iunlockput(dp);
80105697:	83 ec 0c             	sub    $0xc,%esp
8010569a:	ff 75 f0             	pushl  -0x10(%ebp)
8010569d:	e8 1e c5 ff ff       	call   80101bc0 <iunlockput>
801056a2:	83 c4 10             	add    $0x10,%esp
    goto bad;
801056a5:	eb 29                	jmp    801056d0 <sys_link+0x156>
  }
  iunlockput(dp);
801056a7:	83 ec 0c             	sub    $0xc,%esp
801056aa:	ff 75 f0             	pushl  -0x10(%ebp)
801056ad:	e8 0e c5 ff ff       	call   80101bc0 <iunlockput>
801056b2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801056b5:	83 ec 0c             	sub    $0xc,%esp
801056b8:	ff 75 f4             	pushl  -0xc(%ebp)
801056bb:	e8 10 c4 ff ff       	call   80101ad0 <iput>
801056c0:	83 c4 10             	add    $0x10,%esp

  commit_trans();
801056c3:	e8 22 dc ff ff       	call   801032ea <commit_trans>

  return 0;
801056c8:	b8 00 00 00 00       	mov    $0x0,%eax
801056cd:	eb 48                	jmp    80105717 <sys_link+0x19d>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801056cf:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	ff 75 f4             	pushl  -0xc(%ebp)
801056d6:	e8 2b c2 ff ff       	call   80101906 <ilock>
801056db:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801056de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801056e5:	83 e8 01             	sub    $0x1,%eax
801056e8:	89 c2                	mov    %eax,%edx
801056ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ed:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801056f1:	83 ec 0c             	sub    $0xc,%esp
801056f4:	ff 75 f4             	pushl  -0xc(%ebp)
801056f7:	e8 36 c0 ff ff       	call   80101732 <iupdate>
801056fc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801056ff:	83 ec 0c             	sub    $0xc,%esp
80105702:	ff 75 f4             	pushl  -0xc(%ebp)
80105705:	e8 b6 c4 ff ff       	call   80101bc0 <iunlockput>
8010570a:	83 c4 10             	add    $0x10,%esp
  commit_trans();
8010570d:	e8 d8 db ff ff       	call   801032ea <commit_trans>
  return -1;
80105712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105717:	c9                   	leave  
80105718:	c3                   	ret    

80105719 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105719:	55                   	push   %ebp
8010571a:	89 e5                	mov    %esp,%ebp
8010571c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010571f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105726:	eb 40                	jmp    80105768 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572b:	6a 10                	push   $0x10
8010572d:	50                   	push   %eax
8010572e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105731:	50                   	push   %eax
80105732:	ff 75 08             	pushl  0x8(%ebp)
80105735:	e8 34 c7 ff ff       	call   80101e6e <readi>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	83 f8 10             	cmp    $0x10,%eax
80105740:	74 0d                	je     8010574f <isdirempty+0x36>
      panic("isdirempty: readi");
80105742:	83 ec 0c             	sub    $0xc,%esp
80105745:	68 2f 85 10 80       	push   $0x8010852f
8010574a:	e8 17 ae ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010574f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105753:	66 85 c0             	test   %ax,%ax
80105756:	74 07                	je     8010575f <isdirempty+0x46>
      return 0;
80105758:	b8 00 00 00 00       	mov    $0x0,%eax
8010575d:	eb 1b                	jmp    8010577a <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010575f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105762:	83 c0 10             	add    $0x10,%eax
80105765:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105768:	8b 45 08             	mov    0x8(%ebp),%eax
8010576b:	8b 50 18             	mov    0x18(%eax),%edx
8010576e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105771:	39 c2                	cmp    %eax,%edx
80105773:	77 b3                	ja     80105728 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105775:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    

8010577c <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010577c:	55                   	push   %ebp
8010577d:	89 e5                	mov    %esp,%ebp
8010577f:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105782:	83 ec 08             	sub    $0x8,%esp
80105785:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105788:	50                   	push   %eax
80105789:	6a 00                	push   $0x0
8010578b:	e8 a5 fa ff ff       	call   80105235 <argstr>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	85 c0                	test   %eax,%eax
80105795:	79 0a                	jns    801057a1 <sys_unlink+0x25>
    return -1;
80105797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579c:	e9 b7 01 00 00       	jmp    80105958 <sys_unlink+0x1dc>
  if((dp = nameiparent(path, name)) == 0)
801057a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801057a4:	83 ec 08             	sub    $0x8,%esp
801057a7:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801057aa:	52                   	push   %edx
801057ab:	50                   	push   %eax
801057ac:	e8 29 cd ff ff       	call   801024da <nameiparent>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057bb:	75 0a                	jne    801057c7 <sys_unlink+0x4b>
    return -1;
801057bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c2:	e9 91 01 00 00       	jmp    80105958 <sys_unlink+0x1dc>

  begin_trans();
801057c7:	e8 cb da ff ff       	call   80103297 <begin_trans>

  ilock(dp);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	ff 75 f4             	pushl  -0xc(%ebp)
801057d2:	e8 2f c1 ff ff       	call   80101906 <ilock>
801057d7:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057da:	83 ec 08             	sub    $0x8,%esp
801057dd:	68 41 85 10 80       	push   $0x80108541
801057e2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801057e5:	50                   	push   %eax
801057e6:	e8 62 c9 ff ff       	call   8010214d <namecmp>
801057eb:	83 c4 10             	add    $0x10,%esp
801057ee:	85 c0                	test   %eax,%eax
801057f0:	0f 84 4a 01 00 00    	je     80105940 <sys_unlink+0x1c4>
801057f6:	83 ec 08             	sub    $0x8,%esp
801057f9:	68 43 85 10 80       	push   $0x80108543
801057fe:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105801:	50                   	push   %eax
80105802:	e8 46 c9 ff ff       	call   8010214d <namecmp>
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	85 c0                	test   %eax,%eax
8010580c:	0f 84 2e 01 00 00    	je     80105940 <sys_unlink+0x1c4>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105812:	83 ec 04             	sub    $0x4,%esp
80105815:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105818:	50                   	push   %eax
80105819:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010581c:	50                   	push   %eax
8010581d:	ff 75 f4             	pushl  -0xc(%ebp)
80105820:	e8 43 c9 ff ff       	call   80102168 <dirlookup>
80105825:	83 c4 10             	add    $0x10,%esp
80105828:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010582b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010582f:	0f 84 0a 01 00 00    	je     8010593f <sys_unlink+0x1c3>
    goto bad;
  ilock(ip);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	ff 75 f0             	pushl  -0x10(%ebp)
8010583b:	e8 c6 c0 ff ff       	call   80101906 <ilock>
80105840:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105846:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010584a:	66 85 c0             	test   %ax,%ax
8010584d:	7f 0d                	jg     8010585c <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	68 46 85 10 80       	push   $0x80108546
80105857:	e8 0a ad ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010585c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105863:	66 83 f8 01          	cmp    $0x1,%ax
80105867:	75 25                	jne    8010588e <sys_unlink+0x112>
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	ff 75 f0             	pushl  -0x10(%ebp)
8010586f:	e8 a5 fe ff ff       	call   80105719 <isdirempty>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	75 13                	jne    8010588e <sys_unlink+0x112>
    iunlockput(ip);
8010587b:	83 ec 0c             	sub    $0xc,%esp
8010587e:	ff 75 f0             	pushl  -0x10(%ebp)
80105881:	e8 3a c3 ff ff       	call   80101bc0 <iunlockput>
80105886:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105889:	e9 b2 00 00 00       	jmp    80105940 <sys_unlink+0x1c4>
  }

  memset(&de, 0, sizeof(de));
8010588e:	83 ec 04             	sub    $0x4,%esp
80105891:	6a 10                	push   $0x10
80105893:	6a 00                	push   $0x0
80105895:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105898:	50                   	push   %eax
80105899:	e8 ed f5 ff ff       	call   80104e8b <memset>
8010589e:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
801058a4:	6a 10                	push   $0x10
801058a6:	50                   	push   %eax
801058a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058aa:	50                   	push   %eax
801058ab:	ff 75 f4             	pushl  -0xc(%ebp)
801058ae:	e8 12 c7 ff ff       	call   80101fc5 <writei>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	83 f8 10             	cmp    $0x10,%eax
801058b9:	74 0d                	je     801058c8 <sys_unlink+0x14c>
    panic("unlink: writei");
801058bb:	83 ec 0c             	sub    $0xc,%esp
801058be:	68 58 85 10 80       	push   $0x80108558
801058c3:	e8 9e ac ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801058c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058cb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058cf:	66 83 f8 01          	cmp    $0x1,%ax
801058d3:	75 21                	jne    801058f6 <sys_unlink+0x17a>
    dp->nlink--;
801058d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801058dc:	83 e8 01             	sub    $0x1,%eax
801058df:	89 c2                	mov    %eax,%edx
801058e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	ff 75 f4             	pushl  -0xc(%ebp)
801058ee:	e8 3f be ff ff       	call   80101732 <iupdate>
801058f3:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801058f6:	83 ec 0c             	sub    $0xc,%esp
801058f9:	ff 75 f4             	pushl  -0xc(%ebp)
801058fc:	e8 bf c2 ff ff       	call   80101bc0 <iunlockput>
80105901:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105907:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010590b:	83 e8 01             	sub    $0x1,%eax
8010590e:	89 c2                	mov    %eax,%edx
80105910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105913:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105917:	83 ec 0c             	sub    $0xc,%esp
8010591a:	ff 75 f0             	pushl  -0x10(%ebp)
8010591d:	e8 10 be ff ff       	call   80101732 <iupdate>
80105922:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105925:	83 ec 0c             	sub    $0xc,%esp
80105928:	ff 75 f0             	pushl  -0x10(%ebp)
8010592b:	e8 90 c2 ff ff       	call   80101bc0 <iunlockput>
80105930:	83 c4 10             	add    $0x10,%esp

  commit_trans();
80105933:	e8 b2 d9 ff ff       	call   801032ea <commit_trans>

  return 0;
80105938:	b8 00 00 00 00       	mov    $0x0,%eax
8010593d:	eb 19                	jmp    80105958 <sys_unlink+0x1dc>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010593f:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	ff 75 f4             	pushl  -0xc(%ebp)
80105946:	e8 75 c2 ff ff       	call   80101bc0 <iunlockput>
8010594b:	83 c4 10             	add    $0x10,%esp
  commit_trans();
8010594e:	e8 97 d9 ff ff       	call   801032ea <commit_trans>
  return -1;
80105953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105958:	c9                   	leave  
80105959:	c3                   	ret    

8010595a <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010595a:	55                   	push   %ebp
8010595b:	89 e5                	mov    %esp,%ebp
8010595d:	83 ec 38             	sub    $0x38,%esp
80105960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105963:	8b 55 10             	mov    0x10(%ebp),%edx
80105966:	8b 45 14             	mov    0x14(%ebp),%eax
80105969:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010596d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105971:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105975:	83 ec 08             	sub    $0x8,%esp
80105978:	8d 45 de             	lea    -0x22(%ebp),%eax
8010597b:	50                   	push   %eax
8010597c:	ff 75 08             	pushl  0x8(%ebp)
8010597f:	e8 56 cb ff ff       	call   801024da <nameiparent>
80105984:	83 c4 10             	add    $0x10,%esp
80105987:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010598a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010598e:	75 0a                	jne    8010599a <create+0x40>
    return 0;
80105990:	b8 00 00 00 00       	mov    $0x0,%eax
80105995:	e9 90 01 00 00       	jmp    80105b2a <create+0x1d0>
  ilock(dp);
8010599a:	83 ec 0c             	sub    $0xc,%esp
8010599d:	ff 75 f4             	pushl  -0xc(%ebp)
801059a0:	e8 61 bf ff ff       	call   80101906 <ilock>
801059a5:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801059a8:	83 ec 04             	sub    $0x4,%esp
801059ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ae:	50                   	push   %eax
801059af:	8d 45 de             	lea    -0x22(%ebp),%eax
801059b2:	50                   	push   %eax
801059b3:	ff 75 f4             	pushl  -0xc(%ebp)
801059b6:	e8 ad c7 ff ff       	call   80102168 <dirlookup>
801059bb:	83 c4 10             	add    $0x10,%esp
801059be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059c5:	74 50                	je     80105a17 <create+0xbd>
    iunlockput(dp);
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	ff 75 f4             	pushl  -0xc(%ebp)
801059cd:	e8 ee c1 ff ff       	call   80101bc0 <iunlockput>
801059d2:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801059d5:	83 ec 0c             	sub    $0xc,%esp
801059d8:	ff 75 f0             	pushl  -0x10(%ebp)
801059db:	e8 26 bf ff ff       	call   80101906 <ilock>
801059e0:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801059e3:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801059e8:	75 15                	jne    801059ff <create+0xa5>
801059ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ed:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059f1:	66 83 f8 02          	cmp    $0x2,%ax
801059f5:	75 08                	jne    801059ff <create+0xa5>
      return ip;
801059f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fa:	e9 2b 01 00 00       	jmp    80105b2a <create+0x1d0>
    iunlockput(ip);
801059ff:	83 ec 0c             	sub    $0xc,%esp
80105a02:	ff 75 f0             	pushl  -0x10(%ebp)
80105a05:	e8 b6 c1 ff ff       	call   80101bc0 <iunlockput>
80105a0a:	83 c4 10             	add    $0x10,%esp
    return 0;
80105a0d:	b8 00 00 00 00       	mov    $0x0,%eax
80105a12:	e9 13 01 00 00       	jmp    80105b2a <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a17:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1e:	8b 00                	mov    (%eax),%eax
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	52                   	push   %edx
80105a24:	50                   	push   %eax
80105a25:	e8 27 bc ff ff       	call   80101651 <ialloc>
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a34:	75 0d                	jne    80105a43 <create+0xe9>
    panic("create: ialloc");
80105a36:	83 ec 0c             	sub    $0xc,%esp
80105a39:	68 67 85 10 80       	push   $0x80108567
80105a3e:	e8 23 ab ff ff       	call   80100566 <panic>

  ilock(ip);
80105a43:	83 ec 0c             	sub    $0xc,%esp
80105a46:	ff 75 f0             	pushl  -0x10(%ebp)
80105a49:	e8 b8 be ff ff       	call   80101906 <ilock>
80105a4e:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a54:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105a58:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105a63:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6a:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	ff 75 f0             	pushl  -0x10(%ebp)
80105a76:	e8 b7 bc ff ff       	call   80101732 <iupdate>
80105a7b:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105a7e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a83:	75 6a                	jne    80105aef <create+0x195>
    dp->nlink++;  // for ".."
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a8c:	83 c0 01             	add    $0x1,%eax
80105a8f:	89 c2                	mov    %eax,%edx
80105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a94:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105a98:	83 ec 0c             	sub    $0xc,%esp
80105a9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a9e:	e8 8f bc ff ff       	call   80101732 <iupdate>
80105aa3:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa9:	8b 40 04             	mov    0x4(%eax),%eax
80105aac:	83 ec 04             	sub    $0x4,%esp
80105aaf:	50                   	push   %eax
80105ab0:	68 41 85 10 80       	push   $0x80108541
80105ab5:	ff 75 f0             	pushl  -0x10(%ebp)
80105ab8:	e8 65 c7 ff ff       	call   80102222 <dirlink>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	78 1e                	js     80105ae2 <create+0x188>
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	8b 40 04             	mov    0x4(%eax),%eax
80105aca:	83 ec 04             	sub    $0x4,%esp
80105acd:	50                   	push   %eax
80105ace:	68 43 85 10 80       	push   $0x80108543
80105ad3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ad6:	e8 47 c7 ff ff       	call   80102222 <dirlink>
80105adb:	83 c4 10             	add    $0x10,%esp
80105ade:	85 c0                	test   %eax,%eax
80105ae0:	79 0d                	jns    80105aef <create+0x195>
      panic("create dots");
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	68 76 85 10 80       	push   $0x80108576
80105aea:	e8 77 aa ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af2:	8b 40 04             	mov    0x4(%eax),%eax
80105af5:	83 ec 04             	sub    $0x4,%esp
80105af8:	50                   	push   %eax
80105af9:	8d 45 de             	lea    -0x22(%ebp),%eax
80105afc:	50                   	push   %eax
80105afd:	ff 75 f4             	pushl  -0xc(%ebp)
80105b00:	e8 1d c7 ff ff       	call   80102222 <dirlink>
80105b05:	83 c4 10             	add    $0x10,%esp
80105b08:	85 c0                	test   %eax,%eax
80105b0a:	79 0d                	jns    80105b19 <create+0x1bf>
    panic("create: dirlink");
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	68 82 85 10 80       	push   $0x80108582
80105b14:	e8 4d aa ff ff       	call   80100566 <panic>

  iunlockput(dp);
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1f:	e8 9c c0 ff ff       	call   80101bc0 <iunlockput>
80105b24:	83 c4 10             	add    $0x10,%esp

  return ip;
80105b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105b2a:	c9                   	leave  
80105b2b:	c3                   	ret    

80105b2c <sys_open>:

int
sys_open(void)
{
80105b2c:	55                   	push   %ebp
80105b2d:	89 e5                	mov    %esp,%ebp
80105b2f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b32:	83 ec 08             	sub    $0x8,%esp
80105b35:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b38:	50                   	push   %eax
80105b39:	6a 00                	push   $0x0
80105b3b:	e8 f5 f6 ff ff       	call   80105235 <argstr>
80105b40:	83 c4 10             	add    $0x10,%esp
80105b43:	85 c0                	test   %eax,%eax
80105b45:	78 15                	js     80105b5c <sys_open+0x30>
80105b47:	83 ec 08             	sub    $0x8,%esp
80105b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b4d:	50                   	push   %eax
80105b4e:	6a 01                	push   $0x1
80105b50:	e8 5b f6 ff ff       	call   801051b0 <argint>
80105b55:	83 c4 10             	add    $0x10,%esp
80105b58:	85 c0                	test   %eax,%eax
80105b5a:	79 0a                	jns    80105b66 <sys_open+0x3a>
    return -1;
80105b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b61:	e9 4d 01 00 00       	jmp    80105cb3 <sys_open+0x187>
  if(omode & O_CREATE){
80105b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b69:	25 00 02 00 00       	and    $0x200,%eax
80105b6e:	85 c0                	test   %eax,%eax
80105b70:	74 2f                	je     80105ba1 <sys_open+0x75>
    begin_trans();
80105b72:	e8 20 d7 ff ff       	call   80103297 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b7a:	6a 00                	push   $0x0
80105b7c:	6a 00                	push   $0x0
80105b7e:	6a 02                	push   $0x2
80105b80:	50                   	push   %eax
80105b81:	e8 d4 fd ff ff       	call   8010595a <create>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105b8c:	e8 59 d7 ff ff       	call   801032ea <commit_trans>
    if(ip == 0)
80105b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b95:	75 66                	jne    80105bfd <sys_open+0xd1>
      return -1;
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	e9 12 01 00 00       	jmp    80105cb3 <sys_open+0x187>
  } else {
    if((ip = namei(path)) == 0)
80105ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	50                   	push   %eax
80105ba8:	e8 11 c9 ff ff       	call   801024be <namei>
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bb7:	75 0a                	jne    80105bc3 <sys_open+0x97>
      return -1;
80105bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbe:	e9 f0 00 00 00       	jmp    80105cb3 <sys_open+0x187>
    ilock(ip);
80105bc3:	83 ec 0c             	sub    $0xc,%esp
80105bc6:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc9:	e8 38 bd ff ff       	call   80101906 <ilock>
80105bce:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bd8:	66 83 f8 01          	cmp    $0x1,%ax
80105bdc:	75 1f                	jne    80105bfd <sys_open+0xd1>
80105bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105be1:	85 c0                	test   %eax,%eax
80105be3:	74 18                	je     80105bfd <sys_open+0xd1>
      iunlockput(ip);
80105be5:	83 ec 0c             	sub    $0xc,%esp
80105be8:	ff 75 f4             	pushl  -0xc(%ebp)
80105beb:	e8 d0 bf ff ff       	call   80101bc0 <iunlockput>
80105bf0:	83 c4 10             	add    $0x10,%esp
      return -1;
80105bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf8:	e9 b6 00 00 00       	jmp    80105cb3 <sys_open+0x187>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105bfd:	e8 71 b3 ff ff       	call   80100f73 <filealloc>
80105c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c09:	74 17                	je     80105c22 <sys_open+0xf6>
80105c0b:	83 ec 0c             	sub    $0xc,%esp
80105c0e:	ff 75 f0             	pushl  -0x10(%ebp)
80105c11:	e8 4b f7 ff ff       	call   80105361 <fdalloc>
80105c16:	83 c4 10             	add    $0x10,%esp
80105c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105c20:	79 29                	jns    80105c4b <sys_open+0x11f>
    if(f)
80105c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c26:	74 0e                	je     80105c36 <sys_open+0x10a>
      fileclose(f);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 f0             	pushl  -0x10(%ebp)
80105c2e:	e8 fe b3 ff ff       	call   80101031 <fileclose>
80105c33:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105c36:	83 ec 0c             	sub    $0xc,%esp
80105c39:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3c:	e8 7f bf ff ff       	call   80101bc0 <iunlockput>
80105c41:	83 c4 10             	add    $0x10,%esp
    return -1;
80105c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c49:	eb 68                	jmp    80105cb3 <sys_open+0x187>
  }
  iunlock(ip);
80105c4b:	83 ec 0c             	sub    $0xc,%esp
80105c4e:	ff 75 f4             	pushl  -0xc(%ebp)
80105c51:	e8 08 be ff ff       	call   80101a5e <iunlock>
80105c56:	83 c4 10             	add    $0x10,%esp

  f->type = FD_INODE;
80105c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c68:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c78:	83 e0 01             	and    $0x1,%eax
80105c7b:	85 c0                	test   %eax,%eax
80105c7d:	0f 94 c0             	sete   %al
80105c80:	89 c2                	mov    %eax,%edx
80105c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c85:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c8b:	83 e0 01             	and    $0x1,%eax
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	75 0a                	jne    80105c9c <sys_open+0x170>
80105c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c95:	83 e0 02             	and    $0x2,%eax
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	74 07                	je     80105ca3 <sys_open+0x177>
80105c9c:	b8 01 00 00 00       	mov    $0x1,%eax
80105ca1:	eb 05                	jmp    80105ca8 <sys_open+0x17c>
80105ca3:	b8 00 00 00 00       	mov    $0x0,%eax
80105ca8:	89 c2                	mov    %eax,%edx
80105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cad:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <sys_mkdir>:

int
sys_mkdir(void)
{
80105cb5:	55                   	push   %ebp
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105cbb:	e8 d7 d5 ff ff       	call   80103297 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105cc0:	83 ec 08             	sub    $0x8,%esp
80105cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc6:	50                   	push   %eax
80105cc7:	6a 00                	push   $0x0
80105cc9:	e8 67 f5 ff ff       	call   80105235 <argstr>
80105cce:	83 c4 10             	add    $0x10,%esp
80105cd1:	85 c0                	test   %eax,%eax
80105cd3:	78 1b                	js     80105cf0 <sys_mkdir+0x3b>
80105cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd8:	6a 00                	push   $0x0
80105cda:	6a 00                	push   $0x0
80105cdc:	6a 01                	push   $0x1
80105cde:	50                   	push   %eax
80105cdf:	e8 76 fc ff ff       	call   8010595a <create>
80105ce4:	83 c4 10             	add    $0x10,%esp
80105ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cee:	75 0c                	jne    80105cfc <sys_mkdir+0x47>
    commit_trans();
80105cf0:	e8 f5 d5 ff ff       	call   801032ea <commit_trans>
    return -1;
80105cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfa:	eb 18                	jmp    80105d14 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	ff 75 f4             	pushl  -0xc(%ebp)
80105d02:	e8 b9 be ff ff       	call   80101bc0 <iunlockput>
80105d07:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105d0a:	e8 db d5 ff ff       	call   801032ea <commit_trans>
  return 0;
80105d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d14:	c9                   	leave  
80105d15:	c3                   	ret    

80105d16 <sys_mknod>:

int
sys_mknod(void)
{
80105d16:	55                   	push   %ebp
80105d17:	89 e5                	mov    %esp,%ebp
80105d19:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105d1c:	e8 76 d5 ff ff       	call   80103297 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105d21:	83 ec 08             	sub    $0x8,%esp
80105d24:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d27:	50                   	push   %eax
80105d28:	6a 00                	push   $0x0
80105d2a:	e8 06 f5 ff ff       	call   80105235 <argstr>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d39:	78 4f                	js     80105d8a <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80105d3b:	83 ec 08             	sub    $0x8,%esp
80105d3e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d41:	50                   	push   %eax
80105d42:	6a 01                	push   $0x1
80105d44:	e8 67 f4 ff ff       	call   801051b0 <argint>
80105d49:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	78 3a                	js     80105d8a <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105d50:	83 ec 08             	sub    $0x8,%esp
80105d53:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d56:	50                   	push   %eax
80105d57:	6a 02                	push   $0x2
80105d59:	e8 52 f4 ff ff       	call   801051b0 <argint>
80105d5e:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105d61:	85 c0                	test   %eax,%eax
80105d63:	78 25                	js     80105d8a <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d68:	0f bf c8             	movswl %ax,%ecx
80105d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d6e:	0f bf d0             	movswl %ax,%edx
80105d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105d74:	51                   	push   %ecx
80105d75:	52                   	push   %edx
80105d76:	6a 03                	push   $0x3
80105d78:	50                   	push   %eax
80105d79:	e8 dc fb ff ff       	call   8010595a <create>
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d88:	75 0c                	jne    80105d96 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105d8a:	e8 5b d5 ff ff       	call   801032ea <commit_trans>
    return -1;
80105d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d94:	eb 18                	jmp    80105dae <sys_mknod+0x98>
  }
  iunlockput(ip);
80105d96:	83 ec 0c             	sub    $0xc,%esp
80105d99:	ff 75 f0             	pushl  -0x10(%ebp)
80105d9c:	e8 1f be ff ff       	call   80101bc0 <iunlockput>
80105da1:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105da4:	e8 41 d5 ff ff       	call   801032ea <commit_trans>
  return 0;
80105da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dae:	c9                   	leave  
80105daf:	c3                   	ret    

80105db0 <sys_chdir>:

int
sys_chdir(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105db6:	83 ec 08             	sub    $0x8,%esp
80105db9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dbc:	50                   	push   %eax
80105dbd:	6a 00                	push   $0x0
80105dbf:	e8 71 f4 ff ff       	call   80105235 <argstr>
80105dc4:	83 c4 10             	add    $0x10,%esp
80105dc7:	85 c0                	test   %eax,%eax
80105dc9:	78 18                	js     80105de3 <sys_chdir+0x33>
80105dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dce:	83 ec 0c             	sub    $0xc,%esp
80105dd1:	50                   	push   %eax
80105dd2:	e8 e7 c6 ff ff       	call   801024be <namei>
80105dd7:	83 c4 10             	add    $0x10,%esp
80105dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105de1:	75 07                	jne    80105dea <sys_chdir+0x3a>
    return -1;
80105de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de8:	eb 64                	jmp    80105e4e <sys_chdir+0x9e>
  ilock(ip);
80105dea:	83 ec 0c             	sub    $0xc,%esp
80105ded:	ff 75 f4             	pushl  -0xc(%ebp)
80105df0:	e8 11 bb ff ff       	call   80101906 <ilock>
80105df5:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dff:	66 83 f8 01          	cmp    $0x1,%ax
80105e03:	74 15                	je     80105e1a <sys_chdir+0x6a>
    iunlockput(ip);
80105e05:	83 ec 0c             	sub    $0xc,%esp
80105e08:	ff 75 f4             	pushl  -0xc(%ebp)
80105e0b:	e8 b0 bd ff ff       	call   80101bc0 <iunlockput>
80105e10:	83 c4 10             	add    $0x10,%esp
    return -1;
80105e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e18:	eb 34                	jmp    80105e4e <sys_chdir+0x9e>
  }
  iunlock(ip);
80105e1a:	83 ec 0c             	sub    $0xc,%esp
80105e1d:	ff 75 f4             	pushl  -0xc(%ebp)
80105e20:	e8 39 bc ff ff       	call   80101a5e <iunlock>
80105e25:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80105e28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e2e:	8b 40 68             	mov    0x68(%eax),%eax
80105e31:	83 ec 0c             	sub    $0xc,%esp
80105e34:	50                   	push   %eax
80105e35:	e8 96 bc ff ff       	call   80101ad0 <iput>
80105e3a:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
80105e3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e46:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e4e:	c9                   	leave  
80105e4f:	c3                   	ret    

80105e50 <sys_exec>:

int
sys_exec(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e59:	83 ec 08             	sub    $0x8,%esp
80105e5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e5f:	50                   	push   %eax
80105e60:	6a 00                	push   $0x0
80105e62:	e8 ce f3 ff ff       	call   80105235 <argstr>
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	78 18                	js     80105e86 <sys_exec+0x36>
80105e6e:	83 ec 08             	sub    $0x8,%esp
80105e71:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105e77:	50                   	push   %eax
80105e78:	6a 01                	push   $0x1
80105e7a:	e8 31 f3 ff ff       	call   801051b0 <argint>
80105e7f:	83 c4 10             	add    $0x10,%esp
80105e82:	85 c0                	test   %eax,%eax
80105e84:	79 0a                	jns    80105e90 <sys_exec+0x40>
    return -1;
80105e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8b:	e9 c6 00 00 00       	jmp    80105f56 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105e90:	83 ec 04             	sub    $0x4,%esp
80105e93:	68 80 00 00 00       	push   $0x80
80105e98:	6a 00                	push   $0x0
80105e9a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105ea0:	50                   	push   %eax
80105ea1:	e8 e5 ef ff ff       	call   80104e8b <memset>
80105ea6:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105ea9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb3:	83 f8 1f             	cmp    $0x1f,%eax
80105eb6:	76 0a                	jbe    80105ec2 <sys_exec+0x72>
      return -1;
80105eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebd:	e9 94 00 00 00       	jmp    80105f56 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec5:	c1 e0 02             	shl    $0x2,%eax
80105ec8:	89 c2                	mov    %eax,%edx
80105eca:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105ed0:	01 c2                	add    %eax,%edx
80105ed2:	83 ec 08             	sub    $0x8,%esp
80105ed5:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105edb:	50                   	push   %eax
80105edc:	52                   	push   %edx
80105edd:	e8 32 f2 ff ff       	call   80105114 <fetchint>
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	79 07                	jns    80105ef0 <sys_exec+0xa0>
      return -1;
80105ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eee:	eb 66                	jmp    80105f56 <sys_exec+0x106>
    if(uarg == 0){
80105ef0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105ef6:	85 c0                	test   %eax,%eax
80105ef8:	75 27                	jne    80105f21 <sys_exec+0xd1>
      argv[i] = 0;
80105efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efd:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105f04:	00 00 00 00 
      break;
80105f08:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0c:	83 ec 08             	sub    $0x8,%esp
80105f0f:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105f15:	52                   	push   %edx
80105f16:	50                   	push   %eax
80105f17:	e8 49 ac ff ff       	call   80100b65 <exec>
80105f1c:	83 c4 10             	add    $0x10,%esp
80105f1f:	eb 35                	jmp    80105f56 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f21:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f2a:	c1 e2 02             	shl    $0x2,%edx
80105f2d:	01 c2                	add    %eax,%edx
80105f2f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	52                   	push   %edx
80105f39:	50                   	push   %eax
80105f3a:	e8 0f f2 ff ff       	call   8010514e <fetchstr>
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	85 c0                	test   %eax,%eax
80105f44:	79 07                	jns    80105f4d <sys_exec+0xfd>
      return -1;
80105f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4b:	eb 09                	jmp    80105f56 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105f4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105f51:	e9 5a ff ff ff       	jmp    80105eb0 <sys_exec+0x60>
  return exec(path, argv);
}
80105f56:	c9                   	leave  
80105f57:	c3                   	ret    

80105f58 <sys_pipe>:

int
sys_pipe(void)
{
80105f58:	55                   	push   %ebp
80105f59:	89 e5                	mov    %esp,%ebp
80105f5b:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f5e:	83 ec 04             	sub    $0x4,%esp
80105f61:	6a 08                	push   $0x8
80105f63:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f66:	50                   	push   %eax
80105f67:	6a 00                	push   $0x0
80105f69:	e8 6a f2 ff ff       	call   801051d8 <argptr>
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	85 c0                	test   %eax,%eax
80105f73:	79 0a                	jns    80105f7f <sys_pipe+0x27>
    return -1;
80105f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7a:	e9 af 00 00 00       	jmp    8010602e <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80105f7f:	83 ec 08             	sub    $0x8,%esp
80105f82:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f85:	50                   	push   %eax
80105f86:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f89:	50                   	push   %eax
80105f8a:	e8 c1 dc ff ff       	call   80103c50 <pipealloc>
80105f8f:	83 c4 10             	add    $0x10,%esp
80105f92:	85 c0                	test   %eax,%eax
80105f94:	79 0a                	jns    80105fa0 <sys_pipe+0x48>
    return -1;
80105f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9b:	e9 8e 00 00 00       	jmp    8010602e <sys_pipe+0xd6>
  fd0 = -1;
80105fa0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105faa:	83 ec 0c             	sub    $0xc,%esp
80105fad:	50                   	push   %eax
80105fae:	e8 ae f3 ff ff       	call   80105361 <fdalloc>
80105fb3:	83 c4 10             	add    $0x10,%esp
80105fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fbd:	78 18                	js     80105fd7 <sys_pipe+0x7f>
80105fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fc2:	83 ec 0c             	sub    $0xc,%esp
80105fc5:	50                   	push   %eax
80105fc6:	e8 96 f3 ff ff       	call   80105361 <fdalloc>
80105fcb:	83 c4 10             	add    $0x10,%esp
80105fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd5:	79 3f                	jns    80106016 <sys_pipe+0xbe>
    if(fd0 >= 0)
80105fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fdb:	78 14                	js     80105ff1 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80105fdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fe6:	83 c2 08             	add    $0x8,%edx
80105fe9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ff0:	00 
    fileclose(rf);
80105ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	50                   	push   %eax
80105ff8:	e8 34 b0 ff ff       	call   80101031 <fileclose>
80105ffd:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106003:	83 ec 0c             	sub    $0xc,%esp
80106006:	50                   	push   %eax
80106007:	e8 25 b0 ff ff       	call   80101031 <fileclose>
8010600c:	83 c4 10             	add    $0x10,%esp
    return -1;
8010600f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106014:	eb 18                	jmp    8010602e <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106016:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106019:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010601c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010601e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106021:	8d 50 04             	lea    0x4(%eax),%edx
80106024:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106027:	89 02                	mov    %eax,(%edx)
  return 0;
80106029:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010602e:	c9                   	leave  
8010602f:	c3                   	ret    

80106030 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106036:	e8 0b e3 ff ff       	call   80104346 <fork>
}
8010603b:	c9                   	leave  
8010603c:	c3                   	ret    

8010603d <sys_exit>:

int
sys_exit(void)
{
8010603d:	55                   	push   %ebp
8010603e:	89 e5                	mov    %esp,%ebp
80106040:	83 ec 08             	sub    $0x8,%esp
  exit();
80106043:	e8 6f e4 ff ff       	call   801044b7 <exit>
  return 0;  // not reached
80106048:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010604d:	c9                   	leave  
8010604e:	c3                   	ret    

8010604f <sys_wait>:

int
sys_wait(void)
{
8010604f:	55                   	push   %ebp
80106050:	89 e5                	mov    %esp,%ebp
80106052:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106055:	e8 8b e5 ff ff       	call   801045e5 <wait>
}
8010605a:	c9                   	leave  
8010605b:	c3                   	ret    

8010605c <sys_kill>:

int
sys_kill(void)
{
8010605c:	55                   	push   %ebp
8010605d:	89 e5                	mov    %esp,%ebp
8010605f:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106062:	83 ec 08             	sub    $0x8,%esp
80106065:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106068:	50                   	push   %eax
80106069:	6a 00                	push   $0x0
8010606b:	e8 40 f1 ff ff       	call   801051b0 <argint>
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	85 c0                	test   %eax,%eax
80106075:	79 07                	jns    8010607e <sys_kill+0x22>
    return -1;
80106077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607c:	eb 0f                	jmp    8010608d <sys_kill+0x31>
  return kill(pid);
8010607e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106081:	83 ec 0c             	sub    $0xc,%esp
80106084:	50                   	push   %eax
80106085:	e8 6e e9 ff ff       	call   801049f8 <kill>
8010608a:	83 c4 10             	add    $0x10,%esp
}
8010608d:	c9                   	leave  
8010608e:	c3                   	ret    

8010608f <sys_getpid>:

int
sys_getpid(void)
{
8010608f:	55                   	push   %ebp
80106090:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106092:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106098:	8b 40 10             	mov    0x10(%eax),%eax
}
8010609b:	5d                   	pop    %ebp
8010609c:	c3                   	ret    

8010609d <sys_sbrk>:

int
sys_sbrk(void)
{
8010609d:	55                   	push   %ebp
8010609e:	89 e5                	mov    %esp,%ebp
801060a0:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060a3:	83 ec 08             	sub    $0x8,%esp
801060a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	6a 00                	push   $0x0
801060ac:	e8 ff f0 ff ff       	call   801051b0 <argint>
801060b1:	83 c4 10             	add    $0x10,%esp
801060b4:	85 c0                	test   %eax,%eax
801060b6:	79 07                	jns    801060bf <sys_sbrk+0x22>
    return -1;
801060b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bd:	eb 28                	jmp    801060e7 <sys_sbrk+0x4a>
  addr = proc->sz;
801060bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060c5:	8b 00                	mov    (%eax),%eax
801060c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801060ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cd:	83 ec 0c             	sub    $0xc,%esp
801060d0:	50                   	push   %eax
801060d1:	e8 cd e1 ff ff       	call   801042a3 <growproc>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	79 07                	jns    801060e4 <sys_sbrk+0x47>
    return -1;
801060dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e2:	eb 03                	jmp    801060e7 <sys_sbrk+0x4a>
  return addr;
801060e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801060e7:	c9                   	leave  
801060e8:	c3                   	ret    

801060e9 <sys_sleep>:

int
sys_sleep(void)
{
801060e9:	55                   	push   %ebp
801060ea:	89 e5                	mov    %esp,%ebp
801060ec:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801060ef:	83 ec 08             	sub    $0x8,%esp
801060f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060f5:	50                   	push   %eax
801060f6:	6a 00                	push   $0x0
801060f8:	e8 b3 f0 ff ff       	call   801051b0 <argint>
801060fd:	83 c4 10             	add    $0x10,%esp
80106100:	85 c0                	test   %eax,%eax
80106102:	79 07                	jns    8010610b <sys_sleep+0x22>
    return -1;
80106104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106109:	eb 77                	jmp    80106182 <sys_sleep+0x99>
  acquire(&tickslock);
8010610b:	83 ec 0c             	sub    $0xc,%esp
8010610e:	68 60 1e 11 80       	push   $0x80111e60
80106113:	e8 10 eb ff ff       	call   80104c28 <acquire>
80106118:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010611b:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106123:	eb 39                	jmp    8010615e <sys_sleep+0x75>
    if(proc->killed){
80106125:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010612b:	8b 40 24             	mov    0x24(%eax),%eax
8010612e:	85 c0                	test   %eax,%eax
80106130:	74 17                	je     80106149 <sys_sleep+0x60>
      release(&tickslock);
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	68 60 1e 11 80       	push   $0x80111e60
8010613a:	e8 50 eb ff ff       	call   80104c8f <release>
8010613f:	83 c4 10             	add    $0x10,%esp
      return -1;
80106142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106147:	eb 39                	jmp    80106182 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106149:	83 ec 08             	sub    $0x8,%esp
8010614c:	68 60 1e 11 80       	push   $0x80111e60
80106151:	68 a0 26 11 80       	push   $0x801126a0
80106156:	e8 7b e7 ff ff       	call   801048d6 <sleep>
8010615b:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010615e:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106163:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106166:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106169:	39 d0                	cmp    %edx,%eax
8010616b:	72 b8                	jb     80106125 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	68 60 1e 11 80       	push   $0x80111e60
80106175:	e8 15 eb ff ff       	call   80104c8f <release>
8010617a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010617d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106182:	c9                   	leave  
80106183:	c3                   	ret    

80106184 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
8010618a:	83 ec 0c             	sub    $0xc,%esp
8010618d:	68 60 1e 11 80       	push   $0x80111e60
80106192:	e8 91 ea ff ff       	call   80104c28 <acquire>
80106197:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010619a:	a1 a0 26 11 80       	mov    0x801126a0,%eax
8010619f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	68 60 1e 11 80       	push   $0x80111e60
801061aa:	e8 e0 ea ff ff       	call   80104c8f <release>
801061af:	83 c4 10             	add    $0x10,%esp
  return xticks;
801061b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061b5:	c9                   	leave  
801061b6:	c3                   	ret    

801061b7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801061b7:	55                   	push   %ebp
801061b8:	89 e5                	mov    %esp,%ebp
801061ba:	83 ec 08             	sub    $0x8,%esp
801061bd:	8b 55 08             	mov    0x8(%ebp),%edx
801061c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801061c3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801061c7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061ca:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801061ce:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801061d2:	ee                   	out    %al,(%dx)
}
801061d3:	90                   	nop
801061d4:	c9                   	leave  
801061d5:	c3                   	ret    

801061d6 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801061d6:	55                   	push   %ebp
801061d7:	89 e5                	mov    %esp,%ebp
801061d9:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801061dc:	6a 34                	push   $0x34
801061de:	6a 43                	push   $0x43
801061e0:	e8 d2 ff ff ff       	call   801061b7 <outb>
801061e5:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801061e8:	68 9c 00 00 00       	push   $0x9c
801061ed:	6a 40                	push   $0x40
801061ef:	e8 c3 ff ff ff       	call   801061b7 <outb>
801061f4:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801061f7:	6a 2e                	push   $0x2e
801061f9:	6a 40                	push   $0x40
801061fb:	e8 b7 ff ff ff       	call   801061b7 <outb>
80106200:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106203:	83 ec 0c             	sub    $0xc,%esp
80106206:	6a 00                	push   $0x0
80106208:	e8 2d d9 ff ff       	call   80103b3a <picenable>
8010620d:	83 c4 10             	add    $0x10,%esp
}
80106210:	90                   	nop
80106211:	c9                   	leave  
80106212:	c3                   	ret    

80106213 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106213:	1e                   	push   %ds
  pushl %es
80106214:	06                   	push   %es
  pushl %fs
80106215:	0f a0                	push   %fs
  pushl %gs
80106217:	0f a8                	push   %gs
  pushal
80106219:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010621a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010621e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106220:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106222:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106226:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106228:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010622a:	54                   	push   %esp
  call trap
8010622b:	e8 d7 01 00 00       	call   80106407 <trap>
  addl $4, %esp
80106230:	83 c4 04             	add    $0x4,%esp

80106233 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106233:	61                   	popa   
  popl %gs
80106234:	0f a9                	pop    %gs
  popl %fs
80106236:	0f a1                	pop    %fs
  popl %es
80106238:	07                   	pop    %es
  popl %ds
80106239:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010623a:	83 c4 08             	add    $0x8,%esp
  iret
8010623d:	cf                   	iret   

8010623e <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010623e:	55                   	push   %ebp
8010623f:	89 e5                	mov    %esp,%ebp
80106241:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106244:	8b 45 0c             	mov    0xc(%ebp),%eax
80106247:	83 e8 01             	sub    $0x1,%eax
8010624a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010624e:	8b 45 08             	mov    0x8(%ebp),%eax
80106251:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106255:	8b 45 08             	mov    0x8(%ebp),%eax
80106258:	c1 e8 10             	shr    $0x10,%eax
8010625b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010625f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106262:	0f 01 18             	lidtl  (%eax)
}
80106265:	90                   	nop
80106266:	c9                   	leave  
80106267:	c3                   	ret    

80106268 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106268:	55                   	push   %ebp
80106269:	89 e5                	mov    %esp,%ebp
8010626b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010626e:	0f 20 d0             	mov    %cr2,%eax
80106271:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106277:	c9                   	leave  
80106278:	c3                   	ret    

80106279 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106279:	55                   	push   %ebp
8010627a:	89 e5                	mov    %esp,%ebp
8010627c:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010627f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106286:	e9 c3 00 00 00       	jmp    8010634e <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010628b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628e:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106295:	89 c2                	mov    %eax,%edx
80106297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629a:	66 89 14 c5 a0 1e 11 	mov    %dx,-0x7feee160(,%eax,8)
801062a1:	80 
801062a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a5:	66 c7 04 c5 a2 1e 11 	movw   $0x8,-0x7feee15e(,%eax,8)
801062ac:	80 08 00 
801062af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b2:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
801062b9:	80 
801062ba:	83 e2 e0             	and    $0xffffffe0,%edx
801062bd:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
801062c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c7:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
801062ce:	80 
801062cf:	83 e2 1f             	and    $0x1f,%edx
801062d2:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
801062d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062dc:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
801062e3:	80 
801062e4:	83 e2 f0             	and    $0xfffffff0,%edx
801062e7:	83 ca 0e             	or     $0xe,%edx
801062ea:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
801062f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f4:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
801062fb:	80 
801062fc:	83 e2 ef             	and    $0xffffffef,%edx
801062ff:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106309:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106310:	80 
80106311:	83 e2 9f             	and    $0xffffff9f,%edx
80106314:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
8010631b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631e:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106325:	80 
80106326:	83 ca 80             	or     $0xffffff80,%edx
80106329:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106333:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
8010633a:	c1 e8 10             	shr    $0x10,%eax
8010633d:	89 c2                	mov    %eax,%edx
8010633f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106342:	66 89 14 c5 a6 1e 11 	mov    %dx,-0x7feee15a(,%eax,8)
80106349:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010634a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010634e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106355:	0f 8e 30 ff ff ff    	jle    8010628b <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010635b:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106360:	66 a3 a0 20 11 80    	mov    %ax,0x801120a0
80106366:	66 c7 05 a2 20 11 80 	movw   $0x8,0x801120a2
8010636d:	08 00 
8010636f:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
80106376:	83 e0 e0             	and    $0xffffffe0,%eax
80106379:	a2 a4 20 11 80       	mov    %al,0x801120a4
8010637e:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
80106385:	83 e0 1f             	and    $0x1f,%eax
80106388:	a2 a4 20 11 80       	mov    %al,0x801120a4
8010638d:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
80106394:	83 c8 0f             	or     $0xf,%eax
80106397:	a2 a5 20 11 80       	mov    %al,0x801120a5
8010639c:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801063a3:	83 e0 ef             	and    $0xffffffef,%eax
801063a6:	a2 a5 20 11 80       	mov    %al,0x801120a5
801063ab:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801063b2:	83 c8 60             	or     $0x60,%eax
801063b5:	a2 a5 20 11 80       	mov    %al,0x801120a5
801063ba:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801063c1:	83 c8 80             	or     $0xffffff80,%eax
801063c4:	a2 a5 20 11 80       	mov    %al,0x801120a5
801063c9:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801063ce:	c1 e8 10             	shr    $0x10,%eax
801063d1:	66 a3 a6 20 11 80    	mov    %ax,0x801120a6
  
  initlock(&tickslock, "time");
801063d7:	83 ec 08             	sub    $0x8,%esp
801063da:	68 94 85 10 80       	push   $0x80108594
801063df:	68 60 1e 11 80       	push   $0x80111e60
801063e4:	e8 1d e8 ff ff       	call   80104c06 <initlock>
801063e9:	83 c4 10             	add    $0x10,%esp
}
801063ec:	90                   	nop
801063ed:	c9                   	leave  
801063ee:	c3                   	ret    

801063ef <idtinit>:

void
idtinit(void)
{
801063ef:	55                   	push   %ebp
801063f0:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801063f2:	68 00 08 00 00       	push   $0x800
801063f7:	68 a0 1e 11 80       	push   $0x80111ea0
801063fc:	e8 3d fe ff ff       	call   8010623e <lidt>
80106401:	83 c4 08             	add    $0x8,%esp
}
80106404:	90                   	nop
80106405:	c9                   	leave  
80106406:	c3                   	ret    

80106407 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106407:	55                   	push   %ebp
80106408:	89 e5                	mov    %esp,%ebp
8010640a:	57                   	push   %edi
8010640b:	56                   	push   %esi
8010640c:	53                   	push   %ebx
8010640d:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106410:	8b 45 08             	mov    0x8(%ebp),%eax
80106413:	8b 40 30             	mov    0x30(%eax),%eax
80106416:	83 f8 40             	cmp    $0x40,%eax
80106419:	75 3e                	jne    80106459 <trap+0x52>
    if(proc->killed)
8010641b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106421:	8b 40 24             	mov    0x24(%eax),%eax
80106424:	85 c0                	test   %eax,%eax
80106426:	74 05                	je     8010642d <trap+0x26>
      exit();
80106428:	e8 8a e0 ff ff       	call   801044b7 <exit>
    proc->tf = tf;
8010642d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106433:	8b 55 08             	mov    0x8(%ebp),%edx
80106436:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106439:	e8 28 ee ff ff       	call   80105266 <syscall>
    if(proc->killed)
8010643e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106444:	8b 40 24             	mov    0x24(%eax),%eax
80106447:	85 c0                	test   %eax,%eax
80106449:	0f 84 1b 02 00 00    	je     8010666a <trap+0x263>
      exit();
8010644f:	e8 63 e0 ff ff       	call   801044b7 <exit>
    return;
80106454:	e9 11 02 00 00       	jmp    8010666a <trap+0x263>
  }

  switch(tf->trapno){
80106459:	8b 45 08             	mov    0x8(%ebp),%eax
8010645c:	8b 40 30             	mov    0x30(%eax),%eax
8010645f:	83 e8 20             	sub    $0x20,%eax
80106462:	83 f8 1f             	cmp    $0x1f,%eax
80106465:	0f 87 c0 00 00 00    	ja     8010652b <trap+0x124>
8010646b:	8b 04 85 3c 86 10 80 	mov    -0x7fef79c4(,%eax,4),%eax
80106472:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106474:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010647a:	0f b6 00             	movzbl (%eax),%eax
8010647d:	84 c0                	test   %al,%al
8010647f:	75 3d                	jne    801064be <trap+0xb7>
      acquire(&tickslock);
80106481:	83 ec 0c             	sub    $0xc,%esp
80106484:	68 60 1e 11 80       	push   $0x80111e60
80106489:	e8 9a e7 ff ff       	call   80104c28 <acquire>
8010648e:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106491:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106496:	83 c0 01             	add    $0x1,%eax
80106499:	a3 a0 26 11 80       	mov    %eax,0x801126a0
      wakeup(&ticks);
8010649e:	83 ec 0c             	sub    $0xc,%esp
801064a1:	68 a0 26 11 80       	push   $0x801126a0
801064a6:	e8 16 e5 ff ff       	call   801049c1 <wakeup>
801064ab:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801064ae:	83 ec 0c             	sub    $0xc,%esp
801064b1:	68 60 1e 11 80       	push   $0x80111e60
801064b6:	e8 d4 e7 ff ff       	call   80104c8f <release>
801064bb:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801064be:	e8 ac ca ff ff       	call   80102f6f <lapiceoi>
    break;
801064c3:	e9 1c 01 00 00       	jmp    801065e4 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801064c8:	e8 c5 c2 ff ff       	call   80102792 <ideintr>
    lapiceoi();
801064cd:	e8 9d ca ff ff       	call   80102f6f <lapiceoi>
    break;
801064d2:	e9 0d 01 00 00       	jmp    801065e4 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801064d7:	e8 b2 c8 ff ff       	call   80102d8e <kbdintr>
    lapiceoi();
801064dc:	e8 8e ca ff ff       	call   80102f6f <lapiceoi>
    break;
801064e1:	e9 fe 00 00 00       	jmp    801065e4 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801064e6:	e8 60 03 00 00       	call   8010684b <uartintr>
    lapiceoi();
801064eb:	e8 7f ca ff ff       	call   80102f6f <lapiceoi>
    break;
801064f0:	e9 ef 00 00 00       	jmp    801065e4 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064f5:	8b 45 08             	mov    0x8(%ebp),%eax
801064f8:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801064fb:	8b 45 08             	mov    0x8(%ebp),%eax
801064fe:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106502:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106505:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010650b:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010650e:	0f b6 c0             	movzbl %al,%eax
80106511:	51                   	push   %ecx
80106512:	52                   	push   %edx
80106513:	50                   	push   %eax
80106514:	68 9c 85 10 80       	push   $0x8010859c
80106519:	e8 a8 9e ff ff       	call   801003c6 <cprintf>
8010651e:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106521:	e8 49 ca ff ff       	call   80102f6f <lapiceoi>
    break;
80106526:	e9 b9 00 00 00       	jmp    801065e4 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010652b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106531:	85 c0                	test   %eax,%eax
80106533:	74 11                	je     80106546 <trap+0x13f>
80106535:	8b 45 08             	mov    0x8(%ebp),%eax
80106538:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010653c:	0f b7 c0             	movzwl %ax,%eax
8010653f:	83 e0 03             	and    $0x3,%eax
80106542:	85 c0                	test   %eax,%eax
80106544:	75 40                	jne    80106586 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106546:	e8 1d fd ff ff       	call   80106268 <rcr2>
8010654b:	89 c3                	mov    %eax,%ebx
8010654d:	8b 45 08             	mov    0x8(%ebp),%eax
80106550:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106553:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106559:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010655c:	0f b6 d0             	movzbl %al,%edx
8010655f:	8b 45 08             	mov    0x8(%ebp),%eax
80106562:	8b 40 30             	mov    0x30(%eax),%eax
80106565:	83 ec 0c             	sub    $0xc,%esp
80106568:	53                   	push   %ebx
80106569:	51                   	push   %ecx
8010656a:	52                   	push   %edx
8010656b:	50                   	push   %eax
8010656c:	68 c0 85 10 80       	push   $0x801085c0
80106571:	e8 50 9e ff ff       	call   801003c6 <cprintf>
80106576:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106579:	83 ec 0c             	sub    $0xc,%esp
8010657c:	68 f2 85 10 80       	push   $0x801085f2
80106581:	e8 e0 9f ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106586:	e8 dd fc ff ff       	call   80106268 <rcr2>
8010658b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010658e:	8b 45 08             	mov    0x8(%ebp),%eax
80106591:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106594:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010659a:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010659d:	0f b6 d8             	movzbl %al,%ebx
801065a0:	8b 45 08             	mov    0x8(%ebp),%eax
801065a3:	8b 48 34             	mov    0x34(%eax),%ecx
801065a6:	8b 45 08             	mov    0x8(%ebp),%eax
801065a9:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801065ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b2:	8d 78 6c             	lea    0x6c(%eax),%edi
801065b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065bb:	8b 40 10             	mov    0x10(%eax),%eax
801065be:	ff 75 e4             	pushl  -0x1c(%ebp)
801065c1:	56                   	push   %esi
801065c2:	53                   	push   %ebx
801065c3:	51                   	push   %ecx
801065c4:	52                   	push   %edx
801065c5:	57                   	push   %edi
801065c6:	50                   	push   %eax
801065c7:	68 f8 85 10 80       	push   $0x801085f8
801065cc:	e8 f5 9d ff ff       	call   801003c6 <cprintf>
801065d1:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801065d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065da:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801065e1:	eb 01                	jmp    801065e4 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801065e3:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801065e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065ea:	85 c0                	test   %eax,%eax
801065ec:	74 24                	je     80106612 <trap+0x20b>
801065ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065f4:	8b 40 24             	mov    0x24(%eax),%eax
801065f7:	85 c0                	test   %eax,%eax
801065f9:	74 17                	je     80106612 <trap+0x20b>
801065fb:	8b 45 08             	mov    0x8(%ebp),%eax
801065fe:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106602:	0f b7 c0             	movzwl %ax,%eax
80106605:	83 e0 03             	and    $0x3,%eax
80106608:	83 f8 03             	cmp    $0x3,%eax
8010660b:	75 05                	jne    80106612 <trap+0x20b>
    exit();
8010660d:	e8 a5 de ff ff       	call   801044b7 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106612:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106618:	85 c0                	test   %eax,%eax
8010661a:	74 1e                	je     8010663a <trap+0x233>
8010661c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106622:	8b 40 0c             	mov    0xc(%eax),%eax
80106625:	83 f8 04             	cmp    $0x4,%eax
80106628:	75 10                	jne    8010663a <trap+0x233>
8010662a:	8b 45 08             	mov    0x8(%ebp),%eax
8010662d:	8b 40 30             	mov    0x30(%eax),%eax
80106630:	83 f8 20             	cmp    $0x20,%eax
80106633:	75 05                	jne    8010663a <trap+0x233>
    yield();
80106635:	e8 30 e2 ff ff       	call   8010486a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010663a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106640:	85 c0                	test   %eax,%eax
80106642:	74 27                	je     8010666b <trap+0x264>
80106644:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010664a:	8b 40 24             	mov    0x24(%eax),%eax
8010664d:	85 c0                	test   %eax,%eax
8010664f:	74 1a                	je     8010666b <trap+0x264>
80106651:	8b 45 08             	mov    0x8(%ebp),%eax
80106654:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106658:	0f b7 c0             	movzwl %ax,%eax
8010665b:	83 e0 03             	and    $0x3,%eax
8010665e:	83 f8 03             	cmp    $0x3,%eax
80106661:	75 08                	jne    8010666b <trap+0x264>
    exit();
80106663:	e8 4f de ff ff       	call   801044b7 <exit>
80106668:	eb 01                	jmp    8010666b <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010666a:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010666b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010666e:	5b                   	pop    %ebx
8010666f:	5e                   	pop    %esi
80106670:	5f                   	pop    %edi
80106671:	5d                   	pop    %ebp
80106672:	c3                   	ret    

80106673 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106673:	55                   	push   %ebp
80106674:	89 e5                	mov    %esp,%ebp
80106676:	83 ec 14             	sub    $0x14,%esp
80106679:	8b 45 08             	mov    0x8(%ebp),%eax
8010667c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106680:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106684:	89 c2                	mov    %eax,%edx
80106686:	ec                   	in     (%dx),%al
80106687:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010668a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010668e:	c9                   	leave  
8010668f:	c3                   	ret    

80106690 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 08             	sub    $0x8,%esp
80106696:	8b 55 08             	mov    0x8(%ebp),%edx
80106699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010669c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801066a0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066a3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801066a7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801066ab:	ee                   	out    %al,(%dx)
}
801066ac:	90                   	nop
801066ad:	c9                   	leave  
801066ae:	c3                   	ret    

801066af <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801066af:	55                   	push   %ebp
801066b0:	89 e5                	mov    %esp,%ebp
801066b2:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801066b5:	6a 00                	push   $0x0
801066b7:	68 fa 03 00 00       	push   $0x3fa
801066bc:	e8 cf ff ff ff       	call   80106690 <outb>
801066c1:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801066c4:	68 80 00 00 00       	push   $0x80
801066c9:	68 fb 03 00 00       	push   $0x3fb
801066ce:	e8 bd ff ff ff       	call   80106690 <outb>
801066d3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801066d6:	6a 0c                	push   $0xc
801066d8:	68 f8 03 00 00       	push   $0x3f8
801066dd:	e8 ae ff ff ff       	call   80106690 <outb>
801066e2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801066e5:	6a 00                	push   $0x0
801066e7:	68 f9 03 00 00       	push   $0x3f9
801066ec:	e8 9f ff ff ff       	call   80106690 <outb>
801066f1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801066f4:	6a 03                	push   $0x3
801066f6:	68 fb 03 00 00       	push   $0x3fb
801066fb:	e8 90 ff ff ff       	call   80106690 <outb>
80106700:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106703:	6a 00                	push   $0x0
80106705:	68 fc 03 00 00       	push   $0x3fc
8010670a:	e8 81 ff ff ff       	call   80106690 <outb>
8010670f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106712:	6a 01                	push   $0x1
80106714:	68 f9 03 00 00       	push   $0x3f9
80106719:	e8 72 ff ff ff       	call   80106690 <outb>
8010671e:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106721:	68 fd 03 00 00       	push   $0x3fd
80106726:	e8 48 ff ff ff       	call   80106673 <inb>
8010672b:	83 c4 04             	add    $0x4,%esp
8010672e:	3c ff                	cmp    $0xff,%al
80106730:	74 6e                	je     801067a0 <uartinit+0xf1>
    return;
  uart = 1;
80106732:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106739:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010673c:	68 fa 03 00 00       	push   $0x3fa
80106741:	e8 2d ff ff ff       	call   80106673 <inb>
80106746:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106749:	68 f8 03 00 00       	push   $0x3f8
8010674e:	e8 20 ff ff ff       	call   80106673 <inb>
80106753:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106756:	83 ec 0c             	sub    $0xc,%esp
80106759:	6a 04                	push   $0x4
8010675b:	e8 da d3 ff ff       	call   80103b3a <picenable>
80106760:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106763:	83 ec 08             	sub    $0x8,%esp
80106766:	6a 00                	push   $0x0
80106768:	6a 04                	push   $0x4
8010676a:	e8 c5 c2 ff ff       	call   80102a34 <ioapicenable>
8010676f:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106772:	c7 45 f4 bc 86 10 80 	movl   $0x801086bc,-0xc(%ebp)
80106779:	eb 19                	jmp    80106794 <uartinit+0xe5>
    uartputc(*p);
8010677b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677e:	0f b6 00             	movzbl (%eax),%eax
80106781:	0f be c0             	movsbl %al,%eax
80106784:	83 ec 0c             	sub    $0xc,%esp
80106787:	50                   	push   %eax
80106788:	e8 16 00 00 00       	call   801067a3 <uartputc>
8010678d:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106790:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106797:	0f b6 00             	movzbl (%eax),%eax
8010679a:	84 c0                	test   %al,%al
8010679c:	75 dd                	jne    8010677b <uartinit+0xcc>
8010679e:	eb 01                	jmp    801067a1 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801067a0:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801067a1:	c9                   	leave  
801067a2:	c3                   	ret    

801067a3 <uartputc>:

void
uartputc(int c)
{
801067a3:	55                   	push   %ebp
801067a4:	89 e5                	mov    %esp,%ebp
801067a6:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801067a9:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801067ae:	85 c0                	test   %eax,%eax
801067b0:	74 53                	je     80106805 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801067b9:	eb 11                	jmp    801067cc <uartputc+0x29>
    microdelay(10);
801067bb:	83 ec 0c             	sub    $0xc,%esp
801067be:	6a 0a                	push   $0xa
801067c0:	e8 c5 c7 ff ff       	call   80102f8a <microdelay>
801067c5:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067cc:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801067d0:	7f 1a                	jg     801067ec <uartputc+0x49>
801067d2:	83 ec 0c             	sub    $0xc,%esp
801067d5:	68 fd 03 00 00       	push   $0x3fd
801067da:	e8 94 fe ff ff       	call   80106673 <inb>
801067df:	83 c4 10             	add    $0x10,%esp
801067e2:	0f b6 c0             	movzbl %al,%eax
801067e5:	83 e0 20             	and    $0x20,%eax
801067e8:	85 c0                	test   %eax,%eax
801067ea:	74 cf                	je     801067bb <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801067ec:	8b 45 08             	mov    0x8(%ebp),%eax
801067ef:	0f b6 c0             	movzbl %al,%eax
801067f2:	83 ec 08             	sub    $0x8,%esp
801067f5:	50                   	push   %eax
801067f6:	68 f8 03 00 00       	push   $0x3f8
801067fb:	e8 90 fe ff ff       	call   80106690 <outb>
80106800:	83 c4 10             	add    $0x10,%esp
80106803:	eb 01                	jmp    80106806 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106805:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106806:	c9                   	leave  
80106807:	c3                   	ret    

80106808 <uartgetc>:

static int
uartgetc(void)
{
80106808:	55                   	push   %ebp
80106809:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010680b:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106810:	85 c0                	test   %eax,%eax
80106812:	75 07                	jne    8010681b <uartgetc+0x13>
    return -1;
80106814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106819:	eb 2e                	jmp    80106849 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010681b:	68 fd 03 00 00       	push   $0x3fd
80106820:	e8 4e fe ff ff       	call   80106673 <inb>
80106825:	83 c4 04             	add    $0x4,%esp
80106828:	0f b6 c0             	movzbl %al,%eax
8010682b:	83 e0 01             	and    $0x1,%eax
8010682e:	85 c0                	test   %eax,%eax
80106830:	75 07                	jne    80106839 <uartgetc+0x31>
    return -1;
80106832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106837:	eb 10                	jmp    80106849 <uartgetc+0x41>
  return inb(COM1+0);
80106839:	68 f8 03 00 00       	push   $0x3f8
8010683e:	e8 30 fe ff ff       	call   80106673 <inb>
80106843:	83 c4 04             	add    $0x4,%esp
80106846:	0f b6 c0             	movzbl %al,%eax
}
80106849:	c9                   	leave  
8010684a:	c3                   	ret    

8010684b <uartintr>:

void
uartintr(void)
{
8010684b:	55                   	push   %ebp
8010684c:	89 e5                	mov    %esp,%ebp
8010684e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106851:	83 ec 0c             	sub    $0xc,%esp
80106854:	68 08 68 10 80       	push   $0x80106808
80106859:	e8 7f 9f ff ff       	call   801007dd <consoleintr>
8010685e:	83 c4 10             	add    $0x10,%esp
}
80106861:	90                   	nop
80106862:	c9                   	leave  
80106863:	c3                   	ret    

80106864 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $0
80106866:	6a 00                	push   $0x0
  jmp alltraps
80106868:	e9 a6 f9 ff ff       	jmp    80106213 <alltraps>

8010686d <vector1>:
.globl vector1
vector1:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $1
8010686f:	6a 01                	push   $0x1
  jmp alltraps
80106871:	e9 9d f9 ff ff       	jmp    80106213 <alltraps>

80106876 <vector2>:
.globl vector2
vector2:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $2
80106878:	6a 02                	push   $0x2
  jmp alltraps
8010687a:	e9 94 f9 ff ff       	jmp    80106213 <alltraps>

8010687f <vector3>:
.globl vector3
vector3:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $3
80106881:	6a 03                	push   $0x3
  jmp alltraps
80106883:	e9 8b f9 ff ff       	jmp    80106213 <alltraps>

80106888 <vector4>:
.globl vector4
vector4:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $4
8010688a:	6a 04                	push   $0x4
  jmp alltraps
8010688c:	e9 82 f9 ff ff       	jmp    80106213 <alltraps>

80106891 <vector5>:
.globl vector5
vector5:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $5
80106893:	6a 05                	push   $0x5
  jmp alltraps
80106895:	e9 79 f9 ff ff       	jmp    80106213 <alltraps>

8010689a <vector6>:
.globl vector6
vector6:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $6
8010689c:	6a 06                	push   $0x6
  jmp alltraps
8010689e:	e9 70 f9 ff ff       	jmp    80106213 <alltraps>

801068a3 <vector7>:
.globl vector7
vector7:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $7
801068a5:	6a 07                	push   $0x7
  jmp alltraps
801068a7:	e9 67 f9 ff ff       	jmp    80106213 <alltraps>

801068ac <vector8>:
.globl vector8
vector8:
  pushl $8
801068ac:	6a 08                	push   $0x8
  jmp alltraps
801068ae:	e9 60 f9 ff ff       	jmp    80106213 <alltraps>

801068b3 <vector9>:
.globl vector9
vector9:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $9
801068b5:	6a 09                	push   $0x9
  jmp alltraps
801068b7:	e9 57 f9 ff ff       	jmp    80106213 <alltraps>

801068bc <vector10>:
.globl vector10
vector10:
  pushl $10
801068bc:	6a 0a                	push   $0xa
  jmp alltraps
801068be:	e9 50 f9 ff ff       	jmp    80106213 <alltraps>

801068c3 <vector11>:
.globl vector11
vector11:
  pushl $11
801068c3:	6a 0b                	push   $0xb
  jmp alltraps
801068c5:	e9 49 f9 ff ff       	jmp    80106213 <alltraps>

801068ca <vector12>:
.globl vector12
vector12:
  pushl $12
801068ca:	6a 0c                	push   $0xc
  jmp alltraps
801068cc:	e9 42 f9 ff ff       	jmp    80106213 <alltraps>

801068d1 <vector13>:
.globl vector13
vector13:
  pushl $13
801068d1:	6a 0d                	push   $0xd
  jmp alltraps
801068d3:	e9 3b f9 ff ff       	jmp    80106213 <alltraps>

801068d8 <vector14>:
.globl vector14
vector14:
  pushl $14
801068d8:	6a 0e                	push   $0xe
  jmp alltraps
801068da:	e9 34 f9 ff ff       	jmp    80106213 <alltraps>

801068df <vector15>:
.globl vector15
vector15:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $15
801068e1:	6a 0f                	push   $0xf
  jmp alltraps
801068e3:	e9 2b f9 ff ff       	jmp    80106213 <alltraps>

801068e8 <vector16>:
.globl vector16
vector16:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $16
801068ea:	6a 10                	push   $0x10
  jmp alltraps
801068ec:	e9 22 f9 ff ff       	jmp    80106213 <alltraps>

801068f1 <vector17>:
.globl vector17
vector17:
  pushl $17
801068f1:	6a 11                	push   $0x11
  jmp alltraps
801068f3:	e9 1b f9 ff ff       	jmp    80106213 <alltraps>

801068f8 <vector18>:
.globl vector18
vector18:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $18
801068fa:	6a 12                	push   $0x12
  jmp alltraps
801068fc:	e9 12 f9 ff ff       	jmp    80106213 <alltraps>

80106901 <vector19>:
.globl vector19
vector19:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $19
80106903:	6a 13                	push   $0x13
  jmp alltraps
80106905:	e9 09 f9 ff ff       	jmp    80106213 <alltraps>

8010690a <vector20>:
.globl vector20
vector20:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $20
8010690c:	6a 14                	push   $0x14
  jmp alltraps
8010690e:	e9 00 f9 ff ff       	jmp    80106213 <alltraps>

80106913 <vector21>:
.globl vector21
vector21:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $21
80106915:	6a 15                	push   $0x15
  jmp alltraps
80106917:	e9 f7 f8 ff ff       	jmp    80106213 <alltraps>

8010691c <vector22>:
.globl vector22
vector22:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $22
8010691e:	6a 16                	push   $0x16
  jmp alltraps
80106920:	e9 ee f8 ff ff       	jmp    80106213 <alltraps>

80106925 <vector23>:
.globl vector23
vector23:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $23
80106927:	6a 17                	push   $0x17
  jmp alltraps
80106929:	e9 e5 f8 ff ff       	jmp    80106213 <alltraps>

8010692e <vector24>:
.globl vector24
vector24:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $24
80106930:	6a 18                	push   $0x18
  jmp alltraps
80106932:	e9 dc f8 ff ff       	jmp    80106213 <alltraps>

80106937 <vector25>:
.globl vector25
vector25:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $25
80106939:	6a 19                	push   $0x19
  jmp alltraps
8010693b:	e9 d3 f8 ff ff       	jmp    80106213 <alltraps>

80106940 <vector26>:
.globl vector26
vector26:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $26
80106942:	6a 1a                	push   $0x1a
  jmp alltraps
80106944:	e9 ca f8 ff ff       	jmp    80106213 <alltraps>

80106949 <vector27>:
.globl vector27
vector27:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $27
8010694b:	6a 1b                	push   $0x1b
  jmp alltraps
8010694d:	e9 c1 f8 ff ff       	jmp    80106213 <alltraps>

80106952 <vector28>:
.globl vector28
vector28:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $28
80106954:	6a 1c                	push   $0x1c
  jmp alltraps
80106956:	e9 b8 f8 ff ff       	jmp    80106213 <alltraps>

8010695b <vector29>:
.globl vector29
vector29:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $29
8010695d:	6a 1d                	push   $0x1d
  jmp alltraps
8010695f:	e9 af f8 ff ff       	jmp    80106213 <alltraps>

80106964 <vector30>:
.globl vector30
vector30:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $30
80106966:	6a 1e                	push   $0x1e
  jmp alltraps
80106968:	e9 a6 f8 ff ff       	jmp    80106213 <alltraps>

8010696d <vector31>:
.globl vector31
vector31:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $31
8010696f:	6a 1f                	push   $0x1f
  jmp alltraps
80106971:	e9 9d f8 ff ff       	jmp    80106213 <alltraps>

80106976 <vector32>:
.globl vector32
vector32:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $32
80106978:	6a 20                	push   $0x20
  jmp alltraps
8010697a:	e9 94 f8 ff ff       	jmp    80106213 <alltraps>

8010697f <vector33>:
.globl vector33
vector33:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $33
80106981:	6a 21                	push   $0x21
  jmp alltraps
80106983:	e9 8b f8 ff ff       	jmp    80106213 <alltraps>

80106988 <vector34>:
.globl vector34
vector34:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $34
8010698a:	6a 22                	push   $0x22
  jmp alltraps
8010698c:	e9 82 f8 ff ff       	jmp    80106213 <alltraps>

80106991 <vector35>:
.globl vector35
vector35:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $35
80106993:	6a 23                	push   $0x23
  jmp alltraps
80106995:	e9 79 f8 ff ff       	jmp    80106213 <alltraps>

8010699a <vector36>:
.globl vector36
vector36:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $36
8010699c:	6a 24                	push   $0x24
  jmp alltraps
8010699e:	e9 70 f8 ff ff       	jmp    80106213 <alltraps>

801069a3 <vector37>:
.globl vector37
vector37:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $37
801069a5:	6a 25                	push   $0x25
  jmp alltraps
801069a7:	e9 67 f8 ff ff       	jmp    80106213 <alltraps>

801069ac <vector38>:
.globl vector38
vector38:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $38
801069ae:	6a 26                	push   $0x26
  jmp alltraps
801069b0:	e9 5e f8 ff ff       	jmp    80106213 <alltraps>

801069b5 <vector39>:
.globl vector39
vector39:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $39
801069b7:	6a 27                	push   $0x27
  jmp alltraps
801069b9:	e9 55 f8 ff ff       	jmp    80106213 <alltraps>

801069be <vector40>:
.globl vector40
vector40:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $40
801069c0:	6a 28                	push   $0x28
  jmp alltraps
801069c2:	e9 4c f8 ff ff       	jmp    80106213 <alltraps>

801069c7 <vector41>:
.globl vector41
vector41:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $41
801069c9:	6a 29                	push   $0x29
  jmp alltraps
801069cb:	e9 43 f8 ff ff       	jmp    80106213 <alltraps>

801069d0 <vector42>:
.globl vector42
vector42:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $42
801069d2:	6a 2a                	push   $0x2a
  jmp alltraps
801069d4:	e9 3a f8 ff ff       	jmp    80106213 <alltraps>

801069d9 <vector43>:
.globl vector43
vector43:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $43
801069db:	6a 2b                	push   $0x2b
  jmp alltraps
801069dd:	e9 31 f8 ff ff       	jmp    80106213 <alltraps>

801069e2 <vector44>:
.globl vector44
vector44:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $44
801069e4:	6a 2c                	push   $0x2c
  jmp alltraps
801069e6:	e9 28 f8 ff ff       	jmp    80106213 <alltraps>

801069eb <vector45>:
.globl vector45
vector45:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $45
801069ed:	6a 2d                	push   $0x2d
  jmp alltraps
801069ef:	e9 1f f8 ff ff       	jmp    80106213 <alltraps>

801069f4 <vector46>:
.globl vector46
vector46:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $46
801069f6:	6a 2e                	push   $0x2e
  jmp alltraps
801069f8:	e9 16 f8 ff ff       	jmp    80106213 <alltraps>

801069fd <vector47>:
.globl vector47
vector47:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $47
801069ff:	6a 2f                	push   $0x2f
  jmp alltraps
80106a01:	e9 0d f8 ff ff       	jmp    80106213 <alltraps>

80106a06 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $48
80106a08:	6a 30                	push   $0x30
  jmp alltraps
80106a0a:	e9 04 f8 ff ff       	jmp    80106213 <alltraps>

80106a0f <vector49>:
.globl vector49
vector49:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $49
80106a11:	6a 31                	push   $0x31
  jmp alltraps
80106a13:	e9 fb f7 ff ff       	jmp    80106213 <alltraps>

80106a18 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $50
80106a1a:	6a 32                	push   $0x32
  jmp alltraps
80106a1c:	e9 f2 f7 ff ff       	jmp    80106213 <alltraps>

80106a21 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $51
80106a23:	6a 33                	push   $0x33
  jmp alltraps
80106a25:	e9 e9 f7 ff ff       	jmp    80106213 <alltraps>

80106a2a <vector52>:
.globl vector52
vector52:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $52
80106a2c:	6a 34                	push   $0x34
  jmp alltraps
80106a2e:	e9 e0 f7 ff ff       	jmp    80106213 <alltraps>

80106a33 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $53
80106a35:	6a 35                	push   $0x35
  jmp alltraps
80106a37:	e9 d7 f7 ff ff       	jmp    80106213 <alltraps>

80106a3c <vector54>:
.globl vector54
vector54:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $54
80106a3e:	6a 36                	push   $0x36
  jmp alltraps
80106a40:	e9 ce f7 ff ff       	jmp    80106213 <alltraps>

80106a45 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $55
80106a47:	6a 37                	push   $0x37
  jmp alltraps
80106a49:	e9 c5 f7 ff ff       	jmp    80106213 <alltraps>

80106a4e <vector56>:
.globl vector56
vector56:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $56
80106a50:	6a 38                	push   $0x38
  jmp alltraps
80106a52:	e9 bc f7 ff ff       	jmp    80106213 <alltraps>

80106a57 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $57
80106a59:	6a 39                	push   $0x39
  jmp alltraps
80106a5b:	e9 b3 f7 ff ff       	jmp    80106213 <alltraps>

80106a60 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $58
80106a62:	6a 3a                	push   $0x3a
  jmp alltraps
80106a64:	e9 aa f7 ff ff       	jmp    80106213 <alltraps>

80106a69 <vector59>:
.globl vector59
vector59:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $59
80106a6b:	6a 3b                	push   $0x3b
  jmp alltraps
80106a6d:	e9 a1 f7 ff ff       	jmp    80106213 <alltraps>

80106a72 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $60
80106a74:	6a 3c                	push   $0x3c
  jmp alltraps
80106a76:	e9 98 f7 ff ff       	jmp    80106213 <alltraps>

80106a7b <vector61>:
.globl vector61
vector61:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $61
80106a7d:	6a 3d                	push   $0x3d
  jmp alltraps
80106a7f:	e9 8f f7 ff ff       	jmp    80106213 <alltraps>

80106a84 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $62
80106a86:	6a 3e                	push   $0x3e
  jmp alltraps
80106a88:	e9 86 f7 ff ff       	jmp    80106213 <alltraps>

80106a8d <vector63>:
.globl vector63
vector63:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $63
80106a8f:	6a 3f                	push   $0x3f
  jmp alltraps
80106a91:	e9 7d f7 ff ff       	jmp    80106213 <alltraps>

80106a96 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $64
80106a98:	6a 40                	push   $0x40
  jmp alltraps
80106a9a:	e9 74 f7 ff ff       	jmp    80106213 <alltraps>

80106a9f <vector65>:
.globl vector65
vector65:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $65
80106aa1:	6a 41                	push   $0x41
  jmp alltraps
80106aa3:	e9 6b f7 ff ff       	jmp    80106213 <alltraps>

80106aa8 <vector66>:
.globl vector66
vector66:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $66
80106aaa:	6a 42                	push   $0x42
  jmp alltraps
80106aac:	e9 62 f7 ff ff       	jmp    80106213 <alltraps>

80106ab1 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $67
80106ab3:	6a 43                	push   $0x43
  jmp alltraps
80106ab5:	e9 59 f7 ff ff       	jmp    80106213 <alltraps>

80106aba <vector68>:
.globl vector68
vector68:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $68
80106abc:	6a 44                	push   $0x44
  jmp alltraps
80106abe:	e9 50 f7 ff ff       	jmp    80106213 <alltraps>

80106ac3 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $69
80106ac5:	6a 45                	push   $0x45
  jmp alltraps
80106ac7:	e9 47 f7 ff ff       	jmp    80106213 <alltraps>

80106acc <vector70>:
.globl vector70
vector70:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $70
80106ace:	6a 46                	push   $0x46
  jmp alltraps
80106ad0:	e9 3e f7 ff ff       	jmp    80106213 <alltraps>

80106ad5 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $71
80106ad7:	6a 47                	push   $0x47
  jmp alltraps
80106ad9:	e9 35 f7 ff ff       	jmp    80106213 <alltraps>

80106ade <vector72>:
.globl vector72
vector72:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $72
80106ae0:	6a 48                	push   $0x48
  jmp alltraps
80106ae2:	e9 2c f7 ff ff       	jmp    80106213 <alltraps>

80106ae7 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $73
80106ae9:	6a 49                	push   $0x49
  jmp alltraps
80106aeb:	e9 23 f7 ff ff       	jmp    80106213 <alltraps>

80106af0 <vector74>:
.globl vector74
vector74:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $74
80106af2:	6a 4a                	push   $0x4a
  jmp alltraps
80106af4:	e9 1a f7 ff ff       	jmp    80106213 <alltraps>

80106af9 <vector75>:
.globl vector75
vector75:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $75
80106afb:	6a 4b                	push   $0x4b
  jmp alltraps
80106afd:	e9 11 f7 ff ff       	jmp    80106213 <alltraps>

80106b02 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $76
80106b04:	6a 4c                	push   $0x4c
  jmp alltraps
80106b06:	e9 08 f7 ff ff       	jmp    80106213 <alltraps>

80106b0b <vector77>:
.globl vector77
vector77:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $77
80106b0d:	6a 4d                	push   $0x4d
  jmp alltraps
80106b0f:	e9 ff f6 ff ff       	jmp    80106213 <alltraps>

80106b14 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $78
80106b16:	6a 4e                	push   $0x4e
  jmp alltraps
80106b18:	e9 f6 f6 ff ff       	jmp    80106213 <alltraps>

80106b1d <vector79>:
.globl vector79
vector79:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $79
80106b1f:	6a 4f                	push   $0x4f
  jmp alltraps
80106b21:	e9 ed f6 ff ff       	jmp    80106213 <alltraps>

80106b26 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $80
80106b28:	6a 50                	push   $0x50
  jmp alltraps
80106b2a:	e9 e4 f6 ff ff       	jmp    80106213 <alltraps>

80106b2f <vector81>:
.globl vector81
vector81:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $81
80106b31:	6a 51                	push   $0x51
  jmp alltraps
80106b33:	e9 db f6 ff ff       	jmp    80106213 <alltraps>

80106b38 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $82
80106b3a:	6a 52                	push   $0x52
  jmp alltraps
80106b3c:	e9 d2 f6 ff ff       	jmp    80106213 <alltraps>

80106b41 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $83
80106b43:	6a 53                	push   $0x53
  jmp alltraps
80106b45:	e9 c9 f6 ff ff       	jmp    80106213 <alltraps>

80106b4a <vector84>:
.globl vector84
vector84:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $84
80106b4c:	6a 54                	push   $0x54
  jmp alltraps
80106b4e:	e9 c0 f6 ff ff       	jmp    80106213 <alltraps>

80106b53 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $85
80106b55:	6a 55                	push   $0x55
  jmp alltraps
80106b57:	e9 b7 f6 ff ff       	jmp    80106213 <alltraps>

80106b5c <vector86>:
.globl vector86
vector86:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $86
80106b5e:	6a 56                	push   $0x56
  jmp alltraps
80106b60:	e9 ae f6 ff ff       	jmp    80106213 <alltraps>

80106b65 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $87
80106b67:	6a 57                	push   $0x57
  jmp alltraps
80106b69:	e9 a5 f6 ff ff       	jmp    80106213 <alltraps>

80106b6e <vector88>:
.globl vector88
vector88:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $88
80106b70:	6a 58                	push   $0x58
  jmp alltraps
80106b72:	e9 9c f6 ff ff       	jmp    80106213 <alltraps>

80106b77 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $89
80106b79:	6a 59                	push   $0x59
  jmp alltraps
80106b7b:	e9 93 f6 ff ff       	jmp    80106213 <alltraps>

80106b80 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $90
80106b82:	6a 5a                	push   $0x5a
  jmp alltraps
80106b84:	e9 8a f6 ff ff       	jmp    80106213 <alltraps>

80106b89 <vector91>:
.globl vector91
vector91:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $91
80106b8b:	6a 5b                	push   $0x5b
  jmp alltraps
80106b8d:	e9 81 f6 ff ff       	jmp    80106213 <alltraps>

80106b92 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $92
80106b94:	6a 5c                	push   $0x5c
  jmp alltraps
80106b96:	e9 78 f6 ff ff       	jmp    80106213 <alltraps>

80106b9b <vector93>:
.globl vector93
vector93:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $93
80106b9d:	6a 5d                	push   $0x5d
  jmp alltraps
80106b9f:	e9 6f f6 ff ff       	jmp    80106213 <alltraps>

80106ba4 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $94
80106ba6:	6a 5e                	push   $0x5e
  jmp alltraps
80106ba8:	e9 66 f6 ff ff       	jmp    80106213 <alltraps>

80106bad <vector95>:
.globl vector95
vector95:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $95
80106baf:	6a 5f                	push   $0x5f
  jmp alltraps
80106bb1:	e9 5d f6 ff ff       	jmp    80106213 <alltraps>

80106bb6 <vector96>:
.globl vector96
vector96:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $96
80106bb8:	6a 60                	push   $0x60
  jmp alltraps
80106bba:	e9 54 f6 ff ff       	jmp    80106213 <alltraps>

80106bbf <vector97>:
.globl vector97
vector97:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $97
80106bc1:	6a 61                	push   $0x61
  jmp alltraps
80106bc3:	e9 4b f6 ff ff       	jmp    80106213 <alltraps>

80106bc8 <vector98>:
.globl vector98
vector98:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $98
80106bca:	6a 62                	push   $0x62
  jmp alltraps
80106bcc:	e9 42 f6 ff ff       	jmp    80106213 <alltraps>

80106bd1 <vector99>:
.globl vector99
vector99:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $99
80106bd3:	6a 63                	push   $0x63
  jmp alltraps
80106bd5:	e9 39 f6 ff ff       	jmp    80106213 <alltraps>

80106bda <vector100>:
.globl vector100
vector100:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $100
80106bdc:	6a 64                	push   $0x64
  jmp alltraps
80106bde:	e9 30 f6 ff ff       	jmp    80106213 <alltraps>

80106be3 <vector101>:
.globl vector101
vector101:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $101
80106be5:	6a 65                	push   $0x65
  jmp alltraps
80106be7:	e9 27 f6 ff ff       	jmp    80106213 <alltraps>

80106bec <vector102>:
.globl vector102
vector102:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $102
80106bee:	6a 66                	push   $0x66
  jmp alltraps
80106bf0:	e9 1e f6 ff ff       	jmp    80106213 <alltraps>

80106bf5 <vector103>:
.globl vector103
vector103:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $103
80106bf7:	6a 67                	push   $0x67
  jmp alltraps
80106bf9:	e9 15 f6 ff ff       	jmp    80106213 <alltraps>

80106bfe <vector104>:
.globl vector104
vector104:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $104
80106c00:	6a 68                	push   $0x68
  jmp alltraps
80106c02:	e9 0c f6 ff ff       	jmp    80106213 <alltraps>

80106c07 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $105
80106c09:	6a 69                	push   $0x69
  jmp alltraps
80106c0b:	e9 03 f6 ff ff       	jmp    80106213 <alltraps>

80106c10 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $106
80106c12:	6a 6a                	push   $0x6a
  jmp alltraps
80106c14:	e9 fa f5 ff ff       	jmp    80106213 <alltraps>

80106c19 <vector107>:
.globl vector107
vector107:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $107
80106c1b:	6a 6b                	push   $0x6b
  jmp alltraps
80106c1d:	e9 f1 f5 ff ff       	jmp    80106213 <alltraps>

80106c22 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $108
80106c24:	6a 6c                	push   $0x6c
  jmp alltraps
80106c26:	e9 e8 f5 ff ff       	jmp    80106213 <alltraps>

80106c2b <vector109>:
.globl vector109
vector109:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $109
80106c2d:	6a 6d                	push   $0x6d
  jmp alltraps
80106c2f:	e9 df f5 ff ff       	jmp    80106213 <alltraps>

80106c34 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $110
80106c36:	6a 6e                	push   $0x6e
  jmp alltraps
80106c38:	e9 d6 f5 ff ff       	jmp    80106213 <alltraps>

80106c3d <vector111>:
.globl vector111
vector111:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $111
80106c3f:	6a 6f                	push   $0x6f
  jmp alltraps
80106c41:	e9 cd f5 ff ff       	jmp    80106213 <alltraps>

80106c46 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $112
80106c48:	6a 70                	push   $0x70
  jmp alltraps
80106c4a:	e9 c4 f5 ff ff       	jmp    80106213 <alltraps>

80106c4f <vector113>:
.globl vector113
vector113:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $113
80106c51:	6a 71                	push   $0x71
  jmp alltraps
80106c53:	e9 bb f5 ff ff       	jmp    80106213 <alltraps>

80106c58 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $114
80106c5a:	6a 72                	push   $0x72
  jmp alltraps
80106c5c:	e9 b2 f5 ff ff       	jmp    80106213 <alltraps>

80106c61 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $115
80106c63:	6a 73                	push   $0x73
  jmp alltraps
80106c65:	e9 a9 f5 ff ff       	jmp    80106213 <alltraps>

80106c6a <vector116>:
.globl vector116
vector116:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $116
80106c6c:	6a 74                	push   $0x74
  jmp alltraps
80106c6e:	e9 a0 f5 ff ff       	jmp    80106213 <alltraps>

80106c73 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $117
80106c75:	6a 75                	push   $0x75
  jmp alltraps
80106c77:	e9 97 f5 ff ff       	jmp    80106213 <alltraps>

80106c7c <vector118>:
.globl vector118
vector118:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $118
80106c7e:	6a 76                	push   $0x76
  jmp alltraps
80106c80:	e9 8e f5 ff ff       	jmp    80106213 <alltraps>

80106c85 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $119
80106c87:	6a 77                	push   $0x77
  jmp alltraps
80106c89:	e9 85 f5 ff ff       	jmp    80106213 <alltraps>

80106c8e <vector120>:
.globl vector120
vector120:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $120
80106c90:	6a 78                	push   $0x78
  jmp alltraps
80106c92:	e9 7c f5 ff ff       	jmp    80106213 <alltraps>

80106c97 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $121
80106c99:	6a 79                	push   $0x79
  jmp alltraps
80106c9b:	e9 73 f5 ff ff       	jmp    80106213 <alltraps>

80106ca0 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $122
80106ca2:	6a 7a                	push   $0x7a
  jmp alltraps
80106ca4:	e9 6a f5 ff ff       	jmp    80106213 <alltraps>

80106ca9 <vector123>:
.globl vector123
vector123:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $123
80106cab:	6a 7b                	push   $0x7b
  jmp alltraps
80106cad:	e9 61 f5 ff ff       	jmp    80106213 <alltraps>

80106cb2 <vector124>:
.globl vector124
vector124:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $124
80106cb4:	6a 7c                	push   $0x7c
  jmp alltraps
80106cb6:	e9 58 f5 ff ff       	jmp    80106213 <alltraps>

80106cbb <vector125>:
.globl vector125
vector125:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $125
80106cbd:	6a 7d                	push   $0x7d
  jmp alltraps
80106cbf:	e9 4f f5 ff ff       	jmp    80106213 <alltraps>

80106cc4 <vector126>:
.globl vector126
vector126:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $126
80106cc6:	6a 7e                	push   $0x7e
  jmp alltraps
80106cc8:	e9 46 f5 ff ff       	jmp    80106213 <alltraps>

80106ccd <vector127>:
.globl vector127
vector127:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $127
80106ccf:	6a 7f                	push   $0x7f
  jmp alltraps
80106cd1:	e9 3d f5 ff ff       	jmp    80106213 <alltraps>

80106cd6 <vector128>:
.globl vector128
vector128:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $128
80106cd8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cdd:	e9 31 f5 ff ff       	jmp    80106213 <alltraps>

80106ce2 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $129
80106ce4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106ce9:	e9 25 f5 ff ff       	jmp    80106213 <alltraps>

80106cee <vector130>:
.globl vector130
vector130:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $130
80106cf0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cf5:	e9 19 f5 ff ff       	jmp    80106213 <alltraps>

80106cfa <vector131>:
.globl vector131
vector131:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $131
80106cfc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d01:	e9 0d f5 ff ff       	jmp    80106213 <alltraps>

80106d06 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $132
80106d08:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d0d:	e9 01 f5 ff ff       	jmp    80106213 <alltraps>

80106d12 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $133
80106d14:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d19:	e9 f5 f4 ff ff       	jmp    80106213 <alltraps>

80106d1e <vector134>:
.globl vector134
vector134:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $134
80106d20:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d25:	e9 e9 f4 ff ff       	jmp    80106213 <alltraps>

80106d2a <vector135>:
.globl vector135
vector135:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $135
80106d2c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d31:	e9 dd f4 ff ff       	jmp    80106213 <alltraps>

80106d36 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $136
80106d38:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d3d:	e9 d1 f4 ff ff       	jmp    80106213 <alltraps>

80106d42 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $137
80106d44:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d49:	e9 c5 f4 ff ff       	jmp    80106213 <alltraps>

80106d4e <vector138>:
.globl vector138
vector138:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $138
80106d50:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d55:	e9 b9 f4 ff ff       	jmp    80106213 <alltraps>

80106d5a <vector139>:
.globl vector139
vector139:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $139
80106d5c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d61:	e9 ad f4 ff ff       	jmp    80106213 <alltraps>

80106d66 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $140
80106d68:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d6d:	e9 a1 f4 ff ff       	jmp    80106213 <alltraps>

80106d72 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $141
80106d74:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d79:	e9 95 f4 ff ff       	jmp    80106213 <alltraps>

80106d7e <vector142>:
.globl vector142
vector142:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $142
80106d80:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d85:	e9 89 f4 ff ff       	jmp    80106213 <alltraps>

80106d8a <vector143>:
.globl vector143
vector143:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $143
80106d8c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d91:	e9 7d f4 ff ff       	jmp    80106213 <alltraps>

80106d96 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $144
80106d98:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d9d:	e9 71 f4 ff ff       	jmp    80106213 <alltraps>

80106da2 <vector145>:
.globl vector145
vector145:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $145
80106da4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106da9:	e9 65 f4 ff ff       	jmp    80106213 <alltraps>

80106dae <vector146>:
.globl vector146
vector146:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $146
80106db0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106db5:	e9 59 f4 ff ff       	jmp    80106213 <alltraps>

80106dba <vector147>:
.globl vector147
vector147:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $147
80106dbc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106dc1:	e9 4d f4 ff ff       	jmp    80106213 <alltraps>

80106dc6 <vector148>:
.globl vector148
vector148:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $148
80106dc8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106dcd:	e9 41 f4 ff ff       	jmp    80106213 <alltraps>

80106dd2 <vector149>:
.globl vector149
vector149:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $149
80106dd4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106dd9:	e9 35 f4 ff ff       	jmp    80106213 <alltraps>

80106dde <vector150>:
.globl vector150
vector150:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $150
80106de0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106de5:	e9 29 f4 ff ff       	jmp    80106213 <alltraps>

80106dea <vector151>:
.globl vector151
vector151:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $151
80106dec:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106df1:	e9 1d f4 ff ff       	jmp    80106213 <alltraps>

80106df6 <vector152>:
.globl vector152
vector152:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $152
80106df8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106dfd:	e9 11 f4 ff ff       	jmp    80106213 <alltraps>

80106e02 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $153
80106e04:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e09:	e9 05 f4 ff ff       	jmp    80106213 <alltraps>

80106e0e <vector154>:
.globl vector154
vector154:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $154
80106e10:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e15:	e9 f9 f3 ff ff       	jmp    80106213 <alltraps>

80106e1a <vector155>:
.globl vector155
vector155:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $155
80106e1c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e21:	e9 ed f3 ff ff       	jmp    80106213 <alltraps>

80106e26 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $156
80106e28:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e2d:	e9 e1 f3 ff ff       	jmp    80106213 <alltraps>

80106e32 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $157
80106e34:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e39:	e9 d5 f3 ff ff       	jmp    80106213 <alltraps>

80106e3e <vector158>:
.globl vector158
vector158:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $158
80106e40:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e45:	e9 c9 f3 ff ff       	jmp    80106213 <alltraps>

80106e4a <vector159>:
.globl vector159
vector159:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $159
80106e4c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e51:	e9 bd f3 ff ff       	jmp    80106213 <alltraps>

80106e56 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $160
80106e58:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e5d:	e9 b1 f3 ff ff       	jmp    80106213 <alltraps>

80106e62 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $161
80106e64:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e69:	e9 a5 f3 ff ff       	jmp    80106213 <alltraps>

80106e6e <vector162>:
.globl vector162
vector162:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $162
80106e70:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e75:	e9 99 f3 ff ff       	jmp    80106213 <alltraps>

80106e7a <vector163>:
.globl vector163
vector163:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $163
80106e7c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e81:	e9 8d f3 ff ff       	jmp    80106213 <alltraps>

80106e86 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $164
80106e88:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e8d:	e9 81 f3 ff ff       	jmp    80106213 <alltraps>

80106e92 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $165
80106e94:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e99:	e9 75 f3 ff ff       	jmp    80106213 <alltraps>

80106e9e <vector166>:
.globl vector166
vector166:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $166
80106ea0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ea5:	e9 69 f3 ff ff       	jmp    80106213 <alltraps>

80106eaa <vector167>:
.globl vector167
vector167:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $167
80106eac:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106eb1:	e9 5d f3 ff ff       	jmp    80106213 <alltraps>

80106eb6 <vector168>:
.globl vector168
vector168:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $168
80106eb8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ebd:	e9 51 f3 ff ff       	jmp    80106213 <alltraps>

80106ec2 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $169
80106ec4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ec9:	e9 45 f3 ff ff       	jmp    80106213 <alltraps>

80106ece <vector170>:
.globl vector170
vector170:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $170
80106ed0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ed5:	e9 39 f3 ff ff       	jmp    80106213 <alltraps>

80106eda <vector171>:
.globl vector171
vector171:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $171
80106edc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ee1:	e9 2d f3 ff ff       	jmp    80106213 <alltraps>

80106ee6 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $172
80106ee8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106eed:	e9 21 f3 ff ff       	jmp    80106213 <alltraps>

80106ef2 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $173
80106ef4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106ef9:	e9 15 f3 ff ff       	jmp    80106213 <alltraps>

80106efe <vector174>:
.globl vector174
vector174:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $174
80106f00:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f05:	e9 09 f3 ff ff       	jmp    80106213 <alltraps>

80106f0a <vector175>:
.globl vector175
vector175:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $175
80106f0c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f11:	e9 fd f2 ff ff       	jmp    80106213 <alltraps>

80106f16 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $176
80106f18:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f1d:	e9 f1 f2 ff ff       	jmp    80106213 <alltraps>

80106f22 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $177
80106f24:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f29:	e9 e5 f2 ff ff       	jmp    80106213 <alltraps>

80106f2e <vector178>:
.globl vector178
vector178:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $178
80106f30:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f35:	e9 d9 f2 ff ff       	jmp    80106213 <alltraps>

80106f3a <vector179>:
.globl vector179
vector179:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $179
80106f3c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f41:	e9 cd f2 ff ff       	jmp    80106213 <alltraps>

80106f46 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $180
80106f48:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f4d:	e9 c1 f2 ff ff       	jmp    80106213 <alltraps>

80106f52 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $181
80106f54:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f59:	e9 b5 f2 ff ff       	jmp    80106213 <alltraps>

80106f5e <vector182>:
.globl vector182
vector182:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $182
80106f60:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f65:	e9 a9 f2 ff ff       	jmp    80106213 <alltraps>

80106f6a <vector183>:
.globl vector183
vector183:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $183
80106f6c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f71:	e9 9d f2 ff ff       	jmp    80106213 <alltraps>

80106f76 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $184
80106f78:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f7d:	e9 91 f2 ff ff       	jmp    80106213 <alltraps>

80106f82 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $185
80106f84:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f89:	e9 85 f2 ff ff       	jmp    80106213 <alltraps>

80106f8e <vector186>:
.globl vector186
vector186:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $186
80106f90:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f95:	e9 79 f2 ff ff       	jmp    80106213 <alltraps>

80106f9a <vector187>:
.globl vector187
vector187:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $187
80106f9c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106fa1:	e9 6d f2 ff ff       	jmp    80106213 <alltraps>

80106fa6 <vector188>:
.globl vector188
vector188:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $188
80106fa8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106fad:	e9 61 f2 ff ff       	jmp    80106213 <alltraps>

80106fb2 <vector189>:
.globl vector189
vector189:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $189
80106fb4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106fb9:	e9 55 f2 ff ff       	jmp    80106213 <alltraps>

80106fbe <vector190>:
.globl vector190
vector190:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $190
80106fc0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106fc5:	e9 49 f2 ff ff       	jmp    80106213 <alltraps>

80106fca <vector191>:
.globl vector191
vector191:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $191
80106fcc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fd1:	e9 3d f2 ff ff       	jmp    80106213 <alltraps>

80106fd6 <vector192>:
.globl vector192
vector192:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $192
80106fd8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fdd:	e9 31 f2 ff ff       	jmp    80106213 <alltraps>

80106fe2 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $193
80106fe4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106fe9:	e9 25 f2 ff ff       	jmp    80106213 <alltraps>

80106fee <vector194>:
.globl vector194
vector194:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $194
80106ff0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ff5:	e9 19 f2 ff ff       	jmp    80106213 <alltraps>

80106ffa <vector195>:
.globl vector195
vector195:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $195
80106ffc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107001:	e9 0d f2 ff ff       	jmp    80106213 <alltraps>

80107006 <vector196>:
.globl vector196
vector196:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $196
80107008:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010700d:	e9 01 f2 ff ff       	jmp    80106213 <alltraps>

80107012 <vector197>:
.globl vector197
vector197:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $197
80107014:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107019:	e9 f5 f1 ff ff       	jmp    80106213 <alltraps>

8010701e <vector198>:
.globl vector198
vector198:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $198
80107020:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107025:	e9 e9 f1 ff ff       	jmp    80106213 <alltraps>

8010702a <vector199>:
.globl vector199
vector199:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $199
8010702c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107031:	e9 dd f1 ff ff       	jmp    80106213 <alltraps>

80107036 <vector200>:
.globl vector200
vector200:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $200
80107038:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010703d:	e9 d1 f1 ff ff       	jmp    80106213 <alltraps>

80107042 <vector201>:
.globl vector201
vector201:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $201
80107044:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107049:	e9 c5 f1 ff ff       	jmp    80106213 <alltraps>

8010704e <vector202>:
.globl vector202
vector202:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $202
80107050:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107055:	e9 b9 f1 ff ff       	jmp    80106213 <alltraps>

8010705a <vector203>:
.globl vector203
vector203:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $203
8010705c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107061:	e9 ad f1 ff ff       	jmp    80106213 <alltraps>

80107066 <vector204>:
.globl vector204
vector204:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $204
80107068:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010706d:	e9 a1 f1 ff ff       	jmp    80106213 <alltraps>

80107072 <vector205>:
.globl vector205
vector205:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $205
80107074:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107079:	e9 95 f1 ff ff       	jmp    80106213 <alltraps>

8010707e <vector206>:
.globl vector206
vector206:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $206
80107080:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107085:	e9 89 f1 ff ff       	jmp    80106213 <alltraps>

8010708a <vector207>:
.globl vector207
vector207:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $207
8010708c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107091:	e9 7d f1 ff ff       	jmp    80106213 <alltraps>

80107096 <vector208>:
.globl vector208
vector208:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $208
80107098:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010709d:	e9 71 f1 ff ff       	jmp    80106213 <alltraps>

801070a2 <vector209>:
.globl vector209
vector209:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $209
801070a4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801070a9:	e9 65 f1 ff ff       	jmp    80106213 <alltraps>

801070ae <vector210>:
.globl vector210
vector210:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $210
801070b0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801070b5:	e9 59 f1 ff ff       	jmp    80106213 <alltraps>

801070ba <vector211>:
.globl vector211
vector211:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $211
801070bc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801070c1:	e9 4d f1 ff ff       	jmp    80106213 <alltraps>

801070c6 <vector212>:
.globl vector212
vector212:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $212
801070c8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070cd:	e9 41 f1 ff ff       	jmp    80106213 <alltraps>

801070d2 <vector213>:
.globl vector213
vector213:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $213
801070d4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070d9:	e9 35 f1 ff ff       	jmp    80106213 <alltraps>

801070de <vector214>:
.globl vector214
vector214:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $214
801070e0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070e5:	e9 29 f1 ff ff       	jmp    80106213 <alltraps>

801070ea <vector215>:
.globl vector215
vector215:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $215
801070ec:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070f1:	e9 1d f1 ff ff       	jmp    80106213 <alltraps>

801070f6 <vector216>:
.globl vector216
vector216:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $216
801070f8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070fd:	e9 11 f1 ff ff       	jmp    80106213 <alltraps>

80107102 <vector217>:
.globl vector217
vector217:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $217
80107104:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107109:	e9 05 f1 ff ff       	jmp    80106213 <alltraps>

8010710e <vector218>:
.globl vector218
vector218:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $218
80107110:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107115:	e9 f9 f0 ff ff       	jmp    80106213 <alltraps>

8010711a <vector219>:
.globl vector219
vector219:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $219
8010711c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107121:	e9 ed f0 ff ff       	jmp    80106213 <alltraps>

80107126 <vector220>:
.globl vector220
vector220:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $220
80107128:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010712d:	e9 e1 f0 ff ff       	jmp    80106213 <alltraps>

80107132 <vector221>:
.globl vector221
vector221:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $221
80107134:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107139:	e9 d5 f0 ff ff       	jmp    80106213 <alltraps>

8010713e <vector222>:
.globl vector222
vector222:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $222
80107140:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107145:	e9 c9 f0 ff ff       	jmp    80106213 <alltraps>

8010714a <vector223>:
.globl vector223
vector223:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $223
8010714c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107151:	e9 bd f0 ff ff       	jmp    80106213 <alltraps>

80107156 <vector224>:
.globl vector224
vector224:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $224
80107158:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010715d:	e9 b1 f0 ff ff       	jmp    80106213 <alltraps>

80107162 <vector225>:
.globl vector225
vector225:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $225
80107164:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107169:	e9 a5 f0 ff ff       	jmp    80106213 <alltraps>

8010716e <vector226>:
.globl vector226
vector226:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $226
80107170:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107175:	e9 99 f0 ff ff       	jmp    80106213 <alltraps>

8010717a <vector227>:
.globl vector227
vector227:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $227
8010717c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107181:	e9 8d f0 ff ff       	jmp    80106213 <alltraps>

80107186 <vector228>:
.globl vector228
vector228:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $228
80107188:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010718d:	e9 81 f0 ff ff       	jmp    80106213 <alltraps>

80107192 <vector229>:
.globl vector229
vector229:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $229
80107194:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107199:	e9 75 f0 ff ff       	jmp    80106213 <alltraps>

8010719e <vector230>:
.globl vector230
vector230:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $230
801071a0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801071a5:	e9 69 f0 ff ff       	jmp    80106213 <alltraps>

801071aa <vector231>:
.globl vector231
vector231:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $231
801071ac:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801071b1:	e9 5d f0 ff ff       	jmp    80106213 <alltraps>

801071b6 <vector232>:
.globl vector232
vector232:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $232
801071b8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071bd:	e9 51 f0 ff ff       	jmp    80106213 <alltraps>

801071c2 <vector233>:
.globl vector233
vector233:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $233
801071c4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801071c9:	e9 45 f0 ff ff       	jmp    80106213 <alltraps>

801071ce <vector234>:
.globl vector234
vector234:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $234
801071d0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071d5:	e9 39 f0 ff ff       	jmp    80106213 <alltraps>

801071da <vector235>:
.globl vector235
vector235:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $235
801071dc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071e1:	e9 2d f0 ff ff       	jmp    80106213 <alltraps>

801071e6 <vector236>:
.globl vector236
vector236:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $236
801071e8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071ed:	e9 21 f0 ff ff       	jmp    80106213 <alltraps>

801071f2 <vector237>:
.globl vector237
vector237:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $237
801071f4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071f9:	e9 15 f0 ff ff       	jmp    80106213 <alltraps>

801071fe <vector238>:
.globl vector238
vector238:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $238
80107200:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107205:	e9 09 f0 ff ff       	jmp    80106213 <alltraps>

8010720a <vector239>:
.globl vector239
vector239:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $239
8010720c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107211:	e9 fd ef ff ff       	jmp    80106213 <alltraps>

80107216 <vector240>:
.globl vector240
vector240:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $240
80107218:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010721d:	e9 f1 ef ff ff       	jmp    80106213 <alltraps>

80107222 <vector241>:
.globl vector241
vector241:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $241
80107224:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107229:	e9 e5 ef ff ff       	jmp    80106213 <alltraps>

8010722e <vector242>:
.globl vector242
vector242:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $242
80107230:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107235:	e9 d9 ef ff ff       	jmp    80106213 <alltraps>

8010723a <vector243>:
.globl vector243
vector243:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $243
8010723c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107241:	e9 cd ef ff ff       	jmp    80106213 <alltraps>

80107246 <vector244>:
.globl vector244
vector244:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $244
80107248:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010724d:	e9 c1 ef ff ff       	jmp    80106213 <alltraps>

80107252 <vector245>:
.globl vector245
vector245:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $245
80107254:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107259:	e9 b5 ef ff ff       	jmp    80106213 <alltraps>

8010725e <vector246>:
.globl vector246
vector246:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $246
80107260:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107265:	e9 a9 ef ff ff       	jmp    80106213 <alltraps>

8010726a <vector247>:
.globl vector247
vector247:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $247
8010726c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107271:	e9 9d ef ff ff       	jmp    80106213 <alltraps>

80107276 <vector248>:
.globl vector248
vector248:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $248
80107278:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010727d:	e9 91 ef ff ff       	jmp    80106213 <alltraps>

80107282 <vector249>:
.globl vector249
vector249:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $249
80107284:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107289:	e9 85 ef ff ff       	jmp    80106213 <alltraps>

8010728e <vector250>:
.globl vector250
vector250:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $250
80107290:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107295:	e9 79 ef ff ff       	jmp    80106213 <alltraps>

8010729a <vector251>:
.globl vector251
vector251:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $251
8010729c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801072a1:	e9 6d ef ff ff       	jmp    80106213 <alltraps>

801072a6 <vector252>:
.globl vector252
vector252:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $252
801072a8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801072ad:	e9 61 ef ff ff       	jmp    80106213 <alltraps>

801072b2 <vector253>:
.globl vector253
vector253:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $253
801072b4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801072b9:	e9 55 ef ff ff       	jmp    80106213 <alltraps>

801072be <vector254>:
.globl vector254
vector254:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $254
801072c0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801072c5:	e9 49 ef ff ff       	jmp    80106213 <alltraps>

801072ca <vector255>:
.globl vector255
vector255:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $255
801072cc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072d1:	e9 3d ef ff ff       	jmp    80106213 <alltraps>

801072d6 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801072d6:	55                   	push   %ebp
801072d7:	89 e5                	mov    %esp,%ebp
801072d9:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801072dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072df:	83 e8 01             	sub    $0x1,%eax
801072e2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801072e6:	8b 45 08             	mov    0x8(%ebp),%eax
801072e9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801072ed:	8b 45 08             	mov    0x8(%ebp),%eax
801072f0:	c1 e8 10             	shr    $0x10,%eax
801072f3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801072f7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801072fa:	0f 01 10             	lgdtl  (%eax)
}
801072fd:	90                   	nop
801072fe:	c9                   	leave  
801072ff:	c3                   	ret    

80107300 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	83 ec 04             	sub    $0x4,%esp
80107306:	8b 45 08             	mov    0x8(%ebp),%eax
80107309:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010730d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107311:	0f 00 d8             	ltr    %ax
}
80107314:	90                   	nop
80107315:	c9                   	leave  
80107316:	c3                   	ret    

80107317 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107317:	55                   	push   %ebp
80107318:	89 e5                	mov    %esp,%ebp
8010731a:	83 ec 04             	sub    $0x4,%esp
8010731d:	8b 45 08             	mov    0x8(%ebp),%eax
80107320:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107324:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107328:	8e e8                	mov    %eax,%gs
}
8010732a:	90                   	nop
8010732b:	c9                   	leave  
8010732c:	c3                   	ret    

8010732d <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010732d:	55                   	push   %ebp
8010732e:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107330:	8b 45 08             	mov    0x8(%ebp),%eax
80107333:	0f 22 d8             	mov    %eax,%cr3
}
80107336:	90                   	nop
80107337:	5d                   	pop    %ebp
80107338:	c3                   	ret    

80107339 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107339:	55                   	push   %ebp
8010733a:	89 e5                	mov    %esp,%ebp
8010733c:	8b 45 08             	mov    0x8(%ebp),%eax
8010733f:	05 00 00 00 80       	add    $0x80000000,%eax
80107344:	5d                   	pop    %ebp
80107345:	c3                   	ret    

80107346 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107346:	55                   	push   %ebp
80107347:	89 e5                	mov    %esp,%ebp
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
8010734c:	05 00 00 00 80       	add    $0x80000000,%eax
80107351:	5d                   	pop    %ebp
80107352:	c3                   	ret    

80107353 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107353:	55                   	push   %ebp
80107354:	89 e5                	mov    %esp,%ebp
80107356:	53                   	push   %ebx
80107357:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010735a:	e8 b7 bb ff ff       	call   80102f16 <cpunum>
8010735f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107365:	05 20 f9 10 80       	add    $0x8010f920,%eax
8010736a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010736d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107370:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107379:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010737f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107382:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107389:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010738d:	83 e2 f0             	and    $0xfffffff0,%edx
80107390:	83 ca 0a             	or     $0xa,%edx
80107393:	88 50 7d             	mov    %dl,0x7d(%eax)
80107396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107399:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010739d:	83 ca 10             	or     $0x10,%edx
801073a0:	88 50 7d             	mov    %dl,0x7d(%eax)
801073a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801073aa:	83 e2 9f             	and    $0xffffff9f,%edx
801073ad:	88 50 7d             	mov    %dl,0x7d(%eax)
801073b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801073b7:	83 ca 80             	or     $0xffffff80,%edx
801073ba:	88 50 7d             	mov    %dl,0x7d(%eax)
801073bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801073c4:	83 ca 0f             	or     $0xf,%edx
801073c7:	88 50 7e             	mov    %dl,0x7e(%eax)
801073ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073cd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801073d1:	83 e2 ef             	and    $0xffffffef,%edx
801073d4:	88 50 7e             	mov    %dl,0x7e(%eax)
801073d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073da:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801073de:	83 e2 df             	and    $0xffffffdf,%edx
801073e1:	88 50 7e             	mov    %dl,0x7e(%eax)
801073e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801073eb:	83 ca 40             	or     $0x40,%edx
801073ee:	88 50 7e             	mov    %dl,0x7e(%eax)
801073f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801073f8:	83 ca 80             	or     $0xffffff80,%edx
801073fb:	88 50 7e             	mov    %dl,0x7e(%eax)
801073fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107401:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107405:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107408:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010740f:	ff ff 
80107411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107414:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010741b:	00 00 
8010741d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107420:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107431:	83 e2 f0             	and    $0xfffffff0,%edx
80107434:	83 ca 02             	or     $0x2,%edx
80107437:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010743d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107440:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107447:	83 ca 10             	or     $0x10,%edx
8010744a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107453:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010745a:	83 e2 9f             	and    $0xffffff9f,%edx
8010745d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107466:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010746d:	83 ca 80             	or     $0xffffff80,%edx
80107470:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107479:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107480:	83 ca 0f             	or     $0xf,%edx
80107483:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107493:	83 e2 ef             	and    $0xffffffef,%edx
80107496:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010749c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801074a6:	83 e2 df             	and    $0xffffffdf,%edx
801074a9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801074af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801074b9:	83 ca 40             	or     $0x40,%edx
801074bc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801074c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801074cc:	83 ca 80             	or     $0xffffff80,%edx
801074cf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801074d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d8:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801074df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801074e9:	ff ff 
801074eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ee:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801074f5:	00 00 
801074f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fa:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010750b:	83 e2 f0             	and    $0xfffffff0,%edx
8010750e:	83 ca 0a             	or     $0xa,%edx
80107511:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107521:	83 ca 10             	or     $0x10,%edx
80107524:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010752a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107534:	83 ca 60             	or     $0x60,%edx
80107537:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010753d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107540:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107547:	83 ca 80             	or     $0xffffff80,%edx
8010754a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107553:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010755a:	83 ca 0f             	or     $0xf,%edx
8010755d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107566:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010756d:	83 e2 ef             	and    $0xffffffef,%edx
80107570:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107579:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107580:	83 e2 df             	and    $0xffffffdf,%edx
80107583:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107593:	83 ca 40             	or     $0x40,%edx
80107596:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010759c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075a6:	83 ca 80             	or     $0xffffff80,%edx
801075a9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b2:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801075b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bc:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801075c3:	ff ff 
801075c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c8:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801075cf:	00 00 
801075d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d4:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801075db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075de:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801075e5:	83 e2 f0             	and    $0xfffffff0,%edx
801075e8:	83 ca 02             	or     $0x2,%edx
801075eb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801075f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801075fb:	83 ca 10             	or     $0x10,%edx
801075fe:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107607:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010760e:	83 ca 60             	or     $0x60,%edx
80107611:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107621:	83 ca 80             	or     $0xffffff80,%edx
80107624:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010762a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107634:	83 ca 0f             	or     $0xf,%edx
80107637:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010763d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107640:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107647:	83 e2 ef             	and    $0xffffffef,%edx
8010764a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107653:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010765a:	83 e2 df             	and    $0xffffffdf,%edx
8010765d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107666:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010766d:	83 ca 40             	or     $0x40,%edx
80107670:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107679:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107680:	83 ca 80             	or     $0xffffff80,%edx
80107683:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768c:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107696:	05 b4 00 00 00       	add    $0xb4,%eax
8010769b:	89 c3                	mov    %eax,%ebx
8010769d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a0:	05 b4 00 00 00       	add    $0xb4,%eax
801076a5:	c1 e8 10             	shr    $0x10,%eax
801076a8:	89 c2                	mov    %eax,%edx
801076aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ad:	05 b4 00 00 00       	add    $0xb4,%eax
801076b2:	c1 e8 18             	shr    $0x18,%eax
801076b5:	89 c1                	mov    %eax,%ecx
801076b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ba:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801076c1:	00 00 
801076c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c6:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801076cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d0:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801076d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d9:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801076e0:	83 e2 f0             	and    $0xfffffff0,%edx
801076e3:	83 ca 02             	or     $0x2,%edx
801076e6:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801076ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ef:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801076f6:	83 ca 10             	or     $0x10,%edx
801076f9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801076ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107702:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107709:	83 e2 9f             	and    $0xffffff9f,%edx
8010770c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107715:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010771c:	83 ca 80             	or     $0xffffff80,%edx
8010771f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107728:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010772f:	83 e2 f0             	and    $0xfffffff0,%edx
80107732:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107742:	83 e2 ef             	and    $0xffffffef,%edx
80107745:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010774b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107755:	83 e2 df             	and    $0xffffffdf,%edx
80107758:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010775e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107761:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107768:	83 ca 40             	or     $0x40,%edx
8010776b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107774:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010777b:	83 ca 80             	or     $0xffffff80,%edx
8010777e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107787:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010778d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107790:	83 c0 70             	add    $0x70,%eax
80107793:	83 ec 08             	sub    $0x8,%esp
80107796:	6a 38                	push   $0x38
80107798:	50                   	push   %eax
80107799:	e8 38 fb ff ff       	call   801072d6 <lgdt>
8010779e:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801077a1:	83 ec 0c             	sub    $0xc,%esp
801077a4:	6a 18                	push   $0x18
801077a6:	e8 6c fb ff ff       	call   80107317 <loadgs>
801077ab:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801077ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b1:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801077b7:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801077be:	00 00 00 00 
}
801077c2:	90                   	nop
801077c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801077c6:	c9                   	leave  
801077c7:	c3                   	ret    

801077c8 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801077c8:	55                   	push   %ebp
801077c9:	89 e5                	mov    %esp,%ebp
801077cb:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801077d1:	c1 e8 16             	shr    $0x16,%eax
801077d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801077db:	8b 45 08             	mov    0x8(%ebp),%eax
801077de:	01 d0                	add    %edx,%eax
801077e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801077e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077e6:	8b 00                	mov    (%eax),%eax
801077e8:	83 e0 01             	and    $0x1,%eax
801077eb:	85 c0                	test   %eax,%eax
801077ed:	74 18                	je     80107807 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801077ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077f2:	8b 00                	mov    (%eax),%eax
801077f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077f9:	50                   	push   %eax
801077fa:	e8 47 fb ff ff       	call   80107346 <p2v>
801077ff:	83 c4 04             	add    $0x4,%esp
80107802:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107805:	eb 48                	jmp    8010784f <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107807:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010780b:	74 0e                	je     8010781b <walkpgdir+0x53>
8010780d:	e8 ae b3 ff ff       	call   80102bc0 <kalloc>
80107812:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107819:	75 07                	jne    80107822 <walkpgdir+0x5a>
      return 0;
8010781b:	b8 00 00 00 00       	mov    $0x0,%eax
80107820:	eb 44                	jmp    80107866 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107822:	83 ec 04             	sub    $0x4,%esp
80107825:	68 00 10 00 00       	push   $0x1000
8010782a:	6a 00                	push   $0x0
8010782c:	ff 75 f4             	pushl  -0xc(%ebp)
8010782f:	e8 57 d6 ff ff       	call   80104e8b <memset>
80107834:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107837:	83 ec 0c             	sub    $0xc,%esp
8010783a:	ff 75 f4             	pushl  -0xc(%ebp)
8010783d:	e8 f7 fa ff ff       	call   80107339 <v2p>
80107842:	83 c4 10             	add    $0x10,%esp
80107845:	83 c8 07             	or     $0x7,%eax
80107848:	89 c2                	mov    %eax,%edx
8010784a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010784d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010784f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107852:	c1 e8 0c             	shr    $0xc,%eax
80107855:	25 ff 03 00 00       	and    $0x3ff,%eax
8010785a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107864:	01 d0                	add    %edx,%eax
}
80107866:	c9                   	leave  
80107867:	c3                   	ret    

80107868 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107868:	55                   	push   %ebp
80107869:	89 e5                	mov    %esp,%ebp
8010786b:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010786e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107871:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107879:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787c:	8b 45 10             	mov    0x10(%ebp),%eax
8010787f:	01 d0                	add    %edx,%eax
80107881:	83 e8 01             	sub    $0x1,%eax
80107884:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107889:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010788c:	83 ec 04             	sub    $0x4,%esp
8010788f:	6a 01                	push   $0x1
80107891:	ff 75 f4             	pushl  -0xc(%ebp)
80107894:	ff 75 08             	pushl  0x8(%ebp)
80107897:	e8 2c ff ff ff       	call   801077c8 <walkpgdir>
8010789c:	83 c4 10             	add    $0x10,%esp
8010789f:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078a6:	75 07                	jne    801078af <mappages+0x47>
      return -1;
801078a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078ad:	eb 47                	jmp    801078f6 <mappages+0x8e>
    if(*pte & PTE_P)
801078af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078b2:	8b 00                	mov    (%eax),%eax
801078b4:	83 e0 01             	and    $0x1,%eax
801078b7:	85 c0                	test   %eax,%eax
801078b9:	74 0d                	je     801078c8 <mappages+0x60>
      panic("remap");
801078bb:	83 ec 0c             	sub    $0xc,%esp
801078be:	68 c4 86 10 80       	push   $0x801086c4
801078c3:	e8 9e 8c ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801078c8:	8b 45 18             	mov    0x18(%ebp),%eax
801078cb:	0b 45 14             	or     0x14(%ebp),%eax
801078ce:	83 c8 01             	or     $0x1,%eax
801078d1:	89 c2                	mov    %eax,%edx
801078d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078d6:	89 10                	mov    %edx,(%eax)
    if(a == last)
801078d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801078de:	74 10                	je     801078f0 <mappages+0x88>
      break;
    a += PGSIZE;
801078e0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801078e7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801078ee:	eb 9c                	jmp    8010788c <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801078f0:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801078f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078f6:	c9                   	leave  
801078f7:	c3                   	ret    

801078f8 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801078f8:	55                   	push   %ebp
801078f9:	89 e5                	mov    %esp,%ebp
801078fb:	53                   	push   %ebx
801078fc:	83 ec 14             	sub    $0x14,%esp
  // By ShaunFong
  // initialize the variable of kalloc counter as 0
  no_of_alloc = 0;
801078ff:	c7 05 fc 26 11 80 00 	movl   $0x0,0x801126fc
80107906:	00 00 00 
  
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107909:	e8 b2 b2 ff ff       	call   80102bc0 <kalloc>
8010790e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107911:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107915:	75 0a                	jne    80107921 <setupkvm+0x29>
    return 0;
80107917:	b8 00 00 00 00       	mov    $0x0,%eax
8010791c:	e9 8e 00 00 00       	jmp    801079af <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107921:	83 ec 04             	sub    $0x4,%esp
80107924:	68 00 10 00 00       	push   $0x1000
80107929:	6a 00                	push   $0x0
8010792b:	ff 75 f0             	pushl  -0x10(%ebp)
8010792e:	e8 58 d5 ff ff       	call   80104e8b <memset>
80107933:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	68 00 00 00 0e       	push   $0xe000000
8010793e:	e8 03 fa ff ff       	call   80107346 <p2v>
80107943:	83 c4 10             	add    $0x10,%esp
80107946:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010794b:	76 0d                	jbe    8010795a <setupkvm+0x62>
    panic("PHYSTOP too high");
8010794d:	83 ec 0c             	sub    $0xc,%esp
80107950:	68 ca 86 10 80       	push   $0x801086ca
80107955:	e8 0c 8c ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010795a:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107961:	eb 40                	jmp    801079a3 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107966:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796c:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010796f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107972:	8b 58 08             	mov    0x8(%eax),%ebx
80107975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107978:	8b 40 04             	mov    0x4(%eax),%eax
8010797b:	29 c3                	sub    %eax,%ebx
8010797d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107980:	8b 00                	mov    (%eax),%eax
80107982:	83 ec 0c             	sub    $0xc,%esp
80107985:	51                   	push   %ecx
80107986:	52                   	push   %edx
80107987:	53                   	push   %ebx
80107988:	50                   	push   %eax
80107989:	ff 75 f0             	pushl  -0x10(%ebp)
8010798c:	e8 d7 fe ff ff       	call   80107868 <mappages>
80107991:	83 c4 20             	add    $0x20,%esp
80107994:	85 c0                	test   %eax,%eax
80107996:	79 07                	jns    8010799f <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107998:	b8 00 00 00 00       	mov    $0x0,%eax
8010799d:	eb 10                	jmp    801079af <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010799f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801079a3:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
801079aa:	72 b7                	jb     80107963 <setupkvm+0x6b>

  // By ShaunFong
  // display the number of calls of kalloc() during once setupkvm()
  //cprintf("The time of calls of kalloc() is: :%d\n", no_of_alloc);

  return pgdir;
801079ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801079af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079b2:	c9                   	leave  
801079b3:	c3                   	ret    

801079b4 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801079b4:	55                   	push   %ebp
801079b5:	89 e5                	mov    %esp,%ebp
801079b7:	83 ec 08             	sub    $0x8,%esp
  // By ShaunFong
  // initialize variable as 0
  //no_of_alloc = 0;

  kpgdir = setupkvm();
801079ba:	e8 39 ff ff ff       	call   801078f8 <setupkvm>
801079bf:	a3 f8 26 11 80       	mov    %eax,0x801126f8

  // By ShaunFong
  // display
  //cprintf("The number of the calls of 'kfree()' is: %d\n", no_of_alloc);

  switchkvm();
801079c4:	e8 03 00 00 00       	call   801079cc <switchkvm>
}
801079c9:	90                   	nop
801079ca:	c9                   	leave  
801079cb:	c3                   	ret    

801079cc <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801079cc:	55                   	push   %ebp
801079cd:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801079cf:	a1 f8 26 11 80       	mov    0x801126f8,%eax
801079d4:	50                   	push   %eax
801079d5:	e8 5f f9 ff ff       	call   80107339 <v2p>
801079da:	83 c4 04             	add    $0x4,%esp
801079dd:	50                   	push   %eax
801079de:	e8 4a f9 ff ff       	call   8010732d <lcr3>
801079e3:	83 c4 04             	add    $0x4,%esp
}
801079e6:	90                   	nop
801079e7:	c9                   	leave  
801079e8:	c3                   	ret    

801079e9 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801079e9:	55                   	push   %ebp
801079ea:	89 e5                	mov    %esp,%ebp
801079ec:	56                   	push   %esi
801079ed:	53                   	push   %ebx
  pushcli();
801079ee:	e8 92 d3 ff ff       	call   80104d85 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801079f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079f9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107a00:	83 c2 08             	add    $0x8,%edx
80107a03:	89 d6                	mov    %edx,%esi
80107a05:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107a0c:	83 c2 08             	add    $0x8,%edx
80107a0f:	c1 ea 10             	shr    $0x10,%edx
80107a12:	89 d3                	mov    %edx,%ebx
80107a14:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107a1b:	83 c2 08             	add    $0x8,%edx
80107a1e:	c1 ea 18             	shr    $0x18,%edx
80107a21:	89 d1                	mov    %edx,%ecx
80107a23:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107a2a:	67 00 
80107a2c:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107a33:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107a39:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107a40:	83 e2 f0             	and    $0xfffffff0,%edx
80107a43:	83 ca 09             	or     $0x9,%edx
80107a46:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107a4c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107a53:	83 ca 10             	or     $0x10,%edx
80107a56:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107a5c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107a63:	83 e2 9f             	and    $0xffffff9f,%edx
80107a66:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107a6c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107a73:	83 ca 80             	or     $0xffffff80,%edx
80107a76:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107a7c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107a83:	83 e2 f0             	and    $0xfffffff0,%edx
80107a86:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107a8c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107a93:	83 e2 ef             	and    $0xffffffef,%edx
80107a96:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107a9c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107aa3:	83 e2 df             	and    $0xffffffdf,%edx
80107aa6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107aac:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107ab3:	83 ca 40             	or     $0x40,%edx
80107ab6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107abc:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107ac3:	83 e2 7f             	and    $0x7f,%edx
80107ac6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107acc:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107ad2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ad8:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107adf:	83 e2 ef             	and    $0xffffffef,%edx
80107ae2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107ae8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107aee:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107af4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107afa:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107b01:	8b 52 08             	mov    0x8(%edx),%edx
80107b04:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107b0a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107b0d:	83 ec 0c             	sub    $0xc,%esp
80107b10:	6a 30                	push   $0x30
80107b12:	e8 e9 f7 ff ff       	call   80107300 <ltr>
80107b17:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107b1d:	8b 40 04             	mov    0x4(%eax),%eax
80107b20:	85 c0                	test   %eax,%eax
80107b22:	75 0d                	jne    80107b31 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107b24:	83 ec 0c             	sub    $0xc,%esp
80107b27:	68 db 86 10 80       	push   $0x801086db
80107b2c:	e8 35 8a ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107b31:	8b 45 08             	mov    0x8(%ebp),%eax
80107b34:	8b 40 04             	mov    0x4(%eax),%eax
80107b37:	83 ec 0c             	sub    $0xc,%esp
80107b3a:	50                   	push   %eax
80107b3b:	e8 f9 f7 ff ff       	call   80107339 <v2p>
80107b40:	83 c4 10             	add    $0x10,%esp
80107b43:	83 ec 0c             	sub    $0xc,%esp
80107b46:	50                   	push   %eax
80107b47:	e8 e1 f7 ff ff       	call   8010732d <lcr3>
80107b4c:	83 c4 10             	add    $0x10,%esp
  popcli();
80107b4f:	e8 76 d2 ff ff       	call   80104dca <popcli>
}
80107b54:	90                   	nop
80107b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b58:	5b                   	pop    %ebx
80107b59:	5e                   	pop    %esi
80107b5a:	5d                   	pop    %ebp
80107b5b:	c3                   	ret    

80107b5c <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107b5c:	55                   	push   %ebp
80107b5d:	89 e5                	mov    %esp,%ebp
80107b5f:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107b62:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b69:	76 0d                	jbe    80107b78 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107b6b:	83 ec 0c             	sub    $0xc,%esp
80107b6e:	68 ef 86 10 80       	push   $0x801086ef
80107b73:	e8 ee 89 ff ff       	call   80100566 <panic>
  mem = kalloc();
80107b78:	e8 43 b0 ff ff       	call   80102bc0 <kalloc>
80107b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107b80:	83 ec 04             	sub    $0x4,%esp
80107b83:	68 00 10 00 00       	push   $0x1000
80107b88:	6a 00                	push   $0x0
80107b8a:	ff 75 f4             	pushl  -0xc(%ebp)
80107b8d:	e8 f9 d2 ff ff       	call   80104e8b <memset>
80107b92:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107b95:	83 ec 0c             	sub    $0xc,%esp
80107b98:	ff 75 f4             	pushl  -0xc(%ebp)
80107b9b:	e8 99 f7 ff ff       	call   80107339 <v2p>
80107ba0:	83 c4 10             	add    $0x10,%esp
80107ba3:	83 ec 0c             	sub    $0xc,%esp
80107ba6:	6a 06                	push   $0x6
80107ba8:	50                   	push   %eax
80107ba9:	68 00 10 00 00       	push   $0x1000
80107bae:	6a 00                	push   $0x0
80107bb0:	ff 75 08             	pushl  0x8(%ebp)
80107bb3:	e8 b0 fc ff ff       	call   80107868 <mappages>
80107bb8:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107bbb:	83 ec 04             	sub    $0x4,%esp
80107bbe:	ff 75 10             	pushl  0x10(%ebp)
80107bc1:	ff 75 0c             	pushl  0xc(%ebp)
80107bc4:	ff 75 f4             	pushl  -0xc(%ebp)
80107bc7:	e8 7e d3 ff ff       	call   80104f4a <memmove>
80107bcc:	83 c4 10             	add    $0x10,%esp
}
80107bcf:	90                   	nop
80107bd0:	c9                   	leave  
80107bd1:	c3                   	ret    

80107bd2 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107bd2:	55                   	push   %ebp
80107bd3:	89 e5                	mov    %esp,%ebp
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bdc:	25 ff 0f 00 00       	and    $0xfff,%eax
80107be1:	85 c0                	test   %eax,%eax
80107be3:	74 0d                	je     80107bf2 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107be5:	83 ec 0c             	sub    $0xc,%esp
80107be8:	68 0c 87 10 80       	push   $0x8010870c
80107bed:	e8 74 89 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bf9:	e9 95 00 00 00       	jmp    80107c93 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c04:	01 d0                	add    %edx,%eax
80107c06:	83 ec 04             	sub    $0x4,%esp
80107c09:	6a 00                	push   $0x0
80107c0b:	50                   	push   %eax
80107c0c:	ff 75 08             	pushl  0x8(%ebp)
80107c0f:	e8 b4 fb ff ff       	call   801077c8 <walkpgdir>
80107c14:	83 c4 10             	add    $0x10,%esp
80107c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c1e:	75 0d                	jne    80107c2d <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80107c20:	83 ec 0c             	sub    $0xc,%esp
80107c23:	68 2f 87 10 80       	push   $0x8010872f
80107c28:	e8 39 89 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80107c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c30:	8b 00                	mov    (%eax),%eax
80107c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107c3a:	8b 45 18             	mov    0x18(%ebp),%eax
80107c3d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107c40:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107c45:	77 0b                	ja     80107c52 <loaduvm+0x80>
      n = sz - i;
80107c47:	8b 45 18             	mov    0x18(%ebp),%eax
80107c4a:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c50:	eb 07                	jmp    80107c59 <loaduvm+0x87>
    else
      n = PGSIZE;
80107c52:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107c59:	8b 55 14             	mov    0x14(%ebp),%edx
80107c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107c62:	83 ec 0c             	sub    $0xc,%esp
80107c65:	ff 75 e8             	pushl  -0x18(%ebp)
80107c68:	e8 d9 f6 ff ff       	call   80107346 <p2v>
80107c6d:	83 c4 10             	add    $0x10,%esp
80107c70:	ff 75 f0             	pushl  -0x10(%ebp)
80107c73:	53                   	push   %ebx
80107c74:	50                   	push   %eax
80107c75:	ff 75 10             	pushl  0x10(%ebp)
80107c78:	e8 f1 a1 ff ff       	call   80101e6e <readi>
80107c7d:	83 c4 10             	add    $0x10,%esp
80107c80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c83:	74 07                	je     80107c8c <loaduvm+0xba>
      return -1;
80107c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c8a:	eb 18                	jmp    80107ca4 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107c8c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c96:	3b 45 18             	cmp    0x18(%ebp),%eax
80107c99:	0f 82 5f ff ff ff    	jb     80107bfe <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107ca7:	c9                   	leave  
80107ca8:	c3                   	ret    

80107ca9 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ca9:	55                   	push   %ebp
80107caa:	89 e5                	mov    %esp,%ebp
80107cac:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107caf:	8b 45 10             	mov    0x10(%ebp),%eax
80107cb2:	85 c0                	test   %eax,%eax
80107cb4:	79 0a                	jns    80107cc0 <allocuvm+0x17>
    return 0;
80107cb6:	b8 00 00 00 00       	mov    $0x0,%eax
80107cbb:	e9 b0 00 00 00       	jmp    80107d70 <allocuvm+0xc7>
  if(newsz < oldsz)
80107cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80107cc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cc6:	73 08                	jae    80107cd0 <allocuvm+0x27>
    return oldsz;
80107cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ccb:	e9 a0 00 00 00       	jmp    80107d70 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80107cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd3:	05 ff 0f 00 00       	add    $0xfff,%eax
80107cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ce0:	eb 7f                	jmp    80107d61 <allocuvm+0xb8>
    mem = kalloc();
80107ce2:	e8 d9 ae ff ff       	call   80102bc0 <kalloc>
80107ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107cea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cee:	75 2b                	jne    80107d1b <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80107cf0:	83 ec 0c             	sub    $0xc,%esp
80107cf3:	68 4d 87 10 80       	push   $0x8010874d
80107cf8:	e8 c9 86 ff ff       	call   801003c6 <cprintf>
80107cfd:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107d00:	83 ec 04             	sub    $0x4,%esp
80107d03:	ff 75 0c             	pushl  0xc(%ebp)
80107d06:	ff 75 10             	pushl  0x10(%ebp)
80107d09:	ff 75 08             	pushl  0x8(%ebp)
80107d0c:	e8 61 00 00 00       	call   80107d72 <deallocuvm>
80107d11:	83 c4 10             	add    $0x10,%esp
      return 0;
80107d14:	b8 00 00 00 00       	mov    $0x0,%eax
80107d19:	eb 55                	jmp    80107d70 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80107d1b:	83 ec 04             	sub    $0x4,%esp
80107d1e:	68 00 10 00 00       	push   $0x1000
80107d23:	6a 00                	push   $0x0
80107d25:	ff 75 f0             	pushl  -0x10(%ebp)
80107d28:	e8 5e d1 ff ff       	call   80104e8b <memset>
80107d2d:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107d30:	83 ec 0c             	sub    $0xc,%esp
80107d33:	ff 75 f0             	pushl  -0x10(%ebp)
80107d36:	e8 fe f5 ff ff       	call   80107339 <v2p>
80107d3b:	83 c4 10             	add    $0x10,%esp
80107d3e:	89 c2                	mov    %eax,%edx
80107d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d43:	83 ec 0c             	sub    $0xc,%esp
80107d46:	6a 06                	push   $0x6
80107d48:	52                   	push   %edx
80107d49:	68 00 10 00 00       	push   $0x1000
80107d4e:	50                   	push   %eax
80107d4f:	ff 75 08             	pushl  0x8(%ebp)
80107d52:	e8 11 fb ff ff       	call   80107868 <mappages>
80107d57:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107d5a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d64:	3b 45 10             	cmp    0x10(%ebp),%eax
80107d67:	0f 82 75 ff ff ff    	jb     80107ce2 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107d6d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d70:	c9                   	leave  
80107d71:	c3                   	ret    

80107d72 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d72:	55                   	push   %ebp
80107d73:	89 e5                	mov    %esp,%ebp
80107d75:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d78:	8b 45 10             	mov    0x10(%ebp),%eax
80107d7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d7e:	72 08                	jb     80107d88 <deallocuvm+0x16>
    return oldsz;
80107d80:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d83:	e9 a5 00 00 00       	jmp    80107e2d <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80107d88:	8b 45 10             	mov    0x10(%ebp),%eax
80107d8b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107d98:	e9 81 00 00 00       	jmp    80107e1e <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	83 ec 04             	sub    $0x4,%esp
80107da3:	6a 00                	push   $0x0
80107da5:	50                   	push   %eax
80107da6:	ff 75 08             	pushl  0x8(%ebp)
80107da9:	e8 1a fa ff ff       	call   801077c8 <walkpgdir>
80107dae:	83 c4 10             	add    $0x10,%esp
80107db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107db4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107db8:	75 09                	jne    80107dc3 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80107dba:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107dc1:	eb 54                	jmp    80107e17 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80107dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dc6:	8b 00                	mov    (%eax),%eax
80107dc8:	83 e0 01             	and    $0x1,%eax
80107dcb:	85 c0                	test   %eax,%eax
80107dcd:	74 48                	je     80107e17 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80107dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dd2:	8b 00                	mov    (%eax),%eax
80107dd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ddc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107de0:	75 0d                	jne    80107def <deallocuvm+0x7d>
        panic("kfree");
80107de2:	83 ec 0c             	sub    $0xc,%esp
80107de5:	68 65 87 10 80       	push   $0x80108765
80107dea:	e8 77 87 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80107def:	83 ec 0c             	sub    $0xc,%esp
80107df2:	ff 75 ec             	pushl  -0x14(%ebp)
80107df5:	e8 4c f5 ff ff       	call   80107346 <p2v>
80107dfa:	83 c4 10             	add    $0x10,%esp
80107dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107e00:	83 ec 0c             	sub    $0xc,%esp
80107e03:	ff 75 e8             	pushl  -0x18(%ebp)
80107e06:	e8 18 ad ff ff       	call   80102b23 <kfree>
80107e0b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107e17:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e21:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e24:	0f 82 73 ff ff ff    	jb     80107d9d <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107e2a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e2d:	c9                   	leave  
80107e2e:	c3                   	ret    

80107e2f <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e2f:	55                   	push   %ebp
80107e30:	89 e5                	mov    %esp,%ebp
80107e32:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107e35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e39:	75 0d                	jne    80107e48 <freevm+0x19>
    panic("freevm: no pgdir");
80107e3b:	83 ec 0c             	sub    $0xc,%esp
80107e3e:	68 6b 87 10 80       	push   $0x8010876b
80107e43:	e8 1e 87 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107e48:	83 ec 04             	sub    $0x4,%esp
80107e4b:	6a 00                	push   $0x0
80107e4d:	68 00 00 00 80       	push   $0x80000000
80107e52:	ff 75 08             	pushl  0x8(%ebp)
80107e55:	e8 18 ff ff ff       	call   80107d72 <deallocuvm>
80107e5a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e64:	eb 4f                	jmp    80107eb5 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e70:	8b 45 08             	mov    0x8(%ebp),%eax
80107e73:	01 d0                	add    %edx,%eax
80107e75:	8b 00                	mov    (%eax),%eax
80107e77:	83 e0 01             	and    $0x1,%eax
80107e7a:	85 c0                	test   %eax,%eax
80107e7c:	74 33                	je     80107eb1 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e88:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8b:	01 d0                	add    %edx,%eax
80107e8d:	8b 00                	mov    (%eax),%eax
80107e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e94:	83 ec 0c             	sub    $0xc,%esp
80107e97:	50                   	push   %eax
80107e98:	e8 a9 f4 ff ff       	call   80107346 <p2v>
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107ea3:	83 ec 0c             	sub    $0xc,%esp
80107ea6:	ff 75 f0             	pushl  -0x10(%ebp)
80107ea9:	e8 75 ac ff ff       	call   80102b23 <kfree>
80107eae:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107eb1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107eb5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107ebc:	76 a8                	jbe    80107e66 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107ebe:	83 ec 0c             	sub    $0xc,%esp
80107ec1:	ff 75 08             	pushl  0x8(%ebp)
80107ec4:	e8 5a ac ff ff       	call   80102b23 <kfree>
80107ec9:	83 c4 10             	add    $0x10,%esp
}
80107ecc:	90                   	nop
80107ecd:	c9                   	leave  
80107ece:	c3                   	ret    

80107ecf <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107ecf:	55                   	push   %ebp
80107ed0:	89 e5                	mov    %esp,%ebp
80107ed2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ed5:	83 ec 04             	sub    $0x4,%esp
80107ed8:	6a 00                	push   $0x0
80107eda:	ff 75 0c             	pushl  0xc(%ebp)
80107edd:	ff 75 08             	pushl  0x8(%ebp)
80107ee0:	e8 e3 f8 ff ff       	call   801077c8 <walkpgdir>
80107ee5:	83 c4 10             	add    $0x10,%esp
80107ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107eef:	75 0d                	jne    80107efe <clearpteu+0x2f>
    panic("clearpteu");
80107ef1:	83 ec 0c             	sub    $0xc,%esp
80107ef4:	68 7c 87 10 80       	push   $0x8010877c
80107ef9:	e8 68 86 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f01:	8b 00                	mov    (%eax),%eax
80107f03:	83 e0 fb             	and    $0xfffffffb,%eax
80107f06:	89 c2                	mov    %eax,%edx
80107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0b:	89 10                	mov    %edx,(%eax)
}
80107f0d:	90                   	nop
80107f0e:	c9                   	leave  
80107f0f:	c3                   	ret    

80107f10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80107f16:	e8 dd f9 ff ff       	call   801078f8 <setupkvm>
80107f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f22:	75 0a                	jne    80107f2e <copyuvm+0x1e>
    return 0;
80107f24:	b8 00 00 00 00       	mov    $0x0,%eax
80107f29:	e9 e9 00 00 00       	jmp    80108017 <copyuvm+0x107>
  for(i = 0; i < sz; i += PGSIZE){
80107f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f35:	e9 b5 00 00 00       	jmp    80107fef <copyuvm+0xdf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3d:	83 ec 04             	sub    $0x4,%esp
80107f40:	6a 00                	push   $0x0
80107f42:	50                   	push   %eax
80107f43:	ff 75 08             	pushl  0x8(%ebp)
80107f46:	e8 7d f8 ff ff       	call   801077c8 <walkpgdir>
80107f4b:	83 c4 10             	add    $0x10,%esp
80107f4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f55:	75 0d                	jne    80107f64 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107f57:	83 ec 0c             	sub    $0xc,%esp
80107f5a:	68 86 87 10 80       	push   $0x80108786
80107f5f:	e8 02 86 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80107f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f67:	8b 00                	mov    (%eax),%eax
80107f69:	83 e0 01             	and    $0x1,%eax
80107f6c:	85 c0                	test   %eax,%eax
80107f6e:	75 0d                	jne    80107f7d <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107f70:	83 ec 0c             	sub    $0xc,%esp
80107f73:	68 a0 87 10 80       	push   $0x801087a0
80107f78:	e8 e9 85 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80107f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f80:	8b 00                	mov    (%eax),%eax
80107f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f87:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80107f8a:	e8 31 ac ff ff       	call   80102bc0 <kalloc>
80107f8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80107f96:	74 68                	je     80108000 <copyuvm+0xf0>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80107f98:	83 ec 0c             	sub    $0xc,%esp
80107f9b:	ff 75 e8             	pushl  -0x18(%ebp)
80107f9e:	e8 a3 f3 ff ff       	call   80107346 <p2v>
80107fa3:	83 c4 10             	add    $0x10,%esp
80107fa6:	83 ec 04             	sub    $0x4,%esp
80107fa9:	68 00 10 00 00       	push   $0x1000
80107fae:	50                   	push   %eax
80107faf:	ff 75 e4             	pushl  -0x1c(%ebp)
80107fb2:	e8 93 cf ff ff       	call   80104f4a <memmove>
80107fb7:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80107fba:	83 ec 0c             	sub    $0xc,%esp
80107fbd:	ff 75 e4             	pushl  -0x1c(%ebp)
80107fc0:	e8 74 f3 ff ff       	call   80107339 <v2p>
80107fc5:	83 c4 10             	add    $0x10,%esp
80107fc8:	89 c2                	mov    %eax,%edx
80107fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcd:	83 ec 0c             	sub    $0xc,%esp
80107fd0:	6a 06                	push   $0x6
80107fd2:	52                   	push   %edx
80107fd3:	68 00 10 00 00       	push   $0x1000
80107fd8:	50                   	push   %eax
80107fd9:	ff 75 f0             	pushl  -0x10(%ebp)
80107fdc:	e8 87 f8 ff ff       	call   80107868 <mappages>
80107fe1:	83 c4 20             	add    $0x20,%esp
80107fe4:	85 c0                	test   %eax,%eax
80107fe6:	78 1b                	js     80108003 <copyuvm+0xf3>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107fe8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ff5:	0f 82 3f ff ff ff    	jb     80107f3a <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80107ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ffe:	eb 17                	jmp    80108017 <copyuvm+0x107>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108000:	90                   	nop
80108001:	eb 01                	jmp    80108004 <copyuvm+0xf4>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108003:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108004:	83 ec 0c             	sub    $0xc,%esp
80108007:	ff 75 f0             	pushl  -0x10(%ebp)
8010800a:	e8 20 fe ff ff       	call   80107e2f <freevm>
8010800f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108012:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108017:	c9                   	leave  
80108018:	c3                   	ret    

80108019 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108019:	55                   	push   %ebp
8010801a:	89 e5                	mov    %esp,%ebp
8010801c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010801f:	83 ec 04             	sub    $0x4,%esp
80108022:	6a 00                	push   $0x0
80108024:	ff 75 0c             	pushl  0xc(%ebp)
80108027:	ff 75 08             	pushl  0x8(%ebp)
8010802a:	e8 99 f7 ff ff       	call   801077c8 <walkpgdir>
8010802f:	83 c4 10             	add    $0x10,%esp
80108032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108038:	8b 00                	mov    (%eax),%eax
8010803a:	83 e0 01             	and    $0x1,%eax
8010803d:	85 c0                	test   %eax,%eax
8010803f:	75 07                	jne    80108048 <uva2ka+0x2f>
    return 0;
80108041:	b8 00 00 00 00       	mov    $0x0,%eax
80108046:	eb 29                	jmp    80108071 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	8b 00                	mov    (%eax),%eax
8010804d:	83 e0 04             	and    $0x4,%eax
80108050:	85 c0                	test   %eax,%eax
80108052:	75 07                	jne    8010805b <uva2ka+0x42>
    return 0;
80108054:	b8 00 00 00 00       	mov    $0x0,%eax
80108059:	eb 16                	jmp    80108071 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010805b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805e:	8b 00                	mov    (%eax),%eax
80108060:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108065:	83 ec 0c             	sub    $0xc,%esp
80108068:	50                   	push   %eax
80108069:	e8 d8 f2 ff ff       	call   80107346 <p2v>
8010806e:	83 c4 10             	add    $0x10,%esp
}
80108071:	c9                   	leave  
80108072:	c3                   	ret    

80108073 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108073:	55                   	push   %ebp
80108074:	89 e5                	mov    %esp,%ebp
80108076:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108079:	8b 45 10             	mov    0x10(%ebp),%eax
8010807c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010807f:	eb 7f                	jmp    80108100 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108081:	8b 45 0c             	mov    0xc(%ebp),%eax
80108084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108089:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010808c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010808f:	83 ec 08             	sub    $0x8,%esp
80108092:	50                   	push   %eax
80108093:	ff 75 08             	pushl  0x8(%ebp)
80108096:	e8 7e ff ff ff       	call   80108019 <uva2ka>
8010809b:	83 c4 10             	add    $0x10,%esp
8010809e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801080a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801080a5:	75 07                	jne    801080ae <copyout+0x3b>
      return -1;
801080a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ac:	eb 61                	jmp    8010810f <copyout+0x9c>
    n = PGSIZE - (va - va0);
801080ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080b1:	2b 45 0c             	sub    0xc(%ebp),%eax
801080b4:	05 00 10 00 00       	add    $0x1000,%eax
801080b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801080bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bf:	3b 45 14             	cmp    0x14(%ebp),%eax
801080c2:	76 06                	jbe    801080ca <copyout+0x57>
      n = len;
801080c4:	8b 45 14             	mov    0x14(%ebp),%eax
801080c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801080ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801080cd:	2b 45 ec             	sub    -0x14(%ebp),%eax
801080d0:	89 c2                	mov    %eax,%edx
801080d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080d5:	01 d0                	add    %edx,%eax
801080d7:	83 ec 04             	sub    $0x4,%esp
801080da:	ff 75 f0             	pushl  -0x10(%ebp)
801080dd:	ff 75 f4             	pushl  -0xc(%ebp)
801080e0:	50                   	push   %eax
801080e1:	e8 64 ce ff ff       	call   80104f4a <memmove>
801080e6:	83 c4 10             	add    $0x10,%esp
    len -= n;
801080e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ec:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801080ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f2:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801080f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080f8:	05 00 10 00 00       	add    $0x1000,%eax
801080fd:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108100:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108104:	0f 85 77 ff ff ff    	jne    80108081 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010810a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010810f:	c9                   	leave  
80108110:	c3                   	ret    
