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
    


def main():
    ''' Function description.
    '''
        
    if debug:
        snake_debug = "-n"
    else:
        snake_debug = ""


    #Config-maker
    command = f"python ./config-maker.py -1 {forward_read} -2 {reverse_read} -o {outdir}"
    print(command)
    os.system(command)
    #Snakemake
    command = f"snakemake --cores {threads} --use-conda --conda-frontend mamba {snake_debug}"
    print(command)
    os.system(command)
        

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Pannopi - a tool for prokariotic genome assembly and annotation.')
    parser.add_argument('-1','--forward_read', help="path to forward read")
    parser.add_argument('-2','--reverse_read', help='path to reverse read')
    parser.add_argument('-o','--outdir', help='output directory', default=False)
    parser.add_argument('-t','--threads', help='number of threads [default == 8]', default = "8")
    parser.add_argument('-d','--debug', help='debug mode', action='store_true')
    args = vars(parser.parse_args())

    forward_read = os.path.abspath(args["forward_read"])
    reverse_read = os.path.abspath(args["reverse_read"])
    outdir = args["outdir"]
    if not outdir:
        outdir = os.path.dirname(forward_read)
    else:
        outdir = os.path.abspath(outdir)
    threads = args["threads"]
    debug = args["debug"]

    main()
