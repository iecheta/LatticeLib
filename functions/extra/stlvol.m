function [vol] = stlvol(f, v)

% Calculate volume enclosed by triangulated surface

% 1. Engineering, C. & Avenue, F. EFFICIENT FEATURE EXTRACTION FOR 2D/3D OBJECTS IN MESH REPRESENTATION. Virtual Real. 1�5
% http://chenlab.ece.cornell.edu/Publication/Cha/icip01_Cha.pdf
% winopen([getenv('onedrive') '\PhD\Mendeley\Engineering, Avenue'])

% Inputs:
    % f: m x 3 triangle indexing matrix
    % v: n x 3 matrix of points
    
% Outputs:
    % vol: volume enclosed by surface

v1 = v(f(:,3), 1) .* v(f(:,2), 2) .* v(f(:,1), 3);
v2 = v(f(:,2), 1) .* v(f(:,3), 2) .* v(f(:,1), 3);
v3 = v(f(:,3), 1) .* v(f(:,1), 2) .* v(f(:,2), 3);
v4 = v(f(:,1), 1) .* v(f(:,3), 2) .* v(f(:,2), 3);
v5 = v(f(:,2), 1) .* v(f(:,1), 2) .* v(f(:,3), 3);
v6 = v(f(:,1), 1) .* v(f(:,2), 2) .* v(f(:,3), 3);

vol = 1/6 * (-v1 + v2 + v3 -v4 - v5 + v6);

vol = abs(sum(vol));
