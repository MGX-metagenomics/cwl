cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: ubuntu:18.04

label: "concat-fasta"

requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

baseCommand: cat

inputs:

  file1:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1

  file2:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 2

  outfile:
    type: string
    inputBinding:
      position: 4


arguments:

  - position: 3
    valueFrom: ">"

outputs:

  outputFile:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: $(inputs.outfile)

