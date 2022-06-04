function [tessellation_volume, x1, y1, z1] = tessellate2(d, cs, radius, n, z, dx)

cell_count = prod(n);
unit_cell_length = size(d, 1);

tessellation_volume = repmat(inf(size(d)), n);
unit_cell = tessellation_volume;


if sum(unique(z(:)==-cs/2)) ~= 1
    warning('Tessellation points: approximated')
end

if max(z(:)) == cs/2 + radius
    warning('unit cell volume has no padding')
end

%% Find indices

% Find the page index for the the z coordinates used for tessellation

% z-coordinates
h = abs(-cs/2-z);
[~, index1] = min(h,[],3);
index1 = index1(1);

h = abs(cs/2-z);
[~, index2] = min(h,[],3);
index2 = index2(1);

shift = index2-index1;

%%

[x_shift, y_shift, z_shift] = meshgrid(...
    [1, [shift*[1:n(1)-1]+1]], [1, [shift*[1:n(2)-1]+1]], [1, [shift*[1:n(3)-1]+1]]);


for i = 1:cell_count
    a1 = x_shift(i);
    b1 = a1+unit_cell_length-1;
    c1 = y_shift(i);
    d1 = c1+unit_cell_length-1;
    e1 = z_shift(i);
    f1 = e1+unit_cell_length-1;
    
    unit_cell(a1:b1, c1:d1, e1:f1) = d;
    tessellation_volume = min(tessellation_volume, unit_cell);
    unit_cell(:) = inf;
        
end

%% Tessellated coordinates

cell_start = min(z(:));

x1 = linspace(cell_start, cell_start + (size(tessellation_volume, 2)-1)*dx, size(tessellation_volume, 2));
y1 = linspace(cell_start, cell_start + (size(tessellation_volume, 1)-1)*dx, size(tessellation_volume, 1));
z1 = linspace(cell_start, cell_start + (size(tessellation_volume, 3)-1)*dx, size(tessellation_volume, 3));

if round(x1(2)-x1(1), 4) ~= dx || round(y1(2)-y1(1), 4) ~= dx || round(z1(2)-z1(1), 4) ~= dx
    error('dx of tessellation does not match dx of input volume')
end

[x1, y1, z1] = meshgrid(x1, y1, z1);
 

end