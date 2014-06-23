function f = basename(pathName, withExtension, withDirs)

% f = basename(pathName, withExtension, withDirs)

if nargin < 2, withExtension = true; end
if nargin < 3, withDirs = 0; end

[d,f,e] = fileparts(pathName);
if withExtension
    f = [f e];
end
while withDirs > 0
    [d,f2] = fileparts(d);
    f = fullfile(f2, f);
    withDirs = withDirs - 1;
end
