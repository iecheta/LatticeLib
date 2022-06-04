function plotunwrap(select_data)

% Surface unwrapping plotting function

scatter3(select_data.surface_angle,...
        select_data.t,...
        select_data.dists,[],...
        colormapnorm(parula, select_data.dists), 'filled');
    ylim([0 1]); zlim([0 1]); xlabel('surface angle, \alpha'); 
    ylabel('intersection ratio, t')
    colorbar
    
end