% Digital Filters
% 1st homework
% Dimitris Niras
% 8057

clear all
close all

load('sound.mat');
load('noise.mat');

n = length(d);
coeff = 60;

a = xcorr(u,u,coeff-1,'unbiased');
a = a(coeff:(2*coeff-1));
R = toeplitz(a);

P = zeros(coeff,1);
P(1) = 0.8;

w = -ones(coeff,1);

mu = 2 / max(eig(R));

wt = zeros([coeff,n]); wt(:,1) = w;
y = zeros(n, 1);

A = zeros(coeff-1,1);
s = [A; u];

for i=coeff:n
  w = w + mu*(P-R*w); % Adaptation steps
  wt(:,i) = w;
  y(i) = s(i:-1:i-59)' * w; % filter
end

y=[y(coeff:end); A];
e = d - y;

sound(e, Fs);