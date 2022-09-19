#!/bin/bash nextflow
nextflow.enable.dsl=2

// Importing modules
include { REGENIE_STEP_1 } from './modules/regenie_stepI'
include { REGENIE_STEP_2 } from './modules/regenie_stepII'
include { MANHATTAN_PLOT } from './modules/manhattan_plot'

// Workflow
workflow {
    pgen_step1_ch = Channel.fromFilePairs(params.step1_pgen, size: 3).collect()
    phenotype_ch = Channel.fromPath(params.phenotype_file).collect()
    covariate_ch = Channel.fromPath(params.covariate_file).collect()
    
    REGENIE_STEP_1(pgen_step1_ch, phenotype_ch, covariate_ch)
    
    pgen_step2_ch = Channel.fromFilePairs(params.step2_pgen, size: 3).collect()
    pred_list_ch = REGENIE_STEP_1.out[0]
    pheno_id_ch = pred_list_ch.splitCsv(sep: ' ')
    loco_file_ch = REGENIE_STEP_1.out[1].flatten().map { loco_file -> 
                                                         tuple(loco_file, loco_file.name).collect()
                                                       }
    pheno_loco_ch = pheno_id_ch.join(loco_file_ch, by: 1).map { name, pheno_id, loco_file ->
                                                                tuple(pheno_id, loco_file)
                                                              }
    
    REGENIE_STEP_2(pgen_step2_ch, pred_list_ch, pheno_loco_ch, phenotype_ch, covariate_ch)
   
    MANHATTAN_PLOT(REGENIE_STEP_2.out[0])    
}

