# AgalychnisUCE
Agalychnis (tree frog) UCE analyses

# Data
UCE data were generated by RAPiD Genomics. I obtained a copy of the data, which are stored here:

`/uufs/chpc.utah.edu/common/home/gompert-group4/data/UCE_data`

This includes UCE data for 66 individiuals (a few were miss-labeled, see notes below).

I used archived UCE data to create a reference UCE file for alignment. This is in `/uufs/chpc.utah.edu/common/home/gompert-group4/data/UCE_data/Reference`, and was indexed with `samtools` (version 1.16) and `bwa` (version 0.7.17-r1198-dirty). 

```{bash}
cd /uufs/chpc.utah.edu/common/home/gompert-group4/data/UCE_data/Reference
samtools faidx CleanUCE.fasta
bwa index CleanUCE.fasta
```
