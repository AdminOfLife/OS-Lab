#include <include/stdio.h>
#include <include/string.h>


void serial_printc(char);

static void out_num(unsigned, unsigned, bool);
static void out_string(char*);
static void rec_out_num(unsigned int, unsigned int);

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

static void rec_out_num(unsigned int x, unsigned int base) {
	if(x >= base){
		rec_out_num(x/base, base);
	}
	serial_printc("0123456789abcdef"[x % base]);
}

static void out_num(unsigned int x, unsigned int base, bool SIGN) {
	if( SIGN && ((int)x) < 0 ){
		serial_printc('-');
		x = ~x + 1;
	}
	rec_out_num(x, base);
}

static void out_string(char *s) {
	while(*s){
		serial_printc(*s);
		s++;
	}
}

struct bitmap {
	uint8_t mask[BLOCK_NUM / 8];
} bit_map;

struct dirent {
	char filename[24];
	uint32_t file_size;
	uint32_t inode_offset;
};

struct dir {
	struct dirent entries[2 * 512 / sizeof(struct dirent)];
} root;

struct inode {
	uint32_t data_block_offsets[512 * 64 / sizeof(uint32_t)];
} inode_list[32];

struct FCB {
	uint32_t inode_entry;
	uint32_t pid;
	uint32_t seek_pos;
	uint32_t mode;
	bool valid;
} fcb[FCB_SIZE];

void init_fs() {
	readseg((void *)&bit_map, sizeof(bit_map), 0);
	readseg((void *)&root, sizeof(root), sizeof(bit_map));
	readseg((void *)inode_list, sizeof(inode_list), sizeof(bit_map) + sizeof(root));
}

/* Reading and writing in binary is the default behavior. */

int fs_open(const char *pathname, int flags) {
	int i, fd = -1, fn_ind = -1, inode_entry = -1;
	if (pathname[0] == '/') pathname ++;
	for (i = 0; i < 2 * 512 / sizeof(struct dirent); i ++) {
		if (strcmp(root.entries[i].filename, pathname) == 0) {
			fn_ind = i;
			break;
		}
	}
	inode_entry = root.entries[fn_ind].inode_offset;
	if (flags | R_FLAG && fn_ind == -1) return fd;
	for (i = 0; i < FCB_SIZE; i++) if (!fcb[i].valid) {
		fd = i;
		break;
	}
	if (fd == -1) return fd;

	fcb[fd].valid = 1;
	fcb[fd].inode_entry = inode_entry;
	fcb[fd].pid = 0;
	fcb[fd].seek_pos = 0;
	fcb[fd].mode = flags;

//	printk("Offset: %x\n", inode_list[fcb[fd].inode_entry].data_block_offsets[0]);

	return fd;
}

static int fread(const int fd, uint8_t *buf, int offset, int len) {
	int i, ooffset = offset;
	uint8_t *obuf = buf;
	for (i = ooffset / 512; i < (ooffset + len) / 512; i ++) {
		if (inode_list[fcb[fd].inode_entry].data_block_offsets[i] != 0) {
			int disk_offset = inode_list[fcb[fd].inode_entry].data_block_offsets[i];
			readseg(buf, SECTSIZE - (offset % SECTSIZE), disk_offset + (offset % SECTSIZE));
			buf += SECTSIZE - (offset % SECTSIZE);
			offset += SECTSIZE - (offset % SECTSIZE);
		}
	}
	return (int)(buf - obuf);
}

/* TODO: test */
static int fwrite(const int fd, uint8_t *buf, int offset, int len) {
	int i, ooffset = offset;
	uint8_t *obuf = buf;
	for (i = ooffset / 512; i < (ooffset + len) / 512; i ++) {
		if (inode_list[fcb[fd].inode_entry].data_block_offsets[i] != 0) {
			int disk_offset = inode_list[fcb[fd].inode_entry].data_block_offsets[i];
			ide_write(buf, SECTSIZE - (offset % SECTSIZE), disk_offset + (offset % SECTSIZE));
			buf += SECTSIZE - (offset % SECTSIZE);
			offset += SECTSIZE - (offset % SECTSIZE);
		}
	}
	return (int)(buf - obuf);
}

int fs_read(const int fd, void *buf, int len) {
	int seek_pos;
	if (fd < 0 || fd > FCB_SIZE || !fcb[fd].valid || !(fcb[fd].mode | R_FLAG)) return -1;
	seek_pos = fcb[fd].seek_pos;
	return fread(fd, buf, seek_pos, len);
}

int fs_write(int fd, void *buf, int len) {
	int seek_pos;
	if (fd < 0 || fd > FCB_SIZE || !fcb[fd].valid || !(fcb[fd].mode | W_FLAG)) return -1;
	seek_pos = fcb[fd].seek_pos;
	return fwrite(fd, buf, seek_pos, len);
}

int fs_lseek(int fd, int offset, int whence) {
	if (fd < 0 || fd > FCB_SIZE || !fcb[fd].valid) return -1;
	if (whence == SEEK_SET) fcb[fd].seek_pos = offset;
	else fcb[fd].seek_pos += offset;
	return 0;
}

int fs_close(int fd) {
	if (fd < 0 || fd > FCB_SIZE) return -1;
	fcb[fd].valid = 0;
	return 0;
}
