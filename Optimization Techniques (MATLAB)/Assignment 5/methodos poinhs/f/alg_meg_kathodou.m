function x=alg_meg_kathodou(e,co,r)
k=1;
x(:,k)=co;
g=e/10;
while(norm(gGrad(x(:,k),r))>=e)
    d=-gGrad(x(:,k),r);
    x(:,k+1)=x(:,k)+g*d;
    k=k+1;
    if(k>100000)
        break;
    end
end
x=x(:,k);
end
