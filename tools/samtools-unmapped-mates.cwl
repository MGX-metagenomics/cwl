#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

label: "samtools-get-unmapped-pairs"


baseCommand: [samtools, view, -f12]

inputs:
  
  input:
    type: File
    format: http://edamontology.org/format_2573 # SAM
    inputBinding:
      position: 1
      
      
arguments:
  - position: 2
    prefix: "-o"
    valueFrom: |
      ${
        return inputs.input.nameroot + "unmapped.sam"
      }

outputs:

  output:
    type: File
    format: http://edamontology.org/format_2573 # SAM
    outputBinding:
      glob: $(inputs.input.nameroot + "unmapped.sam")

