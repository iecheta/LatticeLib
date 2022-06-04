function [rough, varargout] = roughnesssurface(overhang_angle, t, theta, amplitude, updownskin)

% Calculate the displacement to be applied to a specific point on a lattice strut surface

% Inputs
%   strutAngle:     overhang angle
%   t:              intersection ratio
%   theta:          surface angle
%   amplitude:      amplitude of displacement function
%   updownskin:     select upskin or downskin roughness
%                   "upskin"/"downskin"
%
% Outputs
%   rough: Structure array:
%        rough.freqX = frequency of x component of sine function
%        rough.freqY = frequency of y component of sine function
%        rough.centre = centre of Gaussian
%        rough.sigmaY = spread of Gaussian
%        rough.amplitude = amplitude of displacement function
%   varargout{1}: the calculated displacement
%% Roughness parameters

tNew = t*2*pi;
thetaNew = ((theta/180)*pi);

freqX = 8/2*2;     % sine wave frequency in x. frequency along strut length
freqY = 8;         % sine wave frequency in y
sigmaY = pi/5;     % spread of gaussian function

if updownskin == "downskin"
    centre = pi;    % centre of Gaussian DOWNSKIN
elseif updownskin == "upskin"
    centre = 0;     % centre of Gaussian UPSKIN
else
    error('incorrect input "updownskin"')
end

rough.freqX = freqX;
rough.freqY = freqY;
rough.centre = centre;
rough.sigmaY = sigmaY;
rough.amplitude = amplitude;

if nargout == 1
    return
end

%% Calculate distance

sineComponent1 = sin(freqX * tNew);
sineComponent2 = sin(freqY * thetaNew);
sinPart = amplitude * (sineComponent1 * sineComponent2) * -1; % Flip the values
gaussPart = 1*exp(-((thetaNew-centre)^2/(2*sigmaY^2)));
dist = (sinPart*gaussPart);

if overhang_angle < 35
    dist = 0;
end

varargout{1} = dist;
end