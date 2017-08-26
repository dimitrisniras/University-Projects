function r=alg_suz_klisewn2(e,co)
k=1;
r(:,k)=co;
d=-gradf(r(1,k),r(2,k));
int=[0 1];
g=BisDeriv(e,int,r(:,k));
b=0;
r(:,k+1)=r(:,k)+g*d;
grad=gradf(r(1,k+1),r(2,k+1));
oldgrad=-d;
k=2;
while(norm(grad)>=e)
    b=(grad'*(grad-oldgrad))/(oldgrad'*oldgrad);
    d=-grad+b*d;
    g=BisDeriv(e,int,r(:,k));
    r(:,k+1)=r(:,k)+g*d;
    oldgrad=grad;
    grad=gradf(r(1,k+1),r(2,k+1));
    k=k+1;
    if(k>100000)
       break;
    end
end
end