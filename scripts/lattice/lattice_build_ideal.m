% Create a triangulated surface of the BCCZ strut-based lattice structure.
% No defects are applied here.
%
% If you wish to save the data file(s) produced by this script, change the
% variable 'filesave' below to 'true'. Note that the files will not be
% saved if they already exist in the current directory.

clear
filesave = false;
%% Define lattice geometry

% General parameters
cs = 7;             % cell size
radius = 0.5;       % strut radius
radius_node = 0.75;	% node radius
n = [2 3 4];        % tessellation. number of cells in (y,x,z).

% Strut coordinates

% Define the 'start' and 'end' points of the medial axes. Only 2 medial
% axes are defined: one inclined strut and one vertical strut. The cell's
% symmetry will be utilised to generate the remaining inclined and vertical
% struts
a = cs/2;   
incl_start = [-a -a -a];    % start/end coordinates of inclined strut
incl_end = [a a a];
vert_start = [a a -a];      % start/end coordinates of vertical strut
vert_end = [a a a];

line_segments = 1;          % Number of line segments in each medial axis

% Define the inclined struts (no defects applied)
[verts_incl, segments_incl] = strutdefine(incl_start, incl_end, line_segments, 'normal', 0);
radii_incl = radius;        % No radius variation applied to inclined struts

% Vertical struts (no defects applied)
[verts_vertical, segments_vertical] = strutdefine(vert_start, vert_end,1, 'normal', 0);
radii_vert = radius;        % No radius variation applied to vertical struts

% Node coordinates 
node_coords = [0 0 0; -cs/2 cs/2 cs/2; cs/2 cs/2 cs/2; cs/2 -cs/2 cs/2;
          -cs/2 -cs/2 cs/2; -cs/2 cs/2 -cs/2; cs/2 cs/2 -cs/2;
          cs/2 -cs/2 -cs/2; -cs/2 -cs/2 -cs/2];

%% Signed distance functions

% Parameters
dx = 0.125; % domain resolution
[x, y, z] = meshgrid(-cs/2-radius_node:dx:cs/2+radius_node);

% Inclined struts
fprintf(1, 'Computing SDF (1) ...\n');
[d1] = sdf(x, y, z, verts_incl, segments_incl, radii_incl);
% Utilising symmetry to generate the remaining inclined struts
u_incl = booleanoperations(d1, rot90(d1, 1), rot90(d1, 2), rot90(d1, 3));

% Vertical struts
fprintf(1, 'Computing SDF (2) ...\n');
[d2] = sdf(x, y, z, verts_vertical, segments_vertical, radii_vert);
% Symmetry again
u_vert = booleanoperations(d2, rot90(d2, 1), rot90(d2, 2), rot90(d2, 3));

% Create nodes
[u_nodes] = sdfsphere(x, y, z, node_coords, radius_node);

%% Boolean operations
fprintf(1, 'Merging volumes ...\n');

% Merge struts and nodes to form unit cell
u_cell = booleanoperations(u_nodes, u_incl, u_vert);

% Perform tessellations to form lattice
[u_lattice, x1, y1, z1] = tessellate(u_cell, cs, radius, n, z, dx);

% Crop geometries
[u_cell_crop] = cropvolume(u_cell, cs/2, -cs/2, z);
[u_lattice_crop] = cropvolume(u_lattice, cs*n(3)-cs/2, -cs/2, z1);

%% Create Isosurfaces
fprintf(1, 'Performing tessellations ...\n');

% Unit cell surfaces (cropped and uncropped)
[data_cell.f, data_cell.v] = isosurface(x, y, z, u_cell, 0);
[data_crop_cell.f, data_crop_cell.v] = isosurface(x, y, z, u_cell_crop, 0);

% Tessellation surfaces (cropped and uncropped)
[data_lattice.f, data_lattice.v] = isosurface(x1, y1, z1, u_lattice, 0);
[data_crop_lattice.f, data_crop_lattice.v] = isosurface(x1, y1, z1, u_lattice_crop, 0);

%% Store relevant geoemtric data
% This is just how I chose to store relevant data to be used in scripts

fprintf(1, 'Organising data ...\n');

[data_cell.strutVertices] = cellsymmetry(verts_incl([1,end],:)', verts_vertical([1,end],:)');
[data_lattice.strutVertices] = tessellatecoordinates(data_cell.strutVertices, cs, n);

[data_cell.strutVertices, data_cell.strutID] = segmentsdefine(data_cell.strutVertices);
[data_lattice.strutVertices, data_lattice.strutID] = segmentsdefine(data_lattice.strutVertices);

data_crop_cell.strutVertices = data_cell.strutVertices;
data_crop_lattice.strutVertices = data_lattice.strutVertices;

data_crop_cell.strutID = data_cell.strutID;
data_crop_lattice.strutID = data_lattice.strutID;

fprintf(1, 'Done.\n');

%% Save data

if filesave == false
    return
end

filename = 'bccz_ideal.mat';
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data file not saved.'])
else
    disp(['"' filename '" saved to current directory.'])
    clear filesave
    save(filename)
end

