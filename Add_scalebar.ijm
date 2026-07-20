dir = getDirectory( "Choose the Directory" );
list = getFileList( dir );
for ( i=0; i<list.length; i++ ) {
    open( dir + list[i] );
}
waitForUser("Close any images that you don't want to edit");
newdir = getDirectory("Choose a new Directory");

for (i=0; i<nImages; i++){
	selectImage(i+1);
	title = getTitle();
	path = newdir+title;
	getPixelSize(mm, pw, ph, pd);
	resolution = 1/pw;
	run("Set Scale...", "distance=resolution known=1 pixel=1 unit=micron");		
	run("Scale Bar...", "width=20 height=10 font=50 color=White background=None location=[Lower Right] bold label");
	save(path);
	close();
}


