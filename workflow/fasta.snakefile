configfile: "config/config.yaml"

rule all:
    input:
        config["bedtools_softmasked_fasta"]
        
rule locals:
    params:
        ninja_path = "/home/dzilov/data_zilov/soft/NINJA-0.97-cluster_only/NINJA/",
        abblast_path = "",
        eggnog_db = "/mnt/projects/zilov/soft/eggnog-mapper-2.0.4-rf1/database",
        genemark_path = "/media/eternus1/projects/zilov/soft/genemark/gmes_linux_64",
        
locals = rules.locals.params

rule envs:
    params:
        repeatmodeler = "../envs/repeatmodeler.yaml",
        bedtools = "../envs/bedtools.yaml",
        braker = "../envs/braker.yaml",
      
envs = rules.envs.params

include: "rules/repeatmasker.smk"

include: "rules/bedtools.smk"

include: "rules/braker.smk"