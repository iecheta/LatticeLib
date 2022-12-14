function [u_crop] = cropvolume(u, z_max, z_min, z)

% Crop volumes using a plane parallel to x-y plane

% Inputs:
    % u:            the volume to crop
    % crop_height:  z-value for trimming plane
    % z:            the z coordinates of the volume you're cropping (i.e.
    %               the [~,~,z] output of the meshgrid.m function
    
% Outputs:
    % u_crop:       The cropped volume. Note that size(u_crop) = size(u)

    
%%
h = abs(z_max-z);
[~, index1] = min(h, [], 3);
index1 = index1(1);

h2 = abs(z_min-z);
[~, index2] = min(h2, [], 3);
index2 = index2(1);

% Crop a flat area in z-direction
crop = inf(size(u));  
crop(:, :, [1:index2, index1:size(u, 3)]) = 0;

u_crop = min(-u, crop);

end