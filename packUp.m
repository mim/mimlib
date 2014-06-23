function mFiles = packUp(destDir, mFiles, dataFiles, fnsThatShouldRun)

% Copy necessary files into a dest directory and test that everything works
% with the path cleared.
%
% files = packUp(destDir, mFiles, dataFiles, fnsThatShouldRun);
%
% Inputs:
%   destDir           directory to copy files to
%   mFiles            cell array of m-files to copy (absolute or relative path)
%   dataFiles         cell array of data files to copy (absolute or relative path)
%   fnsThatShouldRun  cell array of functions with no arguments that
%                     should be able to run if all dependencies are copied
%                     properly 
%
% Outputs:
%   mFiles  cell array of original mFiles augmented with others that need
%           to be included, may need to be run again to find more

ensureDirExists(destDir, 1);
rmdir(destDir, 's');
ensureDirExists(destDir, 1);

disp('Copying files over')
for f = 1:length(mFiles)
    copyfile(mFiles{f}, destDir);
end
for f = 1:length(dataFiles)
    fileDest = fullfile(destDir, dataFiles{f});
    ensureDirExists(fileDest);
    copyfile(dataFiles{f}, fileDest);
end

disp('Remembering current state')
origDir = pwd();
origPath = path();
rmFromPath = findMatlabDirs();

keepGoing = true;
missingFile = '';
while keepGoing
    disp('Clearing state')
    rmpath(rmFromPath{:});
    cd(destDir);

    disp('Testing')
    try
        for f = 1:length(fnsThatShouldRun)
            fnsThatShouldRun{f}();
        end
        keepGoing = false;
    catch e
        fprintf('Error: %s\n', e.message)
        if strcmp(e.identifier, 'MATLAB:UndefinedFunction')
            missingFile = regexprep(e.message, '^.*?''(.*?)''.*$', '$1');
        else
            keepGoing = false;
        end
    end

    disp('Restoring original state')
    cd(origDir);
    path(origPath);
    
    if ~isempty(missingFile)
        mf = which(missingFile);
        mFiles{end+1} = mf;
        fprintf('missing file: ''%s''\n', mf);
        copyfile(mf, destDir)
    end
end
