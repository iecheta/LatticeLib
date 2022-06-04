function [tetMeshCoords, tetCentroid, circum, r] = tetextract(verts, elems, varargin)

% Extract single tetrahedron from mesh

% Inputs:
    % verts: n x 3 matrix of mesh coordinates
    % elems: m x 4 tetrahedra indexing matrix
    % ADDITIONAL INPUTS
    % queryNum: the selected tetrahedra (integer between 1 and m)
    
% Outputs:
    % tetCurrent:       4 x 3 x m matrix of tetrahedron coordinates 
    % tetCentroid:      1 x 3 x m matrix of centroid coordinates
    % C: circumcentre:  m x 3 matrix of circumcentre coordinates
    % r: circumradius:  m x 1 vector of circumradii
    %                   (m is the number of tetrahedra, where m = 1 if
    %                   queryNum is used)

if nargin == 2
    
    % Circumcentre and r of all tets
    TR = triangulation(elems, verts);
    [circum, r] = circumcenter(TR);
    
    % Reorder faces so that each vertex is on a new row and each tet is on
    % a new page
    elems = permute(elems, [3 2 1]);
    elems = permute(elems, [2 1 3]);
    
    % Create 4 x 3 x n matrix of the vertices of all tetrahedra. n = number
    % of tets
    tetMeshCoords = verts(elems, :);
    tetMeshCoords = tetMeshCoords';
    tetMeshCoords = reshape(tetMeshCoords, 3,4,[]);
    tetMeshCoords = permute(tetMeshCoords, [2 1 3]);

    
elseif nargin == 3
    queryNum = varargin{1};
    tetMeshCoords = verts(elems(queryNum, :), :);

    % Circumcentre and r of selected tetrahedron
    TR = triangulation(1:4, tetMeshCoords);
    [circum, r] = circumcenter(TR); % C = circumcentre, r = radius
   
else
    error('incorrect input')
end

% Centroid
centroidx = mean(tetMeshCoords(:, 1, :));
centroidy = mean(tetMeshCoords(:, 2, :));
centroidz = mean(tetMeshCoords(:, 3, :));

tetCentroid = [centroidx centroidy centroidz];
end