function  showQualitative(imdir, rec, result)
%  showQualitative(imdir, rec, result)
%
%
% Input:
%   imdir: the directory of images
%   rec: the PASCAL annotations structure
%   result: output of the analyzeTrueDetections function

for o = 1:numel(result)
    gt = result(o).gt;
    pn = gt.pn;
    
    predpn = zeros(size(pn));
    
    attributes = zeros(gt.N, 4);
    keep = true(gt.N, 1);
    for k = 1:gt.N
        if rec(gt.rnum(k)).objects(gt.onum(k)).difficult,
            keep(k) = false;
            continue;
        end;
        attributes(k, :) = [result(o).occ(gt.occ_level(k)).apn  ...
            result(o).truncated(gt.truncated(k)+1).apn ...
            result(o).area(gt.area(k)).apn  ...
            result(o).aspect(gt.aspect(k)).apn];
        
    end
    
    w = robustfit(attributes(keep, :), pn(keep));
    disp(num2str(w'))
    predpn = attributes*w(2:end) + w(1);
    
    diffpn = predpn-pn;
    si=[];
    [sv, si] = sort(result.det.conf, 'descend');
    det.bbox = result.det.bbox(si, :);
    det.conf = result.det.conf(si);
    det.rnum = result.det.rnum(si);
    det.view = result.det.view(si, :);
    c=1;
    mkdir([result.resultdir,'/', result.name, '/qualitative/bad_opp']);
    mkdir([result.resultdir,'/', result.name, '/qualitative/bad_nearby']);
    mkdir([result.resultdir,'/', result.name, '/qualitative/bad_other']);
    mkdir([result.resultdir,'/', result.name, '/qualitative/good']);
    for k = 1:length(result.det.conf)
        if result.gt.isdiff(result.det.gtnum(si(k))), continue; end;
        im = imread(fullfile(imdir, rec(result.det.rnum(si(k))).filename));
        bbox = result.det.bbox(si(k),:);
        view = result.det.view(si(k),:);
        h=figure(1), hold off, imagesc(im); axis image, axis off;
        hold on, plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'b', 'linewidth', 6);
        
        bboxgt = result.gt.bbox(result.det.gtnum(si(k)), :);
        hold on, plot(bboxgt([1 1 3 3 1]), bboxgt([2 4 4 2 2]), 'g--', 'linewidth', 6);
        
        %Arrow
        vx=[0 0 10 0 -10];
        vy=[0 70 40 70 40];
        %Rotate arrow
        vec=[vx;vy];
        B=[cosd((view(1))) -sind((view(1)));sind((view(1))) cosd((view(1)))];
        vecR=B*vec;
        xVec=bbox(1) + round((bbox(3)-bbox(1))/2) + (vecR(1,:));
        yVec=bbox(2) + round((bbox(4)-bbox(2))/2) + (vecR(2,:));
        gtB=[cosd((result.gt.viewpoint(result.det.gtnum(si(k))).azimuth)) ...
            -sind((result.gt.viewpoint(result.det.gtnum(si(k))).azimuth));...
            sind((result.gt.viewpoint(result.det.gtnum(si(k))).azimuth)) ...
            cosd((result.gt.viewpoint(result.det.gtnum(si(k))).azimuth))];
        gtvecR=gtB*vec;
        gtxVec=bbox(1) + round((bbox(3)-bbox(1))/2) + gtvecR(1,:);
        gtyVec=bbox(2) + round((bbox(4)-bbox(2))/2) + gtvecR(2,:);
        plot(gtxVec,gtyVec, 'g', 'linewidth', 8);
        text(bbox(1)+3, bbox(2)+45, ...
            sprintf('%0.3f',result.gt.viewpoint(result.det.gtnum(si(k))).azimuth), ...
            'backgroundcolor', [0 1 0], 'fontsize', 14, 'FontWeight', 'bold');
        
        error_azimuth = min(mod(view(1)-result.gt.viewpoint(result.det.gtnum(si(k))).azimuth,360), ...
            mod(result.gt.viewpoint(result.det.gtnum(si(k))).azimuth-view(1),360));
        flag = 0;
        if(error_azimuth <= 15)
            text(bbox(1)+3, bbox(2)+85, sprintf('%d',view(1)), ...
                'backgroundcolor', [1 1 1], 'color', [0 0 1], 'fontsize', 14, 'FontWeight', 'bold');
            plot(xVec,yVec, 'b', 'linewidth', 8);
            outDir = [result.resultdir,'/', result.name, ...
                '/qualitative/good/', num2str(c), '_', rec(gt.rnum(si(k))).filename, '.pdf'];
            saveas(h,outDir);
            flag = 1;
        end
        if(error_azimuth >165)
            text(bbox(1)+3, bbox(2)+85, sprintf('%d',view(1)), ...
                'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
            plot(xVec,yVec, 'r', 'linewidth', 8);
            outDir = [result.resultdir,'/', result.name, ...
                '/qualitative/bad_opp/', num2str(c), '_', rec(gt.rnum(si(k))).filename, '.pdf'];
            saveas(h,outDir);
            flag = 1;
        end
        if(error_azimuth >15 && error_azimuth < 30)
            text(bbox(1)+3, bbox(2)+85, sprintf('%d',view(1)), ...
                'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
            plot(xVec,yVec, 'r', 'linewidth', 8);
            outDir = [result.resultdir,'/', result.name, ...
                '/qualitative/bad_nearby/', num2str(c), '_', rec(gt.rnum(si(k))).filename, '.pdf'];
            saveas(h,outDir);
            flag = 1;
        end
        if(flag == 0)
            text(bbox(1)+3, bbox(2)+85, sprintf('%d',view(1)), ...
                'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
            plot(xVec,yVec, 'r', 'linewidth', 8);
            outDir = [result.resultdir,'/', result.name, ...
                '/qualitative/bad_other/', num2str(c), '_', rec(gt.rnum(si(k))).filename, '.pdf'];
            saveas(h,outDir);
        end
        c=c+1;
    end
    
end


function att = gt2attributes(gt)

att = [];
fnames = {'area', 'aspect', 'occ_level', 'truncated', 'part', 'side', 'height'};
for f = 1:numel(fnames)
    if ~isstruct(fnames{f})
        na = max(gt.(fnames{f}));
        att(:, end+(1:na)) = repmat(gt.(fnames{f}), [1 na])==repmat(1:na, [gt.N 1]);
    else
        fnames2 = fieldnames(gt.(fnames{f}));
        for k = 1:numel(fnames2)
            na = max(gt.(fnames{f}).(fnames2{k}));
            att(:, end+(1:na)) = repmat(gt.(fnames{f}).(fnames2{k}), [1 na])==repmat(1:na, [gt.N 1]);
        end
    end
end