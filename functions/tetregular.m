function [tetCoords] = tetregular(C, r)

% Create regular tetrahedron
% https://mathworld.wolfram.com/RegularTetrahedron.html

% Inputs:
    % C: Circumcentre (1 x 3)
    % r: radius (float).
    % C and r can have n-rows.
    
% Output
    % tetCoords: 4 x 3 matrix of coordinates for regular tetrahedron. If C
    %            and r have n-rows, tetCoords will have a corresponding
    %            n-pages

    
% If there's more than one circumcentre and radius, each should be on a
% new page. All the following calculations are performed page-wise, where
% the number of pages = the num of circumcentres and radii
C = permute(C, [3, 2, 1]);
r = permute(r, [3, 2, 1]);


% Calculate the lengths in regular tetrahedron, for each value of r
tetA = (4*r)/sqrt(6);
tetX = (1/3) * sqrt(3) * tetA;
tetD = (1/6) * sqrt(3) * tetA;
tetH = (1/3) * sqrt(6) * tetA;

% Construct the matrix for each regular tetrahedron
tetCoords = zeros(4, 3, size(C, 3));
tetCoords(1, 1, :) = tetX;
tetCoords(2, 1, :) = -tetD;
tetCoords(2, 2, :) = -tetA/2;
tetCoords(3, 1, :) = -tetD;
tetCoords(3, 2, :) = tetA/2;
tetCoords(4, 3, :) = tetH;

% The regular tetrahedron has been built around the origin. regC is the
% current location of the circumcentre. We need to find the centreVector
% between regC and C, in order to shift all the tetCoords to the correct
% place
regC = zeros(1, 3, size(C, 3));
regC(1, 3, :) = tetH - r;
centreVector = C-regC;
tetCoords = tetCoords + centreVector;

end