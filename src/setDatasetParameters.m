function dataset_params = setDatasetParameters(dataset)
% dataset_params = setDatasetParameters(dataset)
%
% Sets machine-specific and datset-specific parameters such as image paths.
%
% Required parameters: 
%   imdir: directory containing images
%   objnames_all{nclasses}: names for each object class, order specifies
%     index for each class


switch dataset
    
  case 'PASCAL3D+'
    sourceDir = '../PASCAL3D+';
    dataset_params.imset = 'test';  % set used for analysis    
    dataset_params.imdir = [sourceDir '/PASCAL3D+_release1.1/PASCAL/VOCdevkit/VOC2012/JPEGImages']; % needs to be set for your computer
    dataset_params.VOCsourcepath = '/VOCcode';  % change this for later VOC versions
    dataset_params.VOCset = 'PASCAL3D';
    dataset_params.dataBaseDir = [sourceDir '/data/PASCAL3D+_release1.1'];
    addpath(dataset_params.VOCsourcepath);
    dataset_params.annotationdir = '../annotations';
    dataset_params.confidence_threshold = -Inf; % minimum confidence to be included in analysis (e.g., set to 0.01 to improve speed)

    % all object names , 
    dataset_params.objnames_all = {'aeroplane', 'bicycle', 'boat', 'bottle', 'bus', 'car', ...
       'chair', 'diningtable', 'motorbike', 'sofa', 'train', 'tvmonitor'}; 
    
    % overlap analysis:
    % names to specify localization criteria
    dataset_params.overlapNames = {'weak', 'weak_1', 'weak_2', 'weak_3', 'strong', 'strong_1', 'strong_2', ...
    'strong_3', 'strong_4'};
    
%     'weak'  % also duplicate detections are ignored, per last line
%     iuthresh = dataset_params.iuthresh_weak;  % intersection/union threshold
%     idthresh = dataset_params.idthresh_weak;    % intersection/det_area threshold 
%     
%     'strong'
%     iuthresh = dataset_params.iuthresh_strong;
%     idthresh = dataset_params.idthresh_strong;
%     
%     'weak_1'  
%     iuthresh = 0.2;  
%     idthresh = 0;     
%     
%     'weak_2'  
%     iuthresh = 0.3;  
%     idthresh = 0;     
%     
%     'weak_3'  
%     iuthresh = 0.4;  
%     idthresh = 0;    
%     'strong_1'
%     iuthresh = 0.6;
%     idthresh = 0;
%     
%     'strong_2'
%     iuthresh = 0.7;
%     idthresh = 0;
%     
%     'strong_3'
%     iuthresh = 0.8;
%     idthresh = 0;
%     
%     'strong_4'
%     iuthresh = 0.9;
%     idthresh = 0;


   
    % localization criteria by default
    dataset_params.iuthresh_weak = 0.1;  % intersection/union threshold
    dataset_params.idthresh_weak = 0;    % intersection/det_area threshold
    dataset_params.iuthresh_strong = 0.5;  % intersection/union threshold
    dataset_params.idthresh_strong = 0;    % intersection/det_area threshold 
    
      
end
