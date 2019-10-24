# Hi-C-scaffolding-pipelines
I'm sharing my automation of the Juicer/3D_DNA and SALSA Hi-C scaffolding pipelines.

Juicer maps HiC reads to an input assembly. Use:       
`run_juicer.sh  < input_assembly.fasta > < project name >`
  
You need to edit the following variables with your own directory of juicer and 3D-DNA:            
`JUICERDIR="/../scaffolding/juicer/00_juicer"`           
`VIZ_DIR="/../scaffolding/juicer/01_3D-DNA/visualize/visualizations"              `        


You can scaffold the resulting Juicer project with 3D-DNA. Use:
`run_3d-dna.sh < project name >`
  
