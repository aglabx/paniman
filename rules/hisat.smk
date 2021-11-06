rule hisat2_index:
    input:
        genome = config["softmasked_genome"]
    conda:
        envs.hisat2
    threads: workflow.cores
    output:
        config["hisat_index"]
    params:
        outdir = directory(config["hisat_dir"]),
        prefix = config["prefix"]
    shell:
        """
        hisat2-build {input} {params.prefix}
        """

rule hisat2_align:
    input:
        genome = config["softmasked_genome"],
        forward_read = config["forward_rna_read"],
        reverse_read = config["reverse_rna_read"],
        index = rules.hisat2_index.output,
    conda: 
        envs.hisat2
    threads: 
        workflow.cores
    output:
        config["alignment_bam"]
    params:
        outdir = directory(config["hisat_dir"]),
        prefix = config["prefix"]
    shell:
        """
        hisat2 -x {params.prefix} -p {threads} -1 {input.forward_read} -2 {input.reverse_read} | samtools view -Sbh -o {output}
        """