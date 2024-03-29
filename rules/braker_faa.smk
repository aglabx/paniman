rule braker:
    input:
        braker_in_fasta = GENOME,
        braker_in_faa = PROTEINS,
    conda:
        envs.braker
    threads: min(workflow.cores, 48)
    output:
        braker_out_aa = f"{OUTDIR}/braker/augustus.hints.aa",
        braker_out_gtf = f"{OUTDIR}/braker/augustus.hints.gtf",
    params:
        prefix = PREFIX,
        genemark_path = locals.genemark_path,
        prothint_path = locals.prothint_path,
        output_dir = directory(OUTDIR)
    shell:
        """
        cd {params.genemark_path}
        ./check_install.bash
        
        export GENEMARK_PATH={params.genemark_path}
        export PROTHINT_PATH={params.prothint_path}
        
        cd {params.output_dir}
        braker.pl \
           --verbosity 4 \
           --min_contig=1000 \
           --prg gth \
           --trainFromGth \
           --softmasking \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --prot_seq={input.braker_in_faa} \
           --species={params.prefix} \
        """