function [frameType] = SSC(frameT, nextFrameT, prevFrameType)

l = 8;
sample = 128;
start = 576;
nextFrameType0 = 'OLS';
nextFrameType1 = 'OLS';
nextFrameT0 = nextFrameT(:,1);
nextFrameT1 = nextFrameT(:,2);
s0 = zeros(l,1);
s1 = zeros(l,1);
ds0 = zeros(l,1);
ds1 = zeros(l,1);

b = [0.7548 -0.7548];
a = [1 -0.5095];

y0 = filter(b,a,nextFrameT0);
y1 = filter(b,a,nextFrameT1);

for i=1:l
    for j=start+sample*(i-1)+1:start+sample*i
        s0(i) = s0(i) + y0(j)*y0(j);
        s1(i) = s1(i) + y1(j)*y1(j);
    end
end

for i=2:l
    ds0(i) = s0(i) / ((1/i) * sum(s0(1:i-1)));
    ds1(i) = s1(i) / ((1/i) * sum(s1(1:i-1)));
    
    if (s0(i) > 0.001 && ds0(i) > 10) 
        nextFrameType0 = 'ESH';
    end
    
    if (s1(i) > 0.001 && ds1(i) > 10)
        nextFrameType1 = 'ESH';
    end
end


%% frameType for channel 0
if (prevFrameType == 'OLS')
    if (nextFrameType0 == 'ESH')
        frameType0 = 'LSS';
    else
        frameType0 = 'OLS';
    end
elseif (prevFrameType == 'ESH') 
    if (nextFrameType0 == 'ESH')
        frameType0 = 'ESH';
    else
        frameType0 = 'LPS';
    end
elseif (prevFrameType == 'LSS')
    frameType0 = 'ESH';
else
    frameType0 = 'OLS';
end

%% frameType for channel 1
if (prevFrameType == 'OLS')
    if (nextFrameType1 == 'ESH')
        frameType1 = 'LSS';
    else
        frameType1 = 'OLS';
    end
elseif (prevFrameType == 'ESH') 
    if (nextFrameType1 == 'ESH')
        frameType1 = 'ESH';
    else
        frameType1 = 'LPS';
    end
elseif (prevFrameType == 'LSS')
    frameType1 = 'ESH';
else
    frameType1 = 'OLS';
end

%% frameType for both channels
if (frameType0 == 'OLS')
    frameType = frameType1;
elseif (frameType0 == 'LSS')
    if (frameType1 == 'OLS')
        frameType = 'LSS';
    elseif (frameType1 == 'LSS')
        frameType = 'LSS';
    elseif (frameType1 == 'ESH')
        frameType = 'ESH';
    else
        frameType = 'ESH';
    end
elseif (frameType0 == 'ESH')
    frameType = 'ESH';
else
    if (frameType1 == 'OLS')
        frameType = 'LPS';
    elseif (frameType1 == 'LSS')
        frameType = 'ESH';
    elseif (frameType1 == 'ESH')
        frameType = 'ESH';
    else
        frameType = 'LPS';
    end
end

end