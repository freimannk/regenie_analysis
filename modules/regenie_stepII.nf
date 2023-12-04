#!/bin/bash nextflow
//nextflow.enable.dsl=2

process REGENIE_STEP_2 {
    container = 'quay.io/eqtlcatalogue/regenie:v3.2.1'


    publishDir "${params.outdir}/${params.prefix}/STEP2/regenie", mode:'copy',\
		pattern: "*.regenie*"
     
    
    input:
    file bgen_file
    file sample_file
    val phenotype_id 
    file pred_list 
    file phenotype_file
    file covariate_file
    file loco
    
    output:
    tuple val(phenotype_id), path("*.regenie*")
    path "*.log"
    
    shell:         
    '''
    regenie \
    --step 2 \
    --bgen !{bgen_file} \
    --sample !{sample_file} \
    --ref-first \
    --phenoFile !{phenotype_file} \
    --phenoColList !{phenotype_id} \
    --covarFile !{covariate_file} \
    --covarColList !{params.covariate_list} \
    --bsize 1000 \
    --apply-rint \
    --threads !{task.cpus} \
    --pred !{pred_list} \
    --gz \
    --out "!{params.prefix}+++"\
    '''
}
