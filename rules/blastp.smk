rule blastp:
    input:
        pep_file = "/mnt/data/lizards/dasha/val/transdecoder/Trinity.fasta.transdecoder.pep"
    conda:
        "/home/sryaxovsky/transcriptomics_pipeline/envs/blastp.yaml"
    output:
        out_file = "/media/eternus1/nfs/projects/shared/transcriptome_pipeline/data/blast/blastp.outfmt6"
    threads: 32
    params:
        db = "/mnt/data/ncbi/blast/uniref90/uniref90"
    shell:
       """ blastp -query {input} -db {params.db} -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads {threads} -out {output} """  

