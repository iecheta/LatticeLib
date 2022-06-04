function [surf_nodes, nodes_flat] = extractflatpoints(node, face, amp, div, surface_location)

% abaqusfilegen dependency

faceID = unique(face(:));

% Extract surface nodes
surf_nodes = node(faceID, :);

if amp == 0
    search_window = 0.1;
else
    search_window = amp * 2;
end

search_increment = search_window/div;

if surface_location == "top"
    minZ = max(surf_nodes(:, 3)) - search_window;
    nodes_extract = surf_nodes(surf_nodes(:, 3) > minZ, :); 
elseif surface_location == "bottom"
    % Lowest point
    minZ = min(surf_nodes(:, 3));  
    % Extract nodes within search window
    nodes_extract = surf_nodes(surf_nodes(:, 3) < minZ + search_window, :);
else
    error('incorrect input: "surface_location"')
end


% Initialise
nodes_flat = [0 0 0];

for i = 1:div
    
    window_bottom = minZ + search_increment * (i-1);
    window_top = minZ + search_increment * i;

    % Extract coordinates of the nodes in the current window
    nodes_in_window = nodes_extract(nodes_extract(:, 3) <= window_top ...
        & nodes_extract(:, 3) > window_bottom, :);
    
    % Only keep the node data from the window which had the most nodes in
    if size(nodes_in_window, 1) > size(nodes_flat, 1)
        nodes_flat = nodes_in_window;
    end
    
end


end