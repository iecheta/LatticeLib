function [strutNew, segments, strutOriginal] = ...
    strutdefine(x1, x2, numberOfSegments, varargin)

% Creates medial axis for the SDF function. The medial axis can be divided
% into smaller segments, and the vertices can be displaced in 2 orthogonal
% directions

% Inputs:
    % x1: row vector of coordinates of the line segment's starting point [x y z]
    % x2: row vector of coordinates of the line segment's end point [x y z]
    % numberOfSegments: number of segments that(x2-x1) is divided into
    %
    % ADDITIONAL INPUTS:
    % varargin{1} = pdf_type: "normal"/"function" - normal distribution/pdf function from
    % matlab
    % varargin{2}, if pdf_type = 'normal' then this input is the standard
    % deviations in first and second directions
    % varargin{2}, if pdf_type = "function", then this input is the PDF object.
    
% Outputs:
    % strutNew:      coordinates of the line segments, with displacements
    %                applied (if any)
    % segments:      line segment indexing matrix (n x 2)
    % strutOriginal: coordinates of the line segments before displacement
    
% Notes:
%     Displacements are NOT applied to the first and last vertices, x1 and x2
%     respectively


% Create the coordinates of the line segments
strutOriginal = segmentscreate(x1, x2, numberOfSegments);
num_of_verts = size(strutOriginal, 1);
if nargin == 3
    shiftOne = zeros([num_of_verts-2, 1]);
    shiftTwo = shiftOne;
elseif nargin > 3
    pdf_type = varargin{1};
    if pdf_type == "normal"
        % Create normally distributed displacement values
        shiftOne = normrnd(0, varargin{2}, [num_of_verts-2, 1]);
        shiftTwo = normrnd(0, varargin{2}, [num_of_verts-2, 1]);
    elseif pdf_type == "function"
        pdf_func = varargin{2};
        random_angles = rand([num_of_verts-2, 1])*2*pi;
        % Magnitude of the vector which applies the offset
        norms = pdf_func.random(num_of_verts-2, 1);
        % Find cos and sin components, such that the magnitude of shiftOne
        % + shiftTwo = norms
        shiftOne = cos(random_angles).*norms;
        shiftTwo = sin(random_angles).*norms;
    end
else
    error('incorrect inputs')
end

% Calculate the two normal vectors for applying the displacements
[normalOne, ~] = normalVector(strutOriginal([1, end], :));
normalTwo = cross(x2 - x1, normalOne);
normalTwo = normalTwo/norm(normalTwo);

% Apply displacements in the 2 orthogonal directions
strutNew = strutOriginal;
strutNew(2:end-1,:) = strutOriginal(2:end-1,:) + shiftOne*normalOne;
strutNew(2:end-1,:) = strutNew(2:end-1,:) + shiftTwo*normalTwo;

% Create segment indexing array
segments = 1:size(strutOriginal, 1) -1;
segments = vertcat(segments, segments +1)';
end