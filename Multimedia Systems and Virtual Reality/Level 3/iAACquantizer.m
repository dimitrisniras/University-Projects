function [frameF] = iAACquantizer(S, sfc, G, frameType)

load('TableB219.mat');

if (frameType == 'ESH')
    table = B219b;
    Nb = size(table,1);
    frameSize = 128;
    frames = 8;
    a = zeros(Nb,frames);
    frameF = cell(frames,1);
    b = 2:Nb;
    
    for i=1:frames
        a(1,i) = G(i);
        a(b,i) = sfc(b-1,i) + a(b-1,i);
    end
    
    for i=1:frames
        temp = zeros(frameSize,1);
        for b=1:Nb
            for k=table(b,2)+1:table(b,3)+1
                temp(k) = sign(S(k+(i-1)*frameSize)) * abs(S(k+(i-1)*frameSize))^(4/3) * 2^(0.25*a(b,i));
            end
        end
        frameF{i} = temp;
    end
    
else
    table = B219a;
    Nb = size(table,1); 
    frameSize = 1024;
    a = zeros(Nb,1);
    frameF = zeros(frameSize,1);
    b = 2:Nb;
   
    a(1) = G;
    a(b) = sfc(b-1) + a(b-1);
   
    for b=1:Nb
        for k=table(b,2)+1:table(b,3)+1
            frameF(k) = sign(S(k)) * abs(S(k))^(4/3) * 2^(0.25*a(b));
        end
    end
end

end