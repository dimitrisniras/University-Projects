function [] = noise_error2(y2,x2,h)

e = zeros(4,1);
for a = -7:-4
    y2n = y2 + (10^a) * randn(size(y2)); % output image with noise
    x2hat = invfilter(y2n,h,true);
    e(a + 8) = immse(x2hat,x2); % square mean error
end

figure;
semilogy(e);
labels = -7:-4;
set(gca, 'XTick', 1:4);
set(gca, 'XTickLabel', labels);
title('Square Mean Error');
xlabel('a');
ylabel('error');

end