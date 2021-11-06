rule braker:
    input:
        braker_in_fasta = config["softmasked_genome"],
        braker_in_bam = rules.hisat2_align.output,
        braker_in_faa = config["faa_proteins"]
    conda:
        envs.braker
    threads: min(workflow.cores, 48)
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
           --etpmode \
           --softmasking \
           --cores={threads} \
           --gff3 \
           --genome={input.braker_in_fasta} \
           --species={params.prefix} \
           --bam={input.braker_in_bam} \
           --prot_seq={input.braker_in_faa} \
        """     
