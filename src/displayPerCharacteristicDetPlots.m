function [resutclass,f] = displayPerCharacteristicDetPlots(results_all, error_type)
%function [resutclass,f] = displayPerCharacteristicDetPlots(results_all, error_type)
%
% Object characteristic effect on detection: save and display plots 
%
% Inputs: 
% results_all: detection results
% error_type: metric to analysis 

close all

drawline = true;
makeMultiCategoryPlot(1, results_all, 'occ', ...
    [results_all(1).name ': Occluded Objects'], 1, {'N', 'O'}, drawline);
makeMultiCategoryPlot(2, results_all, 'area', ...
    [results_all(1).name ': Object Size Influence'], 1, {'XS', 'S', 'M', 'L', 'XL'}, drawline);
makeMultiCategoryPlot(3, results_all, 'aspect', ...
    [results_all(1).name ': Aspect Ratio Influence'], 1, {'XT', 'T', 'M', 'W', 'XW'}, drawline);
makeMultiCategoryPlot(4, results_all, 'truncated', ...
    [results_all(1).name ': Truncated Objects'], 1, {'N', 'T'}, drawline);
makeMultiCategoryPlot(5, results_all, 'trunc_occ', ...
    [results_all(1).name ': Trunc/Occ. Objects'], 1, {'N', 'T/O'}, drawline);
makeMultiCategoryPlot(6, results_all, 'diff_nondiff', ...
    [results_all(1).name ': Difficult Objects'], 1, {'All', 'Only Diff'}, drawline);
f=6;

fs = 18;

%% Visible parts
f=f+1;
tickstr = {};
np=0;

for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'part')
        pnames = fieldnames(results_all(o).pose.part);
        for p = 1:numel(pnames)
            np=np+1;
            results_all(o).tmp((p-1)*2+(1:2)) = results_all(o).pose.part.(pnames{p});
        end
    end
end
drawline = false;
makeMultiCategoryPlot(f, results_all, 'tmp', ...
    [results_all(o).name ': Part Visibility Effect'], 1, tickstr, drawline);
axisval = axis;
n=0;
for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'part')
        pnames = fieldnames(results_all(o).pose.part);
        n=n+1;
        for p = 1:numel(pnames)
            text(n+1, -0.071*axisval(4), sprintf('%d\n0/1', p), 'fontsize', fs);
            n = n+2;
        end
    end
end
if isfield(results_all, 'tmp')
    results_all = rmfield(results_all, 'tmp');
end

%% Visible sides
f=f+1;
tickstr = {};
np=0;
for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'side')
        pnames = fieldnames(results_all(o).pose.side);
        pnames = pnames(2:4);
        for p = 1:numel(pnames)
            np=np+1;
            results_all(o).tmp((p-1)*2+(1:2)) = results_all(o).pose.side.(pnames{p});
            
        end
    end
end
drawline = false;
makeMultiCategoryPlot(f, results_all, 'tmp', ...
    [results_all(o).name ': Visible Side Influence'], 1, tickstr, drawline);
axisval = axis;
n=0;
for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'side')
        pnames = fieldnames(results_all(o).pose.side);
        pnames = pnames(2:4);
        n=n+1;
        for p = 1:numel(pnames)
            name = pnames{p}; if numel(name)>5, name = removeVowels(name); end;
            text(n+1, -0.071*axisval(4), sprintf('%s\n0/1', name), 'fontsize', fs);
            n = n+2;
        end
    end
end
if isfield(results_all, 'tmp')
    results_all = rmfield(results_all, 'tmp');
end

%% Visible parts vs pose estimation
f=f+1;
tickstr = {};
np=0;

for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'part')
        pnames = fieldnames(results_all(o).pose.part);
        for p = 1:numel(pnames)
            np=np+1;
            results_all(o).pose.tmp((p-1)*2+(1:2)) = results_all(o).pose.part.(pnames{p});
            
        end
    end
end
drawline = false;

makeMultiCategoryPlotPose(f, results_all.pose, 'tmp', ...
    [results_all(o).name ': Part Visibility Effect'], 1, tickstr, drawline, error_type);
axisval = axis;
n=0;
for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'part')
        pnames = fieldnames(results_all(o).pose.part);
        n=n+1;
        for p = 1:numel(pnames)
            text(n+1, -0.071*axisval(4), sprintf('%d\n0/1', p), 'fontsize', fs);
            n = n+2;
        end
    end
end
if isfield(results_all, 'tmp')
    results_all = rmfield(results_all, 'tmp');
end

%% Visible sides vs pose estimation
f=f+1;
tickstr = {};
np=0;
for o = 1:numel(results_all)
    if isfield(results_all(o).pose, 'side')
        pnames = fieldnames(results_all(o).pose.side);
        pnames = pnames(2:4);
        for p = 1:numel(pnames)
            switch error_type
                case 1
                    resutclass.side_1(p) = results_all(o).pose.side.(pnames{p})(1).aos;
                    if isnan(resutclass.side_1(p))
                        resutclass.side_1(p) = results_all(o).pose.aos;
                    end
                    resutclass.side_2(p) = results_all(o).pose.side.(pnames{p})(2).aos;
                    if isnan(resutclass.side_2(p))
                        resutclass.side_2(p) = results_all(o).pose.aos;
                    end
                case 2
                    resutclass.side_1(p) = results_all(o).pose.side.(pnames{p})(1).avp15;
                    if isnan(resutclass.side_1(p))
                        resutclass.side_1(p) = results_all(o).pose.avp15;
                    end
                    resutclass.side_2(p) = results_all(o).pose.side.(pnames{p})(2).avp15;
                    if isnan(resutclass.side_2(p))
                        resutclass.side_2(p) = results_all(o).pose.avp15;
                    end
                case 3
                    resutclass.side_1(p) = results_all(o).pose.side.(pnames{p})(1).peap15;
                    if isnan(resutclass.side_1(p))
                        resutclass.side_1(p) = results_all(o).pose.peap15;
                    end
                    resutclass.side_2(p) = results_all(o).pose.side.(pnames{p})(2).peap15;
                    if isnan(resutclass.side_2(p))
                        resutclass.side_2(p) = results_all(o).pose.avp15;
                    end
                case 4
                    resutclass.side_1(p) = results_all(o).pose.side.(pnames{p})(1).mean_error;
                    if isnan(resutclass.side_1(p))
                        resutclass.side_1(p) = results_all(o).pose.mean_error;
                    end
                    resutclass.side_2(p) = results_all(o).pose.side.(pnames{p})(2).mean_error;
                    if isnan(resutclass.side_2(p))
                        resutclass.side_2(p) = results_all(o).pose.mean_error;
                    end
                case 5
                    resutclass.side_1(p) = results_all(o).pose.side.(pnames{p})(1).median_error;
                    if isnan(resutclass.side_1(p))
                        resutclass.side_1(p) = results_all(o).pose.median_error;
                    end
                    resutclass.side_2(p) = results_all(o).pose.side.(pnames{p})(2).median_error;
                    if isnan(resutclass.side_2(p))
                        resutclass.side_2(p) = results_all(o).pose.median_error;
                    end
            end
            
            np=np+1;
            results_all(o).pose.tmp2((p-1)*2+(1:2)) = results_all(o).pose.side.(pnames{p});
            
        end
    end
end
drawline = false;
makeMultiCategoryPlotPose(f, results_all.pose, 'tmp2', ...
    [results_all(o).name ': Visible Side Influence'], 1, tickstr, drawline, error_type);
axisval = axis;
n=0;
for o = 1:numel(results_all)
    
    if isfield(results_all(o).pose, 'side')
        pnames = fieldnames(results_all(o).pose.side);
        pnames = pnames(2:4);
        n=n+1;
        for p = 1:numel(pnames)
            name = pnames{p}; if numel(name)>5, name = removeVowels(name); end;
            text(n+1, -0.071*axisval(4), sprintf('%s\n0/1', name), 'fontsize', fs);
            n = n+2;
        end
    end
end
if isfield(results_all, 'tmp2')
    results_all = rmfield(results_all, 'tmp2');
end

if isfield(results_all, 'tmp2')
    results_all = rmfield(results_all, 'tmp2');
end


function makeMultiCategoryPlot(f, results, rname, title_str, xtickstep, xticklab, drawline)

fs = 18;
setupplot(f);

if ~isfield(results(1), rname)
    return;
end

nobj = numel(results);

rangex = 0;
maxy = 0;
xticks = [];
firsttick = zeros(nobj,1);
for o = 1:nobj
    result = results(o);
    nres = numel(results(o).(rname));
    rangex = rangex(end)+1+(1:nres);
    plotapnbars(result.(rname), rangex, drawline);
    maxy = max(maxy, round(max(([result.(rname).ap]+0.15))*10)/10);
    h=plot(rangex([1 end]), [1 1]*result.pose.ap, 'k--', 'linewidth', 2);
    firsttick(o) = rangex(1);
    xticks = [xticks rangex(1:xtickstep:end)];
end
maxy = min(maxy, 1);
if numel(xticklab)==nres
    xticklab = repmat(xticklab, [1 nobj]);
end
axis([0 rangex(end)+1 0 maxy]);
for o = 1:numel(results)
    if strcmp(results(o).name, 'diningtable')
        results(o).name = 'diningtable';
    elseif strcmp(results(o).name, 'aeroplane')
        results(o).name = 'aeroplane';
    end
    
end
title(title_str, 'fontsize', fs);
set(gca, 'xtick', xticks);
ylabel('AP', 'fontsize', fs);

set(gca, 'xticklabel', xticklab);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
set(gca, 'fontsize', fs);
set(gca, 'ticklength', [0.001 0.001]);

function makeMultiCategoryPlotPose(f, results, ...
    rname, title_str, xtickstep, xticklab, drawline, error_type)

fs = 18;
setupplot(f);

if ~isfield(results(1), rname)
    return;
end

nobj = numel(results);

rangex = 0;
maxy = 0;
xticks = [];
firsttick = zeros(nobj,1);
for o = 1:nobj
    result = results(o);
    nres = numel(results(o).(rname));
    rangex = rangex(end)+1+(1:nres);
    plotapnbarspose(result.(rname), rangex, drawline, error_type);
    switch error_type
        case 1
            maxy = max(maxy, round(max(([result.(rname).aos]+0.15))*10)/10);
            h=plot(rangex([1 end]), [1 1]*result.aos, 'k--', 'linewidth', 2);
            ylabel('AOS', 'fontsize', fs, 'FontWeight', 'bold');
            maxy = min(maxy, 1);
            
        case 2
            maxy = max(maxy, round(max(([result.(rname).avp15]+0.15))*10)/10);
            h=plot(rangex([1 end]), [1 1]*result.avp15, 'k--', 'linewidth', 2);
            ylabel('AVP', 'fontsize', fs, 'FontWeight', 'bold');
            maxy = min(maxy, 1);
        case 3
            maxy = max(maxy, round(max(([result.(rname).peap15]+0.15))*10)/10);
            h=plot(rangex([1 end]), [1 1]*result.peap15, 'k--', 'linewidth', 2);
            ylabel('PEAP', 'fontsize', fs, 'FontWeight', 'bold');
            maxy = min(maxy, 1);
        case 4
            maxy = max(maxy, round(max(([result.(rname).mean_error]))) + 80);
            h=plot(rangex([1 end]), [1 1]*result.mean_error, 'k--', 'linewidth', 2);
            ylabel('MAE', 'fontsize', fs, 'FontWeight', 'bold');
            
        case 5
            maxy = max(maxy, round(max(([result.(rname).median_error]))) + 80);
            h=plot(rangex([1 end]), [1 1]*result.median_error, 'k--', 'linewidth', 2);
            ylabel('MedError', 'fontsize', fs, 'FontWeight', 'bold');
            
    end
    
    firsttick(o) = rangex(1);
    xticks = [xticks rangex(1:xtickstep:end)];
end

if numel(xticklab)==nres
    xticklab = repmat(xticklab, [1 nobj]);
end
axis([0 rangex(end)+1 0 maxy]);
title(title_str, 'fontsize', fs);
set(gca, 'xtick', xticks);

set(gca, 'xticklabel', xticklab, 'fontsize', fs);
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
set(gca, 'fontsize', fs);
set(gca, 'ticklength', [0.001 0.001]);


function plotapnbars(resall, x, drawline)
fs = 18;
for k = 1:numel(resall)
    res =resall(k);
    if isnan(res.ap), res.ap = 0; end
    if ~isnan(res.ap_stderr)
        errorbar(x(k), res.ap, res.ap_stderr, 'r', 'linewidth', 1);
    end
    hold on;
    plot(x(k), res.ap, '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    text(x(k)+0.12, res.ap, sprintf('%0.2f', res.ap), 'fontsize', fs, 'FontWeight', 'bold');
end
if drawline
    plot(x, [resall.ap], 'b-', 'linewidth', 4);
else % draw every other
    for i=1:2:numel(x)
        plot(x([i i+1]), [resall([i i+1]).ap], 'b-', 'linewidth', 4);
        set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    end
end

function plotapnbarspose(resall, x, drawline, error_type)
fs = 18;
for k = 1:numel(resall)
    res =resall(k);
    switch error_type
        case 1
            err_name = res.aos;
            err_name_std = res.aos_stderr;
        case 2
            err_name = res.avp15;
            err_name_std = res.avp_stderr15;
        case 3
            err_name = res.peap15;
            err_name_std = res.peap_stderr15;
        case 4
            err_name = res.mean_error;
            err_name_std = res.std_error;
        case 5
            err_name = res.median_error;
            err_name_std = res.std_error;
    end
    if isnan(err_name), err_name = 0; end
    if ~isnan(res.ap_stderr)
        errorbar(x(k), err_name, err_name_std, 'r', 'linewidth', 1);
    end
    hold on;
    plot(x(k), err_name, '+', 'linewidth', 4, 'markersize', 2);
    set(gca, 'fontsize', fs, 'FontWeight', 'bold');
    if (error_type == 1) || (error_type == 2) || (error_type == 3)
        text(x(k)+0.12, err_name, sprintf('%0.2f', err_name), 'FontSize', fs, 'FontWeight', 'bold');
    else
        text(x(k)+0.12, err_name, sprintf('%0.1f', err_name), 'FontSize', fs, 'FontWeight', 'bold');
    end
end
switch error_type
    case 1
        if drawline
            plot(x, [resall.aos], 'b-', 'linewidth', 4);
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).aos], 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 2
        if drawline
            plot(x, [resall.avp15], 'b-', 'linewidth', 4);
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).avp15], 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 3
        if drawline
            plot(x, [resall.peap15], 'b-', 'linewidth', 4);
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).peap15], 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 4
        if drawline
            plot(x, [resall.mean_error], 'b-', 'linewidth', 4);
            set(gca, 'fontsize', fs, 'FontWeight', 'bold');
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).mean_error], 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 5
        if drawline
            plot(x, [resall.median_error], 'b-', 'linewidth', 4);
            set(gca, 'fontsize', fs, 'FontWeight', 'bold');
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).median_error], 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
end

function str = removeVowels(str)
for v = 'aeiou'
    str(str==v) = [];
end


function setupplot(f)
figure(f), hold off