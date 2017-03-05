function r=bg(x)
h=0;
g(1)=x(1)+1;
g(2)=x(2)+1;
for i=1:2
    h=h-1/g(i);
end
r=h;  
end