function fh = orientation_plots(data)
fh = figure;

% Tissue image
subplot(2,2,1)
imagesc(data.image)

% e
subplot(2,2,2)
imagesc(data.e)

% angles and coherences
subplot(2,2,3)
x = 0.01:0.01:1;
[AX,H1,H2] = plotyy(x,data.angles,x,data.coherences);
set(get(AX(1),'Ylabel'),'String','angle')
set(get(AX(2),'Ylabel'),'String','coherence')
xlabel('e') 
title('Transmural Angles and Coherences') 
set(H1,'LineStyle','--')
set(H2,'LineStyle',':')

% quiver or ellipses
subplot(2,2,4)
angle_subset = data.angles(1:end);

x = linspace(0,1,length(angle_subset))'*ones(1,5);
y = ones(length(angle_subset),1)*[0:4];
u = cos(angle_subset);
v = sin(angle_subset);

qh = quiver(x,y,u,v);

end