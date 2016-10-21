% Niras Dimitris
% 8057
% diminira@auth.gr
% Ergasia 3 Part B (a,b)

clear all
close all

N = 3000; % number of samples
coeff = 11; % order of filter
sigma2d1 = 0.73;
sigma2d2 = 0.39;

v1 = randn(N,1) * sqrt(sigma2d1); v1 = v1 - mean(v1); % white noise
v2 = randn(N,1) * sqrt(sigma2d2); v2 = v2 - mean(v2); % white noise

u = zeros(N,1);
x = zeros(N,1);
s = zeros(N,1);
y = zeros(N,1);

u(1) = v1(1);
u(2) = -0.87*u(1) + v1(2);
u(3) = -0.87*u(2) - 0.12*u(1) + v1(3);
for i = 4:N
    u(i) = -0.87*u(i-1) - 0.12*u(i-2) - 0.0032*u(i-3) + v1(i);
end

x(1) = v2(1);
x(2) = -0.57*x(1) + v2(2);
x(3) = -0.57*x(2) - 0.16*x(1) + v2(3);
for i = 4:N
    x(i) = -0.57*x(i-1) - 0.16*x(i-2) - 0.08*x(i-3) + v2(i);
end

s(1) = -0.23*u(1);
s(2) = -0.23*u(2) + 0.67*u(1);
s(3) = -0.23*u(3) + 0.67*u(2) - 0.18*u(1);
for i = 4:N
    s(i) = -0.23*u(i) + 0.67*u(i-1) - 0.18*u(i-2) + 0.39*u(i-3);
end

d = s + x;

%% A) Wiener filter (R, p, wo)

% correlation vector
r = xcorr(u,u,coeff-1,'unbiased');
r = r(coeff:(2*coeff - 1));

R = toeplitz(r);

p = xcorr(d,u);
p = p / length(u);
p = p(N:N+coeff-1);

wo = R \ p;

for i = coeff+1:N
     y(i) = wo' * u(i:-1:i-coeff+1);
end

e = d - y;

figure(1);
semilogy((e - x) .^2);
title('Wiener Square Mean Error');
xlabel('time steps');
ylabel('Ee^{2}(n)');



%% B) LMS, Normalized LMS and RLS algorithms

%% LMS algorithm
mu = 0.001;

w = zeros(coeff,1);
y = zeros(N,1);
e = zeros(N,1);
J = zeros(N,1);

for i = coeff+1:N
    y(i) = w' * u(i:-1:i-coeff+1);
    e(i) = d(i) - y(i);
    w = w + mu * e(i) * u(i:-1:i-coeff+1);
    J(i) = (e(i) - x(i)) ^ 2;
end

figure(2);
semilogy(J);
title('LMS Square Mean Error');
xlabel('time steps');
ylabel('Ee^{2}(n)');


%% Normalized LMS algorithm
mu = 0.5;
a = 100;

w = zeros(coeff,1);
y = zeros(N,1);
e = zeros(N,1);
J = zeros(N,1);

for i = (coeff+1):N
    y(i) = w' * u(i:-1:i-coeff+1);
    e(i) = d(i) - y(i);
    w = w + (mu * e(i) * u(i:-1:i-coeff+1)) / (a + norm(u(i:-1:i-coeff+1)) ^ 2);
    J(i) = (e(i) - x(i)) ^ 2;
end

figure(3);
semilogy(J);
title('Normalized LMS Square Mean Error');
xlabel('time steps');
ylabel('Ee^{2}(n)');


%% RLS algorithm
lambda = 1;
delta = 1 / 250;

w = zeros(coeff,1);
y = zeros(N,1);
e = zeros(N,1);
J = zeros(N,1);
P = (1 / delta) * eye(coeff,coeff);

for i = coeff+1:N
    y(i) =   w' * u(i:-1:i-coeff+1);
    k = ((lambda ^ -1) * P * u(i:-1:i-coeff+1)) / (1 + (lambda ^ -1) * u(i:-1:i-coeff+1)' * P * u(i:-1:i-coeff+1));
    e(i) = d(i) - y(i);
    w = w + k * e(i);
    P = (lambda ^ -1) * P - (lambda ^ -1) * k * u(i:-1:i-coeff+1)' * P;
    J(i) = (e(i) - x(i)) ^ 2;
end

figure(4);
semilogy(J);
title('RLS Square Mean Error');
xlabel('time steps');
ylabel('Ee^{2}(n)');

