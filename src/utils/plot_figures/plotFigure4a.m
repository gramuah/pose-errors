function plotFigure4a()
%% plot Figure 4(a) from paper

f=0;
fs = 18;
resultDir = '/home/carolina/projects/pose-estimation/eccv2016/eval_code/results';
detectors = {'vdpm-gt','vpskps-gt', 'bhf-gt'};



% Visible parts vs pose estimation
for obj = 1: length(detectors)
    tmp(obj) = load ([resultDir, '/', detectors{obj}, '/results_total.mat']);
end
f=f+1;
tickstr = {};
np=0;

clear results_all;
for o = 1:numel(tmp)
    pnames = {'fr', 're', 'side'};
    results_all(o).aos = mean([tmp(o).resulttotal(:).aos]);
    results_all(o).avp = mean([tmp(o).resulttotal(:).avp]);
    maxval_a = zeros(1,length(tmp(o).resulttotal(1).side_1));
    minval_a = zeros(1,length(tmp(o).resulttotal(1).side_2));
    for mx = 1:length(tmp(o).resulttotal)
        maxval_a = maxval_a + tmp(o).resulttotal(mx).side_1;
        minval_a = minval_a + tmp(o).resulttotal(mx).side_2;
    end
    maxval = maxval_a/length(tmp(o).resulttotal);
    minval = minval_a/length(tmp(o).resulttotal);
    for p = 1:numel(pnames)
        results_all(o).tmp((p-1)*2+(1:2)) = [maxval(p), minval(p)];
    end
end
N = length(detectors);
drawline = false;
xticks = makeMultiCategoryPlotPose(f, results_all, 'tmp', ...
    ['Visible Side Characteristic Overview'], 1, tickstr, drawline, 1, N);
axisval = axis;
n=0;

for o = 1:numel(results_all)
    n=n+1;
    for p = 1:numel(pnames)
        name = pnames{p};
        hold on;
        text(n+0.5, -0.071*axisval(4), sprintf('%s\n 0/1', name), 'fontsize', fs, 'fontweight', 'bold');
        n = n+2;
    end
    
end

text(xticks(round(numel(pnames) / 2)) , 0.2, sprintf('%s', 'VDPM'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
text(xticks(round(numel(pnames) / 2) + (2*numel(pnames)))+1, 0.2, sprintf('%s', 'V&K'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
text(xticks(round(numel(pnames) / 2) + (4*numel(pnames)))+1, 0.2, sprintf('%s', 'BHF'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
hold off;



Nfig = f;
for f = 1:Nfig
    print('-dpdf', ['-f' num2str(f)], ...
        fullfile(resultDir, sprintf('plot_%d.pdf', f)));
end
hold off;
close all;

function xticks = makeMultiCategoryPlotPose(f, results, ...
    rname, title_str, xtickstep, xticklab, drawline, error_type, N)

fs = 18;
setupplot(f);

if ~isfield(results(1), rname)% || any(isnan([results(1).(rname).apn]))
    return;
end

nobj = numel(results);

rangex = 0;
maxy = 0;
xticks = [];
yticks = [];

firsttick = zeros(nobj,1);
for o = 1:nobj
    result = results(o);
    nres = numel(results(o).(rname));
    rangex = rangex(end)+1+(1:nres);
    shift_y(o) = result.aos;
    plotapnbarspose(result.(rname), rangex, drawline, error_type, shift_y(o));
    
    maxy = max(maxy, round(max(([result.aos]+0.15))*10)/10);
    my(o) = max(maxy, round(max(([result.aos]+0.15))*10)/10);
    hold on;
    h=plot(rangex([1 end]), [1 1]*result.aos, 'k--', 'linewidth', 2);
    
    text(rangex(1)-2.5, result.aos, sprintf('%0.2f', result.aos), ...
        'FontSize', fs, 'FontWeight', 'bold');
    %ylabel('AOS', 'fontsize', fs, 'FontWeight', 'bold');
    maxy = min(maxy, 1);
    
    firsttick(o) = rangex(1);
    xticks = [xticks rangex(1:xtickstep:end)];
    
    
end

if numel(xticklab)==nres
    xticklab = repmat(xticklab, [1 nobj]);
end
axis([0 rangex(end)+1 0 max(my) + 0.05]);
title(title_str, 'fontsize', fs);
set(gca, 'xtick', xticks);
%set(gca, 'ytick', 0:10);
box on
ylabel('AOS');
set(gca, 'xticklabel', xticklab, 'fontsize', fs);
set(gca, 'yticklabel', [], 'fontsize', fs)
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
set(gca, 'fontsize', fs);
set(gca, 'ticklength', [0.001 0.001]);


function plotapnbarspose(resall, x)
fs = 18;
for k = 1:numel(resall)
    
    hold on;
    plot(x(k), resall(k), '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    text(x(k)+0.12, resall(k), sprintf('%0.2f', resall(k)), 'FontSize', fs, 'FontWeight', 'bold');
end
for i=1:2:numel(x)-1
    plot(x([i i+1]), [resall([i i+1])], 'b-', 'linewidth', 4);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
end


function setupplot(f)
figure(f), hold off