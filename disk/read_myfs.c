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

uint8_t disk_data[512 * BLOCK_NUM];

uint8_t tmp[512 * BLOCK_NUM];

int main(int argc, char *argv[]) {
	int i;
	FILE *f;

	if (argc < 3) {
		printf("Too few arguments!\n");
		return 1;
	}

	f = fopen(argv[1], "rb");
	fread(&bit_map, sizeof(bit_map), 1, f);
	fread(&root, sizeof(root), 1, f);
	fread(inode_list, sizeof(inode_list), 1, f);
	fread(disk_data, sizeof(disk_data), 1, f);
	fclose(f);

	for (i = 2; i < argc; i++) {
		memset(tmp, 0, sizeof tmp);

		int j, fn_ind = -1, inode_entry = -1, file_size = 0;
		if (argv[i][0] == '/') argv[i] ++;
		for (j = 0; j < 2 * 512 / sizeof(struct dirent); j ++) {
			if (strcmp(root.entries[j].filename, argv[i]) == 0) {
				fn_ind = j;
				break;
			}
		}

		if (fn_ind == -1) continue;

		inode_entry = root.entries[fn_ind].inode_offset;
		file_size = root.entries[fn_ind].file_size;

		uint8_t *cur_tmp = tmp;
		for (j = 0; j < 512 * 64 / sizeof(uint32_t); j++) {
			if (inode_list[inode_entry].data_block_offsets[j] != 0) {
				int disk_offset = inode_list[inode_entry].data_block_offsets[j]
								- sizeof(bit_map) - sizeof(root) - sizeof(inode_list);
				memcpy(cur_tmp, disk_data + disk_offset, 512);
				cur_tmp += 512;
			}
		}

		f = fopen(argv[i], "wb");
		fwrite(tmp, file_size, 1, f);
		fclose(f);
	}

	return 0;
}
