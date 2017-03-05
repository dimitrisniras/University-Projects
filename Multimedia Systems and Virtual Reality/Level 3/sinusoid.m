function [wL,wR] = sinusoid(N)

n = 0:N/2-1;
wL(n+1) = sin((pi/N)*(n+1/2));
wL = wL';

n = N/2:N-1;
wR(n-N/2+1) = sin((pi/N)*(n+1/2));
wR = wR';

end