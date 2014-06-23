function y = setSignalLen(x, fs, len_s)

% Set the length of a signal by truncating or zero padding.
%
% y = setSignalLen(x, fs, len_s)
%
% Happens along the column dimension.  If the signal is longer than len_s,
% then take the middle len_s seconds of it.  If the signal is shorter than
% len_s, then zero pad both the beginning and end until it is len_s seconds
% long.

len = round(fs * len_s);

[nSamp nChan] = size(x);

if nSamp >= len
    trim = nSamp - len;
    beginTrim = floor(trim / 2);
    endTrim   = trim - beginTrim;
    
    y = x(beginTrim+1:end-endTrim,:);
else
    xFade_s = 0.01;
    xFade = round(fs * xFade_s);

    zpLen = len - nSamp;
    beginZpLen = floor(zpLen / 2);
    endZpLen   = zpLen - beginZpLen;
    
    y = crossFade(zeros(beginZpLen+xFade,nChan), x, fs, xFade_s);
    y = crossFade(y, zeros(endZpLen+xFade,nChan), fs, xFade_s);
end
