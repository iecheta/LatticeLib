function [d] = sdfsphere(x, y, z, coords, radius)

% Signed distance function for individual points. Produces spheres

% Inputs:
    % x, y, z:          3D coordinates of the domain. Use MATLAB meshgrid.m
    %                   function.
    % coords:           n x 3 matrix of node coordinates
    % radius:           node radius

% Outputs:
    % d: 3D scalar field of signed distances

d = zeros(size(z));

for i = 1:numel(z)
    x0 = [x(i),y(i),z(i)];
    d(i) = min(vecnorm(coords-x0, 2, 2)) - radius;
end
end