#include <stdio.h>
#include <math.h>
#define MAX 200

void main()
{
    int ar_uf,i,flag=0;
    float min_dis,X[MAX],Y[MAX],X_center=0,Y_center=0,max_dis=0,riza_xy,R,x,y,center_dis,uf_dis;

    do {
    printf("Enter number of shelfs: ");
    scanf("%d",&ar_uf);
    if (ar_uf<=0 || ar_uf>MAX)
        printf("Number of shelfs must be 0 and %d\n",MAX);
    } while (ar_uf<=0 || ar_uf>MAX);

    do {
    printf("Enter minimum safe distance: ");
    scanf("%f",&min_dis);
    if (min_dis<0)
        printf("Minimum safe distance must be positive or zero/n");
    } while (min_dis<0);

    for (i=0; i<ar_uf; i++) {
        printf("Enter coordinate X of shelf: ");
        scanf("%f",&X[i]);
        printf("Enter coordinate Y of shelf: ");
        scanf("%f",&Y[i]);
        X_center+=(X[i]/ar_uf);
        Y_center+=(Y[i]/ar_uf);
    }

    for (i=0; i<ar_uf; i++) {
        riza_xy=sqrt(pow((X[i]-X_center),2)+pow((Y[i]-Y_center),2));
        if (riza_xy>max_dis)
            max_dis=riza_xy;
    }

    R=max_dis+min_dis;

    for (; ;) {
        int ep_uf=0;

        printf("Enter coordinate X of ship: ");
        scanf("%f",&x);
        printf("Enter coordinate Y of ship: ");
        scanf("%f",&y);
        center_dis=sqrt(pow((X_center-x),2)+pow((Y_center-y),2));
        if (center_dis<=R) {
            flag=1;
            printf("Dangerous field with shelfs.\n\n");
            for (i=0; i<ar_uf; i++) {
                uf_dis=sqrt(pow((X[i]-x),2)+pow((Y[i]-y),2));
                if (uf_dis<=min_dis) {
                    ep_uf+=1;
                    printf("DANGER!!! The ship is only %f metres from shelf with coordinates (%f,%f).\n\n",uf_dis,X[i],Y[i]);
                }
            }
            printf("The shelfs that are in dangerous position with the ship are: %d\n\n",ep_uf);
        }
        else {
            if (flag==1) {
            printf("Exit from dangerous field with shelfs!");
            break;
            }
        }
    }
}

