void main (void)
{
    unsigned byte v[8];

    v[0] = 9;
    v[1] = 3;
    v[2] = 6;
    v[3] = 2;
    v[4] = 8;
    v[5] = 1;
    v[6] = 4;
    v[7] = 5;

    unsigned byte i;
    unsigned byte j;
    unsigned byte temp;

    for (i = 1; i < 8; i = i+1)
    {
        for (j = i-1; j >= 0; j = j-1)
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
