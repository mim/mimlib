function h = plotYs(varargin)

% Like plot, but without needing to specify x.  Can handle all of the
% options that plot can in terms of styles and things.

plotArgs = {};
state = 'data';
len = [];
i = 1;
while i <= length(varargin)
    switch state
        case 'data'
            if isempty(len)
                len = length(varargin{i});
            else
                if len ~= length(varargin{i})
                    warning('plotYs:sizeMismatch', 'Mismatched lengths: expected %d, found %d', len, length(varargin{i}));
                end
            end
            plotArgs{end+1} = 1:length(varargin{i});
            plotArgs{end+1} = varargin{i};
            state = 'option';
            i = i + 1;
        case 'option'
            if ischar(varargin{i}) && reMatch(varargin{i}, '^[bgrcmykw.ox+*sdv^<>ph:-]+$')
                % Stand-alone string option
                plotArgs{end+1} = varargin{i};
                state = 'data';
                i = i + 1;
            elseif ischar(varargin{i})
                % Key of key-value option
                plotArgs{end+1} = varargin{i};
                state = 'value';
                i = i + 1;
            else
                % Data to plot
                state = 'data';
            end
        case 'value'
            plotArgs{end+1} = varargin{i};
            i = i + 1;
            state = 'option';
        otherwise
            error('Unknown state: %s', state)
    end
end

h = plot(plotArgs{:});

if nargout < 1
    clear h
end
