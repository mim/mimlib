function Y = scale01(X, dim)

% Scale a matrix X so that it's maximum value is 1 and its minimum value 0.

if nargin < 2, dim = 1; end

mx = max(X, [], dim);
mn = min(X, [], dim);
Y = bsxfun(@rdivide, bsxfun(@minus, X, mn), mx - mn + 1e-8);
