#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;

class machine {
protected:
    char *Class_id;
    static machine **M;
    static int n;
    static machine **ID;
    static int m;
public:
    machine();
    machine(char *p);
    char *get_Class_id();
    virtual char *get_id()=0;
    virtual float get_power()=0;
    virtual float get_problem()=0;
    virtual void create_units(int k)=0;
    static machine **get_M();
    static int get_n();
    static machine **get_ID();
    static int get_m();
};

machine **machine::M;
int machine::n;
machine **machine::ID;
int machine::m;

machine::machine() {
    n++;
    if (n==1) {
        if ((M=(machine **)malloc(n*sizeof(machine *)))==NULL) {
            cout<<"Memory allocation failed!";
            exit(1);
        }
    }
    else {
        if ((M=(machine **)realloc(M,n*sizeof(machine *)))==NULL) {
            cout<<"Memory allocation failed!";
            exit(2);
        }
    }
    M[n-1]=this;
}

machine::machine(char *p) {
    Class_id=p;
    m++;
    if (m==1) {
        if ((ID=(machine **)malloc(m*sizeof(machine *)))==NULL) {
            cout<<"Memory allocatio failed!";
            exit(5);
        }
    }
    else {
        if ((ID=(machine **)realloc(ID,m*sizeof(machine *)))==NULL) {
            cout<<"MEmory allocation failed!";
            exit(6);
        }
    }
    ID[m-1]=this;
}

machine** machine::get_M() {
    return M;
}

int machine::get_n() {
    return n;
}

machine** machine::get_ID() {
    return ID;
}

int machine::get_m() {
    return m;
}

char* machine::get_Class_id() {
    return Class_id;
}

class sun_machine:public machine {
    float sun,S,power;
    char id[31];
    static float area,problem;
public:
    sun_machine();
    sun_machine(char *p);
    float get_power();
    float get_problem();
    char* get_id();
    void create_units(int k);
}s("sun");

float sun_machine::area;
float sun_machine::problem;

sun_machine::sun_machine() {
    cout<<"------Sun Machine------\n";
    cout<<"Type the id of the machine: ";
    cin>>id;
    cout<<"Type the amount of sun: ";
    cin>>sun;
    cout<<"Type the S factor: ";
    cin>>S;
}

sun_machine::sun_machine(char *p):machine(p) {
    cout<<"Type the problem of sun machines: ";
    cin>>problem;
    cout<<"Type the area of sun machines: ";
    cin>>area;
}

float sun_machine::get_power() {
    power=area*sun*S;
    return power;
}

float sun_machine::get_problem() {
    return problem;
}

char* sun_machine::get_id() {
    return id;
}

void sun_machine::create_units(int k) {
    sun_machine *p;
    p=new sun_machine[k];
    if (p==0) {
        cout<<"Memory allocation failed!";
        exit(3);
    }
}

class wind_machine:public machine {
    float speed,A,power;
    char id[31];
    static float problem;
public:
    wind_machine();
    wind_machine(char *p);
    float get_power();
    float get_problem();
    char* get_id();
    void create_units(int k);
}w("wind");

float wind_machine::problem;

wind_machine::wind_machine() {
    cout<<"------Wind Machine------\n";
    cout<<"Type the id of the machine: ";
    cin>>id;
    cout<<"Type the speed of air: ";
    cin>>speed;
    cout<<"Type the A factor: ";
    cin>>A;
}

void wind_machine::create_units(int k) {
    wind_machine *p;
    p=new wind_machine[k];
    if (p==0) {
        cout<<"Memory allocation failed!";
        exit(4);
    }
}

wind_machine::wind_machine(char *p):machine(p) {
    cout<<"\nType the problem of wind machine: ";
    cin>>problem;
}

float wind_machine::get_power() {
    power=speed*A;
    return power;
}

float wind_machine::get_problem() {
    return problem;
}

char* wind_machine::get_id() {
    return id;
}

int control (machine **M,int n,float &power,float n_pow) {
    int i;
    srand(time(NULL));

    for (i=0; i<n; i++) {
        if (M[i]->get_problem()<=(float)(rand()%10)/10) {
            power+=M[i]->get_power();
        }
        else {
            cout<<"The source with id "<<M[i]->get_id()<<" is damaged!\n";
        }
    }
    if (power<n_pow)
        return 1;
    else if (power>n_pow && power<=1.1*n_pow)
        return 2;
    else
        return 3;
}

int main() {
    int i,k,num,n;
    float power=0,n_pow;
    char *id;
    machine **p;
    p=machine::get_ID();
    n=machine::get_m();

    for (i=0; i<n; i++) {
        id=p[i]->get_Class_id();
        cout<<endl;
        cout<<"Type the amount of machines type "<<id<<": ";
        cin>>num;
        cout<<endl;
        p[i]->create_units(num);
    }
    cout<<"Type the minimum power that island needs: ";
    cin>>n_pow;
    k=control(machine::get_M(),machine::get_n(),power,n_pow);
    if (k==1)
        cout<<"The power is not enough!\n";
    else if (k==2)
        cout<<"The power is beyond security limit!\n";
    else if (k==3)
        cout<<"The supply is going well!!!\n";

    cout<<"The total power of sources is "<<power<<" MWatt.";

    return 0;
}
