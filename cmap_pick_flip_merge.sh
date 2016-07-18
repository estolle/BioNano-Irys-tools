#!/bin/zsh
if [ $# -ne 5 ]; then
    echo $0: usage: ./cmap_pick_flip_merge.sh MAPIDs.lst GAPSIZE NEWID INCMAP.cmap OUTPREFIX 
	echo "\nmapIDs.lst: List if CMAP IDs to pick (and/or) flip and then merge into cumulative cmap\n1 ID per line, negative numbers indicate IDs to be flipped\n\nExample: file mapIDs.lst\n-189\n257\n-4\n12"
	echo "\ngapsize: size (bp) of the gap between cmaps when fusing them into single molecule, e.g. 50000"
	echo "\nnew ID for fused cmap [integer]"
	echo "\nin.cmap: CMAP file containing multiple cmaps (v 0.1)"
	echo "\nOUTPREFIX: Prefix used for output files"
	echo "\nOutput: picked/flipped cmaps in a multi cmap file (OUTPREFIX_selected.cmap)\ncumulative cmap file with concatenated cmaps(OUTPREFIX_fused.cmap)\nlist of distances to the previous marker (OUTPREFIX_diff.lst)\ncumulative coordinates (OUTPREFIX_cumcoord.lst)"
    exit 1
fi

MAPLST=$1
GAP=$2
NEWID=$3
CMAPS=$4
OUTFILE=$5


#echo "\n"
#echo "$(date +%Y-%m-%d) $(date +%H:%M)"
#echo "picking, flipping, fusing CMAPs"
#echo "List of MapIDs: $MAPLST"
#echo "Gapsize (bp): $GAP"
#echo "new cmap ID (for fused cmap): $NEWID"
#echo "CMAPs: $CMAPS"
echo "Output-Prefix: $OUTFILE"


#echo "extracting (flipping if negative) cMapIDs"
rm -f $OUTFILE'_selected'.cmap
cat $MAPLST | while read MAPID;do
if [ $MAPID -lt 0 ]
then
cat $CMAPS | grep -w "^$(echo ${MAPID} | tr -d -)" - | \
awk -F ' ' 'BEGIN {OFS = " ";} {print $1,$2,$3,$3-($4-1),$5,$2-$6,$7,$8,$9;}' | tac | \
awk 'FNR==1{$6=$2;$4=$3+1}1' | awk 'NR==1 {a=$0; next} 1; END{print a}' | tr -s " " "\t" >> $OUTFILE'_selected'.cmap
else
  cat $CMAPS | grep -w "^$MAPID" - >> $OUTFILE'_selected'.cmap
fi
done

#echo "maps selected/flipped ..."

COUNT=$(wc -l $OUTFILE'_selected'.cmap | cut -d' ' -f 1) 

cat $OUTFILE'_selected'.cmap | awk -v z=$GAP -F "\t" 'BEGIN {OFS = "\t"; print 'x20';} {print $6;}' | awk 'NR-1{print $0-p}{p=$0}' | awk '/^-.*/{gsub(/.*/, z)};{print}' > $OUTFILE'_diff'.list
cat $OUTFILE'_diff'.list | awk 'BEGIN {sum=0} {sum= sum+$0; printf("%.1f\n",sum)}' > $OUTFILE'_cumCoord'.list

LENGTH=$(tail -1 $OUTFILE'_cumCoord'.list)
cat $OUTFILE'_selected'.cmap | awk -v x=$COUNT -v y=$LENGTH -v w=$NEWID -F "\t" 'BEGIN {OFS = "\t";} {print w,y,x-1,NR,1,$6,$7,$8,$9;}' | tac | \
awk 'FNR==1{$5=0;}1' | tr -s " " "\t" | tac > $OUTFILE.tmp
awk 'FNR==NR{a[NR]=$1;next}{$6=a[FNR]}1' $OUTFILE'_cumCoord'.list $OUTFILE.tmp | tr -s " " "\t" > $OUTFILE'_fused'.cmap

#echo "maps fused ... done"
echo 'Length: '$(tail -1 $OUTFILE'_fused'.cmap | cut -f 2)' bp'

rm -f $OUTFILE.tmp
#echo "files:\n$OUTFILE""_selected.cmap\n$OUTFILE""_diff.list\n$OUTFILE""_cumcoord.list\n$OUTFILE""_fused.cmap" &&  echo "\ndone\n"
