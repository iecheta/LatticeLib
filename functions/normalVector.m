function [normalRef, strutAngle] = normalVector(verts)

% Calculates normal vector in +z direction. 

% Inputs:
    % verts:        2 x 3 matrix of the line segment's start and end point
    
% Outputs:
    % normalRef:    1 x 3 vector normal to the line segment (and facing as
    %               far as possible from xy plane)
    % strutAngle:   the line segment's angle to the z axis


if verts(1, 3) < verts(2, 3)
    verts = flip(verts, 1);
end

checkSegment = verts(1, :)-verts(2, :);

if checkSegment(1) == 0 && checkSegment(2) == 0
    normalRef = [0 1 0];
    strutAngle = 0;
    
elseif checkSegment(3) == 0
    normalRef = [0 0 1];
    strutAngle = 90;
else
    thirdPoint = [verts(1, 1) verts(1, 2) verts(2, 3)];
    triangleRef = cat(1, verts, thirdPoint);
    
    hypSide = norm(triangleRef(1, :) - triangleRef(2, :));
    shortSide = norm(triangleRef(1, :) - triangleRef(3, :));
    longerSide = norm(triangleRef(3, :) - triangleRef(2, :));
    
    thetaAng = asind(longerSide/hypSide);
    alphaAng = 90 - thetaAng;
    
    addX = shortSide * tand(alphaAng); %%%% TAN
    addDirection = triangleRef(3, :) - triangleRef(2, :);
    addDirection = addDirection/norm(addDirection);
    addPoint = triangleRef(3, :) + addDirection * addX;
    
    normalRef = triangleRef(1, :) - addPoint;
    normalRef = normalRef / norm(normalRef);
    strutAngle = thetaAng;
end
end