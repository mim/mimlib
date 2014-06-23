function y = lim(x, lower, upper)

% Limit the values in x to be at least lower and at most upper.
%
% y = lim(x, lower, upper)

y = max(lower, min(upper, x));
