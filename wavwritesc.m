function wavwritesc(y, varargin)

% Like soundsc, but for writing sounds to file

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

wavWriteBetter(y * .95 / max(abs(y)), varargin{:});