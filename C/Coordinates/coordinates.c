#include <stdio.h>
#include <math.h>
#define MAX 200

void main()
{
    int ar_uf,i,flag=0;
    float min_dis,X[MAX],Y[MAX],X_center=0,Y_center=0,max_dis=0,riza_xy,R,x,y,center_dis,uf_dis;

    do {
    printf("Dwse ton ari8mo twn ufalwn ths perioxhs: ");
    scanf("%d",&ar_uf);
    if (ar_uf<=0 || ar_uf>MAX)
        printf("O ari8mos twn ufalwn prepei na einai anamesa sto 0 kai sto %d\n",MAX);
    } while (ar_uf<=0 || ar_uf>MAX);

    do {
    printf("Dwse thn elaxisth apostash asfaleias: ");
    scanf("%f",&min_dis);
    if (min_dis<0)
        printf("H elaxisth apostash asfaleias prepei na einai 8etikh h mhden/n");
    } while (min_dis<0);

    for (i=0; i<ar_uf; i++) {
        printf("Dwse thn tetmhmenh X tou ufalou: ");
        scanf("%f",&X[i]);
        printf("Dwse thn tetagmenh Y tou ufalou: ");
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

        printf("Dwse thn tetmhmenh x tou ploiou: ");
        scanf("%f",&x);
        printf("Dwse thn tetagmenh y tou ploiou: ");
        scanf("%f",&y);
        center_dis=sqrt(pow((X_center-x),2)+pow((Y_center-y),2));
        if (center_dis<=R) {
            flag=1;
            printf("Briskestai se epikindunh perioxh me ufalous.\n\n");
            for (i=0; i<ar_uf; i++) {
                uf_dis=sqrt(pow((X[i]-x),2)+pow((Y[i]-y),2));
                if (uf_dis<=min_dis) {
                    ep_uf+=1;
                    printf("PROSOXH!!! To ploio brisketai se epikindunh apostash %f metrwn apo ton ufalo me suntetagmenes (%f,%f).\n\n",uf_dis,X[i],Y[i]);
                }
            }
            printf("Oi ufaloi pou briskontai se epikindunh apostash apo to ploio einai: %d\n\n",ep_uf);
        }
        else {
            if (flag==1) {
            printf("Eksodos apo epikindunh perioxh me ufalous!");
            break;
            }
        }
    }
}

