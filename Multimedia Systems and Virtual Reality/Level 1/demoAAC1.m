function [SNR] = demoAAC1(fNameIn,fNameOut)

fprintf('\nLevel 1\n=======\n');

data = audioread(fNameIn);

tic;
AACSeq1 = AACoder1(fNameIn);
fprintf('Coding: time ellapsed is %f seconds\n',toc);

tic;
x = iAACoder1(AACSeq1, fNameOut);
fprintf('Decoding: time ellapsed is %f seconds\n',toc);

if (size(data,1) > size(x,1)) 
    data = data(1:size(x,1),:);
else
    x = x(1:size(data,1),:);
end

SNR = [snr(data(:,1), x(:,1) - data(:,1)) snr(data(:,2), x(:,2) - data(:,2))];

fprintf('Channel 1 SNR: %f dB\n',SNR(1));
fprintf('Channel 2 SNR: %f dB\n\n',SNR(2));

end