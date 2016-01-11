function playWav(wavs, showSpec, doPause, chan)

if ~exist('showSpec', 'var') || isempty(showSpec), showSpec = false; end
if ~exist('doPause', 'var') || isempty(doPause), doPause = true; end
if ~exist('chan', 'var') || isempty(chan), chan = 1; end

if ~iscell(wavs)
    wavs = {wavs};
end

for i = 1:length(wavs)
    fprintf('%d: %s channel %d\n', i, wavs{i}, chan);
    [x fs] = audioread(wavs{i});
    if showSpec
        X = stft(x(:,chan)', 1024, 1024, 256);
        subplots(db(X));
    end
    
    sound(x(:,chan), fs);
    
    if doPause
        pause
    end
end
