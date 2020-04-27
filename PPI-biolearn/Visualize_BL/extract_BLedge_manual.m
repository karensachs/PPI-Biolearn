%Apr 6 - quick iteration approach -manually parse and extract edges from
%one of the results files. This is 
% /Users/karensachs/Dropbox/Matlab/ALS/FromJohnny_to_Karen_Feb18 made spec file here, made data here, data lives here as well
% data: BL_LINCSpcsf_DS_G_CT_C9nodesMarch28_31.txt (earlier versions didnt work on BL bc there was a tab between variabe names, 
% smh)
% 
% Score BDe 10.0
% # Prior EdgePenalty fraction 0.99999 = 3.7142874041127385
% # data DataPointPerLine /Users/karensachs/Dropbox/Matlab/ALS/FromJohnny_to_Karen_Feb18/BL_LINCSpcsf_DS_G_CT_C9nodesMarch28_31.txt
% # Sample 1.0
% 
% ran here /Users/karensachs/Dropbox/Matlab/NIPS2017Biolearn 
% spec file: starterspec_SCAlg_2sidedConstraints.spec.txt
% nw file: pcsfLINCS_2sideconstr_SCAlg4set6.confidences
% 
% 
% 20 iters, allowing only LINCS PCSF edges, all else prob 0.

%cutting off at .7 confidence
%unfort have to convert edge names to indicies. so be it
% celltypenames={'CTsmi32'    'CTisl1'    'CTnkx6'    'CTtuj1'    'CTs100b'};

% G --> EIF1AY    100%
% SOX2 --- GPC4   100%
% RRM2 --- CDK1   100%
% CDK1 --- CDK2   100% (10% forward, 0% backward)
% ANXA1 --- S100A11       100% (10% forward, 0% backward)
% NCAPH --- NCAPG 95%
% COL1A1 --- SPARC        95% (30% forward, 0% backward)
% NCAPG --- SMC4  95%
% SP1 --- ELF1    90% (25% forward, 0% backward)
% CDK1 --- VIM    90% (10% forward, 0% backward)
% COL1A1 --- IGFBP3       85% (15% forward, 5% backward)
% TMED10 --- TMED2        85%
% PEX11B --- FIS1 80%
% COL1A1 --- FN1  80% (15% forward, 10% backward)
% FBN1 --- FN1    80% (20% forward, 10% backward)
% GBA --- LAMP1   80%
% YY1 --- GABPA   80%
% FBN1 --- TGFBI  75% (10% forward, 5% backward)
% BGN --- ELN     70% (5% forward, 0% backward)
% HSPG2 --- COL18A1       70%

 %assign the only anchor to be 398, bc 397 total nodes
load March21_edges_nodes_PCSFfromLINCS %nodes
%first edge/pilot:
findcol=strfind(nodes,'EIF1AY');
geneindex1=find(cellfun(@isempty,findcol)==0)
% nodes(geneindex1)

%manually extracted edge lsit
BLextracted_edges={'G' 'EIF1AY'
    'SOX2' 'GPC4'
'RRM2'   'CDK1'
'CDK1'   'CDK2'   
'ANXA1'   'S100A11'    
'NCAPH'   'NCAPG' 
'COL1A1'   'SPARC'       
'NCAPG'   'SMC4' 
'SP1'   'ELF1' 
'CDK1'   'VIM'  
'COL1A1'   'IGFBP3'       
'TMED10'   'TMED2'  
'PEX11B'   'FIS1' 
'COL1A1'   'FN1'
'FBN1'   'FN1' 
'GBA'   'LAMP1'
'YY1'   'GABPA'
'FBN1'   'TGFBI'
'BGN'   'ELN' 
'HSPG2'   'COL18A1'};
%intialize
edgelist_webweb=zeros(size(BLextracted_edges,1),2);
edgelist_webweb(1,:)=[398 geneindex1];
%fill edge_lsit
for i=2:length(BLextracted_edges)
    for col=1:2
        findcol=strfind(nodes,BLextracted_edges{i,col});%BDC_
        geneindex=find(cellfun(@isempty,findcol)==0);
        whichindex=0;
        if length(geneindex>1)
            for j=1:length(geneindex)
                nodes(geneindex(j))
                if strcmp(nodes(geneindex(j)),BLextracted_edges{i,col})
                    whichindex=j;
                    i
                    BLextracted_edges{i,col}
                    nodes(geneindex(j))
                end
            end
            edgelist_webweb(i,col)=geneindex(j);
        else
            edgelist_webweb(i,col)=geneindex;
        end
    end
end



% 
% struct4webweb_BLedges=struct('networks',edgelist_webweb);
% 
% struct('x',{'a','b'}) returns s(1).x = 'a' and s(2).x = 'b'.
% 

%% from ww example code for matlab https://webwebpage.github.io/docs/examples/add_node_names.html
% define a couple edges
edges = edgelist_webweb;

% [...
%     1,2;
%     2,3;...
%     ];
% Place the edges in a webweb struct called ww
ww.networks.network.edgeList = edges;

% Define some names in an array of cells containing strings
% names = {'Huberg','Pierot','Slartibertfast'};
names= nodes;
% Put the names in metadata with the special key "names"
ww.display.metadata.name.values = names;

% Call webweb
webweb(ww)


%% trying to color each gene&label
alphabeticallity = [1:398];
alphabeticallity_keys = names;%{'A-Z','a-z','W+;'};
ww.display.metadata.alphabeticallity.values = alphabeticallity;
ww.display.metadata.alphabeticallity.categories = alphabeticallity_keys;
webweb(ww)

%% coloring is only for a few categories so lets pick out our gene
nodes_in_BN=reshape(edges,size(edges,1)*2,1);
nodes_in_BN=unique(nodes_in_BN);
names_plus_G=names;
names_plus_G{398}='G';
names_in_BN=names_plus_G(nodes_in_BN);
%define nw
edges = edgelist_webweb;
edge_vector=reshape(edges,1,size(edges,1)*2);
%cant think of an elegant way to reindex the edges so they dont keep the
%original indexes/so they cut out the nodes that dont appear in the BN
%(???)
%So I'm doing it this longhand way
sorted=unique(sort(edge_vector));
reindexed_edges=zeros(size(edges));
for i=1:size(edges,1)
    reindexed_edges(i,1)=find(sorted==edges(i,1));
    reindexed_edges(i,2)=find(sorted==edges(i,2));
end

ww.networks.network.edgeList = reindexed_edges;
names= names_in_BN;

% Put the names in metadata with the special key "names"
ww.display.metadata.name.values = names;
% Call webweb
webweb(ww)



% alphabeticallity = 1:max(reindexed_edges);
% alphabeticallity_keys = names;%{'A-Z','a-z','W+;'};
% ww.display.metadata.alphabeticallity.values = alphabeticallity;
% ww.display.metadata.alphabeticallity.categories = alphabeticallity_keys;
% webweb(ww)

% alphabeticallity = [1:398];
% alphabeticallity_keys = names;%{'A-Z','a-z','W+;'};
% ww.display.metadata.alphabeticallity.values = alphabeticallity;
% ww.display.metadata.alphabeticallity.categories = alphabeticallity_keys;
% webweb(ww)



% % SOX2 --- GPC4   100%
% RRM2 --- CDK1   100%
% CDK1 --- CDK2   100% (10% forward, 0% backward)
% ANXA1 --- S100A11       100% (10% forward, 0% backward)
% NCAPH --- NCAPG 95%
% COL1A1 --- SPARC        95% (30% forward, 0% backward)
% NCAPG --- SMC4  95%
% SP1 --- ELF1    90% (25% forward, 0% backward)
% CDK1 --- VIM    90% (10% forward, 0% backward)
% COL1A1 --- IGFBP3       85% (15% forward, 5% backward)
% TMED10 --- TMED2        85%
% PEX11B --- FIS1 80%
% COL1A1 --- FN1  80% (15% forward, 10% backward)
% FBN1 --- FN1    80% (20% forward, 10% backward)
% GBA --- LAMP1   80%
% YY1 --- GABPA   80%
% FBN1 --- TGFBI  75% (10% forward, 5% backward)
% BGN --- ELN     70% (5% forward, 0% backward)
% HSPG2 --- COL18A1       70%


%% color example from ww https://webwebpage.github.io/docs/examples/add_node_metadata_categorical.html
% define a couple edges - thsi works in CHROME
% edges = [...
%     1,2;
%     2,3;...
%     ];
% % place the edges in a webweb struct called ww
% ww.networks.network.edgeList = edges;
% 
% % Define categorical metadata sets in TWO different ways
% % 1. Categories defined by integers with a set of integer-assigned keys
% alphabeticallity = [1,2,3];
% alphabeticallity_keys = {'A-Z','a-z','W+;'};
% ww.display.metadata.alphabeticallity.values = alphabeticallity;
% ww.display.metadata.alphabeticallity.categories = alphabeticallity_keys;
% % 2. Categories defined directly by strings
% cooperativity = {'high','medium','low'};
% ww.display.metadata.cooperativity.values = cooperativity;
% 
% % BONUS: ask webweb to default to present colors by alphabeticallity
% % This assignment simply needs to match the key of the metadata above.
% ww.display.colorBy = 'alphabeticallity';
% 
% % call webweb
% webweb(ww);
