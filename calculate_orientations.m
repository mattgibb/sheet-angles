% files = dir('H:\cygwin\home\matthew.g\images\Rat24\HiRes\originals\');
files = {
    'Rat24_0396.bmp'
    'Rat24_0414.bmp'
    'Rat24_0435.bmp'
    'Rat24_0455.bmp'
    'Rat24_0475.bmp'
    'Rat24_0495.bmp'
    'Rat24_0516.bmp'
    'Rat24_0535.bmp'
    'Rat24_0556.bmp'
    'Rat24_0576.bmp'
    'Rat24_0595.bmp'
    };

for file = 1:length(files)
    calculate_orientations_in_roi(files{file}, 'upper_septum');
end
