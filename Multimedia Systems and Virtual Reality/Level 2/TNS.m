function [frameFout, TNScoeffs] = TNS(frameFin, frameType)

%% step 1
load('TableB219.mat')

if(frameType == 'ESH') 
    frameIn = zeros (8,128);
    
    for i=1:8 
        frameIn(i,:) = frameFin{i,1}; 
    end
    
    frameIn = frameIn';
    Nb = size(B219b,1);
    P = zeros(Nb,8);
    Sw = zeros(Nb,8);
    Xw = zeros(Nb,8);
    
    for i = 1:8
        for j=1:Nb-1
            P(j,i) = sum( frameIn( B219b(j,2)+1:B219b(j+1,2) , i ).^2 );
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
        for k = 127 : -1 : 1
            Sw(k,i) = (Sw(k,i) + Sw(k + 1,i))/2;
        end
        
        for k = 2 : 128
            Sw(k,i) = (Sw(k,i) + Sw(k-1,i))/2;
        end
    end
    
    Xw(1:128,:) = frameIn(1:128,:) ./ Sw(1:128,:) ;
else
    Nb = size(B219a,1);
    P = zeros(Nb,1);
    Sw = zeros(length(frameFin),1);
    
    for j=1:Nb-1    
        P(j) = sum( frameFin( B219a(j,2)+1:B219a(j+1,2) ).^2 );
    end
    
    for k = 1:1024 % na dw me find gia taxuthta kai vectorization
        for j = 1:Nb-1
            if B219a(j,2)<= k && k < B219a(j+1,2)
                break;
            end
        end
        Sw(k) = sqrt(P(j));
    end
    
    for k = 1023 : -1 : 1
        Sw(k) = (Sw(k) + Sw(k + 1))/2;
    end
    
    for k = 2:1024
        Sw(k) = (Sw(k) + Sw(k-1))/2;
    end
    
    Xw = frameFin ./ Sw(1:length(frameFin));
end

%% step 2
p = 4;

if(frameType == 'ESH')
    TNScoeffs = zeros(4,8);
    
    for i=1:8
        tmp = xcorr(Xw(:,i),Xw(:,i),p-1,'unbiased');
        tmp = tmp(p:2*p-1);
        R = toeplitz(tmp);
        temp = xcorr(Xw(:,i),Xw(:,i),p,'unbiased');
        r = temp(p:2*p-1);
        TNScoeffs(:,i) = R\r;
    end
    
else
    tmp = xcorr(Xw,Xw,p-1,'unbiased');
    tmp = tmp(p:2*p-1);
    R = toeplitz(tmp);
    temp = xcorr(Xw,Xw,p,'unbiased');
    r = temp(p:2*p-1);
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
        frameFout{i} = filter(filterCoeffs, 1, frameIn(:,i));
    end
    
    frameFout = frameFout';
else
    filterCoeffs = [ 1; -1.*quantizedTNScoeffs] ;
    frameFout = filter(filterCoeffs, 1, frameFin);
end

end 