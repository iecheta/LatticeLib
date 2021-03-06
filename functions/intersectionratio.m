% function [dist, surfaceNormal, v, t] = intersectionratio(x0, x1, x2, varargin)
function [dist, surfaceNormal, v, t] = intersectionratio(x0, x1, x2)

% Calculate intersection ratio, and additional vectors

% Inputs:
        % x0: point in 3D space
        % x1, x2: line segment coordinates
        
% Outputs:
        % dist: Euclidean distance between x0 and line segment
        % v: closest point on line segment
        % t: intersection ratio
        % surfaceNormal: normal vector from v
        
x_start = x1;
x_end = x2;
        
if x1(3) > x2(3)
    x_start = x2;
    x_end = x1;
end

t = -dot(x_start - x0, x_end - x_start)*...
        1/dot(x_end - x_start, x_end - x_start);

t = max(0, min(1, t));

v = x_start + (x_end - x_start)*t;

dist = norm(x0 - v);

surfaceNormal = (x0-v)/dist;
end