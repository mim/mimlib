function newLst = listFilter(func, lst)

% Keep elements of a "list" for which fn returns true
%
% lst = listFilter(fn, lst)
%
% A list can be either a cell array or a structure.  In the case of a cell
% array, fn should look like: 
%   keep = fn(oldVal);
% In the case of a struct, fn should look like:
%   keep = fn(fieldName, fieldVal);
% The output type will be the same as the input type.  Does not work on
% structure arrays, just the fields within a structure.

if isempty(lst)
    newLst = lst;
    return
elseif isstruct(lst)
    fields = fieldnames(lst);
    newLst = [];
    for f = 1:length(fields)
        fn = fields{f};
        if func(fn, lst.(fn))
            newLst.(fn) = lst.(fn);
        end
    end
elseif iscell(lst)
    newLst = {};
    for f = 1:length(lst)
        if func(lst{f})
            newLst{end+1} = lst{f};
        end
    end
end
