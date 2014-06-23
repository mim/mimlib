function result = ifthenelse(condition, trueFn, falseFn)

% Functional version of if statement.
%
% result = ifthenelse(condition, trueFn, falseFn)
%
% trueFn and falseFn are function handles.  If condition is true, then
% trueFn will be run with no arguments and the output will be its output.
% Otherwise, if the output of falseFn will be returned.

if condition
    if nargout > 0
        result = trueFn();
    else
        trueFn();
    end
else
    if nargout > 0
        result = falseFn();
    else
        falseFn();
    end
end
