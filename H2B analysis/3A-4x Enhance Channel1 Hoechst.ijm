// Set the input and output folders
inputFolder = getDirectory("Select a folder");
outputFolder = inputFolder + File.separator + "output" + File.separator;
File.makeDirectory(outputFolder);

// Get a list of all TIFF files in the input folder
list = getFileList(inputFolder);

// Activate batch mode
setBatchMode(true);

// Loop through each TIFF file in the list
for (i = 0; i < list.length; i++) {
    // Check if the current file is a C1 channel image
    if (startsWith(list[i], "C1")) {
        // Open the C1 channel image
        open(inputFolder + list[i]);
        // Enhance the C1 channel image by multiplying by 4
        run("Multiply...", "value=4");
        // Save the enhanced C1 image with a modified name in the output folder
        saveAs("Tiff", outputFolder + "Enhanced" + list[i]);
        // Close the C1 channel image
        close();
    }
}

// Close all open images outside of the loop
close("*");
