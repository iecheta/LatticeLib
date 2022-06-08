%% Fit circles to the cross sections of xct point cloud of a unit cell, using least squares

% This script requests user input for the following:
%   - Selection of the point cloud data of individual filtered struts,
%     either inclinded OR vertical struts. This point cloud data is produced
%     by import_point_cloud.m and example data is stored in
%     \LatticeLib\exampledata\xct\stl import
%   - Confirmation of whether or not an inclined strut dataset was selected

% If you wish to save the data file(s) produced by this script, change the
% variable 'filesave' below to 'true'. Note that the files will not be
% saved if they already exist in the current directory.

clear
filesave = false;
%% Select example point cloud data of struts
% From the point cloud data produced by import_point_cloud.m, select a set
% of filtered point clouds of lattice struts. Either a vertical set or
% inclined set.

[filename, ~] = uigetfile('*','Select a file','MultiSelect', 'on');

% Layer thickness of manufacturing process (mm)
layer_thickness = 0.04;

% Initialising
data_count = length(filename);
circle_fit = cell(1, data_count);
offset = circle_fit;
offset_mean = zeros(1, data_count);
radii_mean = offset_mean;
options = optimset('Display','off');

check = input('inclined set? y/n: ', 's');
if check == 'y'
    inclined = true;
    setname = 'inclined';
else
    inclined = false;
    setname = 'vertical';
end

%% Circle fitting
for i = 1:data_count
    load(filename{i})
    % apply transformations
    if inclined == true
        [v, ~] = pcloudrotatexy(v', segments);
        v = v';
    end
     
    slices = min(v(:, 3)):layer_thickness:max(v(:, 3));
    slices_count = length(slices)-1;
    circle_fit{i} = nan(slices_count, 3);
    for j = 1:slices_count
        current_slice = v(v(:, 3)>=slices(j) & v(:, 3)<=slices(j+1), :);
        % If the current slice has less than 10 points in it. This is
        % really a condition that deals with the gap in the middle of the
        % inclined struts. The gap is represented by NaNs
        if size(current_slice, 1) < 10
            continue
        end
        
        fun = @(x)(current_slice(:, 1)-x(1)).^2 + (current_slice(:, 2)-x(2)).^2-x(3)^2;
        circle_fit{i}(j, :) = lsqnonlin(fun,...
            [current_slice(1, 1) current_slice(1, 2) 0.5], [], [], options);
    end
end

for i = 1:data_count
    nan_check = sum(isnan(circle_fit{i}), 2);
    circle_fit{i}(nan_check>0, :) = [];
end

for i = 1:data_count
    x_offset = circle_fit{i}(:, 1)-mean(circle_fit{i}(:, 1));
    y_offset = circle_fit{i}(:, 2)-mean(circle_fit{i}(:, 2));
    offset{i} = sqrt(x_offset.^2 + y_offset.^2);
    offset_mean(i) = mean(offset{i});
    radii_mean(i) = mean(circle_fit{i}(:, 3));
end

radii_all = [];
offset_all = [];
for i = 1:data_count
    radii_all = vertcat(radii_all, circle_fit{i}(:, 3));
    offset_all = vertcat(offset_all, offset{i});
end

%% Fit PDF to offset and radii data, using kernel density estimation
offset_pdf = fitdist(offset_all, 'kernel');
radii_pdf = fitdist(radii_all, 'kernel');

%% Save data

if filesave == false
    return
end

filename = [setname 'data.mat'];
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data files not saved.'])
    return
else
    disp('Saving data files to current directory.')
end

clear filesave
save(filename)
save(['pdf_offset_' setname], 'offset_pdf')
save(['pdf_radii_' setname], 'radii_pdf')


