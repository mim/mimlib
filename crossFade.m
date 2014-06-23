function x = crossFade(x1, x2, fs, overlap_s)

% Cross-fade between two signals
%
% x = crossFade(x1, x2, fs, overlap_s)
%
% The signals will be crossfaded over a duration of overlap_s seconds, so
% the length of x in seconds will be len_s(x1) + len_s(x2) - overlap_s.
% Operates in the column direction.

overlap = round(overlap_s * fs);
rampUp = linspace(0, 1, overlap+2)';
rampUp = rampUp(2:end-1);

part1 = x1(1:end-overlap,:);
part2a = bsxfun(@times, x1(end-overlap+1:end,:), 1-rampUp);
part2b = bsxfun(@times, x2(1:overlap,:), rampUp);
part3 = x2(overlap+1:end,:);

x = [part1; part2a+part2b; part3];
