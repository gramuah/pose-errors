function writeAnalysisSummary(result, allnames, detector, fn)
% function writeAnalysisSummary(result, allnames, detector, fn)
%
% Create a txt file with the main results from the analysis
%
% Inputs:
% result: detection and pose estimation results
% allnames: selected object names
% detector: detector name
% fn: out file

close all;

for k  =1:numel(allnames)
    allnames{k} = allnames{k}(1:min(5, numel(allnames{k})));
end

fid = fopen(fn, 'w');
fprintf(fid, sprintf('Analysis: %s\n', detector));
fprintf(fid, sprintf('%s\n', date));

fprintf(fid, 'Detection and Pose Estimation Performance (AP, AOS, AVP and PEAP)\n');
fprintf(fid, '\n');
for i=1:length(allnames)
    fprintf(fid, 'Class: %s, AP: %.4f , AOS: %.4f, AVP (pi/12): %.4f, PEAP (pi/12): %.4f\n', result(i).tp.name, ...
        result(i).tp.pose.ap, result(i).tp.pose.aos, result(i).tp.pose.avp15, result(i).tp.pose.peap15);
end
fprintf(fid, '\n\n');
fprintf(fid, 'Impact on Pose Performance\n');

fprintf(fid, '\n');
for i=1:length(allnames)
    fprintf(fid, 'Class: %s\n', result(i).tp.name);
    fprintf(fid, 'Pose Distribution: F, F-L, L, L-Re, Re, Re-R, R, R-F\n');
    fprintf(fid, 'Distribution: %d, %d, %d, %d, %d,%d, %d, %d\n', ...
        result(i).tp.pose.hist_gt_views(1), result(i).tp.pose.hist_gt_views(2),result(i).tp.pose.hist_gt_views(3),...
        result(i).tp.pose.hist_gt_views(4), result(i).tp.pose.hist_gt_views(5), result(i).tp.pose.hist_gt_views(6),...
        result(i).tp.pose.hist_gt_views(7),result(i).tp.pose.hist_gt_views(8));
    
    fprintf(fid, 'Success Rate: %.2f, %.2f, %.2f, %.2f, %.2f,%.2f, %.2f, %.2f\n', ...
        (result(i).tp.pose.hist_views(1)/result(i).tp.pose.hist_gt_views(1))*100, ...
        (result(i).tp.pose.hist_views(2)/result(i).tp.pose.hist_gt_views(2))*100, ...
        (result(i).tp.pose.hist_views(3)/result(i).tp.pose.hist_gt_views(3))*100,...
        (result(i).tp.pose.hist_views(4)/result(i).tp.pose.hist_gt_views(4))*100, ...
        (result(i).tp.pose.hist_views(5)/result(i).tp.pose.hist_gt_views(5))*100, ...
        (result(i).tp.pose.hist_views(6)/result(i).tp.pose.hist_gt_views(6))*100,...
        (result(i).tp.pose.hist_views(7)/result(i).tp.pose.hist_gt_views(7))*100, ...
        (result(i).tp.pose.hist_views(8)/result(i).tp.pose.hist_gt_views(8))*100);
    
    fprintf(fid, 'Porcentage Error Modes: Correct (Co), Opposite(Opp), Nearby(Near), Other(Oth)\n');
    fprintf(fid, 'Error Modes: %.2f, %.2f, %.2f, %.2f\n', result(i).fp.pose.no_error, result(i).fp.pose.opp_error, ...
        result(i).fp.pose.nearby_error,  result(i).fp.pose.other_error);
    
    fprintf(fid, 'Improvement by correcting Error Modes (AVP): Opposite(Opp), Nearby(Near), Other(Oth)\n');
    fprintf(fid, 'Improvement: %.2f, %.2f, %.2f\n', result(i).fp.pose.correctopp.avp15-result(i).fp.pose.avp15, ...
        result(i).fp.pose.correctnearby.avp15-result(i).fp.pose.avp15, ...
        result(i).fp.pose.correctother.avp15-result(i).fp.pose.avp15);
    %
    %      fprintf(fid, 'Summary of Sensitivity and Impact of Object Characteristics:\n');
    %      fprintf(fid, 'occlusion/truncation (occ-trn), difficult objects (diff), object size (size), aspect ratio (asp), visible sides (side) and part visibility (part)\n');
    
    fprintf(fid, '\n\n');
end


fclose(fid);