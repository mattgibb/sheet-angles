for spread = 0:99
    theta = spread * pi/100;
    angles = linspace(0,theta,100);
    vectors = [cos(angles)
               sin(angles)];
           
        % construct orientation tensor
    orientation_tensor = zeros(2,2);
    for i = 1:length(angles)
        orientation_tensor = orientation_tensor + vectors(:,i) * vectors(:,i)';
    end
    
    % calculate biggest eigenvector
    [vectors,values] = eig(orientation_tensor);
    values = diag(values);
    [bigger_value,bigger_index] = max(values);
    principal_vector = vectors(:,bigger_index);
    
    % calculate coherence
    smaller_value = values(3-bigger_index);
    coherence(spread + 1) = 1 - smaller_value / bigger_value;
end

plot(coherence)
hold on
plot(coherence.^2, 'r')
legend('coherence', 'coherence squared')