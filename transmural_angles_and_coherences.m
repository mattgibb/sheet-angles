function [principal_angles,coherences] = transmural_angles_and_coherences(vectors, e)
% separate vectors into x and y components
x = vectors(1,:);
y = vectors(2,:);

% discard pixels with zero e
x = x(e~=0);
y = y(e~=0);
e = e(e~=0);
 
% e percentage index
e_bins = ceil(e(:)*100);

for percentile=1:100
    % construct tensor
    bin_indeces = e_bins==percentile;
    sum_x_squared = sum(x(bin_indeces).^2);
    sum_y_squared = sum(y(bin_indeces).^2);
    sum_xy        = sum(x(bin_indeces).*y(bin_indeces));
    
    orientation_tensor = [sum_x_squared sum_xy
                           sum_xy        sum_y_squared];
    
    [principal_angles(percentile), coherences(percentile)] = principal_angle_and_coherence(orientation_tensor);
end
end

function [principal_angle, coherence] = principal_angle_and_coherence(tensor)
% calculate biggest eigenvector and its angle
[vectors,values] = eig(tensor);
values = diag(values);
[bigger_value,bigger_index] = max(values);
principal_vector = vectors(:,bigger_index);
principal_angle = atan( principal_vector(2) / principal_vector(1) );

% calculate coherence
smaller_value = values(3-bigger_index);
coherence = (1 - smaller_value / bigger_value)^2;
end


