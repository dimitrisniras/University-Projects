function r=bf(x)
h=0;
g(1)=3-x(1);
g(2)=x(1)-30;
g(3)=-25-x(2);
g(4)=x(2)+5;
for i =1:4
    h=h-1/g(i);
end
r=h;  
end