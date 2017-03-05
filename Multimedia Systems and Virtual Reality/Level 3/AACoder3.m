function [AACSeq3] = AACoder3(fNameIn, fnameAACoded)

[data,~] = audioread(fNameIn);
[row,~] = size(data);
frameSize = 2048;
data = [zeros(frameSize/2,2); data; zeros(frameSize/2,2)];

AACSeq3 = struct('frameType',{},'winType',{},'chl',{},'chr',{});
chl = struct('TNScoeffs',{},'T',{},'G',{},'sfc',{},'stream',{},'codebook',{});
chr = struct('TNScoeffs',{},'T',{},'G',{},'sfc',{},'stream',{},'codebook',{});

end