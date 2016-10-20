% Niras Dimitris  8057
% diminira@auth.gr
% Ergasia 2
% Block LMS algorithm with FFT

clear all;
close all;

n = 30000; % time steps
T = 100; % number of independent trials
sigma2d = 0.27; % noise variance
M = 3000; % order of the filter
L = M;
kmax = floor(n / L); % integral part

%% channel
result = zeros(kmax - 1);
average_J = zeros(kmax - 1,T);

% Generate gaussian noise with variance = 0.27
v = randn(n, 1) * sqrt(sigma2d); 
v = v - mean(v);
    
% Generate input signal
u = zeros(n, 1);
u(1) = v(1);
for i=2:n
    u(i) = (-0.18 * u(i-1)) + v(i);
end

for t=1:T
    
    W = zeros(2*M,1);
    P = zeros(2*M,1);
    
    for k=1:kmax-1
        u_temp = fft(u((k-1)*M+1:(k+1)*M) ,2*M);
		yzer = ifft(u_temp .* W);
		y = yzer(M+1:2*M);
		d = plant(u_temp);
		d = d';
		
		e(k*M+1:(k+1)*M ,1) = d - y;
        average_J(k,trial) = sum(e(k*M+1:(k+1)*M,1).^2) / M;
		
		%estimated power 
        ffact = 0.3; %forgetting factor
        P = ffact * P + (1-ffact) * abs(u) .^ 2; %estimation of Pi
        
        %transformation of estimation error 
        Uvec = fft( [zeros(M,1)' e(kM+1:(k+1)*M)']' ,2*M );
		
        %block k, inverse of power
        Dvec = 1 ./ P;
		
        %estimated gradient
        fizer = ifft( Dvec .* conj(u) .* Uvec ,2*M );
        fi = fizer(1:M);
		
        %update of weights
        step = 0.4; %step size
        W = W + step * fft([fi;zeros(M,1)],2*M);
    end
	
	% transform of final weights to time domain.
    % make sure that w is real-valued
    w = ifft(W);
    w = real(w(1:length(W) / 2));
    
end

for k=1:kmax-1
    result(k) = sum(average_J(k,:)) / (T - 1);
end

figure;
semilogy(result);
xlabel('k number');
ylabel('Ee^{2}(n)');
title('Learning curve M = 3000, ì dynamic (Block LMS algorithm with FFT)');
