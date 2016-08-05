function  [resultclass, f] = displayPerCharacteristicPosePlots(resultfp, result, detector, error_type)
%function [resutclass,f] = displayPerCharacteristicDetPlots(results_all, error_type)
%
% Object characteristic effect on pose estimation: save and display plots
%
% Inputs:
% result: detection results
% resultfp: pose error results (false positives)
% error_type: metric to analysis


close all
switch error_type
    case 1
        metric = 'AOS';
        
    case 2
        metric = 'AVP';
        
    case 3
        metric = 'PEAP';
        
    case 4
        metric = 'MAE';
        
    case 5
        metric = 'MedError';
        
end
%% Impact Bar Chart

% Obtained pose results:
tmp = [resultfp.pose];
AP = mean([tmp.ap]);
AOS = mean([tmp.aos]);
AVP = mean([tmp.avp15]);
PEAP = mean([tmp.peap15]);
MAE = mean([tmp.mean_error]);
MedErr = mean([tmp.median_error]);
resultclass.MAE = MAE;
resultclass.MedError = MedErr;

fs = 18;
f = 1;

%% occ vs non-occluded
tmp = [result.pose.ignoreocc];
occ_flag = 0;
if ~isempty(tmp)
    occ_flag = 1;
    ignore_OCC_aos = mean([tmp.aos]);
    ignore_OCC_avp = mean([tmp.avp15]);
    ignore_OCC_peap = mean([tmp.peap15]);
    ignore_OCC_mae = mean([tmp.mean_error]);
    ignore_OCC_mederr = mean([tmp.median_error]);
else
    occ_flag = 0;
    ignore_OCC_aos = 0;
    ignore_OCC_avp = 0;
    ignore_OCC_peap = 0;
    ignore_OCC_mae = 0;
    ignore_OCC_mederr = 0;
    
end

tmp = [result.pose.onlyocc];
occ_flag = 0;
if ~isempty(tmp)
    occ_flag = 1;
    only_OCC_aos = mean([tmp.aos]);
    only_OCC_avp = mean([tmp.avp15]);
    only_OCC_peap = mean([tmp.peap15]);
    only_OCC_mae = mean([tmp.mean_error]);
    only_OCC_mederr = mean([tmp.median_error]);
else
    occ_flag = 0;
    only_OCC_aos = 0;
    only_OCC_avp = 0;
    only_OCC_peap = 0;
    only_OCC_mae = 0;
    only_OCC_mederr = 0;
    
end

switch error_type
    case 1
        y = [0, 0, 0; ...
            AOS, ignore_OCC_aos, only_OCC_aos];
        x = [-2 2];
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('AOS','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Trunc/Occ. Objects'])
        
    case 2
        
        y = [0, 0, 0;
            AVP, ignore_OCC_avp, only_OCC_avp];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('AVP','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Trunc/Occ. Objects'])
    case 3
        
        y = [0, 0, 0;
            PEAP, ignore_OCC_peap, only_OCC_peap];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('PEAP','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Trunc/Occ. Objects'])
        
    case 4
        
        y = [0, 0, 0; ...
            MAE, ignore_OCC_mae, only_OCC_mae];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 ceil(max([MAE ignore_OCC_mae only_OCC_mae])+10) 0 4]);
        xlim = [0 ceil((max([MAE ignore_OCC_mae only_OCC_mae])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('MAE','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Trunc/Occ. Objects'])
        
    case 5
        y = [0, 0, 0; ...
            MedErr, ignore_OCC_mederr, only_OCC_mederr];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 ceil(max([MedErr ignore_OCC_mederr only_OCC_mederr])+10) 0 4]);
        xlim = [0 ceil((max([MedErr ignore_OCC_mederr only_OCC_mederr])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('MedError','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Trunc/Occ. Objects'])
end

%% diff vs non-diff
%%%%
f = f + 1;

tmp = [result.pose.diff];
diff_aos = mean([tmp.aos]);
diff_avp = mean([tmp.avp15]);
diff_peap = mean([tmp.peap15]);
diff_mae = mean([tmp.mean_error]);
diff_mederr = mean([tmp.median_error]);

tmp = [result.diff_nondiff(2)];
only_diff_aos = mean([tmp.aos]);
only_diff_avp = mean([tmp.avp15]);
only_diff_peap = mean([tmp.peap15]);
only_diff_mae = mean([tmp.mean_error]);
only_diff_mederr = mean([tmp.median_error]);

switch error_type
    case 1
        y = [0, 0, 0; ...
            AOS, diff_aos, only_diff_aos];
        x = [-2 2];
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('AOS','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Difficult Objects'])
        
    case 2
        
        y = [0, 0, 0;
            AVP, diff_avp, only_diff_avp];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('AVP','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Difficult Objects'])
    case 3
        
        y = [0, 0, 0;
            PEAP, diff_peap, only_diff_peap];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 1 0 4]);
        xlim = [0 1];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('PEAP','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Difficult Objects'])
        
    case 4
        
        y = [0, 0, 0; ...
            MAE, diff_mae, only_diff_mae];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 ceil(max([MAE ignore_OCC_mae only_OCC_mae])+10) 0 4]);
        xlim = [0 ceil((max([MAE ignore_OCC_mae only_OCC_mae])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('MAE','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Difficult Objects'])
        
    case 5
        y = [0, 0, 0; ...
            MedErr, diff_mederr, only_diff_mederr];
        x = [-2 2];
        
        figure(f), hold off;
        barh(x, y);
        
        axis([0 ceil(max([MedErr ignore_OCC_mederr only_OCC_mederr])+10) 0 4]);
        xlim = [0 ceil((max([MedErr ignore_OCC_mederr only_OCC_mederr])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        
        set(gca, 'ytick', 2)
        set(gca, 'yticklabel', {' '});
        ylabel('MedError','fontsize', fs,'Rotation',90);
        set(gca, 'fontsize', fs);
        title([resultfp.name ': Difficult Objects'])
end

%% object size analysis
%%%%
f = f + 1;
onlythissize_aos = zeros(1, length(result.pose.onlythissize));
onlythissize_avp = zeros(1, length(result.pose.onlythissize));
onlythissize_peap  = zeros(1, length(result.pose.onlythissize));
onlythissize_mae  = zeros(1, length(result.pose.onlythissize));
onlythissize_mederr = zeros(1, length(result.pose.onlythissize));
ignorethissize_aos = zeros(1, length(result.pose.onlythissize));
ignorethissize_avp = zeros(1, length(result.pose.onlythissize));
ignorethissize_peap = zeros(1, length(result.pose.onlythissize));
ignorethissize_mae = zeros(1, length(result.pose.onlythissize));
ignorethissize_mederr = zeros(1, length(result.pose.onlythissize));

for i=1:length(result.pose.onlythissize)
    
    tmp = [result.pose.onlythissize(i)];
    onlythissize_aos(i) = mean([tmp.aos]);
    onlythissize_avp(i) = mean([tmp.avp15]);
    onlythissize_peap(i) = mean([tmp.peap15]);
    onlythissize_mae(i) = mean([tmp.mean_error]);
    onlythissize_mederr(i) = mean([tmp.median_error]);
    
    tmp = [result.pose.ignorethissize(i)];
    ignorethissize_aos(i) = mean([tmp.aos]);
    ignorethissize_avp(i) = mean([tmp.avp15]);
    ignorethissize_peap(i) = mean([tmp.peap15]);
    ignorethissize_mae(i) = mean([tmp.mean_error]);
    ignorethissize_mederr(i) = mean([tmp.median_error]);
    
    
end

switch error_type
    case 1
        resultclass.extrasmall = onlythissize_aos(1);
        resultclass.small = onlythissize_aos(2);
        resultclass.large = onlythissize_aos(4);
        resultclass.extralarge = onlythissize_aos(5);
        y1 = [AOS, onlythissize_aos(1), ignorethissize_aos(1);
            AOS, onlythissize_aos(2), ignorethissize_aos(2);
            AOS, onlythissize_aos(3), ignorethissize_aos(3);
            AOS, onlythissize_aos(4), ignorethissize_aos(4);
            AOS, onlythissize_aos(5), ignorethissize_aos(5)];
        
    case 2
        resultclass.extrasmall = onlythissize_avp(1);
        resultclass.small = onlythissize_avp(2);
        resultclass.large = onlythissize_avp(4);
        resultclass.extralarge = onlythissize_avp(5);
        y1 = [AVP, onlythissize_avp(1), ignorethissize_avp(1);
            AVP, onlythissize_avp(2), ignorethissize_avp(2);
            AVP, onlythissize_avp(3), ignorethissize_avp(3);
            AVP, onlythissize_avp(4), ignorethissize_avp(4);
            AVP, onlythissize_avp(5), ignorethissize_avp(5)];
    case 3
        resultclass.extrasmall = onlythissize_peap(1);
        resultclass.small = onlythissize_peap(2);
        resultclass.large = onlythissize_peap(4);
        resultclass.extralarge = onlythissize_peap(5);
        y1 = [PEAP, onlythissize_peap(1), ignorethissize_peap(1);
            AVP, onlythissize_peap(2), ignorethissize_peap(2);
            AVP, onlythissize_peap(3), ignorethissize_peap(3);
            AVP, onlythissize_peap(4), ignorethissize_peap(4);
            AVP, onlythissize_peap(5), ignorethissize_peap(5)];
    case 4
        resultclass.extrasmall = onlythissize_mae(1);
        resultclass.small = onlythissize_mae(2);
        resultclass.large = onlythissize_mae(4);
        resultclass.extralarge = onlythissize_mae(5);
        y1 = [MAE, onlythissize_mae(1), ignorethissize_mae(1);
            MAE, onlythissize_mae(2), ignorethissize_mae(2);
            MAE, onlythissize_mae(3), ignorethissize_mae(3);
            MAE, onlythissize_mae(4), ignorethissize_mae(4);
            MAE, onlythissize_mae(5), ignorethissize_mae(5)];
    case 5
        resultclass.extrasmall = onlythissize_mederr(1);
        resultclass.small = onlythissize_mederr(2);
        resultclass.large = onlythissize_mederr(4);
        resultclass.extralarge = onlythissize_mederr(5);
        y1 = [MedErr, onlythissize_mederr(1), ignorethissize_mederr(1);
            MedErr, onlythissize_mederr(2), ignorethissize_mederr(2);
            MedErr, onlythissize_mederr(3), ignorethissize_mederr(3);
            MedErr, onlythissize_mederr(4), ignorethissize_mederr(4);
            MedErr, onlythissize_mederr(5), ignorethissize_mederr(5)];
end


x = [1 2 3 4 5];
figure(f), hold off;
barh(x, y1);
if (error_type == 1) || (error_type == 2) || (error_type == 3)
    xlim = [0 1];
else
    xlim = [0 ceil(max(max(y1))+10)];
end
set(gca, 'xlim', xlim);
set(gca, 'xminortick', 'on');
set(gca, 'ticklength', get(gca, 'ticklength'));
xlabel(metric, 'fontsize', fs);
set(gca, 'ytick', 1:5)
set(gca, 'yticklabel', {'XS', 'S', 'M', 'L', 'XL'});
set(gca, 'fontsize', fs);
title([resultfp.name ': Object Size Influence'], 'fontsize', fs, 'fontweight', 'bold')

%% aspect ratio analysis
%%%%
f = f + 1;

onlythisaspect_aos = zeros(1, length(result.pose.onlythisaspect));
onlythisaspect_avp = zeros(1, length(result.pose.onlythisaspect));
onlythisaspect_peap  = zeros(1, length(result.pose.onlythisaspect));
onlythisaspect_mae  = zeros(1, length(result.pose.onlythisaspect));
onlythisaspect_mederr = zeros(1, length(result.pose.onlythisaspect));
ignorethisaspect_aos = zeros(1, length(result.pose.onlythisaspect));
ignorethisaspect_avp = zeros(1, length(result.pose.onlythisaspect));
ignorethisaspect_peap = zeros(1, length(result.pose.onlythisaspect));
ignorethisaspect_mae = zeros(1, length(result.pose.onlythisaspect));
ignorethisaspect_mederr = zeros(1, length(result.pose.onlythisaspect));

for i = 1:length(result.pose.onlythisaspect)
    tmp = [result.pose.onlythisaspect(i)];
    onlythisaspect_aos(i) = mean([tmp.aos]);
    onlythisaspect_avp(i) = mean([tmp.avp15]);
    onlythisaspect_peap(i) = mean([tmp.peap15]);
    onlythisaspect_mae(i) = mean([tmp.mean_error]);
    onlythisaspect_mederr(i) = mean([tmp.median_error]);
    
    tmp = [result.pose.ignorethisaspect(i)];
    ignorethisaspect_aos(i) = mean([tmp.aos]);
    ignorethisaspect_avp(i) = mean([tmp.avp15]);
    ignorethisaspect_peap(i) = mean([tmp.peap15]);
    ignorethisaspect_mae(i) = mean([tmp.mean_error]);
    ignorethisaspect_mederr(i) = mean([tmp.median_error]);
end

switch error_type
    case 1
        resultclass.extratall = onlythisaspect_aos(1);
        resultclass.tall = onlythisaspect_aos(2);
        resultclass.wide = onlythisaspect_aos(4);
        resultclass.extrawide = onlythisaspect_aos(5);
        y1 = [AOS, onlythisaspect_aos(1), ignorethisaspect_aos(1);
            AOS, onlythisaspect_aos(2), ignorethisaspect_aos(2);
            AOS, onlythisaspect_aos(3), ignorethisaspect_aos(3);
            AOS, onlythisaspect_aos(4), ignorethisaspect_aos(4);
            AOS, onlythisaspect_aos(5), ignorethisaspect_aos(5)];
    case 2
        resultclass.extratall = onlythisaspect_avp(1);
        resultclass.tall = onlythisaspect_avp(2);
        resultclass.wide = onlythisaspect_avp(4);
        resultclass.extrawide = onlythisaspect_avp(5);
        y1 = [AVP, onlythisaspect_avp(1), ignorethisaspect_avp(1);
            AVP, onlythisaspect_avp(2), ignorethisaspect_avp(2);
            AVP, onlythisaspect_avp(3), ignorethisaspect_avp(3);
            AVP, onlythisaspect_avp(4), ignorethisaspect_avp(4);
            AVP, onlythisaspect_avp(5), ignorethisaspect_avp(5)];
    case 3
        resultclass.extratall = onlythisaspect_peap(1);
        resultclass.tall = onlythisaspect_peap(2);
        resultclass.wide = onlythisaspect_peap(4);
        resultclass.extrawide = onlythisaspect_peap(5);
        y1 = [PEAP, onlythisaspect_peap(1), ignorethisaspect_peap(1);
            PEAP, onlythisaspect_peap(2), ignorethisaspect_peap(2);
            PEAP, onlythisaspect_peap(3), ignorethisaspect_peap(3);
            PEAP, onlythisaspect_peap(4), ignorethisaspect_peap(4);
            PEAP, onlythisaspect_peap(5), ignorethisaspect_peap(5)];
    case 4
        resultclass.extratall = onlythisaspect_mae(1);
        resultclass.tall = onlythisaspect_mae(2);
        resultclass.wide = onlythisaspect_mae(4);
        resultclass.extrawide = onlythisaspect_mae(5);
        y1 = [MAE, onlythisaspect_mae(1), ignorethisaspect_mae(1);
            MAE, onlythisaspect_mae(2), ignorethisaspect_mae(2);
            MAE, onlythisaspect_mae(3), ignorethisaspect_mae(3);
            MAE, onlythisaspect_mae(4), ignorethisaspect_mae(4);
            MAE, onlythisaspect_mae(5), ignorethisaspect_mae(5)];
    case 5
        resultclass.extratall = onlythisaspect_mederr(1);
        resultclass.tall = onlythisaspect_mederr(2);
        resultclass.wide = onlythisaspect_mederr(4);
        resultclass.extrawide = onlythisaspect_mederr(5);
        y1 = [MedErr, onlythisaspect_mederr(1), ignorethisaspect_mederr(1);
            MedErr, onlythisaspect_mederr(2), ignorethisaspect_mederr(2);
            MedErr, onlythisaspect_mederr(3), ignorethisaspect_mederr(3);
            MedErr, onlythisaspect_mederr(4), ignorethisaspect_mederr(4);
            MedErr, onlythisaspect_mederr(5), ignorethisaspect_mederr(5)];
end

x = [1 2 3 4 5];

figure(f), hold off;
barh(x, y1);

if (error_type == 1) || (error_type == 2) || (error_type == 3)
    xlim = [0 1];
else
    xlim = [0 round(max(max(y1))+10)];
end
set(gca, 'xlim', xlim);
set(gca, 'xminortick', 'on');
set(gca, 'ticklength', get(gca, 'ticklength'));
xlabel(metric, 'fontsize', fs);
set(gca, 'ytick', 1:5)
set(gca, 'yticklabel', {'XT', 'T', 'M', 'W', 'XW'});
set(gca, 'fontsize', fs);
title([resultfp.name ': Aspect Ratio Influence'], 'fontsize', fs, 'fontweight', 'bold')

%%%%
fs = 18;
f = f + 1;
if strcmp(detector(length(detector)-1:length(detector)), 'gt')
    fnames = {'side', 'part'};
    xticklab = {'occ-trn', 'size', 'asp', 'side', 'part'};
    
    valid = true(size(xticklab));
    for af = 1:numel(fnames)
        if ~isfield(result(1).pose, fnames{af})
            valid(f) = false;
            continue;
        end
        
        
        if af == 1
            
            if occ_flag
                switch error_type
                    case 1
                        maxval(1)= max([AOS, ignore_OCC_aos, only_OCC_aos]);
                        minval(1)= min([AOS, ignore_OCC_aos, only_OCC_aos]);
                    case 2
                        maxval(1)= max([AVP, ignore_OCC_avp, only_OCC_avp]);
                        minval(1)= min([AVP, ignore_OCC_avp, only_OCC_avp]);
                    case 3
                        maxval(1)= max([PEAP, ignore_OCC_peap, only_OCC_peap]);
                        minval(1)= min([PEAP, ignore_OCC_peap, only_OCC_peap]);
                    case 4
                        maxval(1)= max([MAE, ignore_OCC_mae, only_OCC_mae]);
                        minval(1)= min([MAE, ignore_OCC_mae, only_OCC_mae]);
                    case 5
                        maxval(1)= max([MedErr, ignore_OCC_mederr, only_OCC_mederr]);
                        minval(1)= min([MedErr, ignore_OCC_mederr, only_OCC_mederr]);
                end
                
            else
                switch error_type
                    case 1
                        maxval(1) = AOS;
                        minval(1) = 0;
                    case 2
                        maxval(1) = AVP;
                        minval(1) = 0;
                    case 3
                        maxval(1) = PEAP;
                        minval(1) = 0;
                    case 4
                        maxval(1) = MAE;
                        minval(1) = 0;
                    case 5
                        maxval(1) = MedErr;
                        minval(1) = 0;
                end
                
            end
            
            resultclass.ap = AP;
            resultclass.aos = AOS;
            resultclass.avp = AVP;
            resultclass.peap = PEAP;
            resultclass.mae = MAE;
            resultclass.mederr = MedErr;
            
            switch error_type
                
                case 1
                    
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.aos]);
                    maxval(2)= max([AOS, onlythissize_aos, ignorethissize_aos]);
                    minval(2)= min([AOS, onlythissize_aos, ignorethissize_aos]);
                    maxval(3)= max([AOS, onlythisaspect_aos, ignorethisaspect_aos]);
                    minval(3)= min([AOS, onlythisaspect_aos, ignorethisaspect_aos]);
                case 2
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.avp15]);
                    maxval(2)= max([AVP, onlythissize_avp, ignorethissize_avp]);
                    minval(2)= min([AVP, onlythissize_avp, ignorethissize_avp]);
                    maxval(3)= max([AVP, onlythisaspect_avp, ignorethisaspect_avp]);
                    minval(3)= min([AVP, onlythisaspect_avp, ignorethisaspect_avp]);
                case 3
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.peap15]);
                    maxval(2)= max([PEAP, onlythissize_peap, ignorethissize_peap]);
                    minval(2)= min([PEAP, onlythissize_peap, ignorethissize_peap]);
                    maxval(3)= max([PEAP, onlythisaspect_peap, ignorethisaspect_peap]);
                    minval(3)= min([PEAP, onlythisaspect_peap, ignorethisaspect_peap]);
                case 4
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.mean_error]);
                    maxval(2)= max([MAE, onlythissize_mae, ignorethissize_mae]);
                    minval(2)= min([MAE, onlythissize_mae, ignorethissize_mae]);
                    maxval(3)= max([MAE, onlythisaspect_mae, ignorethisaspect_mae]);
                    minval(3)= min([MAE, onlythisaspect_mae, ignorethisaspect_mae]);
                case 5
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.median_error]);
                    maxval(2)= max([MedErr, onlythissize_mederr, ignorethissize_mederr]);
                    minval(2)= min([MedErr, onlythissize_mederr, ignorethissize_mederr]);
                    maxval(3)= max([MedErr, onlythisaspect_mederr, ignorethisaspect_mederr]);
                    minval(3)= min([MedErr, onlythisaspect_mederr, ignorethisaspect_mederr]);
            end
            
            resultclass.maxval(1) = maxval(1);
            resultclass.minval(1) = minval(1);
            
            resultclass.maxval(2) = maxval(2);
            resultclass.minval(2) = minval(2);
            
            resultclass.maxval(3) = maxval(3);
            resultclass.minval(3) = minval(3);
        end
        
        switch error_type
            
            case 1
                maxval(af+3) = getMaxVal([result(o).pose.(fnames{af})], 'aos');
                minval(af+3) = getMinVal([result(o).pose.(fnames{af})], 'aos');
            case 2
                maxval(af+3) = getMaxVal([result(o).pose.(fnames{af})], 'avp15');
                minval(af+3) = getMinVal([result(o).pose.(fnames{af})], 'avp15');
            case 3
                maxval(af+3) = getMaxVal([result(o).pose.(fnames{af})], 'peap15');
                minval(af+3) = getMinVal([result(o).pose.(fnames{af})], 'peap15');
            case 4
                maxval(af+3) = getMaxVal([result(o).pose.(fnames{af})], 'mean_error');
                minval(af+3) = getMinVal([result(o).pose.(fnames{af})], 'mean_error');
            case 5
                maxval(af+3) = getMaxVal([result(o).pose.(fnames{af})], 'median_error');
                minval(af+3) = getMinVal([result(o).pose.(fnames{af})], 'median_error');
        end
        
        resultclass.maxval(af+3) = maxval(af+3);
        resultclass.minval(af+3) = minval(af+3);
    end
    
    maxval = maxval(:, valid); minval = minval(:, valid);
    fnames = xticklab(valid); xticklab = xticklab(valid);
    
    maxval = mean(maxval, 1);
    minval = mean(minval, 1);
    
    figure(f), hold off;
    plot([1 numel(fnames)], [avgval avgval], 'k--', 'linewidth', 2);
    hold on;
    errorbar(1:numel(fnames), avgval*ones(1, numel(fnames)), avgval-minval, ...
        maxval-avgval, 'r+', 'linewidth', 2);
    for x = 1:numel(fnames)
        if (error_type == 1) || (error_type == 2) || (error_type == 3)
            text(x+0.12, minval(x)+0.01, sprintf('%0.3f', minval(x)), ...
                'fontsize', fs, 'fontweight', 'bold');
            text(x+0.12, maxval(x)-0.02, sprintf('%0.3f', maxval(x)), ...
                'fontsize', fs, 'fontweight', 'bold');
        else
            text(x+0.12, minval(x), sprintf('%0.1f', minval(x)), 'fontsize', fs, 'fontweight', 'bold');
            text(x+0.12, maxval(x), sprintf('%0.1f', maxval(x)), 'fontsize', fs, 'fontweight', 'bold');
        end
    end
    text(0.1, avgval, sprintf('%0.3f', avgval), 'fontsize', fs, 'fontweight', 'bold');
    
    if (error_type == 1) || (error_type == 2) || (error_type == 3)
        ymax = min(round((max(maxval)+0.15)*10)/10,1);
    else
        ymax = max(maxval) + 5;
    end
    axis([0 numel(fnames)+1 0 ymax]);
    ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
    set(gca, 'xtick', 1:numel(fnames));
    set(gca, 'xticklabel', xticklab);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    set(gca, 'fontsize', fs, 'fontweight', 'bold');
    set(gca, 'ticklength', [0.001 0.001]);
    title([resultfp.name ': Sensitivity and Impact'])
else
    fnames = {'side', 'part'};
    xticklab = {'occ-trn', 'diff', 'size', 'asp', 'side', 'part'};
    af=1;
    valid = true(size(xticklab));
    for af = 1:numel(fnames)
        if ~isfield(result(1).pose, fnames{af})
            valid(f) = false;
            continue;
        end
        
        
        if af == 1
            
            if occ_flag
                switch error_type
                    case 1
                        maxval(1)= max([AOS, ignore_OCC_aos, only_OCC_aos]);
                        minval(1)= min([AOS, ignore_OCC_aos, only_OCC_aos]);
                    case 2
                        maxval(1)= max([AVP, ignore_OCC_avp, only_OCC_avp]);
                        minval(1)= min([AVP, ignore_OCC_avp, only_OCC_avp]);
                    case 3
                        maxval(1)= max([PEAP, ignore_OCC_peap, only_OCC_peap]);
                        minval(1)= min([PEAP, ignore_OCC_peap, only_OCC_peap]);
                    case 4
                        maxval(1)= max([MAE, ignore_OCC_mae, only_OCC_mae]);
                        minval(1)= min([MAE, ignore_OCC_mae, only_OCC_mae]);
                    case 5
                        maxval(1)= max([MedErr, ignore_OCC_mederr, only_OCC_mederr]);
                        minval(1)= min([MedErr, ignore_OCC_mederr, only_OCC_mederr]);
                end
                
            else
                switch error_type
                    case 1
                        maxval(1) = AOS;
                        minval(1) = 0;
                    case 2
                        maxval(1) = AVP;
                        minval(1) = 0;
                    case 3
                        maxval(1) = PEAP;
                        minval(1) = 0;
                    case 4
                        maxval(1) = MAE;
                        minval(1) = 0;
                    case 5
                        maxval(1) = MedErr;
                        minval(1) = 0;
                end
                
            end
            
            resultclass.ap = AP;
            resultclass.aos = AOS;
            resultclass.avp = AVP;
            resultclass.peap = PEAP;
            resultclass.mae = MAE;
            resultclass.mederr = MedErr;
            
            switch error_type
                
                case 1
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.aos]);
                    maxval(2)= max(AOS, diff_aos);
                    minval(2)= min(AOS, diff_aos);
                    maxval(3)= max([AOS, onlythissize_aos, ignorethissize_aos]);
                    minval(3)= min([AOS, onlythissize_aos, ignorethissize_aos]);
                    maxval(4)= max([AOS, onlythisaspect_aos, ignorethisaspect_aos]);
                    minval(4)= min([AOS, onlythisaspect_aos, ignorethisaspect_aos]);
                case 2
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.avp15]);
                    maxval(2)= max(AVP, diff_avp);
                    minval(2)= min(AVP, diff_avp);
                    maxval(3)= max([AVP, onlythissize_avp, ignorethissize_avp]);
                    minval(3)= min([AVP, onlythissize_avp, ignorethissize_avp]);
                    maxval(4)= max([AVP, onlythisaspect_avp, ignorethisaspect_avp]);
                    minval(4)= min([AVP, onlythisaspect_avp, ignorethisaspect_avp]);
                case 3
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.peap15]);
                    maxval(2)= max(PEAP, diff_peap);
                    minval(2)= min(PEAP, diff_peap);
                    maxval(3)= max([PEAP, onlythissize_peap, ignorethissize_peap]);
                    minval(3)= min([PEAP, onlythissize_peap, ignorethissize_peap]);
                    maxval(4)= max([PEAP, onlythisaspect_peap, ignorethisaspect_peap]);
                    minval(4)= min([PEAP, onlythisaspect_peap, ignorethisaspect_peap]);
                case 4
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.mean_error]);
                    maxval(2)= max(MAE, diff_mae);
                    minval(2)= min(MAE, diff_mae);
                    maxval(3)= max([MAE, onlythissize_mae, ignorethissize_mae]);
                    minval(3)= min([MAE, onlythissize_mae, ignorethissize_mae]);
                    maxval(4)= max([MAE, onlythisaspect_mae, ignorethisaspect_mae]);
                    minval(4)= min([MAE, onlythisaspect_mae, ignorethisaspect_mae]);
                case 5
                    tmp = [resultfp.pose];
                    avgval = mean([tmp.median_error]);
                    maxval(2)= max(MedErr, diff_mederr);
                    minval(2)= min(MedErr, diff_mederr);
                    maxval(3)= max([MedErr, onlythissize_mederr, ignorethissize_mederr]);
                    minval(3)= min([MedErr, onlythissize_mederr, ignorethissize_mederr]);
                    maxval(4)= max([MedErr, onlythisaspect_mederr, ignorethisaspect_mederr]);
                    minval(4)= min([MedErr, onlythisaspect_mederr, ignorethisaspect_mederr]);
            end
            
            resultclass.maxval(1) = maxval(1);
            resultclass.minval(1) = minval(1);
            
            resultclass.maxval(2) = maxval(2);
            resultclass.minval(2) = minval(2);
            
            resultclass.maxval(3) = maxval(3);
            resultclass.minval(3) = minval(3);
            
            resultclass.maxval(4) = maxval(4);
            resultclass.minval(4) = minval(4);
        end
        
        switch error_type
            
            case 1
                maxval(af+4) = getMaxVal([result.pose.(fnames{af})], 'aos');
                minval(af+4) = getMinVal([result.pose.(fnames{af})], 'aos');
            case 2
                maxval(af+4) = getMaxVal([result.pose.(fnames{af})], 'avp15');
                minval(af+4) = getMinVal([result.pose.(fnames{af})], 'avp15');
            case 3
                maxval(af+4) = getMaxVal([result.pose.(fnames{af})], 'peap15');
                minval(af+4) = getMinVal([result.pose.(fnames{af})], 'peap15');
            case 4
                maxval(af+4) = getMaxVal([result.pose.(fnames{af})], 'mean_error');
                minval(af+4) = getMinVal([result.pose.(fnames{af})], 'mean_error');
            case 5
                maxval(af+4) = getMaxVal([result.pose.(fnames{af})], 'median_error');
                minval(af+4) = getMinVal([result.pose.(fnames{af})], 'median_error');
        end
        
        resultclass.maxval(af+4) = maxval(af+4);
        resultclass.minval(af+4) = minval(af+4);
        
    end
    
    maxval = maxval(:, valid); minval = minval(:, valid);
    fnames = xticklab(valid); xticklab = xticklab(valid);
    
    maxval = mean(maxval, 1);
    minval = mean(minval, 1);
    
    figure(f), hold off;
    plot([1 numel(fnames)], [avgval avgval], 'k--', 'linewidth', 2);
    hold on;
    errorbar(1:numel(fnames), avgval*ones(1, numel(fnames)), avgval-minval, ...
        maxval-avgval, 'r+', 'linewidth', 2);
    for x = 1:numel(fnames)
        if (error_type == 1) || (error_type == 2) || (error_type == 3)
            text(x+0.12, minval(x)+0.01, sprintf('%0.3f', minval(x)), ...
                'fontsize', fs, 'fontweight', 'bold');
            text(x+0.12, maxval(x)-0.02, sprintf('%0.3f', maxval(x)), ...
                'fontsize', fs, 'fontweight', 'bold');
        else
            text(x+0.12, minval(x), sprintf('%0.1f', minval(x)), 'fontsize', fs, 'fontweight', 'bold');
            text(x+0.12, maxval(x), sprintf('%0.1f', maxval(x)), 'fontsize', fs, 'fontweight', 'bold');
        end
        
    end
    text(0.1, avgval, sprintf('%0.3f', avgval), 'fontsize', fs, 'fontweight', 'bold');
    
    if (error_type == 1) || (error_type == 2) || (error_type == 3)
        ymax = min(round((max(maxval)+0.15)*10)/10,1);
    else
        ymax = max(maxval) + 5;
    end
    axis([0 numel(fnames)+1 0 ymax]);
    ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
    set(gca, 'xtick', 1:numel(fnames));
    set(gca, 'xticklabel', xticklab);
    set(gca, 'ygrid', 'on')
    set(gca, 'xgrid', 'on')
    set(gca, 'fontsize', fs, 'fontweight', 'bold');
    set(gca, 'ticklength', [0.001 0.001]);
    title([resultfp.name ': Sensitivity and Impact'])
end


%% Gets the maximum value of a particular variable name for any field in the structure
function maxy = getMaxVal(s, fname, maxy)
if ~exist('maxy', 'var') || isempty(maxy)
    maxy = -Inf;
end
if numel(s)>1
    for k = 1:numel(s)
        maxy = max(maxy, getMaxVal(s(k), fname, maxy));
    end
    return;
end
names = fieldnames(s);
for k = 1:numel(names)
    if ~isstruct(s.(names{k})) && ~strcmp(names{k}, fname)
        continue;
    end
    for j = 1:numel(s.(names{k}))
        if strcmp(names{k}, fname)
            
            maxy = max(maxy, s.(fname)(j));
            
        else
            maxy = max(maxy, getMaxVal(s.(names{k})(j), fname, maxy));
        end
    end
end


function miny = getMinVal(s, fname, miny)
if ~exist('miny', 'var') || isempty(miny)
    miny = Inf;
end
if numel(s)>1
    for k = 1:numel(s)
        miny = min(miny, getMinVal(s(k), fname, miny));
    end
    return;
end
names = fieldnames(s);
for k = 1:numel(names)
    if ~isstruct(s.(names{k})) && ~strcmp(names{k}, fname)
        continue;
    end
    for j = 1:numel(s.(names{k}))
        if strcmp(names{k}, fname)
            %if s.npos>=5 % special case
            miny = min(miny, s.(fname)(j));
            %end
        else
            miny = min(miny, getMinVal(s.(names{k})(j), fname, miny));
        end
    end
end


%% Removes vowels from a string
function str = removeVowels(str)
for v = 'aeiou'
    str(str==v) = [];
end