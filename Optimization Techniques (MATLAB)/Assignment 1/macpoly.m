function p=macpoly(n,x)
p=0;
for k=0:1:n
    p=p+((x.^k)/(factorial(k)));
end
end
