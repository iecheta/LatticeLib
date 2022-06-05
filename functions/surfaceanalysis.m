function [surfaceNormals, strutAngle, skinAngle, t, normalRef, varargout] = ...
    surfaceanalysis(surfaceVertices, strutVertices, strutID)

% Extract surface parameteres from lattice structure surface
%
% Inputs
%   surfaceVertices: n x 3 matrix of surface points
%   strutVertices:   3 x m matrix of strut start/end points
%   strutID:         m-element vector used to ID the struts in
%                    strutVertices. This is the second output value of the
%                    function segmentsdefine.m
% Outputs
%   surfaceNormals: n x 3 matrix of surface normals
%   strutAngle:     n x 1 vector of overhang angle (in degrees) of the
%                   strut that each point on the surface is associated to
%   skinAngle:      n x 1 vector of upskin/downskin angle (in degrees)
%                   between surface normal and reference vector
%                   (normalRef). Angular range of 0-180 degrees
%   t:              n x 1 vector of intersection ratios of all points
%                   (these values are modified where necessary so that t is
%                   never < 0 or > 1)
%   normalRef:      reference vector used for calculating upskin/downskin
%                   angle
% ADDITIONAL OUTPUTS
%   varargout{1}:   n x 1 vector of distances between surface points and 
%                   closest strut;
%   varargout{2}:   n x 1 vector of integers used to indicate which strut
%                   is closest to the n-th point. The numbering convention
%                   is arbitrary;
%   varargout{3}:   n x 1 vector of unpskin/downskin angles, but with
%                   angular range between 0-360 degrees.


% Initialise arrays
surfaceNormals = zeros(size(surfaceVertices));
% surfaceNormalsReorient = zeros(size(surfaceVertices));

numOfPoints = size(surfaceVertices, 1);

strutAngle = zeros(numOfPoints, 1);
skinAngle = zeros(numOfPoints, 1);
normalRef = zeros(numOfPoints, 3);
t = zeros(numOfPoints, 1);
skin_angle360 = zeros(numOfPoints, 1);
dist = zeros(numOfPoints, 1);
strutNum = zeros(numOfPoints, 1);

% Find the top and bottom z values
top_surf = max(surfaceVertices(:, 3));
bottom_surf = min(surfaceVertices(:, 3));

% For each point on the surface, find the surface normal, the closest line
% segment, and the orientation of the line segment
for n = 1:size(surfaceVertices, 1)
    
    % For point n, calculate the distance to all the line segment vertices
    surfPointDist = repmat(surfaceVertices(n, :), size(strutVertices, 2), 1);
    surfPointDist = vecnorm(surfPointDist - strutVertices', 2, 2);
    
    % Locate the indices of the closest vertex
    [closestVertexIndex, ~] = find(surfPointDist == min(surfPointDist));
    
    % Create matrix to index all the possible line segments
    segmentsIndex = zeros(length(closestVertexIndex)*2, 2);
    
    for j = 1:length(closestVertexIndex)
        
        segmentsIndex(j*2-1, :) = [closestVertexIndex(j)-1, closestVertexIndex(j)];
        segmentsIndex(j*2, :) = [closestVertexIndex(j), closestVertexIndex(j)+1];
        
    end
    
    % Remove segments that come before and after the first and last vertex
    % in strutVertices
    segmentsIndex((segmentsIndex(:, 1) == 0), :) = [];
    segmentsIndex((segmentsIndex(:, 1) == size(strutVertices, 2)), :) = [];
    
    % All real struts will have two identical neighbouring values in
    % strutID. 
        
    % Check strutID to remove
    segmentsCheck = sum(strutID(segmentsIndex), 2);
    segmentsIndex = segmentsIndex(segmentsCheck == 0 | segmentsCheck == 2, :);
    
    % Reshape into row vector
    segmentsIndex = reshape(segmentsIndex', 1, []);
    
    % Extract the segments of interest
    segments = strutVertices(:, segmentsIndex);
    
    % Prepare to calculate distances and normals to the line segments
    distanceToSegments = zeros(1, size(segments, 2) / 2);
    segmentsSurfaceNormal = zeros(length(distanceToSegments), 3);
    tSegments = zeros(length(distanceToSegments), 1);
    segments = segments';
    
    % Calculate distance and normals to line segments
    for i = 1:length(distanceToSegments)
        [distanceToSegments(i), segmentsSurfaceNormal(i, :), ~, tSegments(i)] = intersectionratio(...
            surfaceVertices(n, :), segments(i*2-1, :), segments(i*2, :));
%             surfaceVertices(n, :), segments(i*2-1, :), segments(i*2, :), tfull);
    end
    
    % Only store the index of the closest line segment and its
    % corresponding normal vector
    [~, closestLineSegIndex] = min(distanceToSegments);
    
    % Extract the coordinates of the closest line segment
    segmentClosest = [segments(closestLineSegIndex*2-1, :) ; segments(closestLineSegIndex*2, :)];
    t(n) = tSegments(closestLineSegIndex);
    dist(n) = min(distanceToSegments);
    
    if surfaceVertices(n, 3) == top_surf
        surfaceNormals(n, :) = [0 0 1];
    elseif surfaceVertices(n, 3) == bottom_surf
        surfaceNormals(n, :) = [0 0 -1];
    else
        surfaceNormals(n, :) = segmentsSurfaceNormal(closestLineSegIndex, :);
    end
        
    % Calculate the angle between the normal reference vector and the
    % surface normal
    [normalRef(n, :), strutAngle(n)] = normalVector(segmentClosest);
    
    % Calculate up/down skin angle
    [skinAngle(n)] = dotangle(surfaceNormals(n, :), normalRef(n, :));
    skin_angle360(n) = angle360(normalRef(n, :)', surfaceNormals(n, :)');
    
    strutNum(n) = segmentsIndex(closestLineSegIndex*2)/2;
end

varargout{1} = dist;
varargout{2} = strutNum;
varargout{3} = skin_angle360;
end

