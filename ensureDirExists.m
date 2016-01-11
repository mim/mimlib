function ensureDirExists(fileName, isDir)

% Create the directory that fileName will be in if it does not exist

if ~exist('isDir', 'var') || isempty(isDir), isDir = 0; end

if isDir
    d = fileName;
else
    d = fileparts(fileName);
end
if isempty(d), d = '.'; end


if ~exist(d, 'dir')
    [status msg] = mkdir(d);

    %if ~exist(d, 'dir') || (status == 0)
    %    error('Unable to create "%s": %s', d, msg)
    %end

    if ~exist(d, 'dir')
        system(sprintf('mkdir -p "%s"', d));
        
        if ~exist(d, 'dir')
            error('Unable to create "%s"', d)
        end
    end
end
