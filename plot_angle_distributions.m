clear

% retrieve file names
mat_dir = 'H:\cygwin\home\matthew.g\orientations\Rat24\';
mat_files = dir(mat_dir);
mat_files = {mat_files.name};
mat_files = mat_files(3:end);

% set up figure
figure
hold on
xlabel('Relative distance to boundary');
ylabel('Angle with respect to main axis');

% plot histograms
for file = 1:length(mat_files)
    mat_path = [mat_dir mat_files{file}];
    data = load(mat_path);
    [data.mean,data.std] = angle_bins(data.anglesg, data.e);
    angles(file) = data;
    plot(0.01:0.01:1,data.mean)
    plot(0.01:0.01:1,data.mean+data.std,'r')
    plot(0.01:0.01:1,data.mean-data.std,'r')
    
end


