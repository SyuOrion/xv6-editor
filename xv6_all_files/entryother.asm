
bootblockother.o:     file format elf32-i386


Disassembly of section .text:

00007000 <start>:
#   - it uses the address at start-4, start-8, and start-12

.code16           
.globl start
start:
  cli            
    7000:	fa                   	cli    

  xorw    %ax,%ax
    7001:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds
    7003:	8e d8                	mov    %eax,%ds
  movw    %ax,%es
    7005:	8e c0                	mov    %eax,%es
  movw    %ax,%ss
    7007:	8e d0                	mov    %eax,%ss

  lgdt    gdtdesc
    7009:	0f 01 16             	lgdtl  (%esi)
    700c:	84 70 0f             	test   %dh,0xf(%eax)
  movl    %cr0, %eax
    700f:	20 c0                	and    %al,%al
  orl     $CR0_PE, %eax
    7011:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7015:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  ljmpl    $(SEG_KCODE<<3), $(start32)
    7018:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
    701e:	08 00                	or     %al,(%eax)

00007020 <start32>:

.code32
start32:
  movw    $(SEG_KDATA<<3), %ax
    7020:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds
    7024:	8e d8                	mov    %eax,%ds
  movw    %ax, %es
    7026:	8e c0                	mov    %eax,%es
  movw    %ax, %ss
    7028:	8e d0                	mov    %eax,%ss
  movw    $0, %ax
    702a:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs
    702e:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs
    7030:	8e e8                	mov    %eax,%gs

  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
    7032:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
    7035:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
    7038:	0f 22 e0             	mov    %eax,%cr4
  # Use enterpgdir as our initial page table
  movl    (start-12), %eax
    703b:	a1 f4 6f 00 00       	mov    0x6ff4,%eax
  movl    %eax, %cr3
    7040:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
    7043:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
    7046:	0d 01 00 01 80       	or     $0x80010001,%eax
  movl    %eax, %cr0
    704b:	0f 22 c0             	mov    %eax,%cr0

  # Switch to the stack allocated by startothers()
  movl    (start-4), %esp
    704e:	8b 25 fc 6f 00 00    	mov    0x6ffc,%esp
  # Call mpenter()
  call	 *(start-8)
    7054:	ff 15 f8 6f 00 00    	call   *0x6ff8

  movw    $0x8a00, %ax
    705a:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    705e:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7061:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax
    7063:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7067:	66 ef                	out    %ax,(%dx)

00007069 <spin>:
spin:
  jmp     spin
    7069:	eb fe                	jmp    7069 <spin>
    706b:	90                   	nop

0000706c <gdt>:
	...
    7074:	ff                   	(bad)  
    7075:	ff 00                	incl   (%eax)
    7077:	00 00                	add    %al,(%eax)
    7079:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7080:	00                   	.byte 0x0
    7081:	92                   	xchg   %eax,%edx
    7082:	cf                   	iret   
	...

00007084 <gdtdesc>:
    7084:	17                   	pop    %ss
    7085:	00 6c 70 00          	add    %ch,0x0(%eax,%esi,2)
	...
