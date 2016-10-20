#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include <cuda.h>

int n, w;
float p;
float *A, *dist;

void makeAdjency();
void warshallFloyd();
void print_tables(float *table);
void error_check(float *dist, float *cdist);
void cwf1();
void cwf2();
void cwf3();
__global__ void cuda1(int n, int k, float *cA);
__global__ void cuda2(int n, int k, float *cA);
__global__ void cuda3(int n, int k, float *cA, int elements);

int main(int argc, char** argv)
{
	n = 1<<atoi(argv[1]);
	p = atof(argv[2]);
	w = atoi(argv[3]);
    time_t t;
    
    srand((unsigned)time(&t));
	
    A = (float *) malloc (n*n*sizeof(float));
    dist = (float *) malloc (n*n*sizeof(float));

    makeAdjency();
    warshallFloyd();
    cwf1();
    cwf2();
    cwf3();
    
    printf("\n");
    free(A);
    free(dist);
    
    return 0;
}

void makeAdjency() {
    int i, j;
	double r;

    for (i=0; i<n; i++) {
        for (j=0; j<n; j++) {
            A[i*n + j] = 0;
            dist[i*n + j] =0;
        }
    }

    for (i=0; i<n; i++) {
        for (j=0; j<n; j++) {
			r = (((double)rand()+1)/((double)RAND_MAX+1));
            if (r > p) {
                A[i*n + j] = INFINITY;
                dist[i*n + j] = A[i*n + j];
            }
            else {
                A[i*n + j] = r * w;
                dist[i*n + j] = A[i*n + j];
            }
        }
        A[i*n + i] = 0;
        dist[i*n + i] = 0;
    }

}

void warshallFloyd() {
    int i, j, k;
    double seq_time;
    struct timeval startwtime, endwtime;

    gettimeofday (&startwtime, NULL);
    for (k=0; k<n; k++) {
        for (i=0; i<n; i++) {
            for (j=0; j<n; j++) {
                if ( dist[i*n + j] > dist[i*n + k] + dist[k*n + j] )
                    dist[i*n + j] = dist[i*n + k] + dist[k*n + j];
            }
        }
    }

    gettimeofday (&endwtime, NULL);
    seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
    printf("\n---- n = %d  p = %.2f  w = %d ----\n",n,p,w);
    printf("\nSerial complete time = %f s\n",seq_time);
    
}

__global__ void cuda1(int n, int k, float *cA) {
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	int j = blockIdx.y*blockDim.y + threadIdx.y;
	
	if ( cA[i*n + j] > cA[i*n + k] + cA[k*n + j] ) {
		cA[i*n + j] = cA[i*n + k] + cA[k*n + j];
	}
    
}

__global__ void cuda2(int n, int k, float *cA) {
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	int j = blockIdx.y*blockDim.y + threadIdx.y;
	
	extern __shared__ float s[];
	float *ci = s;
	ci[threadIdx.x] = cA[i*n + k];
	
	if ( cA[i*n + j] > ci[threadIdx.x] + cA[k*n + j] ) {
		cA[i*n + j] = ci[threadIdx.x] + cA[k*n + j];
	}
	
}

__global__ void cuda3(int n, int k, float *cA, int elements) {
	int l, m;
	int p = 0, r = 0;
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	int j = blockIdx.y*blockDim.x + threadIdx.y;
	
	extern __shared__ float s[];
	float *ci = s;
	float *ck = (float *)&ci[blockDim.x*elements];
	
	for (l=i*elements; l<(i*elements) + elements; l++) {
		ci[threadIdx.x*elements + p] = cA[l*n + k];
		p++;
	}
	p = 0;
	
	for (m=j*elements; m<(j*elements) + elements; m++) {
		ck[threadIdx.y*elements + r] = cA[k*n + m];
		r++;
	}
	r = 0;
	
	__syncthreads();
	
	for (l=i*elements; l<(i*elements) + elements; l++) {
		for (m=j*elements; m<(j*elements) + elements; m++) {
			if ( cA[l*n + m] > ci[threadIdx.x*elements + p] + ck[threadIdx.y*elements + r] ) {
				cA[l*n + m] = ci[threadIdx.x*elements + p] + ck[threadIdx.y*elements + r];
			}
			r++;
		}
		r = 0;
		p++;
	}
	
}

void cwf1() {
	float *cA, milliseconds;
	cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    float *dist1 = (float *) malloc (n*n*sizeof(float));
    
    cudaMalloc( (void **) &cA, n*n*sizeof(float) );
	cudaEventRecord(start);
    cudaMemcpy(cA, A, n*n*sizeof(float), cudaMemcpyHostToDevice);

	if ( n <= 8 ) {
    	dim3 threadsPerBlock(n, n);
    	int numBlocks = 1;
    	
    	for (int k=0; k<n; k++) {
    		cuda1<<<numBlocks,threadsPerBlock>>>(n,k,cA);
    	}
    }
    else {
    	dim3 threadsPerBlock(8, 8); 
    	dim3 numBlocks(n/threadsPerBlock.x, n/threadsPerBlock.y);
    	
    	for (int k=0; k<n; k++) {
    		cuda1<<<numBlocks,threadsPerBlock>>>(n,k,cA);
    	}
	}
    
    cudaMemcpy(dist1, cA, n*n*sizeof(float), cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&milliseconds, start, stop);
    
    printf("\nCUDA1 complete time = %f s\n",milliseconds/1000);
    
    error_check(dist,dist1);
    
    cudaFree(cA);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    free(dist1);
}

void cwf2() {
	float *cA, milliseconds;
	cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    float *dist2 = (float *) malloc (n*n*sizeof(float));
    
    cudaMalloc( (void **) &cA, n*n*sizeof(float) );
	cudaEventRecord(start);
    cudaMemcpy(cA, A, n*n*sizeof(float), cudaMemcpyHostToDevice);

    if ( n <= 8 ) {
    	dim3 threadsPerBlock(n, n);
    	int numBlocks = 1;
    	size_t size = threadsPerBlock.x*sizeof(float);
    	
    	for (int k=0; k<n; k++) {
			cuda2<<<numBlocks,threadsPerBlock,size>>>(n,k,cA);
    	}
    }
    else {
    	dim3 threadsPerBlock(8, 8); 
    	dim3 numBlocks(n/threadsPerBlock.x, n/threadsPerBlock.y);
    	size_t size = threadsPerBlock.x*sizeof(float);
    	
    	for (int k=0; k<n; k++) {
    		cuda2<<<numBlocks,threadsPerBlock,size>>>(n,k,cA);
    	}
	}
    
    cudaMemcpy(dist2, cA, n*n*sizeof(float), cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&milliseconds, start, stop);
    
    printf("\nCUDA2 complete time = %f s\n",milliseconds/1000);
    
    error_check(dist,dist2);
    
    cudaFree(cA);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    free(dist2);
}

void cwf3() {
	int elements = 4;
	float *cA, milliseconds;
	cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    float *dist3 = (float *) malloc (n*n*sizeof(float));
    
    cudaMalloc( (void **) &cA, n*n*sizeof(float) );
	cudaEventRecord(start);
    cudaMemcpy(cA, A, n*n*sizeof(float), cudaMemcpyHostToDevice);
    
    if ( n <= (8*elements) ) {
    	dim3 threadsPerBlock(n/elements, n/elements);
    	int numBlocks = 1;
    	size_t size = (threadsPerBlock.x*elements)*sizeof(float) + (threadsPerBlock.y*elements)*sizeof(float);
    	
    	for (int k=0; k<n; k++) {
    		cuda3<<<numBlocks,threadsPerBlock,size>>>(n,k,cA,elements);
    	}
    }
    else {
        dim3 threadsPerBlock(8, 8);
    	dim3 numBlocks(n/(threadsPerBlock.x*elements), n/(threadsPerBlock.y*elements));
    	size_t size = (threadsPerBlock.x*elements)*sizeof(float) + (threadsPerBlock.y*elements)*sizeof(float);
    		
    	for (int k=0; k<n; k++) {
    		cuda3<<<numBlocks,threadsPerBlock,size>>>(n,k,cA,elements);
    	}
	}
    
    cudaMemcpy(dist3, cA, n*n*sizeof(float), cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&milliseconds, start, stop);
    
    printf("\nCUDA3 complete time = %f s\n",milliseconds/1000);
    
    error_check(dist,dist3);
    
    cudaFree(cA);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    free(dist3);
}

void error_check(float *dist, float *cdist) {
	int i;
	int flag = 0;
	
	for (i=0; i<n*n; i++) {
		if (dist[i] != cdist[i]) {
			printf("CUDA Warshall Floyd was failed!\n");
			flag = 1;
			break;
		}
	}
	
	if (flag == 0) printf("CUDA Warshall Floyd was succesful!\n");
	
}

void print_tables(float *table) {
    int i, j;
    
    for (j=0; j<n; j++) {
    	for (i=0; i<n; i++) {
    		printf("%f  ",table[i*n + j]);
    	}
    	printf("\n");
    }

    printf("\n\n");
}

