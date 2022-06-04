%% Apply roughness to surface of lattice structure
clear
filesave = false;
%% Load example data
s = load("bccz_ideal.mat", "data_crop_cell");
select_geometry = s.data_crop_cell;

%% Define parameters
amplitude = 0.1;
crop = 'on';
updownskin = 'downskin';

%% Apply roughness
[data.normals, data.strutAngle, data.surfaceAngle, data.t, data.normalRef] = surfaceanalysis(...
    select_geometry.v, select_geometry.strutVertices, select_geometry.strutID);

[surfaceVerticesRough, rough] = roughnessapply(...
    select_geometry.v, data.normals, data.surfaceAngle, data.strutAngle, data.t, crop,...
    amplitude, updownskin);

%% Save data
if filesave == false
    return
end

filename = 'roughsurface.mat';
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data file not saved.'])
else
    disp(['"' filename '" saved to current directory.'])
    save(filename)
end

