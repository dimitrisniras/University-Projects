#include <iostream>
#include <stdlib.h>
using namespace std;

class AND {
    bool ent1,ent2,exit;
    float power;
public:
    void set_ent(bool n,bool k);
    bool get_exit();
    float get_power();
};

void AND::set_ent(bool n,bool k) {
    ent1=n;
    ent2=k;
}

bool AND::get_exit() {
    if (ent1==0 && ent2==0) {
        exit=0;
    }
    else if(ent1==0 && ent2==1) {
        exit=0;
    }
    else if(ent1==1 && ent2==0) {
        exit=0;
    }
    else {
        exit=1;
    }
    return exit;
}

float AND::get_power() {
    if (ent1==0 && ent2==0) {
        power=0;
    }
    else if(ent1==0 && ent2==1) {
        power=0.5;
    }
    else if(ent1==1 && ent2==0) {
        power=0.5;
    }
    else {
        power=1;
    }
    return power;
}

class OR {
    bool ent1,ent2,exit;
    float power;
public:
    void set_ent(bool n,bool k);
    bool get_exit();
    float get_power();
};

void OR::set_ent(bool n,bool k) {
    ent1=n;
    ent2=k;
}

bool OR::get_exit() {
    if (ent1==0 && ent2==0) {
        exit=0;
    }
    else if(ent1==0 && ent2==1) {
        exit=1;
    }
    else if(ent1==1 && ent2==0) {
        exit=1;
    }
    else {
        exit=1;
    }
    return exit;
}

float OR::get_power() {
    if (ent1==0 && ent2==0) {
        power=0;
    }
    else if(ent1==0 && ent2==1) {
        power=0.5;
    }
    else if(ent1==1 && ent2==0) {
        power=0.5;
    }
    else {
        power=1;
    }
    return power;
}

class NOT {
    bool ent,exit;
    float power;
public:
    void set_ent(bool n);
    bool get_exit();
    float get_power();
};

void NOT::set_ent(bool n) {
    ent=n;
}

bool NOT::get_exit() {
    if (ent==0) {
        exit=1;
    }
    else {
        exit=0;
    }
    return exit;
}

float NOT::get_power() {
    if (ent==0) {
        power=0;
    }
    else {
        power=1;
    }
    return power;
}

class circuits {
public:
    virtual void set_ent(bool n,bool k)=0;
    virtual bool get_exit1()=0;
    virtual bool get_exit2()=0;
    virtual float get_power()=0;
};

class A:public circuits {
    bool ent1,ent2,exit1,exit2;
    float power;
    AND a;
    OR o;
public:
    void set_ent(bool n,bool k);
    bool get_exit1();
    bool get_exit2();
    float get_power();
};

void A::set_ent(bool n,bool k) {
    ent1=n;
    ent2=k;
    a.set_ent(ent1,ent2);
    o.set_ent(ent1,ent2);
}

bool A::get_exit1() {
    exit1=a.get_exit();
    return exit1;
}

bool A::get_exit2() {
    exit2=o.get_exit();
    return exit2;
}

float A::get_power() {
    power=a.get_power()+o.get_power();
    return power;
}

class B:public circuits {
    bool ent1,ent2,exit1,exit2;
    float power;
    AND a;
    OR o;
    NOT no;
public:
    void set_ent(bool n,bool k);
    bool get_exit1();
    bool get_exit2();
    float get_power();
};

void B::set_ent(bool n,bool k) {
    ent1=n;
    ent2=k;
    no.set_ent(ent2);
    a.set_ent(ent1,no.get_exit());
    o.set_ent(ent1,ent2);
}

bool B::get_exit1() {
    exit1=a.get_exit();
    return exit1;
}

bool B::get_exit2() {
    exit2=o.get_exit();
    return exit2;
}

float B::get_power() {
    power=a.get_power()+o.get_power()+no.get_power();
    return power;
}

float calc_circuit(int k,circuits **circuit) {
    int i;
    float power=0;
    bool ent1,ent2,exit1,exit2;

    cout<<"Type the entrance a: ";
    cin>>ent1;
    cout<<"Type the entrance b: ";
    cin>>ent2;
    for (i=0; i<k; i++) {
        circuit[i]->set_ent(ent1,ent2);
        exit1=circuit[i]->get_exit1();
        exit2=circuit[i]->get_exit2();
        power+=circuit[i]->get_power();
        ent1=exit1;
        ent2=exit2;
    }
    cout<<"The exit c is "<<exit1<<" and the exit d is "<<exit2<<".\n";

    return power;
}

int main() {
    int i,m,n,k;
    circuits **circuit;
    float power;
    char c;
    A a;
    B b;

    cout<<"Type the amount of A circuits: ";
    cin>>m;
    cout<<"Type the amount of B circuits: ";
    cin>>n;
    k=m+n;
    circuit=new circuits *[k];
    if (circuit==0) {
        cout<<"Memory allocation failed!";
        exit(1);
    }
    for (i=0; i<k; i++) {
        cout<<"Type the type of circuit in place "<<i+1<<": ";
        cin>>c;
        while(c!='A' && c!='B') {
            cout<<"The circuit must be type A or type B!\n";
            cout<<"Type the type of circuit in place "<<i+1<<": ";
            cin>>c;
        }
        if (c=='A') {
            circuit[i]=&a;
        }
        if (c=='B') {
            circuit[i]=&b;
        }
    }
    power=calc_circuit(k,circuit);
    cout<<"The total power of circuit is "<<power<<"mWatt.";
    delete []circuit;

    return 0;
}
