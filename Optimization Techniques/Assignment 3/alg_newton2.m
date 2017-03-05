function r=alg_newton2(e,co)
k=1;
r(:,k)=co;
g(k)=1;
int=[0 1];
while(norm(gradf(r(1,k),r(2,k)))>=e)
    h=hessianf(r(1,k),r(2,k));
    hi=inv(h);
    d=-hi*gradf(r(1,k),r(2,k));
    g(k)=BisDeriv(e,int,r(:,k));
    r(:,k+1)=r(:,k)+g(k)*d;
    k=k+1;
    if(k>1000000)
        break;
    end
end
end
