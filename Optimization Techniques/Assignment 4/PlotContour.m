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
 
name=sprintf('Contour_%d',g*100000);
saveas(h, [pwd '\Graphs\' name],'jpg');