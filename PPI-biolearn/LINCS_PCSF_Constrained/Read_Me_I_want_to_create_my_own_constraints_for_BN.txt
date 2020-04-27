This file gives instructions on running BL by constraining on any network, and/or parts of the PCSF model, by creating one's own spec file to constrain edges. Note that this is essentially a wrapper for spec_PPIconstrained_v2.m
You can choose to run spec_PPIconstrained_v2.m directly instead of using the instructions below, the below is more detailed and by default set up to run with the PCSF constraints from the LINCS model (day 18data).

The PCSF model comes from Ernest Fraenkel's lab at MIT, and was created by Johnny Li in 2019. The data is from day 18 diMNs.

Folder Contents:
PCSF model:
W_1.00_B_2.00_G_4.50.robust_network.graphml
Script to extract nodes and edges in csv or text files:
extract_edges_fromPCSF.py
Also on colab:
https://colab.research.google.com/drive/1WfYYPBUrA_iq0mRAV-kNIrjIIMjg_28p
Edges as csv:
extracted_edges_PCSFgraphml.csv (Note: the 2 csv files are identical)
Data in BL friendly format: (Day 32 iMNs, note these are not the same as the input to the PCSF model)
Input_Data_100Lines_BL_LINCSpcsf_DS_G_CT_C9nodesMarch28_31.txt
Spec file with constraints (allowing only PCSF edges): LINCS_PCSF_constrained.spec.txt
Using the Sparse Candidate Algorithm (constraines search based on minimal correlation among tuples, faster and more restricted search s\
pace): LINCS_PCSF_constrained_SCAlg.spec.txt
Script for making spec files: 
make_spec_pscfLINCS.m


Instructions:
Open make_spec_pscfLINCS.m 
Select fields to edit (all optional) - it is set up to run with all the PCSF model constraints. 
If you have an alternate set of edges to apply in the constraints, load them instead of the defaults.
After you choose all the parameters, save the changes and run make_spec_pcsf_LINCS 
Run BL (this is the GUI version for unix/MAC OSX, but similar to Windows version, please see BL manual) by typing ./BiolearnInteractive\
Run.sh ./
Choose the spec file based on the spec file you chose in the previous step. Defaul;t setting is constrained.spec.txt
Choose GUI options (optional)
Note that nodes to ignore or constrain can be specified in the GUI to be saved to columnstatus file. See also the Anchornodes directory\
 in the main PPI_BL folder.

Load data file of your choosing. The default is Input_Data_100Lines_BL_LINCSpcsf_DS_G_CT_C9nodesMarch28_31.txt, which containrs the RNS seq data from the day 32 100 lines. (Not that because some of the lines were used a controls and therefore repeated, the number of samples is reduced to 63 als (10 C9ORF) and 23 controls.

Press "Run"
