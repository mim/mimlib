function [m, i, j] = min2(A)

% [m, i, j] = min2(A)
%
% Find the minimum element of the matrix A and return the value and
% its position in row I and column K.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

[y,i] = min(A);
[m,j] = min(y);
i = i(j);
