class: CommandLineTool
cwlVersion: v1.0

hints:
  DockerRequirement:
    dockerPull: sjaenick/smallscripts

requirements:
  - class: InlineJavascriptRequirement

baseCommand: renameContigs.pl

inputs:

  inFile:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1

  outFile:
    type: string
    inputBinding:
      position: 2

outputs:
  renamedFile:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: $(inputs.outFile)

