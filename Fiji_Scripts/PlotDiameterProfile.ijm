dir=getDirectory("");
//filepath=File.openDialog("Select a file"); 
//open(filepath);
title=getTitle();
prevn=1;
for (ii=0; ii<100; ii++){
	//name the current axon being analyzed with a number (do multiple profiles per axon)
	currn = getNumber("Current axon number", prevn);
	axonNum = toString(currn);
	run("Clear Results");
	//capture a segment of the current axon, single frame
	makeRectangle(830, 807, 345, 355);
	waitForUser("Capture axon segment with ROI");
	slice = getSliceNumber();
	run("Duplicate...", "  slices="+"slice");
	num=toString(ii);
	//create angle
	setTool("angle");
	waitForUser("Make angle from vertical");
	//measure angle and rotate image
	run("Measure");
	angle = getResult("Angle",0);
	run("Rotate...", "angle=-"+angle+" grid=1 interpolation=Bilinear");
	rangle = round(angle);
	str_rangle = toString(rangle);
	ismyel = getNumber("Is current axon myelinated?", 0);
	str_ismyel = toString(ismyel);
	if (currn < 10) {
		ipath = dir+"ax"+"0"+axonNum+"_"+str_ismyel+"_"+num+"_"+str_rangle+"deg"+title;
	} else {
		ipath = dir+"ax"+axonNum+"_"+str_ismyel+"_"+num+"_"+str_rangle+"deg"+title;
	}
	saveAs("Tiff",ipath+".tif");
	//get diameter profile
	run("Split Channels");
	//run("Close");
	setTool("rectangle");
	makeRectangle(121, 114, 96, 100);
	waitForUser("Choose area to plot profile");
  	// Get profile and display values in "Results" window
	run("Clear Results");
	profile = getProfile();
	for (i=0; i<profile.length; i++){
		setResult("Value", i, profile[i]);
		updateResults;
      	// Plot profile
		Plot.create("Profile", "X", "Value", profile);
	}
	//save profile
	ppath = ipath+".csv";
	saveAs("Results",ppath);
	//close remaining image
	run("Close");
	run("Close");
	prevn = currn;
}
