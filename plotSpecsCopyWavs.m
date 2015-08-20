function plotSpecsCopyWavs(inDir, outDir, toDisk, startAt, files, cax, maxFreq_hz, xrange_s, labels, varargin)

if ~exist('files', 'var'), files = {}; end
if ~exist('toDisk', 'var') || isempty(toDisk), toDisk = 0; end
if ~exist('startAt', 'var') || isempty(startAt), startAt = 0; end
if ~exist('maxFreq_hz', 'var') || isempty(maxFreq_hz), maxFreq_hz = inf; end
if ~exist('xrange_s', 'var'), xrange_s = []; end
if ~exist('cax', 'var') || isempty(cax), cax = [-80 10]; end
if ~exist('labels', 'var') || isempty(labels), labels = [1 1 1]; end

prt('ToFile', toDisk, 'StartAt', startAt, 'NumberPlots', 0, ...
    'Width', 4, 'Height', 3, 'TargetDir', outDir, ...
    'SaveTicks', 1, 'Resolution', 200)

if isempty(files)
    files = findFiles(inDir, '.*.wav');
end

cmap = jet(254);

for f = 1:length(files)
    name = basename(files{f}, 0);
    inFile = fullfile(inDir, files{f});
    if ~exist(inFile, 'file'), continue; end
    
    [X fs hop_s] = loadSpecgram(inFile);
    prtSpectrogram(db(X), name, fs, hop_s, cmap, cax, labels, maxFreq_hz, xrange_s, varargin{:})

    outWavFile = fullfile(outDir, files{f});
    if toDisk
        ensureDirExists(outWavFile);
        copyfile(inFile, outWavFile);
    end
end



function [X fs hop_s] = loadSpecgram(file, win_s)
if ~exist('win_s', 'var') || isempty(win_s), win_s = 0.032; end

[x fs] = wavReadBetter(file);
x = x(:,1);
nfft = 2 * round(win_s * fs / 2);
hop = round(nfft / 4);
X = stft(x', nfft, nfft, hop);
hop_s = hop / fs;
