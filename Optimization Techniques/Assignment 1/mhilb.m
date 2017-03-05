function a=mhilb(n)
a=zeros(n,n);
for i=1:1:n
    for j=1:1:n
        a(i,j)=1/(1+i+j);
    end
end
end

