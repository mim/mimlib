function audition(wavFile)

% Make a simple interactive spectrogram audio player like adobe audition

win_s = 0.016;

[x fs] = audioread(wavFile);
win = round(fs * win_s);
hop = round(win / 4);

X = stft(x(:,1)', win, win, hop);

freq_hz = (0:win/2) * fs / win;
time_s  = (1:size(X,2)) * hop / fs;

imagesc(time_s, freq_hz, db(X));
axis xy;
colorbar;

while true
    [clickT_s clickF_hz button] = ginput(1);
    if button ~= 1
        break
    end
    clickT = round(clickT_s * fs);
    sound(x(clickT:end,:), fs);
end
