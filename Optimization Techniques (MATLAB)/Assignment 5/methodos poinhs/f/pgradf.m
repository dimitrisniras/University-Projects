function r=pgradf(x)
h=zeros(size(x));
g(1)=3-x(1);
g(2)=x(1)-30;
g(3)=-25-x(2);
g(4)=x(2)+5;
gradg{1}=[-1 0]';
gradg{2}=[1 0]';
gradg{3}=[0 -1]';
gradg{4}=[0 1]';
for i=1:4
    if (g(i)>=0)
        v=gradg{i};
        h=h+2*g(i)*v;
    end
end
r=h;
end