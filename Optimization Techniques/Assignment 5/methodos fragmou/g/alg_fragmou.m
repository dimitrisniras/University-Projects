function x=alg_fragmou(e,co)
k=1;
x(:,k)=co;
r(1)=0.2*f(x(:,k))/bg(x(:,k));
while(true)
    x(:,k+1)=alg_meg_kathodou(e,x(:,k),r(k));
    if(norm((g(x(:,k+1))-g(x(:,k)))/g(x(:,k+1)))<=e)
        break;
    end
    r(k+1)=0.8*r(k);
    k=k+1;
    if (k>10000)
        break;
    end
end
PlotContourG
plotResultG(x)
x=x(:,k);
end