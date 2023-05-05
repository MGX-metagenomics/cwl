cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/vamb

label: "VAMB"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: vamb

inputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1
      prefix: "--fasta"

  bamfiles:
    type: File[]
    inputBinding:
      position: 2
      prefix: "--bamfiles"

  threads:
    type: int?
    default: 10
    inputBinding:
      position: 3
      prefix: "-p"

arguments:
  - position: 4
    prefix: "--outdir"
    valueFrom: "outdir"

outputs:
  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: outdir/clusters.tsv

