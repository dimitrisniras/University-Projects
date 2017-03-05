function [AACSeq1] = AACoder1(fNameIn)

[data,~] = audioread(fNameIn);
AACSeq1 = struct('frameType',{},'winType',{},'chl',{},'chr',{});

[row,~] = size(data);
frameSize = 2048;
framesNumber = ceil(2*row/frameSize);
data = [zeros(frameSize/2,2); data; zeros(frameSize/2,2)];
l = 8;
prevFrameType = 'OLS';
    
for i=1:framesNumber - 1
    frameT = data(frameSize/2*(i-1)+1:frameSize/2*(i+1),:);
    nextFrameT = data(frameSize/2*i+1:frameSize/2*(i+2),:);
    
    AACSeq1(i).frameType = SSC(frameT, nextFrameT, prevFrameType);  
    AACSeq1(i).winType = 'SIN';
    
    temp = filterbank(frameT, AACSeq1(i).frameType, AACSeq1(i).winType);
        
    if (AACSeq1(i).frameType == 'ESH')
        frameF1 = cell(l,1);
        frameF2 = cell(l,1);
        
        for j=1:l
            frameF1{j} = temp{j}(:,1);
            frameF2{j} = temp{j}(:,2);
        end
        
        AACSeq1(i).chl.frameF = frameF1;
        AACSeq1(i).chr.frameF = frameF2;
    else
        AACSeq1(i).chl.frameF = temp(:,1);
        AACSeq1(i).chr.frameF = temp(:,2);
    end
    
    prevFrameType = AACSeq1(i).frameType;
    
end

end