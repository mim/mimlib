function sOut = structCast(sIn, testFn, castFn)

% Recurse through a structure containing all sorts of stuff and if a
% field is encountered where typeTestFn returns true, set it to the output
% of castFn applied to that field.  Does not recurse on cell arrays inside
% structures. 

if isstruct(sIn)
    fn = fieldnames(sIn);
    for a = 1:length(sIn)
        for f = 1:length(fn)
            sIn(a).(fn{f}) = structCast(sIn(a).(fn{f}), testFn, castFn);
        end
    end
else
    if testFn(sIn)
        sIn = castFn(sIn);
    end
end
sOut = sIn;
