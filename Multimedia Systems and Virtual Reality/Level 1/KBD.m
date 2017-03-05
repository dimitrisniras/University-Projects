function [wL,wR] = KBD(N)

wL = zeros(N/2,1);

if (N > 256)
    a = 6;
else
    a = 4;
end
    
w = besseli(0, pi*a*sqrt(1-(2*(0:N/2)/(N/2)-1).^2)) / besseli(0, pi*a);
sumw = 0;

for i=1:N/2
    sumw = sumw + w(i);
    wL(i) = sumw;
end

wR = wL(N/2:-1:1);

wL = sqrt(wL / (sumw + w(N/2+1)));
wR = sqrt(wR / (sumw + w(N/2+1)));

end