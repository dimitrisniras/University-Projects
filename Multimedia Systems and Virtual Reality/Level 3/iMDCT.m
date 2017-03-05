function [frameT] = iMDCT(frameF)

[flen,fnum] = size(frameF);

% Make column if it's a single row
if (flen==1)
    frameF = frameF(:);
    flen = fnum;
    fnum = 1;
end

% We need these for furmulas below
N = flen;
M = N/2;
twoN = 2*N;
sqrtN = sqrt(twoN);

% We need this twice so keep it around
t = (0:(M-1)).';
w = diag(sparse(exp(-1i*2*pi*(t+1/8)/twoN)));

% Pre-twiddle
t = (0:(M-1)).';
c = frameF(2*t+1,:) + 1i*frameF(N-1-2*t+1,:);
c = (0.5*w)*c;

% FFT for N/2 points only !!!
c = fft(c,M);

% Post-twiddle
c = ((8/sqrtN)*w)*c;

% Preallocate rotation matrix
rot = zeros(twoN,fnum);

% Sort
t = (0:(M-1)).';
rot(2*t+1,:) = real(c(t+1,:));
rot(N+2*t+1,:) = imag(c(t+1,:)); 
t = (1:2:(twoN-1)).';
rot(t+1,:) = -rot(twoN-1-t+1,:);

% Shift
t = (0:(3*M-1)).';
frameT(t+1,:) = rot(t+M+1,:);
t = (3*M:(twoN-1)).';
frameT(t+1,:) = -rot(t-3*M+1,:);

end