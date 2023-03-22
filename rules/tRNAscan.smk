rule bedtools:
    conda:
        envs.tRNAscan
    threads: workflow.cores
    input:
        assembly_fasta = GENOME,
    output:
        trna_gff = f"{OUTDIR}/tRNAscan2/{PREFIX}_tRNA.gff3"
        trna_fasta = f"{OUTDIR}/tRNAscan2/{PREFIX}_tRNA.fasta"
        trna_output = f"{OUTDIR}/tRNAscan2/{PREFIX}_tRNA.out"
    params:
        bedtools_dir = directory(f"{OUTDIR}/bedtools")
    shell:
        """
        tRNAscan-SE --thread {threads} -o {output.trna_output} -E --gff {output.trna_gff} -a {output.trna_fasta} --progress {input.assembly_fasta}
        """