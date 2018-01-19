// ==========================================================================
// Matheus Viana - vianamp@gmail.com - 01.19.2018
// ==========================================================================
//
// This macro is used to create single cells z-stacks similar to the one available
// in the example dataset.
//
// BEFORE USING THIS MACRO:
// ------------------------
// 1. Use the macro GenFramesMaxProjs.ijm to generate the z-stack MaxProjs.tiff
// 2. Use the z-stack MaxProjs.tiff to drawn ROIs around the cells that you want
//    to crop
// 3. Save the ROIs as RoiSet.zip
//
// USING THIS MACRO:
// ------------------------
// 1. Click run to execute the macro
// 2. Select the size of the single cell images you want to create. The default
// value should be fine for images of mitochondria of yeast cells. You may want
// to increase this value if your cells are bigger (mammalian cells).
// 3. Select the folder that contains the original z-stacks, the file RoiSet.zip
// and the file MaxProjs.tiff
// 4. A subfolder called "cells" will be create and should be used as input for
// MitoGraph
// ==========================================================================

// Defining the size in pixels of the single cell z-stacks
_xy = getNumber("Single cell image size in pixels", 200);

_RootFolder = getDirectory("Choose a Directory");

// Creating a directory where the files are saved
File.makeDirectory(_RootFolder + "cells");

setBatchMode(true);

run("ROI Manager...");
roiManager("Reset");
roiManager("Open",_RootFolder + "RoiSet.zip");

open("MaxProjs.tif");
MAXP = getImageID;

// For each ROI (cell)
for (roi = 0; roi < roiManager("count"); roi++) {
			
	roiManager("Select",roi);
	_FileName = getInfo("slice.label");
	_FileName = replace(_FileName,".tif","@");
	_FileName = split(_FileName,"@");
	_FileName = _FileName[0];

	open(_FileName + ".tif");
	ORIGINAL = getImageID;

	run("Restore Selection");

	newImage("CELL","16-bit Black",_xy,_xy,nSlices);
	CELL = getImageID;

	// Estimating the noise distribution around the ROI
	max_ai = 0;
	for (s = 1; s <= nSlices; s++) {
		selectImage(MAXP);
		
		selectImage(ORIGINAL);
		setSlice(s);
		run("Restore Selection");
		run("Make Band...", "band=5");
		getStatistics(area, mean, min, max, std);
		run("Restore Selection");
		run("Copy");
		
		selectImage(CELL);
		setSlice(s);
		run("Select None");		
		run("Add...", "value=" + mean + " slice");
		run("Add Specified Noise...", "slice standard=" + 0.5*std);
		run("Paste");
		
		getStatistics(area, mean, min, max, std);
		if (mean>max_ai) {
			max_ai = mean;
			slice_max_ai = s;
		}
		
	}
	
	run("Select None");
	resetMinAndMax();

	save(_RootFolder + "cells/" + _FileName + "_" + IJ.pad(roi,3) + ".tif");

	selectImage(CELL); close();
	selectImage(ORIGINAL); close();

}

selectImage(MAXP); close();

setBatchMode(false);

print("Cell croppping is complete.");
