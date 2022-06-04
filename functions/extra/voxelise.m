function [voxels, voxelOutside, voxelInside, voxelBoundary] = voxelise(d, isovalue)

% Extract individual voxels from a 3D array

% Inputs:
%   d:  3D array to be voxelised
%   isovalue: value used to locate isosurface
%
% Outputs:
%   voxels: n x 8 matrix. Each row contains the 8 values of each voxel. n
%           voxels in total
%   voxelOutside:    column vector which indexes the rows in 'voxels' whose
%                    values are all > isovalue
%   voxelInside:     column vector which indexes the rows in 'voxels' whose
%                    values are all < isovalue
%   voxelBoundary:   column vector which indexes the rows in 'voxels' whose
%                    values are all = isovalue
%
% Note:
%   - d must have negative values on the inside of the geometry,
%     otherwise outputs voxelInside/voxelOutside will be the wrong way
%     round
%   - Each row in 'voxels' can be reshaped into an individual voxel using
%     the following command: reshape(voxels(n, :), [2 2 2])

voxels_total = (size(d,1)-1)*(size(d,2)-1)*(size(d,3)-1);

voxels = zeros(voxels_total,8);

p = 1;

for k = 1:size(d,3)-1
        for j = 1:size(d,2)-1
            for i = 1:size(d,1)-1
                voxels(p,1) = d(i,j,k);
                voxels(p,2) = d(i,j+1,k);
                voxels(p,3) = d(i+1,j,k);
                voxels(p,4) = d(i+1,j+1,k);
                
                voxels(p,5) = d(i,j,k+1);
                voxels(p,6) = d(i,j+1,k+1);
                voxels(p,7) = d(i+1,j,k+1);
                voxels(p,8) = d(i+1,j+1,k+1);
                
                p = p+1;     
            end
        end
end

voxelsLogical = voxels<isovalue;
voxelSort = sum(voxelsLogical,2);

voxelOutside = find(voxelSort == 0);
voxelBoundary = find(voxelSort < 8 & voxelSort > 0);
voxelInside = find(voxelSort == 8);

end