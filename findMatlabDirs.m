function dirs = findMatlabDirs(findDirsWithMFiles, ignorePattern)

if nargin < 2, ignorePattern = '^\.git$|^\.svn$|^CVS$|^RCS$|^private$|^@|^\+'; end
if nargin < 1, findDirsWithMFiles = true; end

if ispc
    basedir = 'Z:\code';
else
    basedir = '~/code';
end

if findDirsWithMFiles
    [~,mFiles] = findFiles(fullfile(basedir, 'matlab'), '\.m$', 1, ignorePattern);
    dirs = listMap(@(x) fileparts(x), mFiles);
    dirs = unique(dirs);
else
    [~,dirs] = findFiles(fullfile(basedir, 'matlab'), '.', 0, ignorePattern);
end
