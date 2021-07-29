#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/samtools

label: "samtools-sam-to-paired-fastq"


baseCommand: [samtools, fastq]

arguments:

  - position: 2
    prefix: "-1"
    valueFrom: "fastq_1.fq"

  - position: 3
    prefix: "-2"
    valueFrom: "fastq_2.fq"


inputs:
  
  input:
    type: File
    format: http://edamontology.org/format_2573 # SAM
    inputBinding:
      position: 3

outputs:

  fastq_fwd:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: "fastq_1.fq"

  fastq_rev:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: "fastq_2.fq"


