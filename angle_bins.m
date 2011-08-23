function [angles_mean,angles_std] = angle_bins(angles, e)
%ANGLE_BINS Mean and standard dev distribution of angles against e
er=e;
er(e>0)=round(er(e>0)*99+1);
for v=1:100
    
    angles_mean(v)=mean(angles(er(:)==v));
    angles_std(v)=std(angles(er(:)==v));
end
end
