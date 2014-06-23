function [files fullPaths] = findFiles(baseDir, pattern, isFile, exclude)

% Find files in a directory that match a regular expression pattern.
%
% [files fullPaths] = findFiles(baseDir, pattern, isFile, exclude)
%
% baseDir is the directory to start at.  pattern is a regular expression
% that will be matched against the whole path (excluding baseDir).  If
% isFile is true, return files, false means return directories.  exclude is
% a regular expression that will be applied to (individual) directory names
% to keep them from being explored.  By default it is '\.git' and it will
% have . and .. prepended to it to avoid infinite loops.
%
% Output subDirs is a cell array of paths after baseDir, fullPaths is a
% cell array of paths including baseDir.

if ~exist('exclude', 'var'), exclude = '^\.git$'; end
if ~exist('pattern', 'var') || isempty(pattern), pattern = '.'; end
if ~exist('isFile', 'var') || isempty(isFile), isFile = 1; end 

exclude = ['^\.$|^\.\.$|' exclude];
fullPaths = {};
curDirs = {baseDir};
while ~isempty(curDirs)
    curDir = curDirs{1};
    curDirs = curDirs(2:end);
    
    useLs = ispc();
    if useLs
        % This is a tiny bit slower than using dir() below
        subFiles = cellstr(ls(curDir));
        for d = 1:length(subFiles)
            if ~isempty(regexp(subFiles{d}, exclude, 'once'))
                continue;
            end
            curPath = fullfile(curDir, subFiles{d});
            fileIsDir = isdir(curPath);
            if fileIsDir == ~isFile && reMatch(curPath, pattern)
                fullPaths{end+1} = curPath;
            end
            if fileIsDir
                curDirs{end+1} = curPath;
            end
        end
    else
        subFiles = dir(curDir);
        for d = 1:length(subFiles)
            if ~isempty(regexp(subFiles(d).name, exclude, 'once'))
                continue;
            end
            if subFiles(d).isdir == ~isFile 
                curPath = fullfile(curDir, subFiles(d).name);
                if reMatch(curPath, pattern)
                    fullPaths{end+1} = curPath;
                end
            end
            if subFiles(d).isdir
                curDirs{end+1} = fullfile(curDir, subFiles(d).name);
            end
        end
    end
end

fullPaths = sort(fullPaths(:));
files = cell(size(fullPaths));
startAt = length(baseDir) + 1 + (baseDir(end) ~= filesep);
for i = 1:length(fullPaths)
    files{i} = fullPaths{i}(startAt:end);
end

fprintf('Found %d files\n', length(files));
