function [y] = myconv2freq(x,h)

% matrix dimensions
[M1,M2] = size(x);
[N1,N2] = size(h);
K1 = M1 + N1 - 1;
K2 = M2 + N2 - 1;

% zero padding
x_pad = zeros(K1,K2);
h_pad = zeros(K1,K2);
for i=1:K1
    for j=1:K2
        if (i <= M1 && j <= M2)
            x_pad(i,j) = x(i,j);
        else
            x_pad(i,j) = 0;
        end
        
        if (i<=N1 && j<=N2)
            h_pad(i,j) = h(i,j);
        else
            h_pad(i,j) = 0;
        end
    end
end

X = fft2(x_pad); % fft of zero padded x
H = fft2(h_pad); % fft of zero padded y
Y = X.*H;        % multiply fft of X and fft of Y   
y = ifft2(Y);    % inverse fft of output z 

end
