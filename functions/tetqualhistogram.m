function tetqualhistogram(meshQual, surfaceID, varargin)


if nargin == 2
    subplot(6, 6, [1:12])
    histogram(meshQual)
    title('Mesh quality: all')
    xlim([0 1]); xlabel('quality'); ylabel('Count')

    subplot(6, 6, [22 23 24 28 29 30 34 35 36])
    histogram(meshQual(surfaceID))
    title('Mesh quality: surface')
    xlim([0 1]); xlabel('quality'); ylabel('Count')

    subplot(6, 6, [19 20 25 26 31 32])
    histogram(meshQual(~surfaceID)) 
    title('Mesh quality: body')
    xlim([0 1]); xlabel('quality'); ylabel('Count')
    
elseif nargin == 3
    plotType = varargin{1};
    switch plotType
        case "all"
            histogram(meshQual)
            title('Mesh quality: all')
        case "surface"
            histogram(meshQual(surfaceID))
            title('Mesh quality: surface')
        case "body"
            histogram(meshQual(~surfaceID))
            title('Mesh quality: body')
        otherwise
            error('incorrect input: plotType')
    end
    
else
    error('incorrect inputs')
end
xlim([0 1])



