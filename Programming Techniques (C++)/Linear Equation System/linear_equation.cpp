#include <iostream>
#include <stdlib.h>
#include <math.h>
using namespace std;

class vector;
class matrix {
    int r,c;
    float **m;
public:
    void operator()(int n,int k);
    int operator!();
    float *operator[](int i);
    int getc();
    friend vector operator*(matrix a,vector b);
};

void matrix::operator()(int n,int k) {
    int i,j;

    r=n;
    c=k;
    if ((m=(float **)malloc(r*sizeof(float *)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(1);
    }
    for (i=0; i<r; i++) {
        if ((m[i]=(float *)malloc(c*sizeof(float)))==NULL) {
            cout<<"Memory allocation failed!";
            exit(2);
        }
    }
    cout<<"Type the data of matrix array.\n";
    for (i=0; i<r; i++) {
        cout<<"Type the datas for row "<<i+1<<".\n";
        for (j=0; j<c; j++) {
            cin>>m[i][j];
        }
    }
}

int matrix::operator!() {
    int i,j,fl=0;
    float *row,*collumn;

    if (r!=c) {
        cout<<"The array is not square!";
        exit(13);
    }
    if ((row=(float *)malloc(r*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(3);
    }
    if ((collumn=(float *)malloc(c*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(4);
    }
    for (i=0; i<r; i++) {
        row[i]=0;
        for (j=0; j<c; j++) {
            if (i!=j) {
                row[i]+=abs(m[i][j]);
            }
        }
    }
    for (j=0; j<c; j++) {
        collumn[j]=0;
        for (i=0; i<r; i++) {
            if (j!=i) {
                collumn[j]+=abs(m[i][j]);
            }
        }
    }
    for (i=0; i<r; i++) {
        for (j=0; j<c; j++) {
            if (i==j) {
                if (abs(m[i][j])>row[i] || abs(m[i][j])>collumn[j]) {
                    fl+=1;
                }
            }
        }
    }
    if (fl==r)
        return 0;
    else
        return 1;
}

float *matrix::operator[](int i) {
    return m[i];
}

int matrix::getc() {
    return c;
}

class vector {
    int n;
    float *v;
public:
    void operator()(int k);
    int operator()(vector d,float e);
    vector operator=(matrix a);
    vector operator*(vector d);
    vector operator-(vector d);
    vector operator+(vector d);
    vector operator/(vector d);
    float operator[](int i);
    int getn();
    void setv(int k);
    friend vector operator*(matrix a,vector b);
};

int vector::getn() {
    return n;
}

void vector::operator()(int k) {
    int i;

    n=k;
    if ((v=(float *)malloc(k*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(5);
    }
    cout<<"Type the data of vector array.\n";
    for (i=0; i<n; i++) {
        cin>>v[i];
    }
}

int vector::operator()(vector d,float e) {
    int i;
    float sumb=0,sumd=0;

    if (n!=d.n) {
        cout<<"The array sizes is not equal!";
        exit(20);
    }
    for (i=0; i<n; i++) {
        sumb+=v[i];
        sumd+=d[i];
    }
    if (abs(sumb-sumd)<e)
        return 1;
    else
        return 0;
}

vector vector::operator=(matrix a) {
    int i,j;

    if (n!=a.getc()) {
        cout<<"The matrix array is not square!";
        exit(15);
    }
    for (i=0; i<n; i++) {
        for (j=0; j<a.getc(); j++) {
            if (i==j) {
                v[i]=a[i][j];
            }
        }
    }
    return *this;
}

vector vector::operator*(vector d) {
    int i;
    vector c;

    if (n!=d.getn()) {
        cout<<"The size of arrays is not equal!";
        exit(16);
    }
    if ((c.v=(float *)malloc(n*sizeof(float)))==NULL) {
        exit(6);
    }
    for (i=0; i<n; i++) {
        c.v[i]=v[i]*d[i];
    }
    return c;
}

vector vector::operator-(vector d) {
    int i;
    vector c;

    if (n!=d.getn()) {
        cout<<"The size of arrays is not equal!";
        exit(17);
    }
    if ((c.v=(float *)malloc(n*sizeof(float)))==NULL) {
        exit(7);
    }
    for (i=0; i<n; i++) {
        c.v[i]=v[i]-d[i];
    }
    return c;
}

vector vector::operator+(vector d) {
    int i;
    vector c;

    if (n!=d.getn()) {
        cout<<"The size of arrays is not equal!";
        exit(18);
    }
    if ((c.v=(float *)malloc(n*sizeof(float)))==NULL) {
        exit(8);
    }
    for (i=0; i<n; i++) {
        c.v[i]=v[i]+d[i];
    }
    return c;
}

vector vector::operator/(vector d) {
    int i;
    vector c;

    if (n!=d.getn()) {
        cout<<"The size of arrays is not equal!";
        exit(19);
    }
    if ((c.v=(float *)malloc(n*sizeof(float)))==NULL) {
        exit(9);
    }
    for (i=0; i<n; i++) {
        c.v[i]=v[i]/d[i];
    }
    return c;
}

float vector::operator[](int i) {
    return v[i];
}


void vector::setv(int k) {
    int i;

    n=k;
    if ((v=(float *)malloc(n*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(13);
    }
    for (i=0; i<n; i++) {
        v[i]=0;
    }
}

vector operator*(matrix a,vector b) {
    int i,j;
    vector d;

    if ((d.v=(float *)malloc(b.n*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(10);
    }
    for (i=0; i<a.r; i++) {
        d.v[i]=0;
        for (j=0; j<a.c; j++) {
            d.v[i]+=a[i][j]*b[j];
        }
    }
    return d;
}

class system_solve {
    matrix a;
    vector b;
    int row;
    int collumn;
public:
    system_solve();
    vector solve(int k,float e);
    int get_size();
};

system_solve::system_solve() {
    cout<<"Type the row size of array: ";
    cin>>row;
    cout<<"Type the collumn size of array: ";
    cin>>collumn;
    a(row,collumn);
    b(collumn);
}

vector system_solve::solve(int k,float e) {
    int i=0;
    vector d,x1,x2,x3;
    d.setv(collumn);
    d=a;
    x1.setv(collumn);
    x2.setv(collumn);
    x3.setv(collumn);

    if (!a==1) {
        cout<<"The array is not diagonal!";
        exit(21);
    }
    do {
        x2=a*x1;
        x2=b-x2;
        x3=d*x1;
        x2=x2+x3;
        x2=x2/d;
        x1=x2;
    }while(i<k && (x1(x2,e))==0);

    return x2;
}

int system_solve::get_size() {
    return collumn;
}

int main() {
    int i,k;
    float e;
    vector a;
    system_solve s;

    cout<<"Give k: ";
    cin>>k;
    cout<<"Give e: ";
    cin>>e;
    a=s.solve(k,e);
    for (i=0; i<s.get_size(); i++) {
        cout<<endl<<a[i];
    }
    return 0;
}
