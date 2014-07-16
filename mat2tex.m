function mat2tex(M, format)

% mat2tex(M, format)
%
% Print out a latex table using data from a matlab matrix.  Format is
% an optional argument specifying the way printf should print each
% matrix element.  E.g.
%
%   mat2tex(eye(3), '%0.3f')
% 
%   \begin{tabular}{ccc}
%   1.000 & 0.000 & 0.000 \\
%   0.000 & 1.000 & 0.000 \\
%   0.000 & 0.000 & 1.000 \\
%   \end{tabular}

% Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
% distributable under the GPL


if(nargin < 2) format = '%d'; end

fprintf('\n\\begin{tabular}{');
for i=1:size(M,2)
  fprintf('c');
end
fprintf('}\n');

for i=1:size(M,1)
  fprintf([format ' & '], M(i,1:end-1));
  fprintf([format ' \\\\\n'], M(i,end));
end

fprintf('\\end{tabular}\n\n');
