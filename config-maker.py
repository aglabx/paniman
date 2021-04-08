#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#@created: <data>
#@author: <name>
#@contact: <email>

import sys
import argparse
import os
import os.path
from inspect import getsourcefile

def main(assembly_fasta, forward_read, reverse_read, faa, outdir, mode):
    ''' Function description.
    '''
    pass
    execution_folder = os.path.dirname(os.path.abspath(getsourcefile(lambda: 0)))
    config_file = f"{execution_folder}/config/config.yaml"
    
    
    prefix = os.path.basename(assembly_fasta).replace(".fasta", "")
    assembly_file_dir = os.path.dirname(assembly_fasta)
    
    config = f"""

# main parameters
outdir: "{outdir}"
prefix: "{prefix}"
assembly_fasta: "{assembly_fasta}"

#repeatmasker
repeatmasker_dir: "{outdir}/repeatmasker"
db_prefix: "{assembly_file_dir}/{prefix}"
rm_buildb_output: "{assembly_file_dir}/{prefix}.translation"

repeatmodeler_families: "{assembly_file_dir}/{prefix}-families.fa"
repeatmasker_gff: "{outdir}/repeatmasker/{prefix}.fasta.out.gff"

#bedtools
bedtools_dir: "{outdir}/bedtools"
bedtools_softmasked_fasta: "{outdir}/bedtools/{prefix}_softmasked.fasta"

#star
star_dir: "{outdir}/star"
star_index: "{outdir}/star/Genome"
alignment_sam_raw: "{outdir}/Aligned.out.sam"
alignment_sam: "{outdir}/star/{prefix}_aligned.sam"
alignment_bam: "{outdir}/star/{prefix}_aligned.bam"
#braker
braker_dir: "{outdir}/braker"
braker_aa: "{outdir}/braker/augustus.hints.aa"
braker_gtf: "{outdir}/braker/augustus.hints.gtf"

#eggnog
eggnog_dir: "{outdir}/eggnog/"

eggnog_out_annotation: "{outdir}/eggnog/{prefix}.emapper.annotations"
eggnog_out_orthologs: "{outdir}/eggnog/{prefix}.emapper.seed_orthologs"


    """
    
    if forward_read and reverse_read:
        forward_read = os.path.abspath(forward_read)
        reverse_read = os.path.abspath(reverse_read)
        config += f'\nforward_rna_read: "{forward_read}"'
        config += f'\nreverse_rna_read: "{reverse_read}"'
        config += f'\nrna_alignment: "{outdir}/star/{prefix}.bam"' 
    if faa:
        faa_file = os.path.abspath(faa)
        config += f'\nfaa_proteins: "{faa}"'
        
    
    
    with open(config_file, "w") as fw:
        fw.write(config)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Program description.')
    parser.add_argument('-a', '--assembly', help='path to assembly fasta file', required=True)
    parser.add_argument('-o', '--outdir', help='path to output directory for config.yaml', required=True)
    parser.add_argument('-f', '--forward_read', help='path to forward read rna-seq file', required=True)
    parser.add_argument('-r', '--reverse_read', help='path to reverse read rna-seq file', required=True)
    parser.add_argument('-p', '--proteins_fasta', help='path to proteins fasta file', required=True)
    parser.add_argument('-m', '--mode', help='mode to run pipeline', required=True)
    args = vars(parser.parse_args())
    
    assembly_fasta = os.path.abspath(args["assembly"])
    outdir = os.path.abspath(args["outdir"])
    forward_read =  args["forward_read"]
    reverse_read = args["reverse_read"]
    faa = args["proteins_fasta"]
    mode = args["mode"]
    
    main(assembly_fasta, forward_read, reverse_read, faa, outdir, mode)
