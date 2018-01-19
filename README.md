# MitoGraphAuxiliar
ImageJ macros to help you prepare your data to use with MitoGraph and example dataset

Matheus Viana - vianamp@gmail.com - 01.19.2018

## Download

To download our example dataset and ImageJ macros, please click here.

## Example Dataset

We made availabe five images of mitochondria in budding yeast cells grown in glucose. These cells have been imaged in a spinning disk confocal microscope and their pixel size is `0.056x0.056x0.200µm`. Running MitoGraph with 

```
MitoGraph -xy 0.056 -z 0.2 -path path/to/example/dataset
```
on these images you should be able to get these values:

| File | Volume from voxels (µm3) | Average width (µm) | Std width (µm) | Total length (µm) | Volume from length (µm3)|
|------|:------------------------:|:------------------:|:--------------:|:-----------------:|:-----------------------:|
|BuddingYeastGlucose05 | 4.23674	| 0.22246	| 0.03501	| 46.57995	| 3.29254|
|BuddingYeastGlucose05 | 5.23900	| 0.22189	| 0.03842	| 55.27222	| 3.90696|
|BuddingYeastGlucose05 | 2.03777	| 0.24329	| 0.03732	| 15.97084	| 1.12891|
|BuddingYeastGlucose05 | 2.54079	| 0.24168	| 0.03439	| 23.62560	| 1.67000|
|BuddingYeastGlucose05 | 2.01331	| 0.23770	| 0.04171	| 16.01066	| 1.13173|

## ImageJ Macros

### GenFramesMaxProjs.ijm

This macro is used to generate a z-stack where each slice corresponds to the max projection of a z-stack. The z-stack generated here is used to draw ROIs around the cells you want to analyze individually with MitoGraph.

USING THIS MACRO:

1. Click run to execute the macro
2. Select the folder that contains the original z-stacks
3. A file named __MaxProjs.tif__ will be created inside the chosen folder

### CropCells.ijm

This macro is used to create single cells z-stacks similar to the one available in the example dataset.

BEFORE USING THIS MACRO:

1. Use the macro GenFramesMaxProjs.ijm to generate the z-stack __MaxProjs.tif__
2. Use the z-stack __MaxProjs.tiff__ to drawn ROIs around the cells that you want to crop
3. Save the ROIs as __RoiSet.zip__

USING THIS MACRO:

1. Click run to execute the macro
2. Select the size of the single cell images you want to create. The default value should be fine for images of mitochondria of yeast cells. You may want to increase this value if your cells are bigger (e.g. mammalian cells).
3. Select the folder that contains the original z-stacks, the file __RoiSet.zip__ and the file __MaxProjs.tiff__
4. A subfolder called __cells__ will be create and should be used as input for MitoGraph
