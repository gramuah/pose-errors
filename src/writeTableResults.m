function writeTableResults(outdir, detector, res, avp_matrix, peap_matrix, dataset, objects, metric_type)

switch metric_type
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

if ~exist(outdir, 'file'), mkdir(outdir); end;
global fid
fid = fopen(fullfile(outdir, ['results.tex']), 'w');

pr('Note that the results shown in this Section are obtained by computing the average over \\textbf{the selected object class} (\\textit{i.e} %d object classes:', length(objects));
for obj=1:length(objects)
    if obj == length(objects)
        pr(' %s) from %s dataset.\n', objects{obj}, dataset)
    else
        pr(' %s, ', objects{obj})
    end
end


pr('\n\n')

pr('Tables \\ref{cont_pose} and \\ref{disc_pose} summarize the detection and pose estimation results considering %d object class from %s dataset. Table \\ref{cont_pose} shows the model performance working on continuous pose estimation. For AVP and PEAP the results are obtained considering a threshold equal to $\\frac{\\pi}{12}$.\n Table \\ref{disc_pose} summarizes the results achieve working on discrete pose estimation. The AVP and PEAP metrics are obtained considering different views: 4, 8, 16 and 24.', length(objects), dataset)
pr('\n\n');
pr('\\begin{table}[h]\n')
pr('\\caption{\\textbf{%s: Detection and Continuous Pose Estimation Results on %s dataset. For AVP and PEAP the results are obtained considering a threshold equal to $\\frac{\\pi}{12}$.}}\n', detector, dataset);
pr('\\label{cont_pose}\n')
pr('\\begin{center}\n');
pr('\\resizebox{\\textwidth}{!}{\n')
pr('\\begin{tabular}{|c||')
for obj=1:length(objects)+1
    if obj == length(objects)+1
        pr('c|}\n');
    else
        pr('c|');
    end
    
end
pr('\\hline\n')
pr('Metric & ')
for obj=1:length(objects)
    pr('%s & ', objects{obj});
end
pr('AVG \\\\ \n');
pr('\\hline\n')
pr('AP & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean([res.ap])*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).ap*100;
        pr('%.1f & ', cad);
    end
    
end
pr('AOS & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean([res.aos])*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).aos*100;
        pr('%.1f & ', cad);
    end
    
end
pr('AVP ($\\frac{\\pi}{12}$) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean([res.avp])*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).avp*100;
        pr('%.1f & ', cad);
    end
    
end
pr('PEAP ($\\frac{\\pi}{12}$) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean([res.peap])*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).peap*100;
        pr('%.1f & ', cad);
    end
    
end

pr('\\hline\n');
pr('\\end{tabular}\n');
pr('}');
pr('\\end{center}\n');
pr('\\end{table}\n');

pr('\\begin{table}[h]\n')
pr('\\vspace{-0.4cm}')
pr('\\caption{\\textbf{%s: Detection and Discrete Pose Estimation Results on %s dataset. Results obtained considering: 4, 8, 16 and 24 Views.}}\n', detector, dataset);
pr('\\label{disc_pose}\n')
pr('\\begin{center}\n');
pr('\\resizebox{\\textwidth}{!}{\n')
pr('\\begin{tabular}{|c||')
for obj=1:length(objects)+1
    if obj == length(objects)+1
        pr('c|}\n');
    else
        pr('c|');
    end
    
end
pr('\\hline\n')
pr('Metric & ')
for obj=1:length(objects)
    pr('%s & ', objects{obj});
end
pr('AVG \\\\ \n');
pr('\\hline\n')
pr('AP & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean([res.ap])*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).ap*100;
        pr('%.1f & ', cad);
    end
    
end
pr('\\hline');
pr('\\hline\n');
pr('AVP (4 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(avp_matrix(1,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).avp_views(1)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('PEAP (4 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(peap_matrix(1,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).peap_views(1)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('\\hline');
pr('\\hline\n');
pr('AVP (8 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(avp_matrix(2,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).avp_views(2)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('PEAP (8 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(peap_matrix(2,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).peap_views(2)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('\\hline');
pr('\\hline\n');

pr('AVP (16 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(avp_matrix(3,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).avp_views(3)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('PEAP (16 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(peap_matrix(3,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).peap_views(3)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('\\hline');
pr('\\hline\n');

pr('AVP (24 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(avp_matrix(4,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).avp_views(4)*100;
        pr('%.1f & ', cad);
    end
    
end
pr('PEAP (24 views) & ');

for obj=1:length(objects)+1
    if obj == length(objects) + 1
        cad = mean(peap_matrix(4,:))*100;
        pr('%.1f \\\\ \n', cad );
    else
        cad = res(obj).peap_views(4)*100;
        pr('%.1f & ', cad);
    end
    
end

pr('\\hline\n');
pr('\\end{tabular}\n');
pr('}');
pr('\\end{center}\n');
pr('\\end{table}\n');


pr('Figure \\ref{fig1} summarizes the impact on the pose performance of each type of error. Figure \\ref{fig1a} reports, for the correct detections obtained by the %s model, the frequency and impact on the pose  performance of each type of false positive. For this Figure a pose estimation is considered as: a) correct if its error is $< 15^\\circ$; b) opposite if its pose error is $> 165^\\circ$; c) nearby if its pose error is $\\in [15^\\circ; 30^\\circ]$; d) other for the rest of situations. Figure \\ref{fig1b} shows the impact of different type of pose errors.\n', detector);
pr('Figure \\ref{fig2} shows the success rate considering 8 viewpoints described in Section \\ref{info}. Hence, considering only the correct detections, Figure \\ref{fig1b} also summarizes the percentage of success and error on pose estimation. \n');
pr('\n');
pr('\\begin{figure}[h]\n');
pr('\\centering\n');
pr('\\subfloat[]{\n');
pr('\\label{fig1a}\n');
pr('\\includegraphics[width=0.45\\textwidth,trim = 25mm 65mm 20mm 65mm, clip]{../plot_3.pdf} \n');
pr('}\n');
pr('\\subfloat[]{\n');
pr('\\label{fig1b}\n');
pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../plot_6.pdf}\n');
pr('}\n');
pr('\\caption{\\textbf{Analysis and Impact of Pose Estimation Errors.} (a) Pie chart shows the fraction of pose errors that are due to Opposite viewpoints (Opposite), confusion with Nearby viewpoints (Nearby), confusion with Other rotations (Other). It also reports the porcentage of correct pose estimations (Correct). (b) Impact of Pose Errors. \\textcolor{blue}{Blue Bars} display the %s performance obtained when all estimations are considered. \\textcolor{green}{Green Bars} display the %s improvement by \\textbf{removing} all estimations of one type: \\textbf{OTH} removes confusion with other rotation viewpoints;  \\textbf{NEAR} removes confusion with nearby viewpoints; \\textbf{OPP} removes confusion with opposite viewpoints. \\textcolor{BrickRed}{Brick Red Bars} show the %s improvement by \\textbf{correcting} all estimations of one type: \\textbf{OTH}, \\textbf{NEAR} and \\textbf{OPP}.} \n', metric, metric, metric);
pr('\\label{fig1}\n');
pr('\\end{figure}\n');
pr('\n');

pr('\\begin{figure}[h]\n');
pr('\\centering\n');
pr('\\includegraphics[width=0.85\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../plot_7.pdf} \n');
pr('\\caption{\\textbf{Success Rate considering 8 viewpoints.}  For each of the 8 viewpoints, we report: In \\textcolor{blue}{Blue}, the porcentage of the correct pose estimations. In \\textcolor{cyan}{Cyan}, the porcentage of confusion with the opposite viewpoints. In \\textcolor{yellow}{Yellow}, the porcentage of confusion with nearby viewpoints. In \\textcolor{BrickRed}{Brick Red}, the porcentage of the confusions with other rotations.}\n');
pr('\\label{fig2}\n');
pr('\\end{figure}\n');
pr('\n');

pr('\\clearpage\n');
pr('Figure \\ref{fig3} summarizes the main object characteristic influences. Figure \\ref{fig3a} shows the influence of the side visibility. Figures \\ref{fig3b} and \\ref{fig3c} report the aspect ratio and object sizes effects, respectively.\n');
pr('Figure \\ref{fig4} provides a summary of the sensitivity to each characteristic and the potential impact on improving pose estimation robustness. The worst-performing and best-performing combinations for each object characteristic are averaged over the selected object categories. The difference between the best and the worst performance indicates sensitivity; the difference between the best and the overall indicates the potential impact.\n');
pr('\\begin{figure}[h]\n');
pr('\\centering\n');
pr('\\subfloat[]{\n');
pr('\\label{fig3a}\n');
pr('\\includegraphics[width=0.3\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../plot_2.pdf}\n');
pr('}\n');
pr('\\subfloat[]{\n');
pr('\\label{fig3b}\n');
pr('\\includegraphics[width=0.3\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../plot_8.pdf}\n');
pr('}\n');
pr('\\subfloat[]{\n');
pr('\\label{fig3c}\n');
pr('\\includegraphics[width=0.3\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../plot_9.pdf}\n');
pr('}\n');
pr('\\caption{\\textbf{Object Characteristic Influences in terms of %s}. (a) Side Visibility Influence. Visible side: \\textbf{1} = performance obtained when the corresponding side is visible; \\textbf{0} = accuracy achieved when the side is not visible. (b) Aspect Ratio Effect. We show the overall accuracy by the black dashed line, and the performance achieved when we only consider: XT , T, W and XW objects. (c) Object Size Effect. We show the overall accuracy by the black dashed line, and the performance achieved when we only consider: XS, S, L and XL objects.}\n', metric);
pr('\\label{fig3}\n');
pr('\\end{figure}\n');

if strcmp(detector(length(detector)-1:length(detector)), 'gt')
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.85\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../plot_1.pdf}\n');
    pr('\\caption{\\textbf{Summary of Sensitivity and Impact of Object Characteristics.} We show the %s performance of the highest performing and lowest performing subsets within each characteristic (occlusion/truncation (occ-trn), bounding box area or object size (size), aspect ratio (asp), visible sides (side) and part visibility (part)). Overall accuracy is indicated by the black dashed line. The difference between max and min indicates sensitivity; the difference between max and overall indicates the impact.\n', metric);
    pr('}\n');
    pr('\\label{fig4}\n');
    pr('\\end{figure}\n');
else
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.85\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../plot_1.pdf}\n');
    pr('\\caption{\\textbf{Summary of Sensitivity and Impact of Object Characteristics.} We show the %s performance of the highest performing and lowest performing subsets within each characteristic (occlusion/truncation (occ-trn), difficult objects (diff), bounding box area or object size (size), aspect ratio (asp), visible sides (side) and part visibility (part)). Overall accuracy is indicated by the black dashed line. The difference between max and min indicates sensitivity; the difference between max and overall indicates the impact.\n', metric);
    pr('}\n');
    pr('\\label{fig4}\n');
    pr('\\end{figure}\n');
end

pr('\\clearpage\n');
pr('Figure \\ref{fig5} shows an analysis of the influence of the overlap criterion considering all the metrics. Figure \\ref{fig5a} shows AOS, AVP and PEAP, and Figure \\ref{fig5b} reports MAE and MedError. For this overlap criterion analysis we follow the PASCAL VOC formulation: to be considered a true positive, the area of overlap between the predicted BB and GT BB must exceed a threshold.\n');
pr('\\begin{figure}[h]\n');
pr('\\centering\n');
pr('\\subfloat[]{\n');
pr('\\label{fig5a}\n');
pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 20mm 65mm, clip]{../plot_4.pdf}\n');
pr('}\n');
pr('\\subfloat[]{\n');
pr('\\label{fig5b}\n');
pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 20mm 65mm, clip]{../plot_5.pdf}\n');
pr('}\n');
pr('\\caption{\\textbf{Simultaneous Object Detection and Pose Estimation.} Analysis of pose estimation performance considering different metrics and different overlap criteria. (a) AP, AOS, AVP and PEAP. (b) MAE and MedError.}\n');
pr('\\label{fig5}\n');
pr('\\end{figure}\n');

pr('\n\n')
pr('Finally, we summarize the main pose estimation errors (Figure \\ref{fig6}) and the success rate considering 8 viewpoints (Figure \\ref{fig7}) for each of the selected object classes: ')
for obj=1:length(objects)
    if obj == length(objects)
        pr(' %s from %s dataset.\n', objects{obj}, dataset)
    else
        pr(' %s, ', objects{obj})
    end
end


pr('\n\n')

pr('\\begin{figure}[h]\n')
pr('\\centering\n');
for obj=1:length(objects)
    name = objects{obj};
    if exist(fullfile(outdir(1:end-4), name, 'analysisI/plot_2.pdf'), 'file')
        pr('\\subfloat[%s]{\n', name);
        pr('\\label{fig6%c}\n', char(96 + obj));
        if mod(obj,3) ~= 0
            pr('\\includegraphics[width=0.3\\textwidth,trim = 25mm 65mm 20mm 65mm, clip]{../%s/analysisI/plot_2.pdf} \n', name);
            pr('}\n');
        else
            pr('\\includegraphics[width=0.3\\textwidth,trim = 25mm 65mm 20mm 65mm, clip]{../%s/analysisI/plot_2.pdf} \n', name);
            pr('}\\\\n');
        end
        
    end
end
pr('\\caption{\\textbf{Main Pose Estimation Errors for all selected Object Class from %s dataset.}}\n', dataset);
pr('\\label{fig6}\n');
pr('\\end{figure}\n');

pr('\\begin{figure}[h]\n')
pr('\\centering\n');
for obj=1:length(objects)
    name = objects{obj};
    if exist(fullfile(outdir(1:end-4), name, 'analysisI/plot_4.pdf'), 'file')
        pr('\\subfloat[%s]{\n', name);
        pr('\\label{fig7%c}\n', char(96 + obj));
        if mod(obj,3) ~= 0
            pr('\\includegraphics[width=0.3\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisI/plot_4.pdf} \n', name);
            pr('}\n');
        else
            pr('\\includegraphics[width=0.3\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisI/plot_4.pdf} \n', name);
            pr('}\\\\n');
        end
        
    end
end
pr('\\caption{\\textbf{Success Rate considering 8 viewpoints for all selected Object Class from %s dataset.}}\n', dataset);
pr('\\label{fig7}\n');
pr('\\end{figure}\n');



fclose(fid);



function pr(varargin)
global fid;
fprintf(fid, varargin{:});