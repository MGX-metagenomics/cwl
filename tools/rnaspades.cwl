cwlVersion: v1.0
class: CommandLineTool

label: rnaSPAdes

hints:
  DockerRequirement:
    dockerPull: sjaenick/spades

baseCommand: rnaspades.py

arguments:
  - position: 1
    prefix: '-o'
    valueFrom: 'rnaspades_out'

inputs:

  read1:
    type:
      - "null"
      - type: array
        items: File
        inputBinding:
          prefix: "-1"
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2

  read2:
    type:
      - "null"
      - type: array
        items: File
        inputBinding:
          prefix: "-2"
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2

  unpaired:
    type:
      - "null"
      - type: array
        items: File
        inputBinding:
          prefix: "-s"
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2

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

