function [result, resulclass] = analyzeII(dataset, dataset_params, ann, objind, det, localization)
% result = analyzeII(dataset, dataset_params, ann, objind, similar_ind, det)
% Error analysis ...

switch dataset
    case {'PASCAL3D+'}
    [result, resulclass] = analyzeII_PASCAL3D(dataset, ...
        dataset_params, ann, objind, det, localization);
        
  otherwise
    error('dataset %s is unknown\n', dataset);
end  

   
function [result, resulclass] = analyzeII_PASCAL3D(dataset, dataset_params, ann, objind, det, localization)

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

% Detection and pose estimation considering the difficult objects as well
npos = length(gt.bbox);%
result.pose.diff = averagePoseDetectionPrecision(det, gt, npos, 1);

result.diff_nondiff(1) = result.pose.diff;

result.gt.diffnondiff = zeros(gt.N, 1);
deto = det;
npos = 0;
rec = ann.rec;
for k = 1:gt.N    
       
    r = gt.rnum(k);
    o = gt.onum(k);
    if rec(r).objects(o).difficult == 1       
        result.gt.trunc_occ(k) = 1;
        i = (det.label==0 & det.gtnum==k);
        deto.label(i) = 1;
        npos = npos+1;
    else 
         i = (det.label==1 & det.gtnum==k);
         deto.label(i) = 0;
    end
    
end
dummy = [];
[result.diff_nondiff(2), dummy] = averagePoseDetectionPrecision(deto, gt, npos);

%% Error Analysis and Occ/Trun Study

% Ignore opposite error: remove estimations that have label 2
det2 = [];
ii = [];
ii = find(result.pose.labels_pose == 1 | result.pose.labels_pose == 3 | ...
    result.pose.labels_pose == 4  | result.pose.labels_pose == 0);
hh=1;
result.pose.isopp = [];
for jj = 1: length(ii)
    if det.gtnum(ii(jj)) ~= 0
        result.pose.isopp(hh) = ii(jj);
        hh = hh+1;
    end
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
    gt2=[];
    for j=1:length(result.pose.isopp)
        gt2.isdiff(j) = gt.isdiff(det.gtnum(result.pose.isopp(j)), :);
    end
    if ~isempty(gt2)
        ah=0;
        ai=find(result.pose.labels_pose == 2);
        for j = 1: length(ai);
            if det.isdiff(ai(j)) == 0
                ah = ah+1;
            end
        end
        npos = sum(~[gt.isdiff])-ah;
    else
        npos = 0;
    end
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
    if det.gtnum(ii(jj)) ~= 0
        result.pose.isopp2(hh) = ii(jj);
        hh = hh +1;
    end
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
     if det.gtnum(ii(jj)) ~= 0 
        result.pose.isnearby(hh) = ii(jj);
        hh= hh+1;
     end
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
    gt2 = [];
    for j=1:length(det2.gtnum)
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
    end
    if ~isempty(gt2)
        ah=0;
        ai=find(result.pose.labels_pose == 3);
        for j = 1: length(ai);
            if det.isdiff(ai(j)) == 0
                ah = ah+1;
            end
        end
        npos = sum(~[gt.isdiff])-ah;%sum(~[gt2.isdiff]);
    else
        npos = 0;
    end
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
     if det.gtnum(ii(jj)) ~= 0 
        result.pose.isnearby2(hh) = ii(jj);
        hh= hh+1;
     end
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
     if det.gtnum(ii(jj)) ~= 0 
        result.pose.isother(hh) = ii(jj);
        hh= hh+1;
     end
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

    gt2 = [];
    for j=1:length(det2.gtnum)
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
    end
    if ~isempty(gt2)
        ah=0;
        ai=find(result.pose.labels_pose == 4);
        for j = 1: length(ai);
            if det.isdiff(ai(j)) == 0
                ah = ah+1;
            end
        end
        npos = sum(~[gt.isdiff])-ah;
    else
        npos = 0;
    end
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
     if det.gtnum(ii(jj)) ~= 0 
        result.pose.isother2(hh) = ii(jj);
        hh= hh+1;
     end
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
ii = find(result.pose.labels_pose == 1);
hh=1;
for jj= 1:length(ii)
     if det.gtnum(ii(jj)) ~= 0 &&  det.isdiff(ii(jj)) == 0
        result.pose.isopp(hh) = ii(jj);
        hh= hh+1;
     end
end
 
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
gt2 = [];
for j=1:length(det2.gtnum)
    gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
end
if ~isempty(gt2)
    npos = sum(~[gt2.isdiff]);
    
else
    npos = 0;
end
dummy = [];
[result.pose.ignoreall, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
