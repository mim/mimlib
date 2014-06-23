function dirs = findDirsBut(baseDir, exclude)

% Find all of the directories under baseDir excluding those that match
% exclude, which is a regular expression that is compared to individual
% directory names (not to full paths).

exclude = ['^\.$|^\.\.$|' exclude];
dirs = {baseDir};
curDirs = {baseDir};
while ~isempty(curDirs)
    curDir = curDirs{1};
    curDirs = curDirs(2:end);
    subDirs = dir(curDir);
    for d = 1:length(subDirs)
        if subDirs(d).isdir && isempty(regexp(subDirs(d).name, exclude, 'once'))
            curDirs{end+1} = fullfile(curDir, subDirs(d).name);
            dirs{end+1} = curDirs{end};
        end
    end
end
