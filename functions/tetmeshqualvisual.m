function tetmeshqualvisual(tetCentroid, meshQualRatio, surfaceID, varargin)

% Colour coded scatter plot of mesh quality

% Inputs:
    % tetCentroid: 1 x 3 x n matrix of centriods
    % meshQualRatio: n x 1 vector of mesh quality ratios
    % surfaceID: n x 1 binary vector used for identifying surface tetrahedra
    % ADDITIONAL INPUTS
    % varargin{1}: "all", "surface", "body". Choose the set of elements that will be plotted
    
% Outputs:
    %     Individual plots or subplots of colour coded scatter plots for
    %     entire mesh, surface tets, and body tets

dot_size = 2;
if size(tetCentroid, 3) > 1
    tetCentroid = permute(tetCentroid, [3 2 1]);
end
    

faceCol = [1 0 0] + [-1 1 0].*meshQualRatio;

if nargin == 3
    
    subplot(4, 4, [1, 2, 5, 6, 9, 10, 13, 14])
    scatter3(tetCentroid(:, 1, :), tetCentroid(:, 2, :),...
        tetCentroid(:, 3, :), dot_size, faceCol, 'filled')
    title('Mesh Quality (all)')
    grid on
    axis equal
    view(3)

    subplot(4, 4, [3, 4, 7, 8])
    scatter3(tetCentroid(surfaceID, 1), tetCentroid(surfaceID, 2),...
        tetCentroid(surfaceID, 3), dot_size, faceCol(surfaceID, :), 'filled')
    title('Mesh Quality (surface)')
    grid on
    axis equal
    view(3)

    subplot(4, 4, [11, 12, 15, 16])
    scatter3(tetCentroid(~surfaceID, 1), tetCentroid(~surfaceID, 2),...
            tetCentroid(~surfaceID, 3), dot_size, faceCol(~surfaceID, :), 'filled')
    title('Mesh Quality (body)')
    grid on
    axis equal
    view(3)
    
end


if nargin == 4

    if varargin{1} == "all" 
    elseif varargin{1} == "surface"
        tetCentroid = tetCentroid(surfaceID, :);
        faceCol = faceCol(surfaceID, :);
    elseif varargin{1} == "body"
        tetCentroid = tetCentroid(~surfaceID, :);
        faceCol = faceCol(~surfaceID, :);
    else
        error('incorrect input. specify all/surface/body') 
    end

    
    hold on
    scatter3(tetCentroid(:, 1), tetCentroid(:, 2), tetCentroid(:, 3),...
        dot_size, faceCol, 'filled')

    grid on
    axis equal
    view(3)

end

end



