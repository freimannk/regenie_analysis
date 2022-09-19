#!/bin/bash nextflow
nextflow.enable.dsl=2

// Importing modules
include { REGENIE_STEP_1 } from './modules/regenie_stepI'
include { REGENIE_STEP_2 } from './modules/regenie_stepII'
include { MANHATTAN_PLOT } from './modules/manhattan_plot'

// Workflow
workflow {
    pgen_step1_ch = Channel.fromFilePairs(params.step1_pgen, size : 3)
    phenotype_ch = Channel.fromPath(params.phenotype_file)
    covariate_ch = Channel.fromPath(params.covariate_file)
    
    REGENIE_STEP_1(pgen_step1_ch, phenotype_ch, covariate_ch)
    
    pgen_step2_ch = Channel.fromFilePairs(params.step2_pgen, size : 3)
    
    // Modifying the regenie step I output by combining the pred_list and loco files
    list_file = REGENIE_STEP_1.out[0].map { list_file , loco_files ->
                                            list_file
                                          }

    loco_files = REGENIE_STEP_1.out[0].map { list_file , loco_files ->
                                            loco_files
                                           }.flatten()

    combined_file = list_file.combine(loco_files)
        
    // Creating the regenie step II input channel
    pre_ch = pgen_step2_ch.combine(combined_file)
    pre_ch2 = pre_ch.combine(phenotype_ch)
    step2_ch  = pre_ch2.combine(covariate_ch).map { pgen_id, pgens, list, gz, phenotypes, covariates ->
                                                    tuple(pgen_id, tuple(pgens, list, gz, phenotypes, covariates).flatten())
                                                  } 

    REGENIE_STEP_2(step2_ch)
    
    MANHATTAN_PLOT(REGENIE_STEP_2.out[0])    
}
