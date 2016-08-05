% poseEstimationAnalysisScript (main script)

% type of dataset
dataset = 'PASCAL3D+';

SKIP_SAVED_FILES = 0; % set true to not overwrite any analysis results
SAVE_QUALITATIVE = 0; % set true to save qualitative results
SHOW_FIGURES = 0;     % set true to show plots
DO_TEX = 1; % set true to realize and save info report
DO_OVERLAP_CRITERIA_ANALYSIS = 1; % set true to do overlap analysis
SAVE_SUMMARY = 1; % set true to save a txt file with the main results 

% specify which pose estimators and detectors to evaluate
full_set = {'rand-gt', 'bhf', 'bhf-gt', 'vdpm','vdpm-gt', 'vpskps', 'vpskps-gt', '3ddpm'};
detectors = {'bhf'}; % detectors to analyze

dataset_params = setDatasetParameters(dataset);
objnames_all = dataset_params.objnames_all;

 % objects to analyze (could be a subset)
objnames_selected  =  {'aeroplane', 'bicycle', 'boat', 'bus', 'car', ...
    'chair', 'diningtable', 'motorbike', 'sofa', 'train', 'tvmonitor'};

tp_display_localization = 'strong'; % set to 'weak' to do analysis with a high localization error
flag_diningtable = 0;

%% Metric type:
% 1: AOS;
% 2: AVP;
% 3: PEAP;
% 4: MAE;
% 5: MedError;
metric_type = 2;

set(0,'DefaultFigureVisible','on')
if ~SHOW_FIGURES
    set(0,'DefaultFigureVisible','off')
end

for d = 1:numel(detectors)  % loops through each detector and performs analysis
    
    detector = detectors{d};
    fprintf('\nEvaluating pose estimator: %s\n\n', detector);
    
    % sets detector paths, may need to be modified for your detector
    [dataset_params.detpath, resultdir, detname] = setDetectorInfo(detector);
    if ~exist(resultdir, 'file'), mkdir(resultdir); end;
    
    % reads the records, attaches annotations: requires modification if not
    % using PASCAL3D+
    ann = readDatasetAnnotations(dataset, dataset_params);
    outdir = resultdir;
    resulttotal = struct([]);
    %% For each selected object --> Object Characteristic Analysis
    for o = 1:numel(objnames_selected)
        
        objname = objnames_selected{o};
        if ~exist(fullfile(outdir, sprintf('%s', objname)));
            mkdir(fullfile(outdir, sprintf('%s', objname)))
        end
        outfile = fullfile(outdir, sprintf('%s/results_%s_%s.mat', objname, objname, ...
            tp_display_localization));
        if ~exist(outfile, 'file') || ~SKIP_SAVED_FILES
            
            fprintf('Object Characteristic Analysis: %s\n', objname);
            
            % Read Detections
            det = readDetections(dataset, dataset_params, ann, objname);
            outdir = resultdir;
            if ~exist(outdir, 'file'), mkdir(outdir); end;
            
            if ~exist(outfile, 'file') || ~SKIP_SAVED_FILES
                result = analyzeDetections(dataset, dataset_params, objname, det, ann, ...
                    tp_display_localization);
                save(fullfile(outdir, sprintf('%s/results_I_%s_%s.mat', objname, objname, ...
                    tp_display_localization)), 'result', '-v7.3');
                clear result;
            end
        end
    end
    
    fprintf('\n\n');
    %% For each selected object --> Pose Error Analysis (False Positive Study)
    
    for o = 1:numel(objnames_selected)
        
        objname = objnames_selected{o};
        if strcmp(objname, 'diningtable')
            flag_diningtable = 1;
        end
        outfile = fullfile(outdir, sprintf('%s/results_II_%s_%s', objname, objname, ...
            tp_display_localization));
        if ~exist(outfile, 'file') || ~SKIP_SAVED_FILES
            o_ind = find(strcmp(objnames_all, objname));
            
            % Read Detections
            det = readDetections(dataset, dataset_params, ann, objname);
            
            if ~exist(outdir, 'file'), mkdir(outdir); end;
            
            fprintf('Pose Error Analysis (False Positive Study): %s\n', objname);
            
            if ~exist(outfile, 'file') || ~SKIP_SAVED_FILES
                [result_fp, resultclass] = analyzePoseError(dataset, dataset_params, ann, o_ind, det, ...
                    tp_display_localization);
                resulttotal(o).obj = resultclass.obj;
                resulttotal(o).err  = resultclass.err;
                result_fp.name = objname;
                result_fp.o = o_ind;
                save(outfile, 'result_fp', '-v7.3');
                clear result_fp;
            end
            
        end
    end
    
    %% Create plots and .txt files for the analysis
    localization = tp_display_localization;
    
    for o = 1:numel(objnames_selected)
        fprintf('\n\nObtaining result for the class: %s\n', objnames_selected{o});
        clear result;
        fprintf('%s\n', objnames_selected{o})
        tmp = load(fullfile(resultdir, sprintf('%s/results_I_%s_%s.mat', objnames_selected{o}, ...
            objnames_selected{o}, localization)));
        result(1) = tmp.result;
        
        clear result_fp;
        objname = objnames_selected{o};
        tmp = load(fullfile(resultdir, sprintf('%s/results_II_%s_%s.mat', objname, objname, localization)));
        result_fp(1) = tmp.result_fp;
        
        %% Analysis I (False Positive & Metrics)
        mkdir(fullfile(resultdir, sprintf('%s/analysisI/', objnames_selected{o})));
        [resultclass,Nfig] = displayPoseErrorAnalysisPlots(result_fp, result, metric_type);
        
        resulttotal(o).correct = resultclass.correct;
        resulttotal(o).opp = resultclass.opp;
        resulttotal(o).nearby = resultclass.nearby;
        resulttotal(o).oth = resultclass.oth;
        resulttotal(o).avp = resultclass.avp;
        resulttotal(o).hist_result = resultclass.hist_result;
        resulttotal(o).hist_opp_result = resultclass.hist_opp_result;
        resulttotal(o).hist_near_result = resultclass.hist_near_result;
        resulttotal(o).hist_oth_result = resultclass.hist_oth_result;
        resulttotal(o).ignore_OPP_aos = resultclass.ignore_OPP_aos;
        resulttotal(o).correct_OPP_aos = resultclass.correct_OPP_aos;
        resulttotal(o).ignore_NEAR_aos = resultclass.ignore_NEAR_aos;
        resulttotal(o).correct_NEAR_aos = resultclass.correct_NEAR_aos;
        resulttotal(o).ignore_OTH_aos = resultclass.ignore_OTH_aos;
        resulttotal(o).correct_OTH_aos = resultclass.correct_OTH_aos;
        resulttotal(o).ignore_OPP_avp = resultclass.ignore_OPP_avp;
        resulttotal(o).correct_OPP_avp = resultclass.correct_OPP_avp;
        resulttotal(o).ignore_NEAR_avp = resultclass.ignore_NEAR_avp;
        resulttotal(o).correct_NEAR_avp = resultclass.correct_NEAR_avp;
        resulttotal(o).ignore_OTH_avp = resultclass.ignore_OTH_avp;
        resulttotal(o).correct_OTH_avp = resultclass.correct_OTH_avp;
        resulttotal(o).ignore_OPP_peap = resultclass.ignore_OPP_peap;
        resulttotal(o).correct_OPP_peap = resultclass.correct_OPP_peap;
        resulttotal(o).ignore_NEAR_peap = resultclass.ignore_NEAR_peap;
        resulttotal(o).correct_NEAR_peap = resultclass.correct_NEAR_peap;
        resulttotal(o).ignore_OTH_peap = resultclass.ignore_OTH_peap;
        resulttotal(o).correct_OTH_peap = resultclass.correct_OTH_peap;
        resulttotal(o).ignore_OPP_mae = resultclass.ignore_OPP_mae;
        resulttotal(o).correct_OPP_mae = resultclass.correct_OPP_mae;
        resulttotal(o).ignore_NEAR_mae = resultclass.ignore_NEAR_mae;
        resulttotal(o).correct_NEAR_mae = resultclass.correct_NEAR_mae;
        resulttotal(o).ignore_OTH_mae = resultclass.ignore_OTH_mae;
        resulttotal(o).correct_OTH_mae = resultclass.correct_OTH_mae;
        resulttotal(o).ignore_OPP_MedError = resultclass.ignore_OPP_MedError;
        resulttotal(o).correct_OPP_MedError = resultclass.correct_OPP_MedError;
        resulttotal(o).ignore_NEAR_MedError = resultclass.ignore_NEAR_MedError;
        resulttotal(o).correct_NEAR_MedError = resultclass.correct_NEAR_MedError;
        resulttotal(o).ignore_OTH_MedError = resultclass.ignore_OTH_MedError;
        resulttotal(o).correct_OTH_MedError = resultclass.correct_OTH_MedError;
        
        % Save plots:
        % Fig. 1 Pose Error Analysis: AOS if metric_type = 1, AVP if metric_type = 2, PEAP if metric_type = 3,
        % MAE if metric_type = 4, and MedError if metric_type = 5;
        % Fig. 2 Pie Chart.
        % Fig. 3 Pose Distrib.
        % Fig. 4 Success Rate;
        for f = 1:Nfig
            print('-dpdf', ['-f' num2str(f)], ...
                fullfile(resultdir, sprintf('%s/analysisI/plot_%d.pdf', objnames_selected{o},f)));
        end
        
        %% Analysis II (Object Characteristics: Detection & Pose Estimation Analysis)
        mkdir(fullfile(resultdir, sprintf('%s/analysisII/obj_charact_detection/', objnames_selected{o})));
        mkdir(fullfile(resultdir, sprintf('%s/analysisII/obj_charact_pose/', objnames_selected{o})));
        
        %% Obj.Characteristcs on Detection
        [resutclass,Nfig] = displayPerCharacteristicDetPlots(result, metric_type);
        resulttotal(o).side_1 = resutclass.side_1;
        resulttotal(o).side_2 = resutclass.side_2;
        
        % Save plots
        % Detection Analysis:
        % Obj. Characteristics:
        % Fig. 1 Occluded Objects;
        % Fig. 2 Obj. Size Analysis;
        % Fig. 3 Aspect Ratio Analysis;
        % Fig. 4 Truncated Objects;
        % Fig 5 Trunc/Occ. Objects;
        % Fig 6 Diff. Objects;
        % Fig. 7 Visible part effect;
        % Fig. 8 Visible side influence;
        for f = 1:Nfig-2
            print('-dpdf', ['-f' num2str(f)], ...
                fullfile(resultdir, sprintf('%s/analysisII/obj_charact_detection/plot_%d.pdf', ...
                objnames_selected{o}, f)));
        end
        
        % Save plots
        % Pose Analysis:
        % Obj. Characteristics:
        % Fig. 10 Visible part effect;
        % Fig. 11 Visible side influence;
        save_aux = 1;
        for f = Nfig-1:Nfig
            print('-dpdf', ['-f' num2str(f)], ...
                fullfile(resultdir, sprintf('%s/analysisII/obj_charact_pose/plot_%d.pdf', ...
                objnames_selected{o}, save_aux)));
            save_aux = save_aux + 1;
        end
        close all;
        
        %% Obj.Characteristcs on Pose Estimation and Summary
        [resultclass, Nfig] = displayPerCharacteristicPosePlots(result_fp, result,detector, metric_type);
        resulttotal(o).ap = resultclass.ap;
        resulttotal(o).aos = resultclass.aos;
        resulttotal(o).avp = resultclass.avp;
        resulttotal(o).peap = resultclass.peap;
        resulttotal(o).mae = resultclass.MAE;
        resulttotal(o).MedError = resultclass.MedError;
        resulttotal(o).extrasmall = resultclass.extrasmall;
        resulttotal(o).small = resultclass.small;
        resulttotal(o).large = resultclass.large;
        resulttotal(o).extralarge = resultclass.extralarge;
        resulttotal(o).extratall = resultclass.extratall;
        resulttotal(o).tall = resultclass.tall;
        resulttotal(o).wide = resultclass.wide;
        resulttotal(o).extrawide = resultclass.extrawide;
        for mx = 1:length(resultclass.maxval)
            resulttotal(o).maxval(mx) = resultclass.maxval(mx);
            resulttotal(o).minval(mx) = resultclass.minval(mx);
        end
        
        % Save plots
        % Pose Estimation Analysis:
        % Obj. Characteristics:
        % Fig. 3 Trunc/Occ. Objects;.
        % Fig. 4 Diff. Objects;
        % Fig. 5 Obj. Size Analysis;
        % Fig. 6 Aspect Ratio Analysis;
        % Fig. 7 Summary of Sensitivity and Impact;
        for f = 1:Nfig
            print('-dpdf', ['-f' num2str(f)], ...
                fullfile(resultdir, sprintf('%s/analysisII/obj_charact_pose/plot_%d.pdf', ...
                objnames_selected{o}, f+save_aux-1)));
        end
        
        %% Analysis III (Precision/Recall Curves)
        mkdir(fullfile(resultdir, sprintf('%s/analysisIII/curves/', objnames_selected{o})));
        [Nfig, avp_views, peap_views] = displayPrecRecPlots(result_fp, result);
        resulttotal(o).avp_views = avp_views;
        resulttotal(o).peap_views = peap_views;
        for f = 1:Nfig
            print('-dpdf', ['-f' num2str(f)], ...
                fullfile(resultdir, sprintf('%s/analysisIII/curves/plot_%d.pdf', ...
                objnames_selected{o}, f)));
        end
        close all;
        if DO_OVERLAP_CRITERIA_ANALYSIS
            det = readDetections(dataset, dataset_params, ann, objnames_selected{o});
            mkdir(fullfile(resultdir, sprintf('%s/analysisIII/ov_analysis/', objnames_selected{o})));
            [resultclass, result, Nfig] = overlapAnalysis(dataset, objnames_selected{o},...
                dataset_params, ann, det, metric_type, detector, result);
            resulttotal(o).ov_aos = resultclass.aos;
            resulttotal(o).ov_avp = resultclass.avp;
            resulttotal(o).ov_peap = resultclass.peap;
            resulttotal(o).ov_mae = resultclass.mae;
            resulttotal(o).ov_medError = resultclass.medError;
            resulttotal(o).ov_ap = resultclass.ap;
            for f = 1:Nfig
                print('-dpdf', ['-f' num2str(f)], ...
                    fullfile(resultdir, sprintf('%s/analysisIII/ov_analysis/plot_%d.pdf', ...
                    objnames_selected{o}, f)));
            end
            close all;
        end
        
        %% Qualitative Results
        result.name =  objnames_selected{o};
        result.resultdir =  resultdir;
        if SAVE_QUALITATIVE
            showQualitative(dataset_params.imdir, ann.rec, result);
        end
        
        clear result;
        clear result_fp;
        close all;
        
    end
    
    Nfig = summaryErrorDataset(detector, resulttotal, flag_diningtable, metric_type);
    for f = 1:Nfig
        print('-dpdf', ['-f' num2str(f)], ...
            fullfile(resultdir, sprintf('plot_%d.pdf', f)));
    end
    outfile = [resultdir, '/results_total.mat'];
    save(outfile, 'resulttotal', '-v7.3');
    close all;
    
    if SAVE_SUMMARY
        resultSummary = struct([]);
        for o = 1:numel(objnames_selected)
            tmp1 = load(fullfile(resultdir, sprintf('%s/results_I_%s_%s.mat', objnames_selected{o}, ...
                objnames_selected{o}, ...
                tp_display_localization)));
            resultSummary(o).tp = tmp1.result;
            tmp2 = load(fullfile(resultdir, sprintf('%s/results_II_%s_%s.mat', objnames_selected{o}, ...
                objnames_selected{o}, ...
                tp_display_localization)));
            resultSummary(o).fp = tmp2.result_fp;
            clear tmp1.result;
            clear tmp2.result_fp;
            close all;
        end
        % text summary
        writeAnalysisSummary(resultSummary, objnames_selected, detname, ...
            fullfile(resultdir, sprintf('Analysis_Summary_%s.txt', detector)));
        
    end
    clear resultSummary;
    
    close all;
    
    if DO_TEX
        if ~exist(fullfile(resultdir, 'tex'), 'file'), mkdir(fullfile(resultdir, 'tex')); end;
        system(sprintf('cp ../results/%s/*.tex %s', detector, fullfile(resultdir, 'tex')));
        writeTexHeader(fullfile(resultdir, 'tex'), detector)
        avp_matrix = reshape([resulttotal.avp_views],4,length(objnames_selected));
        peap_matrix = reshape([resulttotal.peap_views],4,length(objnames_selected));
        writeTableResults(fullfile(resultdir, 'tex'), detector, resulttotal, ...
            avp_matrix, peap_matrix, dataset, objnames_selected, metric_type);
        writeNumObjClass(fullfile(resultdir, 'tex'), objnames_selected);
        for o = 1:numel(objnames_selected)
            ind = strmatch(objnames_selected{o}, objnames_all, 'exact');
            writeTexObject(objnames_selected{o}, fullfile(resultdir, 'tex'), ...
                ann.gt(ind), metric_type, dataset, detector);
        end
    end
    clear resulttotal;
    clear result;
    clear result_fp;
    close all;
end %End for(detectors)
clear all;
%exit;