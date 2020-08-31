#$ -S /bin/bash
#$ -cwd
#$ -e log
#$ -o log
#$ -l s_vmem=8G,mem_req=8G

############
# Settings #
############

SAMTOOLS="${HOME}/bin/samtools"
DIR="temp_pmctag"
MEM="2G"
TNUM=4
SAM=$1

##################################################
##################################################
echo 'pmctag start!'
date

rm -rf ${DIR} ### Garbage cleaning
mkdir ${DIR}  ### Creating TMP dir
cd ${DIR}     ### Move to working dir


#
### Merge all bam files
#
#echo "Convert SAM to BAM:"; date
#time ${SAMTOOLS} view -Sb ${SAM} > merged.bam

#
### Name sort
#
#echo "Name sort (${SGE_TASK_ID}):"
#time ~/bin/samtools sort -n -l 0 -m 2G -@ 4 -o nsorted.bam merged.bam

#
### Name collate
#
echo -e "\n\nName collate ..."; date
time ${SAMTOOLS} collate -u -@ ${TNUM} -o collated.bam ../${SAM} || exit $?

#
### Fixmate
#
echo -e "\nAdd ms and MC tags ...";date
time ${SAMTOOLS} fixmate -m collated.bam fixmate.bam || exit $?

#
### Position sort sam files
#
#echo -e "\nPosition sort:"; date
#time ${SAMTOOLS} sort -l 0 -m ${MEM} -@ ${TNUM} -o psorted.bam fixmate.bam

#
### Finalize
#
mv fixmate.bam ../
echo -e "\n\npmctag accomplished!"
#
### Markdup bam files
#
#echo "Markduplicate (${SGE_TASK_ID}):"
#time ~/bin/samtools markdup psorted.bam markdup.bam
