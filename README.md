# scan_to_stl
Simple script and dependencies to translate segmented files based on T1 and T2 scans to STL files for a 3D printer.


## How to use
1. Use Charm (used by SimNIBS) to segment your T1 and T2 structural scans into a nifti file with tissue labels.
2. Ensure that the neural tissues have the labels 1 and 2.
3. Place the 'final_tissues.nii.gz' file in the data_raw folder and add your subject name to the file. 
	- `final_tissues_ernie.nii.gz` for example.
4. Before running the entire script, run the individual sections first to check:
	- If the brain is the right way up. If not, enable `rotate_brain` and change the order of the x, y and z axes in `rotation_order`.
	- Whether the cerebellum touches the base. Try to ensure that the cerebellum just touches the top of the stand by adjusting `suspension_height`.
5. One final thing is that in the translation to STL, it is assumed that the logical voxels are all 1mm<sup>3</sup>. The actual voxel sizes are denoted in the filename.
