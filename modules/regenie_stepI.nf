#!/bin/bash nextflow
//nextflow.enable.dsl=2

process REGENIE_STEP_1 {
    container = 'quay.io/eqtlcatalogue/regenie:v3.2.1'

    input:
    file bgen_file
    file sample_file
    file phenotype_file
    val phenotype_id  
    file covariate_file

    output:
    val phenotype_id
    path "*_pred.list"
    file "*.loco.gz"
    path ".command.out"
    path ".command.sh"


    shell:
    '''
    regenie \
    --step 1 \
    --bgen !{bgen_file} \
    --sample !{sample_file} \
    --ref-first \
    --phenoFile !{phenotype_file} \
    --phenoColList !{phenotype_id} \
    --covarFile !{covariate_file} \
    --covarColList !{params.covariate_list} \
    --use-relative-path \
    --bsize 1000 \
    --lowmem \
    --apply-rint \
    --lowmem-prefix !{phenotype_id}_tmp_rg \
    --gz \
    --threads !{task.cpus} \
    --out !{phenotype_id} \

    '''
}
