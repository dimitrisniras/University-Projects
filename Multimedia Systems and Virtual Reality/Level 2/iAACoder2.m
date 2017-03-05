function [output] = iAACoder2(AACSeq2,fNameOut)

[~,col] = size(AACSeq2);
frameSize = 2048;
framesNumber = col;
x = zeros(frameSize/2*(framesNumber+1),2);
fs = 48000;
l = 8;

for i=1:framesNumber
    if (AACSeq2(i).frameType == 'ESH')
        frameF = cell(l,1);
        tempL = iTNS(AACSeq2(i).chl.frameF, AACSeq2(i).frameType, AACSeq2(i).chl.TNSCoeffs);
        tempR = iTNS(AACSeq2(i).chr.frameF, AACSeq2(i).frameType, AACSeq2(i).chr.TNSCoeffs);
        for j=1:l
            frameF{j} = [tempL{j} tempR{j}];
        end
    else
        frameF = [iTNS(AACSeq2(i).chl.frameF, AACSeq2(i).frameType, AACSeq2(i).chl.TNSCoeffs) iTNS(AACSeq2(i).chr.frameF, AACSeq2(i).frameType, AACSeq2(i).chr.TNSCoeffs)];
    end
    
    temp = iFilterbank2(frameF, AACSeq2(i).frameType, AACSeq2(i).winType);
    x(frameSize/2*(i-1)+1:frameSize/2*(i+1),:) = x(frameSize/2*(i-1)+1:frameSize/2*(i+1),:) + temp;
    
end

x = x(frameSize/2+1:size(x,1)-frameSize/2,:);

audiowrite(fNameOut, x, fs);

if (nargout == 1)
    output = x;
end

end