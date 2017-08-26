function [x2hat] = invfilter(y2,h,isMask)

[k1,k2] = size(y2); % size of y2 array
[n1,n2] = size(h);  % size of h array
m1 = k1 - n1 + 1;   % horizontal dimension of x2hat array
m2 = k2 - n2 + 1;   % vertical dimension of x2hat array

Y2 = fft2(y2);      % DFT of y2

if (isMask == true)
    
    h(n1 + 1:k1, n2 + 1:k2) = 0; % zero padd of h array
    
    H = fft2(h); % DFT of h array
    G = H.^-1;   % inverse filter
    
    X2hat = G .* Y2; 
    x2hat = ifft2(X2hat); % IDFT of X2hat
    x2hat = x2hat(1:m1,1:m2); % x2hat dimension = dimension of x2
    
elseif (isMask == false)
    
    X2hat = h .* Y2;
    x2hat = ifft2(X2hat);
    
end

end