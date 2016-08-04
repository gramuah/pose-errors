function result = analyzeDetections(dataset, dataset_params, objname, det, ann, localization)
% result = analyzeDetections(dataset, dataset_params, objname, det, ann, localization)
%
% Input:
%   dataset: name of the dataset (e.g., PASCAL3D+)
%   dataset_params: parameters of the dataset
%   objname: name of the object class 
%   det.(bbox, conf, rnum): object detection results
%   ann: dataset annotations
%   localization: 'weak' or 'strong' to specify localization criteria
%
% Output:
%   result: set of precision-recall and aos/avp/peap/errors statistics


switch dataset
  case {'PASCAL3D+'}
                         
    result = analyzeDetections_PASCAL3D(dataset, dataset_params, objname, ...
        ann, det, localization);
        
  otherwise
    error('dataset %s is unknown\n', dataset);
end  

result.name = objname;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = analyzeDetections_PASCAL3D(dataset, dataset_params, objname, ...
    ann, det, localization)

rec = ann.rec;

[det.conf, si] = sort(det.conf, 'descend');
det.bbox = det.bbox(si, :);
det.rnum = det.rnum(si);
det.view = det.view(si, :);

[det, gt] = matchDetectionsWithGroundTruth(dataset, dataset_params, objname, ann, det, localization);
result.localization = localization;

result.gt = gt;
result.gt.bbox_conf = zeros(gt.N, 4);
result.gt.bbox_conf(gt.detnum>0, 1:4) = det.bbox(gt.detnum(gt.detnum>0), :); 
result.gt.bbox_ov = zeros(gt.N, 4);
result.gt.bbox_ov(gt.detnum_ov>0, 1:4) = det.bbox(gt.detnum_ov(gt.detnum_ov>0), :); 

result.det.bbox = det.bbox;
result.det.view = det.view;
result.det.conf = det.conf;
result.det.gtnum = det.gtnum;
result.det.rnum = det.rnum;
result.det.isduplicate = det.isduplicate;

%% Obtaining Precision-recall curves

% Overall
npos = sum(~[gt.isdiff]);
dummy = [];
[result.pose, dummy] = averagePoseDetectionPrecision(det, gt, npos);

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

%% Object Characteristic Analysis 
% (occ/trunc. objects, object size, aspect ratio, part visibility, visible side)

% Occlusion
result.gt.occ_level = zeros(gt.N, 1);
for level = 1:2  
  deto = det;
  npos = 0;
  for k = 1:gt.N    
    if gt.isdiff(k), continue; end;
    r = gt.rnum(k);
    o = gt.onum(k);
    if rec(r).objects(o).detailedannotation
      result.gt.occ_level(k) = rec(r).objects(o).details.occ_level;
      if rec(r).objects(o).details.occ_level~=level;
        i = (det.label==1 & det.gtnum==k);
        deto.label(i) = 0;
      else
        npos = npos+1;
      end
    end
  end
  dummy = [];
  [result.occ(level), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end

% Truncation
result.gt.truncated = zeros(gt.N, 1);
for val = 0:1
  deto = det;
  npos = 0;
  for k = 1:gt.N    
    if gt.isdiff(k), continue; end;
    r = gt.rnum(k);
    o = gt.onum(k);
    if rec(r).objects(o).truncated~=val      
      result.gt.truncated(k) = rec(r).objects(o).truncated;
      i = (det.label==1 & det.gtnum==k);
      deto.label(i) = 0;
    else
      npos = npos+1;
    end
  end
  dummy = [];
  [result.truncated(val+1), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end

% Truncation and Occlusion
result.gt.trunc_occ = zeros(gt.N, 1);

for val = 1:2
    deto = det;
    npos = 0;
    for k = 1:gt.N    
        if gt.isdiff(k), continue; end;
        r = gt.rnum(k);
        o = gt.onum(k);
        if val == 2
            if rec(r).objects(o).truncated == 1 || rec(r).objects(o).occluded == 1      
                result.gt.trunc_occ(k) = 1;
                npos = npos+1;
            else 
                i = (det.label==1 & det.gtnum==k);
                deto.label(i) = 0;
            end
        else
            if rec(r).objects(o).truncated == 0 && rec(r).objects(o).occluded == 0
                result.gt.trunc_occ(k) = 0;
                npos = npos+1;
            else 
                i = (det.label==1 & det.gtnum==k);
                deto.label(i) = 0;
            end
        end
    end
dummy = [];
[result.trunc_occ(val), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end

% Ignore truncated and occluded objects: remove objects with labels: isocc == 1 and
% istrunc == 1
ob_gtindex = []; 
ob_gtindex= unique(find((gt.istrunc == 0) & (gt.isocc==0)));
hh=1;
for jj= 1:length(ob_gtindex)
     if gt.detnum(ob_gtindex(jj)) ~= 0 
        result.pose.isocc(hh) = gt.detnum(ob_gtindex(jj));
        hh= hh+1;
     end
end
det2=[];

if hh > 1 
        
    det2.bbox = det.bbox(result.pose.isocc,:);
    det2.conf = det.conf(result.pose.isocc,:);
    det2.rnum = det.rnum(result.pose.isocc,:);
    det2.view = det.view(result.pose.isocc,:);
    det2.nimages = det.nimages;
    det2.N = det.N;
    det2.gtnum = det.gtnum(result.pose.isocc,:);
    det2.ov = det.ov(result.pose.isocc,:);
    det2.ov_obj = det.ov_obj(result.pose.isocc,:);
    det2.ov_gt = det.ov_gt(result.pose.isocc,:);
    det2.isdiff = det.isdiff(result.pose.isocc,:);
    det2.label = det.label(result.pose.isocc,:);
    det2.label_occ = det.label_occ(result.pose.isocc,:);
    det2.label_trunc = det.label_trunc(result.pose.isocc,:);
    det2.isduplicate = det.isduplicate(result.pose.isocc,:);
    gt2=[];
    for j=1:length(result.pose.isocc)
        gt2.isdiff(j) = gt.isdiff(det.gtnum(result.pose.isocc(j)), :);
    end
    if ~isempty(gt2)
        ah=0;
        ai=unique(find((gt.istrunc == 1) | (gt.isocc==1)));
        for j = 1: length(ai);
            if gt.isdiff(ai(j)) == 0
                ah = ah+1;
            end
        end
        npos = sum(~[gt.isdiff])-ah;
    else
        npos = 0;
    end
    dummy = [];
    [result.pose.ignoreocc, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
else
    result.pose.ignoreocc = [];
end

% Considering only truncated and occluded objects: remove objects with labels: isocc == 0 and
% istrunc == 0
ob_gtindex = []; 
ob_gtindex= unique(find((gt.istrunc == 1) & (gt.isocc==1)));
hh=1;
for jj= 1:length(ob_gtindex)
     if gt.detnum(ob_gtindex(jj)) ~= 0 
        result.pose.occind(hh) = gt.detnum(ob_gtindex(jj));
        hh= hh+1;
     end
end
det2=[];
if hh > 1 
    
    det2.bbox = det.bbox(result.pose.occind,:);
    det2.conf = det.conf(result.pose.occind,:);
    det2.rnum = det.rnum(result.pose.occind,:);
    det2.view = det.view(result.pose.occind,:);
    det2.nimages = det.nimages;
    det2.N = det.N;
    det2.gtnum = det.gtnum(result.pose.occind,:);
    det2.ov = det.ov(result.pose.occind,:);
    det2.ov_obj = det.ov_obj(result.pose.occind,:);
    det2.ov_gt = det.ov_gt(result.pose.occind,:);
    det2.isdiff = det.isdiff(result.pose.occind,:);
    det2.label = det.label(result.pose.occind,:);
    det2.label_occ = det.label_occ(result.pose.occind,:);
    det2.label_trunc = det.label_trunc(result.pose.occind,:);
    det2.isduplicate = det.isduplicate(result.pose.occind,:);
    gt2=[];
    for j=1:length(result.pose.occind)
        gt2.isdiff(j) = gt.isdiff(det.gtnum(result.pose.occind(j)), :);
    end
    if ~isempty(gt2)
        ah=0;
        ai=unique(find((gt.istrunc == 0) | (gt.isocc==0)));
        for j = 1: length(ai);
            if gt.isdiff(ai(j)) == 0
                ah = ah+1;
            end
        end
        npos = sum(~[gt.isdiff])-ah;
        
    else
        npos = 0;
    end
    dummy = [];
    [result.pose.onlyocc, dummy] = averagePoseDetectionPrecision(det2, gt, npos);
else
    result.pose.onlyocc = [];
end

% BBox Area
bb = gt.bbox(~[gt.isdiff], :);
gtarea = (bb(:, 3)-bb(:, 1)+1).*(bb(:, 4)-bb(:, 2)+1);
[sa, si] = sort(gtarea, 'ascend');
athresh = [0 sa(round([1/10 3/10 7/10 9/10]*size(bb,1)))'];
alabel(~[gt.isdiff]) = sum(repmat(gtarea, [1 5])>repmat(athresh, [size(bb, 1) 1]), 2);
alabel(logical([gt.isdiff])) = 0;
result.gt.area = alabel;
for a = 1:5  
  deto = det;
  npos = sum(alabel==a &~ [gt.isdiff]');
  ind = find(deto.label==1);
  gti = deto.gtnum(ind);
  ind = ind(alabel(gti)~=a);
  deto.label(ind) = 0;
  dummy = [];
  [result.area(a), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end
areathresh = athresh;

% BBox Height
alabel = [];
bb = gt.bbox(~[gt.isdiff], :);
gtheight = (bb(:, 4)-bb(:, 2)+1);
[sa, si] = sort(gtheight, 'ascend');
athresh = [0 sa(round([1/10 3/10 7/10 9/10]*size(bb,1)))'];
alabel(~[gt.isdiff]) = sum(repmat(gtheight, [1 5])>repmat(athresh, [size(bb, 1) 1]), 2);
alabel(logical([gt.isdiff])) = 0;
for a = 1:5  
  deto = det;
  npos = sum(alabel==a &~ [gt.isdiff]');
  ind = find(deto.label==1);
  gti = deto.gtnum(ind);
  ind = ind(alabel(gti)~=a);
  deto.label(ind) = 0;
  dummy = [];
  [result.height(a), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end
result.gt.height = alabel;
heightthresh = athresh;


% Aspect Ratio
bb = gt.bbox(~[gt.isdiff], :);
gtaspect = (bb(:, 3)-bb(:, 1)+1)./(bb(:, 4)-bb(:, 2)+1);
[sa, si] = sort(gtaspect, 'ascend');
athresh = [0 sa(round([1/10 3/10 7/10 9/10]*size(bb,1)))'];
alabel(~[gt.isdiff]) = sum(repmat(gtaspect, [1 5])>repmat(athresh, [size(bb, 1) 1]), 2);
alabel(logical([gt.isdiff])) = 0;
for a = 1:5  
  deto = det;
  npos = sum(alabel==a &~ [gt.isdiff]');
  ind = find(deto.label==1);
  gti = deto.gtnum(ind);
  ind = ind(alabel(gti)~=a);
  deto.label(ind) = 0;
  dummy = [];
  [result.aspect(a), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
end
result.gt.aspect = alabel;
aspectthresh = athresh;

% Pose estimation vs BBox Area
bb = gt.bbox;
gtarea = (bb(:, 3)-bb(:, 1)+1).*(bb(:, 4)-bb(:, 2)+1);
[sa, si] = sort(gtarea, 'ascend');
athresh = [0 sa(round([1/10 3/10 7/10 9/10]*size(bb,1)))'];
alabel = sum(repmat(gtarea, [1 5])>repmat(athresh, [size(bb, 1) 1]), 2);
result.gt.area = alabel;
for a = 1:5 
  det2=[];
  ind=[];
  dummy = [];
  [ii dummy] = find(alabel==a);
  npos_aux=length(find(gt.isdiff(ii)==0));
  hh=1;
  for jj= 1:length(ii)
      if gt.detnum(ii(jj)) ~= 0 && gt.isdiff(ii(jj)) == 0
        ind(hh) = gt.detnum(ii(jj));
        hh= hh+1;
      end
  end
  det2.bbox = det.bbox(ind,:);
  det2.conf = det.conf(ind,:);
  det2.rnum = det.rnum(ind,:);
  det2.view = det.view(ind,:);
  det2.nimages = det.nimages;
  det2.N = det.N;
  det2.gtnum = det.gtnum(ind,:);
  det2.ov = det.ov(ind,:);
  det2.ov_obj = det.ov_obj(ind,:);
  det2.ov_gt = det.ov_gt(ind,:);
  det2.isdiff = det.isdiff(ind,:);
  det2.label = det.label(ind,:);
  det2.label_occ = det.label_occ(ind,:);
  det2.label_trunc = det.label_trunc(ind,:);
  det2.isduplicate = det.isduplicate(ind,:);
  gt2 = [];
  for j=1:length(det2.gtnum)
    if det2.gtnum(j) ~= 0
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
    end
  end
  if ~isempty(gt2)
     npos = npos_aux;%sum(~[gt2.isdiff]);
  else
      npos = 0;
  end
  dummy = [];
  [result.pose.onlythissize(a), dummy] = averagePoseDetectionPrecision(det2, gt, npos);
  
  det2=[];
  ind=[];
  ii=[];
  val=[];
  dummy = [];
  [ii dummy] = find(alabel~=a);
  npos_aux=length(find(gt.isdiff(ii)==0));
  hh=1;
  for jj= 1:length(ii)
      if gt.detnum(ii(jj)) ~= 0 && gt.isdiff(ii(jj)) == 0
        ind(hh) = gt.detnum(ii(jj));
        hh= hh+1;
      end
  end
  det2.bbox = det.bbox(ind,:);
  det2.conf = det.conf(ind,:);
  det2.rnum = det.rnum(ind,:);
  det2.view = det.view(ind,:);
  det2.nimages = det.nimages;
  det2.N = det.N;
  det2.gtnum = det.gtnum(ind,:);
  det2.ov = det.ov(ind,:);
  det2.ov_obj = det.ov_obj(ind,:);
  det2.ov_gt = det.ov_gt(ind,:);
  det2.isdiff = det.isdiff(ind,:);
  det2.label = det.label(ind,:);
  det2.label_occ = det.label_occ(ind,:);
  det2.label_trunc = det.label_trunc(ind,:);
  det2.isduplicate = det.isduplicate(ind,:);
  gt2 = [];
  for j=1:length(det2.gtnum)
    if det2.gtnum(j) ~= 0
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
    end
  end
  if ~isempty(gt2)
    npos = npos_aux;%sum(~[gt2.isdiff]);
  else
      npos = 0;
  end
  dummy = [];
  [result.pose.ignorethissize(a), dummy] = averagePoseDetectionPrecision(det2, gt, npos);
end

% Pose estimation vs Aspect Ratio
alabel = [];
bb = gt.bbox;
gtaspect = (bb(:, 3)-bb(:, 1)+1)./(bb(:, 4)-bb(:, 2)+1);
[sa, si] = sort(gtaspect, 'ascend');
athresh = [0 sa(round([1/10 3/10 7/10 9/10]*size(bb,1)))'];
alabel = sum(repmat(gtaspect, [1 5])>repmat(athresh, [size(bb, 1) 1]), 2);
for a = 1:5 
  det2=[];
  ii=[];
  ind=[];
  [ii dummy] = find(alabel==a);
  npos_aux=length(find(gt.isdiff(ii)==0));
  hh=1;
  for jj= 1:length(ii)
      if gt.detnum(ii(jj)) ~= 0 && gt.isdiff(ii(jj)) == 0
        ind(hh) = gt.detnum(ii(jj));
        hh= hh+1;
      end
  end
  det2.bbox = det.bbox(ind,:);
  det2.conf = det.conf(ind,:);
  det2.rnum = det.rnum(ind,:);
  det2.view = det.view(ind,:);
  det2.nimages = det.nimages;
  det2.N = det.N;
  det2.gtnum = det.gtnum(ind,:);
  det2.ov = det.ov(ind,:);
  det2.ov_obj = det.ov_obj(ind,:);
  det2.ov_gt = det.ov_gt(ind,:);
  det2.isdiff = det.isdiff(ind,:);
  det2.label = det.label(ind,:);
  det2.label_occ = det.label_occ(ind,:);
  det2.label_trunc = det.label_trunc(ind,:);
  det2.isduplicate = det.isduplicate(ind,:);
  gt2 = [];
  for j=1:length(det2.gtnum)
    if det2.gtnum(j) ~= 0
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
    end
  end
  if ~isempty(gt2)
    npos = npos_aux;%sum(~[gt2.isdiff]);
  else
    npos = 0;
  end
  dummy = [];
  [result.pose.onlythisaspect(a), dummy] = averagePoseDetectionPrecision(det2, gt, npos);
  
  det2=[];
  ind=[];
  ii=[];
  val=[];
  [ii dummy] =find(alabel~=a);
  npos_aux=length(find(gt.isdiff(ii)==0));
  hh=1;
  for jj= 1:length(ii)
      if gt.detnum(ii(jj)) ~= 0 && gt.isdiff(ii(jj)) == 0
        ind(hh) = gt.detnum(ii(jj));
        hh= hh+1;
      end
  end
  det2.bbox = det.bbox(ind,:);
  det2.conf = det.conf(ind,:);
  det2.rnum = det.rnum(ind,:);
  det2.view = det.view(ind,:);
  det2.nimages = det.nimages;
  det2.N = det.N;
  det2.gtnum = det.gtnum(ind,:);
  det2.ov = det.ov(ind,:);
  det2.ov_obj = det.ov_obj(ind,:);
  det2.ov_gt = det.ov_gt(ind,:);
  det2.isdiff = det.isdiff(ind,:);
  det2.label = det.label(ind,:);
  det2.label_occ = det.label_occ(ind,:);
  det2.label_trunc = det.label_trunc(ind,:);
  det2.isduplicate = det.isduplicate(ind,:);
  gt2 = [];
  for j=1:length(det2.gtnum)
      if det2.gtnum(j) ~= 0
        gt2.isdiff(j) = gt.isdiff(det2.gtnum(j), :);
      end
  end
  if ~isempty(gt2)
    npos = npos_aux;%sum(~[gt2.isdiff]);
  else
      npos = 0;
  end
  dummy = [];
  [result.pose.ignorethisaspect(a), dummy] = averagePoseDetectionPrecision(det2, gt, npos);
end

% Parts
i = find(~[gt.isdiff], 1, 'first'); 
if rec(gt.rnum(i)).objects(gt.onum(i)).detailedannotation
  pnames = fieldnames(rec(gt.rnum(i)).objects(gt.onum(i)).details.part_visible);
  for p = 1:numel(pnames)
    name = pnames{p};
    for val = 0:1
      deto = det;
      npos = 0;
      for k = 1:gt.N    
        r = gt.rnum(k);
        o = gt.onum(k);
        
        if rec(r).objects(o).detailedannotation
          result.gt.part.(name)(k) = rec(r).objects(o).details.part_visible.(name);
          if rec(r).objects(o).details.part_visible.(name)~=val         
            deto.label(det.label==1 & det.gtnum==k) = 0;
          else
              if gt.isdiff(k) == 0 
                npos = npos+1;
              end
          end
        end
      end
      dummy = [];
      [result.pose.part.(name)(val+1), dummy] = averagePoseDetectionPrecision(deto, gt, npos);
    end
  end
end

% Side
i = find(~[gt.isdiff], 1, 'first'); 
if rec(gt.rnum(i)).objects(gt.onum(i)).detailedannotation
  pnames = fieldnames(rec(gt.rnum(i)).objects(gt.onum(i)).details.side_visible);
  for p = 1:numel(pnames)
    name = pnames{p};
    for val = 0:1 %0 = non-visible 1 = visible
      deto = det;
      npos = 0;
      for k = 1:gt.N    
        r = gt.rnum(k);
        o = gt.onum(k);
        if rec(r).objects(o).detailedannotation
          result.gt.side.(name)(k) = rec(r).objects(o).details.side_visible.(name);
          if rec(r).objects(o).details.side_visible.(name)~=val         
            deto.label(det.label==1 & det.gtnum==k) = 0;
          else
              if gt.isdiff(k) == 0 
                npos = npos+1;
              end
          end
        end
      end
      dummy = [];
      [result.pose.side.(name)(val+1), dummy] =averagePoseDetectionPrecision(deto, gt, npos);
    end
  end
end

%% Statistics of missed vs. detected
% result.counts stores counts of properties of all and missed objects
% result.overlap stores maximum overlap of different kinds of objects
missedthresh = 0.05;

missed = true(gt.N, 1);
missed(det.gtnum(result.pose.p>=missedthresh & det.label==1)) = false;
missed(gt.isdiff) = false;
found = ~missed;
found(gt.isdiff) = false;

% occlusion/truncation
gtoccludedL = result.gt.occ_level(:)>=2 | result.gt.truncated(:);
gtoccludedM = result.gt.occ_level(:)>=3 | result.gt.truncated(:);
result.counts.missed.total = sum(missed);
result.counts.missed.occludedL = sum(missed.*gtoccludedL(:));
result.counts.missed.occludedM = sum(missed.*gtoccludedM(:));
result.counts.all.total = sum(missed)+sum(found);
result.counts.all.occludedL = sum(gtoccludedL);
result.counts.all.occludedM = sum(gtoccludedM);

result.overlap.all.all = mean(gt.ov);
gtnum = det.gtnum(det.gtnum==1);
result.overlap.detected.all = mean(gt.ov(gtnum));
ind = gtoccludedL(gtnum);
result.overlap.detected.occludedL = mean(gt.ov(gtnum(ind))); 
result.overlap.all.occludedL = mean(gt.ov(gtoccludedL));
ind = gtoccludedM(gtnum);
result.overlap.detected.occludedM = mean(gt.ov(gtnum(ind)));
result.overlap.all.occludedM = mean(gt.ov(gtoccludedM));

% area
alabel = result.gt.area(:);
alabel(logical([gt.isdiff])) = 0;
result.counts.missed.area = hist(alabel(missed & alabel>0), 1:5);
result.counts.all.area = hist(alabel(alabel>0), 1:5);

for k = 1:5
  ind = det.gtnum>0;
  ind(ind) = alabel(det.gtnum(ind))==k;
  result.overlap.detected.area(k) = mean(gt.ov(det.gtnum(ind)));
  result.overlap.all.area(k) = mean(gt.ov(alabel==k));
end

% aspect
alabel = result.gt.aspect(:);
alabel(logical([gt.isdiff])) = 0;
result.counts.all.aspectratio = hist(alabel(alabel>0), 1:5);
result.counts.missed.aspectratio = hist(alabel(missed  & alabel>0), 1:5);

for k = 1:5
  ind = det.gtnum>0;
  ind(ind) = alabel(det.gtnum(ind))==k;
  result.overlap.detected.aspectratio(k) = mean(gt.ov(det.gtnum(ind)));
  result.overlap.all.aspectratio(k) = mean(gt.ov(alabel==k));
end