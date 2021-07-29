cwlVersion: v1.0
class: CommandLineTool

label: rnaSPAdes

baseCommand: rnaspades.py

arguments:
  - position: 1
    prefix: '-o'
    valueFrom: 'rnaspades_out'

inputs:

  read1:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2
      prefix: "-1"

  read2:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "-2"

  unpaired:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "-s"

  thread-number:
    type: int?
    inputBinding:
      position: 5
      prefix: "-t"

  mem-limit:
    type: int?
    inputBinding:
      position: 6
      prefix: "-m"


outputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "rnaspades_out/transcripts.fasta"

