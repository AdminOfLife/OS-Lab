#ifndef __DISK_H__
#define __DISK_H__

#include <include/x86.h>

#define SECTSIZE 512

static inline
void waitdisk(void) {
	while((inb(0x1F7) & 0xC0) != 0x40); 
}

static inline
void readsect(void *dst, int offset) {
	waitdisk();
	outb(0x1F2, 1);
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
	outb(0x1F5, offset >> 16);
	outb(0x1F6, (offset >> 24) | 0xE0);
	outb(0x1F7, 0x20);

	waitdisk();
	insl(0x1F0, dst, SECTSIZE / 4);
}

static inline
void readseg(unsigned char *pa, int count, int offset) {
	unsigned char *epa, *opa = pa;
	unsigned char buffer[SECTSIZE];
	int i;
	epa = pa + count;
	pa -= offset % SECTSIZE;
	offset = (offset / SECTSIZE) + 1;
	for(; pa < epa; pa += SECTSIZE, offset ++) {
		readsect(&buffer, offset);
		for (i = 0; i < SECTSIZE; i ++) {
			if (opa <= pa + i && pa + i <= epa) pa[i] = buffer[i];
		}
	}
}

static inline
void writesect(void *dst, int offset) {
	waitdisk();
	outb(0x1F2, 1);
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
	outb(0x1F5, offset >> 16);
	outb(0x1F6, (offset >> 24) | 0xE0);
	outb(0x1F7, 0x30);

	waitdisk();
	outsl(0x1F0, dst, SECTSIZE / 4);
}

static inline
void ide_write(void *buf, int secno, int nsecs) {
	for(; nsecs ; secno ++, nsecs --, buf += SECTSIZE)
		writesect(buf, secno);
}

#endif
