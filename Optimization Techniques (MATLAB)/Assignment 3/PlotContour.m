%% Plot the contour of the function.

x0 = [-4:0.005:4];
y0 = [-4:0.005:4];

for i=1:length(x0)
    for j=1:length(y0)
        F(i,j) = f(x0(i),y0(j));
    end
end

%% Plot the contour of the function.
figure(2)
contour(x0,y0,F)