function x=alg_poinhs(e,co)
k=1;
x(:,k)=co;
r(1)=3;
while(true)
    x(:,k+1)=alg_meg_kathodou(e,x(:,k),r(k));
    if(norm((f(x(:,k+1))-f(x(:,k)))/f(x(:,k+1)))<=e)
        break;
    end
    r(k+1)=2*r(k);
    k=k+1;    
    if (k>10000)
        break;
    end
end
PlotContourF
plotResultF(x)
x=x(:,k);
end