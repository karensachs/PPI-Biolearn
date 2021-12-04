%% This function takes genes (or Cell type markers etc) and bins by intervals. However, due to issues w/ outliers skewing bin boundaries, it maintains 
% % robustness to outliers by ensuring that a minimum % of cells lie in
% each bin, and also that no more than a certain percent. These parameters
% are hardcoded as 20% and 40% respectivey in the below, adjust directly in the code to change them. 

function binIndicatorM = slice_by_intervalish(normd,numbins)

numgenes=size(normd,2);
numsamples=size(normd,1);
minptsperbin=ceil(numsamples/5);
maxptsperbin=ceil(numsamples/2.5);
binIndicatorM=zeros(size(normd,1),numgenes);
for g=1:numgenes
    genedat=normd(:,g);
    mindat=min(genedat);
    maxdat=max(genedat);
    binsize=(maxdat-mindat)./numbins;
    changeinterval=binsize/10;
    startbin=mindat;
%     g
    for bin=1:numbins,
%         bin
%         startbin
        endbin=startbin+binsize;
        datpts=intersect(find(genedat>=startbin), find(genedat<=endbin));
        numdatpts=length(datpts);
        while numdatpts>maxptsperbin && endbin>=mindat 
%             bin
            endbin=endbin-changeinterval;
            datpts=intersect(find(genedat>=startbin), find(genedat<=endbin));
            numdatpts=length(datpts);
        end
        while numdatpts<minptsperbin && endbin<=maxdat
            endbin=endbin+changeinterval;
            datpts=intersect(find(genedat>=startbin), find(genedat<=endbin));
%             g
%             bin
            numdatpts=length(datpts);
        end
        if bin==3
            datpts=intersect(find(genedat>=startbin), find(genedat<=maxdat));
        end
%         bin
%         numdatpts
        binIndicatorM(datpts,g)=bin;
        startbin=endbin;
 
    end
end