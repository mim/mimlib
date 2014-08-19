function [d K11 K22] = dist(X1, X2, K11, K22)

% d = dist(X1)
% d = dist(X1, X2)
%
% Find the euclidean distance between X1 and X2 by calculating
% their inner products and then manipulating the resulting matrix.
% X1 is NxD, X2 is MxD, d is NxM.  If X2 is omitted, find the
% distance between all pairs of points in X1.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

if ~exist('K11', 'var'), K11 = []; end
if ~exist('K22', 'var'), K22 = []; end

% d_ij = sqrt(x_i*x_i - 2*x_i*x_j + x_j*x_j) 
%      = sqrt(K(i,i) - 2*K(i,j) + K(j,j))

if ~exist('X2', 'var') || isempty(X2)
  % If it's the matrix with itself, we can take some shortcuts
  K = X1 * X1';
  K11 = diag(K);
  
  d = bsxfun(@plus, bsxfun(@plus, K11, -2*K), K11');
  d = sqrt(d .* (d > 0));

else
  % Otherwise, we have to do it the long way
  if isempty(K11)
      K11 = sum(X1 .* X1, 2);
  end
  if isempty(K22)
      K22 = sum(X2 .* X2, 2)';
  end
  
  K = X1 * X2';
  
  d = bsxfun(@plus, bsxfun(@plus, K11, -2*K), K22);
  d = sqrt(d .* (d > 0));
end
