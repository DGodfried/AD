// Define the directory where your images and ROIs are located
inputDir = getDirectory("Select a folder");

// Get a list of all files in the directory
list = getFileList(inputDir);

// Activate batch mode
setBatchMode(true);

// Loop through the files in the directory
for (i = 0; i < list.length; i++) {
    // Check if the file is an image (filename starts with "Result")
    if (startsWith(list[i], "Result_C3")) {
        // Open the image
        open(inputDir + list[i]);

        // Get the corresponding ROI filename
        roiFilename = list[i].replace("Result_C3", "RoiSet_C2") + ".zip";

        // Check if the ROI file exists
        if (File.exists(inputDir + roiFilename)) {
            // Open the ROI Manager and load ROIs
            roiManager("Open", inputDir + roiFilename);

            // Set desired measurements
            run("Set Measurements...", "area mean perimeter shape integrated redirect=None decimal=3");

            // Measure all ROIs
            roiManager("count");
            roiManager("Measure");

            // Save measurements to a file
            saveAs("Results", inputDir + "Measurements_" + list[i] + ".csv");

            // Close the ROI Manager
            roiManager("delete");
        }

        // Close the image
        close();
    }
}

// Close any remaining open images
run("Close All");

// Display a message when processing is complete
waitForUser("Processing is complete.");
