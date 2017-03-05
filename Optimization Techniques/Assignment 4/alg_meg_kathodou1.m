function r=alg_meg_kathodou1(e,g,co)
k=1;
r(:,k)=co;
while(norm(r(:,k))>=e)
    d=-gradf(r(:,k));
    r(:,k+1)=r(:,k)+g*d;
    k=k+1;
    if(k>100000)
        break;
    end
end
%Plot the contour of function
PlotContour;
end
