% Digital Filters
% 1st homework
% Dimitris Niras
% 8057

clear all
close all

N = 1000; % number of time steps
n = 1:N;

%% signal
x = (cos(pi*n).*sin((pi/25)*n + pi/3))';

%% noise
v = sqrt(0.19)*randn(N,1); v = v - mean(v); % input to AR process

%% desired signal
d = x + v;

%% Wiener filter input
u = zeros(N,1);
u(1) = v(1);
for i=2:N
    u(i) = -0.78 * u(i-1) + v(i);
end

figure(1)
plot([d x u])
legend({'d(n)', 'x(n)', 'u(n)'})

%% FIR filter
R = [0.4852 -0.3784; -0.3784 0.4852];

P = [0.19; 0];
wo = R\P;

T = [u [0; u(1:N-1)]]; 

yo = T*wo; % The filter

figure(2)
plot([d yo])
legend({'d(n)', 'y(n)'})

%% clean signal
e = d - yo;
figure(3)
plot([e yo]);
legend({'e(n)', 'y(n)'});

%% Steepest descent
w = [-1; -1]; 
mu = 4;

wt = zeros([2,N]); wt(:,1) = w;
y = zeros(N, 1);

s = [0; u];
for i=2:N
  w = w + mu*(P-R*w); % Adaptation steps
  wt(:,i) = w;
  y(i) = s(i:-1:i-1)' * w; % filter
end

figure(4)
plot([d y])
legend({'d(n)', 'y(n)'})

%% parameter error
figure(5)
we = (wt - wo*ones(1,N)).^2;
e = sqrt(sum(we));

semilogy(e);
xlabel('time step n');
ylabel('Parameter error');
title('Parameter error');


%% contour curves and trajectories
L = 50;
ww = linspace(-3,3,L);

J = zeros([L,L]);
sigma2d = 0.1;

% Construct the error surface
for i=1:L
  for k=1:L
    wp = [ww(i); ww(k)];
    J(k,i) = sigma2d - 2*P'*wp + wp'*R*wp;
  end
end

min_J = min(J(:));
max_J = max(J(:));

levels = linspace(min_J,max_J,12);

figure(6)
contour(ww, ww, J, levels); axis square
hold on

plot(wt(1,:), wt(2,:), 'xr--');
hold off
colorbar
xlabel('w(1)');
ylabel('w(2)');
title('Error Surface and Adaptation process');
