cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement


baseCommand: mergeFC

inputs:

  featureCountsTSV:
    type: File[]
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      prefix: '-i'
      itemSeparator: ","
      position: 1

  outFile:
    type: string
    inputBinding:
      prefix: '-o'
      position: 2

outputs:

  tsvOutput:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.outFile)

