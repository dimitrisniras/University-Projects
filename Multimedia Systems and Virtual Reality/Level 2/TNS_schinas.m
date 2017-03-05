function [frameFout, TNScoeffs] = TNS(frameFin, frameType)
%% step 1
load('TableB219.mat')
if(frameType == 'ESH') % mallon prepei na ginei me eos 256 opou exei 128
    frameIn = zeros (8,128);
    for i=1:8 
        frameIn(i,:) = frameFin{i,1}; 
    end
    frameIn = frameIn';
    Nb = 42;
    P = zeros(Nb,8);
    Sw = zeros(Nb,8);
    Xw = zeros(Nb,8);
    for i = 1:8
        for j=1:Nb
            P(j,i) = sum( frameIn( B219b(j,2)+1:B219b(j,3)+1 , i ).^2 );
        end
    end
    for i=1:8
        for k = 1:128 % na dw me find gia taxuthta kai vectorization
            for j = 1:Nb-1
                 if B219b(j,2)<= k && k < B219b(j+1,2)
                     break;
                 end
            end
         Sw(k,i) = sqrt(P(j,i));
        end
    end
    for i = 1:8
        for k = 126 : -1 : 1
            Sw(k,i) = (Sw(k,i) + Sw(k + 1,i))/2;
        end
        for k = 2 : +1 : 127
            Sw(k,i) = (Sw(k,i) + Sw(k-1,i))/2;
        end
    end
    
    Xw(1:128,:) = frameIn(1:128,:) ./ Sw(1:128,:) ;
else
    Nb = 69;
    P = zeros(Nb,1);
    Sw = zeros(length(frameFin),1);
    Xw = zeros(length(frameFin),1);
    for j=1:Nb
        P(j) = sum( frameFin( B219a(j,2)+1:B219a(j,3)+1 ).^2 );
    end
    for k = 1:1024 % na dw me find gia taxuthta kai vectorization
     for j = 1:Nb-1
         if B219a(j,2)<= k && k < B219a(j+1,2)
             break;
         end
     end
     Sw(k) = sqrt(P(j));
    end
    for k = 1022 : -1 : 1
     Sw(k) = (Sw(k) + Sw(k + 1))/2;
    end
    for k = 2:1023
     Sw(k) = (Sw(k) + Sw(k-1))/2;
    end
    
    Xw = frameFin ./ Sw(1:length(frameFin));
end

%% step 2

if(frameType == 'ESH')
    TNScoeffs = zeros(4,8);
    for i=1:8
        R = toeplitz(autocorr(Xw(:,i),4-1));
        temp = autocorr(Xw(:,i),4);
        r = temp(2:end);
        TNScoeffs(:,i) = R\r;
    end
else
    R = toeplitz(autocorr(Xw,4-1));
    temp = autocorr(Xw,4);
    r = temp(2:end);
    TNScoeffs = R\r;
end

%% step 3
quantizedTNScoeffs = arrayfun(@myQuantizer, TNScoeffs);
TNScoeffs = quantizedTNScoeffs;
%% step 4  pos tha kano ton elegxo eustathias einai ena thema
if(frameType == 'ESH')
    frameFout = cell(1,1); %zeros(128,8);
    for i = 1:8
        filterCoeffs = [ 1; -1.*quantizedTNScoeffs(:,i)] ;
        frameFout{i} = filter(filterCoeffs, 1, Xw(:,i));
    end
    frameFout = frameFout';
else
    filterCoeffs = [ 1; -1.*quantizedTNScoeffs] ;
    frameFout = filter(filterCoeffs, 1, Xw);
end

end 