function r = rms(x, dim)
% Root mean square of a vector or matrix along dimension dim
%
% r = rms(x, dim)

if ~exist('dim', 'var') || isempty(dim), dim = 1; end

r = sqrt(mean(x.^2, dim));
