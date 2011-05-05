function calculate_orientations_in_roi(image_name, roi)
fprintf('Reading original file\n')
im=imread(['H:\cygwin\home\matthew.g\images\Rat24\HiRes\originals\' image_name]);
f1=figure;
imagesc(im)
axis equal; axis tight
title('Select region of interest');

% im2 = im( 7500:11500, 9000:15000, 2);
im2=imcrop(im);
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
f2=figure
imagesc(mask3)
title('Select all regions corresponding to background');
mask3=uint8(bwselect);
title('Select all regions corresponding to cavity');
mask4=uint8(bwselect);
mask3(mask4==1)=2;
close(f1);
imagesc(mask3)


orient_test=calculate_orientation_ST_2D(im2,3,11, ~mask3);

%Select the main orientation of the tissue
figure
imagesc(mask3)
title('Select two point to mark the main orientation of the structure')
[x,y] = ginput(2);
%ref_vector=[y(2)-y(1) x(1)-x(2)];
ref_vector=[x(2)-x(1) y(2)-y(1)];
ref_vector=ref_vector/norm(ref_vector);
ref_angle=atan(ref_vector(2)/ref_vector(1));
orient_angle=squeeze(atan(orient_test(2,:,:)./orient_test(1,:,:)));
angles = orient_angle - ref_angle;
angles(angles < -pi/2) = angles(angles < -pi/2) + pi;
angles(angles > pi/2) = angles(angles > pi/2) - pi;

angles(mask3>0)=0;

%Filter the angles to get a smoother representation
anglesg=gaussian_filter(angles,21,8);

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
imagesc(anglesg)
title('Gaussian-smoothed angles')

dist_epi=bwdist(mask3==2);
dist_endo=bwdist(mask3==1);
e=dist_endo./(dist_endo+dist_epi);
e(clefts==0)=0;
figure
imagesc(e)
title('e parameter in clefts')

er=e;
er(e>0)=round(er(e>0)*99+1);
e_avg=zeros(1,100);
for v=1:100
    angles_avg(v)=mean(anglesg(er(:)==v));
    angles_std(v)=std(anglesg(er(:)==v));
end
figure
plot(0.01:0.01:1,angles_avg)
hold
plot(0.01:0.01:1,angles_avg+angles_std,'r')
plot(0.01:0.01:1,angles_avg-angles_std,'r')
xlabel('Relative distance to boundary');
ylabel('Angle with respect to main axis');
end
