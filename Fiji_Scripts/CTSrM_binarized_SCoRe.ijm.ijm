directory = getDirectory("");
waitForUser("Open rec5wk score");
//rec5wk roi 0
//getDimensions(w,h,c,s,f);
makeRectangle(820, 1240, 485, 485);
waitForUser("");
roiManager("Add");
currslice = getSliceNumber();
bot0 = toString(currslice + 10);
top0 = toString(currslice);
run("Duplicate...", "duplicate range="+top0+"-"+bot0);
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", directory + "rec5wk_ROI_0.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Invert LUT");
saveAs("Tiff", directory + "binary_rec5wk_ROI_0.tif");
run("Set Measurements...", "area mean integrated redirect=None decimal=5");
run("Measure");
close();
close();

//rec5wk roi 1
makeRectangle(820, 1240, 485, 485);
waitForUser("");
roiManager("Add");
currslice = getSliceNumber();
bot1 = toString(currslice + 10);
top1 = toString(currslice);
run("Duplicate...", "duplicate range="+top1+"-"+bot1);
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", directory + "rec5wk_ROI_1.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Invert LUT");
saveAs("Tiff", directory + "binary_rec5wk_ROI_1.tif");
run("Set Measurements...", "area mean integrated redirect=None decimal=5");
run("Measure");
close();
close();
close(); 

//bsln roi 0
waitForUser("Open bsln score");
roiManager("Select", 0);
waitForUser("move to top");
currslice = getSliceNumber();
run("Duplicate...", "duplicate range="+top0+"-"+bot0);
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", directory + "bsln_ROI_0.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Invert LUT");
saveAs("Tiff", directory + "binary_bsln_ROI_0.tif");
run("Set Measurements...", "area mean integrated redirect=None decimal=5");
run("Measure");
close();
close();

//bsln roi 1
roiManager("Select", 1);
waitForUser("move to top");
currslice = getSliceNumber();
run("Duplicate...", "duplicate range="+top1+"-"+bot1);
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", directory + "bsln_ROI_1.tif");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Invert LUT");
saveAs("Tiff", directory + "binary_bsln_ROI_1.tif");
run("Set Measurements...", "area mean integrated redirect=None decimal=5");
run("Measure");
close();
close();
close();

roiManager("Select", newArray(0,1));
roiManager("Save", directory + "RoiSet.zip");
roiManager("Delete");

saveAs("Results", directory + "Results.csv");