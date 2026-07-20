//NOTE: Before running the macro, check the NOTES and make changes if necessary
dir1 = getDirectory("Choose Source Directory ");
dir2 = getDirectory("Choose Destination Directory for individual cells: ");
dir3 = getDirectory("Choose Destination Directory for ROIs: ");
list = getFileList(dir1);
//Runs macro in Batchmode; does not actually open the images. Speeds up the process.
setBatchMode(true);
roiManager("reset");

total_cells = 0;


for (i=0; i<list.length; i++) {
	e = 0;	
 	showProgress(i+1, list.length);
 	open(dir1+list[i]);
 	roiManager("reset");
 	originalID = getImageID();
 	title = getTitle();
 	//NOTE: CHANGE TO NUMBER OF GREEN CHANNEL
 	greenChannel = 3;
 	setSlice(greenChannel);
	run("Duplicate...", "duplicate channels=3");
	greenID = getImageID();
	run("Z Project...", "projection=[Sum Slices]");
	run("Gaussian Blur...", "sigma=5");
	setAutoThreshold("Triangle dark");
	run("Analyze Particles...", "size=3.20-Infinity circularity=0.50-1.00 include add");
	count = roiManager("count");
	countarray = Array.getSequence(count);
	//Turn cell selections into rectangles of the same size
	for (m=0; m<count; m++) {
		if (count == 0){
			break;
			}
		else {
			roiManager("Select", m);
			run("Fit Rectangle");
			roiManager("add");
			roiManager("Select", m + count);
			run("Scale... ", "x=3 y=3 centered");
			//NOTE: change width and height of selection if necessary
			run("Specify...", "width=350 height=350 centered");
			roiManager("update");
			}
		}
	print(count);
	//Delete the original cell selections
	roiManager("Select", countarray);
	roiManager("delete");
	print("deleted old rois");

	//Save the ROIs to a file for future purposes
	roiManager("Save", dir3 + title + "_RoiSet.zip");
	
	//Close the duplicated green channel
	selectImage(greenID);
	close();

	//Duplicate the individual cells with all channels
	selectImage(originalID);
	for (m=0; m<count; m++) {
		roiManager("Select", m);
		run("Duplicate...", "duplicate");
		saveAs("tiff", dir2 + title + "cell" + m);
		close();
		total_cells = total_cells + 1;
		}	
	}