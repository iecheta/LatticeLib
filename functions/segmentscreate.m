function allSegments = segmentscreate(x1, xEnd, numOfSegments)
% Equally divide a line segment into smaller segments

xPoints = linspace(x1(1), xEnd(1), numOfSegments+1);
yPoints = linspace(x1(2), xEnd(2), numOfSegments+1);
zPoints = linspace(x1(3), xEnd(3), numOfSegments+1);

allSegments = vertcat(xPoints, yPoints, zPoints)';



