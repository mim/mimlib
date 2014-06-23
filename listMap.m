function lst = listMap(func, lst)

% Run function fn on each element of a "list"
%
% lst = listMap(func, lst)
%
% A list can be either a cell array or a structure.  In the case of a cell
% array, fn should look like: 
%   newVal = fn(oldVal);
% In the case of a struct, fn should look like:
%   newFieldVal = fn(fieldName, fieldVal);
% The output type will be the same as the input type.  Does not work on
% structure arrays, just the fields within a structure.

if isempty(lst)
    return
elseif isstruct(lst)
    fields = fieldnames(lst);
    for f = 1:length(fields)
        fn = fields{f};
        lst.(fn) = func(fn, lst.(fn));
    end
elseif iscell(lst)
    for f = 1:length(lst)
        lst{f} = func(lst{f});
    end
end
