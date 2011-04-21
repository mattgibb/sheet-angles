%Gaussian filter, using a kernel size hsize and a sigma value sigma.
%It calculates the result using separability of the kernel
function imfilt=gaussian_filter(image, hsize, sigma, resolution)

if(nargin<4)
    resolution=[1 1 1];
end

epsilon=1e-3;

% sigma = sigma ./ resolution;
hsize=2*max(ceil((sigma ./ resolution).*sqrt(-2*log(sqrt(2*pi).*(sigma ./ resolution)*epsilon))))+1;

n=1:hsize;
center= hsize/2 + 0.5;

dims=ndims(image);    %Can be two or three-dimensional

ker1=(1/((2*pi*sigma.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigma.^2));  %One-dim kernel

sigmax=sigma/resolution(1);
sigmay=sigma/resolution(2);

kerx=zeros(1,1,hsize);
kery=zeros(1,1,hsize);

kerx(1,1,:)=(1/((2*pi*sigmax.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmax.^2));
kery(1,1,:)=(1/((2*pi*sigmay.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmay.^2));

%Normalize:
kerx=kerx./sum(kerx);
kery=kery./sum(kery);

if(dims>2)
    sigmaz=sigma/resolution(3);
    kerz=zeros(1,1,hsize);
    kerz(1,1,:)=(1/((2*pi*sigmaz.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmaz.^2));
    kerz=kerz./sum(kerz);
end


%Normalize:
ker1=ker1./sum(ker1);

if(dims==2)
%     imfilt=conv2(image,ker1,'same');
%     imfilt=conv2(imfilt,ker1','same');
%    imfilt=conv2(conv2(image,kerx,'same',kery','same'));
    imfilt=convn(convn(image,shiftdim(kerx,2),'same'),shiftdim(kery,1),'same');
elseif(dims==3)
    ker=zeros(1,1,hsize);   %Three-dim kernel
    ker(1,1,:)=kerz;
%     imfilt=convn(image,ker,'same');
%     imfilt=convn(imfilt,shiftdim(ker,1),'same');
%     imfilt=convn(imfilt,shiftdim(ker,2),'same');
    imfilt=convn(convn(convn(image,shiftdim(kerx,2),'same'),shiftdim(kery,1),'same'),kerz,'same');
elseif(dims==4)
    ker=zeros(1,1,1,hsize);   %Three-dim kernel
    sigmax=sigma/resolution(1);
    ker(1,1,1,:)=(1/((2*pi*sigmax.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmax.^2));
    imfilt=convn(image,ker,'same');
    sigmay=sigma/resolution(2);
    ker(1,1,1,:)=(1/((2*pi*sigmay.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmay.^2));
    imfilt=convn(imfilt,shiftdim(ker,1),'same');
    sigmaz=sigma/resolution(3);
    ker(1,1,1,:)=(1/((2*pi*sigmaz.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmaz.^2));
    imfilt=convn(imfilt,shiftdim(ker,2),'same');
    sigmat=sigma/resolution(4);
    ker(1,1,1,:)=(1/((2*pi*sigmat.^2).^(1/2))) * exp(-((n-center).^2)/(2*sigmat.^2));
    imfilt=convn(imfilt,shiftdim(ker,3),'same');
   
end









