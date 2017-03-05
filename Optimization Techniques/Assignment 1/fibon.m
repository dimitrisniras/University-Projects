function a=fibon(a0,a1,n)
a=zeros(size(n));
a(1)=a0;
a(2)=a1;
for i=3:1:n
    a(i)=a(i+1)-a(i-1);
end
end
