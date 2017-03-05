function AACSeq2 = AACoder2( fNameIn )

[data,~] = audioread(fNameIn);
AACSeq2 = struct('frameType',{},'winType',{},'chl',{},'chr',{});
chl = struct('TNSCoeffs',{},'frameF',{});
chr = struct('TNSCoeffs',{},'frameF',{});

[row,~] = size(data);
frameSize = 2048;
framesNumber = ceil(2*row/frameSize);
data = [zeros(frameSize/2,2); data; zeros(frameSize/2,2)];
l = 8;
prevFrameType = 'OLS';
    
for i=1:framesNumber - 1
    frameT = data(frameSize/2*(i-1)+1:frameSize/2*(i+1),:);
    nextFrameT = data(frameSize/2*i+1:frameSize/2*(i+2),:);
    
    AACSeq2(i).frameType = SSC(frameT, nextFrameT, prevFrameType);  
    AACSeq2(i).winType = 'KBD';
    
    temp = filterbank2(frameT, AACSeq2(i).frameType, AACSeq2(i).winType);
        
    if (AACSeq2(i).frameType == 'ESH')
        frameF1 = cell(l,1);
        frameF2 = cell(l,1);
        
        for j=1:l
            frameF1{j} = temp{j}(:,1);
            frameF2{j} = temp{j}(:,2);
        end
        
        [AACSeq2(i).chl.frameF, AACSeq2(i).chl.TNSCoeffs] = TNS(frameF1,'ESH');
        [AACSeq2(i).chr.frameF, AACSeq2(i).chr.TNSCoeffs] = TNS(frameF2,'ESH');
    else
        [AACSeq2(i).chl.frameF, AACSeq2(i).chl.TNSCoeffs] = TNS(temp(:,1),'OLS');
        [AACSeq2(i).chr.frameF, AACSeq2(i).chr.TNSCoeffs] = TNS(temp(:,2),'OLS');
    end
    
    prevFrameType = AACSeq2(i).frameType;
    
end

end

