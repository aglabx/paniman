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
    

def main(assembly_fasta, fr, rr, faa, outdir, threads, snakefile, mode, execution_folder, snake_debug):
    ''' Function description.
    '''
        
    if debug:
        snake_debug = "-n"
    else:
        snake_debug = ""

    #Config-maker
    command = f"python {execution_folder}/config-maker.py -a {assembly_fasta} -o {outdir} -f {fr} -r {rr} -p {faa} -m {mode}"
    print(command)
    os.system(command)
    #Snakemake
    command = f"snakemake --snakefile {snakefile} --configfile {execution_folder}/config/config.yaml --cores {threads} --use-conda --conda-frontend mamba {snake_debug}"
    print(command)
    os.system(command)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Parrots pipeline - a tool for parrots genome annotation project.')
    parser.add_argument('-m','--mode', help="mode to use [default = fasta]", 
                        choices=["fasta", "fasta_rna", "fasta_faa", "fasta_rna_faa"], default="fasta")
    parser.add_argument('-a','--assembly', help="path to asssembly fasta file", required=True)
    parser.add_argument('-1','--forward_rna_read', help="path to forward rna-seq read", default="")
    parser.add_argument('-2','--reverse_rna_read', help="path to reverse rna-seq read", default="")
    parser.add_argument('-f','--faa', 
                        help="path to protein fasta file (.faa), required for fasta_faa and fasta_rna_faa modes",
                        default="")
    parser.add_argument('-o','--outdir', help='output directory [default is folder of your assembly file]', default=False)
    parser.add_argument('-t','--threads', help='number of threads [default == 8]', default = "8")
    parser.add_argument('-d','--debug', help='debug mode', action='store_true')
    args = vars(parser.parse_args())

    assembly_fasta = os.path.abspath(args["assembly"])
    threads = args["threads"]
    debug = args["debug"]
    mode = args["mode"]
    forward_rna_read = args["forward_rna_read"]
    reverse_rna_read = args["reverse_rna_read"]
    faa_file = args["faa"]
    
    outdir = args["outdir"]
    if not outdir:
        outdir = os.path.dirname(assembly_fasta)
    else:
        outdir = os.path.abspath(outdir)
    
    execution_folder = os.path.dirname(os.path.abspath(getsourcefile(lambda: 0)))
    if mode == "fasta":
        snakefile = os.path.join(execution_folder,"workflow/fasta.snakefile")
    elif mode == "fasta_rna":
        if forward_rna_read == "" or reverse_rna_read == "":
            parser.error("\nfasta_rna mode requires -1 {path_to_forward_read} and -2 {path_to_reverse_read}!")
        else:
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            snakefile = os.path.join(execution_folder, "workflow/fasta_rna.snakefile")
            
    elif mode == "fasta_faa":
        if faa_file == "":
            parser.error("\nfasta_faa mode requires -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            snakefile = os.path.join(execution_folder, "workflow/fasta_faa.snakefile")
            
    elif mode == "fasta_rna_faa":
        if forward_rna_read == "" or reverse_rna_read == "" or faa_file == "":
            parser.error("\nfasta_faa mode requires -1 {path_to_forward_read} and -2 {path_to_reverse_read} and -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            snakefile = os.path.join(execution_folder, "workflow/fasta_rna_faa.snakefile")
     
    main(assembly_fasta, forward_rna_read, reverse_rna_read, faa_file, outdir, threads, snakefile, mode, execution_folder, debug)