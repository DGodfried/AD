// Ask the user to select a folder
dir = getDirectory("Select a folder");
// Get the list of files (& folders) in it
fileList = getFileList(dir);
// Prepare a folder to output the images
output_dir = dir + File.separator + "output" + File.separator;
File.makeDirectory(output_dir);

// Activate batch mode
setBatchMode(true);

// LOOP to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
    // Define the "path" 
    // by concatenation of dir and the i element of the array fileList
    current_imagePath = dir + fileList[i];
    // Check that the currentFile is not a directory
    if (!File.isDirectory(current_imagePath)){
        // Open the image
        open(current_imagePath);
        
        // Apply your desired preprocessing steps here
        run("Duplicate...", " ");
        setOption("ScaleConversions", true);
        run("8-bit");
        setAutoThreshold("Default dark");
        // You can uncomment and customize the thresholding operation as needed
        // run("Threshold...");
        // setThreshold(57, 255);
        
        // Analyze particles
        run("Analyze Particles...", "size=90-Infinity show=Outlines display summarize overlay add");
        
        // Save the outline drawing as an image
        saveAs("Tiff", output_dir + "Outline_" + fileList[i]);
        
        // Save the ROI set
        roiManager("Save", output_dir + "RoiSet_" + fileList[i] + ".zip");
        
        // Close the summary window
        close("Summary");
        
        // Deselect and delete the ROI from the manager
        roiManager("Deselect");
        roiManager("Delete");
        
        // Close the current image
        close();
    }
}

// Close all open images
run("Close All");
