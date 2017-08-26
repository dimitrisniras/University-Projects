//
//		Niras Dimitris
//		AEM: 8057
//		e-mail: diminira@auth.gr
//		Project 1
// 

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/times.h>
#include <sys/time.h>	

int main(int argc, char **argv) {
	int i, pid, status, pd[2], ticks_per_second;
	struct timeval startwtime, endwtime;
	double seq_time, usec, ssec;
	struct tms buf;
	
	char **const params = (char **) malloc ((argc - 1) * sizeof(char *));  // allocate memory for input parameters
	
	/** define parameters for execv from argv **/
	for ( i=1; i<argc; i++ ) 
	{
		params[i-1] = argv[i];
	}
	
	/** checks if pipe is succeed **/
	if ( pipe(pd) < 0 ) 
	{
		printf("\n Can't open pipe! \n");
		exit(-1);
	}
	printf("\n\n");
	pid = fork(); // forking process
	
	if ( pid >= 0 )  // Succesfull fork 
	{
		if ( pid == 0 )  // Child process
		{
			gettimeofday(&startwtime, NULL); // read the current time (start time)
			
			close(pd[0]); // close read channel
			write(pd[1], &startwtime.tv_sec, 4);  // send start time secs
			write(pd[1], &startwtime.tv_usec, 4); // send start time usecs
			close(pd[1]); // close write channel
			
			execv(argv[1],params); // execute command with given parameters
			exit(EXIT_FAILURE); // this line is being executed only if execv fail
		}
		else   // Parent process
		{	
			/** checks if fathers waits for child **/
			if ( wait(&status) == -1) 
			{
				printf(" Wait failed! \n");
				exit(-6);
			}
			
			int sec, usec;
			
			close(pd[1]); // close write channel
			read(pd[0], &sec, 4); // read start time secs
			read(pd[0], &usec, 4); // read start time usecs
			close(pd[0]); // close read channel
					
			gettimeofday (&endwtime, NULL); // read the current time (end time)
			seq_time = (double)((endwtime.tv_usec - usec)/1.0e6 + endwtime.tv_sec - sec);
			
			/** measure CPU times and check if call is succeed **/
			if (times(&buf) < 0) 
			{
				printf("Times error\n");
				exit(-5);
			}
			ticks_per_second = sysconf(_SC_CLK_TCK);
			
			printf("\n Command to be executed: ");
			for (i=0; i<(argc - 1); i++) printf("%s ",params[i]);
			printf("\n Complete time ( real time ) = %fs\n",seq_time);		
			printf(" CPU time ( user time ) = %fs\n", (double)buf.tms_cutime / (double)ticks_per_second);
			printf(" CPU time ( system time ) = %fs\n\n", (double)buf.tms_cstime / (double)ticks_per_second);
		}
	}
	else  // fork failed
	{
		printf("\n Fork failed! \n");
		exit(-3);
	}
	
	return 0;
}
