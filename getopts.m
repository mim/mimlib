function S = getopts(cells, varargin)

% S = getopts(cells, varargin)
%
% Parse options for a function, including default arguments.  Put
% results in structure S with fields determined by arguments and
% default arguments.  Cells should contain the cell array created by
% another function's varargin (without dereferencing it).  The
% varargin should consist of {'string', value} pairs.  Default
% arguments should also consist of such pairs.  If a variable is
% not supplied in cells, its value will be taken from the
% defaults.  If it is supplied in cells, the default will be
% ignored.

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under GPL

S = struct(varargin{:});

for i=1:2:length(cells)
  S = setfield(S, cells{i}, cells{i+1});
end
