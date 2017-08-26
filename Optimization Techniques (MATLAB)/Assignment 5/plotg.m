x1=[-40:0.05:10];
x2=x1;
G=zeros(length(x1),length(x2));
for i=1:length(x1)
    for j=1:length(x2)
        G(i,j)=g([x1(i) x2(j)]);
    end
end

figure(1)
mesh(x1,x2,G)
title('g function Graph')
xlabel('x1')
ylabel('x2')
zlabel('g')

figure(2)
contour(x1,x2,G,'ShowText','on')
title('Contour lines of g')
xlabel('x1')
ylabel('x2')

hold on

c2=[-40:0.05:-1];
c1=-ones(size(c2));
plot(c2,c1,'Color','r');

plot(c1,c2,'Color','r');
legend('Contour Lines','Feasible Set')
hold off