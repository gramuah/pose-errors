#### This contains updated instructions for the last version of the Diagnostic Tool Code. 

------------------------------------------------------------------------------

The main script is **poseEstimationAnalysisScript**. Full functionality applies to
only the **PASCAL3D+ dataset** because detailed annotations are available only
on that dataset. The code has also been written to make it easy to adapt to
other detection and pose estimation datasets that are based on bounding box 
criteria and that contain pose or viewpoint information. 


## MAIN FUNCTIONS

---- Functions that likely require editing ----

poseEstimationAnalysisScript: Script for running all code.  
The first few lines  contain parameters specifying what analysis and display 
functions to call. The dataset type (e.g., 'pascal3d'), list of detectors to 
analyze, and list of object classes to analyze is also specified here. 

setDatasetParameters: Specifies specific datset (e.g., 
'PASCAL3D+') and paths for images and annotations.  Some parameters are 
specific to the machine; others to the type of dataset.  The list of 
generally required parameters are explained in the function documentation.

setDetectorInfo: Specifies location of detection files
for each detector and directory to place results.


---- Functions that require editing if not using a PASCAL3D+ dataset ----

readDatasetAnnotations: For maximum compatibility, if using another dataset,
this should produce the following structure:
  ann.
   rec(image_number).
     filename: name of image file 
     imgsize([w h]): width and height of image in pixels
     objects(num_objects).
        detailedannotation: true if detailed annotation is available 
        details: annotations for visible parts, etc., if available, empty if not
        truncated: 0/1 for whether truncated
        difficult: 0/1 for whether this object is a don't care
   gt(object_class_number).     
     bbox(num_objects, [x1 y1 x2 y2]): ground truth bounding boxes
     rnum(num_objects): index into rec, specifying source image
     onum(num_objects): index into rec(rnum).objects, specifying which object
     isdiff(num_objects): whether each object is don't care
     istrunc(num_objects): whether each object is truncated
     isocc(num_objects): whether each object is occluded
     details(num_objects): detail structure if available (otherwise empty)
     N: number of ground truth objects
Note that isdiff, isocc, istrunc can be set to zeros if that information is 
not available; likewise trunacted and difficult in rec can be set to 0.

readDetections: Reads the output of the object detector. For maximum 
compatibility, this should produce the following structure:
  det.
    bbox(ndetections, [x1 y1 x2 y2]): detection bounding box
    conf(ndetections): confidence for each detection (higher is more confident)
    rnum(ndetections): index into rec/gt structures, specifying source image
    nimages: total number of images in dataset
    N: total number of detections
    

---- Analisys Functions ----

analyzeDetections: Produces precision-recall curves and obtain a study of 
the Impact of Object Characteristics on Pose Prediction Error. 

matchDetectionsWithGroundTruth: Labels detections as incorrect, correct, or 
don't care.  localization parameter specifies whether localization error 
should be ignored ('weak') or not ('strong').  If you want to change the
localization criteria, edit setDatasetParameters and/or this function.  Also
assigned ground truth objects to detections with best score or overlap.

analyzePoseError: Analysis of Main Pose Errors and computes effects of each type of 
pose estimation performance. Pose Error Analysis (False Positive Study)

displayPoseErrorAnalysisPlots: Draws plots for the results obtained by the
analysis of Main Pose Errors. Analysis I (False Positive & Metrics)

displayPerCharacteristicDetPlots: Analysis II. Object Characteristic influences on
Detection.

displayPerCharacteristicPosePlots: Draws plots for the object characteristics
effect on pose estimation and summarizes statistics for all object characteristic influences

displayPrecRecPlots: Analysis III (Precision/Recall Curves). Displays 
precision-recall curves for detection and pose estimation. AP, AOS, AVP and 
PEAP curves.  

overlapAnalisys: If DO_OVERLAP_CRITERIA_ANALISYS flag is true realize a study of 
pose estimation performance for several overlap criteria 

showQualitative: If SHOW_QUALITATIVE flag is set true shows and saves qualitative 
results.

writeAnalysisSummary: If SAVE_SUMMARY flag is true creates text file 
summarizing the results of the analysis

If DO_TEX flag is true:
writeTexHeader: creates tex header file for creating pdf report
writeTableResults: creates a table with the detector results 
writeTexObject: creates tex material for results for one object category