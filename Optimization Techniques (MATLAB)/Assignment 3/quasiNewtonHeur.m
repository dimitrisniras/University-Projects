function output=quasiNewtonHeur(x,int,d)
persistent a 
persistent b 
if isempty(a)
  	a=10^(-3);
end
if isempty(b)
   b=0.9 ;
end
funcGrad=gradf(x(1),x(2));
g=[int(1):a:int(2)];
xVal=f(x(1),x(2));
minVal=inf;
index=length(g);
for i=1:length(g)
    xNew=x+g(i)*d;
    val=f(xNew(1),xNew(2));
    if (val<=xVal+a*g(i)*d'*funcGrad)   
        if (val<minVal)
            minVal=val;
            index=i;
        end
        if (d'*gradf(xNew(1),xNew(2))>b*d'*funcGrad)  
            break;
        end
    end
end
output=g(index);
end