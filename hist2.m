function [H,xlab,ylab] = hist2(X, varargin)

% [H,xlab,ylab] = hist2(X)
% [H,xlab,ylab] = hist2(X, string, value, ...)
%
% Make a 2 dimensional histogram of the data in X.  X should be a 2xN,
% Nx2, 3xN, or Nx3 matrix.  Valid arguments are 'spacing', 'bins',
% 'xlim', 'ylim', 'axis'.  Spacing is a 2-vector saying how far apart
% the bins should be in the x and y directions.  Bins, on the other
% hand, specifies how many bins you should have for the whole range of
% data.  Xlim is a 2-vector specifying the minimum and maximum values
% of X.  Ylim similarly.  And axis combines xlim and ylim into one
% 4-vector, with x's limits coming first, as with the axis command.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

defbins = round(.75*sqrt(numel(X))*[1 1]);

[r,c] = size(X);
if((r > 3) && (c > 3))
  % Passed in a single matrix, like you can pass in to plot().
  % Make indices out of the row number and plot row number vs
  % value.
  ri = repmat([1:r]', 1, c);
  X = [ri(:), X(:)];
  defbins(1) = r;
elseif(r < c) 
  X = X';
end

[r,c] = size(X);
if(c == 3)
  V = X(:,3);
  X = X(:,1:2);
else
  V = ones(size(X,1),1);
end


mins = min(X);
maxs = max(X);
defxl = [mins(1) maxs(1)];
defyl = [mins(2) maxs(2)];

opts = getopts(varargin, 'bins', defbins, 'xlim', defxl, 'ylim', ...
                         defyl, 'axis', []);

% Make aliases to make things clearer
Y = X(:,2);
X = X(:,1);
if ~isempty(opts.axis) 
  opts.xlim = opts.axis([1 2]); 
  opts.ylim = opts.axis([3 4]); 
end
xmin = opts.xlim(1); xmax = opts.xlim(2);
ymin = opts.ylim(1); ymax = opts.ylim(2);
xbins = opts.bins(1); ybins = opts.bins(2);

% Only keep points inside the limits
keep = find((X >= xmin) .* (X <= xmax) .* (Y >= ymin) .* (Y <= ymax));
X = X(keep);
Y = Y(keep);
V = V(keep);

% Scale X and limits
epsilon = 1e-6;
X = ceil((X - xmin) / (xmax - xmin) * (xbins-epsilon) + epsilon);
Y = ceil((Y - ymin) / (ymax - ymin) * (ybins-epsilon) + epsilon);

% Make histogram using sparse matrix trick
H = full(sparse(Y, X, V, ybins, xbins));

% Calculate labels for axes
xlab = xmin:(xmax-xmin)/(xbins-1):xmax;
ylab = ymin:(ymax-ymin)/(ybins-1):ymax;

if(nargout < 1)
  % Draw it
  imagesc(xlab, ylab, H);
  axis xy
  %colormap(1 - gray(256))

  clear H xlab ylab;
end
