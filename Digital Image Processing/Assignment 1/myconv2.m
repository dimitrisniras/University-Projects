function [y] = myconv2(x,h)

% matrix dimensions
[M1,M2] = size(x);
[N1,N2] = size(h);
K1 = M1 + N1 - 1;
K2 = M2 + N2 - 1;

% zero padding
h_pad = zeros(K1,K2);
for i=1:K1+M1
    for j=1:K2+M2
        if ((i > M1 && i <= M1 + N1) && (j > M2 && j <= M2 + N2))
            h_pad(i,j) = h(i-M1,j-M2);
        else
            h_pad(i,j) = 0;
        end
    end
end

% calculate convolution of x*y using a double sum
y = zeros(K1,K2);
m1 = (1:M1);
m2 = (1:M2);
for i=1:K1
    for j=1:K2
        y(i,j) = sum(sum(x(m1,m2) .* h_pad(i-m1+1+M1,j-m2+1+M2)));
    end
end

end
