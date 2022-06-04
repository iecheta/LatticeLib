function [tessellateCoords] = tessellatecoordinates(strutCoords, cellSize, periodicity, varargin)

% Tessellates coordinates of unit cell

% Inputs:
        % strutCoords: nx1 cell array where each element contains 3xn matrix of the x,y,z
        %              coordinates of the struts in the unit cell
        % cellSize:    the size of the unit cell (i.e. bounding box edge length)
        % periodicity: number of unit cells in x,y,z. 1x3 matrix
        % ADDITIONAL OUTPUT varargin{1}:
        % 'fig': plots a figure of the tessellated coordinates
        
% Outputs:
        % tessellateCoords: cell array containing the coordinates for all
        % struts in the lattice. One line segment in each cell element
        
        
% Number of struts in original unit cell
cellStrutsCount = length(strutCoords);

% Total number of cells
cellCount = prod(periodicity);

% Initialise cell array to store the struts for all the cells. We already
% know the first set of strut coordinates (strutCoords)
tessellateCoords = cell(cellStrutsCount * (cellCount-1), 1);

% Multipliers in x,y,z directions. Used to shift the coordinates from the
% unit cell in the first position to any other unit cell

[x, y, z] = meshgrid(0:periodicity(1)-1, 0:periodicity(2)-1, 0:periodicity(3)-1);

% Displacement matrices. [dispX(i) dispX(i) dispX(i)] is the x,y,z distance
% of the ith unit cell from the first cell (i.e. strutCoords)
dispX = x * cellSize;
dispY = y * cellSize;
dispZ = z * cellSize;

% Figure plotting, part 1
plot_the_rest = 0;
if nargin == 4
        
    if varargin{1} == "fig"
        plot_the_rest = 1;
        [struts] = segmentsdefine(strutCoords);
        struts = struts';

        figure
        hold on
        for i = 1:cellStrutsCount
            pos = 2*i-1;
            plot3(struts(pos:pos+1, 1), struts(pos:pos+1, 2), struts(pos:pos+1, 3), '-o')
            view(3)
            grid on
            axis equal
            xlim([-cellSize (max(periodicity)+1)*cellSize])
            ylim([-cellSize (max(periodicity)+1)*cellSize])
            zlim([-cellSize (max(periodicity)+1)*cellSize])
        end
    else
        error('incorrect number of inputs')
    end
end


% We already have the coordinates for the first unit cell (strutCoords), so
% start at 2
for i = 2:cellCount
     
    % Calculate the coordinates of the ith unit cell by adding the
    % corresponding x,y,z distances from strutCoords
    for j = 1:cellStrutsCount
        
        tessellateCoords{j + (i-2)*cellStrutsCount}(1, :) = ...
            strutCoords{j}(1, :) + dispX(i);
        
        tessellateCoords{j + (i-2)*cellStrutsCount}(2, :) = ...
            strutCoords{j}(2, :) + dispY(i);
        
        tessellateCoords{j + (i-2)*cellStrutsCount}(3, :) = ...
            strutCoords{j}(3, :) + dispZ(i);
        
        % Figure plotting part 2
        if plot_the_rest == 1
            plotLine = tessellateCoords{j + (i-2)*cellStrutsCount}';      
            plot3(plotLine(:, 1), plotLine(:, 2), plotLine(:, 3), '-o')
            drawnow
        end
    end
end

% Add the first unit cell (strutCoords) to the other cells
tessellateCoords = vertcat(strutCoords, tessellateCoords);

end