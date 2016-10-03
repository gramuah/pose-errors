# Pose Estimation Diagnostic Tool

## INTRODUCTION:

This project contains the source code and annotations for analyzing object detectors and pose estimators on the PASCAL 3D+ dataset.

This is a repository with an implementation of the diagnostic tool described in our [ECCV2016 paper] (http://agamenon.tsc.uah.es/Investigacion/gram/publications/eccv2016-redondo.pdf). We provide here the codes and data needed to reproduce all the experiments detailed in the paper. 


####LICENCE

The license information of this project is described in the file "LICENSE".

####CITING

If you make use of this software, please cite the following reference in any publications:  

        @inproceedings{Redondo-Cabrera2016,
               Title  = {Pose Estimation Errors, the Ultimate Diagnosis},
               Author = {Redondo-Cabrera, C. and Lopez-Sastre, R.~J. and Xiang, Y. and Tuytelaars, T. and Savarese, S.},
               Booktitle = {ECCV},
               Year = {2016}
        }

####REQUIREMENTS

The diagnostic tool is developed and tested under Ubuntu 14.04. Matlab is required.

## HOW TO GENERATE THE REPORTS?:
The tool we provide here generates the detailed reports described in our paper, for any method using the PASCAL 3D+ dataset.


   + **CASE I:** How to generate the reports for the methods VDPM (vdpm), V&K (vpskps), DPM+VOC-VP (3ddpm) or BHF (bhf) pose estimators? Note these are the methods analysed in the paper.

       1) Download the [PASCAL 3D+ dataset](http://cvgl.stanford.edu/projects/pascal3d.html).

       2) In the script poseEstimationAnalysisScript.m, set all flags to 1 (true).   
   
       3) In setDatasetParameters.m, set the imdir path to a valid directory with the PASCAL 3D+ images.
   
       4) Open Matlab and run the script poseEstimationAnalysisScript.m.

   + **CASE II:** How to generate the reports for your own method using the PASCAL 3D+ dataset?

       1) Create a subdirectory in the detections folder. Assign this directory the name of your pose estimator.
         
       2) Create a text file of detector for each object category.
       
		These file contain for each row the detections and estimations obtained by the
        detector. The format for each detection is: 

                 image_name (without extension, \ie '.jpg') score x1 y1 x2 y2 azimuth zenith
                 example: 2008_000002 0.292526 34.00 11.00 448.00 293.00 342.86 171.43 
   
       3) Add a corresponding entry to setDetectorInfo.m and update detector variable in 
       poseEstimationAnalysisScript.m

       4) Perform [2-4] steps of CASE I
	
   + **CASE III:** Include a new dataset and your own pose estimators

       1) Add the new dataset in the annotations folder

       2) Include the new dataset parameters in setDatasetParameters.m

       3) Modify readDatasetAnnotations.m for maximum compatibility to PASCAL 3D+ dataset (see Code_explanation.txt) 

       4) Perform all steps of CASE II


## DESCRIPTION OF FOLDERS:

   + annotations: 

         Contains annotations for objects (excluding "difficult" objects, as defined
         by VOC and PASCAL 3D+ annotations). The file Labels.txt contains the name of the 
         parts defined on PASCAL 3D+, visible parts and other object characteristics, 
         such as object sizes and aspect ratios.  

   
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

