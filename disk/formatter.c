#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define BLOCK_NUM (512 * 256)


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
int inode_cnt;

uint8_t disk_data[512 * BLOCK_NUM];

int main(int argc, char *argv[]) {
	int i;
	FILE *f;

	if (argc < 2) {
		printf("Too few arguments!\n");
		return 1;
	}

	f = fopen(argv[1], "wb");
	fwrite(&bit_map, sizeof(bit_map), 1, f);
	fwrite(&root, sizeof(root), 1, f);
	fwrite(inode_list, sizeof(inode_list), 1, f);
	fwrite(disk_data, sizeof(disk_data), 1, f);
	fclose(f);
	return 0;
}
