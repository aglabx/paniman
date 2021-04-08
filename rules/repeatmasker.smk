rule rmbuildb:
    conda:
        envs.repeatmodeler
    threads: workflow.cores
    input:
        assembly_fasta = config["assembly_fasta"]
    output:
        database_translation = config["rm_buildb_output"]
    params:
        db_prefix = config["db_prefix"]
    shell:
        """
        BuildDatabase -name {params.db_prefix} {input.assembly_fasta}
        """


rule repeatmodeler:
    conda:
        envs.repeatmodeler
    threads:
        workflow.cores
    input:
        database = rules.rmbuildb.output.database_translation
    output:
        rm_families = config["repeatmodeler_families"]
    params:
        database_prefix = config["db_prefix"],
        ninja_dir = locals.ninja_path
    shell:
        """
        RepeatModeler \
        -ninja_dir {params.ninja_dir} \
        -pa {threads} \
        -LTRStruct \
        -database {params.database_prefix}
        """


rule repeatmasker:
    conda:
        envs.repeatmodeler
    threads:
        workflow.cores
    input:
        assembly = config["assembly_fasta"],
        rm_families = rules.repeatmodeler.output.rm_families
    output:
        repeatmasker_gff = config["repeatmasker_gff"]
    params:
        rm_dir = directory(config["repeatmasker_dir"])
    shell:
        """
        RepeatMasker \
        -pa {threads} \
        -lib {input.rm_families} \
        -smal -poly -html -source -gff -u -excln -dir {params.rm_dir} \
        {input.assembly}
        """
