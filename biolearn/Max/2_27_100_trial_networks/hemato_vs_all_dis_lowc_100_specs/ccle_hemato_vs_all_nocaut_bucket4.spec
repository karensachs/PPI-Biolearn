DefaultNetworkName ccle_hemato_vs_all_nocaut_bucket4
Score BDe 10.0
DiscretizationBuckets 4 HARD BYDISTANCE
algorithm GreedyHillClimbing 5
data DataPointPerLine /nfs/latdata/max/disease_causality/hemato_vs_all_data/ccle_hemato_vs_all_nocaut.txt
sample .9
numruns 100
confidencethreshold 20
columnStatusFile /nfs/latdata/max/disease_causality/dis_status/dis_root_colstatus.txt
constraint ParentMaximum 3
Prior EdgePenalty Fraction .99999
