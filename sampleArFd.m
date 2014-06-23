function [X stdFd] = sampleArFd(b, a, Xo, mask, nSamp)

% Draw samples in the frequency domain of an autoregressive process.  Mask
% is true where Xo has been observed and false where it has not.  X(mask)
% == Xo(mask), and X(~mask) ~ N(...).

N = length(Xo);
stdFd = abs(1 ./ fft([1 a], N)); % fft(b, N)

Xh = bsxfun(@times, stdFd(1:N/2).', randn(N/2,nSamp) .* exp(1i * 2*pi * rand(N/2,nSamp)));
Xd = [Xh; conj(Xh(end:-1:1,:))];

X(~mask,:) = Xd(~mask,:);
X( mask,:) = repmat(Xo( mask), 1, nSamp);
