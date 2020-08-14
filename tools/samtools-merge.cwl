#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

baseCommand: [samtools, merge]

inputs:
  
  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 1
      prefix: "-@"

  outFile:
    type: string
    default: "merged.bam"
    inputBinding: 
      position: 2

  inputs:
    type: File[]
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 3
      
outputs:

  output:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    outputBinding:
      glob: $(inputs.outFile)

