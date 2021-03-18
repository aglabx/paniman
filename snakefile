configfile: "config/config.yaml"

rule all:
    input:
        outfile_1 = config["transdecoder_out_bed"],
        outfile_2 = config["transdecoder_out_cds"]
        
rule locals:
    params:
        eggnog_db = "/mnt/projects/zilov/soft/eggnog-mapper-2.0.4-rf1/database",
        blast_db = "/mnt/projects/shared/ncbi/blast/db/nt",

# set all locals s variable
locals = rules.locals.params


rule envs:
    params:
	#all_tools from envs folder
        v2trim = "../envs/v2trim.yaml",
        rmdup = "../envs/rmdup.yaml",
        trinity = "../envs/trinity.yaml",
        transdecoder = "../envs/transdecoder.yaml",
        fastqc = "../envs/fastqc.yaml",
        prokka = "../envs/prokka.yaml",
        blast = "../envs/blast.yaml",

# set all tools envs as a variable        
envs = rules.envs.params
# to call it use envs.<tool_name>

# trimming reads
include: "rules/v2trim.smk"
# clean up reads from optical duplicates
include: "rules/rmdup.smk"

#......
# last step
#include: "rules/last_step.smk"


