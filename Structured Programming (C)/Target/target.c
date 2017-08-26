#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void nbco_or(float *xb,float *yb,float xs,float ys,float me);
void ntco_or(float *xs,float *ys,float me);

int main()
{
    float xb, yb, xs, ys, sd, me, xp, yp, dis1, dis2;

    printf("Enter cooedinates of bullet.\n");
    printf("Enter X: ");
    scanf("%f",&xb);
    printf("Enter Y: ");
    scanf("%f",&yb);
    printf("Enter target's coordinates.\n");
    printf("Enter X: ");
    scanf("%f",&xs);
    printf("Enter Y: ");
    scanf("%f",&ys);
    printf("Enter the distruction diastance sd: ");
    scanf("%f",&sd);
    printf("Enter maximum value <me> that target will change it's position: ");
    scanf("%f",&me);
    for (;;) {
        printf("Bullet's coordinates are (%f,%f).\n",xb,yb);
        ntco_or(&xs,&ys,me);
        nbco_or(&xb,&yb,xs,ys,me);
        dis1=sqrt(pow((xb-xs),2)+pow((yb-ys),2));
        if (dis1<=sd) {
            printf("Target has been destroyed from bullet (%f,%f).",xb,yb);
            break;
        }
        printf("Enter possible coordinates of bullet.\n");
        printf("Enter X: ");
        scanf("%f",&xp);
        printf("Enter Y: ");
        scanf("%f",&yp);
        dis2=sqrt(pow((xp-xb),2)+pow((yp-yb),2));
        if (dis2<=sd) {
            printf("Bullet has been destroyed %f metres from target.",dis1);
            break;
        }
    }

    return 0;
}

void nbco_or(float *xb,float *yb,float xs,float ys,float me)
{
    float k, xp, yp;
    xp=*xb;
    yp=*yb;
    for (;;) {
        k=(float)rand()/(float)me;
        *xb+=k;
        *yb+=k;
        if (abs(*xb-xs)<abs(xp-xs) && abs(*yb-ys)<abs(yp-ys))
            break;
    }
}

void ntco_or(float *xs,float *ys,float me)
{
    float k;
    k=(float)rand()/(float)(0.25*me);
    *xs+=k;
    *ys+=k;
}



