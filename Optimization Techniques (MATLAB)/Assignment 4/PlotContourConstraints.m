x1=[-40:0.05:40];
x2=x1 ; 
F=zeros(length(x1),length(x2)) ;

for i=1:length(x1)
    for j=1:length(x2)
        F(i,j)=f([x1(i) x2(j)]') ;
    end
end

h=figure(1);
contour(x1,x2,F);
title('Contour Graph');
xlabel('x1')
ylabel('x2')
hold on
t=sprintf('ã=%f',g);
text(20,-30,t, ... 
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','center', ... 
    'BackgroundColor',[0 0 0] , ...
    'color',[1 1 1]);
origin=sprintf('Start point=[%f %f]',r(1,1),r(2,1));
text(-30,-30,origin, ... 
    'VerticalAlignment','bottom' , ...
    'HorizontalAlignment','left', ... 
     'BackgroundColor',[0 0 0], ...
     'color',[1 1 1]);
 sigma=sprintf('S=%f',s);
    text(20,-36,sigma , ... 
    'VerticalAlignment','bottom' , ...
    'HorizontalAlignment' , 'center' , ... 
     'BackgroundColor',[0 0 0] , ...
     'color',[1 1 1]);

%Plot the border defined by the constraints
c1=[-20:0.05:10];
c2=-12*ones(size(c1));
plot(c1,c2,'Color','r');

c1=[-20:0.05:10];
c2=15*ones(size(c1));
plot(c1,c2,'Color','r');

c2=[-12:0.05:15];
c1=-20*ones(size(c2));
plot(c1,c2,'Color','r');

c2=[-12:0.05:15];
c1=10*ones(size(c2));
plot(c1,c2,'Color','r');

h1=plot(r(1,2:length(r(1,:)-1)),r(2,2:length(r(2,:)-1)),'rx','MarkerSize',10,'LineWidth',2);
% Plot the origin.
h2=plot(r(1,1),r(2,1),'bx','MarkerSize',10,'LineWidth',2);
% Plot the final point.
h3=plot(r(1,length(r(1,:))),r(2,length(r(2,:))),'gx','MarkerSize',10,'LineWidth',2);

fp=sprintf('Final point=[%f %f]',r(1,k),r(2,k));
text(-30,-36,fp, ... 
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','left', ... 
     'BackgroundColor',[0 0 0], ...
     'color',[1 1 1]);

 hold off

name=sprintf('Contour_%d',s*10);
saveas(h, [pwd '\Graphs\' name],'jpg');