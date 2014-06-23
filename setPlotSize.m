function setPlotSize(H, width, height, sizeWindow)

% setPlotSize(H, width, height, sizeWindow)
%
% Set the size of a plot to be width x height inches.  H is a handle
% to a figure (e.g. from gcf) If sizeWindow is false, then the axes
% are set to the specified size, ignoring colorbars and legends.  If
% sizeWindow is true, then the whole window is set to the specified
% size.  Note that the size also doesn't include the title or x and
% y labels.

% Positions are measured from the bottom left of the window,
% relative to the window.  Positions are [bottom left corner x,
% bottom left corner y, width, height]

if ~exist('H', 'var') || isempty(H), H = gcf; end
if ~exist('width', 'var'), width = -1; end
if ~exist('height', 'var'), height = -1; end
if ~exist('sizeWindow', 'var'), sizeWindow = 0; end

threshold = 0.003;

set(H, 'Units', 'inches');
set(H, 'ActivePositionProperty', 'Position');
figPos = get(H,'Position');
set(H, 'PaperPositionMode', 'auto');

if sizeWindow
  if width  < 0, width  = figPos(3); end
  if height < 0, height = figPos(4); end
  finalPos = [figPos(1) figPos(2) width height];
  set(H, 'Position', finalPos);
else
  plotWH = getAxesWH(H);
  if width  < 0, width  = plotWH(1); end
  if height < 0, height = plotWH(2); end

  % Need to home in on the right position/size
  moves = 0;
  whs = [];
  while 1
    d = 0.99*([width height] - plotWH);
    if max(abs(d)) <= threshold
        break
    end
    
    figPos = get(H, 'Position');
    finalPos = [figPos(1) figPos(2) figPos(3)+d(1) figPos(4)+d(2)];
    set(H, 'Position', finalPos);
    figPos = get(H,'Position');
    plotWH = getAxesWH(H);
    moves = moves + 1;
    whs(moves,:) = figPos(3:4);

    if (moves > 15)
      % Take the average of the last few positions
      wh = mean(whs(end-5:end,:),1);
      finalPos = [figPos(1) figPos(2) wh];
      set(H, 'Position', finalPos)
      break
    end
  end
end


function wh = getAxesWH(H)
% Get the width and height of all of the plot-type axes in a figure

% Collect non-legend, non-colorbar axes
allAxes = findall(H, 'type', 'axes');
colorbars = findall(H, 'type', 'axes', 'tag', 'Colorbar');
legends = findall(H, 'type', 'axes', 'tag', 'legend');
plots = setdiff(allAxes, [colorbars; legends]);

% Find the most extreme dimensions of each one
set(plots, 'Units', 'inches');
positions = get(plots, 'Position');
if iscell(positions), positions = cat(1, positions{:}); end

% Need to do this so the subplots will resize automatically
set(plots, 'Units', 'normalized');  

corners = [positions(:,1:2) positions(:,1:2)+positions(:,3:4)];
extremes = [min(corners(:,1:2),[],1) max(corners(:,3:4),[],1)];
wh = extremes(3:4) - extremes(1:2);
