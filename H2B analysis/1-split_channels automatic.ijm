// Ask the user to select a folder
dir = getDirectory("Select A folder");

// Get the list of files (& folders) in it
fileList = getFileList(dir);

// Prepare a folder to output the images
output_dir = dir + File.separator + "output" + File.separator;
File.makeDirectory(output_dir);

// Activate batch mode
setBatchMode(true);

// Loop to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
    // Define the "path" by concatenation of dir and the i element of the array fileList
    current_imagePath = dir + fileList[i];
    
    // Check that the currentFile is not a directory
    if (!File.isDirectory(current_imagePath)) {
        // Set Bio-Formats options to open .nd2 files automatically
        options = "open=[" + current_imagePath + "] color_mode=Composite view=Hyperstack stack_order=XYCZT";
        // Open the image using Bio-Formats with the specified options
        run("Bio-Formats Importer", options);
        
        // Get some info about the image
        getDimensions(width, height, channels, slices, frames);
        
        // If it's a multi-channel image or an RGB image
        if (channels > 1 || bitDepth() == 24) {
            run("Split Channels");
        }
        
        // Now save all the generated images as TIFF in the output_dir
        ch_nbr = nImages;
        for (c = 1; c <= ch_nbr; c++) {
            selectImage(c);
            currentImage_name = getTitle();
            saveAs("Tiff", output_dir + currentImage_name);
        }
        
        // Make sure to close every image before opening the next one
        close();
    }
}

// Restore batch mode to its previous state
setBatchMode(false);
