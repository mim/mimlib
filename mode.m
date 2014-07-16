function m = mode(X)

% m = mode(X)
%
% find the most common element of a set of numbers, ties are broken
% by order from the top.  Must be integers.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

col = repmat([1:size(X,2)], size(X,1), 1);
col = reshape(col, [], 1);
row = repmat([1:size(X,1)]', 1, size(X,2));
row = reshape(row, [], 1);
X = reshape(X, [], 1);

% Subtract a tiny bit so that bigger numbers come from bigger rows,
% but adding lots of them together still doesn't matter much.
% Balance between counting how many there are and how much order
% matters.
S = sparse(X, col, 1 - row*1e-6);

m = argmax(S);
