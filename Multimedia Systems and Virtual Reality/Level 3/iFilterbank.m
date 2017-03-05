function [frameT] = iFilterbank(frameF, frameType, winType)

N = 2048;
lss = 448;
lssR = 128;
lps = 448;
lpsL = 128;
esh = 448;
eshFrame = 256;
eshFramesNumber = 8;

if (frameType == 'OLS')
    frameT = iMDCT(frameF);
    
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
    
elseif (frameType == 'LSS')
    frameT = iMDCT(frameF);
    
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
    
elseif (frameType == 'LPS')
    frameT = iMDCT(frameF);
    
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
    
elseif (frameType == 'ESH')
    if (winType == 'KBD')
        [wL,wR] = KBD(eshFrame);
    elseif (winType == 'SIN')
        [wL,wR] = sinusoid(eshFrame);
    end
    
    frameT(1:esh,:) = 0;
    frameT(N-esh+1:N,:) = 0;
    
    for i=1:eshFramesNumber
        temp = iMDCT(frameF{i});
        
        if (i == 1)
            frameT(esh+1:esh+eshFrame/2,1) = temp(1:eshFrame/2,1) .* wL;
            frameT(esh+1:esh+eshFrame/2,2) = temp(1:eshFrame/2,2) .* wL;
            frameT(esh+eshFrame/2+1:esh+eshFrame,1) = temp(eshFrame/2+1:eshFrame,1) .* wR;
            frameT(esh+eshFrame/2+1:esh+eshFrame,2) = temp(eshFrame/2+1:eshFrame,2) .* wR;
        else
            temp(1:eshFrame/2,1) = temp(1:eshFrame/2,1) .* wL;
            temp(1:eshFrame/2,2) = temp(1:eshFrame/2,2) .* wL;
            temp(eshFrame/2+1:eshFrame,1) = temp(eshFrame/2+1:eshFrame,1) .* wR;
            temp(eshFrame/2+1:eshFrame,2) = temp(eshFrame/2+1:eshFrame,2) .* wR;
            
            frameT(esh+eshFrame/2*(i-1)+1:esh+eshFrame/2*(i+1),:) = frameT(esh+eshFrame/2*(i-1)+1:esh+eshFrame/2*(i+1),:) + temp;
        end
        
    end
    
end

end