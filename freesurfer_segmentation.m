%% Set the subject_name according to the template 'number_name'
% This is the only thing you should change if you formatted the names correctly
subject_name = '2_hilde';

%% Start segmentation
input_location = sprintf('%s/data_raw', pwd);
input_name_and_location = sprintf('%s/%s_T1w.nii.gz', input_location, subject_name);
output_location = sprintf('%s/data_processed', pwd);
output_location_subject = sprintf('%s/%s', output_location, subject_name);
output_location_subject_tmp = sprintf('%s/tmp', output_location_subject);
output_location_subject_stl = sprintf('%s/stl', output_location_subject);

% Load correct version of freesurfer
system('source /opt/freesurfer/7.3.2/SetUpFreeSurfer.sh');
system('module load freesurfer');

% Send output location to freesurfer
setenv('SUBJECTS_DIR', output_location);

%% Start the recon-all pipeline from freesurfer
system(sprintf('recon-all -i %s -s %s -all -cw256', input_name_and_location, subject_name));

%% Extract the cerebellum and brainstem
% Extracts and combine them as one voxel object since surface maps don't exist
system(sprintf('mri_binarize --i %s/mri/aseg.mgz --match 7 8 16 46 47 28 60 --o %s/brainstem_cerebellum.mgz', output_location_subject, output_location_subject_tmp));

% Convert this to a boxy surface map
system(sprintf('mri_tessellate %s/brainstem_cerebellum.mgz 1 %s/brainstem_cerebellum_boxy', output_location_subject_tmp, output_location_subject_tmp));

% Smooth this boxy surface map to give the illusion of it being properly mapped as a surface
system(sprintf('mris_smooth %s/brainstem_cerebellum_boxy %s/brainstem_cerebellum_surface', output_location_subject_tmp, output_location_subject_tmp));

%% Convert these surface maps to STL files
mkdir(output_location_subject_stl);
% First for the left and the right hemisphere of the cortex
system(sprintf('mris_convert %s/surf/lh.pial %s/left_hemisphere.stl', output_location_subject, output_location_subject_stl));
system(sprintf('mris_convert %s/surf/rh.pial %s/right_hemisphere.stl', output_location_subject, output_location_subject_stl));
% And now for the brainstem and cerebellum
system(sprintf('mris_convert %s/brainstem_cerebellum_surface %s/brainstem_cerebellum_surface.stl', output_location_subject_tmp, output_location_subject_stl));