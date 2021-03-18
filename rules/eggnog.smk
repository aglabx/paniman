rule eggnog:
    conda:
        "../envs/eggnog.yaml"
    threads:
        60
    input:
        pep_file = "/media/eternus1/nfs/projects/shared/transcriptome_pipeline/data/eggnog/Trinity.fasta.transdecoder.pep"
    output:
        eggnog_output = "/home/pchesnokova/eggnog_snakemake/emapp_trinity_pep.emapper.annotations"
    params:
        eggnog_db = "/mnt/projects/databases/eggnog_db/"
    shell:
        """
        emapper.py \
                    -i {input.pep_file} \
                    --data_dir {params.eggnog_db} \
                    --output {output.eggnog_output} \ 
                    -m diamond \
                    --cpu {threads}
        """
