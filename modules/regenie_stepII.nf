#!/bin/bash nextflow
//nextflow.enable.dsl=2

process REGENIE_STEP_2 {

    // Process directives
    cpus 16
    memory '4 GB'
    executor 'slurm'
    queue 'amd'
    time '4h'
    

    publishDir "${params.outdir}/${params.prefix}/STEP2/regenie", mode:'copy',\
		pattern: "*.regenie*"
    publishDir "${params.outdir}/${params.prefix}/logs", mode:'copy',\
		pattern:  "*.log"
     
    
    // Input data    
    input:
    tuple val(pgen_id), path(files)
    
    // Output data
    output:
    tuple env(phenotype_id), path("*.regenie*")
    path "*.log"
    
    shell:
    phenotype_file = files.find { it.toString().matches('phenotype_file.*') }
    covariate_file = files.find { it.toString().matches('covariate_file.*') }

    pgen_file = files.find { it.toString().endsWith '.pgen' }
    psam_file = files.find { it.toString().endsWith '.psam' }
    pvar_file = files.find { it.toString().endsWith '.pvar' }
    loco_file = files.find { it.toString().matches('.*loco.*') }
    pred_list = files.find { it.toString().endsWith '.list' }
         
    '''
    module load broadwell/regenie/2.2.4

    phenotype_id="`grep !{loco_file}  !{pred_list} | cut -f 1 --d " "`"
   
    regenie \
    --step 2 \
    --pgen !{pgen_id} \
    --phenoFile !{phenotype_file} \
    --phenoColList ${phenotype_id} \
    --covarFile !{covariate_file} \
    --covarColList !{params.covariate_list} \
    --bsize 1000 \
    --apply-rint \
    --threads !{task.cpus} \
    --pred !{pred_list} \
    --gz \
    --out pheno \

    '''
}
