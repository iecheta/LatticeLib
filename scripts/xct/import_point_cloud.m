%% Import STL file of BCCZ lattice structure
% Assumes that the unit cell has one vertical strut perpendicular to xy
% plane and centred at the origin. Additionally, all faces of the bounding
% box must be parralel or perperdicular to xy plane.

% This script requests user input for the following:
%   - a prefix which will be applied to the file names of all the extracted
%     struts. If you're not saving any files, just press ENTER.
%   - selection of an STL file of a unit cell. An example can be found
%     in \LatticeLib\exampledata\xct\stl import
%   - checking that the filtering parameters are appropriate

% Outputs
%   - Filtered inclined and vertical struts of the BCCZ unit cell
%   - Unfiltered inclined and vertical struts
%   - Example data stored in \LatticeLib\exampledata\xct\stl import

clear
filesave = false;
%% Define unit cell size and initial filtering parameters
cell_size = 7; % millimetres

% Filtering parameters
cut_width_inclined = 0.12;
dist_cut_inclined = 1;

cut_width_vert = 0.2;
dist_cut_vert = 0.64;

%% Import stl file
disp('Importing STL file ...')
lattice_name = input('Enter prefix to be added to all output data files: ', 's');
[stl_file, stl_path] = uigetfile('*','Select STL file');
cd(stl_path)

TR = stlread(fullfile(stl_path, stl_file));
v = TR.Points;
f = TR.ConnectivityList;

%% Estimate medial axes positions

x1 = [0 0 0];

if max(v(:, 1)) < cell_size/2
    a = -1;
else
    a = 1;
end

if max(v(:, 2)) < cell_size/2
    b = -1;
else
    b = 1;
end

if max(v(:, 3)) < cell_size/2
    c = -1;
else
    c = 1;
end
    
x2 = [a*cell_size b*cell_size c*cell_size];

line_seg1 = [x1; x2]';
rotation_origin = [(x2-x1)/2]';
% Duplicate the strut by rotating it in z-axis, about rotation_origin
struts_inclined = cellsym(line_seg1, rotation_origin);

% Vertical strut
x4 = [0 0 c*cell_size];
line_seg2 = [x1; x4]';
struts_vertical = cellsym(line_seg2, rotation_origin);

segments = [struts_inclined, struts_vertical];
segment_count = size(segments, 2)/2;
strutID = repmat(logical([0, 0, 1, 1]), [1, segment_count/2]);

%% Segment the struts
disp('Segmenting struts ...');
[~, strutAngle, skinAngle, t, ~, dists, strutNum, skin_angle360] = surfaceanalysis(v, segments, strutID);

%% Check filtering for individual struts
figure
for i = 1:4
    subplot(2, 2, i)
    [filter1, remove1] = strutfilter(...
        i, strutNum, t, dists, cut_width_inclined, dist_cut_inclined, "inclined");
    qscatter3(v(filter1, :), 50)
    hold on
    qscatter3(v(remove1, :), 25, 'r')
    axis equal
    view([45, 5])
    title(["cut width inclined = " num2str(cut_width_inclined)...
        "dist cut inclined = " num2str(dist_cut_inclined)])
end

figure
for i = 5:8
    subplot(2, 2, i-4)
    [filter2, remove2] = strutfilter(...
        i, strutNum, t, dists, cut_width_vert, dist_cut_vert, "vertical");
    qscatter3(v(filter2, :), 50)
    hold on
    qscatter3(v(remove2, :), 25, 'r')
    axis equal
    view([0, 5])
    title(["cut width vertical = " num2str(cut_width_vert)...
        "dist cut vertical = " num2str(dist_cut_vert)])
end

uiwait(msgbox('Check plots. The points in red will be filtered out. Confirm filter values are appropriate.'))
check = NaN;
while 1
    if check == 'y'
        break
    elseif check == 'n'
        error('saving cancelled. change parameters and rerun section')
    else
        check = input('Check strut filtering. Continue? (y/n): ', 's');
    end
end

%% Save data

if filesave == false
    return
end

filename = 'importdata.mat';
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data files not saved.'])
    return
else
    disp(['Saving data files to current directory.'])
    clear stl_path
    save(filename)
end

for i = 1:8
    save_name = [lattice_name+"raw"+num2str(i)];
    filter_vector = strutNum==i;
    savestrut(v, skinAngle, skin_angle360, t, dists, filter_vector,...
        i, 'raw', segments, save_name)
end

% Inclined struts
for i = 1:4
    save_name = [lattice_name+"inclined"+num2str(i)];
    [filter_vector, ~] = strutfilter(i, strutNum, t, dists, cut_width_inclined, dist_cut_inclined, "inclined");
    savestrut(v, skinAngle, skin_angle360, t, dists, filter_vector, i, 'filter',...
              segments, save_name)
end

% vertical struts
for i = 5:8
    save_name = [lattice_name+"vertical"+num2str(i-4)];
    [filter_vector, ~] = strutfilter(i, strutNum, t, dists, cut_width_vert, dist_cut_vert, "vertical");
    savestrut(v, skinAngle, skin_angle360, t, dists, filter_vector, i, 'filter',...
              segments, save_name)    
end

disp('Done.');