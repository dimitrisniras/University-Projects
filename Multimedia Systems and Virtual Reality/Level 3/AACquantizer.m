function [S, sfc, G] = AACquantizer(frameF, frameType, SMR)

%% Initialization
load('TableB219.mat');

if (frameType == 'ESH')
    table = B219b;
    frameSize = size(frameF{1},1);
    temp = frameF;
    l = 8;
else
    table = B219a;
    frameSize = size(frameF,1);
    l = 1;
end

Nb = size(table,1);
sfc = zeros(Nb,l);
G = zeros(1,l);
S = zeros(frameSize,l);

for i=1:l
    % Initialize for ESH frames
    if (frameType == 'ESH')
        frameF = temp{i};
    end
    
    %% Tb calculation
    P = zeros(Nb,1);
    T = zeros(Nb,1);

    for b=1:Nb
        P(b) = sum(frameF(table(b,2)+1:table(b,3)+1).^2);
        T(b) = P(b) / SMR(b,i);
    end

    %% Scalefactor gains calculation
    % Step 1
    a = zeros(Nb,1);
    MQ = 8191;
    b = 1:Nb;

    a(b) = 16/3 .* log2((max(frameF)^(3/4))/MQ);

    % Step 2
    X = zeros(frameSize,1);
    Pe = zeros(Nb,1);
    MagicNumber = 0.4054;
    k = 1:frameSize;

    S(k,i) = sign(frameF(k)) .* round(((abs(frameF(k))*2^(-0.25*a(1))).^0.75 + MagicNumber));
    X(k) = sign(S(k,i)) .* abs(S(k,i)).^(4/3) * 2^(0.25*a(1));

    for b=1:Nb
        Pe(b) = sum((frameF(table(b,2)+1:table(b,3)+1) - X(table(b,2)+1:table(b,3)+1)).^2);
        
        if (b == 1)
            while (Pe(b) < T(b) && abs(a(b+1) - a(b)) < 60)
                a(b) = a(b) + 1;
                for k=table(b,2)+1:table(b,3)+1
                    X(k) = sign(S(k,i)) .* abs(S(k,i)).^(4/3) * 2^(0.25*a(b));
                end
                Pe(b) = sum((frameF(table(b,2)+1:table(b,3)+1) - X(table(b,2)+1:table(b,3)+1)).^2);
            end
        elseif (b < Nb)
            while (Pe(b) < T(b) && abs(a(b+1) - a(b)) < 60 && abs(a(b-1) - a(b)) < 60)
                a(b) = a(b) + 1;
                for k=table(b,2)+1:table(b,3)+1
                    X(k) = sign(S(k,i)) .* abs(S(k,i)).^(4/3) * 2^(0.25*a(b));
                end
                Pe(b) = sum((frameF(table(b,2)+1:table(b,3)+1) - X(table(b,2)+1:table(b,3)+1)).^2);
            end
        else
            while (Pe(b) < T(b) && abs(a(b-1) - a(b)) < 60)
                a(b) = a(b) + 1;
                for k=table(b,2)+1:table(b,3)+1
                    X(k) = sign(S(k,i)) .* abs(S(k,i)).^(4/3) * 2^(0.25*a(b));
                end
                Pe(b) = sum((frameF(table(b,2)+1:table(b,3)+1) - X(table(b,2)+1:table(b,3)+1)).^2);
            end
        end
    end
    
    for b = 1:Nb
        for k = table(b,2)+1:table(b,3)+1
            S(k,i) = sign(X(k))*round((abs(X(k))*2^(-0.25*a(b)))^0.75 + 0.4054);
        end
    end

    % final step
    G(1,i) = a(1);
    b = 2:Nb;

    sfc(1,i) = G(1,i);
    sfc(b,i) = a(b) - a(b-1);
    sfc = sfc(2:end,:);
    
end

if (frameType == 'ESH')
    temp = zeros(frameSize*l,1);
    
    for i=1:l
        temp(frameSize*(i-1)+1:frameSize*i) = S(:,i);
    end
    
    S = temp;
end

end