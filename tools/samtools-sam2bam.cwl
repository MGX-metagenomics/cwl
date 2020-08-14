#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

baseCommand: [samtools, view, -b]

inputs:
  
  uncompressed:
    type: boolean
    default: false
    inputBinding:
      position: 1
      prefix: -u

  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 2
      prefix: "-@"

  fastcompression:
    type: boolean
    default: false
    inputBinding:
      position: 3
      prefix: '-1'

  input:
    type: File
    inputBinding:
      position: 5
      
      
arguments:
  - position: 4
    prefix: "-o"
    valueFrom: |
      ${
        return inputs.input.nameroot + ".bam"
      }

outputs:

  output:
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + ".bam")

