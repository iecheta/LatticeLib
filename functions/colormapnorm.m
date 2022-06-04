function [new_colors] = colormapnorm(colormap_pick, values_normalised, varargin)
% Generate new colormap based on normalised values

if nargin == 3
    if varargin{1} == "flip"
        colormap_pick = flip(colormap_pick, 1);
    end
end

colormaps_gaps = size(colormap_pick, 1)-1;

colormap_pick = [colormap_pick; colormap_pick(end, :)];

values_normalised_ind = values_normalised*colormaps_gaps;

values_colormap_ind = floor(values_normalised_ind)+1;
color_add = values_normalised_ind-floor(values_normalised_ind);

new_colors = colormap_pick(values_colormap_ind, :) + ...
    color_add .* (colormap_pick(values_colormap_ind+1, :)-colormap_pick(values_colormap_ind, :));

end
