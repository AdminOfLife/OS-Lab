#include <include/string.h>

#define STRING_START (0xB8000)
#define BLACK_AND_WHITE (0x0F)

void write_string(int color, const char *string) {
	volatile char *video = (volatile char*)STRING_START;
	while (*string != 0) {
		*video++ = *string++;
		*video++ = color;
	}
}

void write_black_and_white(const char *string) {
	write_string(BLACK_AND_WHITE, string);
}
