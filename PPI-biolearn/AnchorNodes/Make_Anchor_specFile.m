%takes in specfile filename 
%recommended specfile name is some variation on biolearn.spec.txt
%Uses the columnstatus default filename(biolearn.columnstatus.txt)
%Specify regular (Algo=0) or Sparse Candidate Algo (Algo = 1)
%Specify with or without LINCS constraints (LINCS_constraints=0/1)
%outputs biolearn.spec.txt

function Make_Anchor_specFile(Specfilename,Algo, LINCS_constraints)

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
% DefaultNetworkName pcsfLINCS_constrained_BN
% Score BDe 10.0
% DiscretizationBuckets 3 SOFT BYDISTANCE
% 
% algorithm GreedyHillClimbing 5
% algorithm SparseCandidate 3 GreedyHillClimbing 5
% dataformat DataPointPerLine 
% sample 1
% numruns 10
% confidencethreshold 30
% columnStatusFile biolearn.columnstatus.txt
% constraint ParentMaximum 3
% Prior EdgePenalty Fraction .99999
% columnStatusFile biolearn.columnstatus.txt
% 
% discBuckets=3;
% numruns=10;
%         Specfilename=['biolearnPPI.spec'];
        
        fid = fopen(Specfilename,'w+');
%         fid = fopen('starterspec_SCAlg.spec.txt', 'a+');
        fprintf(fid,'%s ','DefaultNetworkName ');
        fprintf(fid,'%s ',networkname);
        fprintf(fid,'\n');
        fprintf(fid,'%s ','discretescore BDe 5');
        fprintf(fid,'\n');
        fprintf(fid,'%s ','VariableStatusFile biolearn.columnstatus.txt');
        fprintf(fid,'\n');
        if Alg0==0
        fprintf(fid,'%s ','algorithm GreedyHillClimbing 5');
        else
         fprintf(fid,'%s ','SparseCandidate 3 GreedyHillClimbing 5');
        end
        fprintf(fid,'\n');
        fprintf(fid,'%s ','data MultipleInputFiles DataPointPerLine ');
%         fprintf(fid,'%s',fldir);
%         fprintf(fid,'%s ',filelist);%forspec);
        fprintf(fid,'\n');
        fprintf(fid,'%s ','sample ');
        fprintf(fid,'%s 1');%,num2str(numcells));
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
        if LINCS_constraints==1
        for i=1:numvar
            for j=1:numvar %bug fix Apr 1 2020 - BL expects directed constraints, so i need to put in both directions to block an edge
                if ppiM(i,j)==0 & ppiM(j,i)==0
                    var1=variable_names{i};
                    var2=variable_names{j};
                    
                    fprintf(fid,'%s ',['Constraint NoEdge ',var1, ' ',var2])
                    fprintf(fid,'\n')
                end
            end
        end
        end
        fprintf(fid,'\n');
        fclose(fid);

%source Make_spec_PPIconstrained_v3 from /Users/karensachs/Dropbox/Matlab/ALS/FromJohnny_to_Karen_Feb18
