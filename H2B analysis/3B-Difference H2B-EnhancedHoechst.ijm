// Define the input folder and output folder paths
inputFolder = getDirectory("Select a folder");
// Prepare a folder to output the images
outputFolder = inputFolder + File.separator + "output" + File.separator;
File.makeDirectory(outputFolder);

// Get a list of files in the input folder
list = getFileList(inputFolder);

// Loop through the files and perform the subtraction
for (i = 0; i < list.length; i++) {
    filename = list[i];
    
    // Check if the file starts with "C3-"
    if (startsWith(filename, "C3-")) {
        // Load the Channel 3 image
        open(inputFolder + filename);
        ch3Image = getTitle();
        
        // Extract the common part of the filename (e.g., "42R-5-CON-Hoechst-NeuN-H2B159-40x B x4.tif")
        commonPart = filename.substring(3);
        
        // Form the corresponding "EnhancedC1" filename
        enhancedC1Filename = "EnhancedC1-" + commonPart;
        
        // Load the Enhanced Channel 1 image
        open(inputFolder + enhancedC1Filename);
        enhancedC1Image = getTitle();
        
        // Subtract Enhanced Channel 1 from Channel 3
        run("Image Calculator...", "image1=[" + ch3Image + "] image2=[" + enhancedC1Image + "] operation=Subtract create");
        
        // Save the result in the output folder
        saveAs("Tiff", outputFolder + "Result_" + filename);
        
        // Close the images
        close();
    }
}

// Close any remaining open images
close("*");

// Display a message when the subtraction is complete
print("Subtraction complete!");
