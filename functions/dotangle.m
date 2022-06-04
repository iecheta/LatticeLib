function [theta] = dotangle(v1, v2)

% Calculate angle (in degrees) between two vectors

    theta = acosd(single(dot(v1, v2) / (norm(v1) * norm(v2))));

end