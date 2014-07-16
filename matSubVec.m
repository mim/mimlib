function C = matSubVec(A, b)

% C = matSubVec(A, b)
%
% Subtract the vector b from each row or column of A, depending on the
% dimensions of A and b.  If b is the same length as each row of A,
% C(i,:) = A(i,:) - b.  If b is the same length as each column of A,
% C(:,j) = A(:,j) - b.  B will be transposed accordingly.  If A is
% square, then the current orientation of b will be used.  
%
% This function appears to be 2-4 times faster than using repmat for
% any A and b, with the performance boost increasing as the
% matrices get bigger.

% MEX file.  Code is in matSubVec.c, but this will be run if that's
% not compiled.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

warning('You should compile matSubVec.c.  Using repmat...');

[am an] = size(A);
[bm bn] = size(b);
bl = max(bm,bn);

if(am == an)
  if(bm == 1)
    C = A - repmat(b, am, 1);
  else
    C = A - repmat(b, 1, an);
  end
else
  b = b(:);
  if(bl == am)
    C = A - repmat(b, 1, an);
  else
    C = A - repmat(b.', am, 1);
  end
end
