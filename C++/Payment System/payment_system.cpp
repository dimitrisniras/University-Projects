#include <iostream>
#include <stdlib.h>
using namespace std;

class specialist;
class project {
    int n,*special,*days;
public:
    void p_set();
    int get_n();
    friend void program(project *p,specialist *s,int *n,int k,int l);
};

void project::p_set() {
    int i;

    cout<<"Type the number of engineers are needed: ";
    cin>>n;
    special=(int *)malloc(n*sizeof(int));
    days=(int *)malloc(n*sizeof(int));
    cout<<"Type the codes are needed to finish the project.\n";
    for (i=0; i<n; i++) {
        cin>>special[i];
    }
    cout<<"Type the days that engineers must work.\n";
    for (i=0; i<n; i++) {
        cout<<"Days for engineer "<<special[i]<<": ";
        cin>>days[i];
    }
}

int project::get_n() {
    return n;
}

class specialist {
    int code;
    float payment;
public:
    void s_set();
    friend void program(project *p,specialist *s,int *n,int k,int l);
};

void specialist::s_set() {
    cout<<"Type the code of speciality: ";
    cin>>code;
    cout<<"Type the payment of engineer: ";
    cin>>payment;
}

void program(project *p,specialist *s,int *n,int k,int l) {
    int i,j,v,fl,start_day=1,end_day,max,min,*busy;
    float payment;

    if ((busy=(int *)malloc(l*sizeof(int)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(4);
    }
    for (i=0; i<l; i++) {
        busy[i]=0;
    }
    for (i=0; i<k; i++) {
        payment=0;
        min=10000;
        max=0;
        for (j=0; j<n[i]; j++) {
            fl=0;
            for (v=0; v<l; v++) {
                if (s[v].code==p[i].special[j]) {
                    fl=1;
                    payment+=p[i].days[j]*s[v].payment;
                    if (busy[v]<min) {
                        min=busy[v];
                    }
                    busy[v]+=p[i].days[j];
                    if (busy[v]>max) {
                        max=busy[v];
                    }
                    break;
                }
                if (fl==0 && v==l-1) {
                    cout<<"You must hire a new engineer!\n";
                    if ((s=(class specialist*)realloc(s,(l+1)*sizeof(class specialist)))==NULL) {
                        cout<<"Memory allocation failed!";
                        exit(5);
                    }
                    if ((busy=(int *)realloc(busy,(l+1)*sizeof(int)))==NULL) {
                        cout<<"Memory allocation failed!";
                        exit(6);
                    }
                    s[l].code=p[i].special[j];
                    cout<<"Type the payment of new engineer: ";
                    cin>>s[l].payment;
                    payment+=p[i].days[j]*s[l].payment;
                    busy[l]=0;
                    min=busy[l];
                    busy[l]+=p[i].days[j];
                    if (busy[l]>max) {
                        max=busy[l];
                    }
                    l++;
                    break;
                }
            }
        }
        start_day+=min;
        end_day=start_day+max;
        cout<<"The start day of project "<<i+1<<" is "<<start_day<<" and the end day is "<<end_day<<".\n";
        cout<<"The payment for project "<<i+1<<" is "<<payment<<".\n\n";
    }
    free(busy);
}

int main() {
    int i,k,l,*n;
    project *p;
    specialist *s;

    cout<<"Type the amount of projects: ";
    cin>>k;
    cout<<"Type the amount of engineers: ";
    cin>>l;
    if ((p=(class project*)malloc(k*sizeof(class project)))==NULL) {
        cout<<"Memory aloccation failed!";
        exit(1);
    }
    if ((s=(class specialist*)malloc(l*sizeof(class specialist)))==NULL) {
        cout<<"Memory aloccation failed!";
        exit(2);
    }
    if ((n=(int *)malloc(k*sizeof(int)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(3);
    }
    for (i=0; i<l; i++) {
        s[i].s_set();
    }
    for (i=0; i<k; i++) {
        p[i].p_set();
        n[i]=p[i].get_n();
    }
    program(p,s,n,k,l);
    free(p);
    free(s);
    free(n);

    return 0;
}
