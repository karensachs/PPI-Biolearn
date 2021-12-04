%7/13/07
%cleans for a certain single column..for cleaning out other bc channels and
%etc

%april 2, 2007
%I am modifying cleanData (see cleanDataold for prev version) bc it doesn't work for neg data that is not 0-centered.  duh.
function [D,thosecut,numCut,numOver] = cleanData(rawD,numstd)
%scol=single column
% numCut, numOver] = cleanData(rawD)
if nargin==1,
    numstd=2.7;
end

Mean=mean(rawD); %avg of each col
std2 = std(rawD) * numstd;
upperBound = std2 + Mean;  %keep everything w/i 3 std of mean
lowerBound=Mean-std2;
molecules = size(rawD,2);
catchem = [];
thosecut=[];
D=rawD;
%rawD=abs(rawD); %*******for data with large neg values, 0-centered, this allows me to throw out all outliers, on either side of 0
for i= 1:molecules,

    origNum = find((rawD(:,i) > upperBound(i)) | (rawD(:,i) < lowerBound(i)) );
    inters=intersect(thosecut,origNum);
%     if inters,
%         for j=1:size(inters,1),
%             pt=inters(j);
%             f=find(origNum==pt);
%             origNum(f)=[];
%         end
%     end
            
    thosecut=[thosecut;origNum];
    rowNum = find((D(:,i) > upperBound(i)) | (D(:,i) < lowerBound(i)) ); %rowNum contains rows where the mol exceeds x+3s
    catchem = [catchem;D(rowNum,:)];
    D(rowNum,:) = []; %erases all rows listed in rowNum
    numCut(i) = size(rowNum,1); %to record how many lines are lost
    numOver(i) = size(origNum,1);
 end




    
