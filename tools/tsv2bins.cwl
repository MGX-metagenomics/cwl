cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/smallscripts

label: "TSV to binned FASTA"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: tsv2bins.pl

inputs:

  scaffold2bin:
    type: File
    default: /dev/null
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 1

  assembledContigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 2

outputs:

  binFastas:
    type: File[]
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "*.fas"

