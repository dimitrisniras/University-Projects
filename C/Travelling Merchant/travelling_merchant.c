#include <stdio.h>
#include <stdlib.h>

void next_vertex(int **connection,float **weights,int *degree,int kor_ek,int n,int *T,float sum_weight);

int main()
{
    int i, j, n, kor_ek, **connection, *degree, *T;
    float **weights, sum_weight=0;

    printf("Enter tops: ");
    scanf("%d",&n);
    if ((degree=(int *)malloc(n*sizeof(int)))==NULL) {
        printf("Not enough memory in position 1.\n");
        exit(1);
    }
    if ((connection=(int **)malloc(n*sizeof(int *)))==NULL) {
        printf("Not enough memory in position 2.\n");
        exit(2);
    }
    if ((weights=(float **)malloc(n*sizeof(float *)))==NULL) {
        printf("Not enough memory in position 3.\n");
        exit(3);
    }
    for (i=0; i<n; i++) {
        printf("Enter rank of top %d : ",i);
        scanf("%d",&degree[i]);
        if ((connection[i]=(int *)malloc(degree[i]*sizeof(int)))==NULL) {
            printf("Not enough memory in position 4.\n");
            exit(4);
        }
        if ((weights[i]=(float *)malloc(degree[i]*sizeof(float)))==NULL) {
            printf("Not enough memory in position 5.\n");
            exit(5);
        }
    }
    if ((T=(int *)malloc(n*sizeof(int)))==NULL) {
        printf("Not enough memory in position 6.\n");
        exit(6);
    }
    for (i=0; i<n; i++) {
        printf("Enter id of tops that connect with top %d.\n",i);
        for (j=0; j<degree[i]; j++)
            scanf("%d",&connection[i][j]);
    }
    for (i=0; i<n; i++) {
        printf("Enter acme's weights that connect top %d.\n",i);
        for (j=0; j<degree[i]; j++)
            scanf("%f",&weights[i][j]);
    }
    printf("Enter start top: ");
    scanf("%d",&kor_ek);
    printf("Dtart top %d. ",kor_ek);
    printf("Path %d ",kor_ek);
    T[kor_ek]=1;
    next_vertex(connection,weights,degree,kor_ek,n,T,sum_weight);
    free(degree);
    free(connection);
    free(weights);
    free(T);

    return 0;
}

void next_vertex(int **connection,float **weights,int *degree,int kor_ek,int n,int *T,float sum_weight)
{
    int i, j, sum=0, counter=0, temp;
    float min_weight=1000000;

    for (j=0; j<degree[kor_ek]; j++) {
        if (connection[kor_ek][j]!=-1){
            if (weights[kor_ek][j]<min_weight) {
                min_weight=weights[kor_ek][j];
                temp=connection[kor_ek][j];
            }
        }
    }
    sum_weight+=min_weight;
    for (i=0; i<n; i++) {
        for (j=0; j<degree[i]; j++) {
            if (connection[i][j]==kor_ek) {
                connection[i][j]=-1;
            }
        }
    }
    T[temp]=1;
    kor_ek=temp;
    printf("%d ",kor_ek);
    for (j=0; j<degree[kor_ek]; j++) {
        sum+=connection[kor_ek][j];
    }
    for (i=0; i<n; i++) {
        if (T[i]==1) {
            counter++;
        }
    }
    if (counter==n) {
        printf(". Cost %f. ",sum_weight);
        printf("Path completed.\n");
    }
    else if (sum==(-1)*degree[kor_ek]) {
        printf(". Cost %f. ",sum_weight);
        printf("Path didn't completed.\n");
    }
    else
        next_vertex(connection,weights,degree,kor_ek,n,T,sum_weight);

}
