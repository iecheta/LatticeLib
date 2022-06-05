function [vol] = tetvolume(verts)

% Calculate volume of a tetrahedron
% https://mathworld.wolfram.com/Tetrahedron.html

% Input
    % verts: 4 x 3 x n matrix of tetrahedron coordinates. n = number of
    %        tetrahedra
    
% Output
    % vol:   n x 1 vector of volumes

% Calculate edge vectors. Page by page, if necessary
a = verts(1,:,:) - verts(2,:,:);
b = verts(1,:,:) - verts(3,:,:);
c = verts(1,:,:) - verts(4,:,:);

% Reshape edge vectors for volume calculation (if there are multiple pages)
a = permute(a, [3 2 1]);
b = permute(b, [3 2 1]);
c = permute(c, [3 2 1]);

% row-wise volume calculation
vol = abs(1/factorial(3)*dot(a,cross(b,c), 2));

end