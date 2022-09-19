#!/bin/bash nextflow
nextflow.enable.dsl=2

// Importing modules
include { REGENIE_STEP_1 } from './modules/regenie_stepI_simple'
include { REGENIE_STEP_2 } from './modules/regenie_stepII_simple'
include { MANHATTAN_PLOT } from './modules/manhattan_plot'

// Workflow
workflow {
    pgen_step1_ch = Channel.fromFilePairs(params.step1_pgen, size: 3).collect()
    phenotype_id_ch = Channel.from(params.phenotype_list.split(','))
    phenotype_ch = Channel.fromPath(params.phenotype_file).collect()
    covariate_ch = Channel.fromPath(params.covariate_file).collect()
    
    REGENIE_STEP_1(pgen_step1_ch, phenotype_id_ch, phenotype_ch, covariate_ch)
    
    pgen_step2_ch = Channel.fromFilePairs(params.step2_pgen, size: 3).collect()
    
    REGENIE_STEP_2(pgen_step2_ch, REGENIE_STEP_1.out[0], REGENIE_STEP_1.out[1], REGENIE_STEP_1.out[2],\
                   phenotype_ch,  covariate_ch)
   
    MANHATTAN_PLOT(REGENIE_STEP_2.out[0])    
}

