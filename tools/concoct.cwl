cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/concoct

label: "CONCOCT"

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      $(inputs.bamFiles)

baseCommand: runCONCOCT

inputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1

  threads:
    type: int
    default: 6
    inputBinding:
      position: 2

  bamFiles:
    type: File[]
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 3

outputs:

  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $("concoct.scaffolds2bin.tsv")

