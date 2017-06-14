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

int next_free_block() {
	for (int i = 0; i < BLOCK_NUM / 8; i ++) {
		for (int j = 0; j < 8; j++) {
			if (!((bit_map.mask[i] >> j) & 1)) {
				bit_map.mask[i] |= (1 << j);
				return (i * 8 + j) * 512 + sizeof(bit_map) + sizeof(root) + sizeof(inode_list);
			}
		}
	}
	return -1;
}

void write_to_block(uint8_t *data, uint32_t data_offset) {
	int i;
	data_offset -= sizeof(bit_map) + sizeof(root) + sizeof(inode_list);
	for (i = 0; i < 512; i++) {
		disk_data[data_offset + i] = data[i];
	}
}

int write_file(char *filename, uint8_t *data, uint32_t size) {
	int i, j, file_offset = 0;
	for (i = 0; i < 2 * 512 / sizeof(struct dirent); i ++) {
		if (!strlen(root.entries[i].filename)) {
			strcpy(root.entries[i].filename, filename);
			root.entries[i].file_size = size;
			root.entries[i].inode_offset = inode_cnt;
			for (j = 0; j < 512 * 64 / sizeof(uint32_t); j ++) {
				inode_list[inode_cnt].data_block_offsets[j] = next_free_block();
				if (j == 0) printf("File allocated at 0x%x\n", inode_list[inode_cnt].data_block_offsets[j]);
				write_to_block(data + file_offset, inode_list[inode_cnt].data_block_offsets[j]);
				file_offset += 512;
				if (file_offset >= size) break;
			}
			inode_cnt ++;
			return 0;
		}
	}
	if (i == 2 * 512 / sizeof(struct dirent)) return -1;
}

char *stripped(char *ori) {
	int len = strlen(ori);
	int i;
	for (i = len - 1; i >= 0; i--) {
		if (ori[i] == '/') break;
	}
	if (i == -1) return ori;
	else return ori + i + 1;
}

uint8_t tmp[512 * BLOCK_NUM];

int main(int argc, char *argv[]) {
	int i;
	FILE *f;

	if (argc < 4) {
		printf("Too few arguments!\n");
		return 1;
	}

	if (strcmp(argv[1], "NULL")) {
		f = fopen(argv[1], "rb");
		fread(&bit_map, sizeof(bit_map), 1, f);
		fread(&root, sizeof(root), 1, f);
		fread(inode_list, sizeof(inode_list), 1, f);
		fread(disk_data, sizeof(disk_data), 1, f);
		fclose(f);
	}

	for (i = 3; i < argc; i++) {
//		if (i == 1 && strcmp(argv[i], "NULL") == 0) continue; 
		memset(tmp, 0, sizeof tmp);
		f = fopen(argv[i], "rb");
		fseek(f, 0, SEEK_END);
		long fsize = ftell(f);
		fseek(f, 0, SEEK_SET);
		fread(tmp, fsize, 1, f);
		fclose(f);
		write_file(stripped(argv[i]), tmp, fsize);
	}

	f = fopen(argv[2], "wb");
	fwrite(&bit_map, sizeof(bit_map), 1, f);
	fwrite(&root, sizeof(root), 1, f);
	fwrite(inode_list, sizeof(inode_list), 1, f);
	fwrite(disk_data, sizeof(disk_data), 1, f);
	fclose(f);
	return 0;
}
