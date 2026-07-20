newdir = getDirectory("Choose a Directory");

for (i=0;i<nImages;i++) {
	selectImage(i+1);
	title = getTitle();
	newtitle = replace(title,"24018_livecellimaging.lif - ","");
	//newnewtitle = replace(newtitle, "TileScan_004", "tilescan_" + i);
	saveAs("tiff", newdir+newtitle);

}