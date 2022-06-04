% Rotate line segment in z-axis. Accommodates line segments not centred
% about origin

% Inputs:
    % coords_old:       3 x 2 matrix of line segment start and end point
    % rotation_centre:  centre of rotation. 3-element column vector
    
% Outputs:
    % coords_new:   3 x 8 matrix containing the complete set of 4 line
    %               segments, centred about rotation_centre


function coords_new = cellsym(coords_old, rotation_centre)

theta = [90, 180, 270];

% Shift the original line segment so that the origin = point of rotation
coord_shift = coords_old - rotation_centre;

% Preparing to store the three rotated line segments
coords_new = zeros(3, 6);

for i = 1:numel(theta)
    rotMatrix = [cosd(theta(i)) sind(theta(i)) 0; -sind(theta(i)) cosd(theta(i)) 0; 0 0 1];
    
    % Rotate the first line semgment by theta(i)
    coords_new(:, 2*i-1) = rotMatrix * coord_shift(:, 1);
    coords_new(:, 2*i) = rotMatrix * coord_shift(:, 2);
end

% Shift all the coordinates back to their original position
coords_new = coords_new + rotation_centre;

% Add the first (unshifted) line segment
coords_new = horzcat(coords_old, coords_new);

end