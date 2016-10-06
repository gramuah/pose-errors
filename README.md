# Pose Estimation Diagnostic Tool

## INTRODUCTION:

This project contains the source code and annotations for analyzing object detectors and pose estimators on the [PASCAL 3D+ dataset](http://cvgl.stanford.edu/projects/pascal3d.html).

This is a repository with an implementation of the diagnostic tool described in our [ECCV2016 paper] (http://agamenon.tsc.uah.es/Investigacion/gram/publications/eccv2016-redondo.pdf). We provide here the codes and data needed to reproduce all the experiments detailed in the paper. 


####LICENSE

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
To generate the PDF with the report, we use the tool **pdflatex**, which has to be correctly installed.

## HOW TO GENERATE THE REPORTS?:
The tool we provide here generates the detailed reports described in our paper, for any method using the PASCAL 3D+ dataset.


   + **CASE I:** How to generate the reports for the methods VDPM (vdpm), V&K (vpskps), DPM+VOC-VP (3ddpm) or BHF (bhf) pose estimators? Note these are the methods analyzed in the paper.

       1) Download the [PASCAL 3D+ dataset](http://cvgl.stanford.edu/projects/pascal3d.html) (Release 1.1) and uncompress the zip file provided in the folder PASCAL3D+.

      2) In the script src/poseEstimationAnalysisScript.m, set to 1 all flags (SKIP_SAVED_FILES, SAVE_QUALITATIVE, SHOW_FIGURES, DO_TEX, DO_OVERLAP_CRITERIA_ANALYSIS and SAVE_SUMMARY). 
       
     3) In the script src/poseEstimationAnalysisScript.m, add to the ''detectors'' list the ones you want to be diagnosed. By default, the tool generates the report for a random pose assignment named 'rand-gt'.
   
      4) Open Matlab, go to the src folder and run the script poseEstimationAnalysisScript.m. The PDF with the detailed report will be generated in the path: results/method_name/tex/AnalysisAutoReportTemplate.pdf
      

   + **CASE II:** How to generate the reports for your own method using the PASCAL 3D+ dataset?

       1) Create a subdirectory in the ''detections'' folder. Assign this directory the name of your new model.
         
       2) In this directory create a text file for each object category. These files must contain in each row the detections and pose estimations obtained by the model, following this format:

                 image_name (without extension, \ie '.jpg') detector_score x1 y1 x2 y2 azimuth zenith
                 example: 2008_000002 0.292526 34.00 11.00 448.00 293.00 342.86 171.43                 
   
       3) Add a corresponding entry to the script src/setDetectorInfo.m and update the ''detectors'' variable in src/poseEstimationAnalysisScript.m to analyze the created model.       

       4) Perform steps [2-4]  of CASE I.
