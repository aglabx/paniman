rule braker:
    input:
        braker_in_fasta = rules.bedtools.output.softmasked_fasta,
        braker_in_bam = rules.samtools.output.bam,
    conda:
        envs.braker
    threads: workflow.cores
    output:
        braker_out_aa = config["braker_aa"],
        braker_out_gtf = config["braker_gtf"]
    params:
        prefix = config["prefix"],
        genemark_path = locals.genemark_path,
        prothint_path = locals.prothint_path,
        output_dir = directory(config["outdir"])
    shell:
        """
        cd {params.genemark_path}
        ./check_install.bash
        
        cd {params.output_dir}
        
        braker.pl \
           --PROTHINT_PATH={params.prothint_path} \
           --GENEMARK_PATH={params.genemark_path} \
           --verbosity 4 \
           --min_contig=10000 \
           --softmasking \
           --useexisting \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --species={params.prefix} \
           --bam={input.braker_in_bam} \
        """