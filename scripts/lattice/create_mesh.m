%% Create tetrahedral mesh of lattice structure

% If you wish to save the data file(s) produced by this script, change the
% variable 'filesave' below to 'true'. Note that the files will not be
% saved if they already exist in the current directory.

clear
filesave = false;
%% Load example data and define mesh parameters
load bccz_formdefects.mat
select_geometry = data_cell;

f = select_geometry.f;
v = select_geometry.v;

radius_bound = 0.1;
angular_bound = 30;
distance_bound = 1;
radius_edge_bound = 3;
max_volume = 0.5;

opt = struct('radbound',radius_bound, 'angbound', angular_bound,...
    'distbound',distance_bound,'reratio',radius_edge_bound);

%% Generate mesh
try
    [node, elem, face] = cgals2m(v,f,opt,max_volume,'cgalpoly');
catch
   error(['iso2mesh toolbox not found. Add to path or install: '...
        'http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?Download']) 
end

%% Save data

if filesave == false
    return
end

filename = 'tetmesh.mat';

if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data file not saved.'])
else
    disp(['"' filename '" saved to current directory.'])
    clear filesave
    save(filename, 'node', 'elem', 'face', 'opt', 'max_volume')
end
