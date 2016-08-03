function ann = readDatasetAnnotations(dataset, dataset_params)
% ann = readDatasetAnnotations(dataset, dataset_params)
%
% Dataset-specific function to read and process annotations

switch dataset
   
  case 'PASCAL3D+'
      
      outfn = fullfile(dataset_params.annotationdir, ...
          sprintf('%s_annotations_%s_all.mat', dataset_params.VOCset, dataset_params.imset));
        
        
      load(outfn, 'ann');
      for o = 1:length(ann.gt)
          viewcountvector = zeros(1,8);
          viewcountvector_wodiff = zeros(1,8);
          ab=1;
          for j=1:ann.gt(o).N
            if ann.gt(o).viewpoint(j).azimuth ~= 0      
                if ann.gt(o).viewpoint(j).azimuth <= 25 || ann.gt(o).viewpoint(j).azimuth > 340
                    viewcountvector(1) = viewcountvector(1) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(1) = viewcountvector_wodiff(1) + 1;
                        idsdb(ab) = j;
                        ab = ab+1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 70 && ann.gt(o).viewpoint(j).azimuth > 25
                    viewcountvector(2) = viewcountvector(2) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(2) = viewcountvector_wodiff(2) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 115 && ann.gt(o).viewpoint(j).azimuth > 70
                    viewcountvector(3) = viewcountvector(3) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(3) = viewcountvector_wodiff(3) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 160 && ann.gt(o).viewpoint(j).azimuth > 115
                    viewcountvector(4) = viewcountvector(4) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(4) = viewcountvector_wodiff(4) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 205 && ann.gt(o).viewpoint(j).azimuth > 160
                    viewcountvector(5) = viewcountvector(5) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(5) = viewcountvector_wodiff(5) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 250 && ann.gt(o).viewpoint(j).azimuth > 205
                    viewcountvector(6) = viewcountvector(6) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(6) = viewcountvector_wodiff(6) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 295 && ann.gt(o).viewpoint(j).azimuth > 250
                    viewcountvector(7) = viewcountvector(7) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(7) = viewcountvector_wodiff(7) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth <= 340 && ann.gt(o).viewpoint(j).azimuth > 295
                    viewcountvector(8) = viewcountvector(8) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(8) = viewcountvector_wodiff(8) + 1;
                    end
                end
            else
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 25 || ann.gt(o).viewpoint(j).azimuth_coarse > 340
                    viewcountvector(1) = viewcountvector(1) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(1) = viewcountvector_wodiff(1) + 1;
                        idsdb(ab) = j;
                        ab = ab+1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 70 && ann.gt(o).viewpoint(j).azimuth_coarse > 25
                    viewcountvector(2) = viewcountvector(2) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(2) = viewcountvector_wodiff(2) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 115 && ann.gt(o).viewpoint(j).azimuth_coarse > 70
                    viewcountvector(3) = viewcountvector(3) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(3) = viewcountvector_wodiff(3) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 160 && ann.gt(o).viewpoint(j).azimuth_coarse > 115
                    viewcountvector(4) = viewcountvector(4) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(4) = viewcountvector_wodiff(4) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 205 && ann.gt(o).viewpoint(j).azimuth_coarse > 160
                    viewcountvector(5) = viewcountvector(5) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(5) = viewcountvector_wodiff(5) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 250 && ann.gt(o).viewpoint(j).azimuth_coarse > 205
                    viewcountvector(6) = viewcountvector(6) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(6) = viewcountvector_wodiff(6) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 295 && ann.gt(o).viewpoint(j).azimuth_coarse > 250
                    viewcountvector(7) = viewcountvector(7) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(7) = viewcountvector_wodiff(7) + 1;
                    end
                end
                if ann.gt(o).viewpoint(j).azimuth_coarse <= 340 && ann.gt(o).viewpoint(j).azimuth_coarse > 295
                    viewcountvector(8) = viewcountvector(8) + 1;
                    if ann.gt(o).isdiff(j) == 0
                        viewcountvector_wodiff(8) = viewcountvector_wodiff(8) + 1;
                    end
                end
        
            end
          end
          ann.gt(o).gtviewvector = viewcountvector;
          ann.gt(o).gtviewvector_wodiff = viewcountvector_wodiff;
          ann.gt(o).idsdb = idsdb;
      end
   
   otherwise 
    error('dataset %s is unknown\n', dataset);
end