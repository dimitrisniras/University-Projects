function [output] = iAACoder1(AACSeq1,fNameOut)

[~,col] = size(AACSeq1);
frameSize = 2048;
framesNumber = col;
x = zeros(frameSize/2*(framesNumber+1),2);
fs = 48000;
l = 8;

for i=1:framesNumber
    if (AACSeq1(i).frameType == 'ESH')
        frameF = cell(l,1);
        
        for j=1:l
            frameF{j} = [AACSeq1(i).chl.frameF{j} AACSeq1(i).chr.frameF{j}];
        end
    else
        frameF = [AACSeq1(i).chl.frameF AACSeq1(i).chr.frameF];
    end
    
    temp = iFilterbank(frameF, AACSeq1(i).frameType, AACSeq1(i).winType);
    x(frameSize/2*(i-1)+1:frameSize/2*(i+1),:) = x(frameSize/2*(i-1)+1:frameSize/2*(i+1),:) + temp;
    
end

x = x(frameSize/2+1:size(x,1)-frameSize/2,:);

audiowrite(fNameOut, x, fs);

if (nargout == 1)
    output = x;
end

end