% Niras Dimitris  8057
% diminira@auth.gr
% Ergasia 2
% Block LMS algorithm with FFT (uncostrained)

clear all;
close all;

n = 2000000; % time steps
T = 100; % number of independent trials
sigma2d = 0.27; % noise variance
M = 3000; % order of the filter
L = M;
kmax = floor(n / L); % integral part

%% channel
result = zeros(kmax - 1);
average_J = zeros(kmax - 1,T);

for t=1:T
    
    % Generate gaussian noise with variance = 0.27
    v = randn(1, n) * sqrt(sigma2d); 
    v = v - mean(v);

    % Generate input signal
    u = zeros(1, n);
    u(1) = v(1);
    for i=2:n
        u(i) = (-0.18 * u(i-1)) + v(i);
    end

    d = plant(u);
    
    W = zeros(1,2*M);
    
    for k=2:kmax
        
        if (k == 2)
            p = var(u((k-1)*L+1:k*L)) * autocorr(u((k-1)*L+1:k*L),L-1);
            mu = 0.4 * (2 / (L * eigs(toeplitz(p),1,'la')));
        end
        
        z = fft(u((k-2)*L+1:k*L));
        o = ifft(z .* W);
        y = o(L+1:2*L);
        e = d((k-1)*L+1:k*L) - y;
        E = fft([zeros(1,L) e]);
        W = W + (mu * conj(z) .* E);
        average_J(k,t) = sum(e .^ 2);
        
    end
    
end

for k=1:kmax-1
    result(k) = sum(average_J(k,:)) / (T - 1);
end

figure;
semilogy(result);
xlabel('k number');
ylabel('Ee^{2}(n)');
title('Learning curve M = 3000, ì dynamic (Block LMS algorithm with FFT(unconstrained))');
