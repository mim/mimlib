function [maxI maxJ val] = maxAround(X, i, j, r)

% Find the maximum value in matrix X within r places of point (i,j)
%
% [maxI maxJ val] = maxAround(X, i, j, r)


[jj ii] = meshgrid(1:size(X,2), 1:size(X,1));
mask = ((jj - j).^2 + (ii - i).^2 > r^2);
X(mask) = nan;
[val ind] = max(X(:));
[maxI maxJ] = ind2sub(size(X), ind);
