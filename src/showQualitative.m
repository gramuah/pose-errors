function showQualitative(imdir, rec, result)
% showSurprisingMisses(imdir, rec, gt)
% 
% Sorts objects by their normalized precision, minus the average of the
% average normalized precision for their characteristics.  For example, a
% medium-sized side-view of an airplane is likely to have a high APn.  
%
% Input:
%   imdir: the directory of images
%   rec: the PASCAL annotations structure
%   result: output of the analyzeTrueDetections function

for o = 1:numel(result)
  gt = result(o).gt;
  pn = gt.pn;
  
  si=[];
  [sv, si] = sort(result.det.conf, 'descend');
  det.bbox = result.det.bbox(si, :);
  det.conf = result.det.conf(si);
  det.rnum = result.det.rnum(si);
  det.view = result.det.view(si, :);
  det.labels = result.pose.labels(si, :);
  det.duplicate = result.pose.isduplicate(si, :);
  c=1;
  mkdir([result.resultdir, '/', result.name,'/qualitative/true_det/bad_opp']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/true_det/bad_nearby']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/true_det/bad_other']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/true_det/good']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/false_det/ov_criterion']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/false_det/duplicate']);
  mkdir([result.resultdir, '/', result.name,'/qualitative/diff_det']);
  for k = 1:length(result.det.conf)
%       if k == 122 
%           disp('db')
%       end
%       if k == 72 
%           disp('db')
%       end
      if result.det.gtnum(si(k)) ~= 0 
          if det.labels(k) == 1
           
              im = imread(fullfile(imdir, rec(result.det.rnum(si(k))).filename));
              bbox = result.det.bbox(si(k),:);
              view = result.det.view(si(k),:);
              h=figure(1); hold off, imagesc(im); axis image, axis off;
              hold on, plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'b', 'linewidth', 6);  
            
              bboxgt = result.gt.bbox(result.det.gtnum(si(k)), :);
              hold on, plot(bboxgt([1 1 3 3 1]), bboxgt([2 4 4 2 2]), 'g--', 'linewidth', 6);
    
    %Arrow
%     vx=[(bbox(1) + round((bbox(3)-bbox(1))/2) + 0) (bbox(1) + round((bbox(3)-bbox(1))/2) + 0) ...
%         (bbox(1) + round((bbox(3)-bbox(1))/2) + 10) (bbox(1) + round((bbox(3)-bbox(1))/2) + 0) ...
%         (bbox(1) + round((bbox(3)-bbox(1))/2) - 10)];
%     vy=[(bbox(2) + round((bbox(4)-bbox(2))/2) + 0) (bbox(2) + round((bbox(4)-bbox(2))/2) + 70) ...
%         (bbox(2) + round((bbox(4)-bbox(2))/2) + 40) (bbox(2) + round((bbox(4)-bbox(2))/2) + 70) ...
%         (bbox(2) + round((bbox(4)-bbox(2))/2) + 40)];
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
              text(bbox(1)+3, bbox(2)+45, sprintf('%0.3f',result.gt.viewpoint(result.det.gtnum(si(k))).azimuth), 'backgroundcolor', [0 1 0], 'fontsize', 14, 'FontWeight', 'bold');
    
              error_azimuth = min(mod(view(1)-result.gt.viewpoint(result.det.gtnum(si(k))).azimuth,360), ...
                mod(result.gt.viewpoint(result.det.gtnum(si(k))).azimuth-view(1),360));
              flag = 0;
              if(error_azimuth <= 15)
                    text(bbox(1)+3, bbox(2)+85, sprintf('%0.3f',view(1)), 'backgroundcolor', [1 1 1], 'color', [0 0 1], 'fontsize', 14, 'FontWeight', 'bold');
                    plot(xVec,yVec, 'b', 'linewidth', 8);
                    outDir = [result.resultdir, '/', result.name, '/qualitative/true_det/good/', ...
                        num2str(c), '_', rec(det.rnum(k)).filename, '.pdf'];
                    saveas(h,outDir);
                    flag = 1;
              end
              if(error_azimuth >165)
                    text(bbox(1)+3, bbox(2)+85, sprintf('%0.3f',view(1)), 'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
                    plot(xVec,yVec, 'r', 'linewidth', 8);
                    outDir = [result.resultdir, '/', result.name, '/qualitative/true_det/bad_opp/',...
                        num2str(c), '_', rec(det.rnum(k)).filename, '.pdf'];
                    saveas(h,outDir);
                    flag = 1;
              end
              if(error_azimuth >15 && error_azimuth < 30)
                    text(bbox(1)+3, bbox(2)+85, sprintf('%0.3f',view(1)), 'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
                    plot(xVec,yVec, 'r', 'linewidth', 8);
                    outDir = [result.resultdir, '/', result.name, '/qualitative/true_det/bad_nearby/',...
                        num2str(c), '_', rec(det.rnum(k)).filename, '.pdf'];
                    saveas(h,outDir);
                    flag = 1;
              end
              if(flag == 0)
                    text(bbox(1)+3, bbox(2)+85, sprintf('%0.3f',view(1)), 'backgroundcolor', [1 0 0], 'fontsize', 14, 'FontWeight', 'bold');
                    plot(xVec,yVec, 'r', 'linewidth', 8);
                    outDir = [result.resultdir, '/', result.name, '/qualitative/true_det/bad_other/', ...
                        num2str(c), '_', rec(det.rnum(k)).filename, '.pdf'];
                    saveas(h,outDir);
              end
            
          end
          if (det.labels(k) == -1) && (det.duplicate(k) == 1)
              
             
              im = imread(fullfile(imdir, rec(result.det.rnum(si(k))).filename));
              bbox = result.det.bbox(si(k),:);
              view = result.det.view(si(k),:);
              h=figure(1); hold off, imagesc(im); axis image, axis off;
              hold on, plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'b', 'linewidth', 6);
              bboxgt = result.gt.bbox(result.det.gtnum(si(k)), :);
              hold on, plot(bboxgt([1 1 3 3 1]), bboxgt([2 4 4 2 2]), 'g--', 'linewidth', 6);
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
              text(bbox(1)+3, bbox(2)+45, sprintf('%0.3f',result.gt.viewpoint(result.det.gtnum(si(k))).azimuth), 'backgroundcolor', [0 1 0], 'fontsize', 14, 'FontWeight', 'bold');
              text(bbox(1)+3, bbox(2)+85, sprintf('%0.3f',view(1)), 'backgroundcolor', [1 1 1], 'color', [0 0 1], 'fontsize', 14, 'FontWeight', 'bold');
              plot(xVec,yVec, 'b', 'linewidth', 8);
              
              outDir = [result.resultdir, '/', result.name, '/qualitative/false_det/duplicate/', num2str(c), '_', ...
                rec(det.rnum(k)).filename, '.pdf'];
              saveas(h,outDir);
          end
          if (det.labels(k) == -1) && (det.duplicate(k) == 0)
            im = imread(fullfile(imdir, rec(result.det.rnum(si(k))).filename));
            bbox = result.det.bbox(si(k),:);
            view = result.det.view(si(k),:);
            h=figure(1); hold off, imagesc(im); axis image, axis off;
            hold on, plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'b', 'linewidth', 6);
            bboxgt = result.gt.bbox(result.det.gtnum(si(k)), :);
            hold on, plot(bboxgt([1 1 3 3 1]), bboxgt([2 4 4 2 2]), 'g--', 'linewidth', 6);
            outDir = [result.resultdir, '/', result.name, '/qualitative/false_det/ov_criterion/', num2str(c), '_', ...
                rec(det.rnum(k)).filename, '.pdf'];
            saveas(h,outDir);
          end
          if det.labels(k) == 0
                im = imread(fullfile(imdir, rec(result.det.rnum(si(k))).filename));
                bbox = result.det.bbox(si(k),:);
                h=figure(1); hold off, imagesc(im); axis image, axis off;
                hold on, plot(bbox([1 1 3 3 1]), bbox([2 4 4 2 2]), 'b', 'linewidth', 6);
                bboxgt = result.gt.bbox(result.det.gtnum(si(k)), :);
                hold on, plot(bboxgt([1 1 3 3 1]), bboxgt([2 4 4 2 2]), 'g--', 'linewidth', 6);
                outDir = [result.resultdir, '/', result.name, '/qualitative/diff_det/', num2str(c), '_', ...
                    rec(det.rnum(k)).filename, '.pdf'];
                saveas(h,outDir);
          end
          c=c+1;
      end
  end
  
end

