function ca = grep(ca, pattern, excludeMatches)

% Keep or exclude strings from a cell array that match a pattern
%
% ca = grep(ca, pattern, [excludeMatches])
%
% excludeMatches 

if nargin < 3, excludeMatches = 0; end

keep = cellfun(@(x) reMatch(x, pattern), ca);
if excludeMatches
    keep = ~keep;
end
ca = ca(keep);
