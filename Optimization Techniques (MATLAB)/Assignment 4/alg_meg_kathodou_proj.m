function r=alg_meg_kathodou_proj(e,g,s,co)
k=1;
r(:,k)=co;
rbar(:,k)=zeros(size(co));
proj=projf(r(:,k)-s*gradf(r(:,k)));
while(norm(r(:,k)-proj)>=e)
    rbar(:,k)=proj;
    r(:,k+1)=r(:,k)+g*(rbar(:,k)-r(:,k));
    k=k+1;
    proj=projf(r(:,k)-s*gradf(r(:,k)));
    if(k>100000)
        break;
    end
end
%Plot the contour of function
PlotContourConstraints;
end