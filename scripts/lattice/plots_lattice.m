%% Lattice with form defects.
clear
load bccz_formdefects.mat

figure
subplot(121)
col = [73/255 138/255 135/255];
patch('Faces', data_cell.f, 'Vertices', data_cell.v,...
    'FaceColor', col, 'EdgeColor', 'none')
view(3); axis equal; axis off; camlight; title('Unit cell')

subplot(122)
col = [73/255 138/255 135/255];
patch('Faces', data_lattice.f, 'Vertices', data_lattice.v,...
    'FaceColor', col, 'EdgeColor', 'none')
view(3); axis equal; axis off; camlight; title('Lattice')

%% Lattice with downskin surface defects
clear
load roughsurface.mat

figure
col = [73/255 138/255 135/255];
patch('Faces', select_geometry.f, 'Vertices', surfaceVerticesRough,...
    'FaceColor', col, 'EdgeColor', 'none')
view(3); axis equal; axis off; camlight; title('Lattice with downskin surface defects')

%% Tetrahedral mesh
clear
load tetmesh.mat

col = [73/255 138/255 135/255];

figure;
try
    subplot(121); plotmesh(node(:, 1:3), elem); axis off; view([103, 9]); title('Tetrahedral mesh')
    subplot(122); plotmesh(node(:, 1:3), elem, '1.75*x+1.75*y<0'); axis off; view([103, 9]); title('Slice view')
catch
    close; figure
    warning(['iso2mesh toolbox not found. Add to path or install: '...
        'http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?Download'])
    warning('Using MATLAB built-in functions for plotting mesh. Only showing surface mesh')
    patch('Faces', face(:, 1:3), 'Vertices', node(:, 1:3), 'FaceColor', col, 'EdgeColor', 'k')
    axis equal; axis off; view([103, 9])
    title('Tetrahedral mesh')
end

%% Mesh quality
clear
load meshquality.mat

figure;
tetmeshqualvisual(tet_centroid, qualFactor, surfaceID)

figure;
tetqualhistogram(qualFactor, surfaceID)
