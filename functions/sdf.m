function [d] = sdf(x, y, z, vertices, segments, radii, varargin)

% Signed distance function (SDF). Calculates the distance between all points in
% the domain and the line segments.

% http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
% https://blogs.mathworks.com/graphics/2016/03/07/signed-distance-fields/

% Inputs:
    % x, y, z:          3D coordinates of the domain. Use MATLAB meshgrid.m
    %                   function.
    % vertices:         3D coordinates of the line segments (n x 3)
    % segments:         line segments indexing array
    % radius:           strut radius
    % 'sparse'/'full':  calculate distance only near the boundary
    %                   ('sparse') OR for all points in cartesian grid
    %                   ('full')

% Outputs:
    % d: 3D scalar field of signed distances


if nargin == 6
    calculation_type = 'sparse';
end
    
if length(radii) == 1
    radii = repmat(radii, [size(vertices, 1), 1]);
    radius_variation = false;
elseif length(radii) == size(vertices, 1)
    radius_variation = true;
    % Create function to describe the relationship between t and radius
    numOfSegments = size(segments, 1);
    maxT = size(segments, 1);
    tValues = 0:0.0001:maxT;
    radiusInterp = interpn(0:numOfSegments, radii, tValues, 'linear');
else
    error('check radius value input')
end
    
% Initialising
d = inf(size(z));     
numOfVerts = size(vertices, 1);

lastnum = 0;
% Iterate through all the points in the domain
for i=1:numel(z)
    check = floor(100*i/numel(z));
    if ismember(check, 20:20:100) && check ~= lastnum
        disp([num2str(check) '%'])
        lastnum = check;
    end
    
    x0 = [x(i), y(i), z(i)]; % check each xyz coordinate
    
    % From the vertices in the line segments, find the vertex closest to x0
    allDists = vecnorm(vertices-x0, 2, 2);
    [~, closestVert] = min(allDists);
       
    % Extract all possible line segments defined using closestVert. A max
    % of 2 line segments
    if closestVert == 1
        closestSegments = [closestVert closestVert+1];
    elseif closestVert == numOfVerts
        closestSegments = [closestVert-1 closestVert];
    else
        closestSegments = [closestVert-1 closestVert; closestVert closestVert+1];
    end
    % Columm vector of distances to all line segments. Reused for every point x0
    dist = zeros(size(closestSegments, 1), 1);   
    % Column vector of intersection ratios (t) for all line segments. Reused
    % for every point x0
    t = zeros(size(closestSegments, 1), 1);
    
% For all closest line segments, find the closest point t to x0
    for j=1:size(closestSegments, 1)
        x1 = vertices(closestSegments(j, 1), :);
        x2 = vertices(closestSegments(j, 2), :);
        
        t(j) = -dot(x1 - x0, x2 - x1)*...
            1/dot(x2 - x1, x2 - x1);
        t(j) = max(0, min(1, t(j))); % 0 < t < 1 in order to remain on the line segment
        v = x1 + t(j)*(x2 - x1); % coordinates of the closest point on the line segment
        % Distance between x0 and line segment
        dist(j) = norm(v - x0);
    end 
    
    % Find the distance to the closest line segment and its index
    [minDist, minDistIndex] = min(dist);
    
    if radius_variation == false   % If there's no radius variation
        d(i) = min(dist) - radii(1);
    else
        % If the calculation type is 'full' OR we're near the boundary
        if calculation_type == "full" || abs(minDist-max(radii))/max(radii) < 1
            % E.g. to find the radii value half way between the 2nd line
            % segment, t should not = 0.5, but t = 2.5. Thus tQuery = t +
            % segment_number.
            tQuery = t(minDistIndex) + closestSegments(minDistIndex, 1)-1;
            tQuery = round(tQuery, 4);
            [~, interpIndex] = min(abs(tValues-tQuery));
            radii = radiusInterp(interpIndex);
            % Shift values for zero level set calculation
            d(i) = minDist - radii;

        elseif calculation_type == "sparse"
            continue
        else
            error("incorrect calculation type. must be 'sparse' or 'full'")
        end
    end
               
end
end





