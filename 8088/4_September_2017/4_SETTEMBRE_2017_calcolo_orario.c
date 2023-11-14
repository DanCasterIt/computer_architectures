#include <stdio.h>
#include <stdint.h>

void to_bin (void * number, unsigned char num_size, char *string);

int main(int argv, char *argc[])	{
	char AC[17], BC[17], CC[17], CD[17];
	uint16_t A = 0x1800, B = 0x0727, C = 0x1037, D;
	uint8_t AH, AL, BH, BL, CH, CL, DH, DL;
	D = (A + B) - C;
	printf("(%u + %u) - %u = %u\n", A, B, C, D);
	AH = A >> 8;
	AL = A;
	BH = B >> 8;
	BL = B;
	CH = C >> 8;
	CL = C;
	DH = D >> 8;
	DL = D;
	printf("(%u:%u + %u:%u) - %u:%u = %u:%u\n", AH, AL, BH, BL, CH, CL, DH, DL);
	to_bin ((void *) &A, 2, AC);
	to_bin ((void *) &B, 2, BC);
	to_bin ((void *) &C, 2, CC);
	to_bin ((void *) &D, 2, CD);
	printf("(%s + %s) - %s = %s\n", AC, BC, CC, CD);
	DH = (AH + BH) - CH;
	DL = (AL + BL) - CL;
	printf("(%u:%u + %u:%u) - %u:%u = %u:%u\n", AH, AL, BH, BL, CH, CL, DH, DL);
	D = (DH << 8) | DL;
	to_bin ((void *) &D, 2, CD);
	printf("(%s + %s) - %s = %s\n", AC, BC, CC, CD);
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
