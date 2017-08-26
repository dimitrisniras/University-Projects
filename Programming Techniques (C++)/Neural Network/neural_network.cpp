#include <iostream>
#include <stdlib.h>
using namespace std;

class neuron {
    int *id,n,state;
    float *weights,limit;
public:
    friend istream &operator >(istream &s,neuron &neu);
    void *operator new[](size_t size);
    void operator delete[](void *p);
    int get_id(int l) {return id[l];}
    int get_n() {return n;}
    float get_limit() {return limit;}
    void set_state(int a) {state=a;}
    int get_state() {return state;}
    float get_weights(int l) {return weights[l];}
};

istream &operator>(istream &s,neuron &neu) {
    int i;

    cout<<"Type the id: \n";
    for (i=0; i<neu.n; i++) {
        s>>neu.id[i];
    }
    cout<<"Type the weights: \n";
    for (i=0; i<neu.n; i++) {
        s>>neu.weights[i];
    }
    cout<<"Type the limit: ";
    s>>neu.limit;
    cout<<"Type a value of state: ";
    s>>neu.state;
    while (neu.state!=1 && neu.state!=-1) {
        cout<<"The state must be 1 or -1!\n";
        s>>neu.state;
    }

    return s;
}

void* neuron::operator new[](size_t size) {
    int i,k;
    neuron *neu;

    if ((neu=(neuron *)malloc(size))==NULL) {
        cout<<"Memory allocation failed!";
        exit(1);
    }
    k=(int)size/sizeof(neuron);
    for (i=0; i<k; i++) {
        cout<<"Type the number of neurons that connected with neuron "<<i<<": ";
        cin>>neu[i].n;
        if ((neu[i].id=(int *)malloc(neu[i].n*sizeof(int)))==NULL) {
            cout<<"Memory allocation failed!";
            exit(2);
        }
        if ((neu[i].weights=(float *)malloc(neu[i].n*sizeof(float)))==NULL) {
            cout<<"Memory allocaiton failed!";
            exit(3);
        }
        cin>neu[i];
    }
    return neu;
}

void neuron::operator delete[](void *p) {
    free(p);
}

class network {
    static int nn;
    static neuron *n;
    static int *states;
    static int net_state;
public:
    void* operator new(size_t size);
    friend ostream &operator <(ostream &s,network net);
    void operator delete(void *p);
    void calc_state();
};
int network::nn;
neuron* network::n;
int* network::states;
int network::net_state;

void* network::operator new(size_t size) {
    cout<<"Type the number of neurons: ";
    cin>>nn;
    n=new neuron[nn];
}

ostream &operator <(ostream &s,network net) {
    int i;

    cout<<"\nNetwork state: ";
    if (net.net_state==1)
        cout<<"Stable!\n";
    else
        cout<<"Unstable\n";

    cout<<"Neurons state.\n";
    for (i=0; i<net.nn; i++) {
        cout<<"Neuron "<<i<<" state: ";
        if (net.states[i]==1)
            cout<<"Stable!\n";
        else
            cout<<"Unstable!\n";
    }

    return s;
}

void network::operator delete(void *p) {
    delete[]n;
    free(p);
    free (states);
}

void network::calc_state() {
    int i,j,l,num,s=0;
    float **sum;

    cout<<"Type the max number of loops: ";
    cin>>num;
    if ((sum=(float **)malloc(nn*sizeof(float *)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(4);
    }
    for (i=0; i<nn; i++) {
        if ((sum[i]=(float *)malloc(num*sizeof(float)))==NULL) {
            cout<<"Memory allocation failed!";
            exit(5);
        }
    }
    if ((states=(int *)malloc(nn*sizeof(int)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(6);
    }
    for (i=0; i<num; i++) {
        for (j=0; j<nn; j++) {
            sum[j][i]=0;
            for (l=0; l<n[j].get_n(); l++) {
                sum[j][i]+=n[n[j].get_id(l)].get_state()*n[j].get_weights(l);
            }
            if (sum[j][i]>n[j].get_limit())
                n[j].set_state(1);
            else
                n[j].set_state(-1);
        }
    }
    for (i=0; i<nn; i++) {
        if (sum[i][num-1]==sum[i][num-2])
            states[i]=1;
        else
            states[i]=0;
        s+=states[i];
    }
    if (s==nn)
        net_state=1;
    else
        net_state=0;

    free(sum);
}

int main() {
    network *n;
    n=new network;
    n->calc_state();
    cout<*n;
    delete n;
    return 0;
}
