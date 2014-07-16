function zxi(times)

% zxi(times)
%
% Zoom X In, keeping the left edge the same.  Works on all subplots
% simultaneously.  If TIMES is not supplied, defaults to 2.  If
% TIMES is a 2-vector, zooms to that xlim on all subplots.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

if(nargin < 1) times = 2; end

fig = get(0, 'CurrentFigure');
kids = get(fig, 'Children');

for i=1:length(kids)
  if(~strcmp(get(kids(i), 'type'), 'axes'))
    continue;
  end
  
  xl = get(kids(i), 'xlim');
  if(numel(times) > 1)
    xlim(kids(i), times);
  else
    xl2 = [xl(1) (xl(2)-xl(1))/times+xl(1)];
    xlim(kids(i), xl2);
  end
end
