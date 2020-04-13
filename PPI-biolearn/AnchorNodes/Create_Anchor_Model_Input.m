%Creates a data file that can be input into Biolearn for learning a model
%with anchor nodes, designated either Root (1) or Leaf (2).
%data is nxm matrix for n=number of samples (patients, cells, etc) and m =
%number of variables. 
%Anchor_values is a nxa matrix where a=number of anchors. The matrix
%specifies the values of the anchors per sample, which may be discrete or
%continuous.
%Anchor_names is a ax1 (or 1xa) cell array with the names of the anchors
%Root_Leaf_indicator is a 1xa (or ax1) vector indicating for each anchor if
%it is root (1) or leaf (2)
%non_anchor_node_names is a 1xm (or mx1) cell array listing the names of
%the nonanchor nodes, in the order they appear in data
%fname is the name of the output file that the function outputs
%Created in dir /Users/karensachs/Dropbox/Matlab/ALS/FromJohnny_to_Karen_Feb18
%Karen Sachs 2020
function Create_Anchor_Model_Input(data, Anchor_values, Anchor_names,Root_Leaf_indicator, non_anchor_node_names,fname)

%some of below taken from usePCSFprior_March21.m
nodes=non_anchor_node_names;
numgenes_thisBN=length(nodes);
num_samples=size(data,1);
num_Anchors = length(Anchor_names);

%% Create col headers
BNnodes=cell(1,numgenes_thisBN+num_Anchors);
%List Anchors
for i=1:num_Anchors
BNnodes{1,i}=Anchor_names{i};
end
%List nonanchor nodes
for i=1:numgenes_thisBN
    BNnodes{1,i+num_Anchors}=nodes{i};
end

%% Create input data
BLinput=[Anchor_values,data];

fid = fopen(fname,'w');
  
% Write the column headers
 for i=1:length(BNnodes)
    colname=BNnodes{i};
    fprintf(fid,'%s ',colname);
 end
 
%Write the data
dat=BLinput;
for i=1:size(dat,1);
    fprintf(fid,'\n');
    fprintf(fid,'%f\t',dat(i,:)); 
end
% Close the file
fclose(fid);









