function r=BisDeriv(e,int,p)
a(1)=int(1);
b(1)=int(2);
k=1;
grad=gradf(p);
while((b(k)-a(k))>=e)
    x(k)=(a(k)+b(k))/2;
    x0=p-x(k)*grad;
    df=(gradf(x0)')*grad;
    k=k+1;
    if(df>0)
        a(k)=a(k-1);
        b(k)=x(k-1);
    elseif(df<0)
        a(k)=x(k-1);
        b(k)=b(k-1);
    else
        break;
    end
    grad=gradf(x0);
end
r=(a(length(a))+b(length(b)))/2;
end