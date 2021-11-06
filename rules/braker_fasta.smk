rule braker:
    input:
        if config["softmasked_genome"]:
            braker_in_fasta = config["softmasked_genome"]
        else:
            braker_in_fasta = rules.bedtools.output.softmasked_fasta,
    conda:
        envs.braker
    threads: min(48, workflow.cores)
    output:
        braker_out_aa = config["braker_aa_fasta"],
        braker_out_gtf = config["braker_gtf_fasta"]
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
           --esmode \
           --useexisting \
           --softmasking \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --species={params.prefix} \
        """
