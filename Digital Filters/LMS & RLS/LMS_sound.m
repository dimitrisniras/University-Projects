% Niras Dimitris
% 8057
% diminira@auth.gr
% Ergasia 3 Part B (c)

clear all
close all

load('speakerA.mat');
load('speakerB.mat');

N = length(u); % time steps
coeff = 6600; % order of the filter


%% Wiener filter

% correlation vector
r = xcorr(u,u,coeff-1,'unbiased');
r = r(coeff:(2*coeff - 1));

R = toeplitz(r);

p = xcorr(d,u);
p = p / length(u);
p = p(N:N+coeff-1);

wo = R \ p;

y = filter(wo,1,u);

e = d - y;

sound(e,fs);


%% LMS algorithm
mu = 0.001;

w = zeros(coeff,1);
y = zeros(N,1);
e = zeros(N,1);

for i = coeff+1:N
    y(i) = w' * u(i:-1:i-coeff+1);
    e(i) = d(i) - y(i);
    w = w + mu * e(i) * u(i:-1:i-coeff+1);
end

sound(e,fs);


%% Normalized LMS algorithm
mu = 0.5;
a = 100;

w = zeros(coeff,1);
y = zeros(N,1);
e = zeros(N,1);

for i = (coeff+1):N
    y(i) = w' * u(i:-1:i-coeff+1);
    e(i) = d(i) - y(i);
    w = w + (mu * e(i) * u(i:-1:i-coeff+1)) / (a + norm(u(i:-1:i-coeff+1)) ^ 2);
end

sound(e,fs);


%% RLS algorithm
lambda = 0.99;
delta = 1 / 100;

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
end

sound(e,fs);