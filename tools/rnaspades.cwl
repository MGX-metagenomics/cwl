cwlVersion: v1.0
class: CommandLineTool

label: rnaSPAdes

baseCommand: rnaspades.py

arguments:
  - position: 1
    prefix: '-o'
    valueFrom: 'spades_out'

inputs:

  read1:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2
      prefix: "-1"

  read2:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "-2"


  thread-number:
    type: int?
    inputBinding:
      position: 4
      prefix: "-t"

outputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "spades_out/contigs.fasta"

