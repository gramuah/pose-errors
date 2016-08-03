function rand_detections()

detectionDir = '/home/carolina/projects/pose-estimation/eccv2016/eval_code/detections';
outDir = [detectionDir, '/rand/'];
mkdir(outDir);
classes = {'aeroplane', 'bicycle', 'boat', 'bus', 'car', ...
       'chair', 'diningtable', 'motorbike', 'sofa', 'train', 'tvmonitor'};

for c = 1:length(classes)

    [img score bb1 bb2 bb3 bb4 az ze] = textread([detectionDir, '/bhf-gt/BHF_PASCAL3D_',classes{c},'_det.txt'],...
        '%s %f %f %f %f %f %d %d');
    fid = fopen([outDir,'/RAND_PASCAL3D_',classes{c},'_det.txt'], 'w');
    for i=1:length(score)
        az_rand = round(360*rand(1,1));
        ze_rand = round(180*rand(1,1));
        sc_rand = rand(1,1);
        fprintf(fid, '%s %f %f %f %f %f %d %d\n', img{i}, sc_rand, ...
            bb1(i), bb2(i), bb3(i), bb4(i), az_rand, ze_rand);
    end
    
end