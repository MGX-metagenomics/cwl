class: CommandLineTool
cwlVersion: v1.0

hints:
  DockerRequirement:
    dockerPull: sjaenick/smallscripts

requirements:
  - class: InlineJavascriptRequirement

baseCommand: cp

inputs:

  taxFile:
    type: File
    inputBinding:
      position: 1

  binFile:
    type: File
    format: http://edamontology.org/format_1929 # FASTA


arguments:

  - position: 2
    valueFrom: $(inputs.binFile.nameroot + ".tax")
  

outputs:
  renamedFile:
    type: File
    outputBinding:
      glob: $(inputs.binFile.nameroot + ".tax")

