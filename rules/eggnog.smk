rule eggnog:
    input:
        proteins_file = rules.braker.output.braker_out_aa 
    conda:
        envs.eggnog
    threads:
        workflow.cores
    output:
        eggnog_out_annotation = config["eggnog_out_annotation"], 
        eggnog_out_orthologs = config["eggnog_out_orthologs"],
    params:
        eggnog_db = locals.eggnog_db,
        eggnog_prefix = config["prefix"],
        eggnog_dir = config["eggnog_dir"]
    shell:
        """
        emapper.py \
          --data_dir {params.eggnog_db} \
          -i {input.proteins_file} \
          -m diamond \
          --cpu {threads} \
          --output {params.eggnog_prefix} \
          --output_dir {params.eggnog_dir}
        """