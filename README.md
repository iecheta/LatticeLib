# LatticeLib
Modelling and measurement tools for strut-based lattice structures. Written in MATLAB (v2020b).

Developed by Ifeanyi Echeta.

## Overview
---
LatticeLib (lattice library) is a library of functions which can be used for:
- Modelling strut-based lattice structures - including the addition of defects.
- Extracting measurement parameters from point cloud data of strut-based lattice structures.

*"Strut-based lattice structures" will hereafter be referred to as **SBLS**.*

LatticeLib consists of a select set of functions developed during my PhD. The focus of my PhD - thesis titled "Analysis of defects in additively manufactured lattice structures" (link will be provided in due course) - was to investigate methods for determining the impact of manufacturing defects on the mechanical properties of SBLS. The summary of my thesis is as follows:
- A modelling method was proposed ([see my journal paper](https://www.sciencedirect.com/science/article/pii/S2214860421004607)) for applying form and surface defects ([see my review paper](https://link.springer.com/article/10.1007/s00170-019-04753-4)) to SBLS.
- Measurement algorithms were developed for extracting measurement parameters from point cloud data of SBLS produced by additive manufacturing and measured using X-ray computed tomography (XCT). These measurement parameters can be used for the selection of more realistic parameters in the aforementioned modelling method.

## Installation
---
Once LatticeLib has been downloaded, all of its folders (excluding `\.git`) must be added to the MATLAB search path. To do this, follow these steps:
* In MATLAB, change the current folder to `...\LatticeLib\functions`
* Enter the command `latticelibinstall` into the command window. This command will run the function [`latticelibinstall.m`](/functions/latticelibinstall.m) which automatically adds all required folders to the MATLAB search path.

If any problems with installation persist, try the following:
* Enter `pathtool` into the command window
* Select "Add with Subfolders..." and select the folder [`\exampledata`](/exampledata/)
* Repeat the above bullet point for the remaining two folders, i.e. [`\functions`](/functions/) and [`\scripts`](/scripts/)
* Select "Save" and close the window

Note: [`latticelibinstall.m`](/functions/latticelibinstall.m) does not check if the folders have already been added to the search path.

## Structure
---
LatticeLib consists of three main folders:

|folder|description|
|------------|-------|
| [`\scripts`](/scripts/)         | Demonstrations showcasing how LatticeLib's functions are used. Contains two subfolders: [`\lattice`](/scripts/lattice/), [`\xct`](/scripts/xct/). |
| [`\functions`](/functions/)        | All of the functions used by LatticeLib (plus a few extras, see next section)  |
| [`\exampledata`](/exampledata/)      | Data files (.mat) used to load the example data from each script. Contains two subfolders: [`\lattice`](/exampledata/lattice/), [`\xct`](/exampledata/xct/).   |

### `\scripts`
The [`\scripts`](/scripts/) folder contains scripts providing demonstrations which showcase how LatticeLib's functions are used. The scripts are sorted into two subfolders. The following scripts are located in the subfolder [`\lattice`](/scripts/lattice/):

|filename|description|
|------------|-------|
|[lattice_build_ideal.m](/scripts/lattice/lattice_build_ideal.m)| Generate triangulated surface of BCCZ lattice structure with **no defects**|
|[lattice_build_defects.m](/scripts/lattice/lattice_build_defects.m)|Generate triangulated surface of BCCZ lattice structure with **form defects**. The parameters of the form defects are derived from XCT data analysed in [\scripts\xct\cross_section_analysis.m](/scripts/xct/cross_section_analysis.m)|
|[surface_roughness.m](/scripts/lattice/surface_roughness.m)|Model **surface defects** by applying a displacement function to the strut surface|
|[create_mesh.m](/scripts/lattice/create_mesh.m)|Convert surface mesh to tetrahedral mesh|
|[mesh_quality.m](/scripts/lattice/mesh_quality.m)|Calculate quality of all elements in the mesh|
|[plots_lattice.m](/scripts/lattice/plots_lattice.m)|Example plots of all the above scripts in this table|

The following scripts are located in the subfolder \xct:

|filename|description|
|------------|-------|
|[import_point_cloud.m](/scripts/xct/import_point_cloud.m)|Extract vertices from STL file of BCCZ lattice structure and segment into individual struts|
|[cross_section_analysis.m](/scripts/xct/cross_section_analysis.m)|Fit circles to cross sections of lattice struts, using least-squares|
|[surface_unwrapping_struts.m](/scripts/xct/surface_unwrapping_struts.m)|Unwrap strut surfaces. Useful for investigating texture bias|
|[plots_xct.m](/scripts/xct/plots_xct.m)|Example plots of all the above scripts in this table|

### `\functions`
The [`\functions`](/functions) folder contains all of the functions used by LatticeLib. Most of the functions have explanations about their inputs and outputs, if you wish to use them externally. Additionally, the scripts (in the [`\scripts`](/scripts/) folder) hopefully demonstrate how the functions are used. The additional folder [`\extra`](/functions/extra/) contains functions (and any dependencies) that I wrote for other things not used by LatticeLib but that I felt might be useful.

### `\exampledata`

The [`\exampledata`](/exampledata/) folder contains all the data files (.mat) which are - by default - used by the scripts. The contents of this folder are required so that each script can perform independently, that is, without having to run any other code. The data files are organised into two folders: [`\lattice`](/exampledata/lattice/), and [`\xct`](/exampledata/xct/)) (reflecting the folder structure in [`\scripts`](/scripts/)).

## Dependencies
---
There is one external dependency, found in [`...\scripts\lattice\create_mesh.m`](/scripts/lattice/create_mesh.m). Conversion of triangulated surface mesh into tetrahedral mesh - i.e. a 3D Delaunay triangulation - is performed using [iso2mesh](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?Home) v1.9.0. iso2mesh must be [downloaded](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?Download) and added to MATLAB's search path.

Iso2mesh can be added to MATLAB's search path by again entering the `pathtool` command and selecting "Add with subfolders..." to add the iso2mesh parent folder and all its subfolders. The iso2mesh website discusses installation [here.](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?Doc/Installation)

## Known Issues
---
- A lot of this code was written as a proof of concept, therefore, optimisation is needed for several functions. If I ever get round to improving this code, I will likely also rewrite it using Python.
- The vertices in the tetrahedral mesh contain a few points which are far away from the mesh and are not part of the mesh. These points are likely leftover from the initialisation of the Delaunay triangulation. These points are not indexed by the mesh's indexing matrix and can therefore often be ignored. However, if you wish to remove these points, see my function meshfilter.m
- Each row in the indexing matrix for the surface triangles of the tetrahedral mesh is duplicated. It is unclear why iso2mesh produces this data; it has not caused me any errors, however.
