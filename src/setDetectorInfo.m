function [detpath, resultdir, detname] = setDetectorInfo(detector)
% [detpath, resultdir, detname] = setDetectorInfo(detector)
%
% sets path etc for a given detector

  switch detector    
    case 'rand-gt'
      detpath = '../detections/rand/RAND_PASCAL3D_%s_det.txt';
      resultdir = '../results/rand-gt';
      detname = 'rand-gt';
    case 'hfplev'
      detpath = '../detections/hfplev/HFPLEV_PASCAL3D_%s_det.txt';
      resultdir = '../results/hfplev';
      detname = 'hfplev';
    case 'hfplev-gt'
      detpath = '../detections/hfplev-gt/HFPLEV_PASCAL3D_%s_det.txt';
      resultdir = '../results/hfplev-gt';
      detname = 'hfplev-gt';
    case 'bhf'
      detpath = '../detections/bhf/BHF_PASCAL3D_%s_det.txt';
      resultdir = '../results/bhf';
      detname = 'bhf';
    case 'bhf-gt'
      detpath = '../detections/bhf-gt/BHF_PASCAL3D_%s_det.txt';
      resultdir = '../results/bhf-gt';
      detname = 'bhf-gt';
    case 'vdpm'
      detpath = '../detections/vdpm/VDPM_PASCAL3D_%s_det.txt';
      resultdir = '../results/vdpm';
      detname = 'vdpm';
    case 'vdpm-gt'
      detpath = '../detections/vdpm-gt/VDPM_PASCAL3D_%s_det.txt';
      resultdir = '../results/vdpm-gt';
      detname = 'vdpm-gt';
    case '3ddpm'
      detpath = '../detections/3ddpm/3DDPM_PASCAL3D_%s_det.txt';
      resultdir = '../results/3ddpm';
      detname = '3ddpm';
    case 'vpskps'
      detpath = '../detections/vpskps/VPSKPS_PASCAL3D_%s_det.txt';
      resultdir = '../results/vpskps';
      detname = 'vpskps';
    case 'vpskps-gt'
      detpath = '../detections/vpskps-gt/vpskps_PASCAL3D_%s_det.txt';
      resultdir = '../results/vpskps-gt';
      detname = 'vpskps-gt';
       
    otherwise
      error('unknown detector')
  end
