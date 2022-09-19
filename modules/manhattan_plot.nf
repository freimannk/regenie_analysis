#!/bin/bash nextflow 


process MANHATTAN_PLOT {
    cpus 16
    memory '12 GB'
    time '10m'
        
    publishDir "${params.outdir}/${params.prefix}/Manhattan_plots", mode: 'move', pattern: "*.png"
    publishDir "${params.outdir}/${params.prefix}/logs", mode:'copy',\
                pattern: ".command.out", saveAs: { filename -> "$phenotype_id-Manhattan_plots.out" }
    
    input:
    tuple val(phenotype_id), path(regenie_out)

    output:
    path "*.png"
    path ".command.out"

    shell:
    '''
    module load any/R/4.1.2-X
    Rscript /gpfs/space/home/ida/Nextflow_training/bin/Manhattan_plot.R \
  --file !{regenie_out} \
  --phenotype_id !{phenotype_id} \
  --out !{phenotype_id} 
    '''
}

