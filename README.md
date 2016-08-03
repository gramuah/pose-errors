# Pose Estimation Diagnostic Tools

#### INTRODUCTION:

This project contains the source code and annotations for analyzing object detectors and pose estimators on the PASCAL 3D+ dataset.

This is a repository with an implementation of the diasnotic tool described in our [ECCV2016 paper] (http://agamenon.tsc.uah.es/Investigacion/gram/publications/eccv2016-redondo.pdf). We provide here the codes and data needed to reproduce all the experiments detailed in the paper.

#License

The license information of this project is described in the file "LICENSE".

#CITING

If you make use of this software, please cite the following reference in any publications:  

@inproceedings{Redondo-Cabrera2016,
    Title                    = {Pose Estimation Errors, the Ultimate Diagnosis},
    Author                   = {Redondo-Cabrera, C. Lopez-Sastre, R.~J., Xiang, Y., Tuytelaars, T. and Savarese, S.},
    Booktitle                = {ECCV},
    Year                     = {2016}
}

#REQUIREMENTS

The diasnotic tool is developed and tested under Ubuntu 14.04. Matlab is required.

#### HOW TO RUN:

   + CASE I: PASCAL 3D+ dataset and VDPM (vdpm), V&K (vpskps), DPM+VOC-VP (3ddpm) or BHF (bhf) pose estimators.

         1) In poseEstimationAnalysisScript.m, set all flags on top to 1 (true)   
   
         2) In setDatasetParameters.m, set the imdir path to a valid directory of PASCAL 3D+ images
   
         3) Run poseEstimationAnalysisScript.m in Matlab

   + CASE II: PASCAL 3D+ dataset and your own pose estimators

         1) Create a subdirectory of detector within detections. 
         For each object category, a .txt file is needed to realize the pose analysis.
         These files contain for each row the detections and estimations obtained by the
         detectors. The format for each detections is: 

         image_name (without extension, \ie '.jpg') score x1 y1 x2 y2 azimuth zenith
      
         example: 2008_000002 0.292526 34.00 11.00 448.00 293.00 342.86 171.43 
   

         2) Add a corresponding entry to setDetectorInfo.m and update detector variable in 
         poseEstimationAnalysisScript.m

         3) Perform all steps of CASE I
	
   + CASE III: Include a new dataset and your own pose estimators

         1) Include the new dataset parameters in setDatasetParameters.m

         2) Modify readDatasetAnnotations.m for maximum compatibility to PASCAL 3D+ dataset (see Code_explanation.txt) 

         3) Perform all steps of CASE II


#### DESCRIPTION OF FOLDERS:

   + annotations: 

         Contains annotations for objects (excluding "difficult" objects, as defined
         by VOC and PASCAL 3D+ annotations). The file Labels.txt contains the name of the 
         parts defined on PASCAL3D+, visible parts and other object characteristics, such as object sizes and aspect ratios.  

   
   + src: 
         
         Contains code for reading the annotations and storing them in the PASCAL VOC
         record structure and realizes the pose estimation analysis  

   
   + results: 

         For each detector: a folder for each object class, which contains the graphical and 
         analytical results, is created. Finally, a reports with all results can be obtained by
         running the AnalysisAutoReportTemplate.tex file automatically created in tex folder. 

   
   + detections: 

         For each detector it is necessary to create a subdirectory which contains, 
         for each object class, a list of all detections and pose estimations. 
         The file det_format.txt helps to explain the detection format.

