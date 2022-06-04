function [surfaceVerticesRough, rough] = roughnessapply(...
    surfaceVertices, surfaceNormals, surfaceAngle, strutAngle, t, crop, amplitude, updownskin)

% Apply roughness to lattice geometry

% Inputs
    % surfaceVertices:      n x 3 coordinates of geometry
    % surfaceNormals:       n x 3 surface normals
    % surfaceAngle:         n x 1 up/down skin angles (degrees)
    % strutAngle:           n x 1 angle of the associated strut (degrees)
    % t:                    n x 1 intersection ratios
    % crop:                 'on'/'off' Use this if the geometry is cropped
    % amplitude:            amplitude of displacement function
    % updownskin:           select upskin or downskin roughness
    %                       "upskin"/"downskin"
    

% Outputs
    % surfaceVerticesRough: n x 3 coordinates of surface with roughness applied
    % rough: Structure array:
    %        rough.freqX = frequency of x component of sine function
    %        rough.freqY = frequency of y component of sine function
    %        rough.centre = centre of Gaussian
    %        rough.sigmaY = spread of Gaussian
    %        rough.amplitude = amplitude of displacement function

surfaceVerticesRough = surfaceVertices;

% Find the top and bottom z values
top_surf = max(surfaceVertices(:, 3));
bottom_surf = min(surfaceVertices(:, 3));

[rough] = roughnesssurface(max(strutAngle), 0, 0, amplitude, updownskin);

% Apply roughness
for n = 1:size(surfaceVertices, 1)
    % Don't move the points at the ends of the struts
    if t(n) == 0 || t(n) == 1
       dist = 0;
    % Don't move the points on cropped surface
    elseif surfaceVertices(n, 3) == top_surf || surfaceVertices(n, 3) == bottom_surf
        if crop == "on"
            dist = 0;
        end
    else
        [~, dist] = roughnesssurface(strutAngle(n), t(n), surfaceAngle(n), amplitude, updownskin);
    end

   % Move the point on the surface
   surfaceVerticesRough(n, :) = ...
        surfaceVertices(n, :) + (surfaceNormals(n, :) * dist);

end
end