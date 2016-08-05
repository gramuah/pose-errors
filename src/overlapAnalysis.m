function [resultclass, result, f] = overlapAnalysis(dataset, objname, ...
    dataset_params, ann, det, metric_type, detector, result, overlapNames)

% function [resultclass, result, f] = overlapAnalysis(dataset, objname, ...
%    dataset_params, ann, det, metric_type, detector, result, overlapNames)
%
% Overlap Analysis
%
% Inputs:
% dataset: dataset
% objname: object name
% dataset_params = dataset parameters
% ann: dataset annotations
% det: detections
% metric_type = metric
% detector: detector name
% results: detection results
% overlapNames: names to specify localization criteria

[sv, si] = sort(det.conf, 'descend');
det.bbox = det.bbox(si, :);
det.conf = det.conf(si);
det.rnum = det.rnum(si);
det.view = det.view(si, :);


aos = zeros(1,length(overlapNames));
avp = zeros(1,length(overlapNames));
peap = zeros(1,length(overlapNames));
mae = zeros(1,length(overlapNames));
medError = zeros(1,length(overlapNames));
ap = zeros(1,length(overlapNames));
ov_vector = zeros(1,length(overlapNames));

for i=1:length(overlapNames)
    localization = overlapNames{i};
    switch localization
        case 'weak'  % also duplicate detections are ignored, per last line
            ov_vector(i) = 0.1;
        case 'strong'
            ov_vector(i) = 0.5;
        case 'weak_1'
            ov_vector(i) = 0.2;
        case 'weak_2'
            ov_vector(i) = 0.3;
        case 'weak_3'
            ov_vector(i) = 0.4;
        case 'strong_1'
            ov_vector(i) = 0.6;
        case 'strong_2'
            ov_vector(i) = 0.7;
        case 'strong_3'
            ov_vector(i) = 0.8;
        case 'strong_4'
            ov_vector(i) = 0.9;
        otherwise
            error('invalid localization criterion: %s', localization)
    end
    
    [det, gt] = matchDetectionsWithGroundTruth(dataset, dataset_params, objname, ann, det, localization);
    npos = sum(~[gt.isdiff]);
    result.pose.ovanalysis(i) = averagePoseDetectionPrecision(det, gt, npos);
    aos(i) = result.pose.ovanalysis(i).aos;
    avp(i) = result.pose.ovanalysis(i).avp15;
    peap(i) = result.pose.ovanalysis(i).peap15;
    mae(i)= result.pose.ovanalysis(i).mean_error;
    medError(i)= result.pose.ovanalysis(i).median_error;
    ap(i) = result.pose.ovanalysis(i).ap;
end
resultclass.aos = aos;
resultclass.avp = avp;
resultclass.peap = peap;
resultclass.mae = mae;
resultclass.medError = medError;
resultclass.ap = ap;
resultclass.ov_vector = ov_vector;

fs = 18;
f=1;

%% AOS
if metric_type == 1
    figure(f)
    plot(ov_vector,aos,'b','LineWidth',4);
    hold on;
    plot(ov_vector,ap,'r','LineWidth',4);
    xticks = ov_vector;
    set(gca, 'xtick', xticks);
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 max(ov_vector)+0.1 0 1]);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    title(objname, 'fontsize', fs, 'fontweight', 'bold')
    ylabel('AOS', 'fontsize',fs, 'fontweight', 'bold');
    xlabel('Overlap Criteria','fontsize', fs, 'fontweight', 'bold')
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    for k=1:length(aos)
        text(xticks(k), aos(k)+0.05, sprintf('%0.2f', aos(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [0 0 1]);
        if strcmp(detector(length(detector)-1:length(detector)), 'gt')
            text(xticks(k), ap(k)-0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        else
            text(xticks(k), ap(k)+0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        end
    end
    hold off;
end

%% AVP
if metric_type == 2
    figure(f)
    plot(ov_vector,avp,'b','LineWidth',4);
    hold on;
    plot(ov_vector,ap,'r','LineWidth',4);
    xticks = ov_vector;
    set(gca, 'xtick', xticks);
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 max(ov_vector)+0.1 0 1]);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    title(objname, 'fontsize', fs, 'fontweight', 'bold')
    ylabel('AVP', 'fontsize',fs, 'fontweight', 'bold');
    xlabel('Overlap Criteria','fontsize', fs, 'fontweight', 'bold')
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    for k=1:length(aos)
        text(xticks(k), avp(k)+0.05, sprintf('%0.2f', avp(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [0 0 1]);
        if strcmp(detector(length(detector)-1:length(detector)), 'gt')
            text(xticks(k), ap(k)-0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        else
            text(xticks(k), ap(k)+0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        end
    end
    hold off;
end

%% PEAP
if metric_type == 3
    figure(f)
    plot(ov_vector,peap,'b','LineWidth',4);
    hold on;
    plot(ov_vector,ap,'r','LineWidth',4);
    xticks =ov_vector;
    set(gca, 'xtick', xticks);
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 max(ov_vector)+0.1 0 1]);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    title(objname, 'fontsize', fs, 'fontweight', 'bold')
    ylabel('PEAP', 'fontsize',fs, 'fontweight', 'bold');
    xlabel('Overlap Criteria','fontsize', fs, 'fontweight', 'bold')
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    for k=1:length(aos)
        text(xticks(k), peap(k)+0.05, sprintf('%0.2f', peap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [0 0 1]);
        if strcmp(detector(length(detector)-1:length(detector)), 'gt')
            text(xticks(k), ap(k)-0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        else
            text(xticks(k), ap(k)+0.05, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
                'Color', [1 0 0]);
        end
    end
    hold off;
end

%% MAE
if metric_type == 4
    figure(f)
    plot(ov_vector,mae,'b','LineWidth',4);
    hold on;
    xticks = ov_vector;
    set(gca, 'xtick', xticks);
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 max(ov_vector)+0.1 0 max(mae) + 20]);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    
    title(objname, 'fontsize', fs, 'fontweight', 'bold')
    ylabel('MAE', 'fontsize',fs, 'fontweight', 'bold');
    xlabel('Overlap Criteria', 'fontsize',fs, 'fontweight', 'bold')
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    for k=1:length(mae)
        text(xticks(k), mae(k)+3, sprintf('%0.1f', mae(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [0 0 1]);
        text(xticks(k), mae(k)+9, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [1 0 0]);
    end
    hold off;
end

%% MedError
if metric_type == 5
    figure(f)
    plot(ov_vector,medError,'b','LineWidth',4);
    hold on;
    xticks = ov_vector;
    set(gca, 'xtick', xticks);
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 max(ov_vector)+0.1 0 max(mae) + 20]);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    
    title(objname, 'fontsize', fs, 'fontweight', 'bold')
    ylabel('MedError', 'fontsize',fs, 'fontweight', 'bold');
    xlabel('Overlap Criteria', 'fontsize',fs, 'fontweight', 'bold')
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    for k=1:length(mae)
        text(xticks(k), medError(k)+3, sprintf('%0.1f', medError(k)), ...
            'fontsize', fs, 'FontWeight', 'bold');
        text(xticks(k), mae(k)+9, sprintf('%0.2f', ap(k)), 'fontsize', fs, 'FontWeight', 'bold', ...
            'Color', [1 0 0]);
    end
    hold off;
end