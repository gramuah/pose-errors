function plotFigure5()
%% plot Figure 5 from paper

f=0;
fs = 18;
resultDir = '/home/carolina/projects/pose-estimation/eccv2016/eval_code/results';
detectors = { 'vdpm-gt','vpskps-gt','bhf-gt'};

objnames = {'aeroplane', 'bicycle', 'boat', 'bus', 'car', ...
       'chair', 'diningtable', 'motorbike', 'sofa', 'train', 'tvmonitor'};

% Visible parts vs pose estimation
for obj = 1: length(objnames)
    for d = 1:length(detectors)
        tmp(d) = load ([resultDir, '/', detectors{d}, '/', objnames{obj}, ...
            '/results_I_', objnames{obj} '_strong.mat']);
    end
    f=f+1;
    tickstr = {};
    np=0;
    
    clear results_all;
    for o = 1:numel(tmp)
        if isfield(tmp(o).result.pose, 'part')
            pnames = fieldnames(tmp(o).result.pose.part);
            results_all(o).aos = tmp(o).result.pose.aos;
            results_all(o).avp = tmp(o).result.pose.avp15;
            results_all(o).mean = tmp(o).result.pose.mean_error;
            results_all(o).medError = tmp(o).result.pose.median_error;
            for p = 1:numel(pnames)
                np=np+1;
                results_all(o).tmp((p-1)*2+(1:2)) = tmp(o).result.pose.part.(pnames{p});    
     
            end  
        end
    end
    N = length(detectors);
    drawline = false;
    xticks = makeMultiCategoryPlotPose(f, results_all, 'tmp', ...
        [objnames{obj} ': Visible Parts'], 1, tickstr, drawline, 1, N);
    axisval = axis;
    n=0;
    for o = 1:numel(results_all)
        if isfield(tmp(o).result.pose, 'part')
            pnames = fieldnames(tmp(o).result.pose.part);
            n=n+1;
            for p = 1:numel(pnames)
                name = pnames{p};
                hold on;
                text(n+1, -0.051*axisval(4), sprintf('%d', p), 'fontsize', fs-2);
                n = n+2;
            end

        end
    end
   au = '0/1';
   text(xticks(round(numel(pnames) / 2)+2), -0.12*axisval(4), sprintf('%s', au), 'fontsize', fs);
   text(xticks(round(numel(pnames) / 2) + 2 + (2*numel(pnames))), -0.12*axisval(4), sprintf('%s', au), 'fontsize', fs);
   text(xticks(round(numel(pnames) / 2) + 2 + (4*numel(pnames))), -0.12*axisval(4), sprintf('%s', au), 'fontsize', fs);
   text(xticks(round(numel(pnames) / 2)), 0.3, sprintf('%s', 'VDPM'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
   text(xticks(round(numel(pnames) / 2) + (2*numel(pnames))), 0.3, sprintf('%s', 'V&K'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
   text(xticks(round(numel(pnames) / 2) + (4*numel(pnames))), 0.3, sprintf('%s', 'BHF'), 'fontsize', fs, 'FontWeight', 'bold', 'Color', 'red');
   hold off;
      
end

Nfig = f;
for f = 1:Nfig
     print('-dpdf', ['-f' num2str(f)], ...
           fullfile(resultDir, sprintf('plot_%d.pdf', f)));
end

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
  h=plot(rangex([1 end]), [1 1]*result.aos, 'k--', 'linewidth', 2);
  hold on;
  text(rangex(1)-6, result.aos, sprintf('%0.2f', result.aos), ...
          'FontSize', fs, 'FontWeight', 'bold');  
          
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
set(gca, 'ytick', 0:10); 
ylabel('AOS');
set(gca, 'xticklabel', xticklab, 'fontsize', fs);
set(gca, 'yticklabel', [], 'fontsize', fs)
set(gca, 'ygrid', 'on')
set(gca, 'xgrid', 'on')
set(gca, 'fontsize', fs);
set(gca, 'ticklength', [0.001 0.001]);


function plotapnbarspose(resall, x, drawline, error_type, shift_y)
fs = 18;
for k = 1:numel(resall)
  res =resall(k);
  switch error_type
      case 1
          err_name = res.aos;
          err_name_std = res.aos_stderr;
      case 2
          err_name = res.avp;
          err_name_std = res.avp_stderr;
      case 3
          err_name = res.mean_error;
          err_name_std = res.std_error;
      case 4    
          err_name = res.median_error;
          err_name_std = res.std_error;
  end
  if isnan(err_name), err_name = 0; end
  if ~isnan(res.apn_stderr)
    errorbar(x(k), err_name , err_name_std, 'r', 'linewidth', 1);
  end
  hold on;
  plot(x(k), err_name, '+', 'linewidth', 4, 'markersize', 2);
  set(gca, 'fontsize', fs, 'FontWeight', 'bold');
  
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
            plot(x, [resall.avp], 'b-', 'linewidth', 4);
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).avp] + shift_y, 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 3    
        if drawline
            plot(x, [resall.mean_error], 'b-', 'linewidth', 4);
            set(gca, 'fontsize', fs, 'FontWeight', 'bold');
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).mean_error] + shift_y, 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
    case 4    
        if drawline
            plot(x, [resall.median_error], 'b-', 'linewidth', 4);
            set(gca, 'fontsize', fs, 'FontWeight', 'bold');
        else % draw every other
            for i=1:2:numel(x)
                plot(x([i i+1]), [resall([i i+1]).median_error] + shift_y, 'b-', 'linewidth', 4);
                set(gca, 'fontsize', fs, 'FontWeight', 'bold');
            end
        end
end

function setupplot(f)
figure(f), hold off 