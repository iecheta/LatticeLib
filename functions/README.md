# Functions
Decriptions of all of the functions used by LatticeLib.

|function|description|
|------------|-------|
| [angle360.m](/functions/angle360.m)| Calculate angle between 2 vectors, with angular range 0-360 degrees.|
| [booleanoperations.m](/functions/booleanoperations.m)| Perform boolean union on n fields.|
| [cellsym.m](/functions/cellsym.m)| Rotate line segment in z-axis. Accommodates line segments not centred about origin.|
| [cellsymmetry.m](/functions/cellsymmetry.m)| Take strut coordinates and create 3 duplicates, each rotated by 90, 180, and 270 degrees about z-axis.|
| [colormapnorm.m](/functions/colormapnorm.m)| Generate new colormap based on normalised values.|
| [cropvolume.m](/functions/cropvolume.m)| Crop volumes using a plane parallel to x-y plane.|
| [dotangle.m](/functions/dotangle.m)| Calculate angle (in degrees) between two vectors.|
|[intersectionratio.m](/functions/intersectionratio.m)| Calculate intersection ratio, and additional vectors.|
|[latticelibinstall.m](/functions/latticelibinstall.m)| Add LatticeLib's folders to the MATLAB search path.|
|[normalVector.m](/functions/normalVector.m)| Calculates normal vector in +z direction.|
|[pcloudrotatexy.m](/functions/pcloudrotatexy.m)| Rotate the point cloud of inclined struts and make it perpendicular to xy plane.|
|[plotunwrap.m](/functions/plotunwrap.m)| Surface unwrapping plotting function.|
|[qscatter3.m](/functions/qscatter3.m)|Shorthand scatter3.m plot.|
|[rotatepoints.m](/functions/rotatepoints.m)| Clockwise rotation (in degrees) about positive axes in 3 dimensions.|
|[roughnessapply.m](/functions/roughnessapply.m)| Apply roughness to lattice geometry.|
|[roughnesssurface.m](/functions/roughnesssurface.m)| Calculate the displacement to be applied to a specific point on a lattice strut surface.|
|[savestrut.m](/functions/savestrut.m)| Saving strut data file.|
|[sdf.m](/functions/sdf.m)| Signed distance function (SDF). Calculates the distance between all points in the domain and the line segments.|
|[sdfsphere.m](/functions/sdfsphere.m)| Signed distance function for individual points. Produces spheres.|
|[segmentscreate.m](/functions/segmentscreate.m)| Equally divide a line segment into smaller segments.|
|[segmentsdefine.m](/functions/segmentsdefine.m)| Extracts line segments from cell array and creates identifying binary vector.|
|[strutdefine.m](/functions/strutdefine.m)| Creates medial axis for the SDF function. The medial axis can be divided into smaller segments, and the vertices can be displaced in 2 orthogonal directions.|
|[strutfilter.m](/functions/strutfilter.m)| Remove unwanted points from strut point cloud.|
|[surfaceanalysis.m](/functions/surfaceanalysis.m)| Extract surface parameteres from lattice structure surface.|
|[tessellate.m](/functions/tessellate.m)| Tessellate signed distance field of unit cell.|
|[tessellatecoordinates.m](/functions/tessellatecoordinates.m)| Tessellates coordinates of unit cell.|
|[tetextract.m](/functions/tetextract.m)| Extract single tetrahedron from mesh.|
|[tetmeshqualvisual.m](/functions/tetmeshqualvisual.m)| Colour coded scatter plot of mesh quality.|
|[tetqualhistogram.m](/functions/tetqualhistogram.m)| Histograms of mesh quality.|
|[tetquality.m](/functions/tetquality.m)| Calculate tetrahedral element quality. Compare tetrahedron volume to volume of regular tetrahedron.|
|[tetregular.m](/functions/tetregular.m)| Create regular tetrahedron.|
|[tetsurfacecheck.m](/functions/tetsurfacecheck.m)| Identify surface tetrahedra.|
|[tetvolume.m](/functions/tetvolume.m)| Calculate volume of a tetrahedron.|
