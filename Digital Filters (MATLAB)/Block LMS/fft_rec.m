function [y] = fft_rec(x)

n = length(x);

if n == 1
    y = x;
else
    m = n/2;
    y_top = fft_rec(x(1:2:(n-1)));
    y_bot = fft_rec(x(2:2:n));
    d = exp(-2 * pi * 1i / n) .^ (0:m-1);
    z = d .* y_bot;
    y = [y_top + z , y_top - z];
end

end