function latticelibinstall()

% Add LatticeLib's folders to the MATLAB search path

addpath(genpath('..\exampledata'))
addpath(genpath('..\functions'))
addpath(genpath('..\scripts'))
savepath
disp('LatticeLib folders added to MATLAB search path.')
