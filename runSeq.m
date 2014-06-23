function runSeq(varargin)
% Run a sequence of function handles that take no arguments
%
% runSeq(@() doSomething(a,b,c), @() doSomethingElse(d,e,f), ...)

for i = 1:nargin
    varargin{i}();
end
