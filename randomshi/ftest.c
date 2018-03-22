#include <stdio.h>
int main()
{
unsigned int a[] = {0x123456ff, 0x89abcdef, 0x00001111, 0x22223333,0x00010002,0x00030004,0xffffeeee,0xddddcccc};
unsigned char *p  = (unsigned char*) a;
static unsigned int q;
 fprintf(stdout,"%p\n",*a);
 fprintf(stdout,"%p\n",*(a+1));
 fprintf(stdout,"%p\n",p);
 fprintf(stdout,"%p\n",p+1);
}
