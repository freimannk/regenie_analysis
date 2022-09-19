# Regenie-Nextflow-pipeline

**[Regenie](https://rgcgithub.github.io/regenie/) example workflow**
-	Analysing multiple phenotypes at the same time
-	Using quantitative traits
-	Outputting the results as one zip file for each phenotype
-	Producing Manhattan plot for each phenotype

**Mandatory input parameters in nextflow.config file**
- params.step1_pgen : pgen files.{pgen,psam,pvar} for step 1
- params.step2_pgen : pgen files.{pgen,psam,pvar} for step 2
- params.phenotype_file : phenotypes file , for more details about the format, review regiene [documentations](https://rgcgithub.github.io/regenie/options/)
- params.phenotype_list : comma separated list of phenotypes to include in the analysis
- params.covariate_file  : covariates file , for more details about the format, review regiene [documentations](https://rgcgithub.github.io/regenie/options/)
- params.covariate_list : comma separated list of covariates to include in the analysis
- params.outdir : directory of the output
- params.prefix : name of the root output file
  
