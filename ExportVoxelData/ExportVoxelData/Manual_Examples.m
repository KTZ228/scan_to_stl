%% Manual Data
% Script containing code, which shows each option of the ExportVoxelData
% package.
% Refer to Manual_ExportVoxelData.pdf for detailed discussion of each
% example.
clear, clc, close all
cd ExportVoxelData/ExportVoxelData/

%% Create data
% This cell creates data that is used throughout the Manual_Data script

% Make coordinate system
[X,Y,Z] = meshgrid(-249:250); 

% Nonintersecting objects
% Create empty matrix
BW_NI = false(500,500,500); % Black and White image (logical)

% Add Sphere
BW_NI((X-50).^2+(Y-50).^2+(Z+30).^2 <= 400) = true; 

% Add Ellipsoid
BW_NI((X/20).^2+(Y/50).^2+(Z/100).^2 <= 1) = true; 

% Intersecting Objects
% Create empty matrix
BW_I = false(500,500,500);
LM_I = zeros(500,500,500, 'uint8'); % Label matrix

% Add Sphere
BW_I((X-50).^2+(Y-50).^2+(Z+30).^2 <= 10000) = true; 
LM_I((X-50).^2+(Y-50).^2+(Z+30).^2 <= 10000) = 1; 

% Add Ellipsoid
BW_I((X/20).^2+(Y/50).^2+(Z/100).^2 <= 1) = true;
LM_I((X/20).^2+(Y/50).^2+(Z/100).^2 <= 1) = 2;

% Determine voxel list through finding region properties
RP_I = regionprops(LM_I, 'PixelList');

clear X Y Z
%% Input - Logical - Example 1

ExportVoxelData(BW_NI, 'output_dir', 'data_processed');

%% Input - Logical - Example 2

ExportVoxelData(BW_I, 'output_dir', 'data_processed');

%% Input - Label Matrix - Example 3

ExportVoxelData(LM_I, 'output_dir', 'data_processed');

%% Input - Voxel List - Example 4

ExportVoxelData(RP_I, 'output_dir', 'data_processed');

%% Mesh Extraction - Convexhull - Example 5

ExportVoxelData(BW_NI, 'method', 'convhull', 'output_dir', 'data_processed');

%% Mesh Extraction - Convexhull - Example 6

ExportVoxelData(BW_I, 'method', 'convhull', 'output_dir', 'data_processed');

%% Mesh Extraction - Isosurface - Example 7

ExportVoxelData(BW_I, 'method', 'isosurface', 'output_dir', 'data_processed');

%% Mesh Extraction - Geometric - Example 8

ExportVoxelData(BW_I, 'method', 'geometric', 'output_dir', 'data_processed');

%% Mesh Modification - Resampling - Example 9

ExportVoxelData(BW_I, 'resample', 0.2, 'output_dir', 'data_processed');

%% Mesh Modification - Smoothing - Example 10

ExportVoxelData(BW_I, 'smoothing', false, 'output_dir', 'data_processed');

%% Mesh Modification - Smoothing - Example 11

ExportVoxelData(BW_I, 'smoothing', struct('mode',1, 'itt',10, 'lambda',1, 'sigma',1), 'output_dir', 'data_processed');

%% Output - STL only - Example 12

ExportVoxelData(BW_I, 'pov', false, 'output_dir', 'data_processed');

%% Options - mesh_name - Example 13

ExportVoxelData(BW_I, 'mesh_name', 'new_mesh_name', 'output_dir', 'data_processed');

%% Options - output_dir - Example 14

ExportVoxelData(BW_I, 'output_dir', 'data_processed');

%% Options - label_matrix - Example 15

ExportVoxelData(RP_I, 'label_matrix', LM_I, 'output_dir', 'data_processed');

%% Options - object_ids - Example 16

ExportVoxelData(LM_I, 'object_ids', 1, 'output_dir', 'data_processed');

%% Options - shift_origin - Example 17

ExportVoxelData(BW_I, 'shift_origin', 0, 'output_dir', 'data_processed');

%% Options - shift_origin - Example 18

ExportVoxelData(BW_I, 'shift_origin', 1, 'output_dir', 'data_processed');

%% Options - img_dim - Example 19

ExportVoxelData(BW_I, 'img_dim', size(BW_I), 'output_dir', 'data_processed');

%% Options - img_shift - Example 20

ExportVoxelData(BW_I, 'img_shift', [100, 0, 0], 'output_dir', 'data_processed');
