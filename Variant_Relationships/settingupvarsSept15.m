load tempt
% whos
% edit prob_pairs_check
odat=dat;
text=d.textdata;
header=text(1,:);

vartext=header(2:end-4);

dat=dat(:,1:end-4);

sumdat=sum(dat);
hist(sumdat,100)
all0=find(sumdat==0);
almostzero=find(sumdat<30);
almostzero=find(sumdat<10);
almostzero=find(sumdat<5);
toosparse=[almostzero];
pruneddat=dat;
pruneddat(:,toosparse)=[];
prunedvartext=vartext;
prunedvartext(toosparse)=[];
sumpdat=sum(pruneddat);
% hist(sumpdat,100)
min(sumpdat)
% hist(sumpdat,100)
save sept15
% edit settingupvarsSept15


alspdat=pruneddat(als,:);
ctrpdat=pruneddat(ctr,:);

%freq's of variants in als/ctr
pvarals=sum(alspdat)./size(als,1);
pvarctr=sum(ctrpdat)./size(ctr,1);
% scatter(pvarals,pvarctr)
% set(gcf,'color','w');
%freq 

dif=pvarals-pvarctr;
% hist(dif,100)
% set(gcf,'color','w');
% title('Probability differences (p(ALS)-p(CTR))')

%this takes around 5 min
alsres=[];
ctrres=[];
whichvars=[];
numv=size(alspdat,2);
for v1=1:numv
    for v2=v1+1:numv
%         thisrow=[];
%         thisrow=[thisrow,[v1 v2]];
        whichvars=[whichvars;[v1 v2]];
        expectedjointALS=pvarals(v1)*pvarals(v2);
        expectedjointCTR=pvarctr(v1)*pvarctr(v2);
        v1inALS=find(alspdat(:,v1)==1);
        v2inALS=find(alspdat(:,v2)==1);
%         length(intersect(v1inALS,v2inALS))
        v1andv2ALS=length(intersect(v1inALS,v2inALS))/size(als,1);
        v1inCTR=find(ctrpdat(:,v1)==1);
        v2inCTR=find(ctrpdat(:,v2)==1);
        v1andv2CTR=length(intersect(v1inCTR,v2inCTR))/size(ctr,1);
        alsres=[alsres;[expectedjointALS v1andv2ALS]];
        ctrres=[ctrres;[expectedjointCTR v1andv2CTR]];
    end
end


%actual vs expected
% scatter(alsres(:,2),alsres(:,1))
% set(gcf,'color','w');
% xlabel('Actual joint probability')
% ylabel('Expected joint probability')
% scatter(ctrres(:,2),ctrres(:,1))
% set(gcf,'color','w');
% xlabel('Actual joint probability')
% ylabel('Expected joint probability')
% title('Control')


% hold on
% %set of pairs that are higher in als appear here
% scatter(alsres(:,1),ctrres(:,1))
% hold on
% scatter(alsres(:,2),ctrres(:,2),'r')
% %what about individual frequencies - are they noticably higher in als?
% scatter(pvarals,pvarctr)

difjointals=alsres(:,2)-alsres(:,1);
difjointctr=ctrres(:,2)-ctrres(:,1);
% scatter(difjointals,difjointctr);
% set(gcf,'color','w');
% xlabel('Deviance from expected ALS')
% ylabel('Deviance from expected CTR')
% title('Deviance of variant-pair joint probabilities from expected')



min(difjointctr)
min(difjointals)
max(difjointals)
%by pathway


% stringnum=x(s(2)+2 : s(3)-2);
% num=str2num(stringnum);

%find all pathways
allpathways=[];
for i=1:numv
    x=prunedvartext{i};
    s=strfind(x,'_WP');
    for j=1:length(s)
        if j==length(s),
            stringnum=x(s(j)+3:end);
        else 
            stringnum=x(s(j)+3:s(j+1)-1);
        end
        allpathways=[allpathways; str2num(stringnum)];
%         pathindicator(i,str2num(stringnum))==1);
% size(allpathways)
    end
end
        
uniquepathways=unique(allpathways);
% scatter(1:length(allpathways),allpathways)
% set(gcf,'color','w');
% scatter(1:1163,sort(allpathways))
% set(gcf,'color','w'); 

%is this useful?? frequency of each pathway in the list of pathways
p_pathway=[];
for i=1:length(uniquepathways)
    path=uniquepathways(i);
    p_pathway=[p_pathway length(find(allpathways==path))/length(uniquepathways)];
end

numpath=length(uniquepathways);%note that this will throw an error bc it's gnerated below
%paths need an index because the numbers are all over the place and i need
%them to be 1:numpaths
% pathindex=[];
% for i=1:numpath,
%     pathindex=find(uniquepathways

pathindicator=zeros(numv,numpath);
for i=1:numv
    x=prunedvartext{i};
    s=strfind(x,'_WP');
    for j=1:length(s)
       if j==length(s),
            stringnum=x(s(j)+3:end);
        else 
            stringnum=x(s(j)+3:s(j+1)-1);
        end
        s2n=str2num(stringnum);
%         allpathways=[allpathways; str2num(stringnum)];
        pathindicator(i,find(uniquepathways==s2n))=1;
    end
end
save sept27
% imagesc(pathindicator)
% set(gcf,'color','w');
% xlabel('Unique pathways')
% ylabel('Variants')
%% 
ppathALS=[];
ppathCTR=[];
sumvarals=sum(alspdat);
for p=1%:numpath
    membervars=find(pathindicator(:,p)==1);
%     summembervars=sumvarals(membervars);
    varsperpatient=sum(alspdat(:,membervars),2);
    numpatientswithpath=sum(varsperpatient>0);
    ppathALS=[ppathALS,numpatientswithpath/length(als)];
%    hist( summembervars,100)
    
end
 pvarals=sum(alspdat)./size(als,1);
pvarctr=sum(ctrpdat)./size(ctr,1);  
  
%% image 
% imagesc(pathindicator)
% xlabel('Pathway')
% ylabel('Variant')
% title('Variant pathway assignments')


%% 
% numpath=length(uniquepathways);
% % p_pathway_als=[];
% pathindicator=zeros(numvar,numpath);
% for p=1:length(uniquepathways);
    



    
    
    