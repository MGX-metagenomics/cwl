#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

baseCommand: [samtools, index]

inputs:
  
  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 1
      prefix: "-@"

  input:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 3
      
arguments:

  - position: 2
    prefix: "-b"

outputs:

  bamIndex:
    type: File
    outputBinding:
      glob: $(inputs.input.basename + ".bai")

