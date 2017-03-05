function [frameF] = filterbank(frameT, frameType, winType)

N = 2048;
lss = 448;
lssR = 128;
lps = 448;
lpsL = 128;
esh = 448;
eshFrame = 256;
eshFramesNumber = 8;

if (frameType == 'OLS')
    if (winType == 'KBD')
        [wL,wR] = KBD(N);
    elseif (winType == 'SIN')
        [wL,wR] = sinusoid(N);
    end
    
    i = 1:N/2;
    frameT(i,1) = frameT(i,1) .* wL(i);
    frameT(i,2) = frameT(i,2) .* wL(i);  
    
    i = N/2+1:N;
    frameT(i,1) = frameT(i,1) .* wR(i-N/2);
    frameT(i,2) = frameT(i,2) .* wR(i-N/2);
        
    frameF = MDCT(frameT);
    
elseif (frameType == 'LSS')
    if (winType == 'KBD')
        [wL1,~] = KBD(N);
        [~,wR2] = KBD(2*lssR);
    elseif (winType == 'SIN')
        [wL1,~] = sinusoid(N);
        [~,wR2] = sinusoid(2*lssR);
    end
    
    i = 1:N/2;
    frameT(i,1) = frameT(i,1) .* wL1(i);
    frameT(i,2) = frameT(i,2) .* wL1(i);  
        
    i = N/2+lss+1:N/2+lss+lssR;
    frameT(i,1) = frameT(i,1) .* wR2(i-N/2-lss);
    frameT(i,2) = frameT(i,2) .* wR2(i-N/2-lss);
        
    frameT(N-lss+1:N,:) = 0;
    
    frameF = MDCT(frameT);
    
elseif (frameType == 'LPS')
    if (winType == 'KBD')
        [~,wR1] = KBD(N);
        [wL2,~] = KBD(2*lpsL);
    elseif (winType == 'SIN')
        [~,wR1] = sinusoid(N);
        [wL2,~] = sinusoid(2*lpsL);
    end
        
    frameT(1:lps,:) = 0;
        
    i = lps+1:lps+lpsL;
    frameT(i,1) = frameT(i,1) .* wL2(i-lps);
    frameT(i,2) = frameT(i,2) .* wL2(i-lps);
  
    i = N/2+1:N;
    frameT(i,1) = frameT(i,1) .* wR1(i-N/2);
    frameT(i,2) = frameT(i,2) .* wR1(i-N/2);
    
    frameF = MDCT(frameT);
    
elseif (frameType == 'ESH')
    frameT = frameT(esh+1:N-esh,:);
    
    if (winType == 'KBD')
        [wL,wR] = KBD(eshFrame);
    elseif (winType == 'SIN')
        [wL,wR] = sinusoid(eshFrame);
    end
    
    frameF = cell(eshFramesNumber,1);
    
    for i=1:eshFramesNumber
        temp = frameT(eshFrame/2*(i-1)+1:eshFrame/2*(i+1),:);
        
        j = 1:eshFrame/2;
        temp(j,1) = temp(j,1) .* wL(j);
        temp(j,2) = temp(j,2) .* wL(j);
        
        j = eshFrame/2+1:eshFrame;
        temp(j,1) = temp(j,1) .* wR(j-eshFrame/2);
        temp(j,2) = temp(j,2) .* wR(j-eshFrame/2);
        
        frameF{i} = MDCT(temp);
    end
    
end

end