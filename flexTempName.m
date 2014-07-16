function name = flexTempName(suffix, useDir)

% Wrapper around matlab's tempname function to make it more flexible
%
% name = flexTempName(suffix, useDir)
%
% The temporary file will be in useDir (defaults to matlab's temp
% directory) and will end in suffix.

name = tempname;
if nargin > 1
    if ~exist(useDir, 'dir')
        warning('flexTempName:DirNotFound', ...
            'Directory %s does not exist, keeping default directory', useDir);
    else
        [~,f] = fileparts(name);
        name = fullfile(useDir, f);
    end
end
if nargin > 0
    name = [name suffix];
end

