#define MAX 8

unsigned byte i;
unsigned byte j;
unsigned byte temp;

unsigned byte v[MAX];

void bubblesort (void)
{
    for (i = 1; i < MAX; i++)
    {
        for (j = 0; j < MAX-1; j++)
        {
            if (v[j] > v[j+1])
            {
                temp = v[j];
                v[j] = v[j+1];
                v[j+1] = temp;
            }
        }
    }
}

void main (void)
{
    v[0] = 9;
    v[1] = 3;
    v[2] = 6;
    v[3] = 2;
    v[4] = 8;
    v[5] = 1;
    v[6] = 4;
    v[7] = 5;

    bubblesort();

    v[0] = 19;
    v[1] = 13;
    v[2] = 16;
    v[3] = 12;
    v[4] = 18;
    v[5] = 11;
    v[6] = 14;
    v[7] = 15;

    bubblesort();

    //for (i = 1; i < MAX; i = i+1)
    //{
    //    for (j = 0; j < MAX-1; j = j+1)
    //    {
    //        if (v[j] > v[j+1])
    //        {
    //            temp = v[j];
    //            v[j] = v[j+1];
    //            v[j+1] = temp;
    //        }
    //    }
    //}
}
