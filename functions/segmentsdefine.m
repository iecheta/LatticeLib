function [allVertices, strutID] = segmentsdefine(allSegmentsVertices)

% Extracts line segments from cell array and creates identifying binary vector

% Inputs:
    % allSegmentsVertices: 1 dimensional CELL ARRAY. Each element must 
    %                      contain a 3 x n matrix, defining the vertices 
    %                      of that segment

% Outputs:
    % allVertices: 3 x m MATRIX, containing all the vertices of the struts
    % strutID: Line segment ID binary vector. Adjacent columns of
    %          allVertices represent a true line segment if corresponding 
    %          elements in strutID are the same (i.e. [0 0] or [1 1]

if iscell(allSegmentsVertices)
    
    finalNoOfStruts = numel(allSegmentsVertices);
    allVertices = [];
    strutID = [];

    for n = 1:finalNoOfStruts
       % Extract vertices from cell array and combine into one continuous matrix
       allVertices = cat(2, allVertices, allSegmentsVertices{n});

       if rem(n, 2) ~= 0
           a = zeros(1, size(allSegmentsVertices{n}, 2)); 
       elseif rem(n, 2) == 0
           a = ones(1, size(allSegmentsVertices{n}, 2));
       end
       strutID = cat(2, strutID, a);
    end
    
else
    allVertices = allSegmentsVertices;
    strutID = logical([1 1]);
end
      
end