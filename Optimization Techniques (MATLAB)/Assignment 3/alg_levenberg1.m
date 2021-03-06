function r=alg_levenberg1(e,co)
k=1;
r(:,k)=co;
g=0.5;
while(norm(gradf(r(1,k),r(2,k)))>=e)
    h=hessianf(r(1,k),r(2,k));
    m=max(abs(eig(h)));
    mk=1.05*m;
    A=h+mk*eye(2);
    b=-g*gradf(r(1,k),r(2,k));
    y=A\b ;
    r(:,k+1)=r(:,k)+y;
    k=k+1;
    if(k>100000)
       break;
    end
end
end