clear

regions = {
    'upper_free_wall'
    'lower_free_wall'
    'upper_septum'
    'lower_septum'
    };

slices = {
    '0391'
    '0411'
    '0431'
    '0451'
    '0471'
    '0491'
    '0511'
    '0531'
    '0550'
    };

data_set = 'Rat28';
mat_dir = ['H:\cygwin\home\matthew.g\orientations\' data_set '\'];

for slice_index = 1:length(slices)
    slice = slices{slice_index};
    disp(slice)
    for region_index = 1:length(regions)
        region = regions{region_index};
        disp(region)
        
        % construct mat path 
        matfile_path = [mat_dir slice '.bmp_' region '.mat'];
        
        % load mat data except 'anglesg'
        mat_data = load(matfile_path, 'rect', 'ref_angle', 'e');
        
        [mat_data.angles, mat_data.coherences] = calculate_orientations_using_tensors(data_set, slice, region, mat_data);   
        
        % save recalculated orientations and coherences
        save(matfile_path, '-struct', 'mat_data');
    end
end
