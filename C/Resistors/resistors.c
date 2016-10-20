#include <stdio.h>

int main()
{
    int n, i, r1_r2, r3_r4, k;
    float r1, r2, r3, r4, V, R1ol, R2ol;
    r1_r2=0;
    r3_r4=0;
    R1ol=0;
    R2ol=0;
    k=1;

    do {
        printf("Give r1: ");
        scanf("%f",&r1);
        printf("Give r2: ");
        scanf("%f",&r2);
        printf("Give r3: ");
        scanf("%f",&r3);
        printf("Give r4: ");
        scanf("%f",&r4);
        if (r1>=r3) {
            printf("Must r1<r3\n");
        }
        if (r2>=r4) {
            printf("Must r2<r4\n");
        }
    } while(r1>=r3 || r2>=r4);

    do {
        printf("Enter n: ");
        scanf("%d",&n);
        if (n<=0) {
            printf("n must be positive!\n");
        }
    } while (n<=0);
    printf("Enter V: ");
    scanf("%f",&V);
    if ((r3-r2)<=0) {
        for (i=1; i<=n; i++) {
            float R, i_max, i_ant;
            do {
                printf("Enter value of resistor: ");
                scanf("%f",&R);
                if (R<r1 || R>r4) {
                    printf("Value of resistor must be at (%f , %f)U(%f , %f)\n",r1,r2,r3,r4);
                }
            } while (R<r1 || R>r4);
            printf("Give maximum intensity: ");
            scanf("%f",&i_max);
            i_ant=(V/R);
            if (i_ant<i_max) {
                if (R>=r3 && R<=r2) {
                    if (k%2) {
                        r1_r2++;
                        R1ol+=R;
                        k++;
                    }
                    else {
                        r3_r4++;
                        R2ol+=(1/R);
                        k++;
                    }
                }
            }
            else if (R>r2 && R<=r4) {
                    r3_r4++;
                    R2ol+=(1/R);
            }
            else {
                    r1_r2++;
                    R1ol+=R;
            }
        }
    }
    else {
        for(i=1; i<=n; i++) {
            float R, i_max, i_ant;
            int k=1;

            do {
            printf("Enter value of resistor: ");
            scanf("%f",&R);
            if (R<r1 || R>r4) {
                printf("Value must be at (%f , %f)U(%f , %f)\n",r1,r2,r3,r4);
          }
          } while (R<r1 || R>r4);

            printf("Give maximum intensity: ");
            scanf("%f",&i_max);
            i_ant=V/R;

            if (i_ant<i_max) {
                if (R>=r1 && R<=r2) {
                    r1_r2++;
                    R1ol+=R;
                }
                else {
                    r3_r4++;
                    R2ol+=(1/R);
                }
            }
        }
    }
    printf("Team 1 has %d resistors.\n",r1_r2);
    printf("Team 2 has %d resistors.\n",r3_r4);
    printf("Total resistor of team 1 is:%f Ohm\n",R1ol);
    if (R2ol!=0)
    printf("Total resistor of team 2 is:%f Ohm\n\n",(1/R2ol));
    else
    printf("Total resistor of team 2 is:0 Ohm\n\n");
    return 0;
}
