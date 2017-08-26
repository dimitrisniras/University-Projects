function r=pgradg(x)
h=zeros(size(x));
g(1)=x(1)+1;
g(2)=x(2)+1;
gradg{1}=[1 0]';
gradg{2}=[1 0]';
for i=1:2
    if (g(i)>=0)
        v=gradg{i};
        h=h+2*g(i)*v;
    end
end
r=h;
end