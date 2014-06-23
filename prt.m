function prt(varargin)
%
%  prt(name)
%  prt('key', value, ...)
%
% Print the current axes to a file named "dir/##-name" where ## is the
% number of images that have been printed so far.  It can be reset by
% passing in name-value pairs of options, which all need to be set at
% the same time.  It will pass through all exportfig options,
% e.g. FontSize, Resolution, SeparateText, Color, but also recognizes
% options of its own:
%
% ToFile     (0) actually export, otherwise just pause
% TargetDir (./) base directory for output files
% NextNum    (0) the number to be used next to make the file name
%
% EXAMPLE
%
% Some possible option settings
% For a paper:
%   prt('ToFile', 1)
% For a poster:
%   prt('SeparateText', 1, 'Color', 'cmyk', ...
%       'Resolution', 144, 'ToFile', 1)
% For a talk:
%   prt('SeparateText', 1, 'Color', 'rgb', ...
%       'Resolution', 144, 'ToFile', 1)

% Remember the user's options for future calls
persistent opt exp_opt;

% TODO: add reset option for resetting instead of always resetting
add_options = (mod(nargin, 2) == 1);
reset_options = (nargin > 1) * (mod(nargin, 2) == 0);

% Create with some defaults
if reset_options || ~(exist('opt', 'var') && isstruct(opt))
  opt = struct('NextNum', 0, 'TargetDir', '.', 'ExportFig', 0, ...
               'ToFile', 0, 'StartAt', 0, 'NumberPlots', 1);
  exp_opt = struct('FontSize', 1, 'Color', 'rgb');
end

% Update options for the current execution
[c_opt, c_exp_opt] = update_options(opt, exp_opt, varargin{1+add_options:end});

% If prt was just called to set options, update the persistent
% options and exit
if reset_options
  opt     = c_opt;
  exp_opt = c_exp_opt;
  return
end

name = varargin{1};

% Maybe the user forgot to reset the options.  Doesn't matter for
% preview mode
if c_opt.ToFile && (etime(clock, c_opt.Updated) > 5 * 60)
  warning('You might be using stale options')
end

if opt.NumberPlots
    filename = fullfile(c_opt.TargetDir, sprintf('%02d-%s', c_opt.NextNum, name));
else
    filename = fullfile(c_opt.TargetDir, name);
end

eo = unstruct(c_exp_opt);
if c_opt.ToFile
  disp(filename)
  my_export_fig(gcf, filename, eo{:});
  %close
else
  disp(filename)
  if c_opt.StartAt <= c_opt.NextNum
    my_export_fig(gcf, '', eo{:});
    pause
  end
end

opt.NextNum = opt.NextNum + 1;


function [opt, exp_opt] = update_options(opt, exp_opt, varargin)
% Update options based on (name, value) pairs passed in varargin.

for i=1:2:length(varargin)
  if isfield(opt, varargin{i})
    opt = setfield(opt, varargin{i}, varargin{i+1});
  else
    exp_opt = setfield(exp_opt, varargin{i}, varargin{i+1});
  end
end

% Update date field
opt.Updated = clock;

% Show current options without printing anything
%opt, exp_opt


function my_export_fig(H, filename, varargin)

% My simplified version of exportfig.  FormatX is for when Format
% is 'auto', in which case, the format will be chosen depending on
% the content of the axes.  It can be a line plot, an image, or
% both, and there are settings for each of these cases.

[width, height, font_size, color, format, res, fmtLine, fmtImg, ...
 fmtMixed, saveTicks] = ...
    process_options(varargin, 'Width', -1, 'Height', -1, ...
                    'FontSize', 1, 'Color', 'rgb', 'Format', 'auto', ...
                    'Resolution', 200, 'FormatLine', 'eps2c', ...
                    'FormatImage', 'png', 'FormatMixed', 'png', ...
                    'SaveTicks', 1);

if saveTicks
  % Save ticks and tick labels at original size
  axs = {'X', 'Y', 'Z'};
  to_save = {'Tick', 'TickLabel'};
  all_axes = findall(H, 'type', 'axes');
  for i=1:length(axs)
    for j=1:length(to_save)
      f = get(all_axes, [axs{i} to_save{j}]);
      if length(all_axes) > 1
        saved{i,j} = f;
      else
        saved{i,j} = {f};
      end
    end
  end
end

setPlotSize(H, width, height, 0);

% set(H, 'Units', 'inches');
% figPos = get(H,'Position');
% if width  < 0, width  = figPos(3); end
% if height < 0, height = figPos(4); end
% set(H, 'PaperPositionMode', 'auto');
% set(H, 'Position', [figPos(1) figPos(2) width height]);

if saveTicks
  % Restore ticks and tick labels at new size
  for i=1:length(axs)
    for j=1:length(to_save)
      for k=1:length(all_axes)
        set(all_axes(k), [axs{i} to_save{j}], saved{i,j}{k});
      end
    end
  end
end

if strcmp(format, 'auto')
  % Automatically figure out the format of the image, depending on
  % its contents
  hasImages = ~isempty(findall(H, 'type', 'image'));
  hasPlots  = ~isempty(findall(H, 'type', 'line')) || ...
      ~isempty(findall(H, 'type', 'surf'));
  switch 2*hasImages + hasPlots
   case 1 % just plots
    %disp('Detected line plot')
    format = fmtLine;
   case 2 % just images
    %disp('Detected image')
    format = fmtImg;
   case 3 % both plots and images
    %disp('Detected line plot and image')
    format = fmtMixed;
   otherwise
    warning('Couldn''t determine plot type')
  end
end

format = sprintf('-d%s', format);
resStr = sprintf('-r%d', res);

if filename
  % Make parent directories if necessary
  [d,f,e] = fileparts(filename);
  if ~exist(d, 'dir'), mkdir(d); end

  % Actually print it
  print(format, resStr, filename)
end
