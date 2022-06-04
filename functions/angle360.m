function ang = angle360(x1, x2)

% Calculate angle between 2 vectors, with angular range 0-360 degrees
%
% Inputs
%   x1 and x2 are column vectors storing the x,y,z coordinates of the vectors i.e. [x y z]'
%

%% x1 rotations
z_rot1 = atan2d(x1(2), x1(1));
x1 = rotatepoints(x1, z_rot1, 'z');

y_rot1 = atan2d(x1(3), x1(1));
y_rot1 = -y_rot1;
x1 = rotatepoints(x1, y_rot1, 'y');

%% x2 rotations

x2 = rotatepoints(x2, z_rot1, 'z');
x2 = rotatepoints(x2, y_rot1, 'y');

if x2(2) == 0
    x2 = rotatepoints(x2, 90, 'x');
end

x2_y_check = x2(2);

x_rot = atan2d(x2(3), x2(2));
x2 = rotatepoints(x2, x_rot, 'x'); % y-z plane

ang = atan2d(x2(2), x2(1));

if x2_y_check < 0
    ang = 360-ang;
end


end