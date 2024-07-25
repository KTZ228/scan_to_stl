clear, clc, close all

%% The following variables can be enabled or adjusted to ensure the model uses
% a brain that is straight up and is not suspended by a really long brainstem.
rotate_brain = false;
rotation_order = [3,1,2]; % notes the new order of the x, y and z axes

% Determine how many layers are removed at the bottom
% Try to ensure that the cerebellum just touches the stand
suspension_height = 70;

%% Load data and turn neural tissue into logical
addpath(genpath('ExportVoxelData'))

subject_name = 'kenneth';
filename = sprintf('data_raw/final_tissues_%s.nii.gz', subject_name);

segmented_data = niftiread(filename);
segmented_data_info = niftiinfo(filename);
disp(segmented_data_info.PixelDimensions);

segmented_data(segmented_data==2) = 1;
segmented_data(segmented_data~=1) = 0;

segmented_data_logical = logical(segmented_data);

%% Rotate if necessary
if rotate_brain == true
    segmented_data_logical = permute(segmented_data_logical, rotation_order);
end

%% Limit array size
% Find the bounds
[xIndices, yIndices, zIndices] = ind2sub(size(segmented_data_logical), find(segmented_data_logical));

skull_buffer = 4;
xMin = min(xIndices);
xMax = max(xIndices);
yMin = min(yIndices);
yMax = max(yIndices);
zMin = min(zIndices) + suspension_height;
zMax = max(zIndices);

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

% Visualise the matrix
for z = 1:z_dim
    imagesc(segmented_data_logical(:,:,z));
    axis equal;
    title(['Layer ', num2str(z)]);
    colorbar; % Add colour bar to indicate values
    colormap([0 0 0; 1 1 1]); % Map 0 to white and 1 to black
    pause(0); % Pause to visualize each layer
end

segmented_data_size_buffer = size(segmented_data_logical) + 10;

%% Export to mat file
%save(sprintf('segmented_data_%s.mat', subject_name), 'segmented_data_logical')

%% Export to STL
if rotate_brain == true
    voxel_size_list = segmented_data_info.PixelDimensions(rotation_order);
    output_name = sprintf('processed_brain_%s_x%.4f_y%.4f_z%.4f', subject_name, voxel_size_list(1), voxel_size_list(2), voxel_size_list(3));
else
    voxel_size_list = segmented_data_info.PixelDimensions;
    output_name = sprintf('processed_brain_%s_x%.4f_y%.4f_z%.4f', subject_name, voxel_size_list(1), voxel_size_list(2), voxel_size_list(3));
end

% These are optimised for 3T files segmented by Charm
smoothing_parameters = struct('mode',1, 'itt',100, 'lambda',0.05, 'sigma',1);

ExportVoxelData(segmented_data_logical, 'method', 'geometric', 'smoothing', smoothing_parameters,...
    'mesh_name', output_name, 'output_dir', 'data_processed', ...
    'img_dim', segmented_data_size_buffer, 'pov', false);
