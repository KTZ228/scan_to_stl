clear, clc, close all

%% Load data and turn neural tissue into logical
addpath(genpath('ExportVoxelData'))

subject_name = 'ernie';

segmented_data = niftiread(sprintf('data_raw/final_tissues_%s.nii.gz', subject_name));

segmented_data(segmented_data==2) = 1;
segmented_data(segmented_data~=1) = 0;

segmented_data_logical = logical(segmented_data);

%% Rotate if necessary
segmented_data_logical = permute(segmented_data_logical, [3,1,2]);

%% Limit array size
% Find the bounds
[xIndices, yIndices, zIndices] = ind2sub(size(segmented_data_logical), find(segmented_data_logical));

skull_buffer = 4;
xMin = min(xIndices) - skull_buffer;
xMax = max(xIndices) + skull_buffer;
yMin = min(yIndices) - skull_buffer;
yMax = max(yIndices) + skull_buffer;
zMin = min(zIndices) + 75;
zMax = max(zIndices) + skull_buffer;

% Crop the array
segmented_data_logical = segmented_data_logical(xMin:xMax, yMin:yMax, zMin:zMax);

%% Add ellipse
% Define the dimensions of the matrix
x_dim = size(segmented_data_logical, 1); % X dimension size
y_dim = size(segmented_data_logical, 2); % Y dimension size
z_dim = size(segmented_data_logical, 3);  % Z dimension size

% Define the bottom 5 layers to place the ellipse
bottom_layers = 1:8;

% Define the ellipse parameters
ellipse_buffer = 1.5;
a = (x_dim - 1) / 2 - ellipse_buffer; % Semi-major axis length (half the width of the matrix)
b = (y_dim - 1) / 2 - ellipse_buffer; % Semi-minor axis length (half the height of the matrix)
x_center = (x_dim + 1) / 2;
y_center = (y_dim + 1) / 2;

% Generate the ellipse
[X, Y] = meshgrid(1:x_dim, 1:y_dim);
ellipse = ((X - x_center) / a).^2 + ((Y - y_center) / b).^2 <= 1;

% Place the ellipse at Z=0 layer
for z = bottom_layers
    segmented_data_logical(:,:,z) = ellipse';
end

% Visualise the matrix (optional)
for z = 1:z_dim
    imagesc(segmented_data_logical(:,:,z));
    axis equal;
    title(['Layer ', num2str(z)]);
    colorbar; % Add colour bar to indicate values
    colormap([0 0 0; 1 1 1]); % Map 0 to white and 1 to black
    pause(0); % Pause to visualize each layer
end

%% Export to mat file
save(sprintf('segmented_data_%s.mat', subject_name), 'segmented_data_logical')

%% Export to STL
smoothing_parameters = struct('mode',1, 'itt',10, 'lambda',0.1, 'sigma',0.1);

ExportVoxelData(segmented_data_logical,... 'smoothing', smoothing_parameters,...
    'mesh_name', sprintf('processed_brain_%s', subject_name), 'output_dir', 'data_processed', 'pov', false);
