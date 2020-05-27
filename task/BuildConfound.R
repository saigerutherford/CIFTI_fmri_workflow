#!/usr/bin/env Rscript
#file="/net/pepper/ABCD/Scripts/slab/CIFTI_task_test/sub-NDARINVZZZNB0XC_ses-baselineYear1Arm1_task-nback_run-01_desc-confounds_regressors"

library(jsonlite)

args = commandArgs(trailingOnly=TRUE)
if (length(args)<2) {
  stop("At least two arguments must be supplied (input, output).n", call.=FALSE)
}

NPC = 5 #this should be set in command line arguments
FDthresh = 0.5 #this should be set in command lin arguments
includeMotion = TRUE
includeCompCor = FALSE
includeCensor = FALSE
includeCosine = FALSE
trim = 0

if (length(args)>4) {
  trim = as.numeric(args[3])
}
if (length(args)>6) {
  includeCosine = as.numeric(args[7])==1
}
if (length(args)>5) {
  includeCensor = as.numeric(args[6])==1
}
if (length(args)>4) {
  includeCompCor = as.numeric(args[5])==1
}
if (length(args)>3) {
  includeMotion = as.numeric(args[4])==1
}
if (length(args)>7) {
  FDthresh = as.numeric(args[8])
}
if (length(args)>8) {
  NPC = as.numeric(args[9])
}



file = args[1]
outfile = args[2]

dat = read.table(paste0(file,".tsv"),header=T,sep="\t",na.strings="n/a")
json = fromJSON(paste0(file,".json"))

f = names(json)
idx = grepl("a_comp_cor",f)
f = f[idx]
wmv = NULL
wmn = NULL
csfv = NULL
csfn = NULL
idxw = 1
idxc = 1
for (i in 1:length(f)) {
  fi = f[i]
  if (json[[fi]]$Method=="aCompCor") {
    if (json[[fi]]$Mask == "WM") {
      wmv[idxw] = json[[fi]]$VarianceExplained
      wmn[idxw] = fi
      idxw = idxw + 1
    } else if (json[[fi]]$Mask == "CSF") {
      csfv[idxc] = json[[fi]]$VarianceExplained
      csfn[idxc] = fi
      idxc = idxc + 1
    }
  }
}

i = order(wmv,decreasing=T)
wmns = wmn[i]
i = order(csfv,decreasing=T)
csfns = csfn[i]

wmn = wmns[1:NPC]
csfn = csfns[1:NPC]

compcor_regressors = matrix(0,nrow=nrow(dat),ncol=NPC*2)
for (i in 1:NPC) {
  compcor_regressors[,i] = dat[,wmn[i]]
  compcor_regressors[,NPC+i] = dat[,csfn[i]]
}

f = names(dat)
idx = grepl("trans_",f) | grepl("rot_",f)
motion_regressors = dat[,idx]

fd = dat$framewise_displacement
censor = fd>FDthresh
y = matrix(0,nrow=nrow(dat),ncol=sum(censor,na.rm=T))
w = which(censor)
y[cbind(w,1:sum(censor,na.rm=T))] = 1
censor = y

f = names(dat)
idx = grepl("cosine",f)
cosine_regressors = dat[,idx]

confounds = matrix(1,nrow=nrow(dat),ncol=1)
if (includeMotion == TRUE) {
  confounds = cbind(confounds,motion_regressors)
}
if (includeCompCor == TRUE) {
  confounds = cbind(confounds,compcor_regressors)
}
if (includeCosine==TRUE) {
  confounds = cbind(confounds,cosine_regressors)
}
if (includeCensor==TRUE) {
  confounds = cbind(confounds,censor)
}

confounds = confounds[,-1]
confounds = confounds[(trim+1):nrow(confounds),]

write.table(confounds,outfile,col.names=F,row.names=F,quote=F,na="0")

