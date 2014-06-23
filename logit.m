function y = logit(x)

x = max(0, min(1, x));
y = log(x) - log(1-x);
