addpath /home/slab/users/mangstad/repos/Misc_utils
addpath /usr/local/MethodsCore/SPM/SPM12/spm12_with_R7219/
addpath /net/parasite/HCP/Scripts/slab/cifti
addpath /net/parasite/HCP/Scripts/slab/cifti/gifti-1.6
addpath /net/pepper/ABCD/CIFTI/Scripts/connectivity/
%cifti scripts need to be on path after SPM

Runs = {'run-01','run-02','run-03','run-04'};

CIFTITemplate = '/net/pepper/ivy_data/workflow/results/[Subject]/[Subject]/func/[Subject]_task-jovi_[Run]_space-fsLR_den-91k_bold.dtseries.nii';
ConfoundTemplate = '/net/pepper/ivy_data/workflow/results/[Subject]/[Subject]/func/[Subject]_task-jovi_[Run]_desc-confounds_regressors.tsv';

ROIFile = '/net/parasite/HCP/CIFTI_atlas/combined.dlabel.nii';
DataFile = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/jovi_MDF.csv';

dat = readtable(DataFile,'Delimiter',',');

subs = dat.subject;
% subs = num2cell(subs);
runs = dat.run;
% runs = num2cell(runs);

rois = mc_load_datafile(ROIFile);

r = numel(Runs);
n = numel(subs);
nroi = numel(unique(rois));
corr_mat_jovi = zeros(n,nroi,nroi);
stats = zeros(n,4);
errors = {};

for iSubject = 1:n
    errors{iSubject} = '';
    Subject = subs{iSubject};
%     Subject = num2cell(Subject);
    Run = Runs{runs(iSubject)};
    
    tmp = sprintf('%d %s %s\n',iSubject,Subject,Run);
    disp(tmp);
    
    temp2 = zeros(nroi,nroi);
    
    %load data
    ciftitemplate = strrep(CIFTITemplate,'[Subject]',Subject);
    ciftitemplate = strrep(ciftitemplate,'[Run]',Run);
    data_cifti = mc_load_datafile(ciftitemplate);
    N = size(data_cifti,1);
    Pc = numel(data_cifti)/N;
    
%     if (N~=380 && N~=383)
%         %wrong number of time points
%         errors{iSubject} = [errors{iSubject} 'wrong time points;'];
%         continue;
%     end
    trimstart = N-273;
    trimend = N;
    
    data_cifti = reshape(data_cifti,N,Pc);
    
    %load confounds here
    confoundtemplate = strrep(ConfoundTemplate,'[Subject]',Subject);
    confoundtemplate = strrep(confoundtemplate,'[Run]',Run);
%     [confounds,stats(iSubject,:)] = fmriprep_getconfounds(mc_GenPath(ConfoundTemplate),5,0.5); 
%     try
        [confounds,stats(iSubject,:)] = fmriprep_getconfounds(confoundtemplate,5,0.5); 
%     catch e
%         errors{iSubject} = [errors{iSubject} e.message ';'];
%         continue;
%     end
    
    %modify to return censored frame count
    
%     %trim data before removing confounds;
%     if (size(confounds,1) ~= N)
%         %error they don't match
%         errors{iSubject} = [errors{iSubject} 'confounds and data do not match;'];
%         continue;
%     end
    
    clean_data = mc_remove_confounds(data_cifti(trimstart:trimend,:),confounds(trimstart:trimend,:));

    %grab ROIs
    roi_vals = mc_summarize_rois(clean_data,rois);
    
    temp = corr(roi_vals);

    fprintf(1,'\n');
    corr_mat_jovi(iSubject,:,:) = temp;
end
