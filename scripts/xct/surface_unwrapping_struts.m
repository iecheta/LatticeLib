%% Unwrap surface of strut point cloud

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
% The example strut point cloud data is stored in
% \LatticeLib\exampledata\xct\stl import

[filename, filepath] = uigetfile('*','Select a file','MultiSelect', 'on');
if ~iscell(filename)
   filename = {filename}; 
end

check = input('inclined set? y/n: ', 's');
if check == 'y'
    inclined = true;
    setname = 'inclined';
    data_count = length(filename)*2;
else
    inclined = false;
    setname = 'vertical';
    data_count = length(filename);
end

surface_unwrap = cell(1, data_count);

%% Unwrap surfaces
if inclined
    for i = 1:data_count/2
        load(filename{i})
        t_filter = t<0.5;
        surface_unwrap{i*2-1}.t = t(t_filter);
        surface_unwrap{i*2}.t = t(~t_filter);
        surface_unwrap{i*2-1}.dists = dists(t_filter);
        surface_unwrap{i*2}.dists = dists(~t_filter);
        surface_unwrap{i*2-1}.surface_angle = skin_angle360(t_filter);
        surface_unwrap{i*2}.surface_angle = skin_angle360(~t_filter);

    end
else
    for i = 1:data_count
        load(filename{i})
        surface_unwrap{i}.t = t;
        surface_unwrap{i}.dists = dists;
        surface_unwrap{i}.surface_angle = skin_angle360;    
    end
end

%% Save data

if filesave == false
    return
end

filename = ['surf_unwrap_' setname '_data.mat'];
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data file not saved.'])
else
    disp(['"' filename '" saved to current directory.'])
    clear filepath filesave
    save(filename)
end

