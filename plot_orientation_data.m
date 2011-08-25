clear

% defines data_set, slices and regions
Rat28

mat_dir = ['H:\cygwin\home\matthew.g\orientations\' data_set '\'];

for slice_index = 1:length(slices)
    slice = slices{slice_index};
    for region_index = 1:length(regions)
        region = regions{region_index};
        disp([slice ': ' region]);
        
        % load mat data
        matfile_path = [mat_dir slice '.bmp_' region '.mat'];
        mat_data = load(matfile_path);
        
        fh = orientation_plots(mat_data);
    end
end
