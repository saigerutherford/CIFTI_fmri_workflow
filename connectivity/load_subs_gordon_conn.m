addpath /home/slab/users/mangstad/repos/Misc_utils
addpath /usr/local/MethodsCore/SPM/SPM12/spm12_with_R7219/
addpath /net/parasite/HCP/Scripts/slab/cifti
addpath /net/parasite/HCP/Scripts/slab/cifti/gifti-1.6
%cifti scripts need to be on path after SPM

CorrTemplate = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Gordon_Sub_Cere/Jovi/[Subject].txt';

ROIFile = '/net/parasite/HCP/CIFTI_atlas/combined.dlabel.nii';
DataFile = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/jovi.csv';

dat = readtable(DataFile,'Delimiter',',');

subs = dat.subject;

N = length(subs);
Nodes = 419;
P = (Nodes*(Nodes-1))/2;
featuremat_jovi = zeros(N,P);

for i = 1:N
    Subject = subs{i};
    fprintf(1,'Loading %d of %d\n',i,N);
    tmp = mc_load_datafile(mc_GenPath(CorrTemplate));
    tmp = mc_flatten_upper_triangle(tmp);
    featuremat_jovi(i,:) = tmp;
end
featuremat_orig_jovi = featuremat_jovi;

%% Gaze
CorrTemplate = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Gordon_Sub_Cere/Gaze/[Subject].txt';

ROIFile = '/net/parasite/HCP/CIFTI_atlas/combined.dlabel.nii';
DataFile = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Gaze_scanfile.csv';

dat = readtable(DataFile,'Delimiter',',');

subs = dat.Subject;

N = length(subs);
Nodes = 419;
P = (Nodes*(Nodes-1))/2;
featuremat_gaze = zeros(N,P);

for i = 1:N
    Subject = subs{i};
    fprintf(1,'Loading %d of %d\n',i,N);
    tmp = mc_load_datafile(mc_GenPath(CorrTemplate));
    tmp = mc_flatten_upper_triangle(tmp);
    featuremat_gaze(i,:) = tmp;
end
featuremat_orig_gaze = featuremat_gaze;

%% Rest
CorrTemplate = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Gordon_Sub_Cere/Rest/[Subject].txt';

ROIFile = '/net/parasite/HCP/CIFTI_atlas/combined.dlabel.nii';
DataFile = '/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/rest_MDF.csv';

dat = readtable(DataFile,'Delimiter',',');

subs = dat.subject;

N = length(subs);
Nodes = 419;
P = (Nodes*(Nodes-1))/2;
featuremat_rest = zeros(N,P);

for i = 1:N
    Subject = subs{i};
    fprintf(1,'Loading %d of %d\n',i,N);
    tmp = mc_load_datafile(mc_GenPath(CorrTemplate));
    tmp = mc_flatten_upper_triangle(tmp);
    featuremat_rest(i,:) = tmp;
end
featuremat_orig_rest = featuremat_rest;

%% Group t-tests

featuremat_jovi_HC = featuremat_jovi(1:32,:);
featuremat_jovi_SZ = featuremat_jovi(33:end,:);
featuremat_gaze_HC = featuremat_gaze(1:33,:);
featuremat_gaze_SZ = featuremat_gaze(34:end,:);
featuremat_rest_HC = featuremat_rest(1:33,:);
featuremat_rest_SZ = featuremat_rest(34:end,:);

[h_jovi p_jovi ci_jovi stats_jovi] = ttest2(featuremat_jovi_HC, featuremat_jovi_SZ);
[h_gaze p_gaze ci_gaze stats_gaze] = ttest2(featuremat_gaze_HC, featuremat_gaze_SZ);
[h_rest p_rest ci_rest stats_rest] = ttest2(featuremat_rest_HC, featuremat_rest_SZ);

sig_edges_jovi = find(p_jovi < 0.05);
sig_edges_gaze = find(p_gaze < 0.05);
sig_edges_rest = find(p_rest < 0.05);



addpath /home/slab/users/mangstad/repos/Misc_utils
nets = load('/net/pepper/ABCD/CIFTI/Scripts/connectivity/gordon_combined_nets.txt');
nets = nets(1:419);

nlog10p_jovi = -log10(p_jovi);
nlog10p_jovi_signed = nlog10p_jovi .* sign(stats_jovi.tstat);
plot_jica_component(nlog10p_jovi_signed,1,0,2,nets,'',[1:16])

nlog10p_gaze = -log10(p_gaze);
nlog10p_gaze_signed = nlog10p_gaze .* sign(stats_gaze.tstat);
plot_jica_component(nlog10p_gaze_signed,1,0,2,nets,'',[1:16])

nlog10p_rest = -log10(p_rest);
nlog10p_rest_signed = nlog10p_rest .* sign(stats_rest.tstat);
plot_jica_component(nlog10p_rest_signed,1,0,2,nets,'',[1:16])
