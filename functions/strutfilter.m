function [filter_keep, filter_remove] = strutfilter(strut_select, strut_num, t, dists, cut_width,...
                                                    dist_cut, orientation)

% Remove unwanted points from strut point cloud

if orientation == "vertical"
    filter_keep = strut_num==strut_select & ...
        dists < dist_cut & ...
        ((t > cut_width)  & (t < 1 - cut_width));
    
    filter_remove = ~filter_keep & strut_num==strut_select;
    
elseif orientation == "inclined"
    filter_keep = strut_num==strut_select & ...
        dists < dist_cut & ...
        ((t < 0.5 - cut_width & t > cut_width)  | (t > 0.5 + cut_width & t < 1 - cut_width));
    
    filter_remove = ~filter_keep & strut_num==strut_select;
    
else
    error('incorrect orientation input')
end
    


end