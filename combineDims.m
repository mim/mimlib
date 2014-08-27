function Y = combineDims(X, dFrom, dInto)

% Combine two dimensions of a multi-dimensional array
%
% Y = combineDims(X, dFrom, dInto)
%
% If X is of size D1 x D2 x D3 x ..., then combining D3 (combineFrom) into
% D2 (combineInto) means concatenating each "page" of X (the third
% dimension) in order along the second dimension.  So Y will then be of
% size D1 x (D2*D3) x ...

sz = size(X);

% Put the "into" dimension first and the "from" dimension second
neutralDims = setdiff(1:length(sz), [dInto dFrom]);
dimOrd = [dInto dFrom neutralDims];
X = permute(X, dimOrd);

% Reshape to combine the first two dimensions
newSizes = sz(dimOrd);
newSizes = [newSizes(1)*newSizes(2) newSizes(3:end)];
Y = reshape(X, newSizes);

% Permute back to original order minus "from" dimension
[~,invOrd] = unique(dimOrd([1 3:end]));
Y = ipermute(Y, invOrd);
