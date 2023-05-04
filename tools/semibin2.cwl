cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/semibin2

label: "SemiBin 2"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: [SemiBin2, single_easy_bin]

inputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1
      prefix: "-i"

  bamfiles:
    type: File[]
    inputBinding:
      position: 2
      prefix: "-b"

  inputFile:
    type: File?
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 3
      prefix: '--prodigal-output-faa'

  threads:
    type: int?
    default: 10
    inputBinding:
      position: 4
      prefix: "--threads"

arguments:
  - position: 5
    prefix: "-o"
    valueFrom: "outdir"

  - position: 6
    valueFrom: "--self-supervised"

  - position: 7
    prefix: "--environment"
    valueFrom: "global"

  - position: 8
    prefix: "--engine"
    valueFrom: "cpu"

outputs:
  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: outdir/contig_bins.tsv

