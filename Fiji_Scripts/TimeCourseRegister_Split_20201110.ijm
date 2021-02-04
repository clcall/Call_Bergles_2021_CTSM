directories = newArray("\\\\F:\\Tracing\\Round4\\M7\\Reg2\\");
for ( k=0; k<directories.length; k++ ) { 
	dir = directories[k];
	print(dir);
	savename = File.getName(dir);
	print(savename);
	list = getFileList(dir);
	for ( i=0; i<list.length; i++ ) { 
		open( dir + list[i] );
		trgtslices = 168;
		title = getTitle;
		getDimensions(w,h,channels,slices,frames);
		if (slices < trgtslices) {
			newImage("black","8-bit black",w,h,trgtslices-slices);
			newImage("black1","8-bit black",w,h,trgtslices-slices);
			run("Merge Channels...", "c1=black c2=black1 create");
			run("Concatenate...", "title="+title+" open image1="+title+" image2=Composite image3=[-- None --]");
		}
	} 
	getDimensions(w,h,channels,slices,frames);
	channels = toString(channels);
	slices = toString(slices);
	run("Concatenate...", "all_open title=[Concatenated Stacks] open");
	tp = toString(list.length);
	//calculate stack size (number of frames)
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices=" + slices + " frames=" + tp + " display=Color");
	title = getTitle;
	saveAs("Tiff", dir + title + ".tif");
	a = (w/2)-(w/4);
	b = w/2;
	makeRectangle(a, a, b, b);
	run("Correct 3D drift", "channel=1 only=20 lowest=20 highest=100");
	selectWindow("Concatenated Stacks.tif");
	run("Close");
	
	//save the registered stack and get its name
	saveAs("Tiff", dir + savename + ".tif");
	
	//dir = getDirectory("Choose a Directory");
	//savename = File.nameWithoutExtension;
	
	filepath = dir + savename + ".tif";
	Split(dir,filepath);

	function Split(dir,filepath) {
		splitDir=dir + "\TimeSeriesSplit\\";
		File.makeDirectory(splitDir); 
		//open(filepath);
		imgName=getTitle();
		run("Stack Slicer", "split_timepoints stack_order=XYCZT");
		close(imgName);
		ids=newArray(nImages); 
		for (i=0;i<nImages;i++) { 
			selectImage(i+1);
			title = getTitle;
			print(title);
		    ids[i]=getImageID; 
		    saveAs("Tiff", splitDir + title + ".tif"); 
		} 
		run("Close All");
	}
	print("DONE");
}