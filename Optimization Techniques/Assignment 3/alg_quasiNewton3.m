function r=alg_quasiNewton3(e,co)
k=1;
r(:,k)=co;
D(:,:,k)=eye(2,2);
grad=gradf(r(1,k),r(2,k));
int=[0 1];
while(norm(grad)>=e)
    d(:,k)=-D(:,:,k)*grad;
    g(k)=quasiNewtonHeur(r(:,k),int,d(:,k));
    r(:,k+1)=r(:,k)+g(k)*d(:,k);
    p(:,k)=r(:,k+1)-r(:,k);
    q(:,k)=gradf(r(1,k+1),r(2,k+1))-grad;
    t(k)=q(:,k)'*D(:,:,k)*q(:,k);
    v(:,k)=(p(:,k)/(p(:,k)'*q(:,k)))-(D(:,:,k)*q(:,k))/t(k);
    D(:,:,k+1)=D(:,:,k)+p(:,k)*p(:,k)'/(p(:,k)'*q(:,k)*g(k))-D(:,:,k) ...
    *q(:,k)*q(:,k)'*D(:,:,k)/t(k)+t(k)*v(:,k)*v(:,k)';
    if(~PosDef(D(:,:,k+1)))
        int(2)=int(2)+1;
        int(1)=int(1)-1;
        continue
    else
        int(1)=0;
        int(2)=0.75;
    end
    k=k+1;
    grad=gradf(r(1,k),r(2,k));
    if(k>100000)
        break;
    end
end
end