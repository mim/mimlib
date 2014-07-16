function [m, i, j] = max2(A)

% Find the maximum element of the matrix A and return the value and
% its position in row I and column K.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

[y,i] = max(A);
[m,j] = max(y);
i = i(j);