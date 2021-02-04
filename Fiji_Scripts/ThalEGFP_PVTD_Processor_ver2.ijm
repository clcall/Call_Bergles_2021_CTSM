directories = newArray("\\\\E:\\thalEGFP_pvTDT_Round4\\M5\\Reg2\\");
for ( k=0; k<directories.length; k++ ) { 
	dir = directories[k];
	ProcImgDir=dir + "\ProcessedImages\\";
	print(ProcImgDir);
	if (File.exists(ProcImgDir)) {
		print("directory already made");
	} else {
		File.makeDirectory(ProcImgDir); 
	}
	list = getFileList(dir);
	for ( i=0; i<list.length; i++ ) { 
		while (File.isDirectory(dir + list[i])) {
			i = i+1;
		}
		open( dir + list[i] ); 
		imgName=getTitle();
		dot = indexOf(imgName,".");
		nameSansExt = substring(imgName,0,dot);
		if (indexOf(imgName, "nm") >= 0) {
			run("Split Channels");
			imageCalculator("Subtract create stack", "C2-"+imgName,"C1-"+imgName);
			selectWindow("C2-"+imgName);
			run("Close"); //get rid of original red channel
			//filter subtracted red channel and close
			run("Median 3D...","X radius=1 Y radius=1 Z radius=1");
			saveAs("Tiff", ProcImgDir + "tdt_" + nameSansExt + "_3D1MedFilt" + ".tif");
			run("Close");
			//filter green channel and close
			run("Median 3D...","X radius=1 Y radius=1 Z radius=1");
			saveAs("Tiff", ProcImgDir + "egfp_" + nameSansExt + "_3D1MedFilt" + ".tif");
		} else { 
			//setMinAndMax(10, 150);
			title = getTitle();
			getDimensions(w,h,channels,slices,frames);
			trgtslices = 111;
			if (slices < trgtslices) {
				newImage("black","8-bit black",w,h,trgtslices-slices);
				newImage("black1","8-bit black",w,h,trgtslices-slices);
				newImage("black2","8-bit black",w,h,trgtslices-slices);
				run("Merge Channels...", "c1=black c2=black1 c3=black2 create");
				run("Concatenate...", "title="+title+" open image1="+title+" image2=Composite image3=[-- None --]");
			}
			run("Subtract Background...", "rolling=15 stack");
			run("Median 3D...","X radius=1 Y radius=1 Z radius=1");
			run("Split Channels");
			imageCalculator("Add create stack", "C1-"+imgName,"C2-"+imgName);
			imageCalculator("Add create stack", "Result of C1-"+imgName, "C3-"+imgName);
			run("Grays");
			saveAs("Tiff", ProcImgDir + nameSansExt + "_combined" + "_3D1MedFilt" + ".tif");
			run("Close All");
		}
	} 
}