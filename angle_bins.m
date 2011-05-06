function [angles_mean,angles_std] = angle_bins(anglesg, e)
%ANGLE_BINS Mean and standard dev distribution of angles against e
er=e;
er(e>0)=round(er(e>0)*99+1);
e_avg=zeros(1,100);
for v=1:100
    angles_mean(v)=mean(anglesg(er(:)==v));
    angles_std(v)=std(anglesg(er(:)==v));
end
end
