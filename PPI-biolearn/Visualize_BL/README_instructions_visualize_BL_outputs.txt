Once you have a BLoutput (a confidence file, though it is also possible to visualize an individual network), you can extract the edges and then run the commands below to visualize the network using webweb.

open Vis_extracted_BLedges.m
It is set up to run on a result from the LINCS PCSF constrained network, using the day 32 100 lines RNA seq data. The cutoff used was 0.7, and the anchors used were disease state, C9ORF, gender and cell type fractions. You can visualize this result or load edges extracted from a different result file using the desired confidence cutoff.

If not using the defaults, load your nodes and extracted edges files. 
Default edge file is: March21_edges_nodes_PCSFfromLINCS 
Default edge list is 
BLextracted_edges=
Edge list looks like this:
{'G' 'EIF1AY'
    'SOX2' 'GPC4'...}

Select remaining options to run desired commands from the script (colors, node names, etc).
