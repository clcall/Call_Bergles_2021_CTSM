directory = getDir("");
path = directory + File.separator + "cropped";
File.makeDirectory(path);
rawpath = path + File.separator + "raw";
binpath = path + File.separator + "bin";
File.makeDirectory(rawpath);
File.makeDirectory(binpath);
filelist = getFileList(directory); 
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
        open(directory + File.separator + filelist[i]);
        getPixelSize(unit, pixelWidth, pixelHeight);
        scalefactor = pixelWidth / 0.3765379;
        run("Scale...", "x="+scalefactor+" y="+scalefactor+" z=1.0 interpolation=Bilinear average process create");
        run("Z Project...", "projection=[Max Intensity]");
        getPixelSize(unit, pixelWidth, pixelHeight);
        //getDimensions(w, h);
        width = 250 / pixelWidth;
        makeRectangle(0, 0, width, width);
        run("Crop");
        imgName = getTitle();
        saveAs("Tiff", rawpath + File.separator + "raw_" + imgName);
        run("Convert to Mask");
        saveAs("Tiff", binpath + File.separator + "binary_" + imgName);
        run("Select All");
		run("Measure");
		close("*");
    } 
}



//setThreshold(45, 255);

