function [jumbled_dataALS,jumbled_dataCTR]=jumble_selected_data(selecteddataALS,selecteddataCTR)

numALS=size(selecteddataALS,1);
numCTR=size(selecteddataCTR,1);

alldata=[selecteddataALS;selecteddataCTR];

% jumbled_dataALS=[]; - this is assigned as whatever is left from alldata
jumbled_dataCTR=[];
for i=1:numCTR,
    randomsampleindex=ceil(rand*size(alldata,1));
    jumbled_dataCTR=[jumbled_dataCTR;alldata(randomsampleindex,:)];
    alldata(randomsampleindex,:)=[];
end

   jumbled_dataALS=alldata;
   
   if size(jumbled_dataALS) ~= size(selecteddataALS),
       error('sizes do not match')
   end
   if size(jumbled_dataCTR) ~= size(selecteddataCTR),
       error('CTR sizes do not match')
   end