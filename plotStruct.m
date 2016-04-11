function plotStruct(s, func)

% Plot each field of the structure if it is a vector or matrix, label each
% line with the name of the field.

if ~exist('func', 'var') || isempty(func), func = @(x)x; end

fn = fieldnames(s);
leg = {};
series = {};
for f = 1:length(fn)
    if isnumeric(s(1).(fn{f}))
        series{end+1} = func([s.(fn{f})]);
        leg{end+1} = fn{f};
    end
end

plotYs(series{:});
legend(leg{:});
