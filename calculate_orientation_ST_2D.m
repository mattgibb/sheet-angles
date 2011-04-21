
%Calculation of the coherence enhancing filter as presented in (Weickert 99). The 
%input parameters are:
%image: Input image
%alpha, C: Parameters used in the calculation of eigenvalues for the Diffusion tensor.
%   All the bigger eigenvalues receive the value alpha, and the smallest one receives
%   alpha + (1-alpha)*exp(-C/k), where k is the coherence at this pixel
%delta_t: Time step used in the calculation
%iterations: Number of iterations calculated
%hsize1, sigma: Gaussian filter parameters for original image filtering
%hsize2, rho: Gaussian filter parameters for structure tensor filtering
%function image_filt = coherence_enhancing_filter(image, alpha, C, delta_t, iterations, hsize1, sigma, hsize2, rho)

function orient=calculate_orientation_ST_2D(image, sigma, rho, mask)

hsize1=2*sigma;
hsize2=2*rho;

if(nargin == 3)
    mask_used = 0;
else
    mask_used = 1;
    mask(mask>0)=1;
end
%load slice5.mat

% hor=zeros(3,1,1); hor(1)=-.5; hor(2)=0; hor(3)=.5;
% ver=zeros(1,3,1); ver(1)=-.5; ver(2)=0; ver(3)=.5;
% prof=zeros(1,1,3); prof(1)=-.5; prof(2)=0; prof(3)=.5;
hor=zeros(3,1); hor(1)=-.5; hor(2)=0; hor(3)=.5;
ver=zeros(1,3); ver(1)=-.5; ver(2)=0; ver(3)=.5;

% [sizex,sizey,sizez] = size(image);
[sizex,sizey] = size(image);

    
        %image_gauss=convn(image, gaussian3D(hsize1,sigma,[1 1 1]),'same');
        image_gauss=gaussian_filter(image,hsize1,sigma);
    
        Lx=convn(image_gauss, hor,'same');
        Ly=convn(image_gauss, ver,'same');
%         Lz=convn(image_gauss, prof,'same');
    
        Lxr = reshape(Lx, [prod(size(Lx)) 1]);
        clear Lx;
        Lyr = reshape(Ly, [prod(size(Ly)) 1]);
        clear Ly;
%         Lzr = reshape(Lz, [prod(size(Lz)) 1]);
%         clear Lz;

        Struct = zeros(2, 2, prod(size(Lxr)));

        Struct(1,1,:) = Lxr.*Lxr;
        Struct(1,2,:) = Lxr.*Lyr;
%         Struct(1,3,:) = Lxr.*Lzr;

        Struct(2,1,:) = Struct(1,2,:);
        Struct(2,2,:) = Lyr.*Lyr;
%         Struct(2,3,:) = Lyr.*Lzr;

%         Struct(3,1,:) = Struct(1,3,:);
%         Struct(3,2,:) = Struct(2,3,:);
%         Struct(3,3,:) = Lzr.*Lzr;
    
        %Filtering the result to obtain the structure tensor
        for i=1:2
            for j=1:i
                tempimg = reshape(squeeze(Struct(i,j,:)),size(image));
                tempimg = gaussian_filter(tempimg,hsize2,rho);
                if(mask_used)
                    tempmask = gaussian_filter(mask,hsize2,rho);
                    tempimg (mask>0) = tempimg (mask>0) ./ tempmask(mask>0);
                    tempimg(mask==0) = 0;
                end
                Struct(i,j,:)=reshape(tempimg,size(Struct(i,j,:)));
            end
        end
        %Some of the values are calculated using symmetry
        for i=1:1
            for j=(i+1):2
                Struct(i,j,:)=Struct(j,i,:);
            end
        end
        
        eigenvals=zeros(size(Struct));
        eigenvecs=zeros(size(Struct));

    
        if(~mask_used)
            mask = ones(size(image));
        end
        fprintf('Calculation of eigenvectors\n');

        indices = find(mask == 1);
        numvoxels = size(indices,1);
        for i=1:numvoxels
            if(mod(i,100000)==0)
                fprintf('Voxel %d of %d\n', i, numvoxels);
            end
            [eigenvecs(:,:,indices(i)), eigenvals(:,:,indices(i))]=eig(Struct(:,:,indices(i)));
        end

        clear Struct;
    
        orient = reshape(eigenvecs(:,1,:),[2 size(image,1) size(image,2)]);

        %This is the right way to plot orientations:
        % [x,y]=ndgrid(1:300,1:200);
        % test=120+120*sin(x/5);
        % test2=imrotate(test,15);
        % imagesc(test2)
        % orient_test=calculate_orientation_ST_2D(test2,3,1,11,3);
        % [x,y]=ndgrid(1:10:size(test2,1),1:10:size(test2,2));
        % quiver(y,x,squeeze(orient_test(2,1:10:size(test2,1),1:10:size(test2,2))),squeeze(orient_test(1,1:10:size(test2,1),1:10:size(test2,2))))


        
        
        