#include <include/string.c>

#define VGA_START (0xA0000)
#define VGA_LENGTH (0x10000)

void transfer(char logo[])
	memcpy((char *)VGA_START, logo, VGA_LENGTH);
}
