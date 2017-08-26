function r=alg_newton3(e,co)
k=1;
r(:,k)=co;
g=0.5;
while(norm(gradf(r(1,k),r(2,k)))>=e)
    h=hessianf(r(1,k),r(2,k));
    hi=inv(h);
    d=-hi*gradf(r(1,k),r(2,k));
    if(k>=4)
        if(f(r(1,k),r(2,k))>0.9*f(r(1,k-3),r(2,k-3)))
            g=1.2*g;
        end
    end
    r(:,k+1)=r(:,k)+g*d;
    k=k+1;
    if(k>100000)
       break;
    end
end
end