function dirs = findMatlabDirs(basedir, findDirsWithMFiles, ignorePattern)

if nargin < 3, ignorePattern = '^\.git$|^\.svn$|^CVS$|^RCS$|^private$|^@|^\+'; end
if nargin < 2, findDirsWithMFiles = true; end
if nargin < 1
  if ispc
    basedir = 'Z:\code\matlab';
  else
    basedir = '~/code/matlab';
  end
end

if findDirsWithMFiles
    [~,mFiles] = findFiles(basedir, '\.m$', 1, ignorePattern);
    dirs = listMap(@(x) fileparts(x), mFiles);
    dirs = unique(dirs);
else
    [~,dirs] = findFiles(basedir, '.', 0, ignorePattern);
end
