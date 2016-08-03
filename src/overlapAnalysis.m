function [resultclass, result,f] = overlapAnalysis(dataset, objname, dataset_params, ann, det, metric_type, detector)

[sv, si] = sort(det.conf, 'descend');
det.bbox = det.bbox(si, :);
det.conf = det.conf(si);
det.rnum = det.rnum(si);
det.view = det.view(si, :);
overlapNames = {'weak', 'weak_1', 'weak_2', 'weak_3', 'strong', 'strong_1', 'strong_2', ...
    'strong_3', 'strong_4'};


for i=1:length(overlapNames)
    localization = overlapNames{i};
    [det, gt] = matchDetectionsWithGroundTruth(dataset, dataset_params, objname, ann, det, localization);
    npos = sum(~[gt.isdiff]);
    result.pose.ovanalisys(i) = averagePoseDetectionPrecision(det, gt, npos);
    aos(i) = result.pose.ovanalisys(i).aos;
    avp(i) = result.pose.ovanalisys(i).avp15;
    peap(i) = result.pose.ovanalisys(i).peap15;
    mae(i)= result.pose.ovanalisys(i).mean_error;
    medError(i)= result.pose.ovanalisys(i).median_error;
    ap(i) = result.pose.ovanalisys(i).ap; 
end
resultclass.aos = aos;
resultclass.avp = avp;
resultclass.peap = peap;
resultclass.mae = mae;
resultclass.medError = medError;
resultclass.ap = ap;

fs = 18;
f=1;

%% AOS
if metric_type == 1
    figure(f)
    plot([0.1:0.1:0.9],aos,'b','LineWidth',4); 
    hold on;
    plot([0.1:0.1:0.9],ap,'r','LineWidth',4); 
    xticks = 0.1:0.1:0.9;
    set(gca, 'xtick', xticks); 
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 1 0 1]);
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
    plot([0.1:0.1:0.9],avp,'b','LineWidth',4); 
    hold on;
    plot([0.1:0.1:0.9],ap,'r','LineWidth',4); 
    xticks = 0.1:0.1:0.9;
    set(gca, 'xtick', xticks); 
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 1 0 1]);
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
    plot([0.1:0.1:0.9],peap,'b','LineWidth',4); 
    hold on;
    plot([0.1:0.1:0.9],ap,'r','LineWidth',4); 
    xticks = 0.1:0.1:0.9;
    set(gca, 'xtick', xticks); 
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 1 0 1]);
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
    plot([0.1:0.1:0.9],mae,'b','LineWidth',4); 
    hold on;
    xticks = 0.1:0.1:0.9;
    set(gca, 'xtick', xticks); 
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 1 0 max(mae) + 20]);
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
    plot([0.1:0.1:0.9],medError,'b','LineWidth',4); 
    hold on;
    xticks = 0.1:0.1:0.9;
    set(gca, 'xtick', xticks); 
    set(gca, 'xticklabel', xticks, 'fontsize', fs);
    axis([0 1 0 max(mae) + 20]);
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