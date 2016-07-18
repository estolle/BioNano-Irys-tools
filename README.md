# BioNano-Irys-tools
tools to work with BioNano Irys optical maps (cmaps)

Bash (zsh) script to pick cmaps (by ID) from a multi-cmap file and invert (flip) selected. Then create a fused cmap from these (e.g. a chromosome). selected (incl flipped) cmaps are stored separately as well.

run cmap_pick_flip_merge.sh
 ./cmap_pick_flip_merge.sh MAPIDs.lst GAPSIZE NEWID INCMAP.cmap OUTPREFIX 
 
mapIDs.lst: List if CMAP IDs to pick (and/or) flip and then merge into cumulative cmap\n1 ID per line, negative numbers indicate IDs to be flipped

Example: 

file mapIDs.lst
-189
257
-4
12

--> last entry (line) will not be selected (leave empty or use any number - it worked for me using any cmap number)


gapsize: size (bp) of the gap between cmaps when fusing them into single molecule, e.g. 50000 [bp]

new ID for fused cmap [integer]

in.cmap: CMAP file containing multiple cmaps (v 0.1)

OUTPREFIX: Prefix used for output files

Output on terminal: 
OUTPREFIX_fused.cmap 
cumulativwe length

