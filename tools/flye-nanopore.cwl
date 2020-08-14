cwlVersion: v1.0
class: CommandLineTool


label: "metaFlye assembler (Nanopore)"

baseCommand: flye

inputs:

  reads:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 1
      prefix: "--nano-raw"
      itemSeparator: " "

  thread-number:
    type: int?
    default: 8
    inputBinding:
      position: 2
      prefix: "-t"

arguments:

  - position: 3
    prefix: "-o"
    valueFrom: "flye_out"

  - position: 4
    valueFrom: "--meta"

outputs:
  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "flye_out/assembly.fasta"

