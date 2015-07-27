function y = fftfilt2(x, h, sz)

% 2D convolution via 2D FFT
%
% y = fftfilt2(x, h, sz)
%
% Drop-in replacement for conv2. sz can be 'full', 'same', or 'valid',
% which selects the size of y relative to the size of x.

if ~exist('sz', 'var') || isempty(sz), sz = 'full'; end

[mx nx] = size(x);
[mh nh] = size(h);
my = mx + mh - 1;
ny = nx + nh - 1;
X = fft2(x, my, ny);
H = fft2(h, my, ny);
y = real(ifft2(X .* H));

switch sz
    case 'full'
        % Don't trim
    case 'same'
        rows = floor(mh/2) + (1:mx);
        cols = floor(nh/2) + (1:nx);
        y = y(rows,cols);
    case 'valid'
        rows = mh+(1:mx-mh+1);
        cols = nh+(1:nx-nh+1);
        y = y(rows,cols);
    otherwise
        error('Unknown size type: "%s"', sz);
end
