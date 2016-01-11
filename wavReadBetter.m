function [x fs] = wavReadBetter(filename, dur_s)

% Simple wrapper around wavread that takes limits in seconds
%
% [x fs] = wavReadBetter(filename, dur_s)
%
% Optional argument dur_s can either be a single number, in which case it
% indicates the length of the segment in seconds to load, or it can a
% 2-vector, in which case is specifies the beginning and end of the
% segment.  The beginning will have 1 sample added to it, so it can be 0
% seconds and you can use integers for reading chunks of files without
% overlap.


if ~exist('dur_s', 'var') || isempty(dur_s), dur_s = []; end

if ~exist(filename, 'file')
    error('Could not find file: %s', filename)
end

if isempty(dur_s)
    [x fs] = audioread(filename);
else
    info = audioinfo(inFile);
    fs = info.SampleRate;
    nSamp = info.TotalSamples;

    dur = round(dur_s * fs);
    if length(dur) == 2
        dur(1) = dur(1) + 1;
    else
        dur = [1 dur];
    end
    dur = min(dur, nSamp);

    [x fs] = audioread(filename, dur);
end
