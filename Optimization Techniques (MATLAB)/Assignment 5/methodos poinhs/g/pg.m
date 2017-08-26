function r=pg(x)
h=0;
g(1)=x(1)+1;
g(2)=x(2)+1;
for i=1:2
    if (g(i)<=0)
        continue;
    else
        h=h+g^2;
    end
end
r=h;   
end