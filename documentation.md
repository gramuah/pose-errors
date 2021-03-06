#### DOCUMENTATION OF THE DIAGNOSTIC TOOL. 
------------------------------------------------------------------------------

## DESCRIPTION OF FOLDERS:

   + annotations: 

         Contains annotations for objects (excluding "difficult" objects, as defined
         by PASCAL VOC and PASCAL 3D+ annotations). The file Labels.txt contains the name of the 
         object parts defined in the PASCAL 3D+, visible parts and other object characteristics, 
         such as object sizes and aspect ratios. 
   
   + src: 
         
         Contains all the code.

   
   + results: 

         Includes, for each detector, a folder for each object class, which contains the graphical   and analytical results. The final diagnosis report is provided in the file AnalysisAutoReportTemplate.pdf. 

   
   + detections: 

         For each detector it is necessary to create a subdirectory which contains, 
         for each object class, a list of all detections and pose estimations. 
         The file det_format.txt helps to explain the format of these files.

## MAIN FUNCTIONS

The main script is **poseEstimationAnalysisScript.m**. Full functionality applies to
only the **PASCAL3D+ dataset**, because detailed annotations are available only
on this dataset. The code has also been written to make it easy to adapt to
other detection and pose estimation datasets that are based on bounding box 
criteria and that contain pose or viewpoint information. 


### Functions that likely require editing:

+ *poseEstimationAnalysisScript.m*

Script for running all the diagnosis code. The first few lines contain parameters defining the type of analysis to perform. The dataset type (e.g., 'pascal3d'), list of detectors to analyze, and list of object classes to analyze have to be specified here. 

+ *setDatasetParameters.m*

Specifies specific dataset parameters and paths for images and annotations. Some parameters are 
specific to the machine; others to the type of dataset. The list of generally required parameters are explained in the function documentation.

+ *setDetectorInfo.m*

Specifies location of detection files for each detector and the directory to place results.


### Functions that require editing if not using a PASCAL3D+ dataset:  

+ *readDatasetAnnotations.m* 

For maximum compatibility, if using another dataset, this script should produce the following structure:

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
not available; likewise truncated and difficult in rec can be set to 0.

+ *readDetections.m*

Reads the output of the object detector and pose estimators. For maximum compatibility, this should produce the following structure:

      det.
         bbox(ndetections, [x1 y1 x2 y2]): detection bounding box
         conf(ndetections): confidence for each detection (higher is more confident)
         rnum(ndetections): index into rec/gt structures, specifying source image
         nimages: total number of images in dataset
         N: total number of detections
    

### Diagnostic Tool Functions:

+ *analyzeDetections.m* 

Produces precision-recall curves and obtain a study of the Impact of Object Characteristics on Pose Prediction Error. 

+ *matchDetectionsWithGroundTruth.m* 

Labels detections as incorrect, correct, or don't care. Localization parameter specifies whether localization error should be ignored ('weak') or not ('strong').  If you want to change the
localization criteria, edit **setDatasetParameters** and/or this function.  Also assigned ground truth objects to detections with best score or overlap.

+ *analyzePoseError.m* 

Analysis of Main Pose Errors and computes effects of each type of pose estimation performance. Pose Error Analysis (False Positive Study).

+ *displayPoseErrorAnalysisPlots.m*

Draws plots for the results obtained by the analysis of Main Pose Errors. Analysis I (False Positive & Metrics).

+ *displayPerCharacteristicDetPlots.m* 

Analysis II. Object Characteristic influences on Detection.

+ *displayPerCharacteristicPosePlots.m*

Draws plots for the object characteristics effect on pose estimation and summarizes statistics for all object characteristic influences.

+ *displayPrecRecPlots.m* 

Analysis III (Precision/Recall Curves). Displays precision-recall curves for detection and pose estimation. AP, AOS, AVP and PEAP metrics can be used.  

+ *overlapAnalisys.m*

If DO_OVERLAP_CRITERIA_ANALISYS flag is true, this script realizes a study of pose estimation performance for several overlap criteria.

+ *showQualitative.m* 

If SHOW_QUALITATIVE flag is true, this script shows and saves qualitative  results.

+ *writeAnalysisSummary.m* 

If SAVE_SUMMARY flag is true, this function creates a text file summarizing the results of the analysis.


**If DO_TEX flag is true:**

+ *writeTexHeader.m*  

Creates a Tex header file for creating the final pdf report.

+ *writeTableResults.m* 

Creates a table with the detector results. 

+ *writeTexObject.m* 

Creates tex material for results for one object category.
