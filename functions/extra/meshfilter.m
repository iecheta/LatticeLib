function [nodes_keep, nodes_remove, index_retain, index_remove] = meshfilter(node, elem)

% Remove erroneous points from iso2mesh mesh. The mesh's element array
% does not index the erroneous points and therefore we can use the absence
% of these indices to identify the points we wish to remove

% Inputs:
    % node:         n x 3 matrix of mesh coordinates
    % elem:         m x 4 tetrahedra indexing matrix
    
% Outputs:
    % nodes_keep:   coordinates of the mesh without erroneous points
    % nodes_remove: coordinates of the erroneous points
    % index_retain: indices of the coordinates you're keeping in the
    %               original mesh
    % index_remove: indices of the coordinates you're removing from the
    %               original mesh


% Extract unique indices for the elements
elem_list = cat(1,elem(:,1),elem(:,2),elem(:,3),elem(:,4));
elem_list = unique(elem_list);

% Isolate the nodes that are actually indexed by the element array i.e. the
% nodes you want to keep
nodes_index = node(:,1:3);
nodes_index(elem_list,:) = 0;
nodes_index = logical(nodes_index==0);

[index_retain,~]=find(nodes_index(:,1)==1); % Find the indices of the points I want to keep
[index_remove,~]=find(nodes_index(:,1)==0); % Find the indices of the points I want to remove

nodes_keep = node(index_retain,:);
nodes_remove = node(index_remove,:);

end