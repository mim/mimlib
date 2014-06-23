function fields = split(string, splitOn)

% Split a string into a cell array of sub-strings on the string splitOn
%
% fields = split(string, splitOn)

fields = regexp(string, splitOn, 'split');
