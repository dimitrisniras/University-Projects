function r=bgGrad(x)
h=zeros(size(x));
g(1)=x(1)+1;
g(2)=x(2)+1;
gradg{1}=[1 0]';
gradg{2}=[0 1]';
for i=1:2
    v=gradg{i};
    val=g(i);
    h=h+v/(val^2);
end
r=h;
end