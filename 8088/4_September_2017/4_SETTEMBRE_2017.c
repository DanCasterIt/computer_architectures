#include <stdio.h>
#include <stdint.h>

void to_bin (void * number, unsigned char num_size, char *string);

int main(int argv, char *argc[])	{
	unsigned int h, m;
	uint16_t r;
	char string[100];
	while(1)	{
		printf("Digitare un orario secondo il formato hh:mm : ");
		scanf("%u:%u", &h, &m);
		r = (h << 8) | m;
		printf("%04XH, %u, ",r);
		to_bin ((void *) &r, 2, string);
		printf("%sB\n\r", string);
	}
	return 0;
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
