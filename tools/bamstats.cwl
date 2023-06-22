cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/bamstats

label: "bamstats: BAM alignment statistics per reference sequence"

baseCommand: bamstats

inputs:

  bamFile:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 1

  outFile:
    type: string
    inputBinding:
      position: 2

outputs:

  tsvOutput:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.outFile)

