function [S, sfc, G] = AACquantizerL(frameF, frameType, SMR)
% in
% frameF: The frame in the frequency domain in the form of the MDCT
%         coefficients. Dimensions: 1024*1.
% frameType: The type of the frame
% SMR: Signal to Mask Ratio, 42*8 for EIGHT SHORT SEQUENCE, 69*1
%     otherwise. The output of the psychoacoustic model
%
% out
% S: Matrix 1024*1 with the quantization symbols of the MDCT
%    coefficients of the current frame.
% sfc: Matrix NB*8 for EIGHT SHORT SEQUENCE frames and NB*1 for
%      all the other frametypes. The values of the scalefactor
%      coefficients for each Scalefactor Band.
% G: The global gain of the current frame(1*8 for ESH, 1 value otherwise)

B = load('TableB219.mat'); % load the psychoacoustic model's bands
B219a = B.B219a;
B219b = B.B219b;

if strcmp(frameType,'ESH')~=1
    
    X = frameF;
    
    % Calculating the thresholds for every band
    NB = length(B219a(:,1));
    wlow = B219a(:,2);
    whigh = B219a(:,3);
    
    P = zeros(NB,1);
    T = zeros(NB,1);
    for b = 1:NB
        for k = wlow(b)+1:whigh(b)+1
            P(b) = P(b) + X(k)^2;
        end
        T(b) = P(b) / SMR(b);
    end
        
    % Quantizing the MDCT coefficients
    MQ = 8191;
    a = zeros(NB,1) + 16/3*log2((max(X)).^0.75/MQ);
    S = zeros(1024,1);
    Xhat = zeros(1024,1);
    for k = 1:1024
        if sign(X(k))>=0 %ceil
            S(k) = sign(X(k))*ceil((abs(X(k))*2^(-0.25*a(1)))^0.75 + 0.4054);
        else %floor
            S(k) = sign(X(k))*floor((abs(X(k))*2^(-0.25*a(1)))^0.75 + 0.4054);
        end
        Xhat(k) = sign(S(k))*abs(S(k))^(4/3)*2^(0.25*a(1));
    end
    
    % Calculating the scalefactor gains
    Pe = zeros(NB,1);
    
    b = 1;
    Pe(b) = sum( (X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
    while Pe(b) < T(b) && abs(a(b+1) - a(b))<=60
        a(b) = a(b) + 1;
        for k = wlow(b)+1:whigh(b)+1
            Xhat(k) = sign(S(k))*abs(S(k))^(4/3)*2^(0.25*a(b));
        end
        Pe(b) = sum( (X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
        
    end
    if abs(a(b+1) - a(b))>60
        a(b) = a(b) - 1;
    end
    
    for b = 2:NB-1
        Pe(b) = sum( ( X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
        while Pe(b) < T(b) && abs(a(b+1) - a(b))<=60 && abs(a(b) - a(b-1))<=60
            a(b) = a(b) + 1;
            for k = wlow(b)+1:whigh(b)+1
                Xhat(k) = sign(S(k))*abs(S(k))^(4/3)*2^(0.25*a(b));
            end
            Pe(b) = sum( (X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
        end
        if abs(a(b+1) - a(b))>60 || abs(a(b) - a(b-1))>60
            a(b) = a(b) - 1;
        end
    end
    
    
    b = NB;
    Pe(b) = sum( (X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
    while Pe(b) < T(b) && abs(a(b) - a(b-1))<=60
        a(b) = a(b) + 1;
        for k = wlow(b)+1:whigh(b)+1
            Xhat(k) = sign(S(k))*abs(S(k))^(4/3)*2^(0.25*a(b));
        end
        Pe(b) = sum( (X(wlow(b)+1:whigh(b)+1)- Xhat(wlow(b)+1:whigh(b)+1)).^2 );
        
    end
    if abs(a(b) - a(b-1))>60
        a(b) = a(b) - 1;
    end
    
    % Quantizing the MDCT coefficients
    for b = 1:NB
        for k = wlow(b)+1:whigh(b)+1
            if sign(X(k))>=0 %ceil
                S(k) = sign(X(k))*ceil((abs(X(k))*2^(-0.25*a(b)))^0.75 + 0.4054);
            else %floor
                S(k) = sign(X(k))*floor((abs(X(k))*2^(-0.25*a(b)))^0.75 + 0.4054);
            end
        end
    end
    
    % Scalefactor coefficients
    G = a(1);
    sfc = zeros(NB,1);
    sfc(1) = G;
    for b = 2:NB
        sfc(b) = a(b) - a(b-1);
    end
    
    sfc = sfc(2:NB);
    
else
    
    X = zeros(1024,1);
    for j=1:8
        X((j-1)*128+1:j*128) = frameF(:,j);
    end
    
    % Calculating the thresholds for every band
    NB = length(B219b(:,1));
    wlow = B219b(:,2);
    whigh = B219b(:,3);
    
    P = zeros(NB,8);
    T = zeros(NB,8);
    for j = 1:8
        for b = 1:NB
            for k = wlow(b)+1:whigh(b)+1
                P(b,j) = P(b,j) + X(k+(j-1)*128)^2;
            end
            T(b,j) = P(b,j) / SMR(b,j);
        end
    end
    
    % Quantizing the MDCT coefficients
    MQ = 8191;
    a = zeros(NB,8);
    for j = 1:8
        maximum = max(X((j-1)*128+1:j*128));
        a(:,j) = a(:,j) + 16/3*log2((maximum)^0.75/MQ);
    end
    S = zeros(1024,1);
    Xhat = zeros(1024,1);
    for j = 1:8
        for k = wlow(b)+1:whigh(b)+1
            if sign(X(k+(j-1)*128))>=0 %ceil
                S(k+(j-1)*128) = sign(X(k+(j-1)*128))*ceil((abs(X(k+(j-1)*128))*2^(-0.25*a(1,1)))^0.75 + 0.4054);
            else %floor
                S(k+(j-1)*128) = sign(X(k+(j-1)*128))*floor((abs(X(k+(j-1)*128))*2^(-0.25*a(1,1)))^0.75 + 0.4054);
            end
            Xhat(k+(j-1)*128) = sign(S(k+(j-1)*128))*abs(S(k+(j-1)*128))^(4/3)*2^(0.25*a(1,1));
        end
    end
    
    % Calculating the scalefactor gains
    Pe = zeros(NB,8);
    
    for j = 1:8
        
        b = 1;
        Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
        while Pe(b,j) < T(b,j) && abs(a(b+1,j) - a(b,j))<=60
            a(b,j) = a(b,j) + 1;
            for k = wlow(b)+1:whigh(b)+1
                Xhat(k+(j-1)*128) = sign(S(k+(j-1)*128))*abs(S(k+(j-1)*128))^(4/3)*2^(0.25*a(b,j));
            end
            Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
            
        end
        if abs(a(b+1,j) - a(b,j))>60
            a(b,j) = a(b,j) - 1;
        end
        
        for b = 2:NB-1
            Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
            while Pe(b,j) < T(b,j) && abs(a(b+1,j) - a(b,j))<=60 && abs(a(b,j) - a(b-1,j))<=60
                a(b,j) = a(b,j) + 1;
                for k = wlow(b)+1:whigh(b)+1
                    Xhat(k+(j-1)*128) = sign(S(k+(j-1)*128))*abs(S(k+(j-1)*128))^(4/3)*2^(0.25*a(b,j));
                end
                Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
            end
            if abs(a(b+1,j) - a(b,j))>60 || abs(a(b,j) - a(b-1,j))>60
                a(b,j) = a(b,j) - 1;
            end
        end
        
        
        b = NB;
        Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
        while Pe(b,j) < T(b,j) && abs(a(b,j) - a(b-1,j))<=60
            a(b,j) = a(b,j) + 1;
            for k = wlow(b)+1:whigh(b)+1
                Xhat(k+(j-1)*128) = sign(S(k+(j-1)*128))*abs(S(k+(j-1)*128))^(4/3)*2^(0.25*a(b,j));
            end
            Pe(b,j) = sum( (X(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)- Xhat(wlow(b)+1+(j-1)*128:whigh(b)+1+(j-1)*128)).^2 );
            
        end
        if abs(a(b,j) - a(b-1,j))>60
            a(b,j) = a(b,j) - 1;
        end
        
    end

   % Quantizing the MDCT coefficients
    for j = 1:8
        for b = 1:NB
            for k = wlow(b)+1:whigh(b)+1
                if sign(X(k+(j-1)*128))>=0 %ceil
                    S(k+(j-1)*128) = sign(X(k+(j-1)*128))*ceil((abs(X(k+(j-1)*128))*2^(-0.25*a(b,j)))^0.75 + 0.4054);
                else %floor
                    S(k+(j-1)*128) = sign(X(k+(j-1)*128))*floor((abs(X(k+(j-1)*128))*2^(-0.25*a(b,j)))^0.75 + 0.4054);
                end
            end
        end
    end
    
    % Scalefactor coefficients
    G = zeros(1,8);
    sfc = zeros(NB,8);
    for j = 1:8
        G(j) = a(1,j);
        sfc(1,j) = G(j);
        for b = 2:NB
            sfc(b,j) = a(b,j) - a(b-1,j);
        end    
    end
    
    sfc = sfc(2:NB,:);
    
end
end
