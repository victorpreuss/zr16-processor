#define MAX 8

unsigned byte i = 7;
unsigned byte j = 9;
unsigned byte k = 0;

void test (void)
{
    k = k + i + j;
}

void main (void)
{
    test();
    test();
}
