#!/bin/bash

JUICERDIR="/your_W_DIR/scaffolding/juicer/00_juicer" 
VIZ_DIR="/your_W_DIR/scaffolding/juicer/01_3D-DNA/visualize/visualizations" 


if [[ $# -eq 0 ]] ; then
    echo "run with 3 arguments: assembly (full path) ; project name and enzime name. 
	Working directories are hardcoded as:
		$JUICERDIR
  	$VIZ_DIR" 
    exit 0
fi
 
module load SamTools/1.6 Python/2.7.5

ASSEMBLY=$1
PROJECT_NAME=$2
ENZYME=$3

ASSEMDIR="$(dirname $ASSEMBLY)"

cd $JUICERDIR ; mkdir projects

############### Preparation  #############################


mkdir projects/$PROJECT_NAME
 cd   projects/$PROJECT_NAME ; ln -s ../../fastq ; cd ../..

ln -s $ASSEMDIR references/$PROJECT_NAME

  	# Apply command1 if FILENAME exists and command2 if it doesn't! :
	# [ -e FILENAME] && command1 || command2

	 [ -e $ASSEMBLY\.bwt ] && echo "$ASSEMBLY has bwa index" ||  
	bwa index $ASSEMBLY     

	 [ -e $ASSEMBLY\.fai ] && echo "$ASSEMBLY has fai index" || 
	samtools faidx $ASSEMBLY


	cut -f1,2 $ASSEMBLY\.fai > references/$PROJECT_NAME\_ChrIDs.txt

#### Create restriction site positions file   ####

cd restriction_sites

 	[ -e $PROJECT_NAME\_$ENZYME\.txt  ] && echo " $PROJECT_NAME\_$ENZYME\.txt exists " ||  
	python2  ../misc/generate_site_positions.py $ENZYME $ASSEMBLY $PROJECT_NAME

cd ..

########   Running Juicer ###########

scripts/juicer.sh -S early -p references/$PROJECT_NAME\_ChrIDs.txt -g $PROJECT_NAME -x \
        -d $JUICERDIR/projects/$PROJECT_NAME \
        -z $ASSEMBLY  \
        -y restriction_sites/$PROJECT_NAME\_$ENZYME\.txt

######################################################## 3d-dna visualize #############################

module load SamTools/1.6 Python/2.7.5 Java/11.0.2 Parallel/20150422

cd $VIZ_DIR ; mkdir $PROJECT_NAME

cd $PROJECT_NAME; ln -s ../../../../00_juicer/projects/$PROJECT_NAME/aligned/merged_nodups.txt

#### Prepare assembly file

awk -f ../../../utils/generate-assembly-file-from-fasta.awk $ASSEMBLY > $PROJECT_NAME\.assembly

### Create heatmaps    # needs merged_nodups from juicer 
 ../../run-assembly-visualizer.sh $PROJECT_NAME\.assembly merged_nodups.txt
 
