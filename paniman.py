#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#@created: 10.11.2021
#@author: Danil Zilov
#@contact: zilov.d@gmail.com

import argparse
import os
import os.path
from inspect import getsourcefile
from datetime import datetime
import string
import random

def config_maker(settings, config_file):
    config = f"""
    "outdir" : "{settings["outdir"]}"
    "genome" : "{settings["assembly_fasta"]}"
    "forward_read" : "{settings["fr"]}"
    "reverse_read" : "{settings["rr"]}"
    "proteins" : "{settings["faa"]}"
    "mode" : "{settings["mode"]}"
    "aligner" : "{settings["aligner"]}"
    "softmasked" : "{settings["softmasked"]}"
    "threads" : "{settings["threads"]}"
    "braker_mode": "{settings["braker_mode"]}"
    "busco_lineage": "{settings["busco_lineage"]}"
    """

    if not os.path.exists(os.path.dirname(config_file)):
        os.mkdir(os.path.dirname(config_file))


    with open(config_file, "w") as fw:
        fw.write(config)
        print(f"CONFIG IS CREATED! {config_file}")
      

def main(settings):
    ''' Function description.
    '''
        
    if settings["debug"]:
        snake_debug = "-n"
    else:
        snake_debug = ""

    #Snakemake
    command = f"""
    snakemake --snakefile {settings["execution_folder"]}/workflow/snakefile \
              --configfile {settings["config_file"]} \
              --cores {settings["threads"]} \
              --use-conda {snake_debug}"""
    print(command)
    os.system(command)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Parrots pipeline - a tool for parrots genome annotation project.')
    parser.add_argument('-m','--mode', help="mode to use [default = fasta]", 
                        choices=["fasta", "fasta_rna", "fasta_faa", "fasta_rna_faa"], default="fasta")
    parser.add_argument('-a','--assembly', help="path to asssembly fasta file", required=True)
    parser.add_argument('-1','--forward_rna_read', help="path to forward rna-seq read", default="")
    parser.add_argument('-2','--reverse_rna_read', help="path to reverse rna-seq read", default="")
    parser.add_argument('--aligner', help="aligner to use, hisat is defaul", choices=["hisat", "star"], default="hisat")
    parser.add_argument('-f','--faa', 
                        help="path to protein fasta file (.faa), required for fasta_faa and fasta_rna_faa modes",
                        default="")
    parser.add_argument("-s", "--softmasked", help="use if your genome is already softmasked", default=0, action='store_true')
    parser.add_argument('-b','--busco_lineage', 
                        help="path to busco lineage database",
                        default="")
    parser.add_argument('-o','--outdir', help='output directory', required=True)
    parser.add_argument('-t','--threads', help='number of threads [default == 8]', default = "8")
    parser.add_argument('-d','--debug', help='debug mode', action='store_true')
    args = vars(parser.parse_args())

    assembly_fasta = os.path.abspath(args["assembly"])
    threads = args["threads"]
    debug = args["debug"]
    mode = args["mode"]
    forward_rna_read = args["forward_rna_read"]
    reverse_rna_read = args["reverse_rna_read"]
    softmasked = args["softmasked"]
    busco_lineage = args["busco_lineage"]
    faa_file = args["faa"]
    aligner = args["aligner"]
    outdir = os.path.abspath(args["outdir"])
    
    
    if softmasked:
        softmasked = 1
    execution_folder = os.path.dirname(os.path.abspath(getsourcefile(lambda: 0)))
    execution_time = datetime.now().strftime("%d_%m_%Y_%H_%M_%S")
    random_letters = "".join([random.choice(string.ascii_letters) for n in range(3)])
    config_file = os.path.join(execution_folder, f"config/config_{random_letters}{execution_time}.yaml")
    # default braker_file for fasta mode
    braker_file = os.path.join(execution_folder,"rules/braker_fasta.smk")

    if mode == "fasta_rna":
        if forward_rna_read == "0" or reverse_rna_read == "0":
            parser.error("\nfasta_rna mode requires -1 {path_to_forward_read} and -2 {path_to_reverse_read}!")
        else:
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            braker_file = os.path.join(execution_folder,"rules/braker_rna.smk")
            
    elif mode == "fasta_faa":
        if faa_file == "0":
            parser.error("\nfasta_faa mode requires -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            braker_file = os.path.join(execution_folder,"rules/braker_faa.smk")
            
    elif mode == "fasta_rna_faa":
        if not (forward_rna_read or reverse_rna_read or faa_file):
            parser.error("\nfasta_faa mode requires -1 {path_to_forward_read} and -2 {path_to_reverse_read} and -f {protein_fasta.faa}!")
        else:
            faa_file = os.path.abspath(faa_file)
            forward_rna_read = os.path.abspath(forward_rna_read)
            reverse_rna_read = os.path.abspath(reverse_rna_read)
            braker_file = os.path.join(execution_folder,"rules/braker_rna_faa.smk")
            
    settings = {
        "assembly_fasta" : assembly_fasta,
        "fr" : forward_rna_read, 
        "rr" : reverse_rna_read,
        "faa" : faa_file,
        "outdir" : outdir,
        "threads" : threads,
        "mode" : mode,
        "execution_folder" : execution_folder,
        "debug" : debug,
        "softmasked" : softmasked,
        "aligner" : aligner,
        "config_file" : config_file,
        "braker_mode" : braker_file,
        "busco_lineage" : busco_lineage,
    }
    
    config_maker(settings, config_file)
    main(settings)
