% Niras Dimitris  8057
% diminira@auth.gr
% Ergasia 2
% Block LMS algorithm with matrix adaption 

clear all;
close all;

n = 30000; % time steps
T = 100; % number of independent trials
sigma2d = 0.27; % noise variance
M = 3000; % order of the filter
L = M;
kmax = floor(n / L); % integral part

%% channel
mu = [0.075 0.025 0.0075];
mtrials = length(mu);
result = zeros(kmax - 1, size(mu,2));

%% adaption
for mi=1:mtrials
    
    average_J = zeros(kmax - 1,T); % Average errors for Graph
    
    for t=1:T
        %% initialize
        v = randn(n, 1) * sqrt(sigma2d); % Generate gaussian noise with variance = 0.27
        v = v - mean(v);
    
        % Generate input signal
        u = zeros(n, 1);
        u(1) = v(1);
        for i=2:n
            u(i) = (-0.18 * u(i-1)) + v(i);
        end
        
        w = zeros(M, 1);
        y = zeros(n, 1);
        e = zeros(n, 1);
        u_temp = zeros(M,M);
        
        for k=1:kmax-1
            
            for m=0:M-1
                u_temp(m + 1,:) = u((k * M) + m:-1:((k * M) + m - M + 1));
            end
            
            u1 = u_temp(1,:);
            d = plant(u1);
            d = d';
            
            y = u_temp * w;
            e = d - y;
            fi = mu(mi) * u_temp' * e;
            w = w + fi;
            
            average_J(k, t) = sum(e .* e) / M;
            
        end
    end
    
    for k=1:kmax-1
        result(k,mi) = sum(average_J(k,:)) / (T - 1); 
    end
    
end

figure;
semilogy(result);
xlabel('k number');
ylabel('Ee^{2}(n)');
legend({sprintf('mu=%f',mu(1)),sprintf('mu=%f',mu(2)),sprintf('mu=%f',mu(3))});
title('Learning curve M = 3000 (Block LMS algorithm with matrix)');
