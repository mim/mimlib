function am = argmin(X, dim)

% am = argmin(X, dim)
%
% Find the index of the minimum value of the matrix X.  If dim is
% supplied, find the minimum index along the dimension dim.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

if(nargin < 2)
  [dummy, am] = min(X);
else
  [dummy, am] = min(X, [], dim);
end
