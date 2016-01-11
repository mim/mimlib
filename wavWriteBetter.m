function wavWriteBetter(y, fs, outFile, varargin)

% Wrapper around audiowrite that makes the directory first and keeps trying
% to write a file that is busy (open on windows)
%
% Takes arguments in wavwrite order:
%   wavWriteBetter(y, fs, filename, [key, value]);

ensureDirExists(outFile);

for i=1:30
    try
        audiowrite(outFile, y, fs, varargin{:});
        break
    catch e
        fprintf('Problem writing %s\n  %s ...\n', outFile, e.message);
        pause(2)
    end
end
