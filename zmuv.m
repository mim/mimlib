function Y = zmuv(X)

% Y = zmuv(X)
%
% Create the zero-mean, unit-variance version of X, assuming each
% row is a sample.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

Y = matSubVec(X, mean(X)) * sparse(diag(1 ./ std(X)));
