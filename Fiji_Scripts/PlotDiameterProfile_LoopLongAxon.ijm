dir=getDirectory("");
print(dir);
list = getFileList(dir); 
axonNum = 0;
for (j=0; j<list.length; j++) { 
     if (endsWith(list[j], ".czi")){ 
     	print(j + ":" + dir + list[j]);
     	open(dir + list[j]);
		title=getTitle();
		for (ii=0; ii<2; ii++){
			axonNum = axonNum + 1;
			run("Clear Results");
			//capture a segment of the current axon, single frame
			makeRectangle(823, 826, 374, 374);
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
			ipath = dir+"ax"+axonNum+"_"+str_ismyel+"_"+num+"_"+str_rangle+"deg"+title;
			saveAs("Tiff",ipath+".tif");
			//get diameter profile
			chan = getNumber("2 channels?", 0);
			if (chan == 1){ 
				run("Split Channels");
			}
			//run("Close");
			setTool("rectangle");
			makeRectangle(49, 40, 161, 104);
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
			//close remaining channel
			if (chan == 1){
			run("Close");
			run("Close");
			} else {
			run("Close");
			}
		}
		//close main image
		run("Close");
     }
     print(j);
}