rule all:
    input:
        config["eggnog_out_annotation"]
        
rule locals:
    params:
        ninja_path = "/home/dzilov/data_zilov/soft/NINJA-0.97-cluster_only/NINJA",
        prothint_path = "/media/eternus1/projects/zilov/soft/ProtHint-2.6.0/bin",
        eggnog_db = "/mnt/projects/databases/eggnog_db",
        genemark_path = "/media/eternus1/projects/zilov/soft/gmes_linux_64",
        
locals = rules.locals.params

rule envs:
    params:
        repeatmodeler = "../envs/repeatmodeler.yaml",
        bedtools = "../envs/bedtools.yaml",
        braker = "../envs/braker.yaml",
        star = "../envs/star.yaml",
        eggnog = "../envs/eggnog.yaml",
        samtools = "../envs/samtools.yaml",
      
envs = rules.envs.params

include: "../rules/repeatmasker.smk"

include: "../rules/bedtools.smk"

include: "../rules/star.smk"

include: "../rules/samtools.smk"

include: "../rules/braker_rna_faa.smk"

include: "../rules/eggnog.smk"