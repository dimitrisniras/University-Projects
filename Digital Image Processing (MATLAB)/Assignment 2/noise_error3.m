function [] = noise_error3(y2,x2,h)

[k1,k2] = size(y2); % size of y2 array
[m1,m2] = size(h);  % size of h array
n1 = k1 - m1 + 1;   % horizontal dimension of x2hat array
n2 = k2 - m2 + 1;   % vertical dimension of x2hat array

h(m1 + 1:k1,m2 + 1:k2) = 0; % zero padd of h array
H = fft2(h); % DFT of h array

e = zeros(41,8);
for a = -7:1
    
    y2n = y2 + (10^a) * randn(size(y2)); % output image with noise
    i = 1;
    
    for k = -10:0.5:10
        
        G = wienerfilter(H,10^k);
        x2hat = invfilter(y2n,G,false);
        x2hat = x2hat(1:n1,1:n2);
        
        e(i,a + 8) = immse(x2hat,x2); % square mean error
        i = i + 1;
        
    end
    
end

figure;
semilogy(e);
legend({'a = -7','a = -6','a = -5','a = -4','a = -3','a = -2','a = -1','a = 0','a = 1'});
labels = -10:2.5:10;
set(gca, 'XTick', 1:5:45);
set(gca, 'XTickLabel', labels);
title('Square Mean Error');
xlabel('K');
ylabel('error');

end
