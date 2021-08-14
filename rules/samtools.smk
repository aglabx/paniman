rule samtools:
    input:
        sam_1 = rules.rename_star.output.alignment_sam
    conda:
        envs.samtools
    threads: workflow.cores
    output:
        bam = config["alignment_bam"]
    shell:
        "samtools view --threads {threads} -S -b {input.sam_1} > {output.bam}"