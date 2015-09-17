function out = chop(in)

% Like the perl chop function, strip trailing whitespace from a string

out = regexprep(in, '\s*$', '');
