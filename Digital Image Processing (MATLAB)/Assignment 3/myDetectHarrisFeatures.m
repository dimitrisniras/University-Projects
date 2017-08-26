function [corners] = myDetectHarrisFeatures(I)

%% variables declaration
sigma = 1; 
radius = 1;
threshold = 420;
size = 2*radius + 1;                % size of matrix filter

dx = [-1 0 1; -1 0 1; -1 0 1];      % x derivative of matrix
dy = dx';                           % y derivative of matrix

w = fspecial('gaussian', max(1, fix(10*sigma)), sigma);

%% Image derivatives computing
Ix = conv2(double(I), dx, 'same');
Iy = conv2(double(I), dy, 'same');

A = conv2(Ix.^2, w, 'same');
B = conv2(Iy.^2, w, 'same');
C = conv2(Ix.*Iy, w, 'same');

%% Harris Corner measure
harris = (A.*B - C.^2) ./ (A + B + eps);

%% Local maxima searching
mx = ordfilt2(harris, size.^2, ones(size));

harris = (harris == mx) & (harris > threshold);

%% Corners result
[rows, cols] = find(harris);
corners = cornerPoints([cols rows]);

end
