function [result, resulclass] = analyzePoseError(dataset, dataset_params, ann, objind, det, localization)
% result = analyzePoseError(dataset, dataset_params, ann, objind, similar_ind, det)
% Pose Error Analysis.

switch dataset
    case {'PASCAL3D+'}
        [result, resulclass] = analyzePoseError_PASCAL3D(dataset, ...
            dataset_params, ann, objind, det, localization);
        
    otherwise
        error('dataset %s is unknown\n', dataset);
end


function [result, resulclass] = analyzePoseError_PASCAL3D(dataset, dataset_params, ann, objind, det, localization)

[sv, si] = sort(det.conf, 'descend');
det.bbox = det.bbox(si, :);
det.conf = det.conf(si);
det.rnum = det.rnum(si);
det.view = det.view(si, :);

objname = dataset_params.objnames_all{objind};

% Regular
[det, gt] = matchDetectionsWithGroundTruth(dataset, dataset_params, objname, ann, det, localization);
npos = sum(~[gt.isdiff]);
result.iscorrect = (det.label>=0);
[result.pose, resulclass] = averagePoseDetectionPrecision(det, gt, npos);

%% Pose Error Analysis

% Ignore opposite error: remove estimations that have label 2
det2 = [];
ii = [];
ii = find(result.pose.labels_pose == 1 | result.pose.labels_pose == 3 | ...
    result.pose.labels_pose == 4  | result.pose.labels_pose == 0);
hh=1;
result.pose.isopp = [];
for jj = 1: length(ii)
    result.pose.isopp(hh) = ii(jj);
    hh = hh+1;
end
if ~isempty(result.pose.isopp)
    det2.bbox = det.bbox(result.pose.isopp,:);
    det2.conf = det.conf(result.pose.isopp,:);
    det2.rnum = det.rnum(result.pose.isopp,:);
    det2.view = det.view(result.pose.isopp,:);
    det2.nimages = det.nimages;
    det2.N = det.N;
    det2.gtnum = det.gtnum(result.pose.isopp,:);
    det2.ov = det.ov(result.pose.isopp,:);
    det2.ov_obj = det.ov_obj(result.pose.isopp,:);
    det2.ov_gt = det.ov_gt(result.pose.isopp,:);
    det2.isdiff = det.isdiff(result.pose.isopp,:);
    det2.label = det.label(result.pose.isopp,:);
    det2.label_occ = det.label_occ(result.pose.isopp,:);
    det2.label_trunc = det.label_trunc(result.pose.isopp,:);
    det2.isduplicate = det.isduplicate(result.pose.isopp,:);
    ah=0;
    ai=find(result.pose.labels_pose == 2);
    for j = 1: length(ai);
        if det.isdiff(ai(j)) == 0
            ah = ah+1;
        end
    end
    npos = sum(~[gt.isdiff])-ah;
    dummy = [];
    [result.pose.ignoreopp, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
else
    result.pose.ignoreopp = result.pose;
end

% reassigns opposite error to correct estimations
ii = [];
ii = find(result.pose.labels_pose == 2);
hh=1;
for jj = 1: length(ii)
    result.pose.isopp2(hh) = ii(jj);
    hh = hh +1;
end
det3 = det;
if hh > 1
    for j=1:length(result.pose.isopp2)
        det3.view(result.pose.isopp2(j),1) = gt.viewpoint(det3.gtnum(result.pose.isopp2(j)), :).azimuth;
    end
end
npos = sum(~[gt.isdiff]);
dummy = [];
[result.pose.correctopp, dummy] = averagePoseDetectionPrecision(det3, gt, npos);

% Ignore nearby error: remove estimations that have label 3
ii = [];
ii = find(result.pose.labels_pose == 1 | result.pose.labels_pose == 2 | ...
    result.pose.labels_pose == 4 | result.pose.labels_pose == 0);
hh=1;
for jj= 1:length(ii)
    result.pose.isnearby(hh) = ii(jj);
    hh= hh+1;
end
det2 = [];
if hh > 1
    det2.bbox = det.bbox(result.pose.isnearby,:);
    det2.conf = det.conf(result.pose.isnearby,:);
    det2.rnum = det.rnum(result.pose.isnearby,:);
    det2.view = det.view(result.pose.isnearby,:);
    det2.nimages = det.nimages;
    det2.N = det.N;
    det2.gtnum = det.gtnum(result.pose.isnearby,:);
    det2.ov = det.ov(result.pose.isnearby,:);
    det2.ov_obj = det.ov_obj(result.pose.isnearby,:);
    det2.ov_gt = det.ov_gt(result.pose.isnearby,:);
    det2.isdiff = det.isdiff(result.pose.isnearby,:);
    det2.label = det.label(result.pose.isnearby,:);
    det2.label_occ = det.label_occ(result.pose.isnearby,:);
    det2.label_trunc = det.label_trunc(result.pose.isnearby,:);
    det2.isduplicate = det.isduplicate(result.pose.isnearby,:);
    ah=0;
    ai=find(result.pose.labels_pose == 3);
    for j = 1: length(ai);
        if det.isdiff(ai(j)) == 0
            ah = ah+1;
        end
    end
    npos = sum(~[gt.isdiff])-ah;
    dummy = [];
    [result.pose.ignorenearby, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
else
    NAMES = fieldnames(det);
    for na=1:length(NAMES)
        det2= setfield(det2,NAMES{na},[]);
    end
    npos = 0;
    result.pose.ignorenearby = [];
end



% reassigns nearby error to correct estimations
ii = [];
ii = find(result.pose.labels_pose == 3);
hh=1;
for jj= 1:length(ii)
    result.pose.isnearby2(hh) = ii(jj);
    hh= hh+1;
end

det3 = det;
if hh > 1
    for j=1:length(result.pose.isnearby2)
        det3.view(result.pose.isnearby2(j),1) = ...
            gt.viewpoint(det3.gtnum(result.pose.isnearby2(j)), :).azimuth;
    end
end
npos = sum(~[gt.isdiff]);
dummy =[];
[result.pose.correctnearby, dummy] = averagePoseDetectionPrecision(det3, gt, npos);

% Ignore other error: remove estimations that have label 4
ii = [];
ii = find(result.pose.labels_pose == 1 | result.pose.labels_pose == 2 | ...
    result.pose.labels_pose == 3 | result.pose.labels_pose == 0);
hh=1;
for jj= 1:length(ii)
    result.pose.isother(hh) = ii(jj);
    hh= hh+1;
end
det2 = [];
if hh > 1
    det2.bbox = det.bbox(result.pose.isother,:);
    det2.conf = det.conf(result.pose.isother,:);
    det2.rnum = det.rnum(result.pose.isother,:);
    det2.view = det.view(result.pose.isother,:);
    det2.nimages = det.nimages;
    det2.N = det.N;
    det2.gtnum = det.gtnum(result.pose.isother,:);
    det2.ov = det.ov(result.pose.isother,:);
    det2.ov_obj = det.ov_obj(result.pose.isother,:);
    det2.ov_gt = det.ov_gt(result.pose.isother,:);
    det2.isdiff = det.isdiff(result.pose.isother,:);
    det2.label = det.label(result.pose.isother,:);
    det2.label_occ = det.label_occ(result.pose.isother,:);
    det2.label_trunc = det.label_trunc(result.pose.isother,:);
    det2.isduplicate = det.isduplicate(result.pose.isother,:);
    
    ah=0;
    ai=find(result.pose.labels_pose == 4);
    for j = 1: length(ai);
        if det.isdiff(ai(j)) == 0
            ah = ah+1;
        end
    end
    npos = sum(~[gt.isdiff])-ah;
    
    dummy=[];
    [result.pose.ignoreother, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
else
    result.pose.ignoreother = [];
end

% reassigns other error to correct estimations
ii = [];
ii = find(result.pose.labels_pose == 4);
hh=1;
for jj= 1:length(ii)
    result.pose.isother2(hh) = ii(jj);
    hh= hh+1;
    
end

det3 = det;
if hh > 1
    for j=1:length(result.pose.isother2)
        det3.view(result.pose.isother2(j),1) = ...
            gt.viewpoint(det3.gtnum(result.pose.isother2(j)), :).azimuth;
    end
end
npos = sum(~[gt.isdiff]);
dummy = [];
[result.pose.correctother, dummy] = averagePoseDetectionPrecision(det3, gt, npos);

% Only correct estimation: remove estimations that have label 2,3 and 4
ii = [];
det2 = [];
ii = find(result.pose.labels_pose == 1);
hh=1;
for jj= 1:length(ii)
    if det.isdiff(ii(jj)) == 0
        result.pose.ignall(hh) = ii(jj);
        hh= hh+1;
    end
end

det2.bbox = det.bbox(result.pose.ignall,:);
det2.conf = det.conf(result.pose.ignall,:);
det2.rnum = det.rnum(result.pose.ignall,:);
det2.view = det.view(result.pose.ignall,:);
det2.nimages = det.nimages;
det2.N = det.N;
det2.gtnum = det.gtnum(result.pose.ignall,:);
det2.ov = det.ov(result.pose.ignall,:);
det2.ov_obj = det.ov_obj(result.pose.ignall,:);
det2.ov_gt = det.ov_gt(result.pose.ignall,:);
det2.isdiff = det.isdiff(result.pose.ignall,:);
det2.label = det.label(result.pose.ignall,:);
det2.label_occ = det.label_occ(result.pose.ignall,:);
det2.label_trunc = det.label_trunc(result.pose.ignall,:);
det2.isduplicate = det.isduplicate(result.pose.ignall,:);

npos = length(result.pose.ignall);
dummy = [];
[result.pose.ignoreall, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
