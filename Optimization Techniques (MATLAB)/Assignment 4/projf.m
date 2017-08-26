function r=projf(x)
r=zeros(2,1);

if(x(1)<=-20)
    r(1)=-20;
elseif(x(1)>=10)
    r(1)=10;
else
    r(1)=x(1);
end

if(x(2)<=-12)
    r(2)=-12;
elseif(r(2)>=15)
    r(2)=15;
else
    r(2)=x(2);
end

end