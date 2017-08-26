function r=alg_meg_kathodou1(e,co)
k=1;
r(:,k)=co;
g=0.5;
while(norm(gradf(r(1,k),r(2,k)))>=e)
    d=-gradf(r(1,k),r(2,k));
    r(:,k+1)=r(:,k)+g*d;
    k=k+1;
    if(k>100000)
        break;
    end
end
end
