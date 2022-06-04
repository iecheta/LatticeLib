function [v_rotate, segments_rotate] = pcloudrotatexy(v, segments)

% Rotate the pointcloud of inclined struts and make it
% perpendicular to xy plane

% Inputs:
%    v: 3 x n point cloud of strut
%    segments: 3 x 2 strut medial axis
% Outputs:
%    v_rotate: 3 x n point cloud of struts, perpendicular to xy plane
%    segments_rotate: 3 x 2 medial axis, perpendicular to xy plane

% Find midpoint of medial axis
s1 = segments(:, 1)+(segments(:, 2) - segments(:, 1))/2;
segments_shift = segments-s1;

[~, ii] = find(segments_shift(3, :)==max(segments_shift(3, :)));
x1 = segments_shift(1, ii);
y1 = segments_shift(2, ii);
z_rot = atan2d(y1, x1);

segments_rotate1 = rotatepoints(segments_shift, z_rot, 'z');

[~, jj] = find(segments_rotate1(3, :)==max(segments_rotate1(3, :)));
x2 = segments_rotate1(1, jj(1));
z2 = segments_rotate1(3, jj(1));
y_rot = atan2d(x2, z2);

%% Apply transformations
v_shift = v-s1;
v_rotate1 = rotatepoints(v_shift, z_rot, 'z');
v_rotate = rotatepoints(v_rotate1, y_rot, 'y');
segments_rotate = rotatepoints(segments_rotate1, y_rot, 'y');
end