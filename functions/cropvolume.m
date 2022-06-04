function [u_crop] = cropvolume(u, crop_height_top, crop_height_bottom, z)

% Crop volumes using a plane parallel to x-y plane

% Inputs:
    % u:            the volume to crop
    % crop_height:  z-value for trimming plane
    % z:            the z coordinates of the volume you're cropping (i.e.
    %               the [~,~,z] output of the meshgrid.m function
    
% Outputs:
    % u_crop:       The cropped volume. Note that size(u_crop) = size(u)

    
%%
h = abs(crop_height_top-z);
[~, Z1] = min(h, [], 3);
Z1 = Z1(1);

h2 = abs(crop_height_bottom-z);
[~, Z2] = min(h2, [], 3);
Z2 = Z2(1);

% Crop a flat area in z-direction
crop = inf(size(u));  
crop(:, :, [1:Z2, Z1:size(u, 3)]) = 0;

u_crop = min(-u, crop);

end