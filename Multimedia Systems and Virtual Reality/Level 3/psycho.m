function [SMR] = psycho(frameT, frameType, frameTprev1, frameTprev2)

%% Initialization
load('TableB219.mat');

if (frameType == 'ESH')
    table = B219b;
    load('spread_short.mat');
    spreadingfun = spread_short;
    l = 8;
    esh_size = 256;
    frameTesh = frameT;
    frameTprev1esh = frameTprev1;
else
    table = B219a;
    load('spread_long.mat');
    spreadingfun = spread_long;
    l = 1;
end

SMR = zeros(size(table,1),l);

for k=1:l
    % Initialize for ESH frames
    if (frameType == 'ESH')
        if (k == 1)
            frameT = frameTesh(1:esh_size);
            frameTprev1 = frameTprev1esh((l-1)*esh_size+1:l*esh_size);
            frameTprev2 = frameTprev1esh((l-2)*esh_size+1:(l-1)*esh_size);
        elseif (k == 2)
            frameT = frameTesh((k-1)*esh_size+1:k*esh_size);
            frameTprev1 = frameTesh(1:esh_size);
            frameTprev2 = frameTprev1esh((l-1)*esh_size+1:l*esh_size);
        else
            frameT = frameTesh((k-1)*esh_size+1:k*esh_size);
            frameTprev1 = frameTesh((k-2)*esh_size+1:(k-1)*esh_size);
            frameTprev2 = frameTesh((k-3)*esh_size+1:(k-2)*esh_size);
        end
    end
    
    N = size(frameT,1);
    
    %% Step 2
    n = 0:N-1;
    Hann = (0.5 - 0.5*cos((pi*(n+0.5))/N))';

    s = frameT .* Hann;
    s_fft = fft(s);

    r = abs(s_fft);
    r = r(1:N/2);
    f = angle(s_fft);
    f = f(1:N/2);

    %% Step 3
    sprev1 = frameTprev1 .* Hann;
    sprev2 = frameTprev2 .* Hann;

    sprev1_fft = fft(sprev1);
    sprev2_fft = fft(sprev2);

    rprev1 = abs(sprev1_fft);
    rprev1 = rprev1(1:N/2);
    fprev1 = angle(sprev1_fft);
    fprev1 = fprev1(1:N/2);

    rprev2 = abs(sprev2_fft);
    rprev2 = rprev2(1:N/2);
    fprev2 = angle(sprev2_fft);
    fprev2 = fprev2(1:N/2);

    r_pred = 2*rprev1 - rprev2;
    f_pred = 2*fprev1 - fprev2;

    %% Step 4
    cw = sqrt((r.*cos(f) - r_pred.*cos(f_pred)).^2 + (r.*sin(f) - r_pred.*sin(f_pred)).^2) ./ (r + abs(r_pred));

    %% Step 5
    e = zeros(size(table,1),1);
    c = zeros(size(table,1),1);

    for i=1:size(table,1)
        for j=table(i,2)+1:table(i,3)+1
            e(i) = e(i) + r(j)^2;
            c(i) = c(i) + cw(j)*(r(j)^2);
        end
    end

    %% Step 6
    ecb = zeros(size(table,1),1);
    ct = zeros(size(table,1),1);
    en = zeros(size(table,1),1);

    for b=1:size(table,1)
        for bb=1:size(table,1)
            ecb(b) = ecb(b) + e(bb) * spreadingfun(bb,b);
            ct(b) = ct(b) + c(bb) * spreadingfun(bb,b);
        end
    end

    cb = ct ./ ecb;

    for b=1:size(table,1)
        en(b) = ecb(b) / sum(spreadingfun(1:size(table,1),b));
    end

    %% Step 7
    tb = -0.229 - 0.43*log(cb);

    %% Step 8
    NMT = 6;
    TMN = 18;
    SNR = tb*TMN + (1-tb)*NMT;

    %% Step 9
    bc = 10 .^ (-SNR/10);

    %% Step 10
    nb = en .* bc;

    %% Step 11
    qthr = eps()*(N/2)*10.^(table(:,6)/10);
    npart = max(nb,qthr);

    %% Step 12
    SMR(:,k) = e ./ npart;

end

end