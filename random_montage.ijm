dir1 = getDirectory("Choose Source Directory ");
list = getFileList(dir1);
randomArray = newArray(list.length);
nrandom = 9;
setBatchMode(true);
print(list.length);

for (i=0; i<list.length; i++) {
 	randomArray[i] = i;
}


function shuffle(array) {
   n = array.length;  // The number of items left to shuffle (loop invariant).
   while (n > 1) {
      k = randomInt(n);     // 0 <= k < n.
      n--;                  // n is now the last pertinent index;
      temp = array[n];  // swap array[n] with array[k] (does nothing if k==n).
      array[n] = array[k];
      array[k] = temp;
   } 
}
 
function randomInt(n) {
   return n * random();
}
 
shuffle(randomArray);
//Array.print(randomArray);

 
for (i=0; i<nrandom; i++){
		number = randomArray[i];
	 	open(dir1+list[number]);
	  	print(list[number]);
	}
  
setBatchMode("exit and display");

titleArray = newArray(nImages);
print("\\Clear");

for (k=0;k<nImages;k++) {
	selectImage(k+1);
	titleArray[k] = getTitle();
}

for (k=0;k<titleArray.length;k++) {
	selectImage(titleArray[k]);
	run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
	nr_slices = nSlices/2;
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=&nr_slices frames=1 display=Color");
	title = getTitle();
	run("Split Channels");
	title_C1 = "C1-" + title;
	title_C2 = "C2-" + title;
	run("Merge Channels...", "c1=&title_C1 c2=&title_C2");
	print(k + "_" + title);
	}
	
nr_images = nImages;

titleArray2 = newArray(nImages);

for (k=0;k<nImages;k++) {
	selectImage(k+1);
	titleArray2[k] = getTitle();
}

for (k=0;k<titleArray2.length;k++) {
		selectImage(titleArray2[k]);
		run("Stack to Images");
}

run("Images to Stack", "method=[Scale (largest)] use");
run("Make Montage...", "columns=&nr_slices rows=&nr_images scale=1 border=5 label");