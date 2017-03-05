i=1;
for x=-2:0.2:2
    j=1;
    for y=-2:0.2:2
        r(i,j)=f(x,y);
        j=j+1;
    end
    i=i+1;
end
x=-2:0.2:2;
y=-2:0.2:2;
surf(x,y,r);