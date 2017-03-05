function [ frameFout ] = iTNS( frameF, frameType, TNScoeffs )
% inverse Temporal Noise Shaping
if(frameType == 'ESH')
    frameFout = cell(1,1); %zeros(128,8);
    
    for i = 1:8
        filterCoeffs = [ 1; -1.*TNScoeffs(:,i)] ;
        frameFout{i} = filter(1, filterCoeffs, frameF{i});
    end
    
else
    filterCoeffs = [ 1; -1.*TNScoeffs] ;
    frameFout = filter(1, filterCoeffs, frameF);
end

end