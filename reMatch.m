function m = reMatch(string, pattern)

if ~iscell(string)
    m = ~isempty(regexp(string, pattern, 'match', 'once'));
else
    m = cellfun(@(x) ~isempty(x), regexp(string, pattern, 'match', 'once'));
end
