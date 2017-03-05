x1=-40:0.05:40;
x2=x1;
F=zeros(length(x1),length(x2));

for i=1:length(x1)
    for j=1:length(x2)
        F(i,j)=f([x1(i) x2(j)]');
    end
end
h=mesh(x1,x2,F);
xlabel('x1');
ylabel('x2');
zlabel('f');

name=sprintf('F');
saveas(h, [pwd '\Graphs\' name],'jpg');