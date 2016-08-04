function f = summaryErrorDataset(detector, rtotal, flag_diningtable, metric_type)
switch metric_type
    case 1
        metric = 'AOS';
        avgval = mean([rtotal(:).aos]);
    case 2
        metric = 'AVP';
        avgval = mean([rtotal(:).avp]);
    case 3
        metric = 'PEAP';
        avgval = mean([rtotal(:).peap]);
    case 4
        metric = 'MAE';
        avgval = mean([rtotal(:).mae]);
    case 5
        metric = 'MedError';
        avgval = mean([rtotal(:).MedError]);
end

maxval = zeros(1,length(rtotal(1).maxval));
minval = zeros(1,length(rtotal(1).maxval));
for mx = 1:length(rtotal)
    maxval = maxval + rtotal(mx).maxval;
    minval = minval + rtotal(mx).minval;
end
maxval = maxval/length(rtotal);
minval = minval/length(rtotal);

f=1;
fs = 18;
if strcmp(detector(length(detector)-1:length(detector)), 'gt')
    
    xticklab = {'occ-trn', 'size', 'asp', 'side', 'part'};
else
    
    xticklab = {'occ-trn', 'diff', 'size', 'asp', 'side', 'part'};
end


valid = true(size(xticklab));

maxval = maxval(:, valid); minval = minval(:, valid);
fnames = xticklab(valid); xticklab = xticklab(valid);

maxval = mean(maxval, 1);
minval = mean(minval, 1);

%% Sensitivity and Impact overview
figure(f), hold off;
plot([1 numel(fnames)], [avgval avgval], 'k--', 'linewidth', 2);
hold on;
errorbar(1:numel(fnames), avgval*ones(1, numel(fnames)), avgval-minval, ...
    maxval-avgval, 'r+', 'linewidth', 2);
for x = 1:numel(fnames)
    if (metric_type == 1) || (metric_type == 2) || (metric_type == 3)
        text(x+0.12, minval(x)+0.01, sprintf('%0.3f', minval(x)), 'fontsize', fs, 'fontweight', 'bold');
        text(x+0.12, maxval(x)-0.02, sprintf('%0.3f', maxval(x)), 'fontsize', fs, 'fontweight', 'bold');
    else
        text(x+0.12, minval(x), sprintf('%0.1f', minval(x)), 'fontsize', fs, 'fontweight', 'bold');
        text(x+0.12, maxval(x), sprintf('%0.1f', maxval(x)), 'fontsize', fs, 'fontweight', 'bold');
    end
end
text(0.1, avgval, sprintf('%0.3f', avgval), 'fontsize', fs, 'fontweight', 'bold');

if (metric_type == 1) || (metric_type == 2) || (metric_type == 3)
    ymax = min(round((max(maxval)+0.15)*10)/10,1);
else
    ymax = max(maxval) + 5;
end
axis([0 numel(fnames)+1 0 ymax]);

set(gca, 'xtick', 1:numel(fnames));
set(gca, 'xticklabel', xticklab);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'ticklength', [0.001 0.001]);
title([detector ': Sensitivity and Impact'])


%% visible side overview
f= f + 1;
maxval_a = zeros(1,length(rtotal(1).side_1));
minval_a = zeros(1,length(rtotal(1).side_2));
for mx = 1:length(rtotal)
    maxval_a = maxval_a + rtotal(mx).side_1;
    minval_a = minval_a + rtotal(mx).side_2;
end
maxval = maxval_a/length(rtotal);
minval = minval_a/length(rtotal);

figure(f)
xticklab = {'frontal', 'rear', 'side'};
resall0 = [maxval];
resall1 = [minval];
x=2:7;
n=1;
for k = 1:numel(resall0)
    if isnan(resall0(k)), resall0(k) = 0; end
    hold on;
    plot(x(n),resall0(k), '+', 'linewidth', 4, 'markersize', 2);
    plot(x(n+1),resall1(k), '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    if (metric_type == 1) || (metric_type == 2)
        text(x(n)+0.12, resall0(k), sprintf('%0.2f', resall0(k)), 'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.2f', resall1(k)), 'FontSize', fs, 'FontWeight', 'bold');
    else
        text(x(n)+0.12, resall0(k), sprintf('%0.1f', resall0(k)), 'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.1f', resall1(k)), 'FontSize', fs, 'FontWeight', 'bold');
    end
    n = n+2;
end
n = 1;
for i=1:numel(resall0)
    plot([x(n) x(n+1)], [resall0(i) resall1(i)], 'b-', 'linewidth', 4);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    n = n+2;
end

if (metric_type == 1) || (metric_type == 2) || (metric_type == 3)
    ymax = 1;
else
    ymax = max(max(resall0), max(resall1)) + 5;
end

axis([1 8 0 ymax]);
axisval = axis;
n=2.5;
for p = 1:numel(xticklab)
    name = xticklab{p};
    text(n, -0.071*axisval(4), sprintf('%s\n0/1', name), 'fontsize', fs, 'fontweight', 'bold');
    n = n+2;
end
plot([1.5 7.5], [avgval avgval], 'k--', 'linewidth', 2);

set(gca, 'xticklabel', []);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'ticklength', [0.001 0.001]);
title([detector ': Visible Side Characteristic Overview'])

%% Pie Chart Error overview
f = f + 1;
correct = mean([rtotal(:).correct]);
opp = mean([rtotal(:).opp]);
nearby = mean([rtotal(:).nearby]);
oth = mean([rtotal(:).oth]);

figure(f), hold off;
p=pie([correct opp nearby oth], ...
    {['Correct: ' num2str(round(correct)) '%'], ...
    ['Opposite: ' num2str(round(opp)) '%'], ...
    ['Nearby: ' num2str(round(nearby)) '%'], ...
    ['Other: ' num2str(round(oth)) '%']});
set(p(2:2:length(p)),'FontSize',20, 'FontWeight', 'bold');
title(detector, 'fontsize', fs, 'fontweight', 'bold')
colormap([1 1 1 ; [79 129 189]/255 ; [192 80 77]/255 ; [77 192 80]/255*1.2 ; [128 100 162]/255]);

%% Overlap Analysis overview
f=f+1;
aos = zeros(1,length(rtotal(1).ov_aos));
avp = zeros(1,length(rtotal(1).ov_avp));
peap = zeros(1,length(rtotal(1).ov_peap));
mae = zeros(1,length(rtotal(1).ov_mae));
medError = zeros(1,length(rtotal(1).ov_medError));
ap = zeros(1,length(rtotal(1).ov_ap));

for mx = 1:length(rtotal)
    aos = aos + rtotal(mx).ov_aos;
    avp = avp + rtotal(mx).ov_avp;
    peap = peap + rtotal(mx).ov_peap;
    mae = mae + rtotal(mx).ov_mae;
    medError = medError + rtotal(mx).ov_medError;
    ap = ap + rtotal(mx).ov_ap;
end

ap = ap/length(rtotal);
aos = aos/length(rtotal);
avp = avp/length(rtotal);
peap = peap/length(rtotal);
mae = mae/length(rtotal);
medError = medError/length(rtotal);


figure(f)
plot([0.1:0.1:0.9],ap,'r','LineWidth',4);
hold on;
plot([0.1:0.1:0.9],aos,'b','LineWidth',4);
plot([0.1:0.1:0.9],avp,'g','LineWidth',4);
plot([0.1:0.1:0.9],peap,'k','LineWidth',4);

xticks = 0.1:0.1:0.9;
set(gca, 'xtick', xticks);
set(gca, 'xticklabel', xticks, 'fontsize', fs);
axis([0 1 0 1]);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
hleg=legend('AP', 'AOS', 'AVP', 'PEAP', 'Location','NorthWest');
set(hleg, 'Box', 'off')
title(detector , 'fontsize', fs, 'fontweight', 'bold')
ylabel('Accuracy', 'fontsize',fs, 'fontweight', 'bold');
xlabel('Overlap Criteria','fontsize', fs, 'fontweight', 'bold')
set(gca, 'fontsize', fs, 'FontWeight', 'bold');
hold off;

f=f+1;
figure(f)
plot([0.1:0.1:0.9],mae,'b','LineWidth',4);
hold on;
plot([0.1:0.1:0.9],medError,'g','LineWidth',4);
xticks = 0.1:0.1:0.9;
set(gca, 'xtick', xticks);
set(gca, 'xticklabel', xticks, 'fontsize', fs);
axis([0 1 0 max(mae) + 20]);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')

title(detector , 'fontsize', fs, 'fontweight', 'bold')
ylabel('Degrees', 'fontsize',fs, 'fontweight', 'bold');
xlabel('Overlap Criteria', 'fontsize',fs, 'fontweight', 'bold')
set(gca, 'fontsize', fs, 'FontWeight', 'bold');
hleg=legend('MAE', 'MedError', 'Location','NorthWest');
set(hleg, 'Box', 'off')
hold off;


%% Pose Error Analysis overview
f = f + 1;
switch metric_type
    case 1
        AOS_average = 0;
        ignore_OPP_aos = 0;
        correct_OPP_aos = 0;
        ignore_NEAR_aos = 0;
        correct_NEAR_aos = 0;
        ignore_OTH_aos = 0;
        correct_OTH_aos = 0;
        for mx = 1:length(rtotal)
            AOS_average = AOS_average + rtotal(mx).aos;
            ignore_OPP_aos = ignore_OPP_aos + rtotal(mx).ignore_OPP_aos;
            correct_OPP_aos = correct_OPP_aos + rtotal(mx).correct_OPP_aos;
            ignore_NEAR_aos = ignore_NEAR_aos + rtotal(mx).ignore_NEAR_aos;
            correct_NEAR_aos = correct_NEAR_aos + rtotal(mx).correct_NEAR_aos;
            ignore_OTH_aos = ignore_OTH_aos + rtotal(mx).ignore_OTH_aos;
            correct_OTH_aos = correct_OTH_aos + rtotal(mx).correct_OTH_aos;
        end
        AOS_average = AOS_average/length(rtotal);
        ignore_OPP_aos = ignore_OPP_aos/length(rtotal);
        correct_OPP_aos = correct_OPP_aos/length(rtotal);
        ignore_NEAR_aos = ignore_NEAR_aos/length(rtotal);
        correct_NEAR_aos = correct_NEAR_aos/length(rtotal);
        ignore_OTH_aos = ignore_OTH_aos/length(rtotal);
        correct_OTH_aos = correct_OTH_aos/length(rtotal);
        
        y = [AOS_average, ignore_OPP_aos, correct_OPP_aos; ...
            AOS_average, ignore_NEAR_aos, correct_NEAR_aos; ...
            AOS_average, ignore_OTH_aos, correct_OTH_aos];
        x = [1 2 3];
        
        figure(f), hold off;
        barh(x, y);
        
        xlim = [0 ceil((max([correct_OPP_aos correct_NEAR_aos correct_OTH_aos])+0.005))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('AOS', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(detector)
    case 2
        AVP_average = 0;
        ignore_OPP_avp = 0;
        correct_OPP_avp = 0;
        ignore_NEAR_avp = 0;
        correct_NEAR_avp = 0;
        ignore_OTH_avp = 0;
        correct_OTH_avp = 0;
        for mx = 1:length(rtotal)
            AVP_average = AVP_average + rtotal(mx).avp;
            ignore_OPP_avp = ignore_OPP_avp + rtotal(mx).ignore_OPP_avp;
            correct_OPP_avp = correct_OPP_avp + rtotal(mx).correct_OPP_avp;
            ignore_NEAR_avp = ignore_NEAR_avp + rtotal(mx).ignore_NEAR_avp;
            correct_NEAR_avp = correct_NEAR_avp + rtotal(mx).correct_NEAR_avp;
            ignore_OTH_avp = ignore_OTH_avp + rtotal(mx).ignore_OTH_avp;
            correct_OTH_avp = correct_OTH_avp + rtotal(mx).correct_OTH_avp;
        end
        AVP_average = AVP_average/length(rtotal);
        ignore_OPP_avp = ignore_OPP_avp/length(rtotal);
        correct_OPP_avp = correct_OPP_avp/length(rtotal);
        ignore_NEAR_avp = ignore_NEAR_avp/length(rtotal);
        correct_NEAR_avp = correct_NEAR_avp/length(rtotal);
        ignore_OTH_avp = ignore_OTH_avp/length(rtotal);
        correct_OTH_avp = correct_OTH_avp/length(rtotal);
        
        y = [AVP_average, ignore_OPP_avp, correct_OPP_avp; ...
            AVP_average, ignore_NEAR_avp, correct_NEAR_avp; ...
            AVP_average, ignore_OTH_avp, correct_OTH_avp];
        x = [1 2 3];
        
        figure(f), hold off;
        barh(x, y);
        
        xlim = [0 ceil((max([correct_OPP_avp correct_NEAR_avp correct_OTH_avp])+0.005))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('AVP', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(detector)
    case 3
        PEAP_average = 0;
        ignore_OPP_peap = 0;
        correct_OPP_peap = 0;
        ignore_NEAR_peap = 0;
        correct_NEAR_peap = 0;
        ignore_OTH_peap = 0;
        correct_OTH_peap = 0;
        for mx = 1:length(rtotal)
            PEAP_average = PEAP_average + rtotal(mx).peap;
            ignore_OPP_peap = ignore_OPP_peap + rtotal(mx).ignore_OPP_peap;
            correct_OPP_peap = correct_OPP_peap + rtotal(mx).correct_OPP_peap;
            ignore_NEAR_peap = ignore_NEAR_peap + rtotal(mx).ignore_NEAR_peap;
            correct_NEAR_peap = correct_NEAR_peap + rtotal(mx).correct_NEAR_peap;
            ignore_OTH_peap = ignore_OTH_peap + rtotal(mx).ignore_OTH_peap;
            correct_OTH_peap = correct_OTH_peap + rtotal(mx).correct_OTH_peap;
        end
        PEAP_average = PEAP_average/length(rtotal);
        ignore_OPP_peap = ignore_OPP_peap/length(rtotal);
        correct_OPP_peap = correct_OPP_peap/length(rtotal);
        ignore_NEAR_peap = ignore_NEAR_peap/length(rtotal);
        correct_NEAR_peap = correct_NEAR_peap/length(rtotal);
        ignore_OTH_peap = ignore_OTH_peap/length(rtotal);
        correct_OTH_peap = correct_OTH_peap/length(rtotal);
        
        y = [PEAP_average, ignore_OPP_peap, correct_OPP_peap; ...
            PEAP_average, ignore_NEAR_peap, correct_NEAR_peap; ...
            PEAP_average, ignore_OTH_peap, correct_OTH_peap];
        x = [1 2 3];
        
        figure(f), hold off;
        barh(x, y);
        
        xlim = [0 ceil((max([correct_OPP_peap correct_NEAR_peap correct_OTH_peap])+0.005))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('PEAP', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(detector)
    case 4
        MAE_average = 0;
        ignore_OPP_mae = 0;
        correct_OPP_mae = 0;
        ignore_NEAR_mae = 0;
        correct_NEAR_mae = 0;
        ignore_OTH_mae = 0;
        correct_OTH_mae = 0;
        for mx = 1:length(rtotal)
            MAE_average = MAE_average + rtotal(mx).mae;
            ignore_OPP_mae = ignore_OPP_mae + rtotal(mx).ignore_OPP_mae;
            correct_OPP_mae = correct_OPP_mae + rtotal(mx).correct_OPP_mae;
            ignore_NEAR_mae = ignore_NEAR_mae + rtotal(mx).ignore_NEAR_mae;
            correct_NEAR_mae = correct_NEAR_mae + rtotal(mx).correct_NEAR_mae;
            ignore_OTH_mae = ignore_OTH_mae + rtotal(mx).ignore_OTH_mae;
            correct_OTH_mae = correct_OTH_mae + rtotal(mx).correct_OTH_mae;
        end
        MAE_average = MAE_average/length(rtotal);
        ignore_OPP_mae = ignore_OPP_mae/length(rtotal);
        correct_OPP_mae = correct_OPP_mae/length(rtotal);
        ignore_NEAR_mae = ignore_NEAR_mae/length(rtotal);
        correct_NEAR_mae = correct_NEAR_mae/length(rtotal);
        ignore_OTH_mae = ignore_OTH_mae/length(rtotal);
        correct_OTH_mae = correct_OTH_mae/length(rtotal);
        
        y = [MAE_average, ignore_OPP_mae, correct_OPP_mae; ...
            MAE_average, ignore_NEAR_mae, correct_NEAR_mae; ...
            MAE_average, ignore_OTH_mae, correct_OTH_mae];
        x = [1 2 3];
        
        figure(f), hold off;
        barh(x, y);
        
        xlim = [0 ceil((max([correct_OPP_mae correct_NEAR_mae correct_OTH_mae])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('MAE', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(detector)
    case 5
        MedErr_average = 0;
        ignore_OPP_mederr = 0;
        correct_OPP_mederr = 0;
        ignore_NEAR_mederr = 0;
        correct_NEAR_mederr = 0;
        ignore_OTH_mederr = 0;
        correct_OTH_mederr = 0;
        for mx = 1:length(rtotal)
            MedErr_average = MedErr_average + rtotal(mx).MedError;
            ignore_OPP_mederr = ignore_OPP_mederr + rtotal(mx).ignore_OPP_MedError;
            correct_OPP_mederr = correct_OPP_mederr + rtotal(mx).correct_OPP_MedError;
            ignore_NEAR_mederr = ignore_NEAR_mederr + rtotal(mx).ignore_NEAR_MedError;
            correct_NEAR_mederr = correct_NEAR_mederr + rtotal(mx).correct_NEAR_MedError;
            ignore_OTH_mederr = ignore_OTH_mederr + rtotal(mx).ignore_OTH_MedError;
            correct_OTH_mederr = correct_OTH_mederr + rtotal(mx).correct_OTH_MedError;
        end
        MedErr_average = MedErr_average/length(rtotal);
        ignore_OPP_mederr = ignore_OPP_mederr/length(rtotal);
        correct_OPP_mederr = correct_OPP_mederr/length(rtotal);
        ignore_NEAR_mederr = ignore_NEAR_mederr/length(rtotal);
        correct_NEAR_mederr = correct_NEAR_mederr/length(rtotal);
        ignore_OTH_mederr = ignore_OTH_mederr/length(rtotal);
        correct_OTH_mederr = correct_OTH_mederr/length(rtotal);
        
        y = [MedErr_average, ignore_OPP_mederr, correct_OPP_mederr; ...
            MedErr_average, ignore_NEAR_mederr, correct_NEAR_mederr; ...
            MedErr_average, ignore_OTH_mederr, correct_OTH_mederr];
        x = [1 2 3];
        
        figure(f), hold off;
        barh(x, y);
        
        xlim = [0 ceil((max([correct_OPP_mederr correct_NEAR_mederr correct_OTH_mederr])+10))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('MedError', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title([detector ': Pose Error Overview'])
end

%% Pose Error considering 8 views overview
hist_result = zeros(1,length(rtotal(1).hist_result));
hist_opp_result = zeros(1,length(rtotal(1).hist_result));
hist_near_result = zeros(1,length(rtotal(1).hist_result));
hist_oth_result = zeros(1,length(rtotal(1).hist_result));
xviewpointlabels = {'F', 'F-L', 'L', 'L-RE', 'RE', 'RE-R', 'R', 'R-F'};
for mx = 1: length(rtotal)
    hist_result = hist_result + rtotal(mx).hist_result;
    hist_opp_result = hist_opp_result + rtotal(mx).hist_opp_result;
    hist_near_result = hist_near_result + rtotal(mx).hist_near_result;
    hist_oth_result = hist_oth_result + rtotal(mx).hist_oth_result;
end

if flag_diningtable
    f1 = strmatch('L-RE', xviewpointlabels, 'exact');
    f2 = strmatch('RE', xviewpointlabels, 'exact');
    f3 = setdiff(1:8,[f1,f2]);
    hist_result(1,f1) = hist_result(1,f1)/(length(rtotal)-1);
    hist_opp_result(1,f1) = hist_opp_result(1,f1)/(length(rtotal)-1);
    hist_near_result(1,f1) = hist_near_result(1,f1)/(length(rtotal)-1);
    hist_oth_result(1,f1) = hist_oth_result(1,f1)/(length(rtotal)-1);
    hist_result(1,f2) = hist_result(1,f2)/(length(rtotal)-1);
    hist_opp_result(1,f2) = hist_opp_result(1,f2)/(length(rtotal)-1);
    hist_near_result(1,f2) = hist_near_result(1,f2)/(length(rtotal)-1);
    hist_oth_result(1,f2) = hist_oth_result(1,f2)/(length(rtotal)-1);
    hist_result(f3) = hist_result(f3)/(length(rtotal));
    hist_opp_result(f3) = hist_opp_result(f3)/(length(rtotal));
    hist_near_result(f3) = hist_near_result(f3)/(length(rtotal));
    hist_oth_result(f3) = hist_oth_result(f3)/(length(rtotal));
else
    hist_result(1:8) = hist_result(1:8)/length(rtotal);
    hist_opp_result(1:8) = hist_opp_result(1:8)/length(rtotal);
    hist_near_result(1:8) = hist_near_result(1:8)/length(rtotal);
    hist_oth_result(1:8) = hist_oth_result(1:8)/length(rtotal);
end

[sv, si] = sort(hist_result, 'descend');
hist_result = hist_result(si);
hist_opp_result = hist_opp_result(si);
hist_near_result = hist_near_result(si);
hist_oth_result = hist_oth_result(si);
xviewpointlabels_sort = xviewpointlabels(si);

f = f + 1;
figure(f), hold off;
Y = [hist_result; hist_opp_result; hist_near_result; hist_oth_result];
bar(Y','stacked');


axis([0 9 0 110]);
set(gca, 'xtick', 1:8)
set(gca, 'xticklabel', xviewpointlabels_sort);
ylabel('Success Rate (%)');
title(detector, 'fontsize', fs, 'fontweight', 'bold')

%% Aspect Ratio Analysis overview
f= f +1;
figure(f), hold off;

switch metric_type
    case 1
        results_all.aos = mean([rtotal(:).aos]);
        maxval=[results_all.aos, results_all.aos, results_all.aos, results_all.aos];
    case 2
        results_all.avp = mean([rtotal(:).avp]);
        maxval=[results_all.avp, results_all.avp, results_all.avp, results_all.avp];
    case 3
        results_all.peap = mean([rtotal(:).peap]);
        maxval=[results_all.peap, results_all.peap, results_all.peap, results_all.peap];
    case 4
        results_all.mae = mean([rtotal(:).mae]);
        maxval=[results_all.mae, results_all.mae, results_all.mae, results_all.mae];
    case 5
        results_all.mederr = mean([rtotal(:).MedError]);
        maxval=[results_all.mederr, results_all.mederr, results_all.mederr, results_all.mederr];
end

maxval_a = zeros(1,length(rtotal(1).extratall));
minval_a = zeros(1,length(rtotal(1).tall));
maxval_b = zeros(1,length(rtotal(1).wide));
minval_b = zeros(1,length(rtotal(1).extrawide));

for mx = 1:length(rtotal)
    maxval_a = maxval_a + rtotal(mx).extratall;
    minval_a = minval_a + rtotal(mx).tall;
    maxval_b = maxval_b + rtotal(mx).wide;
    minval_b = minval_b + rtotal(mx).extrawide;
end
maxval_a = maxval_a/length(rtotal);
minval_a = minval_a/length(rtotal);
maxval_b = maxval_b/length(rtotal);
minval_b = minval_b/length(rtotal);

minval=[maxval_a, minval_a,maxval_b, minval_b];

xticklab = {'XT', 'T', 'W', 'XW'};
resall0 = [maxval];
resall1 = [minval];
x=2:9;
n=1;
for k = 1:numel(resall0)
    if isnan(resall0(k)), resall0(k) = 0; end
    hold on;
    plot(x(n),resall0(k), '+', 'linewidth', 4, 'markersize', 2);
    plot(x(n+1),resall1(k), '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    if (metric_type == 1) || (metric_type == 2)
        text(x(n)+0.12, resall0(k), sprintf('%0.2f', resall0(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.2f', resall1(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
    else
        text(x(n)+0.12, resall0(k), sprintf('%0.1f', resall0(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.1f', resall1(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
    end
    n = n+2;
end
n = 1;
for i=1:numel(resall0)
    plot([x(n) x(n+1)], [resall0(i) resall1(i)], 'b-', 'linewidth', 4);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    n = n+2;
end
if (metric_type == 1) || (metric_type == 2) || (metric_type == 3)
    ymax = 1;
else
    ymax = max(max(resall0), max(resall1)) + 10;
end

axis([1 10 0 ymax]);
axisval = axis;
n=2.5;
for p = 1:numel(xticklab)
    name = xticklab{p};
    text(n, -0.071*axisval(4), sprintf('%s', name), 'fontsize', fs, 'fontweight', 'bold');
    n = n+2;
end
plot([1.5 9.5], [avgval avgval], 'k--', 'linewidth', 2);

set(gca, 'xticklabel', []);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'ticklength', [0.001 0.001]);
title([detector ': Aspect Ratio Characteristic Overview'])


%% Obj. Size Analysis overview
f= f +1;
figure(f), hold off;
tickstr = {};
np=0;
switch metric_type
    case 1
        results_all.aos = mean([rtotal(:).aos]);
        maxval=[results_all.aos, results_all.aos, results_all.aos, results_all.aos];
    case 2
        results_all.avp = mean([rtotal(:).avp]);
        maxval=[results_all.avp, results_all.avp, results_all.avp, results_all.avp];
    case 3
        results_all.peap = mean([rtotal(:).peap]);
        maxval=[results_all.peap, results_all.peap, results_all.peap, results_all.peap];
    case 4
        results_all.mae = mean([rtotal(:).mae]);
        maxval=[results_all.mae, results_all.mae, results_all.mae, results_all.mae];
    case 5
        results_all.mederr = mean([rtotal(:).MedError]);
        maxval=[results_all.mederr, results_all.mederr, results_all.mederr, results_all.mederr];
end

maxval_a = zeros(1,length(rtotal(1).extrasmall));
minval_a = zeros(1,length(rtotal(1).small));
maxval_b = zeros(1,length(rtotal(1).large));
minval_b = zeros(1,length(rtotal(1).extralarge));

for mx = 1:length(rtotal)
    maxval_a = maxval_a + rtotal(mx).extrasmall;
    minval_a = minval_a + rtotal(mx).small;
    maxval_b = maxval_b + rtotal(mx).large;
    minval_b = minval_b + rtotal(mx).extralarge;
end
maxval_a = maxval_a/length(rtotal);
minval_a = minval_a/length(rtotal);
maxval_b = maxval_b/length(rtotal);
minval_b = minval_b/length(rtotal);

minval=[maxval_a, minval_a,maxval_b, minval_b];

xticklab = {'XS', 'S', 'L', 'XL'};
resall0 = [maxval];
resall1 = [minval];
x=2:9;
n=1;
for k = 1:numel(resall0)
    if isnan(resall0(k)), resall0(k) = 0; end
    hold on;
    plot(x(n),resall0(k), '+', 'linewidth', 4, 'markersize', 2);
    plot(x(n+1),resall1(k), '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    if (metric_type == 1) || (metric_type == 2)
        text(x(n)+0.12, resall0(k), sprintf('%0.2f', resall0(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.2f', resall1(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
    else
        text(x(n)+0.12, resall0(k), sprintf('%0.1f', resall0(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
        text(x(n+1)+0.12, resall1(k), sprintf('%0.1f', resall1(k)), ...
            'FontSize', fs, 'FontWeight', 'bold');
    end
    n = n+2;
end
n = 1;
for i=1:numel(resall0)
    plot([x(n) x(n+1)], [resall0(i) resall1(i)], 'b-', 'linewidth', 4);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    n = n+2;
end
if (metric_type == 1) || (metric_type == 2) || (metric_type == 3)
    ymax = 1;
else
    ymax = max(max(resall0), max(resall1)) + 10;
end

axis([1 10 0 ymax]);
axisval = axis;
n=2.5;
for p = 1:numel(xticklab)
    name = xticklab{p};
    text(n, -0.071*axisval(4), sprintf('%s', name), 'fontsize', fs, 'fontweight', 'bold');
    n = n+2;
end
plot([1.5 9.5], [avgval avgval], 'k--', 'linewidth', 2);
set(gca, 'xticklabel', []);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
ylabel(metric, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'fontsize', fs, 'fontweight', 'bold');
set(gca, 'ticklength', [0.001 0.001]);
title([detector ': Object Size Characteristic Overview'])
      