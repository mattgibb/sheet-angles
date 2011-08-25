function [angles, coherences] = calculate_orientations_using_tensors(data_set, slice_name, region, mat_data)
fprintf('Reading original file\n')
im=imread(['H:\cygwin\home\matthew.g\images\' data_set '\HiRes\downsamples_1\' slice_name '.bmp']);
im2 = imcrop(im, mat_data.rect);
im2=im2(:,:,2);
im2=downsample2(im2);

% calculate angles and coherences for different e values
orientation_vectors = calculate_orientation_ST_2D(im2,3,11);
[angles,coherences] = transmural_angles_and_coherences(orientation_vectors, mat_data.e);

% make angles relative to reference angle (approx line of constant e)
angles = angles - mat_data.ref_angle;

% keep angles within bounds of +/- pi/2
angles(angles < -pi/2) = angles(angles < -pi/2) + pi;
angles(angles > pi/2) = angles(angles > pi/2) - pi;

figure
subplot(1,3,1);
imagesc(mat_data.e)
title('e parameter in clefts')
subplot(1,3,2);
imagesc(angles)
title('angles in clefts')
subplot(1,3,3);
imagesc(coherences)
title('coherences in clefts')
end
