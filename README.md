# BioNano-Irys-tools
tools to work with BioNano Irys optical maps (cmaps)  

Bash (zsh) script to pick cmaps (by ID) from a multi-cmap file and invert (flip) selected. Then create a fused cmap from these (e.g. a chromosome). selected (incl flipped) cmaps are stored separately as well.  

#run cmap_pick_flip_merge.sh  
./cmap_pick_flip_merge.sh MAPIDs.lst GAPSIZE NEWID INCMAP.cmap OUTPREFIX  

# MAPIDs.lst  
#file containing list of cmap ID's to pick and/or flip (flip if negative) from a main optical.genome.assembly.cmap  
#one entry per line, last line will not be used, thus leave as empty line  
#eg fuse/orientate cmap-optical-contig 185+249+7+15+945 and turn around the contig 185,15 and 945  
-185  
249  
7  
-15  
-945  

# GAPSIZE  
#gap to be used between two adjacent cmaps [bp]  
#eg 50kb  
50000  

# NEWID  
#ID [integer] for fused cmap (output), means cmap-ID within the cmap file
#eg 1 [as in LG1 or chr1]
1

# INCMAP.cmap
#CMAP (v0.1) file containing multiple cmaps (optical_genome.cmap; input), ie the file from which the individuals cmaps are picked
#if specific GAP-sizes for a specific location are needed, then add cmap entry to this cmap (with unique new ID) and adjust the MAPIDs.lst accordingly to incorporate a specific cmap-contig (which is empty=gap). Take into consideration that the general GAPSIZE is applied everywhere (also between contig and gap-contig), ie potentially adjust the size of the gap accordingly.
#eg Sinv_bigB.cmap
Sinv_bigB.cmap

# OUTPREFIX
#Prefix used for output files
#eg LG1
LG1

# Example
#command, e.g. to contruct an optical chromosome 1 (LG1) from all optical contigs known to be on LG1 and in their respective order / orientation

#files in folder
#ls -1
cmap_pick_flip_merge.sh
Sinv_bigB_all_unplaced_cmaps.lst
Sinv_bigB.cmap
Sinv_LG10.lst
Sinv_LG11.lst
Sinv_LG12.lst
Sinv_LG13.lst
Sinv_LG14.lst
Sinv_LG15.lst
Sinv_LG16.lst
Sinv_LG1.lst
Sinv_LG2.lst
Sinv_LG3.lst
Sinv_LG4.lst
Sinv_LG5.lst
Sinv_LG6.lst
Sinv_LG7.lst
Sinv_LG8.lst
Sinv_LG9.lst

#command
i=1
./cmap_pick_flip_merge.sh Sinv_LG$i.lst 50000 $i Sinv_bigB.cmap Sinv_bigB.$i


# output
#output on screen
Output-Prefix: Sinv_bigB.1
Length: 35181254.2 bp

#output as files
Sinv_bigB.1_cumCoord.list
Sinv_bigB.1_diff.list
Sinv_bigB.1_fused.cmap
Sinv_bigB.1_selected.cmap

#what are these files?
Sinv_bigB.1_cumCoord.list
coordinates of optical markers in the new, fused cmap

Sinv_bigB.1_diff.list
temporary file listing the distances beween the optical markers in the cmaps. This is then used to calculate the new coordinates in the fused cmap

Sinv_bigB.1_fused.cmap
contains the picked/flipped cmaps as fused, single new cmap (including the gaps) with the new ID and new coordinates

Sinv_bigB.1_selected.cmap
contains the picked/flipped cmaps

##create new whole_genome.cmap
#run the above command for each chromosome/LG
#for the unplaced contigs, simply run the same command (using some unique arbitrary value/string as new ID) and use the resulting $OUTPREFIX_selected.cmap to get all the unplaced contigs into a separate file
i=unplaced
./cmap_pick_flip_merge.sh Sinv_bigB_all_unplaced_cmaps.lst 50000 $i Sinv_bigB.cmap Sinv_bigB_unplaced

#concatenate the cmaps (be aware of numerical sorting issues)
ls -1 Sinv_bigB.{1..9}_fused.cmap
ls -1 Sinv_bigB.{10..16}_fused.cmap

cat Sinv_bigB.{1..9}_fused.cmap > Sinv_bigB_whole_genome_in_LGs.cmap
cat Sinv_bigB.{10..16}_fused.cmap >> Sinv_bigB_whole_genome_in_LGs.cmap

#unplaced optical-contigs are in: Sinv_bigB_unplaced_selected.cmap (beware of cmap-contig-IDs which are overlapping with the new IDs in the *_fused.cmap


