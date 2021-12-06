ftoread = 'allele_counts_in_all_individuals_with_extras.csv';
fid = fopen(ftoread);
fgetl(fid) %reads line but does nothing with it
% fgetl(fid)
% fgetl(fid)
M = textscan(fid, '%f', 'Delimiter',','); % you will need to change the number   of values to match your file %f for numbers and %s for strings.
fclose (fid)