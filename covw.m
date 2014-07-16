function C = covw(X, w)

% C = covw(X, w)
%
% Find the covariance of the data in X.  Each row if X is an
% observation and each column is a random variable.  W is a column
% vector that has one entry per row of X.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

X = X - repmat(mean(X), size(X,1), 1);
C = X' * (X .* repmat(w, 1, size(X,2))) / (w'*w);
