function linkaxes(ax,option)
%LINKAXES Synchronize limits of specified 2-D axes
%  Use LINKAXES to synchronize the individual axis limits
%  on different subplots within a figure. Calling linkaxes
%  will make all input axis have identical limits. This is useful
%  when you want to zoom or pan in one subplot and display 
%  the same range of data in another subplot.
%
%  LINKAXES(AX) Links x and y-axis limits of the 2-D axes 
%  specified in AX.
%
%  LINKAXES(AX,OPTION) Links the axes AX according to the 
%  specified option. The option argument can be one of the 
%  following strings: 
%        'x'   ...link x-axis only
%        'y'   ...link y-axis only
%        'xy'  ...link x-axis and y-axis
%        'off' ...remove linking
%
%  See the LINKPROP function for more advanced capabilities 
%  that allows linking object properties on any graphics object.
%
%  Example (Linked Zoom & Pan):
%
%  ax(1) = subplot(2,2,1);
%  plot(rand(1,10)*10,'Parent',ax(1));
%  ax(2) = subplot(2,2,2);
%  plot(rand(1,10)*100,'Parent',ax(2));
%  linkaxes(ax,'x');
%  % Interactively zoom and pan to see link effect
%
%  See also LINKPROP, ZOOM, PAN.

% Copyright 2003-2011 The MathWorks, Inc.

if ~exist('option', 'var') || isempty(option), option = 'xy'; end

if nargin==0 || isempty(ax)
    fig = get(0,'CurrentFigure');
    if isempty(fig), return; end
    ax = findobj(gcf,'type','axes','-not','Tag','legend','-not','Tag','Colorbar');
    nondatachild = logical([]);
    for k=length(ax):-1:1
      nondatachild(k) = isappdata(ax(k),'NonDataObject');
    end
    ax(nondatachild) = [];
else
    naxin = length(ax);
    ax = findobj(ax(ishghandle(ax,'axes')),'flat','type','axes','-not','Tag',...
        'legend','-not','Tag','Colorbar');
    if ~isempty(ax) && length(ax)<naxin
         warning(message('MATLAB:linkaxes:RequireDataAxes'));
    end
    
    % Ensure that no axes are repeated.      
    [~,I] = unique(ax); 
    Idup = setdiff(1:length(ax),I); 
    ax(Idup) = []; 
end


if isempty(ax)
    error(message('MATLAB:linkaxes:InvalidFirstArgument'));
end
h = handle(ax);

% Only support 2-D axes
if ~all(local_is2D(h))
    warning(message('MATLAB:linkaxes:Requires2Dinput'));
end

% Remove any prior links to input handles
localRemoveLink(ax)

% Flush graphics queue so that all axes
% are forced to update their limits. Otherwise,
% calling XLimMode below may get the wrong axis limits
drawnow;

% Create new link
switch option
    case 'x'
        set(ax,'XLimMode','manual');
        hlink = linkprop(ax,'XLim');
    case 'y'
        set(ax,'YLimMode','manual');
        hlink = linkprop(ax,'YLim');
    case 'xy'
        set(ax,'XLimMode','manual','YLimMode','manual');
        hlink = linkprop(ax,{'XLim','YLim'});
    case 'off'
        hlink = [];
    otherwise
     error(message('MATLAB:linkaxes:InvalidSecondArgument'));
end

KEY = 'graphics_linkaxes';
if (feature('HGUsingMATLABClasses') ~= 1)
    for i=1:length(ax)
        setappdata(ax(i),KEY,hlink);
    end
else 
    % MCOS graphics cannot rely on custom machinery in hgload to restore
    % linkaxes. Instead, create a graphics.internal.LinkAxes to wrap the
    % linkprop which will restore the linkaxes when it is de-serialized.
    for i=1:length(ax)
        setappdata(ax(i),KEY,graphics.internal.LinkAxes(hlink));
    end    
end
%--------------------------------------------------%
function localRemoveLink(ax)

KEY = 'graphics_linkaxes';

for n = 1:length(ax)
  % Remove this handle from previous link object
  hlink = getappdata(ax(n),KEY);
  if any(ishandle(hlink))
      removetarget(hlink,ax(n));
  end
end


% Deletion of link object will occur implicitly 
% when no more handles reference the link object

%--------------------------------------------------%
function [bool] = local_is2D(ax)
% Don't call is2D.m for now since that only considers x-y plots
bool = false(1,length(ax));
for n = 1:length(ax)
  bool(n) = logical(sum(campos(ax(n))-camtarget(ax(n))==0)==2);
end