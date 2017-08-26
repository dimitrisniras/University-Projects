x1=[-30:0.05:30];
x2=x1;
F=zeros(length(x1),length(x2));
for i=1:length(x1)
    for j=1:length(x2)
        F(i,j)=f([x1(i) x2(j)]);
    end
end

figure(1)
mesh(x1,x2,F)
xlabel('x1')
ylabel('x2')
zlabel('f')

figure(2)
contour(x1,x2,F,'ShowText','on')
title('Contour lines of f')
xlabel('x1')
ylabel('x2')

hold on
c1=[3:0.05:30];
c2=-25*ones(size(c1));
plot(c1,c2,'Color','r');

c1=[3:0.05:30];
c2=-5*ones(size(c1));
plot(c1,c2,'Color','r');

c2=[-25:0.05:-5];
c1=3*ones(size(c2));
plot(c1,c2,'Color','r');

c2=[-25:0.05:-5];
c1=30*ones(size(c2));
plot(c1,c2,'Color','r');
legend('Contour Lines','Feasible Set')
hold off