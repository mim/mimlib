function y = sample(x, k)

% y = sample(x, k)
%
% Take K rows from X at random.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

N = size(x,1);
p = randperm(N);
y = x(p(1:k),:);