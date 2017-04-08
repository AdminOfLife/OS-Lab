
game.bin:     file format elf32-i386


Disassembly of section .text:

08000000 <game>:
int game() {
 8000000:	55                   	push   %ebp
 8000001:	89 e5                	mov    %esp,%ebp
	while (1);
 8000003:	eb fe                	jmp    8000003 <game+0x3>
 8000005:	66 90                	xchg   %ax,%ax
 8000007:	90                   	nop

08000008 <abort>:
#include <include/stdio.h>
#include <include/x86.h>

int abort(const char* filename, int line) {
 8000008:	55                   	push   %ebp
 8000009:	89 e5                	mov    %esp,%ebp
 800000b:	83 ec 18             	sub    $0x18,%esp
}

static __inline void
cli(void)
{
	__asm __volatile("cli");
 800000e:	fa                   	cli    
	cli();
	printk("%s,%d: Aborted.\n", filename, line);
 800000f:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000012:	89 44 24 08          	mov    %eax,0x8(%esp)
 8000016:	8b 45 08             	mov    0x8(%ebp),%eax
 8000019:	89 44 24 04          	mov    %eax,0x4(%esp)
 800001d:	c7 04 24 00 10 00 08 	movl   $0x8001000,(%esp)
 8000024:	e8 d3 01 00 00       	call   80001fc <printk>
	while(1);
 8000029:	eb fe                	jmp    8000029 <abort+0x21>
 800002b:	90                   	nop

0800002c <serial_output_test>:
	while(!is_serial_idle());
	outb(PORT, a);
}
*/

void serial_output_test(){
 800002c:	55                   	push   %ebp
 800002d:	89 e5                	mov    %esp,%ebp
 800002f:	83 ec 40             	sub    $0x40,%esp
 8000032:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
 8000039:	c6 45 fb 41          	movb   $0x41,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
 800003d:	8a 45 fb             	mov    -0x5(%ebp),%al
 8000040:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8000043:	ee                   	out    %al,(%dx)
 8000044:	c7 45 f4 f8 03 00 00 	movl   $0x3f8,-0xc(%ebp)
 800004b:	c6 45 f3 4e          	movb   $0x4e,-0xd(%ebp)
 800004f:	8a 45 f3             	mov    -0xd(%ebp),%al
 8000052:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8000055:	ee                   	out    %al,(%dx)
 8000056:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
 800005d:	c6 45 eb 44          	movb   $0x44,-0x15(%ebp)
 8000061:	8a 45 eb             	mov    -0x15(%ebp),%al
 8000064:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8000067:	ee                   	out    %al,(%dx)
 8000068:	c7 45 e4 f8 03 00 00 	movl   $0x3f8,-0x1c(%ebp)
 800006f:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 8000073:	8a 45 e3             	mov    -0x1d(%ebp),%al
 8000076:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 8000079:	ee                   	out    %al,(%dx)
 800007a:	c7 45 dc f8 03 00 00 	movl   $0x3f8,-0x24(%ebp)
 8000081:	c6 45 db 4f          	movb   $0x4f,-0x25(%ebp)
 8000085:	8a 45 db             	mov    -0x25(%ebp),%al
 8000088:	8b 55 dc             	mov    -0x24(%ebp),%edx
 800008b:	ee                   	out    %al,(%dx)
 800008c:	c7 45 d4 f8 03 00 00 	movl   $0x3f8,-0x2c(%ebp)
 8000093:	c6 45 d3 52          	movb   $0x52,-0x2d(%ebp)
 8000097:	8a 45 d3             	mov    -0x2d(%ebp),%al
 800009a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 800009d:	ee                   	out    %al,(%dx)
 800009e:	c7 45 cc f8 03 00 00 	movl   $0x3f8,-0x34(%ebp)
 80000a5:	c6 45 cb 41          	movb   $0x41,-0x35(%ebp)
 80000a9:	8a 45 cb             	mov    -0x35(%ebp),%al
 80000ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
 80000af:	ee                   	out    %al,(%dx)
	outb(PORT + 0, 'D');
	outb(PORT + 0, 'S');
	outb(PORT + 0, 'O');
	outb(PORT + 0, 'R');
	outb(PORT + 0, 'A');
}
 80000b0:	c9                   	leave  
 80000b1:	c3                   	ret    

080000b2 <delay>:

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
 80000b2:	55                   	push   %ebp
 80000b3:	89 e5                	mov    %esp,%ebp
 80000b5:	83 ec 20             	sub    $0x20,%esp
 80000b8:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
 80000bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80000c2:	89 c2                	mov    %eax,%edx
 80000c4:	ec                   	in     (%dx),%al
 80000c5:	88 45 fb             	mov    %al,-0x5(%ebp)
 80000c8:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%ebp)
 80000cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80000d2:	89 c2                	mov    %eax,%edx
 80000d4:	ec                   	in     (%dx),%al
 80000d5:	88 45 f3             	mov    %al,-0xd(%ebp)
 80000d8:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%ebp)
 80000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80000e2:	89 c2                	mov    %eax,%edx
 80000e4:	ec                   	in     (%dx),%al
 80000e5:	88 45 eb             	mov    %al,-0x15(%ebp)
 80000e8:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%ebp)
 80000ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80000f2:	89 c2                	mov    %eax,%edx
 80000f4:	ec                   	in     (%dx),%al
 80000f5:	88 45 e3             	mov    %al,-0x1d(%ebp)
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
 80000f8:	c9                   	leave  
 80000f9:	c3                   	ret    

080000fa <serial_printc>:
#define COM_LSR_TXRDY	0x20	//   Transmit buffer avail
#define COM_LSR_TSRE	0x40	//   Transmitter off

void
serial_printc(int c)
{
 80000fa:	55                   	push   %ebp
 80000fb:	89 e5                	mov    %esp,%ebp
 80000fd:	83 ec 20             	sub    $0x20,%esp
	int i;

	for (i = 0;
 8000100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8000107:	eb 08                	jmp    8000111 <serial_printc+0x17>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
 8000109:	e8 a4 ff ff ff       	call   80000b2 <delay>
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
 800010e:	ff 45 fc             	incl   -0x4(%ebp)
 8000111:	c7 45 f8 fd 03 00 00 	movl   $0x3fd,-0x8(%ebp)
 8000118:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800011b:	89 c2                	mov    %eax,%edx
 800011d:	ec                   	in     (%dx),%al
 800011e:	88 45 f7             	mov    %al,-0x9(%ebp)
	return data;
 8000121:	8a 45 f7             	mov    -0x9(%ebp),%al
serial_printc(int c)
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
 8000124:	25 ff 00 00 00       	and    $0xff,%eax
 8000129:	83 e0 20             	and    $0x20,%eax
void
serial_printc(int c)
{
	int i;

	for (i = 0;
 800012c:	85 c0                	test   %eax,%eax
 800012e:	75 09                	jne    8000139 <serial_printc+0x3f>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
 8000130:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
 8000137:	7e d0                	jle    8000109 <serial_printc+0xf>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
 8000139:	8b 45 08             	mov    0x8(%ebp),%eax
 800013c:	25 ff 00 00 00       	and    $0xff,%eax
 8000141:	c7 45 f0 f8 03 00 00 	movl   $0x3f8,-0x10(%ebp)
 8000148:	88 45 ef             	mov    %al,-0x11(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
 800014b:	8a 45 ef             	mov    -0x11(%ebp),%al
 800014e:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8000151:	ee                   	out    %al,(%dx)
}
 8000152:	c9                   	leave  
 8000153:	c3                   	ret    

08000154 <init_serial>:

void
init_serial(void) {
 8000154:	55                   	push   %ebp
 8000155:	89 e5                	mov    %esp,%ebp
 8000157:	83 ec 50             	sub    $0x50,%esp
 800015a:	c7 45 fc fa 03 00 00 	movl   $0x3fa,-0x4(%ebp)
 8000161:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
 8000165:	8a 45 fb             	mov    -0x5(%ebp),%al
 8000168:	8b 55 fc             	mov    -0x4(%ebp),%edx
 800016b:	ee                   	out    %al,(%dx)
 800016c:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
 8000173:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
 8000177:	8a 45 f3             	mov    -0xd(%ebp),%al
 800017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 800017d:	ee                   	out    %al,(%dx)
 800017e:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
 8000185:	c6 45 eb 0c          	movb   $0xc,-0x15(%ebp)
 8000189:	8a 45 eb             	mov    -0x15(%ebp),%al
 800018c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 800018f:	ee                   	out    %al,(%dx)
 8000190:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
 8000197:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
 800019b:	8a 45 e3             	mov    -0x1d(%ebp),%al
 800019e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 80001a1:	ee                   	out    %al,(%dx)
 80001a2:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
 80001a9:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
 80001ad:	8a 45 db             	mov    -0x25(%ebp),%al
 80001b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
 80001b3:	ee                   	out    %al,(%dx)
 80001b4:	c7 45 d4 fc 03 00 00 	movl   $0x3fc,-0x2c(%ebp)
 80001bb:	c6 45 d3 00          	movb   $0x0,-0x2d(%ebp)
 80001bf:	8a 45 d3             	mov    -0x2d(%ebp),%al
 80001c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 80001c5:	ee                   	out    %al,(%dx)
 80001c6:	c7 45 cc f9 03 00 00 	movl   $0x3f9,-0x34(%ebp)
 80001cd:	c6 45 cb 01          	movb   $0x1,-0x35(%ebp)
 80001d1:	8a 45 cb             	mov    -0x35(%ebp),%al
 80001d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
 80001d7:	ee                   	out    %al,(%dx)
 80001d8:	c7 45 c4 fa 03 00 00 	movl   $0x3fa,-0x3c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
 80001df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 80001e2:	89 c2                	mov    %eax,%edx
 80001e4:	ec                   	in     (%dx),%al
 80001e5:	88 45 c3             	mov    %al,-0x3d(%ebp)
 80001e8:	c7 45 bc f8 03 00 00 	movl   $0x3f8,-0x44(%ebp)
 80001ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
 80001f2:	89 c2                	mov    %eax,%edx
 80001f4:	ec                   	in     (%dx),%al
 80001f5:	88 45 bb             	mov    %al,-0x45(%ebp)

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);
}
 80001f8:	c9                   	leave  
 80001f9:	c3                   	ret    
 80001fa:	66 90                	xchg   %ax,%ax

080001fc <printk>:
void serial_printc(char);

void out_num(unsigned, unsigned, bool);
void out_string(char*);

int printk(const char *fmt, ...) {
 80001fc:	55                   	push   %ebp
 80001fd:	89 e5                	mov    %esp,%ebp
 80001ff:	83 ec 28             	sub    $0x28,%esp
	//char ch = *(unsigned char *)fmt;
	va_list ap;

	va_start(ap, fmt);
 8000202:	8d 45 0c             	lea    0xc(%ebp),%eax
 8000205:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(*fmt){
 8000208:	e9 c2 00 00 00       	jmp    80002cf <printk+0xd3>
		if(*fmt != '%'){
 800020d:	8b 45 08             	mov    0x8(%ebp),%eax
 8000210:	8a 00                	mov    (%eax),%al
 8000212:	3c 25                	cmp    $0x25,%al
 8000214:	74 15                	je     800022b <printk+0x2f>
			serial_printc(*fmt);
 8000216:	8b 45 08             	mov    0x8(%ebp),%eax
 8000219:	8a 00                	mov    (%eax),%al
 800021b:	0f be c0             	movsbl %al,%eax
 800021e:	89 04 24             	mov    %eax,(%esp)
 8000221:	e8 d4 fe ff ff       	call   80000fa <serial_printc>
 8000226:	e9 a1 00 00 00       	jmp    80002cc <printk+0xd0>
		}
		else {
			fmt++;
 800022b:	ff 45 08             	incl   0x8(%ebp)
			switch(*fmt){
 800022e:	8b 45 08             	mov    0x8(%ebp),%eax
 8000231:	8a 00                	mov    (%eax),%al
 8000233:	0f be c0             	movsbl %al,%eax
 8000236:	83 f8 64             	cmp    $0x64,%eax
 8000239:	74 1b                	je     8000256 <printk+0x5a>
 800023b:	83 f8 64             	cmp    $0x64,%eax
 800023e:	7f 0a                	jg     800024a <printk+0x4e>
 8000240:	83 f8 63             	cmp    $0x63,%eax
 8000243:	74 5b                	je     80002a0 <printk+0xa4>
				case 'd': out_num( va_arg(ap, int), 10, 1); break;
				case 'x': out_num( va_arg(ap, unsigned int), 16, 0); break;
				case 'c': serial_printc(va_arg(ap, unsigned int)); break;
				case 's': out_string(va_arg(ap, char*)); break;
				default: break;
 8000245:	e9 82 00 00 00       	jmp    80002cc <printk+0xd0>
		if(*fmt != '%'){
			serial_printc(*fmt);
		}
		else {
			fmt++;
			switch(*fmt){
 800024a:	83 f8 73             	cmp    $0x73,%eax
 800024d:	74 69                	je     80002b8 <printk+0xbc>
 800024f:	83 f8 78             	cmp    $0x78,%eax
 8000252:	74 27                	je     800027b <printk+0x7f>
				case 'd': out_num( va_arg(ap, int), 10, 1); break;
				case 'x': out_num( va_arg(ap, unsigned int), 16, 0); break;
				case 'c': serial_printc(va_arg(ap, unsigned int)); break;
				case 's': out_string(va_arg(ap, char*)); break;
				default: break;
 8000254:	eb 76                	jmp    80002cc <printk+0xd0>
			serial_printc(*fmt);
		}
		else {
			fmt++;
			switch(*fmt){
				case 'd': out_num( va_arg(ap, int), 10, 1); break;
 8000256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8000259:	8d 50 04             	lea    0x4(%eax),%edx
 800025c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 800025f:	8b 00                	mov    (%eax),%eax
 8000261:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8000268:	00 
 8000269:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 8000270:	00 
 8000271:	89 04 24             	mov    %eax,(%esp)
 8000274:	e8 b2 00 00 00       	call   800032b <out_num>
 8000279:	eb 51                	jmp    80002cc <printk+0xd0>
				case 'x': out_num( va_arg(ap, unsigned int), 16, 0); break;
 800027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800027e:	8d 50 04             	lea    0x4(%eax),%edx
 8000281:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8000284:	8b 00                	mov    (%eax),%eax
 8000286:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 800028d:	00 
 800028e:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
 8000295:	00 
 8000296:	89 04 24             	mov    %eax,(%esp)
 8000299:	e8 8d 00 00 00       	call   800032b <out_num>
 800029e:	eb 2c                	jmp    80002cc <printk+0xd0>
				case 'c': serial_printc(va_arg(ap, unsigned int)); break;
 80002a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80002a3:	8d 50 04             	lea    0x4(%eax),%edx
 80002a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 80002a9:	8b 00                	mov    (%eax),%eax
 80002ab:	0f be c0             	movsbl %al,%eax
 80002ae:	89 04 24             	mov    %eax,(%esp)
 80002b1:	e8 44 fe ff ff       	call   80000fa <serial_printc>
 80002b6:	eb 14                	jmp    80002cc <printk+0xd0>
				case 's': out_string(va_arg(ap, char*)); break;
 80002b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80002bb:	8d 50 04             	lea    0x4(%eax),%edx
 80002be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 80002c1:	8b 00                	mov    (%eax),%eax
 80002c3:	89 04 24             	mov    %eax,(%esp)
 80002c6:	e8 9c 00 00 00       	call   8000367 <out_string>
 80002cb:	90                   	nop
				default: break;
			}
		}
		fmt++;
 80002cc:	ff 45 08             	incl   0x8(%ebp)
	//char ch = *(unsigned char *)fmt;
	va_list ap;

	va_start(ap, fmt);

	while(*fmt){
 80002cf:	8b 45 08             	mov    0x8(%ebp),%eax
 80002d2:	8a 00                	mov    (%eax),%al
 80002d4:	84 c0                	test   %al,%al
 80002d6:	0f 85 31 ff ff ff    	jne    800020d <printk+0x11>
		fmt++;
	}

	va_end(ap);

	return 0;
 80002dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80002e1:	c9                   	leave  
 80002e2:	c3                   	ret    

080002e3 <rec_out_num>:

void rec_out_num(unsigned int x, unsigned int base) {
 80002e3:	55                   	push   %ebp
 80002e4:	89 e5                	mov    %esp,%ebp
 80002e6:	83 ec 18             	sub    $0x18,%esp
	if(x >= base){
 80002e9:	8b 45 08             	mov    0x8(%ebp),%eax
 80002ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
 80002ef:	72 1a                	jb     800030b <rec_out_num+0x28>
		rec_out_num(x/base, base);
 80002f1:	8b 45 08             	mov    0x8(%ebp),%eax
 80002f4:	ba 00 00 00 00       	mov    $0x0,%edx
 80002f9:	f7 75 0c             	divl   0xc(%ebp)
 80002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 80002ff:	89 54 24 04          	mov    %edx,0x4(%esp)
 8000303:	89 04 24             	mov    %eax,(%esp)
 8000306:	e8 d8 ff ff ff       	call   80002e3 <rec_out_num>
	}
	serial_printc("0123456789abcdef"[x % base]);
 800030b:	8b 45 08             	mov    0x8(%ebp),%eax
 800030e:	ba 00 00 00 00       	mov    $0x0,%edx
 8000313:	f7 75 0c             	divl   0xc(%ebp)
 8000316:	89 d0                	mov    %edx,%eax
 8000318:	8a 80 11 10 00 08    	mov    0x8001011(%eax),%al
 800031e:	0f be c0             	movsbl %al,%eax
 8000321:	89 04 24             	mov    %eax,(%esp)
 8000324:	e8 d1 fd ff ff       	call   80000fa <serial_printc>
}
 8000329:	c9                   	leave  
 800032a:	c3                   	ret    

0800032b <out_num>:

void out_num(unsigned int x, unsigned int base, bool SIGN) {
 800032b:	55                   	push   %ebp
 800032c:	89 e5                	mov    %esp,%ebp
 800032e:	83 ec 18             	sub    $0x18,%esp
 8000331:	8b 45 10             	mov    0x10(%ebp),%eax
 8000334:	88 45 f4             	mov    %al,-0xc(%ebp)
	if( SIGN && ((int)x) < 0 ){
 8000337:	80 7d f4 00          	cmpb   $0x0,-0xc(%ebp)
 800033b:	74 16                	je     8000353 <out_num+0x28>
 800033d:	8b 45 08             	mov    0x8(%ebp),%eax
 8000340:	85 c0                	test   %eax,%eax
 8000342:	79 0f                	jns    8000353 <out_num+0x28>
		serial_printc('-');
 8000344:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
 800034b:	e8 aa fd ff ff       	call   80000fa <serial_printc>
		x = ~x + 1;
 8000350:	f7 5d 08             	negl   0x8(%ebp)
	}
	rec_out_num(x, base);
 8000353:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000356:	89 44 24 04          	mov    %eax,0x4(%esp)
 800035a:	8b 45 08             	mov    0x8(%ebp),%eax
 800035d:	89 04 24             	mov    %eax,(%esp)
 8000360:	e8 7e ff ff ff       	call   80002e3 <rec_out_num>
}
 8000365:	c9                   	leave  
 8000366:	c3                   	ret    

08000367 <out_string>:

void out_string(char *s) {
 8000367:	55                   	push   %ebp
 8000368:	89 e5                	mov    %esp,%ebp
 800036a:	83 ec 18             	sub    $0x18,%esp
	while(*s){
 800036d:	eb 13                	jmp    8000382 <out_string+0x1b>
		serial_printc(*s);
 800036f:	8b 45 08             	mov    0x8(%ebp),%eax
 8000372:	8a 00                	mov    (%eax),%al
 8000374:	0f be c0             	movsbl %al,%eax
 8000377:	89 04 24             	mov    %eax,(%esp)
 800037a:	e8 7b fd ff ff       	call   80000fa <serial_printc>
		s++;
 800037f:	ff 45 08             	incl   0x8(%ebp)
	}
	rec_out_num(x, base);
}

void out_string(char *s) {
	while(*s){
 8000382:	8b 45 08             	mov    0x8(%ebp),%eax
 8000385:	8a 00                	mov    (%eax),%al
 8000387:	84 c0                	test   %al,%al
 8000389:	75 e4                	jne    800036f <out_string+0x8>
		serial_printc(*s);
		s++;
	}
}
 800038b:	c9                   	leave  
 800038c:	c3                   	ret    
 800038d:	66 90                	xchg   %ax,%ax
 800038f:	90                   	nop

08000390 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
 8000390:	55                   	push   %ebp
 8000391:	89 e5                	mov    %esp,%ebp
 8000393:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
 8000396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 800039d:	eb 06                	jmp    80003a5 <strlen+0x15>
		n++;
 800039f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
 80003a2:	ff 45 08             	incl   0x8(%ebp)
 80003a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80003a8:	8a 00                	mov    (%eax),%al
 80003aa:	84 c0                	test   %al,%al
 80003ac:	75 f1                	jne    800039f <strlen+0xf>
		n++;
	return n;
 80003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80003b1:	c9                   	leave  
 80003b2:	c3                   	ret    

080003b3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
 80003b3:	55                   	push   %ebp
 80003b4:	89 e5                	mov    %esp,%ebp
 80003b6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
 80003b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 80003c0:	eb 09                	jmp    80003cb <strnlen+0x18>
		n++;
 80003c2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
 80003c5:	ff 45 08             	incl   0x8(%ebp)
 80003c8:	ff 4d 0c             	decl   0xc(%ebp)
 80003cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 80003cf:	74 09                	je     80003da <strnlen+0x27>
 80003d1:	8b 45 08             	mov    0x8(%ebp),%eax
 80003d4:	8a 00                	mov    (%eax),%al
 80003d6:	84 c0                	test   %al,%al
 80003d8:	75 e8                	jne    80003c2 <strnlen+0xf>
		n++;
	return n;
 80003da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80003dd:	c9                   	leave  
 80003de:	c3                   	ret    

080003df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
 80003df:	55                   	push   %ebp
 80003e0:	89 e5                	mov    %esp,%ebp
 80003e2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
 80003e5:	8b 45 08             	mov    0x8(%ebp),%eax
 80003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
 80003eb:	90                   	nop
 80003ec:	8b 45 08             	mov    0x8(%ebp),%eax
 80003ef:	8d 50 01             	lea    0x1(%eax),%edx
 80003f2:	89 55 08             	mov    %edx,0x8(%ebp)
 80003f5:	8b 55 0c             	mov    0xc(%ebp),%edx
 80003f8:	8d 4a 01             	lea    0x1(%edx),%ecx
 80003fb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 80003fe:	8a 12                	mov    (%edx),%dl
 8000400:	88 10                	mov    %dl,(%eax)
 8000402:	8a 00                	mov    (%eax),%al
 8000404:	84 c0                	test   %al,%al
 8000406:	75 e4                	jne    80003ec <strcpy+0xd>
		/* do nothing */;
	return ret;
 8000408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 800040b:	c9                   	leave  
 800040c:	c3                   	ret    

0800040d <strcat>:

char *
strcat(char *dst, const char *src)
{
 800040d:	55                   	push   %ebp
 800040e:	89 e5                	mov    %esp,%ebp
 8000410:	83 ec 18             	sub    $0x18,%esp
	int len = strlen(dst);
 8000413:	8b 45 08             	mov    0x8(%ebp),%eax
 8000416:	89 04 24             	mov    %eax,(%esp)
 8000419:	e8 72 ff ff ff       	call   8000390 <strlen>
 800041e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
 8000421:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8000424:	8b 45 08             	mov    0x8(%ebp),%eax
 8000427:	01 c2                	add    %eax,%edx
 8000429:	8b 45 0c             	mov    0xc(%ebp),%eax
 800042c:	89 44 24 04          	mov    %eax,0x4(%esp)
 8000430:	89 14 24             	mov    %edx,(%esp)
 8000433:	e8 a7 ff ff ff       	call   80003df <strcpy>
	return dst;
 8000438:	8b 45 08             	mov    0x8(%ebp),%eax
}
 800043b:	c9                   	leave  
 800043c:	c3                   	ret    

0800043d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
 800043d:	55                   	push   %ebp
 800043e:	89 e5                	mov    %esp,%ebp
 8000440:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
 8000443:	8b 45 08             	mov    0x8(%ebp),%eax
 8000446:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
 8000449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8000450:	eb 1f                	jmp    8000471 <strncpy+0x34>
		*dst++ = *src;
 8000452:	8b 45 08             	mov    0x8(%ebp),%eax
 8000455:	8d 50 01             	lea    0x1(%eax),%edx
 8000458:	89 55 08             	mov    %edx,0x8(%ebp)
 800045b:	8b 55 0c             	mov    0xc(%ebp),%edx
 800045e:	8a 12                	mov    (%edx),%dl
 8000460:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
 8000462:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000465:	8a 00                	mov    (%eax),%al
 8000467:	84 c0                	test   %al,%al
 8000469:	74 03                	je     800046e <strncpy+0x31>
			src++;
 800046b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
 800046e:	ff 45 fc             	incl   -0x4(%ebp)
 8000471:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8000474:	3b 45 10             	cmp    0x10(%ebp),%eax
 8000477:	72 d9                	jb     8000452 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
 8000479:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 800047c:	c9                   	leave  
 800047d:	c3                   	ret    

0800047e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
 800047e:	55                   	push   %ebp
 800047f:	89 e5                	mov    %esp,%ebp
 8000481:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
 8000484:	8b 45 08             	mov    0x8(%ebp),%eax
 8000487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
 800048a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 800048e:	74 30                	je     80004c0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
 8000490:	eb 16                	jmp    80004a8 <strlcpy+0x2a>
			*dst++ = *src++;
 8000492:	8b 45 08             	mov    0x8(%ebp),%eax
 8000495:	8d 50 01             	lea    0x1(%eax),%edx
 8000498:	89 55 08             	mov    %edx,0x8(%ebp)
 800049b:	8b 55 0c             	mov    0xc(%ebp),%edx
 800049e:	8d 4a 01             	lea    0x1(%edx),%ecx
 80004a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 80004a4:	8a 12                	mov    (%edx),%dl
 80004a6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
 80004a8:	ff 4d 10             	decl   0x10(%ebp)
 80004ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 80004af:	74 09                	je     80004ba <strlcpy+0x3c>
 80004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 80004b4:	8a 00                	mov    (%eax),%al
 80004b6:	84 c0                	test   %al,%al
 80004b8:	75 d8                	jne    8000492 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
 80004ba:	8b 45 08             	mov    0x8(%ebp),%eax
 80004bd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
 80004c0:	8b 55 08             	mov    0x8(%ebp),%edx
 80004c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80004c6:	29 c2                	sub    %eax,%edx
 80004c8:	89 d0                	mov    %edx,%eax
}
 80004ca:	c9                   	leave  
 80004cb:	c3                   	ret    

080004cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 80004cc:	55                   	push   %ebp
 80004cd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
 80004cf:	eb 06                	jmp    80004d7 <strcmp+0xb>
		p++, q++;
 80004d1:	ff 45 08             	incl   0x8(%ebp)
 80004d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
 80004d7:	8b 45 08             	mov    0x8(%ebp),%eax
 80004da:	8a 00                	mov    (%eax),%al
 80004dc:	84 c0                	test   %al,%al
 80004de:	74 0e                	je     80004ee <strcmp+0x22>
 80004e0:	8b 45 08             	mov    0x8(%ebp),%eax
 80004e3:	8a 10                	mov    (%eax),%dl
 80004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 80004e8:	8a 00                	mov    (%eax),%al
 80004ea:	38 c2                	cmp    %al,%dl
 80004ec:	74 e3                	je     80004d1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
 80004ee:	8b 45 08             	mov    0x8(%ebp),%eax
 80004f1:	8a 00                	mov    (%eax),%al
 80004f3:	31 d2                	xor    %edx,%edx
 80004f5:	88 c2                	mov    %al,%dl
 80004f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 80004fa:	8a 00                	mov    (%eax),%al
 80004fc:	25 ff 00 00 00       	and    $0xff,%eax
 8000501:	29 c2                	sub    %eax,%edx
 8000503:	89 d0                	mov    %edx,%eax
}
 8000505:	5d                   	pop    %ebp
 8000506:	c3                   	ret    

08000507 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
 8000507:	55                   	push   %ebp
 8000508:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
 800050a:	eb 09                	jmp    8000515 <strncmp+0xe>
		n--, p++, q++;
 800050c:	ff 4d 10             	decl   0x10(%ebp)
 800050f:	ff 45 08             	incl   0x8(%ebp)
 8000512:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
 8000515:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8000519:	74 17                	je     8000532 <strncmp+0x2b>
 800051b:	8b 45 08             	mov    0x8(%ebp),%eax
 800051e:	8a 00                	mov    (%eax),%al
 8000520:	84 c0                	test   %al,%al
 8000522:	74 0e                	je     8000532 <strncmp+0x2b>
 8000524:	8b 45 08             	mov    0x8(%ebp),%eax
 8000527:	8a 10                	mov    (%eax),%dl
 8000529:	8b 45 0c             	mov    0xc(%ebp),%eax
 800052c:	8a 00                	mov    (%eax),%al
 800052e:	38 c2                	cmp    %al,%dl
 8000530:	74 da                	je     800050c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
 8000532:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8000536:	75 07                	jne    800053f <strncmp+0x38>
		return 0;
 8000538:	b8 00 00 00 00       	mov    $0x0,%eax
 800053d:	eb 17                	jmp    8000556 <strncmp+0x4f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
 800053f:	8b 45 08             	mov    0x8(%ebp),%eax
 8000542:	8a 00                	mov    (%eax),%al
 8000544:	31 d2                	xor    %edx,%edx
 8000546:	88 c2                	mov    %al,%dl
 8000548:	8b 45 0c             	mov    0xc(%ebp),%eax
 800054b:	8a 00                	mov    (%eax),%al
 800054d:	25 ff 00 00 00       	and    $0xff,%eax
 8000552:	29 c2                	sub    %eax,%edx
 8000554:	89 d0                	mov    %edx,%eax
}
 8000556:	5d                   	pop    %ebp
 8000557:	c3                   	ret    

08000558 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
 8000558:	55                   	push   %ebp
 8000559:	89 e5                	mov    %esp,%ebp
 800055b:	83 ec 04             	sub    $0x4,%esp
 800055e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000561:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
 8000564:	eb 12                	jmp    8000578 <strchr+0x20>
		if (*s == c)
 8000566:	8b 45 08             	mov    0x8(%ebp),%eax
 8000569:	8a 00                	mov    (%eax),%al
 800056b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 800056e:	75 05                	jne    8000575 <strchr+0x1d>
			return (char *) s;
 8000570:	8b 45 08             	mov    0x8(%ebp),%eax
 8000573:	eb 11                	jmp    8000586 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
 8000575:	ff 45 08             	incl   0x8(%ebp)
 8000578:	8b 45 08             	mov    0x8(%ebp),%eax
 800057b:	8a 00                	mov    (%eax),%al
 800057d:	84 c0                	test   %al,%al
 800057f:	75 e5                	jne    8000566 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
 8000581:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8000586:	c9                   	leave  
 8000587:	c3                   	ret    

08000588 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
 8000588:	55                   	push   %ebp
 8000589:	89 e5                	mov    %esp,%ebp
 800058b:	83 ec 04             	sub    $0x4,%esp
 800058e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000591:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
 8000594:	eb 0f                	jmp    80005a5 <strfind+0x1d>
		if (*s == c)
 8000596:	8b 45 08             	mov    0x8(%ebp),%eax
 8000599:	8a 00                	mov    (%eax),%al
 800059b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 800059e:	75 02                	jne    80005a2 <strfind+0x1a>
			break;
 80005a0:	eb 0c                	jmp    80005ae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
 80005a2:	ff 45 08             	incl   0x8(%ebp)
 80005a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80005a8:	8a 00                	mov    (%eax),%al
 80005aa:	84 c0                	test   %al,%al
 80005ac:	75 e8                	jne    8000596 <strfind+0xe>
		if (*s == c)
			break;
	return (char *) s;
 80005ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80005b1:	c9                   	leave  
 80005b2:	c3                   	ret    

080005b3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
 80005b3:	55                   	push   %ebp
 80005b4:	89 e5                	mov    %esp,%ebp
 80005b6:	57                   	push   %edi
	//char *p;

	if (n == 0)
 80005b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 80005bb:	75 05                	jne    80005c2 <memset+0xf>
		return v;
 80005bd:	8b 45 08             	mov    0x8(%ebp),%eax
 80005c0:	eb 5c                	jmp    800061e <memset+0x6b>
	if ((int)v%4 == 0 && n%4 == 0) {
 80005c2:	8b 45 08             	mov    0x8(%ebp),%eax
 80005c5:	83 e0 03             	and    $0x3,%eax
 80005c8:	85 c0                	test   %eax,%eax
 80005ca:	75 41                	jne    800060d <memset+0x5a>
 80005cc:	8b 45 10             	mov    0x10(%ebp),%eax
 80005cf:	83 e0 03             	and    $0x3,%eax
 80005d2:	85 c0                	test   %eax,%eax
 80005d4:	75 37                	jne    800060d <memset+0x5a>
		c &= 0xFF;
 80005d6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
 80005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 80005e0:	c1 e0 18             	shl    $0x18,%eax
 80005e3:	89 c2                	mov    %eax,%edx
 80005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 80005e8:	c1 e0 10             	shl    $0x10,%eax
 80005eb:	09 c2                	or     %eax,%edx
 80005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 80005f0:	c1 e0 08             	shl    $0x8,%eax
 80005f3:	09 d0                	or     %edx,%eax
 80005f5:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
 80005f8:	8b 45 10             	mov    0x10(%ebp),%eax
 80005fb:	c1 e8 02             	shr    $0x2,%eax
 80005fe:	89 c1                	mov    %eax,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
 8000600:	8b 55 08             	mov    0x8(%ebp),%edx
 8000603:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000606:	89 d7                	mov    %edx,%edi
 8000608:	fc                   	cld    
 8000609:	f3 ab                	rep stos %eax,%es:(%edi)
 800060b:	eb 0e                	jmp    800061b <memset+0x68>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
 800060d:	8b 55 08             	mov    0x8(%ebp),%edx
 8000610:	8b 45 0c             	mov    0xc(%ebp),%eax
 8000613:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8000616:	89 d7                	mov    %edx,%edi
 8000618:	fc                   	cld    
 8000619:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
 800061b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 800061e:	5f                   	pop    %edi
 800061f:	5d                   	pop    %ebp
 8000620:	c3                   	ret    

08000621 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
 8000621:	55                   	push   %ebp
 8000622:	89 e5                	mov    %esp,%ebp
 8000624:	57                   	push   %edi
 8000625:	56                   	push   %esi
 8000626:	53                   	push   %ebx
 8000627:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
 800062a:	8b 45 0c             	mov    0xc(%ebp),%eax
 800062d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
 8000630:	8b 45 08             	mov    0x8(%ebp),%eax
 8000633:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
 8000636:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8000639:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 800063c:	73 6d                	jae    80006ab <memmove+0x8a>
 800063e:	8b 45 10             	mov    0x10(%ebp),%eax
 8000641:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8000644:	01 d0                	add    %edx,%eax
 8000646:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8000649:	76 60                	jbe    80006ab <memmove+0x8a>
		s += n;
 800064b:	8b 45 10             	mov    0x10(%ebp),%eax
 800064e:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
 8000651:	8b 45 10             	mov    0x10(%ebp),%eax
 8000654:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
 8000657:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800065a:	83 e0 03             	and    $0x3,%eax
 800065d:	85 c0                	test   %eax,%eax
 800065f:	75 2f                	jne    8000690 <memmove+0x6f>
 8000661:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8000664:	83 e0 03             	and    $0x3,%eax
 8000667:	85 c0                	test   %eax,%eax
 8000669:	75 25                	jne    8000690 <memmove+0x6f>
 800066b:	8b 45 10             	mov    0x10(%ebp),%eax
 800066e:	83 e0 03             	and    $0x3,%eax
 8000671:	85 c0                	test   %eax,%eax
 8000673:	75 1b                	jne    8000690 <memmove+0x6f>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
 8000675:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8000678:	83 e8 04             	sub    $0x4,%eax
 800067b:	8b 55 f0             	mov    -0x10(%ebp),%edx
 800067e:	83 ea 04             	sub    $0x4,%edx
 8000681:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8000684:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
 8000687:	89 c7                	mov    %eax,%edi
 8000689:	89 d6                	mov    %edx,%esi
 800068b:	fd                   	std    
 800068c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 800068e:	eb 18                	jmp    80006a8 <memmove+0x87>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
 8000690:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8000693:	8d 50 ff             	lea    -0x1(%eax),%edx
 8000696:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8000699:	8d 58 ff             	lea    -0x1(%eax),%ebx
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
 800069c:	8b 45 10             	mov    0x10(%ebp),%eax
 800069f:	89 d7                	mov    %edx,%edi
 80006a1:	89 de                	mov    %ebx,%esi
 80006a3:	89 c1                	mov    %eax,%ecx
 80006a5:	fd                   	std    
 80006a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
 80006a8:	fc                   	cld    
 80006a9:	eb 45                	jmp    80006f0 <memmove+0xcf>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
 80006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80006ae:	83 e0 03             	and    $0x3,%eax
 80006b1:	85 c0                	test   %eax,%eax
 80006b3:	75 2b                	jne    80006e0 <memmove+0xbf>
 80006b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80006b8:	83 e0 03             	and    $0x3,%eax
 80006bb:	85 c0                	test   %eax,%eax
 80006bd:	75 21                	jne    80006e0 <memmove+0xbf>
 80006bf:	8b 45 10             	mov    0x10(%ebp),%eax
 80006c2:	83 e0 03             	and    $0x3,%eax
 80006c5:	85 c0                	test   %eax,%eax
 80006c7:	75 17                	jne    80006e0 <memmove+0xbf>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
 80006c9:	8b 45 10             	mov    0x10(%ebp),%eax
 80006cc:	c1 e8 02             	shr    $0x2,%eax
 80006cf:	89 c1                	mov    %eax,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
 80006d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80006d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80006d7:	89 c7                	mov    %eax,%edi
 80006d9:	89 d6                	mov    %edx,%esi
 80006db:	fc                   	cld    
 80006dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 80006de:	eb 10                	jmp    80006f0 <memmove+0xcf>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
 80006e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80006e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80006e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 80006e9:	89 c7                	mov    %eax,%edi
 80006eb:	89 d6                	mov    %edx,%esi
 80006ed:	fc                   	cld    
 80006ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
 80006f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80006f3:	83 c4 10             	add    $0x10,%esp
 80006f6:	5b                   	pop    %ebx
 80006f7:	5e                   	pop    %esi
 80006f8:	5f                   	pop    %edi
 80006f9:	5d                   	pop    %ebp
 80006fa:	c3                   	ret    

080006fb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
 80006fb:	55                   	push   %ebp
 80006fc:	89 e5                	mov    %esp,%ebp
 80006fe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
 8000701:	8b 45 10             	mov    0x10(%ebp),%eax
 8000704:	89 44 24 08          	mov    %eax,0x8(%esp)
 8000708:	8b 45 0c             	mov    0xc(%ebp),%eax
 800070b:	89 44 24 04          	mov    %eax,0x4(%esp)
 800070f:	8b 45 08             	mov    0x8(%ebp),%eax
 8000712:	89 04 24             	mov    %eax,(%esp)
 8000715:	e8 07 ff ff ff       	call   8000621 <memmove>
}
 800071a:	c9                   	leave  
 800071b:	c3                   	ret    

0800071c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
 800071c:	55                   	push   %ebp
 800071d:	89 e5                	mov    %esp,%ebp
 800071f:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
 8000722:	8b 45 08             	mov    0x8(%ebp),%eax
 8000725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
 8000728:	8b 45 0c             	mov    0xc(%ebp),%eax
 800072b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
 800072e:	eb 2d                	jmp    800075d <memcmp+0x41>
		if (*s1 != *s2)
 8000730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8000733:	8a 10                	mov    (%eax),%dl
 8000735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8000738:	8a 00                	mov    (%eax),%al
 800073a:	38 c2                	cmp    %al,%dl
 800073c:	74 19                	je     8000757 <memcmp+0x3b>
			return (int) *s1 - (int) *s2;
 800073e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8000741:	8a 00                	mov    (%eax),%al
 8000743:	31 d2                	xor    %edx,%edx
 8000745:	88 c2                	mov    %al,%dl
 8000747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800074a:	8a 00                	mov    (%eax),%al
 800074c:	25 ff 00 00 00       	and    $0xff,%eax
 8000751:	29 c2                	sub    %eax,%edx
 8000753:	89 d0                	mov    %edx,%eax
 8000755:	eb 18                	jmp    800076f <memcmp+0x53>
		s1++, s2++;
 8000757:	ff 45 fc             	incl   -0x4(%ebp)
 800075a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
 800075d:	8b 45 10             	mov    0x10(%ebp),%eax
 8000760:	8d 50 ff             	lea    -0x1(%eax),%edx
 8000763:	89 55 10             	mov    %edx,0x10(%ebp)
 8000766:	85 c0                	test   %eax,%eax
 8000768:	75 c6                	jne    8000730 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
 800076a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 800076f:	c9                   	leave  
 8000770:	c3                   	ret    

08000771 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
 8000771:	55                   	push   %ebp
 8000772:	89 e5                	mov    %esp,%ebp
 8000774:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
 8000777:	8b 45 10             	mov    0x10(%ebp),%eax
 800077a:	8b 55 08             	mov    0x8(%ebp),%edx
 800077d:	01 d0                	add    %edx,%eax
 800077f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
 8000782:	eb 11                	jmp    8000795 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
 8000784:	8b 45 08             	mov    0x8(%ebp),%eax
 8000787:	8a 10                	mov    (%eax),%dl
 8000789:	8b 45 0c             	mov    0xc(%ebp),%eax
 800078c:	38 c2                	cmp    %al,%dl
 800078e:	75 02                	jne    8000792 <memfind+0x21>
			break;
 8000790:	eb 0b                	jmp    800079d <memfind+0x2c>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
 8000792:	ff 45 08             	incl   0x8(%ebp)
 8000795:	8b 45 08             	mov    0x8(%ebp),%eax
 8000798:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 800079b:	72 e7                	jb     8000784 <memfind+0x13>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
 800079d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80007a0:	c9                   	leave  
 80007a1:	c3                   	ret    

080007a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
 80007a2:	55                   	push   %ebp
 80007a3:	89 e5                	mov    %esp,%ebp
 80007a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
 80007a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
 80007af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
 80007b6:	eb 03                	jmp    80007bb <strtol+0x19>
		s++;
 80007b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
 80007bb:	8b 45 08             	mov    0x8(%ebp),%eax
 80007be:	8a 00                	mov    (%eax),%al
 80007c0:	3c 20                	cmp    $0x20,%al
 80007c2:	74 f4                	je     80007b8 <strtol+0x16>
 80007c4:	8b 45 08             	mov    0x8(%ebp),%eax
 80007c7:	8a 00                	mov    (%eax),%al
 80007c9:	3c 09                	cmp    $0x9,%al
 80007cb:	74 eb                	je     80007b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
 80007cd:	8b 45 08             	mov    0x8(%ebp),%eax
 80007d0:	8a 00                	mov    (%eax),%al
 80007d2:	3c 2b                	cmp    $0x2b,%al
 80007d4:	75 05                	jne    80007db <strtol+0x39>
		s++;
 80007d6:	ff 45 08             	incl   0x8(%ebp)
 80007d9:	eb 13                	jmp    80007ee <strtol+0x4c>
	else if (*s == '-')
 80007db:	8b 45 08             	mov    0x8(%ebp),%eax
 80007de:	8a 00                	mov    (%eax),%al
 80007e0:	3c 2d                	cmp    $0x2d,%al
 80007e2:	75 0a                	jne    80007ee <strtol+0x4c>
		s++, neg = 1;
 80007e4:	ff 45 08             	incl   0x8(%ebp)
 80007e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
 80007ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 80007f2:	74 06                	je     80007fa <strtol+0x58>
 80007f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 80007f8:	75 20                	jne    800081a <strtol+0x78>
 80007fa:	8b 45 08             	mov    0x8(%ebp),%eax
 80007fd:	8a 00                	mov    (%eax),%al
 80007ff:	3c 30                	cmp    $0x30,%al
 8000801:	75 17                	jne    800081a <strtol+0x78>
 8000803:	8b 45 08             	mov    0x8(%ebp),%eax
 8000806:	40                   	inc    %eax
 8000807:	8a 00                	mov    (%eax),%al
 8000809:	3c 78                	cmp    $0x78,%al
 800080b:	75 0d                	jne    800081a <strtol+0x78>
		s += 2, base = 16;
 800080d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
 8000811:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 8000818:	eb 28                	jmp    8000842 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
 800081a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 800081e:	75 15                	jne    8000835 <strtol+0x93>
 8000820:	8b 45 08             	mov    0x8(%ebp),%eax
 8000823:	8a 00                	mov    (%eax),%al
 8000825:	3c 30                	cmp    $0x30,%al
 8000827:	75 0c                	jne    8000835 <strtol+0x93>
		s++, base = 8;
 8000829:	ff 45 08             	incl   0x8(%ebp)
 800082c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 8000833:	eb 0d                	jmp    8000842 <strtol+0xa0>
	else if (base == 0)
 8000835:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8000839:	75 07                	jne    8000842 <strtol+0xa0>
		base = 10;
 800083b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
 8000842:	8b 45 08             	mov    0x8(%ebp),%eax
 8000845:	8a 00                	mov    (%eax),%al
 8000847:	3c 2f                	cmp    $0x2f,%al
 8000849:	7e 19                	jle    8000864 <strtol+0xc2>
 800084b:	8b 45 08             	mov    0x8(%ebp),%eax
 800084e:	8a 00                	mov    (%eax),%al
 8000850:	3c 39                	cmp    $0x39,%al
 8000852:	7f 10                	jg     8000864 <strtol+0xc2>
			dig = *s - '0';
 8000854:	8b 45 08             	mov    0x8(%ebp),%eax
 8000857:	8a 00                	mov    (%eax),%al
 8000859:	0f be c0             	movsbl %al,%eax
 800085c:	83 e8 30             	sub    $0x30,%eax
 800085f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8000862:	eb 42                	jmp    80008a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
 8000864:	8b 45 08             	mov    0x8(%ebp),%eax
 8000867:	8a 00                	mov    (%eax),%al
 8000869:	3c 60                	cmp    $0x60,%al
 800086b:	7e 19                	jle    8000886 <strtol+0xe4>
 800086d:	8b 45 08             	mov    0x8(%ebp),%eax
 8000870:	8a 00                	mov    (%eax),%al
 8000872:	3c 7a                	cmp    $0x7a,%al
 8000874:	7f 10                	jg     8000886 <strtol+0xe4>
			dig = *s - 'a' + 10;
 8000876:	8b 45 08             	mov    0x8(%ebp),%eax
 8000879:	8a 00                	mov    (%eax),%al
 800087b:	0f be c0             	movsbl %al,%eax
 800087e:	83 e8 57             	sub    $0x57,%eax
 8000881:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8000884:	eb 20                	jmp    80008a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
 8000886:	8b 45 08             	mov    0x8(%ebp),%eax
 8000889:	8a 00                	mov    (%eax),%al
 800088b:	3c 40                	cmp    $0x40,%al
 800088d:	7e 3a                	jle    80008c9 <strtol+0x127>
 800088f:	8b 45 08             	mov    0x8(%ebp),%eax
 8000892:	8a 00                	mov    (%eax),%al
 8000894:	3c 5a                	cmp    $0x5a,%al
 8000896:	7f 31                	jg     80008c9 <strtol+0x127>
			dig = *s - 'A' + 10;
 8000898:	8b 45 08             	mov    0x8(%ebp),%eax
 800089b:	8a 00                	mov    (%eax),%al
 800089d:	0f be c0             	movsbl %al,%eax
 80008a0:	83 e8 37             	sub    $0x37,%eax
 80008a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
 80008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80008a9:	3b 45 10             	cmp    0x10(%ebp),%eax
 80008ac:	7c 02                	jl     80008b0 <strtol+0x10e>
			break;
 80008ae:	eb 19                	jmp    80008c9 <strtol+0x127>
		s++, val = (val * base) + dig;
 80008b0:	ff 45 08             	incl   0x8(%ebp)
 80008b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80008b6:	0f af 45 10          	imul   0x10(%ebp),%eax
 80008ba:	89 c2                	mov    %eax,%edx
 80008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80008bf:	01 d0                	add    %edx,%eax
 80008c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
 80008c4:	e9 79 ff ff ff       	jmp    8000842 <strtol+0xa0>

	if (endptr)
 80008c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 80008cd:	74 08                	je     80008d7 <strtol+0x135>
		*endptr = (char *) s;
 80008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 80008d2:	8b 55 08             	mov    0x8(%ebp),%edx
 80008d5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
 80008d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
 80008db:	74 07                	je     80008e4 <strtol+0x142>
 80008dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80008e0:	f7 d8                	neg    %eax
 80008e2:	eb 03                	jmp    80008e7 <strtol+0x145>
 80008e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80008e7:	c9                   	leave  
 80008e8:	c3                   	ret    
