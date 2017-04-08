#include <usr_inc/stdio.h>
#include <usr_inc/syscall.h>


#define PRINT_TO_TERMINAL 3

static char user_space_message[] = "User Printing: ";

static void printc(char);

static void printc(char c) {
	syscall(PRINT_TO_TERMINAL, c);
};

static void out_num(unsigned, unsigned, bool);
static void out_string(char*);

int printk(const char *fmt, ...) {
	out_string(user_space_message);

	//char ch = *(unsigned char *)fmt;
	va_list ap;

	va_start(ap, fmt);

	while(*fmt){
		if(*fmt != '%'){
			printc(*fmt);
		}
		else {
			fmt++;
			switch(*fmt){
				case 'd': out_num( va_arg(ap, int), 10, 1); break;
				case 'x': out_num( va_arg(ap, unsigned int), 16, 0); break;
				case 'c': printc(va_arg(ap, unsigned int)); break;
				case 's': out_string(va_arg(ap, char*)); break;
				default: break;
			}
		}
		fmt++;
	}

	va_end(ap);

	return 0;
}

static void rec_out_num(unsigned int x, unsigned int base) {
	if(x >= base){
		rec_out_num(x/base, base);
	}
	printc("0123456789abcdef"[x % base]);
}

static void out_num(unsigned int x, unsigned int base, bool SIGN) {
	if( SIGN && ((int)x) < 0 ){
		printc('-');
		x = ~x + 1;
	}
	rec_out_num(x, base);
}

static void out_string(char *s) {
	while(*s){
		printc(*s);
		s++;
	}
}
