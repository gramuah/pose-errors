function writeTexHeader(outdir, detname)

ch = sprintf('%c', '%');
if ~exist(outdir, 'file'), mkdir(outdir); end;
global fid
fid = fopen(fullfile(outdir, ['header.tex']), 'w');

pr('\\section{Information}\n');
pr('\\label{info}')
pr('The \\textbf{%s} detector is analyzed. This is an automatically generated report.\n\n', detname);
pr('Our diagnostic tool analyzes the frequency and impact of different types of false positives, and the infuence on the performance  of the main object characteristics. Analyzing the different types of false pose estimations of the methods, we can gather very interesting information to improve them. Since it is difficult to characterize the error modes for generic rotations, we restrict our analysis to only the predicted azimuth. We discretize the azimuth angle into $K$ bins, such that the bin centers have an equidistant spacing of $\\frac{2\\pi}{K}$. For our evaluations we set $K=24$. Thus, we define the following types of error modes. \\textit{Opposite viewpoint error}, which measures the efect of flipped estimates (\\textit{e.g}. confusion between frontal and rear views of a car). \\textit{Nearby viewpoint errors}. Nearby pose bins are confused due to they are very correlated in terms of appearance. Finally, the \\textit{Other rotation errors}, which include the rest of false positives. \n\n We also provide the success rate for each pose estimator considering 8 viewpoints: F: frontal. F-L: frontal-left. L: Left. L-RE: left-rear. RE: rear. RE-R: rear-right. R: right. R-F: right-frontal.\n\n');
pr('With respect to the impact of the main object characteristic, the following characteristic are considered in our study: occlusion/truncation, which indicates whether the object is occluded/truncated or not; object size and aspect ratio, which organizes the objects in different sets, depending on their size or aspect ratio; visible sides, which indicates if the object is in frontal, rear or side view position; and part visibility, which marks whether a 3D part is visible or not. For the object size, we measure the pixel area of the bounding box. We assign each object to a size category, depending on the object percentile size within its object category: extra-small (XS: bottom 10$\\%c$); small (S: next 20$\\%c$); large (L: next 80$\\%c$); extra-large (XL: next 100$\\%c$). Likewise, for the aspect ratio, objects are categorized into extra-tall (XT), tall (T), wide (W), and extra-wide (XW), using the same percentiles.\n', ch, ch, ch, ch);

fclose(fid);



function pr(varargin)
global fid;
fprintf(fid, varargin{:});
