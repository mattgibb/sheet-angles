files = dir('H:\cygwin\home\matthew.g\images\Rat24\HiRes\originals\');
for file = 3:length(files)
    calculate_orientations_in_roi(files(file).name);
end
