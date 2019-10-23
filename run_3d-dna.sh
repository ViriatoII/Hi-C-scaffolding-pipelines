

project="project_name"   # same name as used in run_juicer.sh 


# enter the folder where you installed 3d-dna. Create a projects sub-folder
cd /......../scaffolding/juicer/01_3D-DNA/projects

mkdir $project ; cd $project

        #this .fa needs to be edited depending on folder
../../run-asm-pipeline.sh  --editor-repeat-coverage 3  --sort-output -i 12000 \
 ../../../00_juicer/references/$project/*2.fa \
 ../../../00_juicer/projects/$project/aligned/merged_nodups.txt # --build-gapped-map -r 10 # -i 10000  (rounds and min contig len) 


##########################################################################
###                                                                     ##
###                             BUSCO                                   ##
##########################################################################


module unload SamTools/1.6 Java/11.0.2 Python/2.7.5

module load Augustus/3.3.2 BLAST+/2.2.29 HMMER/3.1b1 Busco/3.1.0


INPUT="*final.fasta"
LIN="/...../busco/solanaceae_odb10" # edit with the path to your busco lineage datasets
      # you must download them from here: https://busco.ezlab.org/datasets/prerelease/*.tar.gz


run_BUSCO.py -c 24 --in $INPUT --out BUSCO_results \
--lineage_path $LIN \
--mode genome --tmp_path ./scratch/

wait


