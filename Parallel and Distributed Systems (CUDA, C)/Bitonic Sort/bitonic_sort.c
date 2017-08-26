#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <pthread.h>
#include <omp.h>
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>

struct timeval startwtime, endwtime;
double seq_time;


int q,p;                  // data array and threads size
int *a;                   // data array to be sorted
int active_threads = 0;   // number of active threads
pthread_mutex_t counter;  // mutex id to protect active_threads counter

const int ASCENDING  = 1;
const int DESCENDING = 0;


void init(void);
void print(void);
void sort(void);
void test(void);
inline void exchange(int i, int j);
void compare(int i, int j, int dir);
void bitonicMerge(int lo, int cnt, int dir);
void recBitonicSort(int lo, int cnt, int dir);
void impBitonicSort(void);
void parallel_sort();
void* par_bitonicMerge(void* args);
void* par_recBitonicSort(void* args);
void parallel_impBitonicSort();
void cilk_impBitonicSort();

/** compare function for quick sort in asceding order **/
int ascending (const void *a , const void *b) {
	return (*(int *)a - *(int *)b);
}

/** compare function for quick sort in desceding order **/
int descending (const void *a , const void *b) {
	return (*(int *)b - *(int *)a);
}

/** the main program **/ 
int main(int argc, char **argv) {

  if (argc !=3 || atoi(argv[1])>30 || atoi(argv[2])>8) {
    printf("You've got to put 2 parametres, one for array size that is smaller from 24 and one for threads number that is smaller from 8!\n");
    exit(1);
  }

  q = 1<<atoi(argv[1]);    // data array size which is 2^argv[1] (power of two)
  p = 1<<atoi(argv[2]);    // threads number that actually is 2^argv[2] (power of two)
  
  printf("Array size q is %d .\n",q);
  printf("Threads size p is %d .\n\n",p);
  
  a = (int *) malloc(q * sizeof(int));
  
  init();
  gettimeofday (&startwtime, NULL);
  impBitonicSort();
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Imperative wall clock time = %f\n", seq_time);
  test();

  init();
  gettimeofday (&startwtime, NULL);
  sort();
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Recursive wall clock time = %f\n", seq_time);
  test();
  
  init();
  gettimeofday (&startwtime, NULL);
  qsort(a , q , sizeof(int) , ascending);
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Quick sort wall clock time = %f\n", seq_time);
  test();
  
  init();
  gettimeofday (&startwtime, NULL);
  parallel_sort();
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Parallel recursive Pthreads wall clock time = %f\n", seq_time);
  test();
  
  init();
  gettimeofday (&startwtime, NULL);
  parallel_impBitonicSort();
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Parallel imperative OpenMP wall clock time = %f\n", seq_time);
  test();
  
  init();
  gettimeofday (&startwtime, NULL);
  cilk_impBitonicSort();
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6 + endwtime.tv_sec - startwtime.tv_sec);
  printf("Parallel imperative Cilk wall clock time = %f\n", seq_time);
  test();
}

/** -------------- SUB-PROCEDURES  ----------------- **/ 

/** procedure test() : verify sort results **/
void test() {
  int pass = 1;
  int i;
  for (i = 1; i < q; i++) {
    pass &= (a[i-1] <= a[i]);
  }

  printf(" TEST %s\n",(pass) ? "PASSed" : "FAILed");
}

/** procedure init() : initialize array "a" with data **/
void init() {
  int i;
  for (i = 0; i < q; i++) {
    a[i] = rand() % q; // (q - i);
  }
}

/** procedure  print() : print array elements **/
void print() {
  int i;
  for (i = 0; i < q; i++) {
    printf("%d\n", a[i]);
  }
  printf("\n");
}

/** INLINE procedure exchange() : pair swap **/
inline void exchange(int i, int j) {
  int t;
  t = a[i];
  a[i] = a[j];
  a[j] = t;
}

/** procedure compare() 
   The parameter dir indicates the sorting direction, ASCENDING 
   or DESCENDING; if (a[i] > a[j]) agrees with the direction, 
   then a[i] and a[j] are interchanged.
**/
inline void compare(int i, int j, int dir) {
  if (dir==(a[i]>a[j])) 
    exchange(i,j);
}

/** Procedure bitonicMerge() 
   It recursively sorts a bitonic sequence in ascending order, 
   if dir = ASCENDING, and in descending order otherwise. 
   The sequence to be sorted starts at index position lo,
   the parameter cbt is the number of elements to be sorted. 
 **/
void bitonicMerge(int lo, int cnt, int dir) {
  if (cnt>1) {
    int k=cnt/2;
    int i;
    for (i=lo; i<lo+k; i++)
      compare(i, i+k, dir);
    bitonicMerge(lo, k, dir);
    bitonicMerge(lo+k, k, dir);
  }
}

/** function recBitonicSort() 
    first produces a bitonic sequence by recursively sorting 
    its two halves in opposite sorting orders, and then
    calls bitonicMerge to make them in the same order 
 **/
void recBitonicSort(int lo, int cnt, int dir) {
  if (cnt>1) {
    int k=cnt/2;
    recBitonicSort(lo, k, ASCENDING);
    recBitonicSort(lo+k, k, DESCENDING);
    bitonicMerge(lo, cnt, dir);
  }
}

/** function sort() 
   Caller of recBitonicSort for sorting the entire array of length N 
   in ASCENDING order
 **/
void sort() {
  recBitonicSort(0, q, ASCENDING);
}

/*
  imperative version of bitonic sort
*/
void impBitonicSort() {

  int i,j,k;
  
  for (k=2; k<=q; k=2*k) {
    for (j=k>>1; j>0; j=j>>1) {
      for (i=0; i<q; i++) {
	int ij=i^j;
	if ((ij)>i) {
	  if ((i&k)==0 && a[i] > a[ij]) 
	      exchange(i,ij);
	  if ((i&k)!=0 && a[i] < a[ij])
	      exchange(i,ij);
	}
      }
    }
  }
}

/** struct for input parameters in pthreads **/
typedef struct{
	int lo , cnt , dir;
}params;

/** parrallel bitonic merge having same philosophy as serial but using pthreads **/
void* par_bitonicMerge(void* args) {
	int lo = ((params *) args ) -> lo;
	int cnt = ((params *) args) -> cnt;
	int dir = ((params *) args) -> dir;
	
	if (cnt>1) {
		int k = cnt/2;
		int i;
		
		for (i=lo; i<lo+k; i++) 
			compare(i,i+k,dir);
		
		if (active_threads > p - 2) {
			bitonicMerge(lo , k , dir);
			bitonicMerge(lo+k , k , dir);
		}
		else {
			params par1 , par2;
			pthread_t thread3 , thread4;
			par1.lo = lo;
			par1.cnt = k;
			par1.dir = dir;
			par2.lo = lo + k;
			par2.cnt = k;
			par2.dir = dir;

			pthread_mutex_lock (&counter);
			active_threads += 2;
			pthread_mutex_unlock (&counter);

			pthread_create(&thread3 , NULL , par_bitonicMerge , &par1);
			pthread_create(&thread4 , NULL , par_bitonicMerge , &par2);
			
			void* useless;
			pthread_join(thread3 , &useless);
			pthread_join(thread4 , &useless);
		}
	}
}

/** parallel bitonic sort having same philosophy as serial but using pthreads **/
void* par_recBitonicSort(void* args) {
	int lo = ((params *) args ) -> lo;
	int cnt = ((params *) args) -> cnt;
	int dir = ((params *) args) -> dir;
	
	if (cnt>1) {
		int k = cnt/2;
		/*if (active_threads >= p/2) {
			qsort(a + lo , k , sizeof(int) , ascending);
			qsort(a + (lo + k) , k , sizeof(int) , descending);
		}*/
		if (active_threads >= p/2) {
			recBitonicSort(lo , k , ASCENDING);
			recBitonicSort(lo+k , k , DESCENDING);
		}
		else {
			params par1 , par2;
			pthread_t thread1 , thread2;
			par1.lo = lo;
			par1.cnt = k;
			par1.dir = ASCENDING;
			par2.lo = lo + k;
			par2.cnt = k;
			par2.dir = DESCENDING;

			pthread_mutex_lock (&counter);
			active_threads += 2;
			pthread_mutex_unlock (&counter);

			pthread_create(&thread1 , NULL , par_recBitonicSort , &par1);
			pthread_create(&thread2 , NULL , par_recBitonicSort , &par2);
			
			void* useless;
			pthread_join(thread1 , &useless);
			pthread_join(thread2 , &useless);	
		}
		params par;
		par.lo = lo;
		par.cnt = cnt;
		par.dir = dir;
		par_bitonicMerge(&par);
	}
}

/** parallel recursive sorting **/
void parallel_sort() {
	params par;
	par.lo = 0;
	par.cnt = q;
	par.dir = ASCENDING;
	par_recBitonicSort(&par);
}

/** parallel imperative bitonic sort using openMP **/
void parallel_impBitonicSort() {

  int i,j,k;
  
  for (k=2; k<=q; k=2*k) {
	  for (j=k>>1; j>0; j=j>>1) {
		  #pragma omp parallel for num_threads(p) schedule(dynamic , q/p)
			for (i=0; i<q; i++) {
				int ij=i^j;
				if ((ij)>i) {
					if ((i&k)==0 && a[i] > a[ij]) 
						exchange(i,ij);
					if ((i&k)!=0 && a[i] < a[ij])
						exchange(i,ij);
				}
			}
		}
	}
}

/** parallel imperative bitonic sort using CilkPLUS **/
void cilk_impBitonicSort() {

  int i,j,k;
  for (k=2; k<=q; k=2*k) {
	  for (j=k>>1; j>0; j=j>>1) {
		  #pragma cilk grainsize = p
		  cilk_for (i=0; i<q; i++) {
			  int ij=i^j;
			  if ((ij)>i) {
				  if ((i&k)==0 && a[i] > a[ij]) 
					  exchange(i,ij);
				  if ((i&k)!=0 && a[i] < a[ij])
					  exchange(i,ij);
				}
			}
		}
	}
}
