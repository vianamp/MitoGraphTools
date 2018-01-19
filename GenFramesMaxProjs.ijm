// ==========================================================================
// Matheus Viana - vianamp@gmail.com - 01.19.2018
// ==========================================================================

// This macro is used to generate a z-stack where each slice corresponds to
// the max projection of a z-stack. The z-stack generated here is used to
// draw ROIs around the cells you want to analyze individually with MitoGraph.
// 
// USING THIS MACRO:
// 
// 1. Click run to execute the macro
// 2. Select the folder that contains the original z-stacks A file name
// 3. A file named MaxProjs.tif will be created inside the chosen folder
// ==========================================================================

_RootFolder = getDirectory("Choose a Directory");

item = 0;
ntiff = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		if (ntiff==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],".tif") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "MaxProjs.tif");
