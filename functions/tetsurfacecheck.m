function [surfaceID, surfaceIDCount] = tetsurfacecheck(facesSurf, facesElem)

% Identify surface tetrahedra

% Inputs:
    % facesSurf: n x 3 surface triangle indexing matrix
    % facesElem: n x 4 tetrahedra indexing matrix
    
% Outputs:
    % surfaceID: identifying binary vector of length = n.
    % surfaceIDCount: vector of length = n. shows the number of vertices
    %                 in each tet which were found to be on the surface

% Check which indices from facesSurf are found in facesElem
surfCheck = ismember(facesElem, facesSurf);

% Logical output. 1/0 = this index is/isn't on the surface. Sum the results
% for each row of tetrahedra
surfaceIDCount = sum(surfCheck, 2);

% The sum for a tetrahedra on the surface will = at least 3 
surfaceID = surfaceIDCount>=3;
end