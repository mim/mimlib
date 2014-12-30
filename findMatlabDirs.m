function dirs = findMatlabDirs(findDirsWithMFiles, ignorePattern)

if nargin < 2, ignorePattern = '^\.git$|^\.svn$|^CVS$|^RCS$|^private$|^@|^\+'; end
if nargin < 1, findDirsWithMFiles = true; end

if ispc
    basedir = 'Z:\code';
else
    basedir = '~/code';
end

if findDirsWithMFiles
    [~,mFiles2] = findFiles(fullfile(basedir, 'lib'), '\.m$', 1, ignorePattern);
    [~,mFiles3] = findFiles(fullfile(basedir, 'github'), '\.m$', 1, ignorePattern);
    [~,mFiles1] = findFiles(fullfile(basedir, 'matlab'), '\.m$', 1, ignorePattern);
    mFiles = [mFiles1; mFiles2; mFiles3];
    dirs = listMap(@(x) fileparts(x), mFiles);
    dirs = unique(dirs);
else
    [~,dirs2] = findFiles(fullfile(basedir, 'lib'), '.', 0, ignorePattern);
    [~,dirs3] = findFiles(fullfile(basedir, 'github'), '.', 0, ignorePattern);
    [~,dirs1] = findFiles(fullfile(basedir, 'matlab'), '.', 0, ignorePattern);
    dirs = [dirs1; dirs2; dirs3];
end
