function out_img = downsample2(in_img)

gfilt=[1 4 6 4 1]./16;

if(ndims(in_img)==3)
    gfilt=zeros(1,1,5);   %Three-dim kernel
    gfilt(1,1,:)=[1 4 6 4 1]./16;

    in_img=convn(convn(convn(in_img,shiftdim(gfilt,2),'same'),shiftdim(gfilt,1),'same'),gfilt,'same');

% gfilt=[1 4 6 4 1]./16;
% 
% if(ndims(in_img)==3)
%     for sl=1:size(in_img,3)
%         slice=in_img(:,:,sl);
%         slice=convn(slice,gfilt,'same');
%         slice=convn(slice,gfilt','same');
%         in_img(:,:,sl)=slice;
%     %     fprintf('Processing slice %d\n', sl);
%     end
% 
%     for sl=1:size(in_img,2)
%         slice=squeeze(in_img(:,sl,:));
%         slice=convn(slice,gfilt,'same');
%         in_img(:,sl,:)=slice;
%     %     fprintf('Processing slice %d\n', sl);
%     end

%     size_out=[floor(size(in_img,1)/2) floor(size(in_img,2)/2) floor(size(in_img,3)/2)];
%     [x,y,z]=ndgrid(1.5:2:(size_out(1)*2)-.5, 1.5:2:(size_out(2)*2)-.5, 1.5);
% 
%     out_img=zeros(size_out);
%     for sl=1:size_out(3)
%         out_img(:,:,sl)=interpn(in_img(:,:,2*sl-1:2*sl),x,y,z);
%     end
%     [x,y,z]=ndgrid(1.5:2:(size_out(1)*2)-.5, 1.5:2:(size_out(2)*2)-.5, 1.5:2:(size_out(3)*2)-.5);
% 
%     out_img=zeros(size_out);
% 	out_img=interpn(in_img,x,y,z);
    out_img=in_img(1:2:size(in_img,1),1:2:size(in_img,2),1:2:size(in_img,3));


elseif(ndims(in_img)==2)
    in_img=convn(in_img,gfilt,'same');
    in_img=convn(in_img,gfilt','same');        

    size_out=[floor(size(in_img,1)/2) floor(size(in_img,2)/2)];
    [x,y]=ndgrid(1.5:2:(size_out(1)*2)-.5, 1.5:2:(size_out(2)*2)-.5);

    out_img=interpn(in_img,x,y);
end
