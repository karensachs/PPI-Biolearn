
% spec_PPIconstrained creates a spec file which Biolearn will apply to create a PPI-constrained network.
%The spec file (biolearn.spec) created by this program should be in the same directory when biolearn is run. If biolearn is run in Interactive Mode, it is also possible to browse to access the spec file.
% As input, this program accepts ppi, a 2 column matrix indicating all
% pairs of PPI edges,
% It also accepts as input a networkname (text string),filelist, a textfile listing
%the list of data files, and variable_names, a list of variables in the
%order they appear in the data array(s)
%Karen Sachs 2019

function [Specfilename] = spec_PPIconstrained(networkname,filelist,variable_names);

%could add as input options:
% filelistforspec,celltype,condindex,drugname,doselist,scoretype,discBuckets,numruns,numcells)

% permitted=importdata(ppi_textfile.txt);
% BLdir=fldir;

%% make ppi into a matrix
numvar=length(variable_names);
ppiM=zeros(numvar,numvar);
for i=1:size(ppi,1)
    node1=ppi(i,1);
    node2=ppi(i,2);
    ppiM(node1,node2)=1;
end

%% Make spec file
        Specfilename=['biolearn.spec'];
        
        fid = fopen(Specfilename,'w+');
        fprintf(fid,'%s ','DefaultNetworkName ');
        fprintf(fid,'%s ',networkName);
        fprintf(fid,'\n');
        fprintf(fid,'%s ','discretescore BDe 5');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','VariableStatusFile biolearn.columnstatus.txt');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','algorithm GreedyHillClimbing 5');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','data MultipleInputFiles DataPointPerLine ');
%         fprintf(fid,'%s',fldir);
        fprintf(fid,'%s ',filelist);%forspec);
        fprintf(fid,'\n');
        fprintf(fid,'%s ','sample ');
        fprintf(fid,'%s ',num2str(numcells));
        fprintf(fid,'\n');
        fprintf(fid,'%s ','DiscretizationBuckets ');
        fprintf(fid,'%s ',num2str(discBuckets));
        fprintf(fid,'%s ',' soft bydistance');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','numruns ');
        fprintf(fid,'%s ',num2str(numruns));
        fprintf(fid,'\n');
        fprintf(fid,'%s ','confidencethreshold 50');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','discretizedFileSuffix discr');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','constraint ParentMaximum 4');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','Prior EdgePenalty Fraction .2');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','batch');
        for i=1:numvar
            for j=i+1:numvar
                if ppiM(i,j)==1 | ppiM(j,i)==1
                    var1=variable_names(i);
                    var2=variable_names(j);
                    fprintf(fid,'\n')
                    fprintf(fid,'%s ',['Constraint NoEdge ',var1, ' ',var2])
                end
            end
        fprintf(fid,'\n');
        fclose(fid);

%%April 2019, Karen & Dan 
% 'source' function: makeSpec from Documents/MATLAB/CYTOF/ComparativeSignaling/code/BL'
