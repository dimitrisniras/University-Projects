#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>

struct timeval startwtime, endwtime;
double seq_time;

struct block {
    int q_cnt;
    int c_cnt;
    int *Q_new;
    int *C_new;
};

void id_check(int i, int j,int a, double *min, double **Q, double **C, struct block *blocks, int *ids);
void table_print(int N, double **Q, double **C);
void id_print(int N, int *ids);
void blocks_print(int n, int m, int k, struct block *blocks, double **Q, double **C);
void error_check (int N, double **Q, double **C, int *ids);

int main(int argc, char **argv)
{
    int N = 1<<atoi(argv[1]);
    int n = 1<<atoi(argv[2]);
    int m = 1<<atoi(argv[3]);
    int k = 1<<atoi(argv[4]);
    int i, j, a, b, c;
    int cnt, pointer;
    double x_d, x_u, y_d, y_u, z_d, z_u;
    double min, dis;
    double x_dis, y_dis, z_dis;

    time_t t;
    srand((unsigned) time(&t));

    double** Q = (double **) malloc (N * sizeof(double *));
    double** C = (double **) malloc (N * sizeof(double *));
    int* ids = (int *) malloc (N * sizeof(int));
    struct block *blocks = (struct block *) malloc ((k*m*n) * sizeof(struct block));

    for (i=0; i<N; i++) {
        Q[i] = (double *) malloc(3 * sizeof(double));
        C[i] = (double *) malloc(3 * sizeof(double));
    }

    for (i=0; i<N; i++) {
        for (j=0; j<3; j++) {
            Q[i][j] = (((long double)rand()+1)/((long double)RAND_MAX+1));
            C[i][j] = (((long double)rand()+1)/((long double)RAND_MAX+1));
        }
    }

    for (i=0; i<(k*m*n); i++) {
        blocks[i].q_cnt = 0;
        blocks[i].c_cnt = 0;
    }

	gettimeofday (&startwtime, NULL);

    for (i=0; i<N; i++) {
        cnt = 0;
        pointer = 0;
        for (a=0; a<n; a++) {
            for (b=0; b<m; b++) {
                for (c=0; c<k; c++) {
                    z_d = (double)c/k;
                    z_u = (double)(c+1)/k;
                    y_d = (double)b/m;
                    y_u = (double)(b+1)/m;
                    x_d = (double)a/n;
                    x_u = (double)(a+1)/n;

                    if (z_d<=Q[i][2] && Q[i][2]<=z_u && y_d<=Q[i][1] && Q[i][1]<=y_u && x_d<=Q[i][0] && Q[i][0]<=x_u) {
                        if (blocks[cnt].q_cnt == 0) {
                            blocks[cnt].Q_new = (int *) malloc (sizeof(int));
                            blocks[cnt].Q_new[blocks[cnt].q_cnt] = i;
                            blocks[cnt].q_cnt++;
                        } else {
                            blocks[cnt].Q_new = (int *) realloc (blocks[cnt].Q_new, (blocks[cnt].q_cnt + 1)*sizeof(int));
                            blocks[cnt].Q_new[blocks[cnt].q_cnt] = i;
                            blocks[cnt].q_cnt++;
                        }
                        pointer++;
                    }

                    if (z_d<=C[i][2] && C[i][2]<=z_u && y_d<=C[i][1] && C[i][1]<=y_u && x_d<=C[i][0] && C[i][0]<=x_u) {
                        if (blocks[cnt].c_cnt == 0) {
                            blocks[cnt].C_new = (int *) malloc (sizeof(int));
                            blocks[cnt].C_new[blocks[cnt].c_cnt] = i;
                            blocks[cnt].c_cnt++;
                        } else {
                            blocks[cnt].C_new = (int *) realloc (blocks[cnt].C_new, (blocks[cnt].c_cnt + 1)*sizeof(int));
                            blocks[cnt].C_new[blocks[cnt].c_cnt] = i;
                            blocks[cnt].c_cnt++;
                        }
                        pointer++;
                    }
                    cnt++;
                    if (pointer == 2) break;
                }
                if (pointer == 2) break;
            }
            if (pointer == 2) break;
        }
    }

    for (i=0; i<(n*m*k); i++) {
        for (a=0; a<blocks[i].q_cnt; a++) {
            min = 10000;
            for (b=0; b<blocks[i].c_cnt; b++) {
                x_dis = pow((Q[blocks[i].Q_new[a]][0] - C[blocks[i].C_new[b]][0]),2);
                y_dis = pow((Q[blocks[i].Q_new[a]][1] - C[blocks[i].C_new[b]][1]),2);
                z_dis = pow((Q[blocks[i].Q_new[a]][2] - C[blocks[i].C_new[b]][2]),2);
                dis = sqrt(x_dis + y_dis + z_dis);
                if (dis < min) {
                    min = dis;
                    ids[blocks[i].Q_new[a]+1] = blocks[i].C_new[b];
                }
            }

            /* checks for upper neighbors */
            if (((i+1) % k) != 0) {
                id_check(i, i+1, a, &min, Q, C, blocks, ids); // checks for upper neighbor
                if ((i+1+k) < n*m*k) id_check(i, (i+1+k), a, &min, Q, C, blocks, ids); // checks for upper back neighbor
                if ((i+1-k) >= 0) id_check(i, (i+1-k), a, &min, Q, C, blocks, ids); // checks for upper front neighbor

                // checks for upper left neighbors
                if ((i+1-(k*m)) >= 0) {
                    id_check(i, (i+1-(k*m)), a, &min, Q, C, blocks, ids); // checks for upper left neighbor
                    if ((i+1-(k*m)-k) >= 0) id_check(i, (i+1-(k*m)-k), a, &min, Q, C, blocks, ids); // checks for upper left front neighbor
                    if ((i+1-(k*m)+k) < n*m*k) id_check(i, (i+1-(k*m)+k), a, &min, Q, C, blocks, ids); // checks for upper left back neighbor
                }

                // checks for upper right neighbors
                if ((i+1+(k*m)) < k*m*n) {
                    id_check(i, (i+1+(k*m)), a, &min, Q, C, blocks, ids); // // checks for upper right neighbor
                    if ((i+1+(k*m)-k) >= 0) id_check(i, (i+1+(k*m)-k), a, &min, Q, C, blocks, ids); // checks for upper right front neighbor
                    if ((i+1+(k*m)+k) < n*m*k) id_check(i, (i+1+(k*m)+k), a, &min, Q, C, blocks, ids); // checks for upper right back neighbor
                }
            }

            /* checks for bottom neighbors */
            if ((i % k) != 0) {
                id_check(i, i-1, a, &min, Q, C, blocks, ids); // checks for bottom neighbor
                if ((i-1+k) < n*m*k) id_check(i, (i-1+k), a, &min, Q, C, blocks, ids); // checks for bottom back neighbor
                if ((i-1-k) >= 0) id_check(i, (i-1-k), a, &min, Q, C, blocks, ids); // checks for bottom front neighbor

                // checks for bottom left neighbors
                if ((i-1-(k*m)) >= 0) {
                    id_check(i, (i-1-(k*m)), a, &min, Q, C, blocks, ids); // checks for bottom left neighbor
                    if ((i-1-(k*m)-k) >= 0) id_check(i, (i-1-(k*m)-k), a, &min, Q, C, blocks, ids); // checks for bottom left front neighbor
                    if ((i-1-(k*m)+k) < n*m*k) id_check(i, (i-1-(k*m)+k), a, &min, Q, C, blocks, ids); // checks for bottom left back neighbor
                }

                // checks for bottom right neighbors
                if ((i-1+(k*m)) < k*m*n) {
                    id_check(i, (i-1+(k*m)), a, &min, Q, C, blocks, ids); // // checks for bottom right neighbor
                    if ((i-1+(k*m)-k) >= 0) id_check(i, (i-1+(k*m)-k), a, &min, Q, C, blocks, ids); // checks for bottom right front neighbor
                    if ((i-1+(k*m)+k) < n*m*k) id_check(i, (i-1+(k*m)+k), a, &min, Q, C, blocks, ids); // checks for bottom right back neighbor
                }
            }

            /* checks for same level neighbors */

            // checks for left neighbors
            if (i-(k*m) >= 0) {
                id_check(i, (i-(k*m)), a, &min, Q, C, blocks, ids); // checks for left neighbor
                if ((i-(k*m)-k) >= 0) id_check(i, (i-(k*m)-k), a, &min, Q, C, blocks, ids); // checks for left front neighbor
                if ((i-(k*m)+k) < n*m*k) id_check(i, (i-(k*m)+k), a, &min, Q, C, blocks, ids); // checks for left back neighbor
            }

            // checks for right neighbors
            if (i+(k*m) < n*m*k) {
                id_check(i, (i+(k*m)), a, &min, Q, C, blocks, ids); // checks for right neighbor
                if ((i+(k*m)-k) >= 0) id_check(i, (i+(k*m)-k), a, &min, Q, C, blocks, ids); // checks for right front neighbor
                if ((i+(k*m)+k) < n*m*k) id_check(i, (i+(k*m)+k), a, &min, Q, C, blocks, ids); // checks for right back neighbor
            }

            if ((i-k) >= 0) id_check(i, (i-k), a, &min, Q, C, blocks, ids); // checks for front neighbor
            if ((i+k) < n*m*k) id_check(i, (i+k), a, &min, Q, C, blocks, ids); // checks for back neighbor
        }
    }

    gettimeofday (&endwtime, NULL);
    seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);

    printf("\nComplete time = %f\n",seq_time);

    //table_print(N,Q,C);
    //blocks_print(n,m,k,blocks,Q,C);
    //id_print(N, ids);
    error_check(N,Q,C,ids);

    return 0;
}

void id_check(int i, int j,int a, double *min, double **Q, double **C, struct block *blocks, int *ids) {
    int b;
    double x_dis, y_dis, z_dis, dis;

    for (b=0; b<blocks[j].c_cnt; b++) {
        x_dis = pow((Q[blocks[i].Q_new[a]][0] - C[blocks[j].C_new[b]][0]),2);
        y_dis = pow((Q[blocks[i].Q_new[a]][1] - C[blocks[j].C_new[b]][1]),2);
        z_dis = pow((Q[blocks[i].Q_new[a]][2] - C[blocks[j].C_new[b]][2]),2);
        dis = sqrt(x_dis + y_dis + z_dis);
        if (dis < *min) {
            *min = dis;
            ids[blocks[i].Q_new[a]+1] = blocks[j].C_new[b];
        }
    }
}

void error_check (int N, double **Q, double **C, int *ids) {
    int i, j, cnt=0;
    double min, dis;

    int* ids_bf = (int *) malloc (N * sizeof(int));
    gettimeofday (&startwtime, NULL);
    min = 1000;
    for (i=0; i<N; i++) {
        for (j=0; j<N; j++) {
            dis = sqrt(pow((Q[i][0] - C[j][0]),2) + pow((Q[i][1] - C[j][1]),2) + pow((Q[i][2] - C[j][2]),2));
            if (dis < min) {
                min = dis;
                ids_bf[i+1] = j;
            }
        }
        min = 1000;
    }
    gettimeofday (&endwtime, NULL);
    seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);

    printf("Brute force complete time = %f\n",seq_time);

    for (i=1; i<=N; i++) {
        if (ids[i] == ids_bf[i]) cnt++;
    }

    //id_print(N,ids_bf);

    if (cnt == N) printf("kNN was succesful!\n");
    else printf("kNN has failed!\n");
}

void table_print(int N, double **Q, double **C) {
    int i, j;

    printf("\n--------- Q Table ---------\n");
    for(j=0; j<3; j++) {
        for (i=0; i<N; i++) {
            printf("%f   ",Q[i][j]);
        }
        printf("\n");
    }

    printf("\n\n--------- C Table ---------\n");
    for(j=0; j<3; j++) {
        for (i=0; i<N; i++) {
            printf("%f   ",C[i][j]);
        }
        printf("\n");
    }
}

void id_print(int N, int *ids) {
    int i;

    printf("\n\n---------- IDs Array ----------\n");
    for (i=1; i<=N; i++) {
        printf("%d\n",ids[i]);
    }
}

void blocks_print(int n, int m, int k, struct block *blocks, double **Q, double **C) {
    int i, j, z;

    for (i=0; i<(n*m*k); i++) {
        printf("\n\n--------Q SubTable %d--------\n",i+1);
        for (j=0; j<3; j++) {
            for (z=0; z<blocks[i].q_cnt; z++) {
                printf("%f   ",Q[blocks[i].Q_new[z]][j]);
            }
            printf("\n");
        }
    }

    for (i=0; i<(n*m*k); i++) {
        printf("\n\n--------C SubTable %d--------\n",i+1);
        for (j=0; j<3; j++) {
            for (z=0; z<blocks[i].c_cnt; z++) {
                printf("%f   ",C[blocks[i].C_new[z]][j]);
            }
            printf("\n");
        }
    }
}
