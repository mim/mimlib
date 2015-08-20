function y = mixSignalsWithOffsets(x1, x2, fs, start1_s, start2_s, dither_db)

% Shift two signals in time and add them together, zero padding as
% necessary

if ~exist('dither_db', 'var') || isempty(dither_db), dither_db = -inf; end
if ~exist('start1_s', 'var') || isempty(start1_s), start1_s = 0; end
if ~exist('start2_s', 'var') || isempty(start2_s), start2_s = 0; end

[len1 nch1] = size(x1);
[len2 nch2] = size(x2);
assert(nch1 == nch2)
nch = nch1;

start1 = round(fs * start1_s);
start2 = round(fs * start2_s);
len = max(start1 + len1, start2 + len2);

dither = 10^(dither_db/20);
x1full = [dither * randn(start1, nch); x1; dither * randn(len - start1 - len1, nch)];
x2full = [dither * randn(start2, nch); x2; dither * randn(len - start2 - len2, nch)];

y = x1full + x2full;
