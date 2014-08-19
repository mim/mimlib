function x = pinkNoise(nX, nC, gain_db)

% Generate pink noise
%
% From: http://www.dsprelated.com/dspbooks/sasp/Example_Synthesis_1_F_Noise.html

if ~exist('gain_db', 'var') || isempty(gain_db), gain_db = -10; end
if ~exist('nC', 'var') || isempty(nC), nC = 1; end

B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1 -2.494956002   2.017265875  -0.522189400];
nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
v = randn(nX+nT60, nC); % Gaussian white noise: N(0,1)
x = filter(B,A,v);    % Apply 1/F roll-off to PSD
x = x(nT60+1:end, :);    % Skip transient response

gain = 10^((gain_db + 16) / 20);  % Gain of 1 gives about -16dB power
x = x * gain;
