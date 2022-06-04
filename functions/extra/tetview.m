function tetview(verts, varargin)

% Plot individual tetrahedron and its corresponding regular tetrahedron

% Inputs:
    % If nargin == 1
    % verts (if nargin = 1): 4 x 3 matrix of tet coordinates
    
    % If nargin == 3
    % verts (if nargin = 3): n x 3 matrix of mesh coordinates
    % varargin{1}: tetrahedra faces. m x 4 tetrahedra indexing matrix
    % varargin{2}: queryNum. an integer which selects an individual
    %              tetrahedron. 1<=queryNum<=m
    
% Output
    % Colour coded tetrahedra plot

if nargin == 1
    faces = [1 2 3 4];
    queryNum = 1;
elseif nargin == 3
    faces = varargin{1};
    queryNum = varargin{2};
else
    error('incorrect number of inputs')
end

% Extract the selected tetrahedron
[tetCurrent, ~, circum, r] = tetextract(verts, faces, queryNum);

% Calculate regular tetrahedron
[tetCoords] = tetregular(circum, r);

% Calculate mesh quality
meshQualRatio = tetvolume(tetCurrent)/tetvolume(tetCoords);

tetIndex = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
faceCol = [1 0 0] + [-1 1 0]*meshQualRatio;
faceCol = [24 191 181]/255; %%%

hold on
grid on

% Plot selected tetrahedron
% scatter3(tetCurrent(:, 1), tetCurrent(:, 2), tetCurrent(:, 3), 30, [0 0 1], 'filled')
patch('Faces', tetIndex, 'Vertices', tetCurrent, 'FaceColor', faceCol,...
    'FaceAlpha', 0.8)

% Plot regular tetrahedron
scatter3(tetCoords(:, 1), tetCoords(:, 2), tetCoords(:, 3), 30, [1 0 1], 'filled')
patch('Faces', tetIndex, 'Vertices', tetCoords, 'FaceColor', [0 1 0],...
    'FaceAlpha', 0.2)

% Circumcentre
scatter3(circum(:, 1), circum(:, 2), circum(:, 3), 100, [0 0 0], 'filled')

% Create circumsphere
[x, y, z] = sphere;
surf(x*r+circum(1),y*r+circum(2),z*r+circum(3), 'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.2, 'EdgeColor', 'none')

view(3)
axis equal
end