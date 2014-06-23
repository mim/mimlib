function c = unstruct(s)

% c = unstruct(s)
%
% Invert the operation performed by the struct() function.  Takes
% in a structure and returns a cell array of alternating field
% names and field values.  Like struct2cell, but useful.

c = struct2cell(s);
f = fieldnames(s);

c = {f{:}; c{:}};
c = c(:)';
