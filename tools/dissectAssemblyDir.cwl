cwlVersion: v1.0
class: CommandLineTool

baseCommand: mv

inputs:

  dir:
    type: Directory
    inputBinding:
      position: 1

outputs:

  unbinned:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "*$(inputs.dir)/*unbinned*"

  remainder:
    type: File[]
    outputBinding:
      glob: "*$(inputs.dir)/bin.[0-9]+.fa"
