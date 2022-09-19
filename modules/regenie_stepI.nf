#!/bin/bash nextflow
//nextflow.enable.dsl=2

process REGENIE_STEP_1 {
    
    // Process directives
    cpus 16
    memory { 4.GB * params.phenotype_list.split(',').size() }
    executor 'slurm'
    queue 'amd'
    time '48h'
    
    publishDir "${params.outdir}/${params.prefix}/STEP1", mode:'copy',\
		pattern: "${params.prefix}*"
    publishDir "${params.outdir}/${params.prefix}/logs", mode:'copy',\
		pattern:  ".command.out", saveAs: { filename -> "$params.prefix-step1.out" }
    publishDir "${params.outdir}/${params.prefix}/STEP1", mode:'copy',\
		pattern:  ".command.sh", saveAs: { filename -> "$params.prefix-step1.sh" }

    // Input data
    input:
    tuple val(pgen_id), path(pgen_file)
    file phenotype_file
    file covariate_file

    // Output data
    output:
    tuple path ("${params.prefix}_pred.list"), path ("${params.prefix}*.loco.gz")
    path ".command.out"
    path ".command.sh"

    shell:
    '''
    module load broadwell/regenie/2.2.4

    regenie \
    --step 1 \
    --pgen !{pgen_id} \
    --phenoFile !{phenotype_file} \
    --phenoColList !{params.phenotype_list} \
    --covarFile !{covariate_file} \
    --covarColList !{params.covariate_list} \
    --use-relative-path \
    --bsize 1000 \
    --lowmem \
    --apply-rint \
    --lowmem-prefix !{params.prefix}_tmp_rg \
    --gz \
    --threads !{task.cpus} \
    --out !{params.prefix} \

    '''
}
