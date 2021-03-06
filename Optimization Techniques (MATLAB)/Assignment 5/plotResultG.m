function []=plotResultG(x)
% Mark the progress of the algorithm on the contour plot.
plot(x(1,2:end-1),x(2,2:end-1),'rx','MarkerSize',12,'LineWidth',3.5);
% Starting Point
plot(x(1,1),x(2,1),'bx','MarkerSize',12,'LineWidth',3.5);
% Last point.
plot(x(1,end),x(2,end),'gx','MarkerSize',12,'LineWidth',3.5);

% Write Origin.
origin=sprintf('Start point=[%f %f]',x(1,1),x(2,1));
text(39,40,origin , ... 
    'VerticalAlignment','top', ...
    'HorizontalAlignment','right', ... 
    'BackgroundColor',[0 0 0] , ...
    'color',[1 1 1]);
% Write min.
min=sprintf('Final point=[%f %f]',x(1,end),x(2,end));
text(39,36,min , ... 
    'VerticalAlignment','top', ...
    'HorizontalAlignment','right', ... 
    'BackgroundColor',[0 0 0], ...
    'color',[1 1 1]);
end