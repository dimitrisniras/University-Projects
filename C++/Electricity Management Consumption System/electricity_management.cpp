#include <iostream>
#include <stdlib.h>
#include <string.h>
using namespace std;

class pelates {
    long int code;
    char name[30];
    char login_name[5];
    long int password;
    float ofeiles,kostos,meg_up;
public:
    void set_all();
    void set_kostos(float a);
    float get_kostos();
    void set_meg_up(float a);
    float get_meg_up();
    char* get_login_name();
    long int get_password();
    void set_ofeiles(float a);
    float get_ofeiles();
    char* get_name();
    long int get_code();
};

void pelates::set_all() {
    cout<<"Enter customer code: ";
    cin>>code;
    cout<<"Enter customer name: ";
    cin>>name;
    cout<<"Enter customer username: ";
    cin>>login_name;
    cout<<"Enter customer password: ";
    cin>>password;
}

void pelates::set_kostos(float a) {
    kostos=a;
}

float pelates::get_kostos() {
    return kostos;
}

void pelates::set_meg_up(float a) {
    meg_up=a;
}

float pelates::get_meg_up() {
    return meg_up;
}

char* pelates::get_login_name() {
    return login_name;
}

long int pelates::get_password() {
    return password;
}

void pelates::set_ofeiles(float a) {
    ofeiles=a;
}

float pelates::get_ofeiles() {
    return ofeiles;
}

char* pelates::get_name() {
    return name;
}

long int pelates::get_code() {
    return code;
}

void add_client(pelates *&pel,int *num) {
    float kostos,meg,ofeiles;

    if ((pel=(class pelates*)realloc(pel,(*num+1)*sizeof(class pelates)))==NULL) {
        cout<<"Allocation Failure!";
        exit(2);
    }
    pel[*num].set_all();
    cout<<"Enter cost of kwh: ";
    cin>>kostos;
    pel[*num].set_kostos(kostos);
    cout<<"Enter maximum remainder: ";
    cin>>meg;
    pel[*num].set_meg_up(meg);
    cout<<"Enter customer's debt: ";
    cin>>ofeiles;
    pel[*num].set_ofeiles(ofeiles);
    *num=*num+1;
}

void delete_client(pelates *&pel,int *num) {
    int i;
    char name[30];
    long int code;

    cout<<"Enter customer name that you want to be deleted: ";
    cin>>name;
    cout<<"Enter customer code that you want to be deleted: ";
    cin>>code;
    for (i=0; i<2; i++) {
        if (strcmp(name,pel[i].get_name())==0 && code==pel[i].get_code()) {
            pel[i]=pel[*num-1];
            if ((pel=(class pelates *)realloc(pel,(*num-1)*sizeof(class pelates)))==NULL) {
                cout<<"Allocation Faillure!";
                exit(3);
            }
            cout<<"Customer has successfully deleted!\n\n";
        }
    }
    *num=*num-1;
}

void client_info(pelates *pel,int num) {
    int i;

    for (i=0; i<num; i++) {
        cout<<"Name: "<<pel[i].get_name()<<"\n";
        cout<<"Account number: "<<pel[i].get_code()<<"\n";
        cout<<"Balance: "<<pel[i].get_ofeiles()<<"\n\n\n";
    }
}

void client_stop(pelates *pel,int num) {
    int i,fl=0;

    for (i=0; i<num; i++) {
        if (pel[i].get_ofeiles()>pel[i].get_meg_up()) {
            fl=1;
            cout<<"Electricity will be suspended on customer with name "<<pel[i].get_name()<<" and account number "<<pel[i].get_code()<<"\n\n";
        }
    }
    if (fl==0)
        cout<<"Electricity will not be suspended on any customer!\n";
}

int main() {
    int k,n,num,i;
    char login_name[5];
    long int password,log;
    float poso,meg,kostos,ofeiles,kwh;
    pelates *pel;

    cout<<"Enter customer's number: ";
    cin>>num;
    if ((pel=(class pelates*)malloc(num*sizeof(class pelates)))==NULL) {
        cout<<"Allocation faillure!";
        exit(1);
    }
    for (i=0; i<num; i++) {
        pel[i].set_all();
        cout<<"Enter kwh cost: ";
        cin>>kostos;
        pel[i].set_kostos(kostos);
        cout<<"Enter maximum balance: ";
        cin>>meg;
        pel[i].set_meg_up(meg);
        cout<<"Enter customer's debt: ";
        cin>>ofeiles;
        pel[i].set_ofeiles(ofeiles);
    }
    for (;;) {
        cout<<"1.Customer\n";
        cout<<"2.Administrator\n";
        cin>>k;
        switch(k) {
        case 1:
            cout<<"Enter username: ";
            cin>>login_name;
            cout<<"Enter password: ";
            cin>>password;
            for (i=0; i<num; i++) {
                if (strcmp(login_name,pel[i].get_login_name())==0 && password==pel[i].get_password()) {
                    cout<<"Enter bank account: ";
                    cin>>log;
                    cout<<"Enter amount of kwh: ";
                    cin>>kwh;
                    cout<<"Enter payment: ";
                    cin>>poso;
                    pel[i].set_ofeiles(pel[i].get_ofeiles()+(kwh*pel[i].get_kostos())-poso);
                    cout<<"Account's balance "<<log<<" is "<<pel[i].get_ofeiles()<<" $.\n\n";
                }
            }
            break;
        case 2:
            cout<<"1.Add customer\n";
            cout<<"2.Delete customer\n";
            cout<<"3.Print suspended customers\n";
            cout<<"4.Print customer's information\n";
            cout<<"5.Exit\n";
            cin>>n;
            switch(n) {
            case 1:
                add_client(pel,&num);
                break;
            case 2:
                delete_client(pel,&num);
                break;
            case 3:
                client_stop(pel,num);
                break;
            case 4:
                client_info(pel,num);
                break;
            case 5:
                cout<<"Exit from program!";
                exit(0);
            }
            break;
        }
    }
    free(pel);
    return 0;
}
