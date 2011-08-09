function calculate_orientations_in_roi(data_set, image_name, region_name)
fprintf('Reading original file\n')
im=imread(['H:\cygwin\home\matthew.g\images\' data_set '\HiRes\downsamples_1\' image_name]);
f1=figure;
imagesc(im)
axis equal; axis tight
title('Select region of interest');

% im2 = im( 7500:11500, 9000:15000, 2);
[im2, rect] = imcrop(im);
close(f1);
im2=im2(:,:,2);
im2=downsample2(im2);
imagesc(im2);
colormap gray; axis equal; axis tight;

%Calculate mask
fprintf('Calculating initial mask\n');
thres1=250;
mask=zeros(size(im2));
mask(im2<thres1)=1;
subplot(1,2,1);
imagesc(mask);
title('Mask before opening and closing');
se = strel('disk',7);
mask = imclose(mask,se);
mask = imopen(mask,se);
subplot(1,2,2);
imagesc(mask);
title('Mask after opening and closing');
%pause; %Check here whether the threshold thres1 is fine.

mask2=bwlabel(mask);
f1=figure;
imagesc(mask2)
impixelinfo
f2=figure;
imagesc(mask2)
title('Select all regions corresponding to tissue (check the previous figure for values)');
mask2=uint8(bwselect);
close(f1);
close(f2);


%Eliminate internal "holes"
mask3=bwlabel(~mask2);
f1=figure;
%subplot(1,2,1)
imagesc(mask3)
impixelinfo
f2=figure;
imagesc(mask3)
title('Select all regions corresponding to background');
mask3=uint8(bwselect);
title('Select all regions corresponding to cavity');
mask4=uint8(bwselect);
close(f1);
close(f2);
mask3(mask4==1)=2;


orient_test=calculate_orientation_ST_2D(im2,3,11, ~mask3);

%Select the main orientation of the tissue
f3 = figure;
imagesc(mask3)
title('Select two point to mark the main orientation of the structure')
[x,y] = ginput(2);
close(f3);
%ref_vector=[y(2)-y(1) x(1)-x(2)];
ref_vector=[x(2)-x(1) y(2)-y(1)];
ref_vector=ref_vector/norm(ref_vector);
ref_angle=atan(ref_vector(2)/ref_vector(1));
orient_angle=squeeze(atan(orient_test(2,:,:)./orient_test(1,:,:)));
angles = orient_angle - ref_angle;
angles(angles < -pi/2) = angles(angles < -pi/2) + pi;
angles(angles > pi/2) = angles(angles > pi/2) - pi;

angles(mask3>0)=0;

%Select only clefts
cleft_thres = 180;  %Select the best threshold for clefts
clefts=zeros(size(im2));
clefts(im2>cleft_thres & mask3==0)=1;

% Get rid of really large holes
figure
subplot(1,2,1);
imagesc(clefts)
title('Before opening')
clefts2=imopen(clefts,strel('disk',11));

clefts=clefts-clefts2;
subplot(1,2,2);
imagesc(clefts)
title('After opening')

anglesg(clefts==0)=0;
figure
imagesc(angles)
title('Gaussian-smoothed angles in clefts')

dist_epi=bwdist(mask3==2);
dist_endo=bwdist(mask3==1);
e=dist_endo./(dist_endo+dist_epi);
e(clefts==0)=0;
figure
imagesc(e)
title('e parameter in clefts')
[angles_mean,angles_std] = angle_bins(angles, e);
plot_angle_distribution(angles_mean,angles_std);
mat_name = [image_name '_' region_name '.mat'];
mat_path = ['H:\cygwin\home\matthew.g\orientations\' data_set '\' mat_name ];
save(mat_path,'angles','e','ref_angle','rect');
end

function plot_angle_distribution(angles_mean,angles_std)
figure
plot(0.01:0.01:1,angles_mean)
hold
plot(0.01:0.01:1,angles_mean+angles_std,'r')
plot(0.01:0.01:1,angles_mean-angles_std,'r')
xlabel('Relative distance to boundary');
ylabel('Angle with respect to main axis');
end
