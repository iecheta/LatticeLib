function savestrut(v, skinAngle, skin_angle360, t,...
    dists, filter_vector, strut_count, filter_type, segments, save_name)

    v = v(filter_vector, :);
    skinAngle = skinAngle(filter_vector);
    skin_angle360 = skin_angle360(filter_vector);
    t = t(filter_vector);
    dists = dists(filter_vector);
    segments = segments(:, (strut_count*2-1:strut_count*2));
    
    
    if filter_type == "raw"
        save([save_name+'.mat'],...
            'v', 'skinAngle', 'skin_angle360', 't', 'dists', 'segments')
    elseif filter_type == "filter"
        save([save_name+'.mat'],...
            'v', 'skinAngle', 'skin_angle360', 't', 'dists', 'segments')
    end
end