%March 2020
%Using the PCSF network obtained from the LINCS data, we constrain the BN
%learning from the d32 RNA data (protein not yet available at this point,
%will be added). In this instantiation, we allow only edges from the PCSF
%to be learned in the BN. Therefore, edges not in the PCSF output have
%probability zero & are forbidden.

% we will use spec_PPIconstrained.m:

% spec_PPIconstrained creates a spec file which Biolearn will apply to create a PPI-constrained network.
%The spec file (biolearn.spec) created by this program should be in the same directory when biolearn is run. If biolearn is run in Interactive Mode, it is also possible to browse to access the spec file.
% As input, this program accepts ppi, a 2 column matrix indicating all
% pairs of PPI edges,
% It also accepts as input a networkname (text string),filelist, a textfile listing
%the list of data files, and variable_names, a list of variables in the
%order they appear in the data array(s)
%Karen Sachs 2019
% function [Specfilename] = spec_PPIconstrained(networkname,filelist,variable_names);
load edges_LINCSpcsf %edges
load nodes_LINCSpcsf %nodes
load edgesindexed_LINCSpcsf %edgesIndexed
networkname='pcsfLINCS_constrained_BN';
filelist='BL_LINCSpcsf_DS_G_CT_C9nodesMarch28.txt'; %d32 RNA data
variable_names=nodes;
ppi=edgesIndexed;
[Specfilename] = spec_PPIconstrained_v2(networkname,filelist,variable_names,ppi);

% fid = fopen('hello.txt', 'a+');