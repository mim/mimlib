function s = join(c, delimiter)
% s = join(c, delimiter)
%
% The opposite of split.  Join a set of strings contained in cell
% array c and insert delimeter between each of them.  Returns a
% singe string, s.

if isempty(c)
    s = '';
    return
end
c = c(:)';
c(2,:) = repmat({delimiter}, size(c));
c{2,end} = '';
s = cat(2, c{:});
