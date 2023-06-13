#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - '$(inputs.databaseDir)'

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/kraken2

baseCommand: kraken2

inputs:

  databaseDir:
    type: Directory
    inputBinding:
      position: 1
      prefix: "--db"
  
  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 2
      prefix: "--threads"

  proteinQuery:
    type: boolean
    default: false
    inputBinding:
      position: 3
      prefix: "--protein-query"

  confidenceThreshold:
    type: float?
    default: 0.0
    inputBinding:
      position: 4
      prefix: "--confidence"


  querySequences:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 6

arguments:

  - position: 4
    prefix: "--output"
    valueFrom: |
      ${
        return inputs.querySequences.nameroot + ".krkn"
      }

outputs:

  output:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.querySequences.nameroot + ".krkn")

