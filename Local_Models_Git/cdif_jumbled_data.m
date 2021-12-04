%% Check for delta cor
%% Pick gender % s100b level, then do ttest for D effect
numslices=2; %s100b slices
numgenders=2;
numcategories = numslices*numgenders;
% pvalM=zeros(numcategories, numgenes);
categoryIndicatorM = zeros(numcategories,2);
catcounter=1;
for genderindex=1%:2
    g=find(gender==genderindex);
    for s100bslice=1%:2
        slice=find(binarys100b==s100bslice);
        thesesamples = intersect(g,slice);
        alssubset=intersect(thesesamples,ALScases);
        ctrsubset=intersect(thesesamples,CTRcases);
        selecteddataALS=normd(alssubset,:);
        selecteddataCTR=normd(ctrsubset,:);
        [jumbled_dataALS,jumbled_dataCTR]=jumble_selected_data(selecteddataALS,selecteddataCTR);
        [jcals,jpvalcals]=corrcoef(jumbled_dataALS);
        [jcctr,jpvalcctr]=corrcoef(jumbled_dataCTR);
        jcdif=jcals-jcctr;      
%         [~,pval,~,stats] = ttest2(selecteddataALS,selecteddataCTR);
%         pvalM(catcounter,:)=pval;
        categoryIndicatorM(catcounter,1)=genderindex;
        categoryIndicatorM(catcounter,2)=s100bslice;
        catcounter=catcounter+1;
        
    end
end
length(find(abs(jcdif)>0.5))/(8525*8525)
[jbigcdifi,jbigcdifj]=find(abs(jcdif>0.8));
for i=1:4
figure(i)
scatter(jumbled_dataCTR(:,jbigcdifi(i)),jumbled_dataCTR(:,jbigcdifj(i)),'filled','b')
hold on
scatter(jumbled_dataALS(:,jbigcdifi(i)),jumbled_dataALS(:,jbigcdifj(i)),'filled','r')
title(cdif(jbigcdifi(i),jbigcdifj(i)))
end