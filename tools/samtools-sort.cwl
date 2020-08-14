#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

baseCommand: [samtools, sort]

inputs:
  
  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 1
      prefix: "-@"

  input:
    type: File
    inputBinding:
      position: 3
      
arguments:

  - position: 2
    prefix: "-o"
    valueFrom: |
      ${
        return inputs.input.nameroot + ".bam"
      }

outputs:

  output:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    outputBinding:
      glob: $(inputs.input.nameroot + ".bam")

