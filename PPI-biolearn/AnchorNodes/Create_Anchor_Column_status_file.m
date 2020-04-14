%%Create_Anchor_Column_status_file creates a file called
%%biolearn.columnstatus.txt
%This file will encode a restriction to biolearn forcing selected nodes to
%serve as anchors, either as ROOT or as LEAF.
%Anchor_names is a ax1 (or 1xa) cell array with the names of the anchors
% where a=number of anchors
%Root_Leaf_indicator is a 1xa (or ax1) vector indicating for each anchor if
%it is root (1) or leaf (2)
function Create_Anchor_Column_status_file(Anchor_names,Root_Leaf_indicator)

fname=biolearn.columnstatus.txt
fid = fopen(fname,'w+');
  
% Encode constraints in the columnstatus file
 for i=1:length(Anchor_names)
    anchor_name=Anchor_names{i};
    if Root_Leaf_indicator(i)==1,
        anchor_type='ROOT';
    else anchor_type='LEAF';
    end
    fprintf(fid,'%s ',[anchor_name,' ',anchor_type]);
    fprintf(fid,'\n');
 end

% Close the file
fclose(fid);
