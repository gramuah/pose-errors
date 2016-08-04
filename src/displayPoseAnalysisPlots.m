function [resultclass, f]=displayPoseAnalysisPlots(resultfp, result, metric_type)

close all
fs = 18;
f = 1;

%% Impact Bar Chart

% Obtained pose results:
tmp = [resultfp.pose];
AOS = mean([tmp.aos]);
AVP = mean([tmp.avp15]);
PEAP = mean([tmp.peap15]);
MAE = mean([tmp.mean_error]);
MedErr = mean([tmp.median_error]);

%% Obtained pose results if ignore or correct the errors:
tmp = [resultfp.pose.ignoreopp];
ignore_OPP_aos = mean([tmp.aos]);
ignore_OPP_avp = mean([tmp.avp15]);
ignore_OPP_peap = mean([tmp.peap15]);
ignore_OPP_mae = mean([tmp.mean_error]);
ignore_OPP_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.correctopp];
correct_OPP_aos = mean([tmp.aos]);
correct_OPP_avp = mean([tmp.avp15]);
correct_OPP_peap = mean([tmp.peap15]);
correct_OPP_mae = mean([tmp.mean_error]);
correct_OPP_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.ignorenearby];
ignore_NEAR_aos = mean([tmp.aos]);
ignore_NEAR_avp = mean([tmp.avp15]);
ignore_NEAR_peap = mean([tmp.peap15]);
ignore_NEAR_mae = mean([tmp.mean_error]);
ignore_NEAR_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.correctnearby];
correct_NEAR_aos = mean([tmp.aos]);
correct_NEAR_avp = mean([tmp.avp15]);
correct_NEAR_peap = mean([tmp.peap15]);
correct_NEAR_mae = mean([tmp.mean_error]);
correct_NEAR_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.ignoreother];
ignore_OTH_aos = mean([tmp.aos]);
ignore_OTH_avp = mean([tmp.avp15]);
ignore_OTH_peap = mean([tmp.peap15]);
ignore_OTH_mae = mean([tmp.mean_error]);
ignore_OTH_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.correctother];
correct_OTH_aos = mean([tmp.aos]);
correct_OTH_avp = mean([tmp.avp15]);
correct_OTH_peap = mean([tmp.peap15]);
correct_OTH_mae = mean([tmp.mean_error]);
correct_OTH_mederr = mean([tmp.median_error]);

tmp = [resultfp.pose.ignoreall];
ignoreall_aos = mean([tmp.aos]);
ignoreall_avp = mean([tmp.avp15]);
ignoreall_peap = mean([tmp.peap15]);
ignoreall_mae = mean([tmp.mean_error]);
ignoreall_mederr = mean([tmp.median_error]);

resultclass.aos = AOS;
resultclass.ignore_OPP_aos = ignore_OPP_aos;
resultclass.correct_OPP_aos = correct_OPP_aos;
resultclass.ignore_NEAR_aos = ignore_NEAR_aos;
resultclass.correct_NEAR_aos = correct_NEAR_aos;
resultclass.ignore_OTH_aos = ignore_OTH_aos;
resultclass.correct_OTH_aos = correct_OTH_aos;

resultclass.avp = AVP;
resultclass.ignore_OPP_avp = ignore_OPP_avp;
resultclass.correct_OPP_avp = correct_OPP_avp;
resultclass.ignore_NEAR_avp = ignore_NEAR_avp;
resultclass.correct_NEAR_avp = correct_NEAR_avp;
resultclass.ignore_OTH_avp = ignore_OTH_avp;
resultclass.correct_OTH_avp = correct_OTH_avp;

resultclass.avp = PEAP;
resultclass.ignore_OPP_peap = ignore_OPP_peap;
resultclass.correct_OPP_peap = correct_OPP_peap;
resultclass.ignore_NEAR_peap = ignore_NEAR_peap;
resultclass.correct_NEAR_peap = correct_NEAR_peap;
resultclass.ignore_OTH_peap = ignore_OTH_peap;
resultclass.correct_OTH_peap = correct_OTH_peap;

resultclass.mae = MAE;
resultclass.ignore_OPP_mae = ignore_OPP_mae;
resultclass.correct_OPP_mae = correct_OPP_mae;
resultclass.ignore_NEAR_mae = ignore_NEAR_mae;
resultclass.correct_NEAR_mae = correct_NEAR_mae;
resultclass.ignore_OTH_mae = ignore_OTH_mae;
resultclass.correct_OTH_mae = correct_OTH_mae;

resultclass.mae = MedErr;
resultclass.ignore_OPP_MedError = ignore_OPP_mederr;
resultclass.correct_OPP_MedError = correct_OPP_mederr;
resultclass.ignore_NEAR_MedError = ignore_NEAR_mederr;
resultclass.correct_NEAR_MedError = correct_NEAR_mederr;
resultclass.ignore_OTH_MedError = ignore_OTH_mederr;
resultclass.correct_OTH_MedError = correct_OTH_mederr;

%% Pose Error Study (Fig: 1)
switch metric_type
    case 1
        y = [AOS, ignore_OPP_aos, correct_OPP_aos; ...
            AOS, ignore_NEAR_aos, correct_NEAR_aos; ...
            AOS, ignore_OTH_aos, correct_OTH_aos];
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
        title(resultfp.name)

    case 2

        y = [AVP, ignore_OPP_avp, correct_OPP_avp; ...
            AVP, ignore_NEAR_avp, correct_NEAR_avp; ...
            AVP, ignore_OTH_avp, correct_OTH_avp];
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
        title(resultfp.name)
    case 3
        y = [PEAP, ignore_OPP_peap, correct_OPP_peap; ...
            PEAP, ignore_NEAR_peap, correct_NEAR_peap; ...
            PEAP, ignore_OTH_peap, correct_OTH_peap];
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
        title(resultfp.name)

    case 4
        y = [MAE, ignore_OPP_mae, correct_OPP_mae; ...
            MAE, ignore_NEAR_mae, correct_NEAR_mae; ...
            MAE, ignore_OTH_mae, correct_OTH_mae];
        x = [1 2 3];

        figure(f), hold off;
        barh(x, y);

        xlim = [0 ceil((max([ignore_NEAR_mae correct_NEAR_mae MAE])+0.5))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('MAE', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(resultfp.name)

    case 5
        y = [MedErr, ignore_OPP_mederr, correct_OPP_mederr; ...
            MedErr, ignore_NEAR_mederr, correct_NEAR_mederr; ...
            MedErr, ignore_OTH_mederr, correct_OTH_mederr];
        x = [1 2 3];

        figure(f), hold off;
        barh(x, y);

        xlim = [0 ceil((max([ignore_NEAR_mederr correct_NEAR_mederr MAE])+0.5))];
        set(gca, 'xlim', xlim);
        set(gca, 'xminortick', 'on');
        set(gca, 'ticklength', get(gca, 'ticklength'));
        xlabel('MedError', 'fontsize', fs);
        set(gca, 'ytick', 1:3)
        set(gca, 'yticklabel', {'OPP', 'NEAR', 'OTH'});
        set(gca, 'fontsize', fs);
        title(resultfp.name)
end

%% Count Pie Chart --> Error Analysis (Fig: 2)

f = f + 1;
figure(f), hold off;

correct = resultfp.pose.no_error;
nearby = resultfp.pose.nearby_error;
oth = resultfp.pose.other_error;
opp = resultfp.pose.opp_error;

resultclass.correct = correct;
resultclass.opp = opp;
resultclass.nearby = nearby;
resultclass.oth = oth;

p=pie([correct opp nearby oth], ...
  {['Correct: ' num2str(round(correct)) '%'], ...
   ['Opposite: ' num2str(round(opp)) '%'], ...
   ['Nearby: ' num2str(round(nearby)) '%'], ...
   ['Other: ' num2str(round(oth)) '%']}); 

set(p(2:2:length(p)),'FontSize',20, 'FontWeight', 'bold');
title(resultfp.name, 'fontsize', fs, 'fontweight', 'bold')
colormap([1 1 1 ; [79 129 189]/255 ; [192 80 77]/255 ; [77 192 80]/255*1.2 ; [128 100 162]/255]);

%% Pose Analysis (Fig: 3 and 4)

f = f + 1;
xviewpointlabels = {'F', 'F-L', 'L', 'L-RE', 'RE', 'RE-R', 'R', 'R-F'};
hist_result = (resultfp.pose.hist_views ./ result.gt.gtviewvector_wodiff).*100;
hist_opp_result = (resultfp.pose.hist_opp_views ./ result.gt.gtviewvector_wodiff).*100;
hist_near_result = (resultfp.pose.hist_near_views ./ result.gt.gtviewvector_wodiff).*100;
hist_oth_result = (resultfp.pose.hist_oth_views ./ result.gt.gtviewvector_wodiff).*100;

[ind]=find(isnan(hist_result));
if ~isempty(ind)
    hist_result(ind) = 0;
end

ind=[];
[ind]=find(isnan(hist_opp_result));
if ~isempty(ind)
    hist_opp_result(ind) = 0;
end

ind=[];
[ind]=find(isnan(hist_near_result));
if ~isempty(ind)
    hist_near_result(ind) = 0;
end

ind=[];
[ind]=find(isnan(hist_oth_result));
if ~isempty(ind)
    hist_oth_result(ind) = 0;
end

resultclass.hist_result = hist_result;
resultclass.hist_opp_result = hist_opp_result;
resultclass.hist_near_result = hist_near_result;
resultclass.hist_oth_result = hist_oth_result;

[sv, si] = sort(hist_result, 'descend');
hist_result = hist_result(si);
hist_opp_result = hist_opp_result(si);
hist_near_result = hist_near_result(si);
hist_oth_result = hist_oth_result(si);
xviewpointlabels_sort = xviewpointlabels(si);

figure(f), hold off; %Pose Distribution
bar(resultfp.pose.hist_gt_views,'FaceColor', [79 129 189]/255);
axis([0 9 0 max(resultfp.pose.hist_gt_views)+10]);

set(gca, 'xtick', 1:8)
set(gca, 'xticklabel', xviewpointlabels, 'fontsize', fs+4);
ylabel('Number of objects', 'fontsize', fs+4);
title(resultfp.name, 'fontsize', fs+4, 'fontweight', 'bold')


%%%%
f = f + 1;
figure(f), hold off; %Success Rate and Errors per Each View
Y = [hist_result; hist_opp_result; hist_near_result; hist_oth_result];
bar(Y','stacked');

axis([0 9 0 110]);
set(gca, 'xtick', 1:8)
set(gca, 'xticklabel', xviewpointlabels_sort);
ylabel('Success Rate (%)');
title(resultfp.name, 'fontsize', fs, 'fontweight', 'bold')