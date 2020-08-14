cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: ubuntu:18.04

label: "concat"

requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

baseCommand: cat

inputs:

  files:
    type: File[]
    format: http://edamontology.org/format_2306 # GTF
    inputBinding:
      position: 1

  outfile:
    type: string
    inputBinding:
      position: 3

arguments:

  - position: 2
    valueFrom: ">"

outputs:

  outputFile:
    type: File
    format: http://edamontology.org/format_2306 # GTF
    outputBinding:
      glob: $(inputs.outfile)

