function playWav(wavs)

if ~iscell(wavs)
    wavs = {wavs};
end

for i = 1:length(wavs)
    fprintf('%s\n', wavs{i});
    [x fs] = wavread(wavs{i});
    sound(x, fs);
end
