function J = easymap(colors, M)

% J = easymap(colors, M)
%
% A colormap with colors in the specified order.  Colors are specified
% as single letters or whole names.  Colors is a cell array or a
% vector of letters.  The letters go from the bottom to the top of
% the colorbar.
%
% For example:
%   easymap('rwb') colormap that goes from red to blue through white
%   easymap('rkg') colormap that goes from red to green through black
%
% Translations of predefined colormaps: 
%   hsv: rygcbmr
%   gray: wb
%   cool: cm
%   better_jet: bcyr
%   jet4plot: rmcg
%
% Note that:
% cyan, magenta, green, and yellow go well with black
% blue goes well with white
% red goes well with both black and white

if ~exist('M', 'var'), M = size(get(gcf,'colormap'),1); end
if ~exist('colors', 'var'), colors = 'bcyr'; end

if iscell(colors)
  for i=1:length(colors)
    vecs(i,:) = name2rgb(colors{i});
  end
else
  for i=1:length(colors)
    vecs(i,:) = name2rgb(colors(i));
  end
end

V = size(vecs,1);
n = ceil((M-1) / (V-1));

for i=1:V-1
  x1 = linspace(0,1,n+1);
  J{i} = interp1([0 1], vecs(i:i+1,:), x1(1:end-1));
end
J{V} = vecs(V,:);
J = cat(1,J{:});



function rgb = name2rgb(name)
% Convert a color name or letter into an rgb vector

switch lower(name)
 case {'r','red'}
  rgb = [1 0 0];
 case {'g','green'}
  rgb = [0 1 0];
 case {'b','blue'}
  rgb = [0 0 1];
 case {'c','cyan'}
  rgb = [0 1 1];
 case {'m','magenta'}
  rgb = [1 0 1];
 case {'y','yellow'}
  rgb = [1 1 0];
 case {'k','black'}
  rgb = [0 0 0];
 case {'w','white'}
  rgb = [1 1 1];
 case {'p','purple'}
  rgb = [.5 0 1];
 case {'o','orange'}
  rgb = [1 .5 0];
 otherwise
  error('Don''t know color: "%s"', name)
end
