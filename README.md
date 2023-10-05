# Regenie-Nextflow-pipeline for QTL analysis

**[Regenie](https://rgcgithub.github.io/regenie/) example workflow**
-	Analysing multiple phenotypes at the same time
-	Using quantitative traits
-	Outputting the results as one zip file for each phenotype

**Mandatory input parameters in nextflow.config file**
- params.step1_bgen : bgen file for step 1
- params.step2_bgen : bgen file for step 2
- params.sample : .sample file for step 1 and step 2
- params.phenotype_file : phenotypes file , for more details about the format, review regiene [documentations](https://rgcgithub.github.io/regenie/options/)
- params.included_phenotype_ids : tab separated file of phenotypes to include in the analysis (in one column)
- params.covariate_file  : covariates file , for more details about the format, review regiene [documentations](https://rgcgithub.github.io/regenie/options/)
- params.covariate_list : comma separated list of covariates to include in the analysis
- params.outdir : directory of the output
- params.prefix : name of the root output file

Use "-entry step2_only" to only run step 2 (with related datasets).
