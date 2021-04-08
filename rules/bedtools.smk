rule bedtools:
    conda:
        envs.bedtools
    threads: workflow.cores
    input:
        assembly_fasta = config["assembly_fasta"],
        rm_gff = rules.repeatmasker.output.repeatmasker_gff
    output:
        softmasked_fasta = config["bedtools_softmasked_fasta"]
    params:
        bedtools_dir = directory(config["bedtools_dir"])
    shell:
        """
        bedtools maskfasta -soft \
        -fi {input.assembly_fasta} \
        -bed {input.rm_gff} \
        -fo {output.softmasked_fasta}
        """