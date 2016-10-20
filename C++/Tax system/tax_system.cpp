#include <iostream>
#include <stdlib.h>
#include <ctime>
using namespace std;

class data {
    int zone;
    float *plot_price,*building_price,*plot_factor,*building_factor,field_factor_trees,field_factor_annual,store_factor;
public:
    data();
    float get_plot_price(int a);
    float get_plot_factor(int a);
    float get_field_factor_trees();
    float get_field_factor_annual();
    float get_building_price(int a);
    float get_building_factor(int a);
    float get_store_factor();
}d;

data::data() {
    int i;

    cout<<"Type the number of zones: ";
    cin>>zone;
    if ((plot_price=(float *)malloc(zone*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(1);
    }
    if ((building_price=(float *)malloc(zone*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(2);
    }
    if ((plot_factor=(float *)malloc(zone*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(3);
    }
    if ((building_factor=(float *)malloc(zone*sizeof(float)))==NULL) {
        cout<<"Memory allocation failed!";
        exit(4);
    }
    for (i=1; i<zone; i++) {
        cout<<"Type the price of plots in zone "<<i<<": ";
        cin>>plot_price[i];
        cout<<"Type the factor of plot taxes in zone "<<i<<": ";
        cin>>plot_factor[i];
    }
    for (i=0; i<zone; i++) {
        cout<<"Type the price of buildings in zone "<<i<<": ";
        cin>>building_price[i];
        cout<<"Type the factor of building taxes in zone "<<i<<": ";
        cin>>building_factor[i];
    }
    cout<<"Type the factor of field taxes.\n";
    cout<<"Type the factor of trees: ";
    cin>>field_factor_trees;
    cout<<"Type the factor of annual fields: ";
    cin>>field_factor_annual;
    cout<<"Type the decrease factor of stores: ";
    cin>>store_factor;
    while(store_factor>=1 || store_factor<=0) {
        cout<<"The store factor must be in terms (0,1).\n";
        cin>>store_factor;
    }
}

float data::get_plot_price(int a) {
    return plot_price[a];
}

float data::get_plot_factor(int a) {
    return plot_factor[a];
}

float data::get_field_factor_trees() {
    return field_factor_trees;
}

float data::get_field_factor_annual() {
    return field_factor_annual;
}

float data::get_building_price(int a) {
    return building_price[a];
}

float data::get_building_factor(int a) {
    return building_factor[a];
}

float data::get_store_factor() {
    return store_factor;
}

class ground {
    int zone;
    float plot_price,area,plot_factor,field_factor;
public:
    ground(int a,float b);
    ground(float a,int b);
    float plot_taxes();
    float field_taxes();
};

ground::ground(int a,float b) {
    zone=a;
    area=b;
    plot_price=d.get_plot_price(a);
    plot_factor=d.get_plot_factor(a);
}

ground::ground(float a,int b) {
    zone=0;
    area=a;
    if (b==0) {
        field_factor=d.get_field_factor_trees();
    }
    else if (b==1) {
        field_factor=d.get_field_factor_annual();
    }
}

float ground::plot_taxes() {
    float tax;
    tax=area*plot_price*plot_factor;
    return tax;
}

float ground::field_taxes() {
    float tax;
    tax=area*field_factor;
    return tax;
}

class building {
    int zone,floors;
    float area,building_price,building_factor;
public:
    building(int a,float b,int c);
    building(int a,float b);
    float house_taxes();
    float store_taxes();
};

building::building(int a,float b,int c) {
    zone=a;
    area=b;
    building_price=d.get_building_price(a);
    building_factor=d.get_building_factor(a);
    floors=c;
}

building::building(int a,float b) {
    zone=a;
    area=b;
    building_price=d.get_building_price(a);
    building_factor=d.get_building_factor(a);
}

float building::house_taxes() {
    float tax;
    tax=area*building_price*building_factor*floors;
    return tax;
}

float building::store_taxes() {
    float tax;
    tax=area*building_price*building_factor*d.get_store_factor();
    return tax;
}

class property:private ground,private building {
public:
    property(int a,float b,int c,float d,int e);
    property(float a,int b,int c,float d);
    property(int a,float b,int c,float d);
    property(float a,int b,int c,float d,int e);
    float get_plot_taxes();
    float get_field_taxes();
    float get_house_taxes();
    float get_store_taxes();
};

property::property(int a,float b,int c,float d,int e):ground(a,b),building(c,d,e) {}
property::property(float a,int b,int c,float d):ground(a,b),building(c,d) {}
property::property(int a,float b,int c,float d):ground(a,b),building(c,d) {}
property::property(float a,int b,int c,float d,int e):ground(a,b),building(c,d,e) {}

float property::get_plot_taxes() {
    return plot_taxes();
}

float property::get_field_taxes() {
    return field_taxes();
}

float property::get_house_taxes() {
    return house_taxes();
}

float property::get_store_taxes() {
    return store_taxes();
}

int main() {
    int i,zone,floors,field_type;
    float plot_area,house_area,field_area,store_area,taxes=0;
    time_t now=time(0);
    tm *ltm=localtime(&now);

    for (;;) {
        if ((1900+ltm->tm_year)==2013 && (1+ltm->tm_mon)==11 && (ltm->tm_mday)==22) {
            break;
        }
        cout<<"1.Plot and House\n";
        cout<<"2.Field and House\n";
        cout<<"3.Plot and Store\n";
        cout<<"4.Field and store\n";
        cin>>i;
        if (i==1) {
            cout<<"Type the zone: ";
            cin>>zone;
            cout<<"Type the area of plot: ";
            cin>>plot_area;
            cout<<"Type the area of house: ";
            cin>>house_area;
            cout<<"Type the floors of the house: ";
            cin>>floors;
            property p(zone,plot_area,zone,house_area,floors);
            cout<<"The amount of taxes is "<<p.get_plot_taxes()+p.get_house_taxes()<<".\n\n";
            taxes+=p.get_plot_taxes()+p.get_house_taxes();
        }
        else if (i==2) {
            cout<<"Type the area of field: ";
            cin>>field_area;
            cout<<"Type the area of house: ";
            cin>>house_area;
            cout<<"type the type of field\n";
            cout<<"Type 0 for trees and 1 for annual: ";
            cin>>field_type;
            cout<<"Type the floors of the house: ";
            cin>>floors;
            property p(field_area,field_type,0,house_area,floors);
            cout<<"The amount of taxes is "<<p.get_field_taxes()+p.get_house_taxes()<<".\n\n";
            taxes+=p.get_field_taxes()+p.get_house_taxes();
        }
        else if (i==3) {
            cout<<"Type the zone: ";
            cin>>zone;
            cout<<"Type the area of plot: ";
            cin>>plot_area;
            cout<<"Type th area of store: ";
            cin>>store_area;
            property p(zone,plot_area,zone,store_area);
            cout<<"The amount of taxes is "<<p.get_plot_taxes()+p.get_store_taxes()<<".\n\n";
            taxes+=p.get_plot_taxes()+p.get_store_taxes();
        }
        else if (i==4) {
            cout<<"Type the area of field: ";
            cin>>field_area;
            cout<<"Type the area of store: ";
            cin>>store_area;
            cout<<"Type the type of field";
            cout<<"Type 0 for trees and 1 for annual: ";
            cin>>field_type;
            property p(field_area,field_type,0,store_area);
            cout<<"The amount of taxes is "<<p.get_field_taxes()+p.get_store_taxes()<<".\n\n";
            taxes+=p.get_field_taxes()+p.get_store_taxes();
        }
    }
    cout<<"The whole amount of taxes is: "<<taxes<<" !";

    return 0;
}
