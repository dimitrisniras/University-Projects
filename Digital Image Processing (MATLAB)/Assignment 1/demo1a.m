%  Niras Dimitris 8057
%  diminira@auth.gr
%  Ergasia 1 
%  demo1a

clear all
close all

Nmax = 10;
rep = 100;
sum = zeros(Nmax);
order = zeros(Nmax);

for N=2:Nmax
    z = rand(2.^N,2.^N);
    for i=1:rep
        tic
        fft2(z);
        sum(N) =+ toc;
    end
    sum(N) = sum(N) / rep;
    order(N) = N * N * log(N);
end

N = 1:Nmax;
figure;
plotyy(N,sum,N,order);
legend({'fft2 function','theoretical order'});
title('fft2 Times');
xlabel('k');
ylabel('O(N)');
xlim([2 Nmax]);