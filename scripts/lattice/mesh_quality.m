%% Calculate mesh quality

% If you wish to save the data file(s) produced by this script, change the
% variable 'filesave' below to 'true'. Note that the files will not be
% saved if they already exist in the current directory.

clear
filesave = false;
%% Load example data
load tetmesh.mat

%% Modify mesh data from iso2mesh
% Remove uneeded columns from mesh data
node = node(:, 1:3);
elem = elem(:, 1:4);
face = face(:, 1:3);

% remove the repeats in the surface indexing matrix
face = face(1:2:size(face, 1), :);

%% Mesh quality
% Extract centroids of tetrahedra
[~, tet_centroid] = tetextract(node, elem);

% ID surface tetrahedra
[surfaceID, surfaceIDCount] = tetsurfacecheck(face, elem);
% Calculate mesh quality
[qualFactor] = tetquality(node, elem);

mean_qual_all = mean(qualFactor);
stddev = std(qualFactor);
mean_qual_surf = mean(qualFactor(surfaceID));
mean_qual_body = mean(qualFactor(~surfaceID));

%% Save data

if filesave == false
    return
end

filename = 'meshquality.mat';
if exist(fullfile(cd, filename), 'file')
    warning(['"' filename '" already exists in the current directory. Data file not saved.'])
else
    disp(['"' filename '" saved to current directory.'])
    save(filename, 'tet_centroid', 'surfaceID', 'qualFactor',...
        'mean_qual_all', 'stddev', 'mean_qual_surf', 'mean_qual_body')
end
