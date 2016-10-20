#include <stdio.h>
#define MAX 100

int main()
{
    int i,j,N,kor_ek,temp,sum,adj[MAX][MAX],T[MAX],counter;
    float sum_weight=0,min_weight,weight[MAX][MAX];

    do {
        printf("Enter number of tops: ");
        scanf("%d",&N);
        if (N<=0 || N>MAX)
            printf("Number of tops must be at (0,%d)\n",MAX);
    } while (N<=0 || N>MAX);

    for (i=0; i<N; i++){
        for (j=0; j<N; j++) {
            if (i==j)
                adj[i][j]=0;
            else {
                do {
                    printf("Give value 1 if there is a acme that connects top %d with top %d,\n",i,j);
                    printf("or else give 0: ");
                    scanf("%d",&adj[i][j]);
                    if (adj[i][j]!=1 && adj[i][j]!=0)
                        printf("Value must be 0 or 1!\n");
                } while(adj[i][j]!=1 && adj[i][j]!=0);
            }
            if (adj[i][j]==1) {
                printf("Enter weight of acme that connects top %d with %d: ",i,j);
                scanf("%f",&weight[i][j]);
            }
        }
    }

    do {
        printf("Enter start top: ");
        scanf("%d",&kor_ek);
        if (kor_ek<0 || kor_ek>=N)
            printf("Start top must be in bounds 0 and %d.",N-1);
    } while (kor_ek<0 || kor_ek>=N);

    printf("Start top: %d\n",kor_ek);
    printf("Path: %d",kor_ek);
    T[kor_ek]=1;

    do {
        sum=0;
        counter=0;
        min_weight=100000;
        for (j=0; j<N; j++) {
            if (adj[kor_ek][j]==1) {
                if (weight[kor_ek][j]<min_weight) {
                    min_weight=weight[kor_ek][j];
                    temp=j;
                }
            }
        }
        T[temp]=1;
        sum_weight+=min_weight;
        adj[kor_ek][temp]=0;
        adj[temp][kor_ek]=0;
        kor_ek=temp;
        printf(",%d",kor_ek);
        for (j=0; j<N; j++) {
            sum+=adj[kor_ek][j];
        }
        for (i=0; i<N; i++) {
            if (T[i]==1)
                counter+=1;
        }
    } while (sum!=0 && counter<N);

    if (sum!=0)
        printf(". The route was completed with weight %f .",sum_weight);
    else
        printf(". Route did not completed.");

    return 0;
}

