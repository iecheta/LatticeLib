function qscatter3(v, varargin)

defaultCol = [0 0.4510 0.7412];

if size(v, 1) == 3 && size(v, 2) == 3
    warning("qscatter3.m: 3 x 3 matrix used. Make sure x, y, z coordinates are in the columns")
end

if nargin == 1
    sizeData = 500;
    col = defaultCol;
elseif nargin == 2
    sizeData = varargin{1};
    col = defaultCol;
elseif nargin == 3
    sizeData = varargin{1};
    col = varargin{2};
else
    error('incorrect number of inputs')
end

scatter3(v(:, 1), v(:, 2), v(:, 3),'.',...
    'SizeData', sizeData, 'MarkerEdgeColor', col)

end