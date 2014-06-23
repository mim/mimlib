function x = readRawAudio(fileName, channels, bits, bigEndian)

% Read raw audio from a file into a matrix
%
% x = readRawAudio(fileName, channels, bits, bigEndian)
%
% Outputs a matrix that is nFrames x channels of the samples.
%
% Inputs:
%   fileName      name of file to read
%   channels  [1] number of channels in the audio
%   bits     [16] bits in each sample (8 or 16)
%   bigEndian [1] whether the byte-order is bigEndian or little

if nargin < 4, bigEndian = true; end
if nargin < 3, bits = 16; end
if nargin < 2, channels = 1; end

if ~exist(fileName, 'file')
    error('Could not find file: %s', fileName)
end

switch bits
    case 8
        precision = 'int8';
    case 16
        precision = 'int16';
    otherwise
        error('Unknown number of bits: %d', bits)
end

if bigEndian
    machineformat = 'b';
else
    machineformat = 's';
end

f = fopen(fileName);
if f < 0
    error('Error opening file: %s', fileName)
end
t = fread(f, inf, precision, 0, machineformat);
fclose(f);

x = reshape(t / (2^bits), channels, [])';
