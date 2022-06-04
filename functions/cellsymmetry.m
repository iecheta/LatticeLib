function [strutVerticesRot] = cellsymmetry(varargin)

% Take strut coordinates and create 3 duplicates, each rotated by 90, 180,
% and 270 degrees about z-axis.

% Inputs:
    % 3 x 2 matrix of the line segment's start and end point
    % varargin, so you can enter as many sets of 3 x 2 as you want.
    
% Output:
    % strutVerticesRot: Cell array

% Create cell array for struts - cell required as a different amount of
% vertices may be used to define each strut
strutVertices = cell(1, nargin);

for n = 1:nargin
    strutVertices{1, n} = varargin{n};
    
    if size(varargin{n}, 1) ~= 3
        error('incorrect input. vertices matrix must be 3 x n')
    end
    
    if size(varargin{n}, 2) == 3
        warning('3 x 3 matrix. Make sure x,y,z is in the rows')
    end
end

% Create rotation matrix
theta = 90;
Rotz = [cosd(theta) sind(theta) 0; -sind(theta) cosd(theta) 0;0 0 1];

% Duplicate array for the rotations
strutVerticesRot = strutVertices;


numOfStruts = size(strutVerticesRot, 2);

% Add 3 more entries to the cell array, containing new coordinates of
% vertices rotated by 90 degrees 3 times
for n = 1:numOfStruts
    for j = 1:size(strutVerticesRot{1, n}, 2) % The number of vertices in strut
        for k = 1:3 % Perform 3 rotations
            strutVerticesRot{1+k, n}(:, j) = Rotz * strutVerticesRot{k, n}(:, j);
        end
    end
end

% Reshape cell array and count the final number of struts
strutVerticesRot = reshape(strutVerticesRot, [], 1);

end

