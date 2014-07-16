function scrollx(speed)

% scrollx(speed)
%
% Continuously pans across the x axis of the current figure at the
% specified SPEED, in units of whole windows per second.  SPEED
% defaults to .3

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

if(nargin < 1) speed = .3; end

while 1
  panx(speed/3);
  pause(1/3)
end