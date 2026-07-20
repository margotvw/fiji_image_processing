//NOTE: to do beforehand: put all images that need to be edited in the same folder.
//choose this folder when asked to. The number of channels needs to be the same for all images.

dir = getDirectory( "Choose the Directory" );
list = getFileList(dir);
//Choose the folder with the images and make a list of its contents

newdir = getDirectory("Choose a Destination Folder");

extensions = newArray("tiff","jpeg","png", "raw");
colours = newArray("Blue","Cyan","Green", "Red", "Magenta", "Grays", "Yellow");
channels = newArray("C1","C2","C3","C4");
slice_array = newArray("Individual channels only","Merged channels only","Individual and merged channels");
slice_answer = "No slices";

//Create some arrays to store choices in for the dialog boxes


Dialog.create("Specify number of channels:");
Dialog.addNumber("Number of channels present:",2);
Dialog.addNumber("Number of channels for analysis:",2);
Dialog.addChoice("Choose new extension:", extensions);
Dialog.show();
newextension = Dialog.getChoice();
numberofchannels = Dialog.getNumber();
if (numberofchannels > 4) exit ("The maximum number of channels is 4");
wantednumberofchannels = Dialog.getNumber();
diff = numberofchannels - wantednumberofchannels;

//Ask the user for the new extension, the number of channels present and the number he/she wants to process. If this is not the same, diff > 0. 


if (diff > 0){
	Dialog.create("Specify which channels you want to include:");
	Dialog.addChoice("Choose the first channel:", channels);
	Dialog.addChoice("Choose the second channel (if applicable):", channels);
	if (wantednumberofchannels == 3){
		Dialog.addChoice("Choose the third channel:", channels);
		}
	//Dialog.addChoice("Choose if you want to save the individual channels:",indiv_choice);
	Dialog.show();
	wantedfirstchannel = Dialog.getChoice();
	wantedsecondchannel = Dialog.getChoice();
	//indiv_answer = Dialog.getChoice();
		if (wantednumberofchannels == 3){
			wantedthirdchannel = Dialog.getChoice();
		}
		else{
			wantedthirdchannel = "random";
		}
	}
	
indiv_answer = getBoolean("Do you want to save the individual channels?");
slice_yesno = getBoolean("Do you want to save a specific slice?");
if (slice_yesno == 1){
	Dialog.create("Specify which slices you want to include:");
	Dialog.addNumber("Number of slice:", 1);
	Dialog.addChoice("Type of slice:", slice_array);
	Dialog.show();
	slice_number = Dialog.getNumber();
	slice_answer = Dialog.getChoice();
}

	Dialog.create("Min and Max. NOTE: C1 = WANTED C1");
	Dialog.addNumber("Min C1:", 0);
	Dialog.addNumber("Max C1:",255);
	Dialog.addChoice("Choose colour C1:", colours);
	Dialog.addNumber("Min C2:", 0);
	Dialog.addNumber("Max C2:",255);
	Dialog.addChoice("Choose colour C2:", colours);
	Dialog.addNumber("Min C3:", 0);
	Dialog.addNumber("Max C3:",255);
	Dialog.addChoice("Choose colour C3:", colours);
	Dialog.addNumber("Min C4:", 0);
	Dialog.addNumber("Max C4:",255);
	Dialog.addChoice("Choose colour C4:", colours);
	Dialog.show();
	min1 = Dialog.getNumber();
	max1 = Dialog.getNumber();
	colour1 = Dialog.getChoice();
	min2 = Dialog.getNumber();
	max2 = Dialog.getNumber();
	colour2 = Dialog.getChoice();
	min3 = Dialog.getNumber();
	max3 = Dialog.getNumber();
	colour3 = Dialog.getChoice();
	min4 = Dialog.getNumber();
	max4 = Dialog.getNumber();
	colour4 = Dialog.getChoice();

setBatchMode(true);

//If the number of channels wanted is different from the number  present, ask the user which channels should be used. The string C1, C2, C3 or C4 
//is stored the variable wantedfirstchannel, wantedsecondchannel and wantedthirdchannel. By default if there are four channels (the maximum), diff = 0. 
//If only two channels are wanted, store the string 'random' for the third channel, otherwise this variable will be empty causing an error.
setBatchMode(true);
for ( i=0; i<list.length; i++ ){
	open( dir + list[i] );
	getDimensions(dummy, dummy, nChannels, dummy, dummy);
	if (nChannels != numberofchannels) exit ("The number of channels should be the same for each image in the folder");
	run("Split Channels");	
	}

//Next, the channels of the images are splitted..

first_channel_id = newArray(nImages/numberofchannels);
first_channel_name = newArray(nImages/numberofchannels);
second_channel_id = newArray(nImages/numberofchannels);
second_channel_name = newArray(nImages/numberofchannels);
third_channel_id = newArray(nImages/numberofchannels);
third_channel_name = newArray(nImages/numberofchannels);
fourth_channel_id = newArray(nImages/numberofchannels);
fourth_channel_name = newArray(nImages/numberofchannels);
//Create 8 arrays: for each possible channel, one with ids (unique for each image) and one with names (of the format C1-name, C2-name, etc.)

m1=0;
m2=0;
m3=0;
m4=0;
//initialize some variables

for (i=0; i<nImages; i++){
 	selectImage(i+1);
 	title = getTitle();
	if (diff>0){
		firstans = startsWith(title, wantedfirstchannel); 
		secondans = startsWith(title, wantedsecondchannel);
		thirdans = startsWith(title, wantedthirdchannel);
		fourthans = startsWith(title, "random");
		//fourthans is put randomly to keep it empty. If diff>0, there will never be a fourth channel that needs to be processed.
		}
	else{
		firstans = startsWith(title,"C1"); 
		secondans = startsWith(title,"C2");
		thirdans = startsWith(title,"C3");
		fourthans = startsWith(title,"C4");  
		}
	if (firstans == 1){	
		first_channel_id[m1] = getImageID();
		first_channel_name[m1] = getTitle();
		m1 = m1 +1;
		}
	if (secondans == 1){	
		second_channel_id[m2] = getImageID();
		second_channel_name[m2] = getTitle();
		m2 = m2+1;
		}
	if (thirdans == 1){	
		third_channel_id[m3] = getImageID();
		third_channel_name[m3] = getTitle();
		m3 = m3+1;
		}
	if (fourthans == 1){	
		fourth_channel_id[m4] = getImageID();
		fourth_channel_name[m4] = getTitle();
		m4 = m4+1;
		}
	}

//Select each image one at a time. For each image, determine which channel it is by looking at what the title starts with.
//diff = 0: if the channel starts with C1, it is the first channel, if it starts with C2 it is the second channel, etc.
//diff > 0: if the channel starts with C1, put it into the array the user indicated previously, etc.

var done = false;
//Continue the code untill done = true

if (!done){
	for (i=0; i<first_channel_id.length; i++){
	selectImage(first_channel_id[i]);
		for (j=1; j<=nSlices; j++){
			setSlice(j);
			setMinAndMax(min1, max1);
			run(colour1);
			}
		 	//Propagate the values to all other images in the stack
		if (indiv_answer == 1 || wantednumberofchannels == 1){	
			selectImage(first_channel_id[i]);
			run("Duplicate...", "duplicate");
			title = getTitle();
			replacedtitle = replace(title, "C1-", "");
			newtitle = replace(replacedtitle, ".tif", "") + "_channel1";
			saveAs(newextension, newdir+newtitle);
			//Save individual channel if needed
			if (slice_answer == "Individual and merged channels" || slice_answer == "Individual channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
			close();
			if (wantednumberofchannels == 1){
				done = true;
				}
				//Save specific slice of individual channel if needed
			}
		}
	}
	
	
if (!done){
	for (i=0; i<second_channel_id.length; i++){
	selectImage(second_channel_id[i]);
		for (j=1; j<=nSlices; j++){
			setSlice(j);
			setMinAndMax(min2, max2);
			run(colour2);
			}
			 //Propagate the values to all other images in the stack
		if (indiv_answer == 1){	
			selectImage(second_channel_id[i]);
			run("Duplicate...", "duplicate");
			title = getTitle();
			replacedtitle = replace(title, "C2-", "");
			newtitle = replace(replacedtitle, ".tif", "") + "_channel2";
			saveAs(newextension, newdir+newtitle);
			//Save individual channel if needed
		if (slice_answer == "Individual and merged channels" || slice_answer == "Individual channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
			close();
			//Save specific slice of individual channel if needed
			}
		}
}

if (wantednumberofchannels == 2){
	done = true;
	//If two channels were wanted, done becomes true and no other if statements are executed
	z = list.length;
 	for (i=0; i<z; i++){
 		window_name = first_channel_name[i];
 		selectWindow(window_name);
 		title = getTitle();
		run("Merge Channels...", "c1=[" + first_channel_name[i] + "] c2=[" + second_channel_name[i] + "] create ");
		run("RGB Color", "slices keep");
		//Merge and flatten the right images by selecting all the first image names from the first and second channel name arrays, then the second ones, etc.
		replacedtitle = replace(title, ".tif", "");
		newtitle = replacedtitle + "_merged";
		saveAs(newextension, newdir+newtitle);
		print(newtitle);
		if (slice_answer == "Individual and merged channels" || slice_answer == "Merged channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}

		close();
		//Save image
		}
	}

if (!done){
	for (i=0; i<third_channel_id.length; i++){
	selectImage(third_channel_id[i]);
		for (j=1; j<=nSlices; j++){
			setSlice(j);
			setMinAndMax(min3, max3);
			run(colour3);
			}
			 //Propagate the values to all other images in the stack
		if (indiv_answer == 1){	
			selectImage(third_channel_id[i]);
			run("Duplicate...", "duplicate");
			title = getTitle();
			replacedtitle = replace(title, "C3-", "");
			newtitle = replace(replacedtitle, ".tif", "") + "_channel3";
			saveAs(newextension, newdir+newtitle);
			//Save individual channel if needed
		if (slice_answer == "Individual and merged channels" || slice_answer == "Individual channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
			close();
			//Save specific slice of individual channel if needed
			}
		}
}

if (wantednumberofchannels == 3){
	done = true;
	z = list.length;
 	for (i=0; i<z; i++){
 		window_name = first_channel_name[i];
 		selectWindow(window_name);
 		title = getTitle();
		run("Merge Channels...", "c1=[" + first_channel_name[i] + "] c2=[" + second_channel_name[i] + "] c3=[" + third_channel_name[i] + "] create ");
		run("RGB Color", "slices keep");
		replacedtitle = replace(title, "C3-","");
		replacedtitle = replace(title, ".tif", "");
		newtitle = replacedtitle + "_merged";
		saveAs(newextension, newdir+newtitle);
		if (slice_answer == "Individual and merged channels" || slice_answer == "Merged channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
		print(newtitle);
		close();
		}
	}
	
if (!done){
	for (i=0; i<fourth_channel_id.length; i++){
	selectImage(fourth_channel_id[i]);
		for (j=1; j<=nSlices; j++){
			setSlice(j);
			setMinAndMax(min4, max4);
			run(colour4);
			}
			 //Propagate the values to all other images in the stack
		if (indiv_answer == 1){	
			selectImage(fourth_channel_id[i]);
			run("Duplicate...", "duplicate");
			title = getTitle();
			replacedtitle = replace(title, "C4-", "");
			newtitle = replace(replacedtitle, ".tif", "") + "_channel4";
			saveAs(newextension, newdir+newtitle);
			//Save individual channel if needed
			if (slice_answer == "Individual and merged channels" || slice_answer == "Individual channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
			close();
			//Save specific slice of individual channel if needed
			}
		}
}

	
if (wantednumberofchannels == 4){
	done = true;
	z = list.length;
 	for (i=0; i<z; i++){
 		window_name = first_channel_name[i];
 		selectWindow(window_name);
 		title = getTitle();
		run("Merge Channels...", "c1=[" + first_channel_name[i] + "] c2=[" + second_channel_name[i] + "] c3=[" + third_channel_name[i] + "] c4=[" + fourth_channel_name[i] + "]");
		run("RGB Color", "slices keep");
		replacedtitle = replace(title, "C4-","");
		newtitle = replace(title, ".tif", "") + "_merged";
		saveAs(newextension, newdir+newtitle);
		print(newtitle);
		if (slice_answer == "Individual and merged channels" || slice_answer == "Merged channels only"){
				setSlice(slice_number);
				run("Duplicate...", "use");
				slicetitle = newtitle + "_slice" + slice_number;
				saveAs(newextension, newdir+slicetitle);
				}
		close();
	}
}