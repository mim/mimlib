function wavWriteBetter(varargin)

outFile = varargin{end};
ensureDirExists(outFile);

for i=1:30
    try
        wavwrite(varargin{:});
        break
    catch e
        fprintf('Problem writing %s\n  %s ...\n', outFile, e.message);
        pause(2)
    end
end