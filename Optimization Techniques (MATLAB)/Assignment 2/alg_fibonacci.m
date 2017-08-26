function [c,k,a,b]=alg_fibonacci(f,l,a,b)
n=1;
while(fibonacci(n)<((b-a)/l))
    n=n+1;
end
x1=a+(fibonacci(n-2)/fibonacci(n))*(b-a);
x2=a+(fibonacci(n-1)/fibonacci(n))*(b-a);
y1=subs(f,{x1});
y2=subs(f,{x2});
c=2;
for k=1:1:(n-2)
    if(y1>y2)
        a=x1;
        x1=x2;
        y1=y2;
        x2=a+(fibonacci(n-k-1)/fibonacci(n-k))*(b-a);
        y2=subs(f,{x2});
    else
        b=x2;
        x2=x1;
        y2=y1;
        x1=a+(fibonacci(n-k-2)/fibonacci(n-k))*(b-a);
        y1=subs(f,{x1});
    end
    c=c+1;
end
end

