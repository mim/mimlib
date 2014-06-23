function r = rmsNonZero(x, noiseFloor_dB, aWeight, aWeightFs)

if ~exist('noiseFloor_dB', 'var') || isempty(noiseFloor_dB), noiseFloor_dB = -96; end
if ~exist('aWeight', 'var') || isempty(aWeight), aWeight = false; end
if ~exist('aWeightFs', 'var') || isempty(aWeightFs), aWeightFs = 16000; end

if aWeight
    % Normalize A-weighted RMS energy
    h = fdesign.audioweighting('WT,Class','A',1,aWeightFs);
    Ha = design(h,'ansis142');
    x = filter(Ha, x);
end

noiseFloor = 10^(noiseFloor_dB/20);
keep = abs(x(:)) > noiseFloor;
r = sqrt(mean(x(keep).^2));
