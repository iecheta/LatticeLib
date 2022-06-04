function coordsNew = rotatepoints(coordsOld, theta, axis)

% Clockwise rotation (about positive axes) in 3 spatial dimensions (degrees)

% Inputs:
    % coordsOld: 3 x n matrix of coordinates
    % theta: angle of rotation (degrees)
    % axis: axis of rotation. 'x', 'y', 'z'
    
% Outputs:
    % coordsNew: 3 x n matrix of rotated coordinates

num_rows = size(coordsOld, 1);
num_columns = size(coordsOld, 2);
    
if num_rows == num_columns
    warning('square matrix. make sure xyz coordinates are given columnwise')
end

if num_rows ~= 3
    error('matrix must have 3 rows. xyz coordinates in each column')
end
    
% Select rotation matrix
switch axis
    case 'x'
        rotMatrix = [1 0 0; 0 cosd(theta) sind(theta); 0 -sind(theta) cosd(theta)];
    case 'y'
        rotMatrix = [cosd(theta) 0 -sind(theta); 0 1 0; sind(theta) 0 cosd(theta)];
    case 'z'
        rotMatrix = [cosd(theta) sind(theta) 0; -sind(theta) cosd(theta) 0; 0 0 1];
    otherwise
        error("axis must be 'x', 'y' or 'z'")
end

% Perform rotation
coordsNew = rotMatrix * coordsOld;




