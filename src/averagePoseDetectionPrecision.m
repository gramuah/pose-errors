function [result, resultclass] = averagePoseDetectionPrecision(det, gt, npos, diff_flag)
% result = averagePoseDetectionPrecision(det, gt, npos, nnorm)
%
% Computes full interpolated average precision, first normalizing the 
% precision values.  
% Normally, p = tp ./ (fp + tp), but this is sensitive to the density of
% positive examples.  
%
% Input:
%   det(ndet, 1): detections
%   gt: ground truth annotations
%   npos: the number of ground truth positive examples
%   nnorm: the normalized value for number of positives (for normalized AP)
%
% Output:
%   result.(labels, conf, npos, r, p, ap, ap_std, MAE, MedErr, std_err, ...
%               aos, avp):
%     the precision-recall and normalized precision-recall curves with AP
%     and standard error of AP. Pose estimation analysis: aos, avp, MAE and MedErr 
%

if nargin < 4
    diff_flag = 0;
end

[sv, si] = sort(det.conf, 'descend');
label = det.label(si); 
label_pose = zeros(length(det.label),1); % label (-1, 1; 0=don't care)
ind_fp=find(label==-1);
if diff_flag
    ind_tp=find(label==1 | label==0);
else
    ind_tp=find(label==1);
end

% compute average precision in pose estimation
tmp=zeros(1,length(label));
tmp_v=zeros(1,length(label));
tmp_v15=zeros(1,length(label));

tp_peap_15=zeros(1,length(label));
fp_peap_15=ones(1,length(label));

tp_peap_30=zeros(1,length(label));
fp_peap_30=ones(1,length(label));

viewcountvector = zeros(1,8);
viewcountvector_opp = zeros(1,8);
viewcountvector_near = zeros(1,8);
viewcountvector_oth = zeros(1,8);
gtviewcountvector = gt.gtviewvector;
error_azimuth = [];
vnum_test = [4 8 16 24];
tmp_bins=zeros(length(label), size(vnum_test,2));
tp_peap_bins=zeros(length(label), size(vnum_test,2));
fp_peap_bins=ones(length(label), size(vnum_test,2));
resultclass.obj = zeros(1,length(label));
resultclass.err = zeros(1,length(label));
for h=1:length(ind_tp)
    if gt.viewpoint(det.gtnum(ind_tp(h))).azimuth ~= 0 
         gtview = gt.viewpoint(det.gtnum(ind_tp(h))).azimuth;
    else
         gtview = gt.viewpoint(det.gtnum(ind_tp(h))).azimuth_coarse;
    end
    error_azimuth(h) = min(mod(det.view(ind_tp(h),1)-gtview,360), ...
        mod(gtview-det.view(ind_tp(h),1),360));
    
        resultclass.obj(h) = det.gtnum(ind_tp(h));
        resultclass.err(h) = error_azimuth(h);
    
    tmp(ind_tp(h))=(1 + cos((error_azimuth(h)*pi)/180))/2; % AOS
    
    if error_azimuth(h) < 15 % pi/12 --> AVP_15
        tmp_v15(ind_tp(h))=1;
        tp_peap_15(ind_tp(h))=1;
        fp_peap_15(ind_tp(h))=0;
    else
        tmp_v15(ind_tp(h))=0;
        fp_peap_15(ind_tp(h))=1;
    end
    
    if error_azimuth(h) < 30 % pi/6 --> AVP_30
        tmp_v(ind_tp(h))=1;
        tp_peap_30(ind_tp(h))=1;
        fp_peap_30(ind_tp(h))=0;
    else
        tmp_v(ind_tp(h))=0;
        fp_peap_30(ind_tp(h))=1;
    end
    
    for av = 1:size(vnum_test,2)
        azimuth_interval = [0 (360/(vnum_test(av)*2)):(360/vnum_test(av)):360-(360/(vnum_test(av)*2))];
        view_gt = find_interval(gtview, azimuth_interval);
        view_pr = find_interval(det.view(ind_tp(h),1), azimuth_interval);
        
        if view_pr == view_gt
            tmp_bins(ind_tp(h),av)=1;
            tp_peap_bins(ind_tp(h),av)=1;
            fp_peap_bins(ind_tp(h),av)=0;
        else
            tmp_bins(ind_tp(h),av)=0;
            fp_peap_bins(ind_tp(h),av)=1;
        end
    end
    %% error classification: 
    % label 1 --> error < 15 (correct); 
    % label 2 -->  error > 165 (opposite); 
    % label 3 --> 15 < error < 30 (nearby);
    % label 4 --> others
    
    flag = 0;
       
    if error_azimuth(h) <= 15
        label_pose(ind_tp(h)) = 1;
        flag = 1;
        if gtview <= 25 || gtview > 340
            viewcountvector(1) = viewcountvector(1) + 1;
        end
        if gtview <= 70 && gtview > 25
            viewcountvector(2) = viewcountvector(2) + 1;
        end
        if gtview <= 115 && gtview > 70
            viewcountvector(3) = viewcountvector(3) + 1;
        end
        if gtview <= 160 && gtview > 115
            viewcountvector(4) = viewcountvector(4) + 1;
        end
        if gtview <= 205 && gtview > 160
            viewcountvector(5) = viewcountvector(5) + 1;
        end
        if gtview <= 250 && gtview > 205
            viewcountvector(6) = viewcountvector(6) + 1;
        end
        if gtview <= 295 && gtview > 250
            viewcountvector(7) = viewcountvector(7) + 1;
        end
        if gtview <= 340 && gtview > 295
            viewcountvector(8) = viewcountvector(8) + 1;
        end
           
    end
    
    if error_azimuth(h) > 165
        label_pose(ind_tp(h)) = 2;
        flag = 1;
        
        if  gtview <= 25 ||  gtview > 340
            viewcountvector_opp(1) = viewcountvector_opp(1) + 1;
        end
        if  gtview <= 70 &&  gtview > 25
            viewcountvector_opp(2) = viewcountvector_opp(2) + 1;
        end
        if  gtview <= 115 &&  gtview > 70
            viewcountvector_opp(3) = viewcountvector_opp(3) + 1;
        end
        if gtview <= 160 && gtview > 115
            viewcountvector_opp(4) = viewcountvector_opp(4) + 1;
        end
        if gtview <= 205 && gtview > 160
            viewcountvector_opp(5) = viewcountvector_opp(5) + 1;
        end
        if gtview <= 250 && gtview > 205
            viewcountvector_opp(6) = viewcountvector_opp(6) + 1;
        end
        if gtview <= 295 && gtview > 250
            viewcountvector_opp(7) = viewcountvector_opp(7) + 1;
        end
        if gtview <= 340 && gtview > 295
            viewcountvector_opp(8) = viewcountvector_opp(8) + 1;
        end
    end
    if error_azimuth(h) > 15 && error_azimuth(h) <= 30
        label_pose(ind_tp(h)) = 3;
        flag = 1;
        if gtview <= 25 || gtview > 340
            viewcountvector_near(1) = viewcountvector_near(1) + 1;
        end
        if gtview <= 70 && gtview > 25
            viewcountvector_near(2) = viewcountvector_near(2) + 1;
        end
        if gtview <= 115 && gtview > 70
            viewcountvector_near(3) = viewcountvector_near(3) + 1;
        end
        if gtview <= 160 && gtview > 115
            viewcountvector_near(4) = viewcountvector_near(4) + 1;
        end
        if gtview <= 205 && gtview > 160
            viewcountvector_near(5) = viewcountvector_near(5) + 1;
        end
        if gtview <= 250 && gtview > 205
            viewcountvector_near(6) = viewcountvector_near(6) + 1;
        end
        if gtview <= 295 && gtview > 250
            viewcountvector_near(7) = viewcountvector_near(7) + 1;
        end
        if gtview <= 340 && gtview > 295
            viewcountvector_near(8) = viewcountvector_near(8) + 1;
        end
        
    end
    if flag == 0
        label_pose(ind_tp(h)) = 4;
        if gtview <= 25 || gtview > 340
            viewcountvector_oth(1) = viewcountvector_oth(1) + 1;
        end
        if gtview <= 70 && gtview > 25
            viewcountvector_oth(2) = viewcountvector_oth(2) + 1;
        end
        if gtview <= 115 && gtview > 70
            viewcountvector_oth(3) = viewcountvector_oth(3) + 1;
        end
        if gtview <= 160 && gtview > 115
            viewcountvector_oth(4) = viewcountvector_oth(4) + 1;
        end
        if gtview <= 205 && gtview > 160
            viewcountvector_oth(5) = viewcountvector_oth(5) + 1;
        end
        if gtview <= 250 && gtview > 205
            viewcountvector_oth(6) = viewcountvector_oth(6) + 1;
        end
        if gtview <= 295 && gtview > 250
            viewcountvector_oth(7) = viewcountvector_oth(7) + 1;
        end
        if gtview <= 340 && gtview > 295
            viewcountvector_oth(8) = viewcountvector_oth(8) + 1;
        end
        
    end
    
end

if ~isempty(error_azimuth)
    mean_error = mean(error_azimuth);
    median_error = median(error_azimuth);
    std_error = std(error_azimuth);
else
    mean_error = 0;
    median_error = 0;
    std_error = 0;
end


tp = cumsum(label==1);
fp = cumsum(label==-1);
conf = sv;

acc=cumsum(tmp);

accV=cumsum(tmp_v);
accV_15 = cumsum(tmp_v15);

tp_peap_15 = cumsum(tp_peap_15);
fp_peap_15 = cumsum(fp_peap_15);
tp_peap_30 = cumsum(tp_peap_30);
fp_peap_30 = cumsum(fp_peap_30);

for av=1:size(vnum_test,2)
    accV_bins = cumsum(tmp_bins(:,av));
    tp_peap = cumsum(tp_peap_bins(:,av));
    fp_peap = cumsum(fp_peap_bins(:,av));
    r_peap(:,av) = tp_peap / npos;
    p_peap(:,av) = tp_peap./(fp_peap+tp_peap);
    p_avp_bins(:,av) = accV_bins ./(fp+tp);
end

r = tp / npos;
p = tp ./ (tp + fp);

r_peap15 = tp_peap_15 / npos;
p_peap15 = tp_peap_15 ./ (tp_peap_15 + fp_peap_15);

r_peap30 = tp_peap_30 / npos;
p_peap30 = tp_peap_30 ./ (tp_peap_30 + fp_peap_30);

p_aos = acc./(fp+tp)';
p_avp30=accV./(fp+tp)';
p_avp15=accV_15 ./(fp+tp)';


result = struct('labels', label, 'labels_pose', label_pose, 'hist_views', viewcountvector, 'hist_gt_views', gtviewcountvector, ...
    'hist_opp_views', viewcountvector_opp, 'hist_near_views', viewcountvector_near, ...
    'hist_oth_views', viewcountvector_oth,'conf', conf, 'r', r, 'p', p, ...
    'p_aos', p_aos, 'p_avp30', p_avp30, ...
    'p_avp15', p_avp15, 'p_peap15', p_peap15, 'r_peap15', r_peap15, ...
    'p_peap30', p_peap30, 'r_peap30', r_peap30);

result.npos = npos;

result.mean_error = mean_error;
result.median_error = median_error;
result.std_error = std_error;

for av=1:size(vnum_test,2)
     result.p_avp_bins(:,av) =  p_avp_bins(:,av);
     result.p_peap_bins(:,av) =  p_peap(:,av);
     result.r_peap_bins(:,av) =  r_peap(:,av);
end

%% Error types
result.opp_error= (length(find(error_azimuth>165))/length(error_azimuth))*100;
result.nearby_error= (length(find(error_azimuth>15 & error_azimuth<30))/length(error_azimuth))*100;
result.no_error= (length(find(error_azimuth<=15))/length(error_azimuth))*100;
result.other_error= 100 - (result.opp_error+result.nearby_error+result.no_error);

result.opp_error_count= length(find(error_azimuth>165));
result.nearby_error_count= length(find(error_azimuth>15 & error_azimuth<30));
result.no_error_count= length(find(error_azimuth<=15));
result.other_error_count= length(error_azimuth) - (result.opp_error_count+result.nearby_error_count+result.no_error_count);

% compute interpolated precision and precision (AP)
istp = (label==1);
[result.ap, result.pi] = calcule_ap(r, p);

missed = zeros(npos-sum(label==1),1);
result.ap_stderr = std([p(istp(:)) ; missed])/sqrt(npos);

%% compute interpolated precision and normalized precision for pose (AOS, AVP and PEAP)
% AOS 
[result.aos, result.aos_pi] = calcule_ap(r, p_aos);
result.aos_stderr = std([p_aos(istp(:))' ; missed])/sqrt(npos);

% AVP 
[result.avp30, result.avp_pi30] = calcule_ap(r, p_avp30);
result.avp_stderr30 = std([p_avp30(istp(:))' ; missed])/sqrt(npos);

[result.avp15, result.avp_pi15] = calcule_ap(r, p_avp15);
result.avp_stderr15 = std([p_avp15(istp(:))' ; missed])/sqrt(npos);

% PEAP
[result.peap30, result.peap_pi30] = calcule_ap(r_peap30', p_peap30);
result.peap_stderr30 = std([p_peap30(istp(:))' ; missed])/sqrt(npos);

[result.peap15, result.peap_pi15] = calcule_ap(r_peap15', p_peap15);
result.peap_stderr15 = std([p_peap15(istp(:))' ; missed])/sqrt(npos);

for av=1:size(vnum_test,2)
    [result.avp_bin(av), result.avp_pi_bin(:,av)] = calcule_ap(r, p_avp_bins(:,av));
    [result.peap_bin(av), result.peap_pi_bin(:,av)] = calcule_ap(r_peap(:,av), p_peap(:,av));
    result.avp_stderr_bin(av) = std([p_avp_bins(istp(:), av) ; missed])/sqrt(npos);
end

function ind = find_interval(azimuth, a)

for i = 1:numel(a)
    if azimuth < a(i)
        break;
    end
end
ind = i - 1;
if azimuth > a(end)
    ind = 1;
end

function [ap, mpre] = calcule_ap(rec, prec)
mrec = [0; rec; 1];
if size(prec,1) >= size(prec,2)
    mpre = [0; prec; 0];
else
    mpre = [0; prec'; 0];
end
for i = numel(mpre)-1:-1:1
    mpre(i) = max(mpre(i), mpre(i+1));
end
i = find(mrec(2:end) ~= mrec(1:end-1)) + 1;
ap = sum((mrec(i) - mrec(i-1)) .* mpre(i));