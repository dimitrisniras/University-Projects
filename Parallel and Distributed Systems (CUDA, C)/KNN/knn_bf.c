#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>

struct timeval startwtime, endwtime;
double seq_time;

void table_print(int N, float **Q, float **C);
void id_print(int N, int *ids);

int main(int argc, char **argv)
{
    int N = 1<<atoi(argv[1]);
    int i, j, id;
    double min, dis;

    time_t t;
    srand((unsigned) time(&t));

    float** Q = (float **) malloc (N * sizeof(float *));
    float** C = (float **) malloc (N * sizeof(float *));
    int* ids = (int *) malloc (N * sizeof(int));
    
    for (i=0; i<N; i++) {
        Q[i] = (float *) malloc(3 * sizeof(float));
        C[i] = (float *) malloc(3 * sizeof(float));
    }

    for (i=0; i<N; i++) {
        for (j=0; j<3; j++) {
            Q[i][j] = (((long double)rand()+1)/((long double)RAND_MAX+1));
        }
    }
    
    for (i=0; i<N; i++) {
        for (j=0; j<3; j++) {
            C[i][j] = (((long double)rand()+1)/((long double)RAND_MAX+1));
        }
    }

    min = 1000;
    gettimeofday (&startwtime, NULL);
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            dis = sqrt(pow((Q[i][0] - C[j][0]),2) + pow((Q[i][1] - C[j][1]),2) + pow((Q[i][2] - C[j][2]),2));
            if (dis < min) {
                min = dis;
                id = j;
            }
        }
        min = 1000;
        ids[i] = id;
    }
    gettimeofday (&endwtime, NULL);
    seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);

    printf("Complete time = %f\n",seq_time);
    //table_print(N,Q,C);
    //id_print(N,ids);

    return 0;
}

void table_print(int N, float **Q, float **C) {
    int i, j;

    printf("\n\n--------- Q Table ---------\n\n");
    for(j=0; j<3; j++) {
        for (i=0; i<N; i++) {
            printf("%f   ",Q[i][j]);
            if (i == N-1) printf("\n");
        }
    }

    printf("\n\n--------- S Table ---------\n\n");
    for(j=0; j<3; j++) {
        for (i=0; i<N; i++) {
            printf("%f   ",C[i][j]);
            if (i == N-1) printf("\n");
        }
    }
}

void id_print(int N, int *ids) {
    int i;

    printf("\n\n---------- IDs Array ----------\n\n");
    for (i=0; i<N; i++) {
        printf("%d\n",ids[i]);
    }
}
