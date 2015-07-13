function sOut = structCast(sIn, testFn, castFn)

% Recurse through a structure containing all sorts of stuff and if a
% field is encountered where typeTestFn returns true, set it to the output
% of castFn applied to that field.  Does not recurse on cell arrays inside
% structures. 

fn = fieldnames(sIn);
for a = 1:length(sIn)
    for f = 1:length(fn)
        if isstruct(sIn(a).(fn{f}))
            sIn(a).(fn{f}) = structCast(sIn(a).(fn{f}), testFn, castFn);
        elseif testFn(sIn(a).(fn{f}))
            sIn(a).(fn{f}) = castFn(sIn(a).(fn{f}));
        else
            sIn(a).(fn{f}) = sIn(a).(fn{f});
        end
    end
end
sOut = sIn;
