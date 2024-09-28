# scan_to_stl
Simple script and dependencies to translate segmented files based on T1 and T2 scans to STL files for a 3D printer.


## How to use
1. Ensure Freesurfer and Matlab are installed.
2. Change the file and foldernames to fit the template.
3. Run the Matlab script.
4. Check if the freesurfer segmentation was succesfull by manually opening the STL files (the cerebellum + brainstem, the left and the right hemisphere) in the output folder.
5. Place all three stl files in one file in Fusion 360 without and export them as one stl file without moving any of the components. This should result in an STL file that attached all three brain conponents to each other.
6. Export this STL file and then reimport it into Fusion 360.
7. Check if the file needs to be rescaled. STL files have a sendency to open at a 10x or 100x size in Fusion 360.
8. Then place that file in the `extrude_holes_template` at a height of 2cm.
9. Then turn the brain into a mesh, this step might take a minute.
10. After this, extrude the holes at a depth of 150mm. An example of that extrusion is shown in the `extrude_holes_example` file.
11. Then export this file to an STL again. This is your final version of the brain.
12. Reimport this again into Fusion and check wheter scaling is necessary.
13. Now open the `stand_template` to adjust the name and check the hole placement inside the brain.
14. Find the text in the timeline and change it to whatever you want.
15. Optionally, you can also change the onset of the slope around the words in case the name is longer or shorter than the one used in the template. Do make sure that you leave enough space between sketch planes for large enough ramp.
16. Now place the brain in this file at a height of 20mm above the origin and manually check whether it's holes align with the stems on the stand.