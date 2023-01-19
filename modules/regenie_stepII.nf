#!/bin/bash nextflow
//nextflow.enable.dsl=2

process REGENIE_STEP_2 {
    container = 'quay.io/eqtlcatalogue/regenie:v3.2.1'


    publishDir "${params.outdir}/${params.prefix}/STEP2/regenie", mode:'copy',\
		pattern: "*.regenie*"
    //publishDir "${params.outdir}/${params.prefix}/logs", mode:'copy',\
		//pattern:  "*.log"
     
    
    // Input data     
    input:
    //tuple val(pgen_id), path(pgen_file)
    file bgen_file
    file sample_file
    val phenotype_id //0
    file pred_list //1
    path loco_file //2
    file phenotype_file
    file covariate_file   
    
    // Output data
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
    --out !{params.prefix} \
    '''
}
