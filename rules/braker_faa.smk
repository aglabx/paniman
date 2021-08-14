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
        
        export GENEMARK_PATH={params.genemark_path}
        export PROTHINT_PATH={params.prothint_path}
        
        cd {params.output_dir}
        braker.pl \
           --verbosity 4 \
           --min_contig=10000 \
           --epmode \
           --softmasking \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --prot_seq={input.braker_in_faa} \
           --species={params.prefix} \
        """