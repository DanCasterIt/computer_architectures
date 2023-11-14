#include <stdio.h>
#include <stdint.h>

#define LEN 6

void to_bin (void * number, unsigned char num_size, char *string);

int main(int argv, char *argc[])	{
	int i;
	uint16_t res;
	uint8_t anno[LEN] = {1, 3, 5, 7, 8, 9};
	uint8_t wos[LEN] = {4, 4, 3, 2, 1, 4};
	uint8_t sco[LEN] = {0, 0, 0, 0, 0, 0};
	char string[17];
	printf("CITATIONS DW D_CITA,D_CITB DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (anno[i] << 12) | (wos[i] << 6) | sco[i];
		printf("%XH", res);
		if(i < LEN - 1)	printf(",");
	}
	printf(")\n");
	printf("\t\t\t;DUP(");
	for(i = 0; i < LEN; i++)	{
		printf("%u|%u|%u", anno[i], wos[i], sco[i]);
		if(i < LEN - 1)	printf(", ");
	}
	printf(")\n");
	printf("DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (anno[i] << 12) | (wos[i] << 6) | sco[i];
		printf("%u", res);
		if(i < LEN - 1)	printf(",");
	}
	printf(")\n");
	printf("DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (anno[i] << 12) | (wos[i] << 6) | sco[i];
		to_bin ((void *) &res, 2, string);
		printf("%sB", string);
		if(i < LEN - 1)	printf(",");
	}
	printf(")\n");
}

void to_bin (void * number, unsigned char num_size, char *string)	{
	int i, e, f;
	unsigned char *num;
	for(f = 0, e = 8 * num_size -1; f < num_size;  f++)	{
		num = number + f;
		for(i = 0; i < 8; i++, e--)	{
			if(((*num >> i) & 1) == 1)	string[e] = '1';
			else	string[e] = '0';
		}
	}
	string[8 * num_size] = '\0';
}
