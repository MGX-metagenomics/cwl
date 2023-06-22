cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/vamb

label: "VAMB"

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 5000
    coresMin: 40


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
    default: 40
    inputBinding:
      position: 3
      prefix: "-p"

  seed:
    type: int
    default: 42
    inputBinding:
      position: 4
      prefix: "--seed"

  mincontiglength:
    type: int
    default: 1000
    inputBinding:
      position: 5
      prefix: "-m"


arguments:
  - position: 5
    prefix: "--outdir"
    valueFrom: "vamb_outdir"

outputs:
  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: vamb_outdir/vae_clusters.tsv

