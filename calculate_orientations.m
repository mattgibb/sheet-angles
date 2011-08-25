% defines data_set, slices and regions
Rat28

for slice_index = 1:length(slices)
    calculate_orientations_in_roi(data_set, [slices{slice_index} '.bmp'], 'upper_free_wall');
end
