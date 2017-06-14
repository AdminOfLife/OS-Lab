#ifndef __STDIO_H__
#define __STDIO_H__

#include <include/types.h>
#include <include/stdarg.h>
#include <include/disk.h>

int printk(const char *, ...);

void init_fs();

int fs_open(const char *pathname, int flags);
int fs_read(const int fd, void *buf, int len);
int fs_write(int fd, void *buf, int len);
int fs_lseek(int fd, int offset, int whence);
int fs_close(int fd);

#define BLOCK_NUM (512 * 256)
#define FCB_SIZE 64

#define R_FLAG 1
#define W_FLAG 2
#define B_FLAG 4

#define SEEK_SET 1
#define SEEK_CUR 2

#endif
