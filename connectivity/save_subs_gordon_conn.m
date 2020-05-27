%need to have variable corr_mat loaded that was created from cifti_conn_rest.m script

tr = 0.8;

%screen bad censored data
bad = zeros(size(corr_mat,1),1);

bad = bad | stats(:,2) < 275;
bad = bad | (stats(:,2)-stats(:,1))*tr < (4*60);
[b,ia,ib] = unique(subs);
badruns = accumarray(ib,bad);
totalruns = accumarray(ib,ones(size(bad)));
goodruns = totalruns; %- badruns;

bad = bad | goodruns(ib)<2;

corr_mat_good = corr_mat(~bad,:,:);
subs_good = subs(~bad);
stats_good = stats(~bad,:);
dat_good = dat(~bad,:);
errors_good = errors(~bad);
runs_good = runs(~bad);
sess_good = sess(~bad);

[b,ia,ib] = unique(subs);
totalruns_good = accumarray(ib,ones(size(corr_mat,1),1));
mean_corr = zeros(numel(b),size(corr_mat,2),size(corr_mat,3));
for i = 1:size(corr_mat,2)
    fprintf(1,'%d\n',i);
    for j = i:size(corr_mat,3)
        tmp = corr_mat(:,i,j);
        nan = isnan(tmp);
        n = accumarray(ib,~nan);
        tmp(nan) = 0;
        mean_corr(:,i,j) = accumarray(ib,tmp)./n;
    end
end

for i = 1:numel(b)
    fprintf(1,'%d\n',i);
    tmp = squeeze(mean_corr(i,:,:));
    save(['/net/data4/SchizGaze2_16/Scripts/slab/CIFTI/Gordon_Sub_Cere/Jovi/' b{i} '.txt'],'tmp','-ASCII');
end

