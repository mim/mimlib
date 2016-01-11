function [X X1 X2 fs nFft] = loadMix(file1, file2, len_s, win_ms, snr_db, preemph, forceMono, withNegF)

if ~exist('preemph', 'var') || isempty(preemph), preemph = 1; end
if ~exist('forceMono', 'var') || isempty(forceMono), forceMono = 1; end
if ~exist('withNegF', 'var') || isempty(withNegF), withNegF = 0; end
if ~exist('win_ms', 'var') || isempty(win_ms), win_ms = 64; end
if ~exist('snr_db', 'var') || isempty(snr_db), snr_db = 0; end

[len1_s fs1] = wavFileInfo(file1);
[len2_s fs2] = wavFileInfo(file2);
if ~exist('len_s', 'var') || isempty(len_s), len_s = max(len1_s, len2_s); end

fs = min(fs1, fs2);
nFft = round(win_ms/1000 * fs);
X1 = loadSpecgram(file1, len_s, fs, nFft, preemph, forceMono, withNegF);
X2 = loadSpecgram(file2, len_s, fs, nFft, preemph, forceMono, withNegF);

snr = 10^(snr_db/20);
X1 = X1 * sqrt(snr);
X2 = X2 / sqrt(snr);

X = X1 + X2;

function [len_s fs] = wavFileInfo(fileName)
info = audioinfo(fileName);
fs = info.SampleRate;
nSamp = info.TotalSamples;
len_s = nSamp / fs;
