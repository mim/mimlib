function printStatus(c)

% Print a character as a status update on the console, intelligently wrap
% lines by remembering how many have been printed.  Start over by calling
% with c = '\n';

maxCol = 80;
persistent col;
if isempty(col) || strcmp(c, '\n')
    col = 0;
end
fprintf(c)
col = col + length(sprintf(c));
if col >= maxCol
    fprintf('\n')
    col = mod(col, maxCol);
end
