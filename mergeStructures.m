function s = mergeStructures(s1, s2, verbose, prefix)

% Combine two structures so that any key that is in either is in the
% combination.  If a key is in both and the value is a structure, it will
% be recursively merged.  If it is not a structure, the value from s1 will
% be taken and another field with an underscore appended to the name will
% be created with the value from s2.

if nargin < 3, verbose = false; end
if nargin < 4, prefix = ''; end

fn1 = fieldnames(s1);
fn2 = fieldnames(s2);

fnb = intersect(fn1, fn2);
fn1 = setdiff(fn1, fnb);
fn2 = setdiff(fn2, fnb);

for i = 1:length(fn1)
    s.(fn1{i}) = s1.(fn1{i});
end
for i = 1:length(fn2)
    s.(fn2{i}) = s2.(fn2{i});
end
for i = 1:length(fnb)
    v1 = s1.(fnb{i});
    v2 = s2.(fnb{i});
    if isstruct(v1) && isstruct(v2)
        s.(fnb{i}) = mergeStructures(v1, v2, verbose, [prefix '.' fnb{i}]);
    else
        altName = [fnb{i} '_'];
        assert(~isfield(s1, altName) && ~isfield(s2, altName));
        s.(fnb{i})  = v1;
        s.(altName) = v2;
        if verbose
            fprintf('Name collision "%s.%s"', prefix, fnb{i});
        end
    end
end
%s = orderfields(s);
