function panx(frac)

% panx(frac)
%
% Pan all subplots in the current figure FRAC to the right.  If
% FRAC is negative, pan to the left.  FRAC defaults to 1/2.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

if(nargin < 1) frac = 1/2; end

fig = get(0, 'CurrentFigure');
kids = get(fig, 'Children');

for i=1:length(kids)
  if(~strcmp(get(kids(i), 'type'), 'axes'))
    continue;
  end
  
  xl = get(kids(i), 'xlim');
  xl2 = xl - (xl(1)-xl(2))*frac;
  xlim(kids(i), xl2);
end
