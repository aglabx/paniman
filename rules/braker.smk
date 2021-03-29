rule braker:
    input:
        braker_in_fasta = "/media/eternus1/projects/zilov/soft/braker_test/genome.fa",
        braker_in_bam = "/media/eternus1/projects/zilov/soft/braker_test/RNAseq.bam",
    conda:
        envs.braker
    threads: workflow.cores
    output:
        braker_out_aa = "./braker/augustus.hints.aa",
        braker_out_gtf = "./braker/augustus.hints.gtf"
    params:
        genemark_path = locals.genemark_path,
    shell:
        """
           braker.pl \
           --genome {input.braker_in_fasta} \
           --bam {input.braker_in_bam} \
           --GENEMARK_PATH={params.genemark_path} \
           --softmasking \
           --cores {threads}
        """