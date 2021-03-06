function abaqusfilegen(node, elem, face, displacement_ratio, directory, inp_filename, depth, fig)

% Generate .inp file for lattice stiffness calculation in Abaqus.

% Inputs:
%   node:               n x 3 matrix of mesh points
%   elem:               m x 4 tetrahedra indexing matrix 
%   face:               p x 3 surface triangle indexing matrix
%   displacement_ratio: applied displacement / lattice height
%   directory:          directory in which all data will be stored. A new
%                       directory will be created if it does not exist.
%   inp_filename:       .inp filename, excluding extension.
%   depth:              a search distance, in millimetres, from top/bottom face (in z direction)
%                       which is used to locate the top/bottom node sets, if the lattice has
%                       cropped faces. Set this value to 0 if the lattice does NOT have any
%                       cropped faces.
%   fig:                Displays a figure of top and bottom node sets. Set this value to
%                       'true'/'false' to display/skip the figure. Displaying the figure
%                       is advised if 'depth' =/= 0.
% Note:
%   - Elastic problems only. Material properties can be changed in the
%     lines below
%   - After running this .inp file in Abaqus, a .dat file will be
%     outputted. Use the .dat file to determine the reaction force in the
%     lattice, from which lattice stiffness can be derived.
%% Parameters

Youngs_mod = 126000; % MPa
poisson = 0.32;
material_name = "Ti6Al4V";

% Node set names
topSetName = "TOPSURF";
bottomSetName = "BOTTOMSURF";

% Remove erroneous points created by iso2mesh
[nodes_keep, ~, ~, ~] = meshfilter(node, elem);

% Calculate height of geometry
height = max(nodes_keep(:, 3)) - min(nodes_keep(:, 3));

% Calculate displacement in negative z direction
displacement = height * -displacement_ratio;

%% Top and bottom faces
div = 100;

% Bottom face
surface_side = "bottom";
[~, nodes_bottom] = extractflatpoints(node, face, depth, div, surface_side);
[bottom_surfID, ~] = find(ismember(node, nodes_bottom, 'rows'));

% Top face
surface_side = "top";
[~, nodes_top] = extractflatpoints(node, face, depth, div, surface_side);
[top_surfID, ~] = find(ismember(node, nodes_top, 'rows'));

% Tabulate node and element data
elemID = horzcat((1:size(elem, 1))', elem); % Node ID list
nodeID = horzcat((1:size(node, 1))', node); % Elem ID list

%% Print info
disp("********************")
disp("INP FILE INFORMATION")
disp("File name: " + inp_filename + ".inp")
disp("Geometry height: " + height)
disp("Displacement: " + displacement)
disp("Node set names: " + topSetName + ", " + bottomSetName)
disp("********************")

%% Figure to check confirm the node selection
if fig
    figure; qscatter3(nodes_keep, 5, 'b')
    hold on
    qscatter3(node(bottom_surfID ,:), 500, 'y')
    qscatter3(node(top_surfID ,:), 500, 'r')
    axis equal
    title([inp_filename '.inp'], 'Interpreter', 'none')
    view(0, 0)
end
%% Write the file
if ~exist(directory, 'dir')
    warning(['new directory created: ' directory])
    mkdir(directory);
end
% save([fullPath '\' inp_filename 'inpfile_variables.mat'])
save(fullfile(directory, 'inpfile_variables.mat'))

% fid = fopen([fullPath '\' inp_filename '.inp'], 'w');
fid = fopen(fullfile(directory, [inp_filename '.inp']), 'w');

fprintf(fid,'*HEADING \n');
fprintf(fid,'Lattice structure generated by Ifeanyi Echeta \n');
fprintf(fid,'**\n');
fprintf(fid,'**PREPRINT, echo=NO, model=NO, history=NO, contact=NO \n');
fprintf(fid,'**\n');
fprintf(fid,'** PARTS\n');
fprintf(fid,'**\n');
fprintf(fid,'*Part, name=PART-1\n');

% Node info
fprintf(fid,'*Node \n');
% NUMBERED LIST OF ALL THE NODES. COMMA SEPARATED
fprintf(fid,'%u, %f, %f, %f \n', nodeID');

% Element info
fprintf(fid,'*Element, type=C3D4 \n');
%%%% NUMBERED LIST OF ALL THE ELEMENTS. COMMA SEPARATED
fprintf(fid,'%u, %u, %u, %u, %u \n', elemID');

fprintf(fid,'*Elset, elset=_PickedSet2, internal, generate\n');
fprintf(fid,"1, " + num2str(size(elem, 1)) + ", 1 \n");
fprintf(fid,'** Section: Section-1\n');

% Name material
fprintf(fid,"*Solid Section, elset=_PickedSet2, material=" + material_name + "\n");
fprintf(fid,',\n');
fprintf(fid,'*End Part\n');
fprintf(fid,'**\n');
fprintf(fid,'**\n');
fprintf(fid,'** ASSEMBLY\n');
fprintf(fid,'**\n');
fprintf(fid,'*Assembly, name=Assembly\n');
fprintf(fid,'**\n');
fprintf(fid,'*Instance, name=PART-1-1, part=PART-1\n');
fprintf(fid,'*End Instance\n');
fprintf(fid,'**\n');

% Define bottom node set
fprintf(fid,"*Nset, nset=" + bottomSetName + ", instance=PART-1-1 \n");
% COMMA SEPARATED LIST OF NODES OF BOTTOM SURFACE
fprintf(fid,'%u, %u, %u, %u, %u \n', bottom_surfID');
fprintf(fid,'\n');

% Define top node set
fprintf(fid,"*Nset, nset=" + topSetName + ", instance=PART-1-1 \n");
% COMMA SEPARATED LIST OF NODES OF TOP SURFACE
fprintf(fid,'%u, %u, %u, %u, %u \n', top_surfID');
fprintf(fid,'\n');

fprintf(fid,'*End Assembly\n');
fprintf(fid,'**\n');
fprintf(fid,'** MATERIALS\n');
fprintf(fid,'**\n');

% Material properties
fprintf(fid,"*Material, name=" + material_name + "\n");
fprintf(fid,'*Elastic\n');
fprintf(fid, num2str(Youngs_mod) + "., " + num2str(poisson) + "\n");
fprintf(fid,'** ----------------------------------------------------------------\n');
fprintf(fid,'**\n');
fprintf(fid,'** STEP: Step-1\n');
fprintf(fid,'**\n');
fprintf(fid,'*Step, name=Step-1, nlgeom=NO\n');
fprintf(fid,'*Static\n');
fprintf(fid,'1., 1., 1e-05, 1.\n');
fprintf(fid,'**\n');

% Boundary conditions
fprintf(fid,'** BOUNDARY CONDITIONS\n');
fprintf(fid,'**\n');
fprintf(fid,'** Name: BC-1 Type: Displacement/Rotation\n');
fprintf(fid,'*Boundary\n');
fprintf(fid,topSetName + ", 3, 3, " + num2str(displacement) + "\n");
fprintf(fid,'** Name: BC-2 Type: Symmetry/Antisymmetry/Encastre\n');
fprintf(fid,'*Boundary\n');
fprintf(fid, bottomSetName + ", ENCASTRE \n");

fprintf(fid,'**\n');
fprintf(fid,'** OUTPUT REQUESTS\n');
fprintf(fid,'**\n');
fprintf(fid,'*Restart, write, frequency=0\n');
fprintf(fid,'**\n');
fprintf(fid,'** FIELD OUTPUT: F-Output-1\n');
fprintf(fid,'**\n');

% Output reaction force
fprintf(fid,"*Node print, nset=" + topSetName + ", freq=1 \n"); 
fprintf(fid,'RF3,\n');
fprintf(fid,'*Output, field, variable=PRESELECT\n');
fprintf(fid,'\n');
fprintf(fid,'**\n');
fprintf(fid,'** HISTORY OUTPUT: H-Output-1\n');
fprintf(fid,'**\n');
fprintf(fid,'*Output, history, variable=PRESELECT\n');
fprintf(fid,'*End Step\n');

fclose(fid);
end





