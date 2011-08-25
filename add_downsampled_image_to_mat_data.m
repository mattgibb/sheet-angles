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
        
        % prepare downsampled image
        fprintf('Reading original file\n')
        im = imread(['H:\cygwin\home\matthew.g\images\' data_set '\HiRes\downsamples_1\' slice '.bmp']);
        im = imcrop(im, mat_data.rect);
        r=downsample2(im(:,:,1));
        g=downsample2(im(:,:,2));
        b=downsample2(im(:,:,3));
        im = cat(3,r,g,b);
        
        % save downsampled image in mat_data
        mat_data.image = im;
        save(matfile_path, '-struct', 'mat_data');        
    end
end
