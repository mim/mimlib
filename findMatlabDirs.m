function dirs = findMatlabDirs(findDirsWithMFiles, ignorePattern)

if nargin < 2, ignorePattern = '^\.git$|^\.svn$|^CVS$|^RCS$|^private$|^@|^\+'; end
if nargin < 1, findDirsWithMFiles = true; end

if ispc
    basedir = 'Z:\code';
else
    basedir = '~/code';
end

if findDirsWithMFiles
    [~,mFiles] = findFiles(basedir, '\.m$', 1, ignorePattern);
    dirs = listMap(@(x) fileparts(x), mFiles);
    dirs = unique(dirs);
else
    [~,dirs1] = findFiles(fullfile(basedir, 'matlab'), '.', 0, ignorePattern);
    [~,dirs2] = findFiles(fullfile(basedir, 'lib'), '.', 0, ignorePattern);
    [~,dirs3] = findFiles(fullfile(basedir, 'github'), '.', 0, ignorePattern);
    dirs = [dirs1; dirs2; dirs3];
end
