function [X fs x] = loadSpecgram(fileName, len_s, fs, nFft, preemph, forceMono, withNegF)

% Load a wave file for experiments.

if nargin < 7, withNegF = 0; end
if nargin < 6, forceMono = 1; end
if nargin < 5, preemph = 1; end

if any(length(len_s) == [0 1])
    [x fsOrig] = wavread(fileName);
elseif length(len_s) == 2
    [x fsOrig] = wavReadBetter(fileName, len_s);
else
    error('Unexpected length for len_s: %d', length(len_s))
end

if (size(x,2) > 1) && forceMono
    % Stereo -> mono
    x = mean(x,2);
end

% Resample
x = resample(x, fs, fsOrig);

% Compute A-weighted energy
h = fdesign.audioweighting('WT,Class','A',1,fs);
Ha = design(h,'ansis142');
aWeighted = filter(Ha, x);

% Normalize A-weighted RMS energy
r = sqrt(mean(aWeighted.^2));
x = x * 0.1 / r;

if preemph
    % Pre-emphasize
    x = filter([1 -0.97], 1.97, x);
end

if length(len_s) == 1
    % Zero-pad or truncate
    x = setSignalLen(x, fs, len_s);
end

% Spectrogram
X = stft(x', nFft, nFft, nFft / 4);

if withNegF
    % Add the symmetric parts back in
    X = [X; conj(X(end-1:-1:2,:))];
end
