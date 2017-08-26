function [c,k,a,b]=alg_dixotomou_me_paragwgo(f,l,a,b)
k=1;
n=1;
c=0;
while(((1/2)^n)>(l/(b-a)))
    n=n+1;
end
fp=diff(f,'x');
for k=1:1:(n+1)
    x=(a+b)/2;
    yp=subs(fp,{x});
    c=c+1;
    if(yp==0)
        a=x;
        b=x;
        return
    elseif(yp>0)
        b=x;
    else
        a=x;
    end
end
end