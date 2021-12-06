%KS 2021
%Local tests on RNA data from Ryan Lim, Nov 2021 - check for delta cor or
%delta MN probability given Dis, gender and cell marker status.

d=importdata('countsWithMetadata.csv');
dat=d.data;
text=d.textdata;
header=text(1,:);


%% Make cell type data
%get rid of NAs in cell type data
CellTypeDataImputed=[];
IndexC = strfind(header,'NKX'); 
Index = find(not(cellfun('isempty',IndexC)));
firstIndex=Index-2; lastIndex=Index+3;

CellTypeMarkers=header(Index-2:Index+3);
for markerindex=firstIndex:lastIndex,
    
y=text(2:end,markerindex);
%replace NAs with the mean across all nonNA samples
    vals=[];
    nans=[];
    allvals=[];
    for i=1:length(y)
        if ~ isempty(str2num(y{i}))
            vals=[vals,str2num(y{i})];
            allvals=[allvals,str2num(y{i})];
        else
            allvals=[allvals,0];
            nans=[nans,i];
        end
    end
    MeanVal=mean(vals);
    allvals(nans)=MeanVal;
    CellTypeDataImputed=[CellTypeDataImputed;allvals];
end

%% Disease node
IndexC = strfind(header,'status'); 
Index = find(not(cellfun('isempty',IndexC)));
header(Index)
diseasecol=Index;
textminusheader=text(2:end,:);
textmh=textminusheader;
IndexC = strfind(textmh(:,diseasecol),'CASE'); 
Index = find(not(cellfun('isempty',IndexC)));
ALScases=Index;
Index = find(cellfun('isempty',IndexC));
CTRcases=Index;
Dnode=ones(size(dat,1),1); 
Dnode(CTRcases)=2;

%% gender node saved

%% Process data
normd=dat./repmat(sum(dat')',1,size(dat,2));
findzeros=normd==0;
% imagesc(findzeros)
% set(gcf,'color','w');
% title('Data sparsity for 8525 genes')
numzeros=sum(findzeros);
% imagesc(numzeros)
% set(gcf,'color','w');
% title('Total number of 0s per gene')
numsamples=size(normd,1);
numgenes=size(normd,2);
%Does data need to be transformed? What does it look like?
%it looks vaguely gaussian, some have a big zeroish peak and not much else
%(only 1-2 from the 50 i looked at) - outliers definitely a thing. I think
%interval-ish discretization is prefered, meaning interval but forces each
%bin to have a min % of cells, else bin is expanded. (shrink as well?)
% for i=1:50
% hist(normd(:,i),100)
% pause(2)
% end
%% Local tests
%to do:read sophia papers, figure out fisher test for correlation

%for g=1/2, slice up s100b and check delta A/CTR (rank sum or ttest) and
%delta cor

%% slice by interval-ish - function below slices into intervals but is more robust to outliers/ tries to ensure no slice has fewer than 20% of cells
% numgenes=5;%size(normd,2);
numbins=3;
% binIndicatorM = slice_by_intervalish(normd(:,1:6),numbins);
%% Grab s100b for now, look at hist
s100b=CellTypeDataImputed(5,:)';
%graphs
% hist(s100b,100)
% set(gcf,'color','w');
% title('Histogram of s100b')
% histogram(s100b(ALScases),100)
% hold on
% histogram(s100b(CTRcases),100)
%% make binary s100b vector
%Pick threshold by eye - either 11 or 12&30
binarys100b=zeros(1,numsamples);
f=find(s100b<=11);
binarys100b(f)=1;
f=find(s100b>=11);
binarys100b(f)=2;
%% make trinary s100b vector
%Pick threshold by eye - either 11 or 12&30
trinarys100b=zeros(1,numsamples);
f=find(s100b<=12);
trinarys100b(f)=1;
ff=find(s100b>=12);
fff=find(s100b<=30);
f=intersect(ff,fff);
trinarys100b(f)=2;
f=find(s100b>=30);
trinarys100b(f)=3;

%% Pick gender % s100b level, then do ttest for D effect
numslices=2; %s100b slices
numgenders=2;
numcategories = numslices*numgenders;
pvalM=zeros(numcategories, numgenes);
categoryIndicatorM = zeros(numcategories,2);
catcounter=1;
for genderindex=1:2
    g=find(gender==genderindex);
    for s100bslice=1:2
        slice=find(binarys100b==s100bslice);
        thesesamples = intersect(g,slice);
        alssubset=intersect(thesesamples,ALScases);
        ctrsubset=intersect(thesesamples,CTRcases);
        selecteddataALS=normd(alssubset,:);
        selecteddataCTR=normd(ctrsubset,:);
        [~,pval,~,stats] = ttest2(selecteddataALS,selecteddataCTR);
        pvalM(catcounter,:)=pval;
        categoryIndicatorM(catcounter,1)=genderindex;
        categoryIndicatorM(catcounter,2)=s100bslice;
        catcounter=catcounter+1;
        
    end
end
        
%  lowpval=pvalM<0.05;
%  imagesc(lowpval)
%  set(gcf,'color','w');
% title('pvals<0.05 - F, low s100b, high 100b, M, low s100b, high s100b')
%  
%% repreat for trinary s100b - ttest for D affect 
% %Pick gender % s100b level, then do ttest
% numslices=3; %s100b slices
% numgenders=2;
% numcategories = numslices*numgenders;
% pvalM=zeros(numcategories, numgenes);
% categoryIndicatorM = zeros(numcategories,2);
% catcounter=1;
% for genderindex=1:2
%     g=find(gender==genderindex);
%     for s100bslice=1:numslices
%         slice=find(trinarys100b==s100bslice);
%         thesesamples = intersect(g,slice);
%         alssubset=intersect(thesesamples,ALScases);
%         ctrsubset=intersect(thesesamples,CTRcases);
%         selecteddataALS=normd(alssubset,:);
%         selecteddataCTR=normd(ctrsubset,:);
%         [~,pval,~,stats] = ttest2(selecteddataALS,selecteddataCTR);
%         pvalM(catcounter,:)=pval;
%         categoryIndicatorM(catcounter,1)=genderindex;
%         categoryIndicatorM(catcounter,2)=s100bslice;
%         catcounter=catcounter+1;
%         
%     end
% end
%         
% imagesc(pvalM)
%  lowpval=pvalM<0.05;
% figure(2)
%  imagesc(lowpval)
%  set(gcf,'color','w');
% title('pvals<0.05 - F, low s100b, high 100b, M, low s100b, high s100b')
%  f=find(sum(lowpval)==0);
%  pickgenes=lowpval;
%  pickgenes(:,f)=[];
%  clustergram(pickgenes-.5)
% % lowerpval=pvalM<0.001;
% % f=find(sum(lowerpval)==0);
% %  pickgenes=lowerpval;
% %  pickgenes(:,f)=[];
% %  clustergram(pickgenes-.5)
% %     

%% Check for delta cor
%% Pick gender % s100b level, then do ttest for D effect
numslices=2; %s100b slices
numgenders=2;
numcategories = numslices*numgenders;
% pvalM=zeros(numcategories, numgenes);
categoryIndicatorM = zeros(numcategories,2);
catcounter=1;
 [cnormd,thosecut,numCut,numOver] = cleanData(normd,3);
for genderindex=1%:2
    g=find(gender==genderindex);
    for s100bslice=1%:2
        slice=find(binarys100b==s100bslice);
        thesesamples = intersect(g,slice);
        alssubset=intersect(thesesamples,ALScases);
        ctrsubset=intersect(thesesamples,CTRcases);
        selecteddataALS=cnormd(alssubset,:);
        selecteddataCTR=cnormd(ctrsubset,:);
       
        [cals,pvalcals]=corrcoef(selecteddataALS);
        [cctr,pvalcctr]=corrcoef(selecteddataCTR);
        cdif=cals-cctr;      
%         [~,pval,~,stats] = ttest2(selecteddataALS,selecteddataCTR);
%         pvalM(catcounter,:)=pval;
        categoryIndicatorM(catcounter,1)=genderindex;
        categoryIndicatorM(catcounter,2)=s100bslice;
        catcounter=catcounter+1;
        
    end
end
% aselecteddataCTR=asinh(selecteddataCTR/5);
% aselecteddataALS=asinh(selecteddataALS/5);
[bigcdifi,bigcdifj]=find(abs(cdif>0.8));
for i=1:4
figure(i)
scatter(selecteddataCTR(:,bigcdifi(i)),selecteddataCTR(:,bigcdifj(i)),'filled','b')
hold on
scatter(selecteddataALS(:,bigcdifi(i)),selecteddataALS(:,bigcdifj(i)),'filled','r')
title(cdif(bigcdifi(i),bigcdifj(i)))
end
% save Nov19
% hist(cdif,100)
% set(gcf,'color','w');
% title('Differences in correlations (Pearson)') 
length(find(abs(cdif)>0.5))/(8525*8525) %6%

%% repeat cdif but with permuted data
% edit cdif_jumbled_data

%%Dec 3 notes - fsr the 



        
%  lowpval=pvalM<0.05;
%  imagesc(lowpval)
%  set(gcf,'color','w');
% title('pvals<0.05 - F, low s100b, high 100b, M, low s100b, high s100b')
%  





    