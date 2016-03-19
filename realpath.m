function real = realpath(path)

% Resolve all symbolic links in a path to a file that may not exist.
%
%
%
% Uses the posix 'readlink -f' command

cmd = sprintf('readlink -f -n "%s"', path);
[status result] = system(cmd);
if status
  warning('realpath:nonZeroStatus', 'Non-zero exit status from readlink: %d, %s', status, result);
else
  real = result;
end
