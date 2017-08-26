%  Niras Dimitris 8057
%  diminira@auth.gr
%  Ergasia 1
%  demo1b

clear all
close all

Nmax = 10;
rep = 100;
sum = zeros(Nmax);
h = rand(64,64);

for N=2:Nmax
    x = rand(2.^N,2.^N);
    for i=1:rep
        tic
        conv2(x,h);
        sum(N) =+ toc;
    end
    sum(N) = sum(N) / rep;
end

figure;
plot(sum);
xlabel('k');
ylabel('time');
xlim([2 Nmax]);
title('conv2 times');