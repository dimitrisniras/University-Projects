function r=pf(x)
h=0;
g(1)=3-x(1);
g(2)=x(1)-30;
g(3)=-25-x(2);
g(4)=x(2)+5;
for i=1:4
    if (g(i)<=0)
        continue;
    else
        h=h+g^2;
    end
end
r=h;   
end