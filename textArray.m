function lines = textArray(fileName)

% Read a text file into a cell array of lines
%
% lines = textArray(fileName);

text = fileread(fileName);
text = text(:)';
lines = split(text, '\n');
lines = lines';
