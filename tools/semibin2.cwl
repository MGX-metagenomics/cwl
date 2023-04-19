cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/semibin2

label: "SemiBin: Metagenomic Binning Using Siamese Neural Networks for short and long reads"

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

arguments:
  - position: 4
    prefix: "-o"
    valueFrom: "outdir"

  - position: 5
    valueFrom: "--self-supervised"

  - position: 6
    prefix: "--environment"
    valueFrom: "global"

outputs:

  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: outdir/contig_bins.tsv

