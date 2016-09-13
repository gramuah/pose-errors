function writeTexObject(name, outdir, gt, metric_type, dataset, detector)
% writeTexObject(name, outdir, gt)
%
% Adds latex code to an existing file for one object:
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
fid = fopen(fullfile(outdir, [name '.tex']), 'w');

pr('\\subsection{%s}\n\n', name);

% create table
if ~isempty(gt)
    
    pr('\\textbf{Statistics for %s class:}\n', name);
    pr('\n\n')
    pr('Number of objects = %d,  No difficult objects = %d\n', length(gt.isdiff), sum(~gt.isdiff));
    pr('\n\n')
    pr('Truncated: None = %d, Truncated = %d\n', sum(~gt.isdiff)-sum(gt.istrunc), sum(gt.istrunc));
    pr('\n\n')
    if ~isempty(gt.details{1})
        details = cat(1, gt.details{:});
        pr('Occluded: None = %d, Occluded = %d\n', hist([details.occ_level], 1:2));
        pr('\n\n')
        a = find(gt.istrunc == 1);
        b = find(gt.isocc == 1);
        [c1,ia1] = setdiff(a,b);
        occtrunc = max(length(a), length(b)) - length(ia1);
        pr('Occluded and Truncated: %d\n', occtrunc);
        sv = [details.side_visible];
        names = fieldnames(details(1).side_visible);
        pr('\n\n')
        pr('side visible: \n');
        pr('\\begin{verbatim}\n');
        for k = 1:numel(names)
            pr('        %s: Yes = %d  No = %d \n', names{k}, sum([sv.(names{k})]==1), sum([sv.(names{k})]==0));
        end
        pr('\\end{verbatim}\n');
        pr('\n\n')
        pr('part visible: \n');
        pr('\\begin{verbatim}\n');
        sv = [details.part_visible];
        names = fieldnames(details(1).part_visible);
        for k = 1:numel(names)
            pr('       part %d = %s: Yes = %d  No = %d \n', k, names{k}, sum([sv.(names{k})]==1), sum([sv.(names{k})]==0));
        end
        pr('\\end{verbatim}\n');
    end
    
    pr('\n\n');
end
pr('\\clearpage')
pr('\n\n');
pr('Figure \\ref{fig1%s} summarizes the viewpoint distribution on the test set for %s class considering the 8 views described in Section \\ref{info}. Figure \\ref{fig2%s} shows the analysis and the impact on the pose performance of each type of pose error. We also report in Figure \\ref{fig3%s} the success rate  for %s class considering each of the 8 viewpoints described in Section \\ref{info}. ', name, name, name, name, name);

if exist(fullfile(outdir(1:end-4), name, 'analysisI/plot_2.pdf'), 'file')
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.65\\textwidth,trim = 20mm 65mm 25mm 60mm, clip]{../%s/analysisI/plot_3.pdf}\n', name);
    pr('\\caption{\\textbf{Analysis of Pose Distribution.} Histogram represents viewpoint distribution on test set for %s class from %s dataset.}\n', name, dataset);
    pr('\\label{fig1%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
end

if exist(fullfile(outdir(1:end-4), name, 'analysisI/plot_2.pdf'), 'file')
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig2%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 60mm, clip]{../%s/analysisI/plot_2.pdf}\n', name);
    pr('}\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig2%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 60mm, clip]{../%s/analysisI/plot_1.pdf}\n', name);
    pr('}\n');
    pr('\\caption{\\textbf{Analysis of the Main Pose Estimation Errors.} (a) Given the correct detections, pie chart shows the fraction of pose error that are due to Opposite viewpoints (Opposite), confusion with Nearby viewpoints (Nearby), confusion with Other rotations (Other), and correct pose estimations (Correct) for %s class. (b) Impact of pose errors in terms of %s. \\textcolor{blue}{Blue Bars} show the %s performance obtained when all estimations are considered. \\textcolor{green}{Green Bars} display the %s improvement by removing all estimations of one type: \\textbf{OTH} removes confusion with other rotation viewpoints;  \\textbf{NEAR} removes confusion with nearby viewpoints; \\textbf{OPP}  removes confusion with opposite viewpoints. \\textcolor{BrickRed}{Brick Red Bars} display the %s improvement by correcting all estimations of one type: \\textbf{OTH} corrects confusion with other rotation viewpoints; \\textbf{NEAR} corrects confusion with nearby viewpoints; \\textbf{OPP}  corrects confusion with opposite viewpoints.}\n', name, metric, metric, metric, metric);
    pr('\\label{fig2%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
end

if exist(fullfile(outdir(1:end-4), name, 'analysisI/plot_4.pdf'), 'file')
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\includegraphics[width=0.85\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisI/plot_4.pdf} \n', name);
    pr('\\caption{\\textbf{Success rate for %s class considering 8 views.} For each of the 8 viewpoints, we report: In \\textcolor{blue}{Blue}, the percentage of the correct pose estimations. In \\textcolor{cyan}{Cyan}, the percentage of confusion with the opposite viewpoints. In \\textcolor{yellow}{Yellow}, the percentage of confusion with nearby viewpoints. In \\textcolor{BrickRed}{Brick Red}, the percentage of the confusions with other rotations.}\n', name);
    
    pr('\\label{fig3%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
end

pr('\\clearpage')
pr('\n\n');
pr('Figure \\ref{fig4%s} summarizes the detection and pose estimation performances for %s class. Figure \\ref{fig4%sa} shows the model performance working on continuous pose estimation. For AVP and PEAP the results are obtained considering a threshold equal to $\\frac{\\pi}{12}$. Figures \\ref{fig4%sb} and \\ref{fig4%sc} report the AVP and PEAP performances achieve working on discrete pose estimation. The AVP and PEAP metrics are obtained considering different number of the views: 4, 8, 16 and 24.\n', name, name, name, name, name);

if exist(fullfile(outdir(1:end-4), name, 'analysisIII/curves/plot_1.pdf'), 'file')
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig4%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisIII/curves/plot_1.pdf} \n', name);
    pr('}\\\\ \n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig4%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisIII/curves/plot_2.pdf} \n', name);
    pr('}\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig4%sc}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisIII/curves/plot_3.pdf} \n', name);
    pr('}\n');
    pr('\\caption{\\textbf{Precision/Recall Curves.} (a) Performance working on continuous pose estimation. For AVP and PEAP the results are obtained considering a threshold equal to $\\frac{\\pi}{12}$. (b) AVP and (c) PEAP performances working on discrete pose estimation. Results obtained by considering 4, 8, 16, and 24 views.}\n');
    pr('\\label{fig4%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
end
pr('\\clearpage')
pr('\n\n');
pr('Figures \\ref{fig5%s}, \\ref{fig6%s}, \\ref{fig7%s}, \\ref{fig8%s} and \\ref{fig9%s} summarize the main object characteristic influences on detection and pose estimation performances for %s class. Figure \\ref{fig5%s} reports the effect of object size characteristic on object detection and pose estimation performances. Figure \\ref{fig6%s} shows the influence of aspect ratio characteristic on object detection and pose estimation performances. Figure \\ref{fig7%s} represents the influence of occluded and truncated objects on detection and pose estimation performances. Figure \\ref{fig8%s} shows the visible side influence. Figure \\ref{fig9%s} reports the part visibily effect. \n', name, name, name ,name, name, name, name, name, name, name, name);

if exist(fullfile(outdir(1:end-4), name, 'analysisII/obj_charact_detection/plot_2.pdf'), 'file')
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig5%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_detection/plot_2.pdf} \n', name);
    pr('}\n')
    pr('\\subfloat[]{\n');
    pr('\\label{fig5%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_5.pdf} \n', name);
    pr('}\n')
    pr('\\caption{\\textbf{Effect of Object Size Characteristic on Object Detection and Pose Estimation Performances.} (a) Detection analysis: AP variance. XS and S are considered EXTRA SMALL and SMALL objects, M are MEDIUM objects, L and XL are LARGE and EXTRA LARGE objects. (b) Pose Estimation Results in terms of %s. \\textcolor{blue}{Blue Bars} show the results when all pose estimations are considered, \\textcolor{green}{Green Bars} show the results when only the pose estimations corresponding this object size are considered and \\textcolor{BrickRed}{Brick Red Bars} display the results when the pose estimations corresponding this object size are removed.}\n', metric);
    pr('\\label{fig5%s}\n', name);
    pr('\\end{figure}\n');
    pr('\n\n');
end
if exist(fullfile(outdir(1:end-4), name, 'analysisII/obj_charact_detection/plot_3.pdf'), 'file')
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig6%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_detection/plot_3.pdf} \n', name);
    pr('}\n')
    pr('\\subfloat[]{\n');
    pr('\\label{fig6%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 20mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_6.pdf} \n', name);
    pr('}\n')
    pr('\\caption{\\textbf{Effect of Object Size Characteristic on Object Detection and Pose Estimation.} (a) Detection analysis: AP variance. XS and S are considered EXTRA SMALL and SMALL objects, M are MEDIUM objects, L and XL are LARGE and EXTRA LARGE objects. (b) Pose Estimation Results in terms of %s. \\textcolor{blue}{Blue Bars} show the results when all pose estimations are considered, \\textcolor{green}{Green Bars} show the results when only the pose estimations corresponding this object size are considered and \\textcolor{BrickRed}{Brick Red Bars} display the results when the pose estimations corresponding this object size are removed.}\n', metric);
    pr('\\label{fig6%s}\n', name);
    pr('\\end{figure}\n');
    pr('\n\n');
end
if exist(fullfile(outdir(1:end-4), name, 'analysisII/obj_charact_detection/plot_5.pdf'), 'file')
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig7%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_detection/plot_5.pdf} \n', name);
    pr('}\n')
    pr('\\subfloat[]{\n');
    pr('\\label{fig7%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_3.pdf} \n', name);
    pr('}\n')
    pr('\\caption{\\textbf{Effect of Occluded and Truncated Objects on Detection and Pose Estimation Performances.} (a) Detection analysis: AP variance.  N non occluded or truncated object, T/O truncated or occluded object. Results on Pose Estimation in terms of the %s metric. \\textcolor{blue}{Blue Bars} show the results when all pose estimations are considered. \\textcolor{green}{Green Bars} display the results when the occluded and truncated objects are removed. \\textcolor{BrickRed}{Brick Red Bars} show the performance when we are only considered the occluded and truncated objects.}\n', metric);
    pr('\\label{fig7%s}\n', name);
    pr('\\end{figure}\n');
    pr('\n\n');
end
if exist(fullfile(outdir(1:end-4), name, 'analysisII/obj_charact_detection/plot_8.pdf'), 'file')
    
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig8%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_detection/plot_8.pdf} \n', name);
    pr('}\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig8%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_2.pdf} \n', name);
    pr('}\n');
    pr('\\caption{\\textbf{Effect of Visible Sides on Object Detection and Pose Estimation Performances.} (a) Detection analysis: AP performance. Pose Estimation analysis: (b) Pose Estimation analysis: %s performance. Black dashed lines indicate overall.  Visible side: \\textbf{1} = performance when the side is visible; \\textbf{0} = performance when the side is not visible.}\n', metric);
    pr('\\label{fig8%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
end

if exist(fullfile(outdir(1:end-4), name, 'analysisII/obj_charact_detection/plot_7.pdf'), 'file')
    
    pr('\\begin{figure}[h]\n')
    pr('\\centering\n');
    pr('\\subfloat[]{\n');
    pr('\\label{fig9%sa}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_detection/plot_7.pdf} \n', name);
    pr('}\n')
    pr('\\subfloat[]{\n');
    pr('\\label{fig9%sb}\n', name);
    pr('\\includegraphics[width=0.45\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_1.pdf} \n', name);
    pr('}\n')
    pr('\\caption{\\textbf{Part Visibility Influence on Object Detection and Pose Estimation Performances.} (a) Detection analysis: AP performance. Pose Estimation analysis: (b) Pose Estimation analysis: %s performance. Black dashed lines indicate overall performance.  Visible part: \\textbf{1} = performance when the part is visible; \\textbf{0} = performance when the part is not visible. The correspondence between the part number and the part name is indicated at the beginning of this Section (see Statistics for %s class).}\n', metric, name);
    pr('\\label{fig9%s}\n', name);
    pr('\\end{figure}\n');
    
    pr('\n\n');
    
end

pr('\\clearpage')
pr('\n\n');
pr('Figure \\ref{fig10%s} provides a summary of the sensitivity to each characteristic and the potential impact on improving pose estimation robustness. The worst-performing and best-performing combinations for each object characteristic are averaged over the selected object categories. The difference between the best and the worst performance indicates sensitivity; the difference between the best and the overall indicates the potential impact.\n', name);

if strcmp(detector(length(detector)-1:length(detector)), 'gt')
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.65\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_7.pdf} \n', name);
    pr('\\caption{\\textbf{Summary of Sensitivity and Impact of Object Characteristics.} We show the performance of the highest performing and lowest performing subsets within each characteristic (occlusion/truncation (occ-trn), bounding box area or object size (size), aspect ratio (asp), visible sides (side) and part visibility (part)). Overall accuracy is indicated by the black dashed line. The difference between max and min indicates sensitivity; the difference between max and overall indicates the impact.\n');
    pr('}\n');
    pr('\\label{fig10%s}\n', name);
    pr('\\end{figure}\n');
else
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.85\\textwidth,trim = 10mm 65mm 25mm 65mm, clip]{../%s/analysisII/obj_charact_pose/plot_7.pdf} \n', name);
    pr('\\caption{\\textbf{Summary of Sensitivity and Impact of Object Characteristics.} We show the %s performance of the highest performing and lowest performing subsets within each characteristic (occlusion/truncation (occ-trn), difficult objects (diff), bounding box area or object size (size), aspect ratio (asp), visible sides (side) and part visibility (part)). Overall accuracy is indicated by the black dashed line. The difference between max and min indicates sensitivity; the difference between max and overall indicates the impact.\n', metric);
    pr('}\n');
    pr('\\label{fig10%s}\n', name);
    pr('\\end{figure}\n');
end
pr('\\clearpage\n');

if exist(fullfile(outdir(1:end-4), name, 'analysisIII/ov_analysis/plot_1.pdf'), 'file')
    pr('Figure \\ref{fig11%s} shows an analysis of the influence of the overlap criterion considering the %s metric. For this overlap criterion analysis we follow the PASCAL VOC formulation: to be considered a true positive, the area of overlap between the predicted BB and GT BB must exceed a threshold.\n', name, metric);
    pr('\\begin{figure}[h]\n');
    pr('\\centering\n');
    pr('\\includegraphics[width=0.85\\textwidth,trim = 15mm 65mm 25mm 65mm, clip]{../%s/analysisIII/ov_analysis/plot_1.pdf} \n', name);
    pr('\\caption{\\textbf{Simultaneous Object Detection and Pose Estimation.} The detection performance (AP) is represented in red and the pose estimation performance (%s) in blue.\n', metric);
    pr('}\n');
    pr('\\label{fig11%s}\n', name);
    pr('\\end{figure}\n');
end

pr('\\clearpage\n');
fclose(fid);




function pr(varargin)
global fid;
fprintf(fid, varargin{:});
