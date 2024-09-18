# Set folder name to the to be segmented data
folder_name=kenneth
subfolder_name=freesurfer_output/3d_model
full_folder_path=/home/affneu/kenvdzee/printing_brains/${folder_name}

# See if this works
source /opt/freesurfer/7.3.2/SetUpFreeSurfer.sh
module load freesurfer

# Set export folder location
export SUBJECTS_DIR=full_folder_path

# Start the main freesurfer pipeline
recon-all -i /SUBJECTS_DIR/${folder_name}_T1w.nii.gz -s freesurfer_output -all -cw256

# Extract the cerebellum and brainstem from file containing subcortical surfacemaps
mri_binarize --i /${full_folder_path}/freesurfer_output/mri/aseg.mgz --match 7 8 16 46 47 28 60 --o ${full_folder_path}/${subfolder_name}/brainstem_cerebellum.mgz

# Convert this to a surfacemap of the cerebellum and brainstem
mri_tessellate /${full_folder_path}/${subfolder_name}/brainstem_cerebellum.mgz 1 /${full_folder_path}/${subfolder_name}/brainstem_cerebellum_boxy

# Smooth the cerebellum and brainstem
mris_smooth /${full_folder_path}/${subfolder_name}/brainstem_cerebellum_boxy /${full_folder_path}/${subfolder_name}/brainstem_cerebellum_surface

# Create STL files of the brainstem and cerebellum, the left and the right hemisphere of the cortex
mris_convert /${full_folder_path}/freesurfer_output/surf/lh.pial /${full_folder_path}/${subfolder_name}/lelf_hemisphere.stl
mris_convert /${full_folder_path}/freesurfer_output/surf/rh.pial /${full_folder_path}/${subfolder_name}/right_hemisphere.stl
mris_convert /${full_folder_path}/${subfolder_name}/brainstem_cerebellum_surface /${full_folder_path}/${subfolder_name}/brainstem_cerebellum_surface.stl