function h = plot3s(x, y, z, varargin)

% Plot 3d line with shadow
%
%  h = plot3s(x, y, z, varargin)
%
% Based on: http://www.mathworks.com/matlabcentral/answers/60386-getting-plot-projection-in-3d

h = plot3(x, y, z, varargin{:});
hold on

c = get(h, 'Color');
sc = 1 - (1-c) * 0.3;

xL = get(gca,'XLim');
yL = get(gca,'XLim');
zL = get(gca,'XLim');

oneMat = ones(length(x), 1);
plot3(oneMat .* xL(2), y, z, 'Color', sc);
plot3(x, oneMat .* yL(2), z, 'Color', sc);
plot3(x, y, oneMat .* zL(1), 'Color', sc);
grid on
hold off

if nargout == 0
    clear h
end
