% Niras Dimitris
% 8057
% diminira@auth.gr
% Ergasia 3 Part A (d)

clear all
close all

load('music.mat');

N = length(s);
delta = 100;
coeff = 100;

u = zeros(N,1);
for i = delta+1:N
    u(i) = s(i-delta);
end

% correlation vector
r = xcorr(s,s,coeff-1,'unbiased');
r = r(coeff:(2*coeff - 1));

a = LevinsonDurbin(coeff-1,r); % Levinson-Durbin coefficients

y = filter(a,1,u);

sound(50*y,fs)

