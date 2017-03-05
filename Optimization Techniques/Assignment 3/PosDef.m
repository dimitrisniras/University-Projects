function flag=PosDef(Mat)
L=eig(Mat);
flag=true;
for i=1:length(L)
    if (L(i)<=0)
        flag=false;
        break;
    end
end
end