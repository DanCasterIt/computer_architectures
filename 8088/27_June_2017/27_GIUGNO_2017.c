#include <stdio.h>
#include <stdint.h>

#define LEN 4

void to_bin (void * number, unsigned char num_size, char *string);

int main(int argv, char *argc[])	{
	int i;
	uint16_t res;
	uint8_t HC[LEN] = {1, 0, 3, 2};
	uint8_t mese[LEN] = {3, 10, 10, 4};
	uint8_t giorno[LEN] = {26, 29, 1, 2};
	uint8_t ora[LEN] = {2, 2, 2, 2};
	char string[17];
	res = (6 << 10) | (27 << 5) | 10;
	printf("TIME DW %XH\n\r", res);
	to_bin ((void *) &res, 2, string);
	printf("TIME DW %sB\n\r", string);
	printf("DAYLIGHT DW 4 DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (HC[i] << 14) | (mese[i] << 10) | (giorno[i] << 5) | ora[i];
		printf("%XH", res);
		if(i < LEN - 1)	printf(",");
	}
	printf(")\n");
	printf("\t;DUP(");
	for(i = 0; i < LEN; i++)	{
		printf("%u|%u|%u|%u", HC[i], mese[i], giorno[i], ora[i]);
		if(i < LEN - 1)	printf(", ");
	}
	printf(")\n");
	printf("DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (HC[i] << 14) | (mese[i] << 10) | (giorno[i] << 5) | ora[i];
		printf("%u", res);
		if(i < LEN - 1)	printf(",");
	}
	printf(")\n");
	printf("DUP(");
	for(i = 0; i < LEN; i++)	{
		res = (HC[i] << 14) | (mese[i] << 10) | (giorno[i] << 5) | ora[i];
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
