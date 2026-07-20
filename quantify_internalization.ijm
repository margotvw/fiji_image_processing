//NOTE: Before running the macro, check the NOTES and make changes if necessary
dir1 = getDirectory("Choose Source Directory ");
dir3 = getDirectory("Choose Destination Directory for ROIs: ");
list = getFileList(dir1);
//Runs macro in Batchmode; does not actually open the images. Speeds up the process.
//setBatchMode(true);
roiManager("reset");

//Open and write to this excel file (saved on desktop)
run("Read and Write Excel", "file_mode=read_and_open file=[C:/Users/margot/Documents/My_file.xlsx] ");
print("Opened file");

run("Set Measurements...", "area integrated limit redirect=None decimal=8");

total_cells = 0;


for (i=0; i<list.length; i++) {
	showProgress(i+1, list.length);
 	open(dir1+list[i]);
 	orititle = getTitle();
 	run("Split Channels");
	//Remove slices from each channel and subtract background
	for (j=0;j<nImages;j++) {
		selectImage(j+1);
		//NOTE: change if needed!
		run("Slice Remover", "first=1 last=1 increment=1");
		run("Slice Remover", "first=2 last=4  increment=1");
		run("Subtract Background...", "rolling=300 disable stack");
		
	}
	for (k=0;k<nImages;k++) {
		selectImage(k+1);
		title = getTitle();
		if (startsWith(title, "C3") == true){
		 	roiManager("reset");
		 	nr_slices = nSlices;
		 	C3title = getTitle();
		 	C3id = getImageID();
			for (j=0; j<nr_slices; j++) {
				selectImage(C3id);
				setSlice(j+1);
				run("Duplicate...", "duplicate channels=&greenChannel slices=&j");			
				run("Gaussian Blur...", "sigma=5");
				setAutoThreshold("Triangle dark");
				run("Analyze Particles...", "size=50-Infinity circularity=0.70-1.00 include add");
				SliceID = getImageID();
				count = roiManager("count");
				print("Slice " + j + " count " + count);
				countarray = Array.getSequence(count);
				for (m=0; m<count; m++) {
					if (count == 0){
						break;
						}
					else {
						roiManager("Select", m);
						run("Scale... ", "x=1.1 y=1.1 centered");
						roiManager("update");					
						roiManager("Save", dir3 + C3title + " slice" + j + "_RoiSet.zip");		
						}
					}
				roiManager("reset")	;
				selectImage(SliceID);
				close();	
				}
			}
		}
		for (k=0;k<nImages;k++) {
			selectImage(k+1);
			title = getTitle();		
			//NOTE: Change channel if first coloc channel is not C2
			if (startsWith(title, "C2") == true){		
				setAutoThreshold("RenyiEntropy dark no-reset");
				run("Convert to Mask", "method=RenyiEntropy background=Dark");		
				for (p=0; p<nSlices; p++) {
					setSlice(p+1);
					does_file_exist = File.exists(dir3 + C3title + " slice" + p + "_RoiSet.zip");
					if (does_file_exist == 1){
						open(dir3 + C3title + " slice" + p + "_RoiSet.zip");
						count2 = roiManager("count");
						for (m=0; m<count2; m++) {
							roiManager("Select", m);
							run("Measure");
							//area = getResult("IntDen", m);
							//print(area);
						}			
						run("Read and Write Excel", "file_mode=queue_write stack_results");
						//run("Read and Write Excel", "file_mode=queue_write stack_results sheet=" + orititle);
						run("Clear Results");
						roiManager("reset")	;
					}
				}
				
			}
		}
	//Close all open files
	for (c=0;c<nImages;c++) {
		while (nImages > 0){
		selectImage(c+1);
		run("Close");
			}
		}
	}

run("Read and Write Excel", "file_mode=write_and_close");	
print("Closed file");	


