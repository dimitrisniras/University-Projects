#include <sys/prex.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <errno.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

static struct termios oldterm, newterm;
static char stack[2][1024];

int n, mode_flag = 0, timer_flag = 0, stop_flag = 0, pause_flag = 0;
int minutes = 0, hours = 0, seconds = 0, sec = 0, min = 0, hour = 0;
int cur_time = 0, cur_time_sec = 0;
long s_sec = 0, e_sec = 0, usec = 0, seq_time = 0, delay = 0;
long h_offset = 0, m_offset = 0, s_offset = 0;
unsigned char key;
 
struct __timeval get_time() {
    device_t rtc_dev;
    struct __timeval tm;
 
    device_open("rtc", 0, &rtc_dev);
    device_ioctl(rtc_dev, RTCIOC_GET_TIME, &tm);
    device_close(rtc_dev);
 
    return tm;
}

int tcsetattr(int fd, int opt, const struct termios *t) {
	struct termios localterm;
	device_t tty_dev;
	int value;
	 	
	if (opt & TCSASOFT) {
		localterm = *t;
		localterm.c_cflag |= CIGNORE;
		t = &localterm;
	}
	
	switch (opt & ~TCSASOFT) {
	case TCSANOW:
			device_open("tty", 2, &tty_dev);
			value = device_ioctl(tty_dev, TIOCSETA, t);
			device_close(tty_dev);
			return  value;	
					
			break;
					
	case TCSADRAIN:
			device_open("tty", 2, &tty_dev);
			value = device_ioctl(tty_dev, TIOCSETAW, t);
			device_close(tty_dev);
			return  value;
							
			break;
				
	case TCSAFLUSH:
			device_open("tty", 2, &tty_dev);
			value = device_ioctl(tty_dev, TIOCSETAF, t);
			device_close(tty_dev);
			return  value;	
			
			break;
				
	default:
		errno = EINVAL;
		return -1;
	}
}

int tcgetattr(int fd, struct termios *t) {
	device_t tty_dev;
	int value;
	
	device_open("tty", 2, &tty_dev);
	value = device_ioctl(tty_dev, TIOCGETA, t);
	device_close(tty_dev);
	
	return  value;
}

static thread_t thread_run(void (*start)(void), void *stack) {
	thread_t t;

	if (thread_create(task_self(), &t) != 0)
		return -1;

	if (thread_load(t, start, stack) != 0)
		return -1;
 
	if (thread_setpri(t, 128) != 0)
		return -1;
		
	if (thread_resume(t) != 0)
		return -1;

	return t;
}

static void clock_thread(void) {
	while (1) {
		if (mode_flag == 0) {
			cur_time_sec = get_time().tv_sec;
		    cur_time = cur_time_sec + h_offset + m_offset - s_offset;
		    sec = cur_time % 60;
		    min = (int)((cur_time / 60) % 60);
		    hour = (int)((cur_time / 3600) % 24);
		         
		    printf("\r%02d:%02d:%02d   ",hour,min,sec);
		}
		timer_sleep(500, 0);
	}
}

static void timer_thread(void) {
	while(1) {
		if (mode_flag == 1) {
			if (timer_flag == 1) {
				e_sec = get_time().tv_sec;
		        seq_time = (int)(e_sec - s_sec + delay);
		        usec = get_time().tv_usec/10000;
		             
		        seconds = (int)(seq_time % 60);
		        minutes = (int)(seq_time / 60) % 60;
		        hours = (int)(seq_time / 3600) % 24;
		        printf("\r%02d:%02d:%02d.%02d",hours,minutes,seconds,usec);
		     }
		     else
		        printf("\r%02d:%02d:%02d.%02d",hours,minutes,seconds,usec);
		}
		timer_sleep(10, 0);
    }
}	

 
int main(void) { 
	device_t tty_dev;
	thread_t clock_t, timer_t;
	
    clock_t = thread_run(clock_thread, stack[0]+1024);
    timer_t = thread_run(timer_thread, stack[1]+1024);
    thread_suspend(timer_t);
    
    tcgetattr(STDIN_FILENO, &oldterm);
    newterm = oldterm;
    newterm.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newterm);
    
    while(1) {
    	device_open("tty", 0, &tty_dev);
    	device_ioctl(tty_dev, TIOCINQ, &n);
    	device_close(tty_dev);
      
      	key = getchar();
      	
        if (key != EOF) {
                 
            if (key == 'T') {
                if (mode_flag == 0) {
                    mode_flag = 1;
                    thread_suspend(clock_t);
                    thread_resume(timer_t);
                }
                else {
                    mode_flag = 0;
                    thread_resume(clock_t);
                    thread_suspend(timer_t);
                }
            }
             
            if (key == 'R') {
                if (timer_flag == 1) {
                	delay = 0;
                    s_sec = get_time().tv_sec;
                }
                else if (pause_flag == 0) {
                	delay = 0;
                	hours = 0;
                	minutes = 0;
                	seconds = 0;
                	usec = 0;
                }
            } 
             
            if (key == 'S') {
                if (timer_flag == 0) {
                    if (pause_flag == 0) {
                        s_sec = get_time().tv_sec;            
                        timer_flag = 1;
                        stop_flag = 0;
                    }
                    else {
                        pause_flag = 0;
                        stop_flag = 1;
                        timer_flag = 0;
                    }
                }
                else {
                	delay += get_time().tv_sec - s_sec;
                    pause_flag = 0;
                    timer_flag = 0;
                    stop_flag = 1;
                }
            }
             
            if (key == 'P') {
                if (timer_flag == 1) {
                    timer_flag = 0;
                    pause_flag = 1;
                }
                else {
                    if (stop_flag == 0 && pause_flag == 1) {
                        timer_flag = 1;
                        pause_flag = 0;
                    }
                }
            }
             
            if (key == 'H')
                h_offset += 3600;
             
            if (key == 'M')
                m_offset += 60;
             
            if (key == 'Z')
                s_offset += cur_time % 60;
                 
        }
        timer_sleep(100, 0);
	}
	
	tcsetattr(STDIN_FILENO, TCSANOW, &oldterm);
     
    return 0;
}

