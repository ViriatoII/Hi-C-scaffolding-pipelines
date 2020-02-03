# Hi-C-scaffolding-pipelines
I'm sharing my automation of the Juicer/3D_DNA and SALSA Hi-C scaffolding pipelines.


## Juicer 

Juicer maps HiC reads to an input assembly. Use:  
  
  `run_juicer.sh  < input_assembly.fasta > < project name >`
  
You need to edit the following variables with your own directory of installed juicer and 3D-DNA:            

  `JUICERDIR="/../scaffolding/juicer/00_juicer"`           
  `VIZ_DIR="/../scaffolding/juicer/01_3D-DNA/visualize/visualizations"`      

You also need to create a folder called fastq in 00_juicer with the soft links of HiC_R1.fastq and HiC_R2.fastq.

## 3D-DNA
You can scaffold the resulting Juicer project with 3D-DNA. Use:        

  `run_3d-dna.sh < project name >`
 
