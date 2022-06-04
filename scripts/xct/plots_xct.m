%% Examples plots from import_point_cloud.m
clear
load importdata.mat

figure; subplot(4, 4, [1 2 5 6 9 10 13 14])
qscatter3(v, 5, 'k'); axis equal; hold on; title('raw point cloud')

load unitcell_raw1.mat
v1 = v; qscatter3(v1, 5); axis equal
load unitcell_raw6.mat
v2 = v; qscatter3(v2, 5); axis equal

load unitcell_inclined1.mat
subplot(4, 4, [3 4 7 8]); qscatter3(v1, 5, 'r'); axis equal; hold on; qscatter3(v, 5);
title('extracted inclined strut')

load unitcell_vertical2.mat
subplot(4, 4, [11 12 15 16]); qscatter3(v2, 5, 'r'); axis equal; hold on; qscatter3(v, 5); 
title('extracted vertical strut')

%% Cross section analysis
clear
load inclineddata.mat
fontsize = 17;

figure; subplot(221)
histogram(offset_all, [0:0.005:0.15])
xlabel('$\textbf{\emph{O}}^{i}_{ptcloud}/\mathrm{mm}$', 'Interpreter', 'latex', 'FontSize', fontsize)
ylabel('Count', 'Interpreter', 'latex'); title('Inclined strut offset data')

subplot(222)
histogram(radii_all, [0.45:0.005:0.55])
xlabel('$\textbf{\emph{R}}^{i}_{ptcloud}/\mathrm{mm}$', 'Interpreter', 'latex', 'FontSize', fontsize)
ylabel('Count', 'Interpreter', 'latex'); title('Inclined strut radii data')

load verticaldata.mat

subplot(223)
histogram(offset_all, [0:0.005:0.15])
xlabel('$\textbf{\emph{O}}^{v}_{ptcloud}/\mathrm{mm}$', 'Interpreter', 'latex', 'FontSize', fontsize)
ylabel('Count', 'Interpreter', 'latex'); title('Vertical strut offset data')

subplot(224)
histogram(radii_all, [0.45:0.005:0.55])
xlabel('$\textbf{\emph{R}}^{v}_{ptcloud}/\mathrm{mm}$', 'Interpreter', 'latex', 'FontSize', fontsize)
ylabel('Count', 'Interpreter', 'latex'); title('Vertical strut radii data')

%% Surface unwrapping
clear
load surf_unwrap_inclined_data.mat

figure; subplot(221)
plotunwrap(surface_unwrap{1})
view([0 90]); title('unwrapped surface: inclined strut (1)')

subplot(222)
plotunwrap(surface_unwrap{2})
view([0 90]); title('unwrapped surface: inclined strut (2)')

load surf_unwrap_vertical_data.mat

subplot(223)
plotunwrap(surface_unwrap{1})
view([0 90]); title('unwrapped surface: vertical strut (1)')

subplot(224)
plotunwrap(surface_unwrap{1})
view([0 90]); title('unwrapped surface: vertical strut (2)')
