cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/smallscripts

label: "filter bin TSV by size"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: filter_bin.pl

inputs:

  assembledContigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1


  binTSV:
    type: File
    default: /dev/null
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 2

  minSize:
    type: int
    default: 100000
    inputBinding:
      position: 3

  filteredTSV:
    type: string
    default: "filtered.tsv"
    inputBinding:
      position: 4


outputs:

  filtered:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.filteredTSV)

