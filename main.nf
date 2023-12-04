#!/bin/bash nextflow
nextflow.enable.dsl=2

include { REGENIE_STEP_1 } from './modules/regenie_stepI'
include { REGENIE_STEP_2 } from './modules/regenie_stepII'
include { ONLY_REGENIE_STEP_2 } from './modules/only_regenie_stepII'


workflow step2_only {
   sample_ch = Channel.fromPath(params.sample).collect()
   phenotype_ch = Channel.fromPath(params.phenotype_file).collect()
   covariate_ch = Channel.fromPath(params.covariate_file).collect()
   Channel
       .fromPath(params.included_phenotype_ids)
       .splitText().map{it -> it.trim()}
       .set{phenotype_list_ch} 
   bgen_step2_ch = Channel.fromPath(params.step2_bgen).collect()
   ONLY_REGENIE_STEP_2(bgen_step2_ch, sample_ch, phenotype_list_ch,\
                   phenotype_ch,  covariate_ch)
    
} 


workflow {
    bgen_step1_ch = Channel.fromPath(params.step1_bgen).collect()
    sample_ch = Channel.fromPath(params.sample).collect()

    Channel
       .fromPath(params.included_phenotype_ids)
       .splitText().map{it -> it.trim()}
       .set{phenotype_list_ch} 

    phenotype_ch = Channel.fromPath(params.phenotype_file).collect()
    covariate_ch = Channel.fromPath(params.covariate_file).collect()
    
    REGENIE_STEP_1(bgen_step1_ch, sample_ch,  phenotype_ch, phenotype_list_ch, covariate_ch)

    
    bgen_step2_ch = Channel.fromPath(params.step2_bgen).collect()

    
    REGENIE_STEP_2(bgen_step2_ch, sample_ch, REGENIE_STEP_1.out[0], REGENIE_STEP_1.out[1],\
                   phenotype_ch,  covariate_ch, REGENIE_STEP_1.out[2])
    
}

