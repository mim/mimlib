function playWav(wavs, ends_s, showSpec, doPause, chan, cax)

if ~exist('ends_s', 'var'), ends_s = []; end
if ~exist('showSpec', 'var') || isempty(showSpec), showSpec = false; end
if ~exist('doPause', 'var') || isempty(doPause), doPause = true; end
if ~exist('chan', 'var') || isempty(chan), chan = 1; end
if ~exist('cax', 'var'), cax = []; end

if ~iscell(wavs)
    wavs = {wavs};
end

for i = 1:length(wavs)
    fprintf('%d: %s channel %d\n', i, wavs{i}, chan);
    
    info = audioinfo(wavs{i});
    fs = info.SampleRate;
    
    if isempty(ends_s)
        [x fs] = audioread(wavs{i});
    else
        ends = ends_s * fs;
        ends(1) = ends(1) + 1;
        [x fs] = audioread(wavs{i}, ends);
    end
        
        
    if showSpec
        X = stft(x(:,chan)', 1024, 1024, 256);
        if isempty(cax)
            subplots(db(X));
        else
            subplots(lim(db(X), cax(1), cax(2)));
        end
    end
    
    sound(x(:,chan), fs);
    
    if doPause
        pause
    else
        pause(size(x,1)/fs)
    end
end
