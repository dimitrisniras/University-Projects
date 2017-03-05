function [c,k,a,b]=alg_dixotomou(f,e,l,a,b)
k=1;
c=0;
while((b-a)>=l)
    x1=((a+b)/2)-e;
    x2=((a+b)/2)+e;
    y1=subs(f,{x1});
    y2=subs(f,{x2});
    if(y1<y2)
        b=x2;
    elseif(y1>y2)
        a=x1;
    end
    c=c+2;
    k=k+1;
end
end