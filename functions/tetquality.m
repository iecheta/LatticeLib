function [meshQualRatio] = tetquality(vertsTet, facesElem, varargin)

% Calculate tetrahedral element quality. Compare tetrahedron volume to volume of regular tetrahedron

% Inputs:
    % vertsTet: n x 3 matrix of mesh coordinates
    % facesElem: m x 4 tetrahedra indexing matrix
    % ADDITIONAL INPUTS
    % varargin{1}: surfaceID. A binary vector ID'ing the surface tets (length = n)
    % varargin{2}: queryNum. Select one tetrahedra for quality calculation
    %           (integer between 1 and m)
    
% Outputs:
    % meshQualRatio: vector of mesh quality values. If queryNum is used,
    %                output is a single value
    % Note:          if nargin == 3 (i.e. the whole mesh is analysed),
    %                histograms of mesh quality are plotted. If nargin == 4
    %                (i.e. only one tet is analysed) an image of the tet is
    %                created
               
if nargin == 2

    % Create matrix for each tet on new page
    [tetMeshCoords, ~, C, r] = tetextract(vertsTet, facesElem);
    
    % Calculate corresponding regular tets
    [tetRegular] = tetregular(C, r);
    
    % Calculate volume in each tet and corresponding regular tet
    volTet = tetvolume(tetMeshCoords);
    volReg = tetvolume(tetRegular);
    
    % Calculate mesh quality
    meshQualRatio = volTet./volReg;

end

if nargin == 4
    
    surfaceID = varargin{1};
    queryNum = varargin{2};

    % Extract selected tetrahedron
    [tetCurrent, ~, Circum, r] = tetextract(vertsTet, facesElem, queryNum);

    % Coordinates and circumcentre of regular tetrahedron
    [tetRegular] = tetregular(Circum, r);

    % Calculate volumes and calculate quality ratio
    meshQualRatio = tetvolume(tetCurrent)/tetvolume(tetRegular);
  
    % View selected tetrahedron
    figure;
    tetview(vertsTet, facesElem, queryNum)
    
    if surfaceID(queryNum) == 1
        title(['Surface tetrahedron: ', num2str(meshQualRatio)])
    else
        title(['Body tetrahedron: ', num2str(meshQualRatio)])
    end
end

end