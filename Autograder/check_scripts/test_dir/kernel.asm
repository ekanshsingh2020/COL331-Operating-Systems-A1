
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc 10 34 10 00       	mov    $0x103410,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 90 06 10 00       	mov    $0x100690,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax
  100018:	66 90                	xchg   %ax,%ax
  10001a:	66 90                	xchg   %ax,%ax
  10001c:	66 90                	xchg   %ax,%ax
  10001e:	66 90                	xchg   %ax,%ax

00100020 <printint>:
static void consputc(int);
static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100020:	55                   	push   %ebp
  100021:	89 e5                	mov    %esp,%ebp
  100023:	57                   	push   %edi
  100024:	56                   	push   %esi
  100025:	53                   	push   %ebx
  100026:	83 ec 2c             	sub    $0x2c,%esp
  100029:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10002c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  10002f:	85 c9                	test   %ecx,%ecx
  100031:	74 04                	je     100037 <printint+0x17>
  100033:	85 c0                	test   %eax,%eax
  100035:	78 79                	js     1000b0 <printint+0x90>
    x = -xx;
  else
    x = xx;
  100037:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  10003e:	89 c1                	mov    %eax,%ecx

  i = 0;
  100040:	31 db                	xor    %ebx,%ebx
  100042:	8d 7d d7             	lea    -0x29(%ebp),%edi
  100045:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
  100048:	89 c8                	mov    %ecx,%eax
  10004a:	31 d2                	xor    %edx,%edx
  10004c:	89 ce                	mov    %ecx,%esi
  10004e:	f7 75 d4             	divl   -0x2c(%ebp)
  100051:	0f be 92 a8 1b 10 00 	movsbl 0x101ba8(%edx),%edx
  100058:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10005b:	89 d8                	mov    %ebx,%eax
  10005d:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
  100060:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    buf[i++] = digits[x % base];
  100063:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
  100066:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
  100069:	73 dd                	jae    100048 <printint+0x28>
  10006b:	89 c6                	mov    %eax,%esi

  if(sign)
  10006d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  100070:	85 c0                	test   %eax,%eax
  100072:	74 0c                	je     100080 <printint+0x60>
    buf[i++] = '-';
  100074:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
  100079:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
  10007b:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
  100080:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  100084:	eb 10                	jmp    100096 <printint+0x76>
  100086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10008d:	8d 76 00             	lea    0x0(%esi),%esi
  100090:	0f be 13             	movsbl (%ebx),%edx
  100093:	83 eb 01             	sub    $0x1,%ebx
consputc(int c)
{
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  100096:	83 ec 0c             	sub    $0xc,%esp
  100099:	52                   	push   %edx
  10009a:	e8 b1 09 00 00       	call   100a50 <uartputc>
  while(--i >= 0)
  10009f:	83 c4 10             	add    $0x10,%esp
  1000a2:	39 fb                	cmp    %edi,%ebx
  1000a4:	75 ea                	jne    100090 <printint+0x70>
}
  1000a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1000a9:	5b                   	pop    %ebx
  1000aa:	5e                   	pop    %esi
  1000ab:	5f                   	pop    %edi
  1000ac:	5d                   	pop    %ebp
  1000ad:	c3                   	ret    
  1000ae:	66 90                	xchg   %ax,%ax
    x = -xx;
  1000b0:	f7 d8                	neg    %eax
  1000b2:	89 c1                	mov    %eax,%ecx
  1000b4:	eb 8a                	jmp    100040 <printint+0x20>
  1000b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1000bd:	8d 76 00             	lea    0x0(%esi),%esi

001000c0 <consputc.part.0>:
consputc(int c)
  1000c0:	55                   	push   %ebp
  1000c1:	89 e5                	mov    %esp,%ebp
  1000c3:	83 ec 14             	sub    $0x14,%esp
    uartputc('\b'); uartputc(' '); uartputc('\b');
  1000c6:	6a 08                	push   $0x8
  1000c8:	e8 83 09 00 00       	call   100a50 <uartputc>
  1000cd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1000d4:	e8 77 09 00 00       	call   100a50 <uartputc>
  1000d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1000e0:	e8 6b 09 00 00       	call   100a50 <uartputc>
}
  1000e5:	83 c4 10             	add    $0x10,%esp
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    
  1000ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001000f0 <cprintf>:
{
  1000f0:	f3 0f 1e fb          	endbr32 
  1000f4:	55                   	push   %ebp
  1000f5:	89 e5                	mov    %esp,%ebp
  1000f7:	57                   	push   %edi
  1000f8:	56                   	push   %esi
  1000f9:	53                   	push   %ebx
  1000fa:	83 ec 1c             	sub    $0x1c,%esp
  if (fmt == 0)
  1000fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100103:	85 c0                	test   %eax,%eax
  100105:	0f 84 88 00 00 00    	je     100193 <cprintf+0xa3>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10010b:	0f b6 10             	movzbl (%eax),%edx
  10010e:	85 d2                	test   %edx,%edx
  100110:	0f 84 7d 00 00 00    	je     100193 <cprintf+0xa3>
  argp = (uint*)(void*)(&fmt + 1);
  100116:	8d 45 0c             	lea    0xc(%ebp),%eax
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100119:	31 db                	xor    %ebx,%ebx
  10011b:	eb 4d                	jmp    10016a <cprintf+0x7a>
  10011d:	8d 76 00             	lea    0x0(%esi),%esi
    c = fmt[++i] & 0xff;
  100120:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
  100123:	85 d2                	test   %edx,%edx
  100125:	74 6c                	je     100193 <cprintf+0xa3>
    switch(c){
  100127:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10012a:	83 c3 02             	add    $0x2,%ebx
  10012d:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  100130:	83 fa 70             	cmp    $0x70,%edx
  100133:	0f 84 b4 00 00 00    	je     1001ed <cprintf+0xfd>
  100139:	7f 65                	jg     1001a0 <cprintf+0xb0>
  10013b:	83 fa 25             	cmp    $0x25,%edx
  10013e:	0f 84 ec 00 00 00    	je     100230 <cprintf+0x140>
  100144:	83 fa 64             	cmp    $0x64,%edx
  100147:	0f 85 b8 00 00 00    	jne    100205 <cprintf+0x115>
      printint(*argp++, 10, 1);
  10014d:	8d 78 04             	lea    0x4(%eax),%edi
  100150:	8b 00                	mov    (%eax),%eax
  100152:	b9 01 00 00 00       	mov    $0x1,%ecx
  100157:	ba 0a 00 00 00       	mov    $0xa,%edx
  10015c:	e8 bf fe ff ff       	call   100020 <printint>
  100161:	89 f8                	mov    %edi,%eax
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100163:	0f b6 16             	movzbl (%esi),%edx
  100166:	85 d2                	test   %edx,%edx
  100168:	74 29                	je     100193 <cprintf+0xa3>
    if(c != '%'){
  10016a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10016d:	8d 7b 01             	lea    0x1(%ebx),%edi
  100170:	8d 34 39             	lea    (%ecx,%edi,1),%esi
  100173:	83 fa 25             	cmp    $0x25,%edx
  100176:	74 a8                	je     100120 <cprintf+0x30>
    uartputc(c);
  100178:	83 ec 0c             	sub    $0xc,%esp
  10017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      continue;
  10017e:	89 fb                	mov    %edi,%ebx
    uartputc(c);
  100180:	52                   	push   %edx
  100181:	e8 ca 08 00 00       	call   100a50 <uartputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100186:	0f b6 16             	movzbl (%esi),%edx
      continue;
  100189:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10018c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10018f:	85 d2                	test   %edx,%edx
  100191:	75 d7                	jne    10016a <cprintf+0x7a>
}
  100193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100196:	5b                   	pop    %ebx
  100197:	5e                   	pop    %esi
  100198:	5f                   	pop    %edi
  100199:	5d                   	pop    %ebp
  10019a:	c3                   	ret    
  10019b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10019f:	90                   	nop
    switch(c){
  1001a0:	83 fa 73             	cmp    $0x73,%edx
  1001a3:	75 43                	jne    1001e8 <cprintf+0xf8>
      if((s = (char*)*argp++) == 0)
  1001a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1001a8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  1001ab:	8b 08                	mov    (%eax),%ecx
  1001ad:	85 c9                	test   %ecx,%ecx
  1001af:	0f 84 9b 00 00 00    	je     100250 <cprintf+0x160>
      for(; *s; s++)
  1001b5:	0f be 11             	movsbl (%ecx),%edx
      if((s = (char*)*argp++) == 0)
  1001b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1001bb:	89 cf                	mov    %ecx,%edi
      for(; *s; s++)
  1001bd:	84 d2                	test   %dl,%dl
  1001bf:	74 a2                	je     100163 <cprintf+0x73>
  1001c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
  1001c8:	83 ec 0c             	sub    $0xc,%esp
      for(; *s; s++)
  1001cb:	83 c7 01             	add    $0x1,%edi
    uartputc(c);
  1001ce:	52                   	push   %edx
  1001cf:	e8 7c 08 00 00       	call   100a50 <uartputc>
      for(; *s; s++)
  1001d4:	0f be 17             	movsbl (%edi),%edx
  1001d7:	83 c4 10             	add    $0x10,%esp
  1001da:	84 d2                	test   %dl,%dl
  1001dc:	75 ea                	jne    1001c8 <cprintf+0xd8>
}
  1001de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1001e1:	eb 80                	jmp    100163 <cprintf+0x73>
  1001e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1001e7:	90                   	nop
    switch(c){
  1001e8:	83 fa 78             	cmp    $0x78,%edx
  1001eb:	75 18                	jne    100205 <cprintf+0x115>
      printint(*argp++, 16, 0);
  1001ed:	8d 78 04             	lea    0x4(%eax),%edi
  1001f0:	8b 00                	mov    (%eax),%eax
  1001f2:	31 c9                	xor    %ecx,%ecx
  1001f4:	ba 10 00 00 00       	mov    $0x10,%edx
  1001f9:	e8 22 fe ff ff       	call   100020 <printint>
  1001fe:	89 f8                	mov    %edi,%eax
      break;
  100200:	e9 5e ff ff ff       	jmp    100163 <cprintf+0x73>
    uartputc(c);
  100205:	83 ec 0c             	sub    $0xc,%esp
  100208:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10020b:	6a 25                	push   $0x25
  10020d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  100210:	e8 3b 08 00 00       	call   100a50 <uartputc>
  100215:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100218:	89 14 24             	mov    %edx,(%esp)
  10021b:	e8 30 08 00 00       	call   100a50 <uartputc>
}
  100220:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100223:	83 c4 10             	add    $0x10,%esp
  100226:	e9 38 ff ff ff       	jmp    100163 <cprintf+0x73>
  10022b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10022f:	90                   	nop
    uartputc(c);
  100230:	83 ec 0c             	sub    $0xc,%esp
  100233:	89 45 e0             	mov    %eax,-0x20(%ebp)
  100236:	6a 25                	push   $0x25
  100238:	e8 13 08 00 00       	call   100a50 <uartputc>
}
  10023d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100240:	83 c4 10             	add    $0x10,%esp
  100243:	e9 1b ff ff ff       	jmp    100163 <cprintf+0x73>
  100248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10024f:	90                   	nop
        s = "(null)";
  100250:	bf 78 1b 10 00       	mov    $0x101b78,%edi
      for(; *s; s++)
  100255:	ba 28 00 00 00       	mov    $0x28,%edx
  10025a:	e9 69 ff ff ff       	jmp    1001c8 <cprintf+0xd8>
  10025f:	90                   	nop

00100260 <halt>:
{
  100260:	f3 0f 1e fb          	endbr32 
  100264:	55                   	push   %ebp
  100265:	89 e5                	mov    %esp,%ebp
  100267:	83 ec 10             	sub    $0x10,%esp
  cprintf("Bye COL%d!\n\0", 331);
  10026a:	68 4b 01 00 00       	push   $0x14b
  10026f:	68 98 1b 10 00       	push   $0x101b98
  100274:	e8 77 fe ff ff       	call   1000f0 <cprintf>
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100279:	b8 00 20 00 00       	mov    $0x2000,%eax
  10027e:	ba 02 06 00 00       	mov    $0x602,%edx
  100283:	66 ef                	out    %ax,(%dx)
  100285:	ba 02 b0 ff ff       	mov    $0xffffb002,%edx
  10028a:	66 ef                	out    %ax,(%dx)
}
  10028c:	83 c4 10             	add    $0x10,%esp
  for(;;);
  10028f:	eb fe                	jmp    10028f <halt+0x2f>
  100291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10029f:	90                   	nop

001002a0 <panic>:
{
  1002a0:	f3 0f 1e fb          	endbr32 
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	56                   	push   %esi
  1002a8:	53                   	push   %ebx
  1002a9:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
  1002ac:	fa                   	cli    
  cprintf("lapicid %d: panic: ", lapicid());
  1002ad:	e8 8e 03 00 00       	call   100640 <lapicid>
  1002b2:	83 ec 08             	sub    $0x8,%esp
  getcallerpcs(&s, pcs);
  1002b5:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  1002b8:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
  1002bb:	50                   	push   %eax
  1002bc:	68 7f 1b 10 00       	push   $0x101b7f
  1002c1:	e8 2a fe ff ff       	call   1000f0 <cprintf>
  cprintf(s);
  1002c6:	58                   	pop    %eax
  1002c7:	ff 75 08             	pushl  0x8(%ebp)
  1002ca:	e8 21 fe ff ff       	call   1000f0 <cprintf>
  cprintf("\n");
  1002cf:	c7 04 24 35 1c 10 00 	movl   $0x101c35,(%esp)
  1002d6:	e8 15 fe ff ff       	call   1000f0 <cprintf>
  getcallerpcs(&s, pcs);
  1002db:	8d 45 08             	lea    0x8(%ebp),%eax
  1002de:	5a                   	pop    %edx
  1002df:	59                   	pop    %ecx
  1002e0:	53                   	push   %ebx
  1002e1:	50                   	push   %eax
  1002e2:	e8 69 0a 00 00       	call   100d50 <getcallerpcs>
  for(i=0; i<10; i++)
  1002e7:	83 c4 10             	add    $0x10,%esp
  1002ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" %p", pcs[i]);
  1002f0:	83 ec 08             	sub    $0x8,%esp
  1002f3:	ff 33                	pushl  (%ebx)
  1002f5:	83 c3 04             	add    $0x4,%ebx
  1002f8:	68 93 1b 10 00       	push   $0x101b93
  1002fd:	e8 ee fd ff ff       	call   1000f0 <cprintf>
  for(i=0; i<10; i++)
  100302:	83 c4 10             	add    $0x10,%esp
  100305:	39 f3                	cmp    %esi,%ebx
  100307:	75 e7                	jne    1002f0 <panic+0x50>
  halt();
  100309:	e8 52 ff ff ff       	call   100260 <halt>
  10030e:	66 90                	xchg   %ax,%ax

00100310 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100310:	f3 0f 1e fb          	endbr32 
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	53                   	push   %ebx
  100318:	83 ec 14             	sub    $0x14,%esp
  10031b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  while((c = getc()) >= 0){
  10031e:	66 90                	xchg   %ax,%ax
  100320:	ff d3                	call   *%ebx
  100322:	85 c0                	test   %eax,%eax
  100324:	78 77                	js     10039d <consoleintr+0x8d>
    switch(c){
  100326:	83 f8 15             	cmp    $0x15,%eax
  100329:	0f 84 98 00 00 00    	je     1003c7 <consoleintr+0xb7>
  10032f:	83 f8 7f             	cmp    $0x7f,%eax
  100332:	0f 84 a8 00 00 00    	je     1003e0 <consoleintr+0xd0>
  100338:	83 f8 08             	cmp    $0x8,%eax
  10033b:	0f 84 9f 00 00 00    	je     1003e0 <consoleintr+0xd0>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100341:	85 c0                	test   %eax,%eax
  100343:	74 db                	je     100320 <consoleintr+0x10>
  100345:	8b 15 a8 34 10 00    	mov    0x1034a8,%edx
  10034b:	89 d1                	mov    %edx,%ecx
  10034d:	2b 0d a0 34 10 00    	sub    0x1034a0,%ecx
  100353:	83 f9 7f             	cmp    $0x7f,%ecx
  100356:	77 c8                	ja     100320 <consoleintr+0x10>
        c = (c == '\r') ? '\n' : c;
  100358:	8d 4a 01             	lea    0x1(%edx),%ecx
  10035b:	83 e2 7f             	and    $0x7f,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
  10035e:	89 0d a8 34 10 00    	mov    %ecx,0x1034a8
        c = (c == '\r') ? '\n' : c;
  100364:	83 f8 0d             	cmp    $0xd,%eax
  100367:	0f 84 96 00 00 00    	je     100403 <consoleintr+0xf3>
        input.buf[input.e++ % INPUT_BUF] = c;
  10036d:	88 82 20 34 10 00    	mov    %al,0x103420(%edx)
  if(c == BACKSPACE){
  100373:	3d 00 01 00 00       	cmp    $0x100,%eax
  100378:	0f 85 a8 00 00 00    	jne    100426 <consoleintr+0x116>
  10037e:	e8 3d fd ff ff       	call   1000c0 <consputc.part.0>
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100383:	a1 a0 34 10 00       	mov    0x1034a0,%eax
  100388:	83 e8 80             	sub    $0xffffff80,%eax
  10038b:	39 05 a8 34 10 00    	cmp    %eax,0x1034a8
  100391:	0f 84 85 00 00 00    	je     10041c <consoleintr+0x10c>
  while((c = getc()) >= 0){
  100397:	ff d3                	call   *%ebx
  100399:	85 c0                	test   %eax,%eax
  10039b:	79 89                	jns    100326 <consoleintr+0x16>
        }
      }
      break;
    }
  }
  10039d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1003a0:	c9                   	leave  
  1003a1:	c3                   	ret    
  1003a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003a8:	83 e8 01             	sub    $0x1,%eax
  1003ab:	89 c2                	mov    %eax,%edx
  1003ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
  1003b0:	80 ba 20 34 10 00 0a 	cmpb   $0xa,0x103420(%edx)
  1003b7:	0f 84 63 ff ff ff    	je     100320 <consoleintr+0x10>
        input.e--;
  1003bd:	a3 a8 34 10 00       	mov    %eax,0x1034a8
  if(c == BACKSPACE){
  1003c2:	e8 f9 fc ff ff       	call   1000c0 <consputc.part.0>
      while(input.e != input.w &&
  1003c7:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  1003cc:	3b 05 a4 34 10 00    	cmp    0x1034a4,%eax
  1003d2:	75 d4                	jne    1003a8 <consoleintr+0x98>
  1003d4:	e9 47 ff ff ff       	jmp    100320 <consoleintr+0x10>
  1003d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
  1003e0:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  1003e5:	3b 05 a4 34 10 00    	cmp    0x1034a4,%eax
  1003eb:	0f 84 2f ff ff ff    	je     100320 <consoleintr+0x10>
        input.e--;
  1003f1:	83 e8 01             	sub    $0x1,%eax
  1003f4:	a3 a8 34 10 00       	mov    %eax,0x1034a8
  if(c == BACKSPACE){
  1003f9:	e8 c2 fc ff ff       	call   1000c0 <consputc.part.0>
  1003fe:	e9 1d ff ff ff       	jmp    100320 <consoleintr+0x10>
    uartputc(c);
  100403:	83 ec 0c             	sub    $0xc,%esp
        input.buf[input.e++ % INPUT_BUF] = c;
  100406:	c6 82 20 34 10 00 0a 	movb   $0xa,0x103420(%edx)
    uartputc(c);
  10040d:	6a 0a                	push   $0xa
  10040f:	e8 3c 06 00 00       	call   100a50 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100414:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  100419:	83 c4 10             	add    $0x10,%esp
          input.w = input.e;
  10041c:	a3 a4 34 10 00       	mov    %eax,0x1034a4
  100421:	e9 fa fe ff ff       	jmp    100320 <consoleintr+0x10>
    uartputc(c);
  100426:	83 ec 0c             	sub    $0xc,%esp
  100429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10042c:	50                   	push   %eax
  10042d:	e8 1e 06 00 00       	call   100a50 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	83 c4 10             	add    $0x10,%esp
  100438:	83 f8 0a             	cmp    $0xa,%eax
  10043b:	74 09                	je     100446 <consoleintr+0x136>
  10043d:	83 f8 04             	cmp    $0x4,%eax
  100440:	0f 85 3d ff ff ff    	jne    100383 <consoleintr+0x73>
  100446:	a1 a8 34 10 00       	mov    0x1034a8,%eax
  10044b:	eb cf                	jmp    10041c <consoleintr+0x10c>
  10044d:	66 90                	xchg   %ax,%ax
  10044f:	90                   	nop

00100450 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  100450:	f3 0f 1e fb          	endbr32 
  100454:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  100455:	c7 05 ac 34 10 00 00 	movl   $0xfec00000,0x1034ac
  10045c:	00 c0 fe 
{
  10045f:	89 e5                	mov    %esp,%ebp
  100461:	56                   	push   %esi
  100462:	53                   	push   %ebx
  ioapic->reg = reg;
  100463:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10046a:	00 00 00 
  return ioapic->data;
  10046d:	8b 15 ac 34 10 00    	mov    0x1034ac,%edx
  100473:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
  100476:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
  10047c:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  100482:	0f b6 15 b4 34 10 00 	movzbl 0x1034b4,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  100489:	c1 ee 10             	shr    $0x10,%esi
  10048c:	89 f0                	mov    %esi,%eax
  10048e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
  100491:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
  100494:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
  100497:	39 c2                	cmp    %eax,%edx
  100499:	74 16                	je     1004b1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  10049b:	83 ec 0c             	sub    $0xc,%esp
  10049e:	68 bc 1b 10 00       	push   $0x101bbc
  1004a3:	e8 48 fc ff ff       	call   1000f0 <cprintf>
  1004a8:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004ae:	83 c4 10             	add    $0x10,%esp
  1004b1:	83 c6 21             	add    $0x21,%esi
{
  1004b4:	ba 10 00 00 00       	mov    $0x10,%edx
  1004b9:	b8 20 00 00 00       	mov    $0x20,%eax
  1004be:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
  1004c0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  1004c2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
  1004c4:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004ca:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  1004cd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
  1004d3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
  1004d6:	8d 5a 01             	lea    0x1(%edx),%ebx
  1004d9:	83 c2 02             	add    $0x2,%edx
  1004dc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
  1004de:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  1004e4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
  1004eb:	39 f0                	cmp    %esi,%eax
  1004ed:	75 d1                	jne    1004c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  1004ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1004f2:	5b                   	pop    %ebx
  1004f3:	5e                   	pop    %esi
  1004f4:	5d                   	pop    %ebp
  1004f5:	c3                   	ret    
  1004f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004fd:	8d 76 00             	lea    0x0(%esi),%esi

00100500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  100500:	f3 0f 1e fb          	endbr32 
  100504:	55                   	push   %ebp
  ioapic->reg = reg;
  100505:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
{
  10050b:	89 e5                	mov    %esp,%ebp
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  100510:	8d 50 20             	lea    0x20(%eax),%edx
  100513:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
  100517:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  100519:	8b 0d ac 34 10 00    	mov    0x1034ac,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10051f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
  100522:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  100525:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
  100528:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  10052a:	a1 ac 34 10 00       	mov    0x1034ac,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10052f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
  100532:	89 50 10             	mov    %edx,0x10(%eax)
}
  100535:	5d                   	pop    %ebp
  100536:	c3                   	ret    
  100537:	66 90                	xchg   %ax,%ax
  100539:	66 90                	xchg   %ax,%ax
  10053b:	66 90                	xchg   %ax,%ax
  10053d:	66 90                	xchg   %ax,%ax
  10053f:	90                   	nop

00100540 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
  100540:	f3 0f 1e fb          	endbr32 
  if(!lapic)
  100544:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100549:	85 c0                	test   %eax,%eax
  10054b:	0f 84 c7 00 00 00    	je     100618 <lapicinit+0xd8>
  lapic[index] = value;
  100551:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  100558:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10055b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10055e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  100565:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100568:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  10056b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  100572:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  100575:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100578:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10057f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  100582:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100585:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10058c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10058f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  100592:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  100599:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10059c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10059f:	8b 50 30             	mov    0x30(%eax),%edx
  1005a2:	c1 ea 10             	shr    $0x10,%edx
  1005a5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  1005ab:	75 73                	jne    100620 <lapicinit+0xe0>
  lapic[index] = value;
  1005ad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  1005b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005ba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005c7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1005ce:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1005db:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005e1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1005e8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1005eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
  1005ee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1005f5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1005f8:	8b 50 20             	mov    0x20(%eax),%edx
  1005fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1005ff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  100600:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
  100606:	80 e6 10             	and    $0x10,%dh
  100609:	75 f5                	jne    100600 <lapicinit+0xc0>
  lapic[index] = value;
  10060b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  100612:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100615:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  100618:	c3                   	ret    
  100619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
  100620:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  100627:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10062a:	8b 50 20             	mov    0x20(%eax),%edx
}
  10062d:	e9 7b ff ff ff       	jmp    1005ad <lapicinit+0x6d>
  100632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100640 <lapicid>:

int
lapicid(void)
{
  100640:	f3 0f 1e fb          	endbr32 
  if (!lapic)
  100644:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100649:	85 c0                	test   %eax,%eax
  10064b:	74 0b                	je     100658 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
  10064d:	8b 40 20             	mov    0x20(%eax),%eax
  100650:	c1 e8 18             	shr    $0x18,%eax
  100653:	c3                   	ret    
  100654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  100658:	31 c0                	xor    %eax,%eax
}
  10065a:	c3                   	ret    
  10065b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10065f:	90                   	nop

00100660 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  100660:	f3 0f 1e fb          	endbr32 
  if(lapic)
  100664:	a1 b0 34 10 00       	mov    0x1034b0,%eax
  100669:	85 c0                	test   %eax,%eax
  10066b:	74 0d                	je     10067a <lapiceoi+0x1a>
  lapic[index] = value;
  10066d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  100674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  100677:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
  10067a:	c3                   	ret    
  10067b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10067f:	90                   	nop

00100680 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  100680:	f3 0f 1e fb          	endbr32 
  100684:	c3                   	ret    
  100685:	66 90                	xchg   %ax,%ax
  100687:	66 90                	xchg   %ax,%ax
  100689:	66 90                	xchg   %ax,%ax
  10068b:	66 90                	xchg   %ax,%ax
  10068d:	66 90                	xchg   %ax,%ax
  10068f:	90                   	nop

00100690 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  100690:	f3 0f 1e fb          	endbr32 
  100694:	55                   	push   %ebp
  100695:	89 e5                	mov    %esp,%ebp
  100697:	83 e4 f0             	and    $0xfffffff0,%esp
  mpinit();        // detect other processors
  10069a:	e8 a1 00 00 00       	call   100740 <mpinit>
  lapicinit();     // interrupt controller
  10069f:	e8 9c fe ff ff       	call   100540 <lapicinit>
  picinit();       // disable pic
  1006a4:	e8 57 02 00 00       	call   100900 <picinit>
  ioapicinit();    // another interrupt controller
  1006a9:	e8 a2 fd ff ff       	call   100450 <ioapicinit>
  uartinit();      // serial port
  1006ae:	e8 cd 02 00 00       	call   100980 <uartinit>
  tvinit();        // trap vectors
  1006b3:	e8 f8 06 00 00       	call   100db0 <tvinit>
  idtinit();       // load idt register
  1006b8:	e8 33 07 00 00       	call   100df0 <idtinit>
  mouseinit();     // mouse
  1006bd:	e8 3e 13 00 00       	call   101a00 <mouseinit>


static inline void
sti(void)
{
  asm volatile("sti");
  1006c2:	fb                   	sti    
  1006c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006c7:	90                   	nop
}

static inline void
wfi(void)
{
  asm volatile("hlt");
  1006c8:	f4                   	hlt    
  1006c9:	eb fd                	jmp    1006c8 <main+0x38>
  1006cb:	66 90                	xchg   %ax,%ax
  1006cd:	66 90                	xchg   %ax,%ax
  1006cf:	90                   	nop

001006d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  1006d0:	55                   	push   %ebp
  1006d1:	89 e5                	mov    %esp,%ebp
  1006d3:	57                   	push   %edi
  1006d4:	56                   	push   %esi
  1006d5:	53                   	push   %ebx
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  e = addr+len;
  1006d6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
{
  1006d9:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
  1006dc:	39 d8                	cmp    %ebx,%eax
  1006de:	73 50                	jae    100730 <mpsearch1+0x60>
  1006e0:	89 c6                	mov    %eax,%esi
  1006e2:	eb 0a                	jmp    1006ee <mpsearch1+0x1e>
  1006e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006e8:	89 fe                	mov    %edi,%esi
  1006ea:	39 fb                	cmp    %edi,%ebx
  1006ec:	76 42                	jbe    100730 <mpsearch1+0x60>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1006ee:	83 ec 04             	sub    $0x4,%esp
  1006f1:	8d 7e 10             	lea    0x10(%esi),%edi
  1006f4:	6a 04                	push   $0x4
  1006f6:	68 ee 1b 10 00       	push   $0x101bee
  1006fb:	56                   	push   %esi
  1006fc:	e8 ef 03 00 00       	call   100af0 <memcmp>
  100701:	83 c4 10             	add    $0x10,%esp
  100704:	85 c0                	test   %eax,%eax
  100706:	75 e0                	jne    1006e8 <mpsearch1+0x18>
  100708:	89 f2                	mov    %esi,%edx
  10070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
  100710:	0f b6 0a             	movzbl (%edx),%ecx
  100713:	83 c2 01             	add    $0x1,%edx
  100716:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
  100718:	39 fa                	cmp    %edi,%edx
  10071a:	75 f4                	jne    100710 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  10071c:	84 c0                	test   %al,%al
  10071e:	75 c8                	jne    1006e8 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
  100720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100723:	89 f0                	mov    %esi,%eax
  100725:	5b                   	pop    %ebx
  100726:	5e                   	pop    %esi
  100727:	5f                   	pop    %edi
  100728:	5d                   	pop    %ebp
  100729:	c3                   	ret    
  10072a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
  100733:	31 f6                	xor    %esi,%esi
}
  100735:	5b                   	pop    %ebx
  100736:	89 f0                	mov    %esi,%eax
  100738:	5e                   	pop    %esi
  100739:	5f                   	pop    %edi
  10073a:	5d                   	pop    %ebp
  10073b:	c3                   	ret    
  10073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100740 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  100740:	f3 0f 1e fb          	endbr32 
  100744:	55                   	push   %ebp
  100745:	89 e5                	mov    %esp,%ebp
  100747:	57                   	push   %edi
  100748:	56                   	push   %esi
  100749:	53                   	push   %ebx
  10074a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  10074d:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  100754:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  10075b:	c1 e0 08             	shl    $0x8,%eax
  10075e:	09 d0                	or     %edx,%eax
  100760:	c1 e0 04             	shl    $0x4,%eax
  100763:	75 1b                	jne    100780 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100765:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  10076c:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  100773:	c1 e0 08             	shl    $0x8,%eax
  100776:	09 d0                	or     %edx,%eax
  100778:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
  10077b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
  100780:	ba 00 04 00 00       	mov    $0x400,%edx
  100785:	e8 46 ff ff ff       	call   1006d0 <mpsearch1>
  10078a:	89 c6                	mov    %eax,%esi
  10078c:	85 c0                	test   %eax,%eax
  10078e:	0f 84 cc 00 00 00    	je     100860 <mpinit+0x120>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100794:	8b 5e 04             	mov    0x4(%esi),%ebx
  100797:	85 db                	test   %ebx,%ebx
  100799:	0f 84 e1 00 00 00    	je     100880 <mpinit+0x140>
  if(memcmp(conf, "PCMP", 4) != 0)
  10079f:	83 ec 04             	sub    $0x4,%esp
  1007a2:	6a 04                	push   $0x4
  1007a4:	68 f3 1b 10 00       	push   $0x101bf3
  1007a9:	53                   	push   %ebx
  1007aa:	e8 41 03 00 00       	call   100af0 <memcmp>
  1007af:	83 c4 10             	add    $0x10,%esp
  1007b2:	85 c0                	test   %eax,%eax
  1007b4:	0f 85 c6 00 00 00    	jne    100880 <mpinit+0x140>
  if(conf->version != 1 && conf->version != 4)
  1007ba:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  1007be:	3c 01                	cmp    $0x1,%al
  1007c0:	74 08                	je     1007ca <mpinit+0x8a>
  1007c2:	3c 04                	cmp    $0x4,%al
  1007c4:	0f 85 b6 00 00 00    	jne    100880 <mpinit+0x140>
  if(sum((uchar*)conf, conf->length) != 0)
  1007ca:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  for(i=0; i<len; i++)
  1007ce:	66 85 d2             	test   %dx,%dx
  1007d1:	0f 84 0b 01 00 00    	je     1008e2 <mpinit+0x1a2>
  1007d7:	0f b7 ca             	movzwl %dx,%ecx
  1007da:	89 d8                	mov    %ebx,%eax
  sum = 0;
  1007dc:	31 d2                	xor    %edx,%edx
  1007de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1007e1:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
  1007e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
  1007e8:	0f b6 08             	movzbl (%eax),%ecx
  1007eb:	83 c0 01             	add    $0x1,%eax
  1007ee:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
  1007f0:	39 f8                	cmp    %edi,%eax
  1007f2:	75 f4                	jne    1007e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
  1007f4:	84 d2                	test   %dl,%dl
  1007f6:	0f 85 84 00 00 00    	jne    100880 <mpinit+0x140>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  1007fc:	8b 43 24             	mov    0x24(%ebx),%eax
  ismp = 1;
  1007ff:	b9 01 00 00 00       	mov    $0x1,%ecx
  lapic = (uint*)conf->lapicaddr;
  100804:	a3 b0 34 10 00       	mov    %eax,0x1034b0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100809:	8d 43 2c             	lea    0x2c(%ebx),%eax
  10080c:	03 5d e4             	add    -0x1c(%ebp),%ebx
  10080f:	90                   	nop
  100810:	39 c3                	cmp    %eax,%ebx
  100812:	76 19                	jbe    10082d <mpinit+0xed>
    switch(*p){
  100814:	0f b6 10             	movzbl (%eax),%edx
  100817:	80 fa 02             	cmp    $0x2,%dl
  10081a:	0f 84 b0 00 00 00    	je     1008d0 <mpinit+0x190>
  100820:	77 6e                	ja     100890 <mpinit+0x150>
  100822:	84 d2                	test   %dl,%dl
  100824:	74 7a                	je     1008a0 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100826:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100829:	39 c3                	cmp    %eax,%ebx
  10082b:	77 e7                	ja     100814 <mpinit+0xd4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
  10082d:	85 c9                	test   %ecx,%ecx
  10082f:	0f 84 b9 00 00 00    	je     1008ee <mpinit+0x1ae>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
  100835:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  100839:	74 15                	je     100850 <mpinit+0x110>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10083b:	b8 70 00 00 00       	mov    $0x70,%eax
  100840:	ba 22 00 00 00       	mov    $0x22,%edx
  100845:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100846:	ba 23 00 00 00       	mov    $0x23,%edx
  10084b:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  10084c:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10084f:	ee                   	out    %al,(%dx)
  }
}
  100850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100853:	5b                   	pop    %ebx
  100854:	5e                   	pop    %esi
  100855:	5f                   	pop    %edi
  100856:	5d                   	pop    %ebp
  100857:	c3                   	ret    
  100858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10085f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
  100860:	ba 00 00 01 00       	mov    $0x10000,%edx
  100865:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  10086a:	e8 61 fe ff ff       	call   1006d0 <mpsearch1>
  10086f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100871:	85 c0                	test   %eax,%eax
  100873:	0f 85 1b ff ff ff    	jne    100794 <mpinit+0x54>
  100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
  100880:	83 ec 0c             	sub    $0xc,%esp
  100883:	68 f8 1b 10 00       	push   $0x101bf8
  100888:	e8 13 fa ff ff       	call   1002a0 <panic>
  10088d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  100890:	83 ea 03             	sub    $0x3,%edx
  100893:	80 fa 01             	cmp    $0x1,%dl
  100896:	76 8e                	jbe    100826 <mpinit+0xe6>
  100898:	31 c9                	xor    %ecx,%ecx
  10089a:	e9 71 ff ff ff       	jmp    100810 <mpinit+0xd0>
  10089f:	90                   	nop
      if(ncpu < NCPU) {
  1008a0:	8b 3d c0 34 10 00    	mov    0x1034c0,%edi
  1008a6:	83 ff 07             	cmp    $0x7,%edi
  1008a9:	7f 13                	jg     1008be <mpinit+0x17e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  1008ab:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
  1008af:	83 c7 01             	add    $0x1,%edi
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  1008b2:	88 97 b7 34 10 00    	mov    %dl,0x1034b7(%edi)
        ncpu++;
  1008b8:	89 3d c0 34 10 00    	mov    %edi,0x1034c0
      p += sizeof(struct mpproc);
  1008be:	83 c0 14             	add    $0x14,%eax
      continue;
  1008c1:	e9 4a ff ff ff       	jmp    100810 <mpinit+0xd0>
  1008c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1008cd:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
  1008d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
  1008d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
  1008d7:	88 15 b4 34 10 00    	mov    %dl,0x1034b4
      continue;
  1008dd:	e9 2e ff ff ff       	jmp    100810 <mpinit+0xd0>
  1008e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1008e9:	e9 0e ff ff ff       	jmp    1007fc <mpinit+0xbc>
    panic("Didn't find a suitable machine");
  1008ee:	83 ec 0c             	sub    $0xc,%esp
  1008f1:	68 10 1c 10 00       	push   $0x101c10
  1008f6:	e8 a5 f9 ff ff       	call   1002a0 <panic>
  1008fb:	66 90                	xchg   %ax,%ax
  1008fd:	66 90                	xchg   %ax,%ax
  1008ff:	90                   	nop

00100900 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100900:	f3 0f 1e fb          	endbr32 
  100904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100909:	ba 21 00 00 00       	mov    $0x21,%edx
  10090e:	ee                   	out    %al,(%dx)
  10090f:	ba a1 00 00 00       	mov    $0xa1,%edx
  100914:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
  100915:	c3                   	ret    
  100916:	66 90                	xchg   %ax,%ax
  100918:	66 90                	xchg   %ax,%ax
  10091a:	66 90                	xchg   %ax,%ax
  10091c:	66 90                	xchg   %ax,%ax
  10091e:	66 90                	xchg   %ax,%ax

00100920 <uartgetc>:
}


static int
uartgetc(void)
{
  100920:	f3 0f 1e fb          	endbr32 
  if(!uart)
  100924:	a1 00 24 10 00       	mov    0x102400,%eax
  100929:	85 c0                	test   %eax,%eax
  10092b:	74 1b                	je     100948 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10092d:	ba fd 03 00 00       	mov    $0x3fd,%edx
  100932:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
  100933:	a8 01                	test   $0x1,%al
  100935:	74 11                	je     100948 <uartgetc+0x28>
  100937:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10093c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  10093d:	0f b6 c0             	movzbl %al,%eax
  100940:	c3                   	ret    
  100941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10094d:	c3                   	ret    
  10094e:	66 90                	xchg   %ax,%ax

00100950 <uartputc.part.0>:
uartputc(int c)
  100950:	55                   	push   %ebp
  100951:	b9 80 00 00 00       	mov    $0x80,%ecx
  100956:	ba fd 03 00 00       	mov    $0x3fd,%edx
  10095b:	89 e5                	mov    %esp,%ebp
  10095d:	53                   	push   %ebx
  10095e:	89 c3                	mov    %eax,%ebx
  100960:	eb 0b                	jmp    10096d <uartputc.part.0+0x1d>
  100962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100968:	83 e9 01             	sub    $0x1,%ecx
  10096b:	74 05                	je     100972 <uartputc.part.0+0x22>
  10096d:	ec                   	in     (%dx),%al
  10096e:	a8 20                	test   $0x20,%al
  100970:	74 f6                	je     100968 <uartputc.part.0+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100972:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100977:	89 d8                	mov    %ebx,%eax
  100979:	ee                   	out    %al,(%dx)
}
  10097a:	5b                   	pop    %ebx
  10097b:	5d                   	pop    %ebp
  10097c:	c3                   	ret    
  10097d:	8d 76 00             	lea    0x0(%esi),%esi

00100980 <uartinit>:
{
  100980:	f3 0f 1e fb          	endbr32 
  100984:	55                   	push   %ebp
  100985:	31 c9                	xor    %ecx,%ecx
  100987:	89 c8                	mov    %ecx,%eax
  100989:	89 e5                	mov    %esp,%ebp
  10098b:	57                   	push   %edi
  10098c:	56                   	push   %esi
  10098d:	53                   	push   %ebx
  10098e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
  100993:	89 da                	mov    %ebx,%edx
  100995:	83 ec 0c             	sub    $0xc,%esp
  100998:	ee                   	out    %al,(%dx)
  100999:	bf fb 03 00 00       	mov    $0x3fb,%edi
  10099e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  1009a3:	89 fa                	mov    %edi,%edx
  1009a5:	ee                   	out    %al,(%dx)
  1009a6:	b8 0c 00 00 00       	mov    $0xc,%eax
  1009ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
  1009b0:	ee                   	out    %al,(%dx)
  1009b1:	be f9 03 00 00       	mov    $0x3f9,%esi
  1009b6:	89 c8                	mov    %ecx,%eax
  1009b8:	89 f2                	mov    %esi,%edx
  1009ba:	ee                   	out    %al,(%dx)
  1009bb:	b8 03 00 00 00       	mov    $0x3,%eax
  1009c0:	89 fa                	mov    %edi,%edx
  1009c2:	ee                   	out    %al,(%dx)
  1009c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
  1009c8:	89 c8                	mov    %ecx,%eax
  1009ca:	ee                   	out    %al,(%dx)
  1009cb:	b8 01 00 00 00       	mov    $0x1,%eax
  1009d0:	89 f2                	mov    %esi,%edx
  1009d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1009d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1009d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
  1009d9:	3c ff                	cmp    $0xff,%al
  1009db:	74 5c                	je     100a39 <uartinit+0xb9>
  uart = 1;
  1009dd:	c7 05 00 24 10 00 01 	movl   $0x1,0x102400
  1009e4:	00 00 00 
  1009e7:	89 da                	mov    %ebx,%edx
  1009e9:	ec                   	in     (%dx),%al
  1009ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
  1009ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
  1009f0:	83 ec 08             	sub    $0x8,%esp
  1009f3:	bf 76 00 00 00       	mov    $0x76,%edi
  for(p="xv6...\n"; *p; p++)
  1009f8:	bb 2f 1c 10 00       	mov    $0x101c2f,%ebx
  ioapicenable(IRQ_COM1, 0);
  1009fd:	6a 00                	push   $0x0
  1009ff:	6a 04                	push   $0x4
  100a01:	e8 fa fa ff ff       	call   100500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
  100a06:	8b 35 00 24 10 00    	mov    0x102400,%esi
  100a0c:	83 c4 10             	add    $0x10,%esp
  100a0f:	b8 78 00 00 00       	mov    $0x78,%eax
  100a14:	eb 0e                	jmp    100a24 <uartinit+0xa4>
  100a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  100a20:	0f b6 7b 01          	movzbl 0x1(%ebx),%edi
  if(!uart)
  100a24:	85 f6                	test   %esi,%esi
  100a26:	74 08                	je     100a30 <uartinit+0xb0>
    uartputc(*p);
  100a28:	0f be c0             	movsbl %al,%eax
  100a2b:	e8 20 ff ff ff       	call   100950 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
  100a30:	89 f8                	mov    %edi,%eax
  100a32:	83 c3 01             	add    $0x1,%ebx
  100a35:	84 c0                	test   %al,%al
  100a37:	75 e7                	jne    100a20 <uartinit+0xa0>
}
  100a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100a3c:	5b                   	pop    %ebx
  100a3d:	5e                   	pop    %esi
  100a3e:	5f                   	pop    %edi
  100a3f:	5d                   	pop    %ebp
  100a40:	c3                   	ret    
  100a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a4f:	90                   	nop

00100a50 <uartputc>:
{
  100a50:	f3 0f 1e fb          	endbr32 
  100a54:	55                   	push   %ebp
  if(!uart)
  100a55:	8b 15 00 24 10 00    	mov    0x102400,%edx
{
  100a5b:	89 e5                	mov    %esp,%ebp
  100a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
  100a60:	85 d2                	test   %edx,%edx
  100a62:	74 0c                	je     100a70 <uartputc+0x20>
}
  100a64:	5d                   	pop    %ebp
  100a65:	e9 e6 fe ff ff       	jmp    100950 <uartputc.part.0>
  100a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100a70:	5d                   	pop    %ebp
  100a71:	c3                   	ret    
  100a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100a80 <uartintr>:

void
uartintr(void)
{
  100a80:	f3 0f 1e fb          	endbr32 
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
  100a8a:	68 20 09 10 00       	push   $0x100920
  100a8f:	e8 7c f8 ff ff       	call   100310 <consoleintr>
  100a94:	83 c4 10             	add    $0x10,%esp
  100a97:	c9                   	leave  
  100a98:	c3                   	ret    
  100a99:	66 90                	xchg   %ax,%ax
  100a9b:	66 90                	xchg   %ax,%ax
  100a9d:	66 90                	xchg   %ax,%ax
  100a9f:	90                   	nop

00100aa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100aa0:	f3 0f 1e fb          	endbr32 
  100aa4:	55                   	push   %ebp
  100aa5:	89 e5                	mov    %esp,%ebp
  100aa7:	57                   	push   %edi
  100aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  100aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  100aae:	53                   	push   %ebx
  100aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
  100ab2:	89 d7                	mov    %edx,%edi
  100ab4:	09 cf                	or     %ecx,%edi
  100ab6:	83 e7 03             	and    $0x3,%edi
  100ab9:	75 25                	jne    100ae0 <memset+0x40>
    c &= 0xFF;
  100abb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100abe:	c1 e0 18             	shl    $0x18,%eax
  100ac1:	89 fb                	mov    %edi,%ebx
  100ac3:	c1 e9 02             	shr    $0x2,%ecx
  100ac6:	c1 e3 10             	shl    $0x10,%ebx
  100ac9:	09 d8                	or     %ebx,%eax
  100acb:	09 f8                	or     %edi,%eax
  100acd:	c1 e7 08             	shl    $0x8,%edi
  100ad0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
  100ad2:	89 d7                	mov    %edx,%edi
  100ad4:	fc                   	cld    
  100ad5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
  100ad7:	5b                   	pop    %ebx
  100ad8:	89 d0                	mov    %edx,%eax
  100ada:	5f                   	pop    %edi
  100adb:	5d                   	pop    %ebp
  100adc:	c3                   	ret    
  100add:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
  100ae0:	89 d7                	mov    %edx,%edi
  100ae2:	fc                   	cld    
  100ae3:	f3 aa                	rep stos %al,%es:(%edi)
  100ae5:	5b                   	pop    %ebx
  100ae6:	89 d0                	mov    %edx,%eax
  100ae8:	5f                   	pop    %edi
  100ae9:	5d                   	pop    %ebp
  100aea:	c3                   	ret    
  100aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100aef:	90                   	nop

00100af0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100af0:	f3 0f 1e fb          	endbr32 
  100af4:	55                   	push   %ebp
  100af5:	89 e5                	mov    %esp,%ebp
  100af7:	56                   	push   %esi
  100af8:	8b 75 10             	mov    0x10(%ebp),%esi
  100afb:	8b 55 08             	mov    0x8(%ebp),%edx
  100afe:	53                   	push   %ebx
  100aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  100b02:	85 f6                	test   %esi,%esi
  100b04:	74 2a                	je     100b30 <memcmp+0x40>
  100b06:	01 c6                	add    %eax,%esi
  100b08:	eb 10                	jmp    100b1a <memcmp+0x2a>
  100b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  100b10:	83 c0 01             	add    $0x1,%eax
  100b13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
  100b16:	39 f0                	cmp    %esi,%eax
  100b18:	74 16                	je     100b30 <memcmp+0x40>
    if(*s1 != *s2)
  100b1a:	0f b6 0a             	movzbl (%edx),%ecx
  100b1d:	0f b6 18             	movzbl (%eax),%ebx
  100b20:	38 d9                	cmp    %bl,%cl
  100b22:	74 ec                	je     100b10 <memcmp+0x20>
      return *s1 - *s2;
  100b24:	0f b6 c1             	movzbl %cl,%eax
  100b27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
  100b29:	5b                   	pop    %ebx
  100b2a:	5e                   	pop    %esi
  100b2b:	5d                   	pop    %ebp
  100b2c:	c3                   	ret    
  100b2d:	8d 76 00             	lea    0x0(%esi),%esi
  100b30:	5b                   	pop    %ebx
  return 0;
  100b31:	31 c0                	xor    %eax,%eax
}
  100b33:	5e                   	pop    %esi
  100b34:	5d                   	pop    %ebp
  100b35:	c3                   	ret    
  100b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b3d:	8d 76 00             	lea    0x0(%esi),%esi

00100b40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100b40:	f3 0f 1e fb          	endbr32 
  100b44:	55                   	push   %ebp
  100b45:	89 e5                	mov    %esp,%ebp
  100b47:	57                   	push   %edi
  100b48:	8b 55 08             	mov    0x8(%ebp),%edx
  100b4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  100b4e:	56                   	push   %esi
  100b4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  100b52:	39 d6                	cmp    %edx,%esi
  100b54:	73 2a                	jae    100b80 <memmove+0x40>
  100b56:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
  100b59:	39 fa                	cmp    %edi,%edx
  100b5b:	73 23                	jae    100b80 <memmove+0x40>
  100b5d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
  100b60:	85 c9                	test   %ecx,%ecx
  100b62:	74 13                	je     100b77 <memmove+0x37>
  100b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
  100b68:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  100b6c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
  100b6f:	83 e8 01             	sub    $0x1,%eax
  100b72:	83 f8 ff             	cmp    $0xffffffff,%eax
  100b75:	75 f1                	jne    100b68 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  100b77:	5e                   	pop    %esi
  100b78:	89 d0                	mov    %edx,%eax
  100b7a:	5f                   	pop    %edi
  100b7b:	5d                   	pop    %ebp
  100b7c:	c3                   	ret    
  100b7d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
  100b80:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
  100b83:	89 d7                	mov    %edx,%edi
  100b85:	85 c9                	test   %ecx,%ecx
  100b87:	74 ee                	je     100b77 <memmove+0x37>
  100b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
  100b90:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
  100b91:	39 f0                	cmp    %esi,%eax
  100b93:	75 fb                	jne    100b90 <memmove+0x50>
}
  100b95:	5e                   	pop    %esi
  100b96:	89 d0                	mov    %edx,%eax
  100b98:	5f                   	pop    %edi
  100b99:	5d                   	pop    %ebp
  100b9a:	c3                   	ret    
  100b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100b9f:	90                   	nop

00100ba0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  100ba0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
  100ba4:	eb 9a                	jmp    100b40 <memmove>
  100ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100bad:	8d 76 00             	lea    0x0(%esi),%esi

00100bb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  100bb0:	f3 0f 1e fb          	endbr32 
  100bb4:	55                   	push   %ebp
  100bb5:	89 e5                	mov    %esp,%ebp
  100bb7:	56                   	push   %esi
  100bb8:	8b 75 10             	mov    0x10(%ebp),%esi
  100bbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100bbe:	53                   	push   %ebx
  100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
  100bc2:	85 f6                	test   %esi,%esi
  100bc4:	74 32                	je     100bf8 <strncmp+0x48>
  100bc6:	01 c6                	add    %eax,%esi
  100bc8:	eb 14                	jmp    100bde <strncmp+0x2e>
  100bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100bd0:	38 da                	cmp    %bl,%dl
  100bd2:	75 14                	jne    100be8 <strncmp+0x38>
    n--, p++, q++;
  100bd4:	83 c0 01             	add    $0x1,%eax
  100bd7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
  100bda:	39 f0                	cmp    %esi,%eax
  100bdc:	74 1a                	je     100bf8 <strncmp+0x48>
  100bde:	0f b6 11             	movzbl (%ecx),%edx
  100be1:	0f b6 18             	movzbl (%eax),%ebx
  100be4:	84 d2                	test   %dl,%dl
  100be6:	75 e8                	jne    100bd0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  100be8:	0f b6 c2             	movzbl %dl,%eax
  100beb:	29 d8                	sub    %ebx,%eax
}
  100bed:	5b                   	pop    %ebx
  100bee:	5e                   	pop    %esi
  100bef:	5d                   	pop    %ebp
  100bf0:	c3                   	ret    
  100bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100bf8:	5b                   	pop    %ebx
    return 0;
  100bf9:	31 c0                	xor    %eax,%eax
}
  100bfb:	5e                   	pop    %esi
  100bfc:	5d                   	pop    %ebp
  100bfd:	c3                   	ret    
  100bfe:	66 90                	xchg   %ax,%ax

00100c00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  100c00:	f3 0f 1e fb          	endbr32 
  100c04:	55                   	push   %ebp
  100c05:	89 e5                	mov    %esp,%ebp
  100c07:	57                   	push   %edi
  100c08:	56                   	push   %esi
  100c09:	8b 75 08             	mov    0x8(%ebp),%esi
  100c0c:	53                   	push   %ebx
  100c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  100c10:	89 f2                	mov    %esi,%edx
  100c12:	eb 1b                	jmp    100c2f <strncpy+0x2f>
  100c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100c18:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  100c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100c1f:	83 c2 01             	add    $0x1,%edx
  100c22:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
  100c26:	89 f9                	mov    %edi,%ecx
  100c28:	88 4a ff             	mov    %cl,-0x1(%edx)
  100c2b:	84 c9                	test   %cl,%cl
  100c2d:	74 09                	je     100c38 <strncpy+0x38>
  100c2f:	89 c3                	mov    %eax,%ebx
  100c31:	83 e8 01             	sub    $0x1,%eax
  100c34:	85 db                	test   %ebx,%ebx
  100c36:	7f e0                	jg     100c18 <strncpy+0x18>
    ;
  while(n-- > 0)
  100c38:	89 d1                	mov    %edx,%ecx
  100c3a:	85 c0                	test   %eax,%eax
  100c3c:	7e 15                	jle    100c53 <strncpy+0x53>
  100c3e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
  100c40:	83 c1 01             	add    $0x1,%ecx
  100c43:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
  100c47:	89 c8                	mov    %ecx,%eax
  100c49:	f7 d0                	not    %eax
  100c4b:	01 d0                	add    %edx,%eax
  100c4d:	01 d8                	add    %ebx,%eax
  100c4f:	85 c0                	test   %eax,%eax
  100c51:	7f ed                	jg     100c40 <strncpy+0x40>
  return os;
}
  100c53:	5b                   	pop    %ebx
  100c54:	89 f0                	mov    %esi,%eax
  100c56:	5e                   	pop    %esi
  100c57:	5f                   	pop    %edi
  100c58:	5d                   	pop    %ebp
  100c59:	c3                   	ret    
  100c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100c60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  100c60:	f3 0f 1e fb          	endbr32 
  100c64:	55                   	push   %ebp
  100c65:	89 e5                	mov    %esp,%ebp
  100c67:	56                   	push   %esi
  100c68:	8b 55 10             	mov    0x10(%ebp),%edx
  100c6b:	8b 75 08             	mov    0x8(%ebp),%esi
  100c6e:	53                   	push   %ebx
  100c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
  100c72:	85 d2                	test   %edx,%edx
  100c74:	7e 21                	jle    100c97 <safestrcpy+0x37>
  100c76:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
  100c7a:	89 f2                	mov    %esi,%edx
  100c7c:	eb 12                	jmp    100c90 <safestrcpy+0x30>
  100c7e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  100c80:	0f b6 08             	movzbl (%eax),%ecx
  100c83:	83 c0 01             	add    $0x1,%eax
  100c86:	83 c2 01             	add    $0x1,%edx
  100c89:	88 4a ff             	mov    %cl,-0x1(%edx)
  100c8c:	84 c9                	test   %cl,%cl
  100c8e:	74 04                	je     100c94 <safestrcpy+0x34>
  100c90:	39 d8                	cmp    %ebx,%eax
  100c92:	75 ec                	jne    100c80 <safestrcpy+0x20>
    ;
  *s = 0;
  100c94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  100c97:	89 f0                	mov    %esi,%eax
  100c99:	5b                   	pop    %ebx
  100c9a:	5e                   	pop    %esi
  100c9b:	5d                   	pop    %ebp
  100c9c:	c3                   	ret    
  100c9d:	8d 76 00             	lea    0x0(%esi),%esi

00100ca0 <strlen>:

int
strlen(const char *s)
{
  100ca0:	f3 0f 1e fb          	endbr32 
  100ca4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  100ca5:	31 c0                	xor    %eax,%eax
{
  100ca7:	89 e5                	mov    %esp,%ebp
  100ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
  100cac:	80 3a 00             	cmpb   $0x0,(%edx)
  100caf:	74 10                	je     100cc1 <strlen+0x21>
  100cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100cb8:	83 c0 01             	add    $0x1,%eax
  100cbb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100cbf:	75 f7                	jne    100cb8 <strlen+0x18>
    ;
  return n;
}
  100cc1:	5d                   	pop    %ebp
  100cc2:	c3                   	ret    
  100cc3:	66 90                	xchg   %ax,%ax
  100cc5:	66 90                	xchg   %ax,%ax
  100cc7:	66 90                	xchg   %ax,%ax
  100cc9:	66 90                	xchg   %ax,%ax
  100ccb:	66 90                	xchg   %ax,%ax
  100ccd:	66 90                	xchg   %ax,%ax
  100ccf:	90                   	nop

00100cd0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  100cd0:	f3 0f 1e fb          	endbr32 
  100cd4:	55                   	push   %ebp
  100cd5:	89 e5                	mov    %esp,%ebp
  100cd7:	53                   	push   %ebx
  100cd8:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  100cdb:	9c                   	pushf  
  100cdc:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
  100cdd:	f6 c4 02             	test   $0x2,%ah
  100ce0:	75 40                	jne    100d22 <mycpu+0x52>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  100ce2:	e8 59 f9 ff ff       	call   100640 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  100ce7:	8b 1d c0 34 10 00    	mov    0x1034c0,%ebx
  100ced:	85 db                	test   %ebx,%ebx
  100cef:	7e 24                	jle    100d15 <mycpu+0x45>
  100cf1:	31 d2                	xor    %edx,%edx
  100cf3:	eb 0a                	jmp    100cff <mycpu+0x2f>
  100cf5:	8d 76 00             	lea    0x0(%esi),%esi
  100cf8:	83 c2 01             	add    $0x1,%edx
  100cfb:	39 da                	cmp    %ebx,%edx
  100cfd:	74 16                	je     100d15 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
  100cff:	0f b6 8a b8 34 10 00 	movzbl 0x1034b8(%edx),%ecx
  100d06:	39 c1                	cmp    %eax,%ecx
  100d08:	75 ee                	jne    100cf8 <mycpu+0x28>
      return &cpus[i];
  }
  panic("unknown apicid\n");
  100d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return &cpus[i];
  100d0d:	8d 82 b8 34 10 00    	lea    0x1034b8(%edx),%eax
  100d13:	c9                   	leave  
  100d14:	c3                   	ret    
  panic("unknown apicid\n");
  100d15:	83 ec 0c             	sub    $0xc,%esp
  100d18:	68 5e 1c 10 00       	push   $0x101c5e
  100d1d:	e8 7e f5 ff ff       	call   1002a0 <panic>
    panic("mycpu called with interrupts enabled\n");
  100d22:	83 ec 0c             	sub    $0xc,%esp
  100d25:	68 38 1c 10 00       	push   $0x101c38
  100d2a:	e8 71 f5 ff ff       	call   1002a0 <panic>
  100d2f:	90                   	nop

00100d30 <cpuid>:
cpuid() {
  100d30:	f3 0f 1e fb          	endbr32 
  100d34:	55                   	push   %ebp
  100d35:	89 e5                	mov    %esp,%ebp
  100d37:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  100d3a:	e8 91 ff ff ff       	call   100cd0 <mycpu>
}
  100d3f:	c9                   	leave  
  return mycpu()-cpus;
  100d40:	2d b8 34 10 00       	sub    $0x1034b8,%eax
}
  100d45:	c3                   	ret    
  100d46:	66 90                	xchg   %ax,%ax
  100d48:	66 90                	xchg   %ax,%ax
  100d4a:	66 90                	xchg   %ax,%ax
  100d4c:	66 90                	xchg   %ax,%ax
  100d4e:	66 90                	xchg   %ax,%ax

00100d50 <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  100d50:	f3 0f 1e fb          	endbr32 
  100d54:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  100d55:	31 d2                	xor    %edx,%edx
{
  100d57:	89 e5                	mov    %esp,%ebp
  100d59:	53                   	push   %ebx
  ebp = (uint*)v - 2;
  100d5a:	8b 45 08             	mov    0x8(%ebp),%eax
{
  100d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
  100d60:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
  100d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100d67:	90                   	nop
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  100d68:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100d6b:	83 fb fd             	cmp    $0xfffffffd,%ebx
  100d6e:	77 18                	ja     100d88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  100d70:	8b 58 04             	mov    0x4(%eax),%ebx
  100d73:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
  100d76:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
  100d79:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
  100d7b:	83 fa 0a             	cmp    $0xa,%edx
  100d7e:	75 e8                	jne    100d68 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
  100d80:	5b                   	pop    %ebx
  100d81:	5d                   	pop    %ebp
  100d82:	c3                   	ret    
  100d83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100d87:	90                   	nop
  for(; i < 10; i++)
  100d88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
  100d8b:	8d 51 28             	lea    0x28(%ecx),%edx
  100d8e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
  100d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  100d96:	83 c0 04             	add    $0x4,%eax
  100d99:	39 d0                	cmp    %edx,%eax
  100d9b:	75 f3                	jne    100d90 <getcallerpcs+0x40>
  100d9d:	5b                   	pop    %ebx
  100d9e:	5d                   	pop    %ebp
  100d9f:	c3                   	ret    

00100da0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  100da0:	60                   	pusha  
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  100da1:	54                   	push   %esp
  call trap
  100da2:	e8 79 00 00 00       	call   100e20 <trap>
  addl $4, %esp
  100da7:	83 c4 04             	add    $0x4,%esp

00100daa <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  100daa:	61                   	popa   
  addl $0x8, %esp  # trapno and errcode
  100dab:	83 c4 08             	add    $0x8,%esp
  iret
  100dae:	cf                   	iret   
  100daf:	90                   	nop

00100db0 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  100db0:	f3 0f 1e fb          	endbr32 
  int i;

  for(i = 0; i < 256; i++)
  100db4:	31 c0                	xor    %eax,%eax
  100db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100dbd:	8d 76 00             	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  100dc0:	8b 14 85 00 20 10 00 	mov    0x102000(,%eax,4),%edx
  100dc7:	c7 04 c5 e2 34 10 00 	movl   $0x8e000008,0x1034e2(,%eax,8)
  100dce:	08 00 00 8e 
  100dd2:	66 89 14 c5 e0 34 10 	mov    %dx,0x1034e0(,%eax,8)
  100dd9:	00 
  100dda:	c1 ea 10             	shr    $0x10,%edx
  100ddd:	66 89 14 c5 e6 34 10 	mov    %dx,0x1034e6(,%eax,8)
  100de4:	00 
  for(i = 0; i < 256; i++)
  100de5:	83 c0 01             	add    $0x1,%eax
  100de8:	3d 00 01 00 00       	cmp    $0x100,%eax
  100ded:	75 d1                	jne    100dc0 <tvinit+0x10>
}
  100def:	c3                   	ret    

00100df0 <idtinit>:

void
idtinit(void)
{
  100df0:	f3 0f 1e fb          	endbr32 
  100df4:	55                   	push   %ebp
  pd[0] = size-1;
  100df5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
  100dfa:	89 e5                	mov    %esp,%ebp
  100dfc:	83 ec 10             	sub    $0x10,%esp
  100dff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  100e03:	b8 e0 34 10 00       	mov    $0x1034e0,%eax
  100e08:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  100e0c:	c1 e8 10             	shr    $0x10,%eax
  100e0f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  100e13:	8d 45 fa             	lea    -0x6(%ebp),%eax
  100e16:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  100e19:	c9                   	leave  
  100e1a:	c3                   	ret    
  100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100e1f:	90                   	nop

00100e20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  100e20:	f3 0f 1e fb          	endbr32 
  100e24:	55                   	push   %ebp
  100e25:	89 e5                	mov    %esp,%ebp
  100e27:	57                   	push   %edi
  100e28:	56                   	push   %esi
  100e29:	53                   	push   %ebx
  100e2a:	83 ec 0c             	sub    $0xc,%esp
  100e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100e30:	8b 43 20             	mov    0x20(%ebx),%eax
  100e33:	83 e8 20             	sub    $0x20,%eax
  100e36:	83 f8 1f             	cmp    $0x1f,%eax
  100e39:	77 78                	ja     100eb3 <trap+0x93>
  100e3b:	3e ff 24 85 cc 1c 10 	notrack jmp *0x101ccc(,%eax,4)
  100e42:	00 
  100e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100e47:	90                   	nop
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  100e48:	8b 73 28             	mov    0x28(%ebx),%esi
  100e4b:	0f b7 5b 2c          	movzwl 0x2c(%ebx),%ebx
  100e4f:	e8 dc fe ff ff       	call   100d30 <cpuid>
  100e54:	56                   	push   %esi
  100e55:	53                   	push   %ebx
  100e56:	50                   	push   %eax
  100e57:	68 70 1c 10 00       	push   $0x101c70
  100e5c:	e8 8f f2 ff ff       	call   1000f0 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
  100e61:	83 c4 10             	add    $0x10,%esp
  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  }
}
  100e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e67:	5b                   	pop    %ebx
  100e68:	5e                   	pop    %esi
  100e69:	5f                   	pop    %edi
  100e6a:	5d                   	pop    %ebp
    lapiceoi();
  100e6b:	e9 f0 f7 ff ff       	jmp    100660 <lapiceoi>
    mouseintr();
  100e70:	e8 3b 0c 00 00       	call   101ab0 <mouseintr>
}
  100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e78:	5b                   	pop    %ebx
  100e79:	5e                   	pop    %esi
  100e7a:	5f                   	pop    %edi
  100e7b:	5d                   	pop    %ebp
    lapiceoi();
  100e7c:	e9 df f7 ff ff       	jmp    100660 <lapiceoi>
  100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
  100e88:	e8 f3 fb ff ff       	call   100a80 <uartintr>
}
  100e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100e90:	5b                   	pop    %ebx
  100e91:	5e                   	pop    %esi
  100e92:	5f                   	pop    %edi
  100e93:	5d                   	pop    %ebp
    lapiceoi();
  100e94:	e9 c7 f7 ff ff       	jmp    100660 <lapiceoi>
  100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ticks++;
  100ea0:	83 05 e0 3c 10 00 01 	addl   $0x1,0x103ce0
}
  100ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100eaa:	5b                   	pop    %ebx
  100eab:	5e                   	pop    %esi
  100eac:	5f                   	pop    %edi
  100ead:	5d                   	pop    %ebp
    lapiceoi();
  100eae:	e9 ad f7 ff ff       	jmp    100660 <lapiceoi>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  100eb3:	0f 20 d7             	mov    %cr2,%edi
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  100eb6:	8b 73 28             	mov    0x28(%ebx),%esi
  100eb9:	e8 72 fe ff ff       	call   100d30 <cpuid>
  100ebe:	83 ec 0c             	sub    $0xc,%esp
  100ec1:	57                   	push   %edi
  100ec2:	56                   	push   %esi
  100ec3:	50                   	push   %eax
  100ec4:	ff 73 20             	pushl  0x20(%ebx)
  100ec7:	68 94 1c 10 00       	push   $0x101c94
  100ecc:	e8 1f f2 ff ff       	call   1000f0 <cprintf>
    panic("trap");
  100ed1:	83 c4 14             	add    $0x14,%esp
  100ed4:	68 c6 1c 10 00       	push   $0x101cc6
  100ed9:	e8 c2 f3 ff ff       	call   1002a0 <panic>

00100ede <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  100ede:	6a 00                	push   $0x0
  pushl $0
  100ee0:	6a 00                	push   $0x0
  jmp alltraps
  100ee2:	e9 b9 fe ff ff       	jmp    100da0 <alltraps>

00100ee7 <vector1>:
.globl vector1
vector1:
  pushl $0
  100ee7:	6a 00                	push   $0x0
  pushl $1
  100ee9:	6a 01                	push   $0x1
  jmp alltraps
  100eeb:	e9 b0 fe ff ff       	jmp    100da0 <alltraps>

00100ef0 <vector2>:
.globl vector2
vector2:
  pushl $0
  100ef0:	6a 00                	push   $0x0
  pushl $2
  100ef2:	6a 02                	push   $0x2
  jmp alltraps
  100ef4:	e9 a7 fe ff ff       	jmp    100da0 <alltraps>

00100ef9 <vector3>:
.globl vector3
vector3:
  pushl $0
  100ef9:	6a 00                	push   $0x0
  pushl $3
  100efb:	6a 03                	push   $0x3
  jmp alltraps
  100efd:	e9 9e fe ff ff       	jmp    100da0 <alltraps>

00100f02 <vector4>:
.globl vector4
vector4:
  pushl $0
  100f02:	6a 00                	push   $0x0
  pushl $4
  100f04:	6a 04                	push   $0x4
  jmp alltraps
  100f06:	e9 95 fe ff ff       	jmp    100da0 <alltraps>

00100f0b <vector5>:
.globl vector5
vector5:
  pushl $0
  100f0b:	6a 00                	push   $0x0
  pushl $5
  100f0d:	6a 05                	push   $0x5
  jmp alltraps
  100f0f:	e9 8c fe ff ff       	jmp    100da0 <alltraps>

00100f14 <vector6>:
.globl vector6
vector6:
  pushl $0
  100f14:	6a 00                	push   $0x0
  pushl $6
  100f16:	6a 06                	push   $0x6
  jmp alltraps
  100f18:	e9 83 fe ff ff       	jmp    100da0 <alltraps>

00100f1d <vector7>:
.globl vector7
vector7:
  pushl $0
  100f1d:	6a 00                	push   $0x0
  pushl $7
  100f1f:	6a 07                	push   $0x7
  jmp alltraps
  100f21:	e9 7a fe ff ff       	jmp    100da0 <alltraps>

00100f26 <vector8>:
.globl vector8
vector8:
  pushl $8
  100f26:	6a 08                	push   $0x8
  jmp alltraps
  100f28:	e9 73 fe ff ff       	jmp    100da0 <alltraps>

00100f2d <vector9>:
.globl vector9
vector9:
  pushl $0
  100f2d:	6a 00                	push   $0x0
  pushl $9
  100f2f:	6a 09                	push   $0x9
  jmp alltraps
  100f31:	e9 6a fe ff ff       	jmp    100da0 <alltraps>

00100f36 <vector10>:
.globl vector10
vector10:
  pushl $10
  100f36:	6a 0a                	push   $0xa
  jmp alltraps
  100f38:	e9 63 fe ff ff       	jmp    100da0 <alltraps>

00100f3d <vector11>:
.globl vector11
vector11:
  pushl $11
  100f3d:	6a 0b                	push   $0xb
  jmp alltraps
  100f3f:	e9 5c fe ff ff       	jmp    100da0 <alltraps>

00100f44 <vector12>:
.globl vector12
vector12:
  pushl $12
  100f44:	6a 0c                	push   $0xc
  jmp alltraps
  100f46:	e9 55 fe ff ff       	jmp    100da0 <alltraps>

00100f4b <vector13>:
.globl vector13
vector13:
  pushl $13
  100f4b:	6a 0d                	push   $0xd
  jmp alltraps
  100f4d:	e9 4e fe ff ff       	jmp    100da0 <alltraps>

00100f52 <vector14>:
.globl vector14
vector14:
  pushl $14
  100f52:	6a 0e                	push   $0xe
  jmp alltraps
  100f54:	e9 47 fe ff ff       	jmp    100da0 <alltraps>

00100f59 <vector15>:
.globl vector15
vector15:
  pushl $0
  100f59:	6a 00                	push   $0x0
  pushl $15
  100f5b:	6a 0f                	push   $0xf
  jmp alltraps
  100f5d:	e9 3e fe ff ff       	jmp    100da0 <alltraps>

00100f62 <vector16>:
.globl vector16
vector16:
  pushl $0
  100f62:	6a 00                	push   $0x0
  pushl $16
  100f64:	6a 10                	push   $0x10
  jmp alltraps
  100f66:	e9 35 fe ff ff       	jmp    100da0 <alltraps>

00100f6b <vector17>:
.globl vector17
vector17:
  pushl $17
  100f6b:	6a 11                	push   $0x11
  jmp alltraps
  100f6d:	e9 2e fe ff ff       	jmp    100da0 <alltraps>

00100f72 <vector18>:
.globl vector18
vector18:
  pushl $0
  100f72:	6a 00                	push   $0x0
  pushl $18
  100f74:	6a 12                	push   $0x12
  jmp alltraps
  100f76:	e9 25 fe ff ff       	jmp    100da0 <alltraps>

00100f7b <vector19>:
.globl vector19
vector19:
  pushl $0
  100f7b:	6a 00                	push   $0x0
  pushl $19
  100f7d:	6a 13                	push   $0x13
  jmp alltraps
  100f7f:	e9 1c fe ff ff       	jmp    100da0 <alltraps>

00100f84 <vector20>:
.globl vector20
vector20:
  pushl $0
  100f84:	6a 00                	push   $0x0
  pushl $20
  100f86:	6a 14                	push   $0x14
  jmp alltraps
  100f88:	e9 13 fe ff ff       	jmp    100da0 <alltraps>

00100f8d <vector21>:
.globl vector21
vector21:
  pushl $0
  100f8d:	6a 00                	push   $0x0
  pushl $21
  100f8f:	6a 15                	push   $0x15
  jmp alltraps
  100f91:	e9 0a fe ff ff       	jmp    100da0 <alltraps>

00100f96 <vector22>:
.globl vector22
vector22:
  pushl $0
  100f96:	6a 00                	push   $0x0
  pushl $22
  100f98:	6a 16                	push   $0x16
  jmp alltraps
  100f9a:	e9 01 fe ff ff       	jmp    100da0 <alltraps>

00100f9f <vector23>:
.globl vector23
vector23:
  pushl $0
  100f9f:	6a 00                	push   $0x0
  pushl $23
  100fa1:	6a 17                	push   $0x17
  jmp alltraps
  100fa3:	e9 f8 fd ff ff       	jmp    100da0 <alltraps>

00100fa8 <vector24>:
.globl vector24
vector24:
  pushl $0
  100fa8:	6a 00                	push   $0x0
  pushl $24
  100faa:	6a 18                	push   $0x18
  jmp alltraps
  100fac:	e9 ef fd ff ff       	jmp    100da0 <alltraps>

00100fb1 <vector25>:
.globl vector25
vector25:
  pushl $0
  100fb1:	6a 00                	push   $0x0
  pushl $25
  100fb3:	6a 19                	push   $0x19
  jmp alltraps
  100fb5:	e9 e6 fd ff ff       	jmp    100da0 <alltraps>

00100fba <vector26>:
.globl vector26
vector26:
  pushl $0
  100fba:	6a 00                	push   $0x0
  pushl $26
  100fbc:	6a 1a                	push   $0x1a
  jmp alltraps
  100fbe:	e9 dd fd ff ff       	jmp    100da0 <alltraps>

00100fc3 <vector27>:
.globl vector27
vector27:
  pushl $0
  100fc3:	6a 00                	push   $0x0
  pushl $27
  100fc5:	6a 1b                	push   $0x1b
  jmp alltraps
  100fc7:	e9 d4 fd ff ff       	jmp    100da0 <alltraps>

00100fcc <vector28>:
.globl vector28
vector28:
  pushl $0
  100fcc:	6a 00                	push   $0x0
  pushl $28
  100fce:	6a 1c                	push   $0x1c
  jmp alltraps
  100fd0:	e9 cb fd ff ff       	jmp    100da0 <alltraps>

00100fd5 <vector29>:
.globl vector29
vector29:
  pushl $0
  100fd5:	6a 00                	push   $0x0
  pushl $29
  100fd7:	6a 1d                	push   $0x1d
  jmp alltraps
  100fd9:	e9 c2 fd ff ff       	jmp    100da0 <alltraps>

00100fde <vector30>:
.globl vector30
vector30:
  pushl $0
  100fde:	6a 00                	push   $0x0
  pushl $30
  100fe0:	6a 1e                	push   $0x1e
  jmp alltraps
  100fe2:	e9 b9 fd ff ff       	jmp    100da0 <alltraps>

00100fe7 <vector31>:
.globl vector31
vector31:
  pushl $0
  100fe7:	6a 00                	push   $0x0
  pushl $31
  100fe9:	6a 1f                	push   $0x1f
  jmp alltraps
  100feb:	e9 b0 fd ff ff       	jmp    100da0 <alltraps>

00100ff0 <vector32>:
.globl vector32
vector32:
  pushl $0
  100ff0:	6a 00                	push   $0x0
  pushl $32
  100ff2:	6a 20                	push   $0x20
  jmp alltraps
  100ff4:	e9 a7 fd ff ff       	jmp    100da0 <alltraps>

00100ff9 <vector33>:
.globl vector33
vector33:
  pushl $0
  100ff9:	6a 00                	push   $0x0
  pushl $33
  100ffb:	6a 21                	push   $0x21
  jmp alltraps
  100ffd:	e9 9e fd ff ff       	jmp    100da0 <alltraps>

00101002 <vector34>:
.globl vector34
vector34:
  pushl $0
  101002:	6a 00                	push   $0x0
  pushl $34
  101004:	6a 22                	push   $0x22
  jmp alltraps
  101006:	e9 95 fd ff ff       	jmp    100da0 <alltraps>

0010100b <vector35>:
.globl vector35
vector35:
  pushl $0
  10100b:	6a 00                	push   $0x0
  pushl $35
  10100d:	6a 23                	push   $0x23
  jmp alltraps
  10100f:	e9 8c fd ff ff       	jmp    100da0 <alltraps>

00101014 <vector36>:
.globl vector36
vector36:
  pushl $0
  101014:	6a 00                	push   $0x0
  pushl $36
  101016:	6a 24                	push   $0x24
  jmp alltraps
  101018:	e9 83 fd ff ff       	jmp    100da0 <alltraps>

0010101d <vector37>:
.globl vector37
vector37:
  pushl $0
  10101d:	6a 00                	push   $0x0
  pushl $37
  10101f:	6a 25                	push   $0x25
  jmp alltraps
  101021:	e9 7a fd ff ff       	jmp    100da0 <alltraps>

00101026 <vector38>:
.globl vector38
vector38:
  pushl $0
  101026:	6a 00                	push   $0x0
  pushl $38
  101028:	6a 26                	push   $0x26
  jmp alltraps
  10102a:	e9 71 fd ff ff       	jmp    100da0 <alltraps>

0010102f <vector39>:
.globl vector39
vector39:
  pushl $0
  10102f:	6a 00                	push   $0x0
  pushl $39
  101031:	6a 27                	push   $0x27
  jmp alltraps
  101033:	e9 68 fd ff ff       	jmp    100da0 <alltraps>

00101038 <vector40>:
.globl vector40
vector40:
  pushl $0
  101038:	6a 00                	push   $0x0
  pushl $40
  10103a:	6a 28                	push   $0x28
  jmp alltraps
  10103c:	e9 5f fd ff ff       	jmp    100da0 <alltraps>

00101041 <vector41>:
.globl vector41
vector41:
  pushl $0
  101041:	6a 00                	push   $0x0
  pushl $41
  101043:	6a 29                	push   $0x29
  jmp alltraps
  101045:	e9 56 fd ff ff       	jmp    100da0 <alltraps>

0010104a <vector42>:
.globl vector42
vector42:
  pushl $0
  10104a:	6a 00                	push   $0x0
  pushl $42
  10104c:	6a 2a                	push   $0x2a
  jmp alltraps
  10104e:	e9 4d fd ff ff       	jmp    100da0 <alltraps>

00101053 <vector43>:
.globl vector43
vector43:
  pushl $0
  101053:	6a 00                	push   $0x0
  pushl $43
  101055:	6a 2b                	push   $0x2b
  jmp alltraps
  101057:	e9 44 fd ff ff       	jmp    100da0 <alltraps>

0010105c <vector44>:
.globl vector44
vector44:
  pushl $0
  10105c:	6a 00                	push   $0x0
  pushl $44
  10105e:	6a 2c                	push   $0x2c
  jmp alltraps
  101060:	e9 3b fd ff ff       	jmp    100da0 <alltraps>

00101065 <vector45>:
.globl vector45
vector45:
  pushl $0
  101065:	6a 00                	push   $0x0
  pushl $45
  101067:	6a 2d                	push   $0x2d
  jmp alltraps
  101069:	e9 32 fd ff ff       	jmp    100da0 <alltraps>

0010106e <vector46>:
.globl vector46
vector46:
  pushl $0
  10106e:	6a 00                	push   $0x0
  pushl $46
  101070:	6a 2e                	push   $0x2e
  jmp alltraps
  101072:	e9 29 fd ff ff       	jmp    100da0 <alltraps>

00101077 <vector47>:
.globl vector47
vector47:
  pushl $0
  101077:	6a 00                	push   $0x0
  pushl $47
  101079:	6a 2f                	push   $0x2f
  jmp alltraps
  10107b:	e9 20 fd ff ff       	jmp    100da0 <alltraps>

00101080 <vector48>:
.globl vector48
vector48:
  pushl $0
  101080:	6a 00                	push   $0x0
  pushl $48
  101082:	6a 30                	push   $0x30
  jmp alltraps
  101084:	e9 17 fd ff ff       	jmp    100da0 <alltraps>

00101089 <vector49>:
.globl vector49
vector49:
  pushl $0
  101089:	6a 00                	push   $0x0
  pushl $49
  10108b:	6a 31                	push   $0x31
  jmp alltraps
  10108d:	e9 0e fd ff ff       	jmp    100da0 <alltraps>

00101092 <vector50>:
.globl vector50
vector50:
  pushl $0
  101092:	6a 00                	push   $0x0
  pushl $50
  101094:	6a 32                	push   $0x32
  jmp alltraps
  101096:	e9 05 fd ff ff       	jmp    100da0 <alltraps>

0010109b <vector51>:
.globl vector51
vector51:
  pushl $0
  10109b:	6a 00                	push   $0x0
  pushl $51
  10109d:	6a 33                	push   $0x33
  jmp alltraps
  10109f:	e9 fc fc ff ff       	jmp    100da0 <alltraps>

001010a4 <vector52>:
.globl vector52
vector52:
  pushl $0
  1010a4:	6a 00                	push   $0x0
  pushl $52
  1010a6:	6a 34                	push   $0x34
  jmp alltraps
  1010a8:	e9 f3 fc ff ff       	jmp    100da0 <alltraps>

001010ad <vector53>:
.globl vector53
vector53:
  pushl $0
  1010ad:	6a 00                	push   $0x0
  pushl $53
  1010af:	6a 35                	push   $0x35
  jmp alltraps
  1010b1:	e9 ea fc ff ff       	jmp    100da0 <alltraps>

001010b6 <vector54>:
.globl vector54
vector54:
  pushl $0
  1010b6:	6a 00                	push   $0x0
  pushl $54
  1010b8:	6a 36                	push   $0x36
  jmp alltraps
  1010ba:	e9 e1 fc ff ff       	jmp    100da0 <alltraps>

001010bf <vector55>:
.globl vector55
vector55:
  pushl $0
  1010bf:	6a 00                	push   $0x0
  pushl $55
  1010c1:	6a 37                	push   $0x37
  jmp alltraps
  1010c3:	e9 d8 fc ff ff       	jmp    100da0 <alltraps>

001010c8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1010c8:	6a 00                	push   $0x0
  pushl $56
  1010ca:	6a 38                	push   $0x38
  jmp alltraps
  1010cc:	e9 cf fc ff ff       	jmp    100da0 <alltraps>

001010d1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1010d1:	6a 00                	push   $0x0
  pushl $57
  1010d3:	6a 39                	push   $0x39
  jmp alltraps
  1010d5:	e9 c6 fc ff ff       	jmp    100da0 <alltraps>

001010da <vector58>:
.globl vector58
vector58:
  pushl $0
  1010da:	6a 00                	push   $0x0
  pushl $58
  1010dc:	6a 3a                	push   $0x3a
  jmp alltraps
  1010de:	e9 bd fc ff ff       	jmp    100da0 <alltraps>

001010e3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1010e3:	6a 00                	push   $0x0
  pushl $59
  1010e5:	6a 3b                	push   $0x3b
  jmp alltraps
  1010e7:	e9 b4 fc ff ff       	jmp    100da0 <alltraps>

001010ec <vector60>:
.globl vector60
vector60:
  pushl $0
  1010ec:	6a 00                	push   $0x0
  pushl $60
  1010ee:	6a 3c                	push   $0x3c
  jmp alltraps
  1010f0:	e9 ab fc ff ff       	jmp    100da0 <alltraps>

001010f5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1010f5:	6a 00                	push   $0x0
  pushl $61
  1010f7:	6a 3d                	push   $0x3d
  jmp alltraps
  1010f9:	e9 a2 fc ff ff       	jmp    100da0 <alltraps>

001010fe <vector62>:
.globl vector62
vector62:
  pushl $0
  1010fe:	6a 00                	push   $0x0
  pushl $62
  101100:	6a 3e                	push   $0x3e
  jmp alltraps
  101102:	e9 99 fc ff ff       	jmp    100da0 <alltraps>

00101107 <vector63>:
.globl vector63
vector63:
  pushl $0
  101107:	6a 00                	push   $0x0
  pushl $63
  101109:	6a 3f                	push   $0x3f
  jmp alltraps
  10110b:	e9 90 fc ff ff       	jmp    100da0 <alltraps>

00101110 <vector64>:
.globl vector64
vector64:
  pushl $0
  101110:	6a 00                	push   $0x0
  pushl $64
  101112:	6a 40                	push   $0x40
  jmp alltraps
  101114:	e9 87 fc ff ff       	jmp    100da0 <alltraps>

00101119 <vector65>:
.globl vector65
vector65:
  pushl $0
  101119:	6a 00                	push   $0x0
  pushl $65
  10111b:	6a 41                	push   $0x41
  jmp alltraps
  10111d:	e9 7e fc ff ff       	jmp    100da0 <alltraps>

00101122 <vector66>:
.globl vector66
vector66:
  pushl $0
  101122:	6a 00                	push   $0x0
  pushl $66
  101124:	6a 42                	push   $0x42
  jmp alltraps
  101126:	e9 75 fc ff ff       	jmp    100da0 <alltraps>

0010112b <vector67>:
.globl vector67
vector67:
  pushl $0
  10112b:	6a 00                	push   $0x0
  pushl $67
  10112d:	6a 43                	push   $0x43
  jmp alltraps
  10112f:	e9 6c fc ff ff       	jmp    100da0 <alltraps>

00101134 <vector68>:
.globl vector68
vector68:
  pushl $0
  101134:	6a 00                	push   $0x0
  pushl $68
  101136:	6a 44                	push   $0x44
  jmp alltraps
  101138:	e9 63 fc ff ff       	jmp    100da0 <alltraps>

0010113d <vector69>:
.globl vector69
vector69:
  pushl $0
  10113d:	6a 00                	push   $0x0
  pushl $69
  10113f:	6a 45                	push   $0x45
  jmp alltraps
  101141:	e9 5a fc ff ff       	jmp    100da0 <alltraps>

00101146 <vector70>:
.globl vector70
vector70:
  pushl $0
  101146:	6a 00                	push   $0x0
  pushl $70
  101148:	6a 46                	push   $0x46
  jmp alltraps
  10114a:	e9 51 fc ff ff       	jmp    100da0 <alltraps>

0010114f <vector71>:
.globl vector71
vector71:
  pushl $0
  10114f:	6a 00                	push   $0x0
  pushl $71
  101151:	6a 47                	push   $0x47
  jmp alltraps
  101153:	e9 48 fc ff ff       	jmp    100da0 <alltraps>

00101158 <vector72>:
.globl vector72
vector72:
  pushl $0
  101158:	6a 00                	push   $0x0
  pushl $72
  10115a:	6a 48                	push   $0x48
  jmp alltraps
  10115c:	e9 3f fc ff ff       	jmp    100da0 <alltraps>

00101161 <vector73>:
.globl vector73
vector73:
  pushl $0
  101161:	6a 00                	push   $0x0
  pushl $73
  101163:	6a 49                	push   $0x49
  jmp alltraps
  101165:	e9 36 fc ff ff       	jmp    100da0 <alltraps>

0010116a <vector74>:
.globl vector74
vector74:
  pushl $0
  10116a:	6a 00                	push   $0x0
  pushl $74
  10116c:	6a 4a                	push   $0x4a
  jmp alltraps
  10116e:	e9 2d fc ff ff       	jmp    100da0 <alltraps>

00101173 <vector75>:
.globl vector75
vector75:
  pushl $0
  101173:	6a 00                	push   $0x0
  pushl $75
  101175:	6a 4b                	push   $0x4b
  jmp alltraps
  101177:	e9 24 fc ff ff       	jmp    100da0 <alltraps>

0010117c <vector76>:
.globl vector76
vector76:
  pushl $0
  10117c:	6a 00                	push   $0x0
  pushl $76
  10117e:	6a 4c                	push   $0x4c
  jmp alltraps
  101180:	e9 1b fc ff ff       	jmp    100da0 <alltraps>

00101185 <vector77>:
.globl vector77
vector77:
  pushl $0
  101185:	6a 00                	push   $0x0
  pushl $77
  101187:	6a 4d                	push   $0x4d
  jmp alltraps
  101189:	e9 12 fc ff ff       	jmp    100da0 <alltraps>

0010118e <vector78>:
.globl vector78
vector78:
  pushl $0
  10118e:	6a 00                	push   $0x0
  pushl $78
  101190:	6a 4e                	push   $0x4e
  jmp alltraps
  101192:	e9 09 fc ff ff       	jmp    100da0 <alltraps>

00101197 <vector79>:
.globl vector79
vector79:
  pushl $0
  101197:	6a 00                	push   $0x0
  pushl $79
  101199:	6a 4f                	push   $0x4f
  jmp alltraps
  10119b:	e9 00 fc ff ff       	jmp    100da0 <alltraps>

001011a0 <vector80>:
.globl vector80
vector80:
  pushl $0
  1011a0:	6a 00                	push   $0x0
  pushl $80
  1011a2:	6a 50                	push   $0x50
  jmp alltraps
  1011a4:	e9 f7 fb ff ff       	jmp    100da0 <alltraps>

001011a9 <vector81>:
.globl vector81
vector81:
  pushl $0
  1011a9:	6a 00                	push   $0x0
  pushl $81
  1011ab:	6a 51                	push   $0x51
  jmp alltraps
  1011ad:	e9 ee fb ff ff       	jmp    100da0 <alltraps>

001011b2 <vector82>:
.globl vector82
vector82:
  pushl $0
  1011b2:	6a 00                	push   $0x0
  pushl $82
  1011b4:	6a 52                	push   $0x52
  jmp alltraps
  1011b6:	e9 e5 fb ff ff       	jmp    100da0 <alltraps>

001011bb <vector83>:
.globl vector83
vector83:
  pushl $0
  1011bb:	6a 00                	push   $0x0
  pushl $83
  1011bd:	6a 53                	push   $0x53
  jmp alltraps
  1011bf:	e9 dc fb ff ff       	jmp    100da0 <alltraps>

001011c4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1011c4:	6a 00                	push   $0x0
  pushl $84
  1011c6:	6a 54                	push   $0x54
  jmp alltraps
  1011c8:	e9 d3 fb ff ff       	jmp    100da0 <alltraps>

001011cd <vector85>:
.globl vector85
vector85:
  pushl $0
  1011cd:	6a 00                	push   $0x0
  pushl $85
  1011cf:	6a 55                	push   $0x55
  jmp alltraps
  1011d1:	e9 ca fb ff ff       	jmp    100da0 <alltraps>

001011d6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1011d6:	6a 00                	push   $0x0
  pushl $86
  1011d8:	6a 56                	push   $0x56
  jmp alltraps
  1011da:	e9 c1 fb ff ff       	jmp    100da0 <alltraps>

001011df <vector87>:
.globl vector87
vector87:
  pushl $0
  1011df:	6a 00                	push   $0x0
  pushl $87
  1011e1:	6a 57                	push   $0x57
  jmp alltraps
  1011e3:	e9 b8 fb ff ff       	jmp    100da0 <alltraps>

001011e8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1011e8:	6a 00                	push   $0x0
  pushl $88
  1011ea:	6a 58                	push   $0x58
  jmp alltraps
  1011ec:	e9 af fb ff ff       	jmp    100da0 <alltraps>

001011f1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1011f1:	6a 00                	push   $0x0
  pushl $89
  1011f3:	6a 59                	push   $0x59
  jmp alltraps
  1011f5:	e9 a6 fb ff ff       	jmp    100da0 <alltraps>

001011fa <vector90>:
.globl vector90
vector90:
  pushl $0
  1011fa:	6a 00                	push   $0x0
  pushl $90
  1011fc:	6a 5a                	push   $0x5a
  jmp alltraps
  1011fe:	e9 9d fb ff ff       	jmp    100da0 <alltraps>

00101203 <vector91>:
.globl vector91
vector91:
  pushl $0
  101203:	6a 00                	push   $0x0
  pushl $91
  101205:	6a 5b                	push   $0x5b
  jmp alltraps
  101207:	e9 94 fb ff ff       	jmp    100da0 <alltraps>

0010120c <vector92>:
.globl vector92
vector92:
  pushl $0
  10120c:	6a 00                	push   $0x0
  pushl $92
  10120e:	6a 5c                	push   $0x5c
  jmp alltraps
  101210:	e9 8b fb ff ff       	jmp    100da0 <alltraps>

00101215 <vector93>:
.globl vector93
vector93:
  pushl $0
  101215:	6a 00                	push   $0x0
  pushl $93
  101217:	6a 5d                	push   $0x5d
  jmp alltraps
  101219:	e9 82 fb ff ff       	jmp    100da0 <alltraps>

0010121e <vector94>:
.globl vector94
vector94:
  pushl $0
  10121e:	6a 00                	push   $0x0
  pushl $94
  101220:	6a 5e                	push   $0x5e
  jmp alltraps
  101222:	e9 79 fb ff ff       	jmp    100da0 <alltraps>

00101227 <vector95>:
.globl vector95
vector95:
  pushl $0
  101227:	6a 00                	push   $0x0
  pushl $95
  101229:	6a 5f                	push   $0x5f
  jmp alltraps
  10122b:	e9 70 fb ff ff       	jmp    100da0 <alltraps>

00101230 <vector96>:
.globl vector96
vector96:
  pushl $0
  101230:	6a 00                	push   $0x0
  pushl $96
  101232:	6a 60                	push   $0x60
  jmp alltraps
  101234:	e9 67 fb ff ff       	jmp    100da0 <alltraps>

00101239 <vector97>:
.globl vector97
vector97:
  pushl $0
  101239:	6a 00                	push   $0x0
  pushl $97
  10123b:	6a 61                	push   $0x61
  jmp alltraps
  10123d:	e9 5e fb ff ff       	jmp    100da0 <alltraps>

00101242 <vector98>:
.globl vector98
vector98:
  pushl $0
  101242:	6a 00                	push   $0x0
  pushl $98
  101244:	6a 62                	push   $0x62
  jmp alltraps
  101246:	e9 55 fb ff ff       	jmp    100da0 <alltraps>

0010124b <vector99>:
.globl vector99
vector99:
  pushl $0
  10124b:	6a 00                	push   $0x0
  pushl $99
  10124d:	6a 63                	push   $0x63
  jmp alltraps
  10124f:	e9 4c fb ff ff       	jmp    100da0 <alltraps>

00101254 <vector100>:
.globl vector100
vector100:
  pushl $0
  101254:	6a 00                	push   $0x0
  pushl $100
  101256:	6a 64                	push   $0x64
  jmp alltraps
  101258:	e9 43 fb ff ff       	jmp    100da0 <alltraps>

0010125d <vector101>:
.globl vector101
vector101:
  pushl $0
  10125d:	6a 00                	push   $0x0
  pushl $101
  10125f:	6a 65                	push   $0x65
  jmp alltraps
  101261:	e9 3a fb ff ff       	jmp    100da0 <alltraps>

00101266 <vector102>:
.globl vector102
vector102:
  pushl $0
  101266:	6a 00                	push   $0x0
  pushl $102
  101268:	6a 66                	push   $0x66
  jmp alltraps
  10126a:	e9 31 fb ff ff       	jmp    100da0 <alltraps>

0010126f <vector103>:
.globl vector103
vector103:
  pushl $0
  10126f:	6a 00                	push   $0x0
  pushl $103
  101271:	6a 67                	push   $0x67
  jmp alltraps
  101273:	e9 28 fb ff ff       	jmp    100da0 <alltraps>

00101278 <vector104>:
.globl vector104
vector104:
  pushl $0
  101278:	6a 00                	push   $0x0
  pushl $104
  10127a:	6a 68                	push   $0x68
  jmp alltraps
  10127c:	e9 1f fb ff ff       	jmp    100da0 <alltraps>

00101281 <vector105>:
.globl vector105
vector105:
  pushl $0
  101281:	6a 00                	push   $0x0
  pushl $105
  101283:	6a 69                	push   $0x69
  jmp alltraps
  101285:	e9 16 fb ff ff       	jmp    100da0 <alltraps>

0010128a <vector106>:
.globl vector106
vector106:
  pushl $0
  10128a:	6a 00                	push   $0x0
  pushl $106
  10128c:	6a 6a                	push   $0x6a
  jmp alltraps
  10128e:	e9 0d fb ff ff       	jmp    100da0 <alltraps>

00101293 <vector107>:
.globl vector107
vector107:
  pushl $0
  101293:	6a 00                	push   $0x0
  pushl $107
  101295:	6a 6b                	push   $0x6b
  jmp alltraps
  101297:	e9 04 fb ff ff       	jmp    100da0 <alltraps>

0010129c <vector108>:
.globl vector108
vector108:
  pushl $0
  10129c:	6a 00                	push   $0x0
  pushl $108
  10129e:	6a 6c                	push   $0x6c
  jmp alltraps
  1012a0:	e9 fb fa ff ff       	jmp    100da0 <alltraps>

001012a5 <vector109>:
.globl vector109
vector109:
  pushl $0
  1012a5:	6a 00                	push   $0x0
  pushl $109
  1012a7:	6a 6d                	push   $0x6d
  jmp alltraps
  1012a9:	e9 f2 fa ff ff       	jmp    100da0 <alltraps>

001012ae <vector110>:
.globl vector110
vector110:
  pushl $0
  1012ae:	6a 00                	push   $0x0
  pushl $110
  1012b0:	6a 6e                	push   $0x6e
  jmp alltraps
  1012b2:	e9 e9 fa ff ff       	jmp    100da0 <alltraps>

001012b7 <vector111>:
.globl vector111
vector111:
  pushl $0
  1012b7:	6a 00                	push   $0x0
  pushl $111
  1012b9:	6a 6f                	push   $0x6f
  jmp alltraps
  1012bb:	e9 e0 fa ff ff       	jmp    100da0 <alltraps>

001012c0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1012c0:	6a 00                	push   $0x0
  pushl $112
  1012c2:	6a 70                	push   $0x70
  jmp alltraps
  1012c4:	e9 d7 fa ff ff       	jmp    100da0 <alltraps>

001012c9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1012c9:	6a 00                	push   $0x0
  pushl $113
  1012cb:	6a 71                	push   $0x71
  jmp alltraps
  1012cd:	e9 ce fa ff ff       	jmp    100da0 <alltraps>

001012d2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1012d2:	6a 00                	push   $0x0
  pushl $114
  1012d4:	6a 72                	push   $0x72
  jmp alltraps
  1012d6:	e9 c5 fa ff ff       	jmp    100da0 <alltraps>

001012db <vector115>:
.globl vector115
vector115:
  pushl $0
  1012db:	6a 00                	push   $0x0
  pushl $115
  1012dd:	6a 73                	push   $0x73
  jmp alltraps
  1012df:	e9 bc fa ff ff       	jmp    100da0 <alltraps>

001012e4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1012e4:	6a 00                	push   $0x0
  pushl $116
  1012e6:	6a 74                	push   $0x74
  jmp alltraps
  1012e8:	e9 b3 fa ff ff       	jmp    100da0 <alltraps>

001012ed <vector117>:
.globl vector117
vector117:
  pushl $0
  1012ed:	6a 00                	push   $0x0
  pushl $117
  1012ef:	6a 75                	push   $0x75
  jmp alltraps
  1012f1:	e9 aa fa ff ff       	jmp    100da0 <alltraps>

001012f6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1012f6:	6a 00                	push   $0x0
  pushl $118
  1012f8:	6a 76                	push   $0x76
  jmp alltraps
  1012fa:	e9 a1 fa ff ff       	jmp    100da0 <alltraps>

001012ff <vector119>:
.globl vector119
vector119:
  pushl $0
  1012ff:	6a 00                	push   $0x0
  pushl $119
  101301:	6a 77                	push   $0x77
  jmp alltraps
  101303:	e9 98 fa ff ff       	jmp    100da0 <alltraps>

00101308 <vector120>:
.globl vector120
vector120:
  pushl $0
  101308:	6a 00                	push   $0x0
  pushl $120
  10130a:	6a 78                	push   $0x78
  jmp alltraps
  10130c:	e9 8f fa ff ff       	jmp    100da0 <alltraps>

00101311 <vector121>:
.globl vector121
vector121:
  pushl $0
  101311:	6a 00                	push   $0x0
  pushl $121
  101313:	6a 79                	push   $0x79
  jmp alltraps
  101315:	e9 86 fa ff ff       	jmp    100da0 <alltraps>

0010131a <vector122>:
.globl vector122
vector122:
  pushl $0
  10131a:	6a 00                	push   $0x0
  pushl $122
  10131c:	6a 7a                	push   $0x7a
  jmp alltraps
  10131e:	e9 7d fa ff ff       	jmp    100da0 <alltraps>

00101323 <vector123>:
.globl vector123
vector123:
  pushl $0
  101323:	6a 00                	push   $0x0
  pushl $123
  101325:	6a 7b                	push   $0x7b
  jmp alltraps
  101327:	e9 74 fa ff ff       	jmp    100da0 <alltraps>

0010132c <vector124>:
.globl vector124
vector124:
  pushl $0
  10132c:	6a 00                	push   $0x0
  pushl $124
  10132e:	6a 7c                	push   $0x7c
  jmp alltraps
  101330:	e9 6b fa ff ff       	jmp    100da0 <alltraps>

00101335 <vector125>:
.globl vector125
vector125:
  pushl $0
  101335:	6a 00                	push   $0x0
  pushl $125
  101337:	6a 7d                	push   $0x7d
  jmp alltraps
  101339:	e9 62 fa ff ff       	jmp    100da0 <alltraps>

0010133e <vector126>:
.globl vector126
vector126:
  pushl $0
  10133e:	6a 00                	push   $0x0
  pushl $126
  101340:	6a 7e                	push   $0x7e
  jmp alltraps
  101342:	e9 59 fa ff ff       	jmp    100da0 <alltraps>

00101347 <vector127>:
.globl vector127
vector127:
  pushl $0
  101347:	6a 00                	push   $0x0
  pushl $127
  101349:	6a 7f                	push   $0x7f
  jmp alltraps
  10134b:	e9 50 fa ff ff       	jmp    100da0 <alltraps>

00101350 <vector128>:
.globl vector128
vector128:
  pushl $0
  101350:	6a 00                	push   $0x0
  pushl $128
  101352:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101357:	e9 44 fa ff ff       	jmp    100da0 <alltraps>

0010135c <vector129>:
.globl vector129
vector129:
  pushl $0
  10135c:	6a 00                	push   $0x0
  pushl $129
  10135e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  101363:	e9 38 fa ff ff       	jmp    100da0 <alltraps>

00101368 <vector130>:
.globl vector130
vector130:
  pushl $0
  101368:	6a 00                	push   $0x0
  pushl $130
  10136a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  10136f:	e9 2c fa ff ff       	jmp    100da0 <alltraps>

00101374 <vector131>:
.globl vector131
vector131:
  pushl $0
  101374:	6a 00                	push   $0x0
  pushl $131
  101376:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  10137b:	e9 20 fa ff ff       	jmp    100da0 <alltraps>

00101380 <vector132>:
.globl vector132
vector132:
  pushl $0
  101380:	6a 00                	push   $0x0
  pushl $132
  101382:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  101387:	e9 14 fa ff ff       	jmp    100da0 <alltraps>

0010138c <vector133>:
.globl vector133
vector133:
  pushl $0
  10138c:	6a 00                	push   $0x0
  pushl $133
  10138e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  101393:	e9 08 fa ff ff       	jmp    100da0 <alltraps>

00101398 <vector134>:
.globl vector134
vector134:
  pushl $0
  101398:	6a 00                	push   $0x0
  pushl $134
  10139a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  10139f:	e9 fc f9 ff ff       	jmp    100da0 <alltraps>

001013a4 <vector135>:
.globl vector135
vector135:
  pushl $0
  1013a4:	6a 00                	push   $0x0
  pushl $135
  1013a6:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  1013ab:	e9 f0 f9 ff ff       	jmp    100da0 <alltraps>

001013b0 <vector136>:
.globl vector136
vector136:
  pushl $0
  1013b0:	6a 00                	push   $0x0
  pushl $136
  1013b2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  1013b7:	e9 e4 f9 ff ff       	jmp    100da0 <alltraps>

001013bc <vector137>:
.globl vector137
vector137:
  pushl $0
  1013bc:	6a 00                	push   $0x0
  pushl $137
  1013be:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  1013c3:	e9 d8 f9 ff ff       	jmp    100da0 <alltraps>

001013c8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1013c8:	6a 00                	push   $0x0
  pushl $138
  1013ca:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  1013cf:	e9 cc f9 ff ff       	jmp    100da0 <alltraps>

001013d4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1013d4:	6a 00                	push   $0x0
  pushl $139
  1013d6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  1013db:	e9 c0 f9 ff ff       	jmp    100da0 <alltraps>

001013e0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1013e0:	6a 00                	push   $0x0
  pushl $140
  1013e2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  1013e7:	e9 b4 f9 ff ff       	jmp    100da0 <alltraps>

001013ec <vector141>:
.globl vector141
vector141:
  pushl $0
  1013ec:	6a 00                	push   $0x0
  pushl $141
  1013ee:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  1013f3:	e9 a8 f9 ff ff       	jmp    100da0 <alltraps>

001013f8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1013f8:	6a 00                	push   $0x0
  pushl $142
  1013fa:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  1013ff:	e9 9c f9 ff ff       	jmp    100da0 <alltraps>

00101404 <vector143>:
.globl vector143
vector143:
  pushl $0
  101404:	6a 00                	push   $0x0
  pushl $143
  101406:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  10140b:	e9 90 f9 ff ff       	jmp    100da0 <alltraps>

00101410 <vector144>:
.globl vector144
vector144:
  pushl $0
  101410:	6a 00                	push   $0x0
  pushl $144
  101412:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  101417:	e9 84 f9 ff ff       	jmp    100da0 <alltraps>

0010141c <vector145>:
.globl vector145
vector145:
  pushl $0
  10141c:	6a 00                	push   $0x0
  pushl $145
  10141e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  101423:	e9 78 f9 ff ff       	jmp    100da0 <alltraps>

00101428 <vector146>:
.globl vector146
vector146:
  pushl $0
  101428:	6a 00                	push   $0x0
  pushl $146
  10142a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  10142f:	e9 6c f9 ff ff       	jmp    100da0 <alltraps>

00101434 <vector147>:
.globl vector147
vector147:
  pushl $0
  101434:	6a 00                	push   $0x0
  pushl $147
  101436:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  10143b:	e9 60 f9 ff ff       	jmp    100da0 <alltraps>

00101440 <vector148>:
.globl vector148
vector148:
  pushl $0
  101440:	6a 00                	push   $0x0
  pushl $148
  101442:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101447:	e9 54 f9 ff ff       	jmp    100da0 <alltraps>

0010144c <vector149>:
.globl vector149
vector149:
  pushl $0
  10144c:	6a 00                	push   $0x0
  pushl $149
  10144e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101453:	e9 48 f9 ff ff       	jmp    100da0 <alltraps>

00101458 <vector150>:
.globl vector150
vector150:
  pushl $0
  101458:	6a 00                	push   $0x0
  pushl $150
  10145a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  10145f:	e9 3c f9 ff ff       	jmp    100da0 <alltraps>

00101464 <vector151>:
.globl vector151
vector151:
  pushl $0
  101464:	6a 00                	push   $0x0
  pushl $151
  101466:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  10146b:	e9 30 f9 ff ff       	jmp    100da0 <alltraps>

00101470 <vector152>:
.globl vector152
vector152:
  pushl $0
  101470:	6a 00                	push   $0x0
  pushl $152
  101472:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  101477:	e9 24 f9 ff ff       	jmp    100da0 <alltraps>

0010147c <vector153>:
.globl vector153
vector153:
  pushl $0
  10147c:	6a 00                	push   $0x0
  pushl $153
  10147e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  101483:	e9 18 f9 ff ff       	jmp    100da0 <alltraps>

00101488 <vector154>:
.globl vector154
vector154:
  pushl $0
  101488:	6a 00                	push   $0x0
  pushl $154
  10148a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  10148f:	e9 0c f9 ff ff       	jmp    100da0 <alltraps>

00101494 <vector155>:
.globl vector155
vector155:
  pushl $0
  101494:	6a 00                	push   $0x0
  pushl $155
  101496:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  10149b:	e9 00 f9 ff ff       	jmp    100da0 <alltraps>

001014a0 <vector156>:
.globl vector156
vector156:
  pushl $0
  1014a0:	6a 00                	push   $0x0
  pushl $156
  1014a2:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  1014a7:	e9 f4 f8 ff ff       	jmp    100da0 <alltraps>

001014ac <vector157>:
.globl vector157
vector157:
  pushl $0
  1014ac:	6a 00                	push   $0x0
  pushl $157
  1014ae:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  1014b3:	e9 e8 f8 ff ff       	jmp    100da0 <alltraps>

001014b8 <vector158>:
.globl vector158
vector158:
  pushl $0
  1014b8:	6a 00                	push   $0x0
  pushl $158
  1014ba:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  1014bf:	e9 dc f8 ff ff       	jmp    100da0 <alltraps>

001014c4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1014c4:	6a 00                	push   $0x0
  pushl $159
  1014c6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  1014cb:	e9 d0 f8 ff ff       	jmp    100da0 <alltraps>

001014d0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1014d0:	6a 00                	push   $0x0
  pushl $160
  1014d2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  1014d7:	e9 c4 f8 ff ff       	jmp    100da0 <alltraps>

001014dc <vector161>:
.globl vector161
vector161:
  pushl $0
  1014dc:	6a 00                	push   $0x0
  pushl $161
  1014de:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  1014e3:	e9 b8 f8 ff ff       	jmp    100da0 <alltraps>

001014e8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1014e8:	6a 00                	push   $0x0
  pushl $162
  1014ea:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  1014ef:	e9 ac f8 ff ff       	jmp    100da0 <alltraps>

001014f4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1014f4:	6a 00                	push   $0x0
  pushl $163
  1014f6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  1014fb:	e9 a0 f8 ff ff       	jmp    100da0 <alltraps>

00101500 <vector164>:
.globl vector164
vector164:
  pushl $0
  101500:	6a 00                	push   $0x0
  pushl $164
  101502:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  101507:	e9 94 f8 ff ff       	jmp    100da0 <alltraps>

0010150c <vector165>:
.globl vector165
vector165:
  pushl $0
  10150c:	6a 00                	push   $0x0
  pushl $165
  10150e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  101513:	e9 88 f8 ff ff       	jmp    100da0 <alltraps>

00101518 <vector166>:
.globl vector166
vector166:
  pushl $0
  101518:	6a 00                	push   $0x0
  pushl $166
  10151a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  10151f:	e9 7c f8 ff ff       	jmp    100da0 <alltraps>

00101524 <vector167>:
.globl vector167
vector167:
  pushl $0
  101524:	6a 00                	push   $0x0
  pushl $167
  101526:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  10152b:	e9 70 f8 ff ff       	jmp    100da0 <alltraps>

00101530 <vector168>:
.globl vector168
vector168:
  pushl $0
  101530:	6a 00                	push   $0x0
  pushl $168
  101532:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101537:	e9 64 f8 ff ff       	jmp    100da0 <alltraps>

0010153c <vector169>:
.globl vector169
vector169:
  pushl $0
  10153c:	6a 00                	push   $0x0
  pushl $169
  10153e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101543:	e9 58 f8 ff ff       	jmp    100da0 <alltraps>

00101548 <vector170>:
.globl vector170
vector170:
  pushl $0
  101548:	6a 00                	push   $0x0
  pushl $170
  10154a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  10154f:	e9 4c f8 ff ff       	jmp    100da0 <alltraps>

00101554 <vector171>:
.globl vector171
vector171:
  pushl $0
  101554:	6a 00                	push   $0x0
  pushl $171
  101556:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  10155b:	e9 40 f8 ff ff       	jmp    100da0 <alltraps>

00101560 <vector172>:
.globl vector172
vector172:
  pushl $0
  101560:	6a 00                	push   $0x0
  pushl $172
  101562:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101567:	e9 34 f8 ff ff       	jmp    100da0 <alltraps>

0010156c <vector173>:
.globl vector173
vector173:
  pushl $0
  10156c:	6a 00                	push   $0x0
  pushl $173
  10156e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101573:	e9 28 f8 ff ff       	jmp    100da0 <alltraps>

00101578 <vector174>:
.globl vector174
vector174:
  pushl $0
  101578:	6a 00                	push   $0x0
  pushl $174
  10157a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  10157f:	e9 1c f8 ff ff       	jmp    100da0 <alltraps>

00101584 <vector175>:
.globl vector175
vector175:
  pushl $0
  101584:	6a 00                	push   $0x0
  pushl $175
  101586:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  10158b:	e9 10 f8 ff ff       	jmp    100da0 <alltraps>

00101590 <vector176>:
.globl vector176
vector176:
  pushl $0
  101590:	6a 00                	push   $0x0
  pushl $176
  101592:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  101597:	e9 04 f8 ff ff       	jmp    100da0 <alltraps>

0010159c <vector177>:
.globl vector177
vector177:
  pushl $0
  10159c:	6a 00                	push   $0x0
  pushl $177
  10159e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  1015a3:	e9 f8 f7 ff ff       	jmp    100da0 <alltraps>

001015a8 <vector178>:
.globl vector178
vector178:
  pushl $0
  1015a8:	6a 00                	push   $0x0
  pushl $178
  1015aa:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  1015af:	e9 ec f7 ff ff       	jmp    100da0 <alltraps>

001015b4 <vector179>:
.globl vector179
vector179:
  pushl $0
  1015b4:	6a 00                	push   $0x0
  pushl $179
  1015b6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  1015bb:	e9 e0 f7 ff ff       	jmp    100da0 <alltraps>

001015c0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1015c0:	6a 00                	push   $0x0
  pushl $180
  1015c2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  1015c7:	e9 d4 f7 ff ff       	jmp    100da0 <alltraps>

001015cc <vector181>:
.globl vector181
vector181:
  pushl $0
  1015cc:	6a 00                	push   $0x0
  pushl $181
  1015ce:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  1015d3:	e9 c8 f7 ff ff       	jmp    100da0 <alltraps>

001015d8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1015d8:	6a 00                	push   $0x0
  pushl $182
  1015da:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  1015df:	e9 bc f7 ff ff       	jmp    100da0 <alltraps>

001015e4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1015e4:	6a 00                	push   $0x0
  pushl $183
  1015e6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  1015eb:	e9 b0 f7 ff ff       	jmp    100da0 <alltraps>

001015f0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1015f0:	6a 00                	push   $0x0
  pushl $184
  1015f2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  1015f7:	e9 a4 f7 ff ff       	jmp    100da0 <alltraps>

001015fc <vector185>:
.globl vector185
vector185:
  pushl $0
  1015fc:	6a 00                	push   $0x0
  pushl $185
  1015fe:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  101603:	e9 98 f7 ff ff       	jmp    100da0 <alltraps>

00101608 <vector186>:
.globl vector186
vector186:
  pushl $0
  101608:	6a 00                	push   $0x0
  pushl $186
  10160a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  10160f:	e9 8c f7 ff ff       	jmp    100da0 <alltraps>

00101614 <vector187>:
.globl vector187
vector187:
  pushl $0
  101614:	6a 00                	push   $0x0
  pushl $187
  101616:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  10161b:	e9 80 f7 ff ff       	jmp    100da0 <alltraps>

00101620 <vector188>:
.globl vector188
vector188:
  pushl $0
  101620:	6a 00                	push   $0x0
  pushl $188
  101622:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101627:	e9 74 f7 ff ff       	jmp    100da0 <alltraps>

0010162c <vector189>:
.globl vector189
vector189:
  pushl $0
  10162c:	6a 00                	push   $0x0
  pushl $189
  10162e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101633:	e9 68 f7 ff ff       	jmp    100da0 <alltraps>

00101638 <vector190>:
.globl vector190
vector190:
  pushl $0
  101638:	6a 00                	push   $0x0
  pushl $190
  10163a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  10163f:	e9 5c f7 ff ff       	jmp    100da0 <alltraps>

00101644 <vector191>:
.globl vector191
vector191:
  pushl $0
  101644:	6a 00                	push   $0x0
  pushl $191
  101646:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  10164b:	e9 50 f7 ff ff       	jmp    100da0 <alltraps>

00101650 <vector192>:
.globl vector192
vector192:
  pushl $0
  101650:	6a 00                	push   $0x0
  pushl $192
  101652:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101657:	e9 44 f7 ff ff       	jmp    100da0 <alltraps>

0010165c <vector193>:
.globl vector193
vector193:
  pushl $0
  10165c:	6a 00                	push   $0x0
  pushl $193
  10165e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101663:	e9 38 f7 ff ff       	jmp    100da0 <alltraps>

00101668 <vector194>:
.globl vector194
vector194:
  pushl $0
  101668:	6a 00                	push   $0x0
  pushl $194
  10166a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  10166f:	e9 2c f7 ff ff       	jmp    100da0 <alltraps>

00101674 <vector195>:
.globl vector195
vector195:
  pushl $0
  101674:	6a 00                	push   $0x0
  pushl $195
  101676:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  10167b:	e9 20 f7 ff ff       	jmp    100da0 <alltraps>

00101680 <vector196>:
.globl vector196
vector196:
  pushl $0
  101680:	6a 00                	push   $0x0
  pushl $196
  101682:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  101687:	e9 14 f7 ff ff       	jmp    100da0 <alltraps>

0010168c <vector197>:
.globl vector197
vector197:
  pushl $0
  10168c:	6a 00                	push   $0x0
  pushl $197
  10168e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  101693:	e9 08 f7 ff ff       	jmp    100da0 <alltraps>

00101698 <vector198>:
.globl vector198
vector198:
  pushl $0
  101698:	6a 00                	push   $0x0
  pushl $198
  10169a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  10169f:	e9 fc f6 ff ff       	jmp    100da0 <alltraps>

001016a4 <vector199>:
.globl vector199
vector199:
  pushl $0
  1016a4:	6a 00                	push   $0x0
  pushl $199
  1016a6:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  1016ab:	e9 f0 f6 ff ff       	jmp    100da0 <alltraps>

001016b0 <vector200>:
.globl vector200
vector200:
  pushl $0
  1016b0:	6a 00                	push   $0x0
  pushl $200
  1016b2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  1016b7:	e9 e4 f6 ff ff       	jmp    100da0 <alltraps>

001016bc <vector201>:
.globl vector201
vector201:
  pushl $0
  1016bc:	6a 00                	push   $0x0
  pushl $201
  1016be:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  1016c3:	e9 d8 f6 ff ff       	jmp    100da0 <alltraps>

001016c8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1016c8:	6a 00                	push   $0x0
  pushl $202
  1016ca:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  1016cf:	e9 cc f6 ff ff       	jmp    100da0 <alltraps>

001016d4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1016d4:	6a 00                	push   $0x0
  pushl $203
  1016d6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  1016db:	e9 c0 f6 ff ff       	jmp    100da0 <alltraps>

001016e0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1016e0:	6a 00                	push   $0x0
  pushl $204
  1016e2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  1016e7:	e9 b4 f6 ff ff       	jmp    100da0 <alltraps>

001016ec <vector205>:
.globl vector205
vector205:
  pushl $0
  1016ec:	6a 00                	push   $0x0
  pushl $205
  1016ee:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  1016f3:	e9 a8 f6 ff ff       	jmp    100da0 <alltraps>

001016f8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1016f8:	6a 00                	push   $0x0
  pushl $206
  1016fa:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  1016ff:	e9 9c f6 ff ff       	jmp    100da0 <alltraps>

00101704 <vector207>:
.globl vector207
vector207:
  pushl $0
  101704:	6a 00                	push   $0x0
  pushl $207
  101706:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  10170b:	e9 90 f6 ff ff       	jmp    100da0 <alltraps>

00101710 <vector208>:
.globl vector208
vector208:
  pushl $0
  101710:	6a 00                	push   $0x0
  pushl $208
  101712:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  101717:	e9 84 f6 ff ff       	jmp    100da0 <alltraps>

0010171c <vector209>:
.globl vector209
vector209:
  pushl $0
  10171c:	6a 00                	push   $0x0
  pushl $209
  10171e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101723:	e9 78 f6 ff ff       	jmp    100da0 <alltraps>

00101728 <vector210>:
.globl vector210
vector210:
  pushl $0
  101728:	6a 00                	push   $0x0
  pushl $210
  10172a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  10172f:	e9 6c f6 ff ff       	jmp    100da0 <alltraps>

00101734 <vector211>:
.globl vector211
vector211:
  pushl $0
  101734:	6a 00                	push   $0x0
  pushl $211
  101736:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  10173b:	e9 60 f6 ff ff       	jmp    100da0 <alltraps>

00101740 <vector212>:
.globl vector212
vector212:
  pushl $0
  101740:	6a 00                	push   $0x0
  pushl $212
  101742:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101747:	e9 54 f6 ff ff       	jmp    100da0 <alltraps>

0010174c <vector213>:
.globl vector213
vector213:
  pushl $0
  10174c:	6a 00                	push   $0x0
  pushl $213
  10174e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101753:	e9 48 f6 ff ff       	jmp    100da0 <alltraps>

00101758 <vector214>:
.globl vector214
vector214:
  pushl $0
  101758:	6a 00                	push   $0x0
  pushl $214
  10175a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  10175f:	e9 3c f6 ff ff       	jmp    100da0 <alltraps>

00101764 <vector215>:
.globl vector215
vector215:
  pushl $0
  101764:	6a 00                	push   $0x0
  pushl $215
  101766:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  10176b:	e9 30 f6 ff ff       	jmp    100da0 <alltraps>

00101770 <vector216>:
.globl vector216
vector216:
  pushl $0
  101770:	6a 00                	push   $0x0
  pushl $216
  101772:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101777:	e9 24 f6 ff ff       	jmp    100da0 <alltraps>

0010177c <vector217>:
.globl vector217
vector217:
  pushl $0
  10177c:	6a 00                	push   $0x0
  pushl $217
  10177e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  101783:	e9 18 f6 ff ff       	jmp    100da0 <alltraps>

00101788 <vector218>:
.globl vector218
vector218:
  pushl $0
  101788:	6a 00                	push   $0x0
  pushl $218
  10178a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  10178f:	e9 0c f6 ff ff       	jmp    100da0 <alltraps>

00101794 <vector219>:
.globl vector219
vector219:
  pushl $0
  101794:	6a 00                	push   $0x0
  pushl $219
  101796:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  10179b:	e9 00 f6 ff ff       	jmp    100da0 <alltraps>

001017a0 <vector220>:
.globl vector220
vector220:
  pushl $0
  1017a0:	6a 00                	push   $0x0
  pushl $220
  1017a2:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  1017a7:	e9 f4 f5 ff ff       	jmp    100da0 <alltraps>

001017ac <vector221>:
.globl vector221
vector221:
  pushl $0
  1017ac:	6a 00                	push   $0x0
  pushl $221
  1017ae:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  1017b3:	e9 e8 f5 ff ff       	jmp    100da0 <alltraps>

001017b8 <vector222>:
.globl vector222
vector222:
  pushl $0
  1017b8:	6a 00                	push   $0x0
  pushl $222
  1017ba:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  1017bf:	e9 dc f5 ff ff       	jmp    100da0 <alltraps>

001017c4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1017c4:	6a 00                	push   $0x0
  pushl $223
  1017c6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  1017cb:	e9 d0 f5 ff ff       	jmp    100da0 <alltraps>

001017d0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1017d0:	6a 00                	push   $0x0
  pushl $224
  1017d2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  1017d7:	e9 c4 f5 ff ff       	jmp    100da0 <alltraps>

001017dc <vector225>:
.globl vector225
vector225:
  pushl $0
  1017dc:	6a 00                	push   $0x0
  pushl $225
  1017de:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  1017e3:	e9 b8 f5 ff ff       	jmp    100da0 <alltraps>

001017e8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1017e8:	6a 00                	push   $0x0
  pushl $226
  1017ea:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  1017ef:	e9 ac f5 ff ff       	jmp    100da0 <alltraps>

001017f4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1017f4:	6a 00                	push   $0x0
  pushl $227
  1017f6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  1017fb:	e9 a0 f5 ff ff       	jmp    100da0 <alltraps>

00101800 <vector228>:
.globl vector228
vector228:
  pushl $0
  101800:	6a 00                	push   $0x0
  pushl $228
  101802:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  101807:	e9 94 f5 ff ff       	jmp    100da0 <alltraps>

0010180c <vector229>:
.globl vector229
vector229:
  pushl $0
  10180c:	6a 00                	push   $0x0
  pushl $229
  10180e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  101813:	e9 88 f5 ff ff       	jmp    100da0 <alltraps>

00101818 <vector230>:
.globl vector230
vector230:
  pushl $0
  101818:	6a 00                	push   $0x0
  pushl $230
  10181a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  10181f:	e9 7c f5 ff ff       	jmp    100da0 <alltraps>

00101824 <vector231>:
.globl vector231
vector231:
  pushl $0
  101824:	6a 00                	push   $0x0
  pushl $231
  101826:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  10182b:	e9 70 f5 ff ff       	jmp    100da0 <alltraps>

00101830 <vector232>:
.globl vector232
vector232:
  pushl $0
  101830:	6a 00                	push   $0x0
  pushl $232
  101832:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101837:	e9 64 f5 ff ff       	jmp    100da0 <alltraps>

0010183c <vector233>:
.globl vector233
vector233:
  pushl $0
  10183c:	6a 00                	push   $0x0
  pushl $233
  10183e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101843:	e9 58 f5 ff ff       	jmp    100da0 <alltraps>

00101848 <vector234>:
.globl vector234
vector234:
  pushl $0
  101848:	6a 00                	push   $0x0
  pushl $234
  10184a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  10184f:	e9 4c f5 ff ff       	jmp    100da0 <alltraps>

00101854 <vector235>:
.globl vector235
vector235:
  pushl $0
  101854:	6a 00                	push   $0x0
  pushl $235
  101856:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  10185b:	e9 40 f5 ff ff       	jmp    100da0 <alltraps>

00101860 <vector236>:
.globl vector236
vector236:
  pushl $0
  101860:	6a 00                	push   $0x0
  pushl $236
  101862:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101867:	e9 34 f5 ff ff       	jmp    100da0 <alltraps>

0010186c <vector237>:
.globl vector237
vector237:
  pushl $0
  10186c:	6a 00                	push   $0x0
  pushl $237
  10186e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101873:	e9 28 f5 ff ff       	jmp    100da0 <alltraps>

00101878 <vector238>:
.globl vector238
vector238:
  pushl $0
  101878:	6a 00                	push   $0x0
  pushl $238
  10187a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  10187f:	e9 1c f5 ff ff       	jmp    100da0 <alltraps>

00101884 <vector239>:
.globl vector239
vector239:
  pushl $0
  101884:	6a 00                	push   $0x0
  pushl $239
  101886:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  10188b:	e9 10 f5 ff ff       	jmp    100da0 <alltraps>

00101890 <vector240>:
.globl vector240
vector240:
  pushl $0
  101890:	6a 00                	push   $0x0
  pushl $240
  101892:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  101897:	e9 04 f5 ff ff       	jmp    100da0 <alltraps>

0010189c <vector241>:
.globl vector241
vector241:
  pushl $0
  10189c:	6a 00                	push   $0x0
  pushl $241
  10189e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  1018a3:	e9 f8 f4 ff ff       	jmp    100da0 <alltraps>

001018a8 <vector242>:
.globl vector242
vector242:
  pushl $0
  1018a8:	6a 00                	push   $0x0
  pushl $242
  1018aa:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  1018af:	e9 ec f4 ff ff       	jmp    100da0 <alltraps>

001018b4 <vector243>:
.globl vector243
vector243:
  pushl $0
  1018b4:	6a 00                	push   $0x0
  pushl $243
  1018b6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  1018bb:	e9 e0 f4 ff ff       	jmp    100da0 <alltraps>

001018c0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1018c0:	6a 00                	push   $0x0
  pushl $244
  1018c2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  1018c7:	e9 d4 f4 ff ff       	jmp    100da0 <alltraps>

001018cc <vector245>:
.globl vector245
vector245:
  pushl $0
  1018cc:	6a 00                	push   $0x0
  pushl $245
  1018ce:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  1018d3:	e9 c8 f4 ff ff       	jmp    100da0 <alltraps>

001018d8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1018d8:	6a 00                	push   $0x0
  pushl $246
  1018da:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  1018df:	e9 bc f4 ff ff       	jmp    100da0 <alltraps>

001018e4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1018e4:	6a 00                	push   $0x0
  pushl $247
  1018e6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  1018eb:	e9 b0 f4 ff ff       	jmp    100da0 <alltraps>

001018f0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1018f0:	6a 00                	push   $0x0
  pushl $248
  1018f2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  1018f7:	e9 a4 f4 ff ff       	jmp    100da0 <alltraps>

001018fc <vector249>:
.globl vector249
vector249:
  pushl $0
  1018fc:	6a 00                	push   $0x0
  pushl $249
  1018fe:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  101903:	e9 98 f4 ff ff       	jmp    100da0 <alltraps>

00101908 <vector250>:
.globl vector250
vector250:
  pushl $0
  101908:	6a 00                	push   $0x0
  pushl $250
  10190a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  10190f:	e9 8c f4 ff ff       	jmp    100da0 <alltraps>

00101914 <vector251>:
.globl vector251
vector251:
  pushl $0
  101914:	6a 00                	push   $0x0
  pushl $251
  101916:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  10191b:	e9 80 f4 ff ff       	jmp    100da0 <alltraps>

00101920 <vector252>:
.globl vector252
vector252:
  pushl $0
  101920:	6a 00                	push   $0x0
  pushl $252
  101922:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101927:	e9 74 f4 ff ff       	jmp    100da0 <alltraps>

0010192c <vector253>:
.globl vector253
vector253:
  pushl $0
  10192c:	6a 00                	push   $0x0
  pushl $253
  10192e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101933:	e9 68 f4 ff ff       	jmp    100da0 <alltraps>

00101938 <vector254>:
.globl vector254
vector254:
  pushl $0
  101938:	6a 00                	push   $0x0
  pushl $254
  10193a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  10193f:	e9 5c f4 ff ff       	jmp    100da0 <alltraps>

00101944 <vector255>:
.globl vector255
vector255:
  pushl $0
  101944:	6a 00                	push   $0x0
  pushl $255
  101946:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10194b:	e9 50 f4 ff ff       	jmp    100da0 <alltraps>

00101950 <mousewait_send>:
#include "traps.h"

// Wait until the mouse controller is ready for us to send a packet
void 
mousewait_send(void) 
{
  101950:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101954:	ba 64 00 00 00       	mov    $0x64,%edx
  101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101960:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x02) != 0);
  101961:	a8 02                	test   $0x2,%al
  101963:	75 fb                	jne    101960 <mousewait_send+0x10>
    return;
}
  101965:	c3                   	ret    
  101966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10196d:	8d 76 00             	lea    0x0(%esi),%esi

00101970 <mousewait_recv>:

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
  101970:	f3 0f 1e fb          	endbr32 
  101974:	ba 64 00 00 00       	mov    $0x64,%edx
  101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101980:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x01) == 0);
  101981:	a8 01                	test   $0x1,%al
  101983:	74 fb                	je     101980 <mousewait_recv+0x10>
    return;
}
  101985:	c3                   	ret    
  101986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10198d:	8d 76 00             	lea    0x0(%esi),%esi

00101990 <mousecmd>:

// Send a one-byte command to the mouse controller, and wait for it
// to be properly acknowledged
void 
mousecmd(uchar cmd) 
{
  101990:	f3 0f 1e fb          	endbr32 
  101994:	55                   	push   %ebp
  101995:	ba 64 00 00 00       	mov    $0x64,%edx
  10199a:	89 e5                	mov    %esp,%ebp
  10199c:	83 ec 08             	sub    $0x8,%esp
  10199f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1019a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1019a8:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x02) != 0);
  1019a9:	a8 02                	test   $0x2,%al
  1019ab:	75 fb                	jne    1019a8 <mousecmd+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019ad:	b8 d4 ff ff ff       	mov    $0xffffffd4,%eax
  1019b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019b3:	ba 64 00 00 00       	mov    $0x64,%edx
  1019b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1019bf:	90                   	nop
  1019c0:	ec                   	in     (%dx),%al
  1019c1:	a8 02                	test   $0x2,%al
  1019c3:	75 fb                	jne    1019c0 <mousecmd+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1019c5:	ba 60 00 00 00       	mov    $0x60,%edx
  1019ca:	89 c8                	mov    %ecx,%eax
  1019cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1019cd:	ba 64 00 00 00       	mov    $0x64,%edx
  1019d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1019d8:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x01) == 0);
  1019d9:	a8 01                	test   $0x1,%al
  1019db:	74 fb                	je     1019d8 <mousecmd+0x48>
  1019dd:	ba 60 00 00 00       	mov    $0x60,%edx
  1019e2:	ec                   	in     (%dx),%al
    outb(MSSTATP, PS2MS); // send 0xD4 to control port to address the mouse
    mousewait_send();
    outb(MSDATAP, cmd);  // send the command to the data port
    mousewait_recv();
    uchar ack = inb(MSDATAP); // read the acknowledgement from the data port
    if (ack != MSACK)
  1019e3:	3c fa                	cmp    $0xfa,%al
  1019e5:	75 02                	jne    1019e9 <mousecmd+0x59>
        panic("Mouse command not acknowledged");
    return;
}
  1019e7:	c9                   	leave  
  1019e8:	c3                   	ret    
        panic("Mouse command not acknowledged");
  1019e9:	83 ec 0c             	sub    $0xc,%esp
  1019ec:	68 4c 1d 10 00       	push   $0x101d4c
  1019f1:	e8 aa e8 ff ff       	call   1002a0 <panic>
  1019f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1019fd:	8d 76 00             	lea    0x0(%esi),%esi

00101a00 <mouseinit>:

void
mouseinit(void)
{
  101a00:	f3 0f 1e fb          	endbr32 
  101a04:	55                   	push   %ebp
  101a05:	ba 64 00 00 00       	mov    $0x64,%edx
  101a0a:	89 e5                	mov    %esp,%ebp
  101a0c:	83 ec 08             	sub    $0x8,%esp
  101a0f:	90                   	nop
  101a10:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x02) != 0);
  101a11:	a8 02                	test   $0x2,%al
  101a13:	75 fb                	jne    101a10 <mouseinit+0x10>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a15:	b8 a8 ff ff ff       	mov    $0xffffffa8,%eax
  101a1a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a1b:	ba 64 00 00 00       	mov    $0x64,%edx
  101a20:	ec                   	in     (%dx),%al
  101a21:	a8 02                	test   $0x2,%al
  101a23:	75 fb                	jne    101a20 <mouseinit+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a25:	b8 20 00 00 00       	mov    $0x20,%eax
  101a2a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a2b:	ba 64 00 00 00       	mov    $0x64,%edx
  101a30:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x01) == 0);
  101a31:	a8 01                	test   $0x1,%al
  101a33:	74 fb                	je     101a30 <mouseinit+0x30>
  101a35:	ba 60 00 00 00       	mov    $0x60,%edx
  101a3a:	ec                   	in     (%dx),%al
    outb(MSSTATP, MSEN);// Step 2: Send 0xA8 to the control port to enable the mouse
    mousewait_send();// Step 3: Modify the "Compaq Status Byte" for mouse interrupts
    outb(MSSTATP, 0x20); // Select Compaq Status byte
    mousewait_recv();
    uchar status = inb(MSDATAP); // Read the status byte
    status |= 0x02; // Set the 2nd bit to 1 for interrupts
  101a3b:	83 c8 02             	or     $0x2,%eax
  101a3e:	ba 64 00 00 00       	mov    $0x64,%edx
  101a43:	89 c1                	mov    %eax,%ecx
mousewait_send(void) 
  101a45:	8d 76 00             	lea    0x0(%esi),%esi
  101a48:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x02) != 0);
  101a49:	a8 02                	test   $0x2,%al
  101a4b:	75 fb                	jne    101a48 <mouseinit+0x48>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a4d:	b8 60 00 00 00       	mov    $0x60,%eax
  101a52:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101a53:	ba 64 00 00 00       	mov    $0x64,%edx
  101a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101a5f:	90                   	nop
  101a60:	ec                   	in     (%dx),%al
  101a61:	a8 02                	test   $0x2,%al
  101a63:	75 fb                	jne    101a60 <mouseinit+0x60>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101a65:	ba 60 00 00 00       	mov    $0x60,%edx
  101a6a:	89 c8                	mov    %ecx,%eax
  101a6c:	ee                   	out    %al,(%dx)
    mousewait_send();
    outb(MSSTATP, MSDATAP); // Tell the controller about the modified status byte
    mousewait_send();
    outb(MSDATAP, status); // Send the modified status byte
    mousecmd(0xF6);// Step 4: Use mousecmd function to send 0xF6 to select "default settings"
  101a6d:	83 ec 0c             	sub    $0xc,%esp
  101a70:	68 f6 00 00 00       	push   $0xf6
  101a75:	e8 16 ff ff ff       	call   101990 <mousecmd>
    mousecmd(0xF4);// Step 5: Use mousecmd function to send 0xF4 to activate and start sending interrupts
  101a7a:	c7 04 24 f4 00 00 00 	movl   $0xf4,(%esp)
  101a81:	e8 0a ff ff ff       	call   101990 <mousecmd>
    ioapicenable(IRQ_MOUSE, 0);// Step 6: Enable mouse interrupt (IRQ12) on CPU 0 using ioapicenable
  101a86:	58                   	pop    %eax
  101a87:	5a                   	pop    %edx
  101a88:	6a 00                	push   $0x0
  101a8a:	6a 0c                	push   $0xc
  101a8c:	e8 6f ea ff ff       	call   100500 <ioapicenable>
    cprintf("Mouse has been initialized");
  101a91:	c7 04 24 6b 1d 10 00 	movl   $0x101d6b,(%esp)
  101a98:	e8 53 e6 ff ff       	call   1000f0 <cprintf>
    return;
  101a9d:	83 c4 10             	add    $0x10,%esp
}
  101aa0:	c9                   	leave  
  101aa1:	c3                   	ret    
  101aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101ab0 <mouseintr>:

void
mouseintr(void)
{
  101ab0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101ab4:	ba 64 00 00 00       	mov    $0x64,%edx
  101ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101ac0:	ec                   	in     (%dx),%al
    while ((inb(MSSTATP) & 0x01) == 0);
  101ac1:	a8 01                	test   $0x1,%al
  101ac3:	74 fb                	je     101ac0 <mouseintr+0x10>
  101ac5:	ec                   	in     (%dx),%al
    // read 3 bytes from the PS/2 controller buffer
    mousewait_recv();
    uchar status = inb(MSSTATP);
    if ((status & 0x01) == 0)
  101ac6:	a8 01                	test   $0x1,%al
  101ac8:	74 5e                	je     101b28 <mouseintr+0x78>
{
  101aca:	55                   	push   %ebp
  101acb:	ba 60 00 00 00       	mov    $0x60,%edx
  101ad0:	89 e5                	mov    %esp,%ebp
  101ad2:	56                   	push   %esi
  101ad3:	53                   	push   %ebx
  101ad4:	ec                   	in     (%dx),%al
  101ad5:	89 c3                	mov    %eax,%ebx
  101ad7:	ec                   	in     (%dx),%al
  101ad8:	ec                   	in     (%dx),%al
        return;
    uchar data[3];
    data[0] = inb(MSDATAP);
    data[1] = inb(MSDATAP);
    data[2] = inb(MSDATAP);
    if ((data[0] & (1 << 0)) || (data[0] & (1 << 1)) || (data[0] & (1 << 2)))
  101ad9:	89 de                	mov    %ebx,%esi
  101adb:	83 e6 04             	and    $0x4,%esi
  101ade:	f6 c3 07             	test   $0x7,%bl
  101ae1:	74 10                	je     101af3 <mouseintr+0x43>
    {
        if (data[0] & (1 << 0))
  101ae3:	f6 c3 01             	test   $0x1,%bl
  101ae6:	75 78                	jne    101b60 <mouseintr+0xb0>
            cprintf("LEFT\n");
        if (data[0] & (1 << 1))
  101ae8:	83 e3 02             	and    $0x2,%ebx
  101aeb:	75 5b                	jne    101b48 <mouseintr+0x98>
            cprintf("RIGHT\n");
        if (data[0] & (1 << 2))
  101aed:	89 f0                	mov    %esi,%eax
  101aef:	84 c0                	test   %al,%al
  101af1:	75 3d                	jne    101b30 <mouseintr+0x80>
  101af3:	ba 64 00 00 00       	mov    $0x64,%edx
  101af8:	ec                   	in     (%dx),%al
            cprintf("MID\n");
    }
    // Drain the controller's buffer
    while ((inb(MSSTATP) & 0x01) != 0)
  101af9:	a8 01                	test   $0x1,%al
  101afb:	74 1d                	je     101b1a <mouseintr+0x6a>
  101afd:	bb 60 00 00 00       	mov    $0x60,%ebx
  101b02:	b9 64 00 00 00       	mov    $0x64,%ecx
  101b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101b0e:	66 90                	xchg   %ax,%ax
  101b10:	89 da                	mov    %ebx,%edx
  101b12:	ec                   	in     (%dx),%al
  101b13:	89 ca                	mov    %ecx,%edx
  101b15:	ec                   	in     (%dx),%al
  101b16:	a8 01                	test   $0x1,%al
  101b18:	75 f6                	jne    101b10 <mouseintr+0x60>
        inb(MSDATAP);
    return;
  101b1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101b1d:	5b                   	pop    %ebx
  101b1e:	5e                   	pop    %esi
  101b1f:	5d                   	pop    %ebp
  101b20:	c3                   	ret    
  101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101b28:	c3                   	ret    
  101b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cprintf("MID\n");
  101b30:	83 ec 0c             	sub    $0xc,%esp
  101b33:	68 93 1d 10 00       	push   $0x101d93
  101b38:	e8 b3 e5 ff ff       	call   1000f0 <cprintf>
  101b3d:	83 c4 10             	add    $0x10,%esp
  101b40:	eb b1                	jmp    101af3 <mouseintr+0x43>
  101b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("RIGHT\n");
  101b48:	83 ec 0c             	sub    $0xc,%esp
  101b4b:	68 8c 1d 10 00       	push   $0x101d8c
  101b50:	e8 9b e5 ff ff       	call   1000f0 <cprintf>
  101b55:	83 c4 10             	add    $0x10,%esp
  101b58:	eb 93                	jmp    101aed <mouseintr+0x3d>
  101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("LEFT\n");
  101b60:	83 ec 0c             	sub    $0xc,%esp
  101b63:	68 86 1d 10 00       	push   $0x101d86
  101b68:	e8 83 e5 ff ff       	call   1000f0 <cprintf>
  101b6d:	83 c4 10             	add    $0x10,%esp
  101b70:	e9 73 ff ff ff       	jmp    101ae8 <mouseintr+0x38>
