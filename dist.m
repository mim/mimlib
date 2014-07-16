function d = dist(X1, X2)

% d = ipDist(X1)
% d = ipDist(X1, X2)
%
% Find the euclidean distance between X1 and X2 by calculating
% their inner products and then manipulating the resulting matrix.
% X1 is NxD, X2 is MxD, d is NxM.  If X2 is omitted, find the
% distance between all pairs of points in X1.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL


% d_ij = sqrt(x_i*x_i - 2*x_i*x_j + x_j*x_j) 
%      = sqrt(K(i,i) - 2*K(i,j) + K(j,j))

if(nargin < 2)
  % If it's the matrix with itself, we can take some shortcuts
  [N,D] = size(X1);
  
  K = X1 * X1';
  Kii = repmat(diag(K), 1, N);
  
  d = Kii - 2*K + Kii';
  d = sqrt(d .* (d > 0));

else
  % Otherwise, we have to do it the long way
  [N,D] = size(X1);
  [M,D2] = size(X2);
  
  K = X1 * X2';
  Kii = repmat(sum(X1 .* X1, 2), 1, M);
  Kjj = repmat(sum(X2 .* X2, 2)', N, 1);
  
  d = Kii - 2*K + Kjj;
  d = sqrt(d .* (d > 0));
end