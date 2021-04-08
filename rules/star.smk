rule star_index:
    input:
        softmasked_fasta = rules.bedtools.output.softmasked_fasta,
    conda:
        envs.star
    threads: 
        workflow.cores
    output:
        star_index = config["star_index"]
    params:
        star_dir = directory(config["star_dir"])
    shell:
        """
        STAR \
        --runMode genomeGenerate \
        --genomeDir {params.star_dir} \
        --genomeFastaFiles {input.softmasked_fasta} \
        --runThreadN {threads}
        """
        
rule star_align:
    input:
        assembly_index = rules.star_index.output.star_index,
        rna_forward_read = config["forward_rna_read"],
        rna_reverse_read = config["reverse_rna_read"]
    conda:
        envs.star
    threads: 
        workflow.cores
    output:
        alignment_sam = config["alignment_sam_raw"]
    params:
        star_dir = directory(config["star_dir"])
    shell:
        """
        STAR \
        --genomeDir {params.star_dir} \
        --readFilesIn {input.rna_forward_read} {input.rna_reverse_read} \
        --runThreadN {threads}
        """


rule move_star:
    input:
        raw_sam = rules.star_align.output.alignment_sam,
    output:
        alignment_sam = config["alignment_sam"]
    params:
        outdir = config["outdir"],
        star_dir = directory(config["star_dir"])
    shell:
        """        
        mv {input.raw_sam} {output.alignment_sam}
        
        mv {params.outdir}/*out* {params.star_dir}
        """