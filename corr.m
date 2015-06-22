function C = corr(ov)

% C = corr(ov)
%
% Calculate the correlation matrix for a set of random variables.
% If ov is square, it is assumed to be a covariance matrix that has
% already been calculated from the variables.  Otherwise, the
% covariance will be computed using cov().

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

[r,c] = size(ov);
if(r ~= c)
  ov = cov(ov);
end
d = diag(ov);
C = ov ./ sqrt(d*d');
