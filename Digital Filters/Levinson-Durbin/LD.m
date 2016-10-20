% Niras Dimitris
% 8057
% diminira@auth.gr
% Ergasia 3 Part A (b,c)

clear all
close all

N = 10000;
fo = 1/4;
fi = pi/2;
A = 2.3;
sigma2d = 0.34;
delta = 10;
coeff = 100;

v = randn(N,1) * sqrt(sigma2d); v = v - mean(v); % white noise
x = A * (sin(2*pi*fo*(1:N)' + fi) + cos(4*pi*fo*(1:N)' + fi) + cos(7*pi*fo*(1:N)' + fi/3));
s = x + v;
d = s;

u = zeros(N,1);
for i = delta+1:N+delta
    u(i) = s(i - delta);
end

%% Wiener filter (R, p, wo) with coeff = 100

% corelation vector
r = xcorr(u,u,coeff-1,'unbiased');
r = r(coeff:(2*coeff - 1));

R = toeplitz(r);

p = zeros(coeff,1);
p(1) = sigma2d;

wo = R \ p;

y = filter(wo,1,u(delta+1:length(u)));

figure;
plot((y - v) .^ 2);
hold on


%% Levinson - Durbin algorithm
[a,D,P] = LevinsonDurbin(coeff-1,r);
[ai,~,L,Dp] = LevinsonDurbin_iterative(coeff-1,r); % iterative version of LD algorithm 

e = zeros(coeff-1,1);
for j = 0:coeff-1
    [al,e(j+1)] = levinson(r',j); % MATLAB LD function
end
al = al';

fprintf('Norm of difference with MATLAB levinson (recursive)   %e\n', norm(a - al)) 
fprintf('Norm of difference with MATLAB levinson (iterative) %e\n', norm(ai - al))
fprintf('Difference of backward errors %e\n', norm(e - Dp))
fprintf('Relation between gamma and wo coefficients %e\n', norm((L * al)' - wo'))

yL = filter(a,1,u(delta+1:length(u)));

plot((yL - v) .^ 2);
xlabel('time steps');
ylabel('error');
title('Square Mean Error');
legend('Wiener','Levinson-Durbin');
hold off
