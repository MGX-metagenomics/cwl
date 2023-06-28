#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - '$(inputs.databaseDir)'

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/metabuli

baseCommand: [ metabuli, classify ] 

inputs:

  querySequences:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1

  databaseDir:
    type: Directory
    inputBinding:
      position: 2
  
  thread-number:
    type: int?
    default: 20
    inputBinding:
      position: 6
      prefix: "--threads"

arguments:

  - position: 3
    valueFrom: "metabuli_out"

  - position: 4
    valueFrom: "job"

  - position: 5
    prefix: "--seq-mode"
    valueFrom: "1"

outputs:

  output:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: metabuli_out/job_classifications.tsv

