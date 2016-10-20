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
        printf("Dwse timh gia thn r1: ");
        scanf("%f",&r1);
        printf("Dwse timh gia thn r2: ");
        scanf("%f",&r2);
        printf("Dwse timh gia thn r3: ");
        scanf("%f",&r3);
        printf("Dwse timh gia thn r4: ");
        scanf("%f",&r4);
        if (r1>=r3) {
            printf("Prepei r1<r3\n");
        }
        if (r2>=r4) {
            printf("Prepei r2<r4\n");
        }
    } while(r1>=r3 || r2>=r4);

    do {
        printf("Dwse timh gia to apothema twn antistasewn: ");
        scanf("%d",&n);
        if (n<=0) {
            printf("To apo8ema twn antistasewn prepei na einai 8etiko!\n");
        }
    } while (n<=0);
    printf("Dwse timh gia thn tash V tou susthmatos: ");
    scanf("%f",&V);
    if ((r3-r2)<=0) {
        for (i=1; i<=n; i++) {
            float R, i_max, i_ant;
            do {
                printf("Dwse timh gia thn antistash: ");
                scanf("%f",&R);
                if (R<r1 || R>r4) {
                    printf("H timh ths antistashs prepei na brisketai sto sunolo (%f , %f)U(%f , %f)\n",r1,r2,r3,r4);
                }
            } while (R<r1 || R>r4);
            printf("Dwse timh gia th megisth entash pou diarreei thn antistash: ");
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
            printf("Dwse timh gia thn antistash: ");
            scanf("%f",&R);
            if (R<r1 || R>r4) {
                printf("H timh ths antistashs prepei na brisketai sto sunolo (%f , %f)U(%f , %f)\n",r1,r2,r3,r4);
          }
          } while (R<r1 || R>r4);

            printf("Dwse timh gia th megisth entash pou diarreei thn antistash: ");
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
    printf("H omada 1 perilambanei %d antistaseis.\n",r1_r2);
    printf("H omada 2 perilambanei %d antistaseis.\n",r3_r4);
    printf("H olikh antistash ths omadas 1 einai:%f Ohm\n",R1ol);
    if (R2ol!=0)
    printf("H olikh antistash ths omadas 2 einai:%f Ohm\n\n",(1/R2ol));
    else
    printf("H olikh antistash ths omadas 2 einai:0 Ohm\n\n");
    return 0;
}
