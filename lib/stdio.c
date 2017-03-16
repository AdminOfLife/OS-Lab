#include <include/stdio.h>

void serial_printc(char);

void out_num(unsigned, unsigned, bool);
void out_string(char*);

int printk(const char *fmt, ...) {
	//char ch = *(unsigned char *)fmt;
	va_list ap;

	va_start(ap, fmt);

	while(*fmt){
		if(*fmt != '%'){
			serial_printc(*fmt);
		}
		else {
			fmt++;
			switch(*fmt){
				case 'd': out_num( va_arg(ap, int), 10, 1); break;
				case 'x': out_num( va_arg(ap, unsigned int), 16, 0); break;
				case 'c': serial_printc(va_arg(ap, unsigned int)); break;
				case 's': out_string(va_arg(ap, char*)); break;
				default: break;
			}
		}
		fmt++;
	}

	va_end(ap);

	return 0;
}

void rec_out_num(unsigned int x, unsigned int base) {
	if(x >= base){
		rec_out_num(x/base, base);
	}
	serial_printc("0123456789abcdef"[x % base]);
}

void out_num(unsigned int x, unsigned int base, bool SIGN) {
	if( SIGN && ((int)x) < 0 ){
		serial_printc('-');
		x = ~x + 1;
	}
	rec_out_num(x, base);
}

void out_string(char *s) {
	while(*s){
		serial_printc(*s);
		s++;
	}
}
