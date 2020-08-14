#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - '$(inputs.dataDir)'
      - '$(inputs.binnedFastas)'

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/checkm

baseCommand: [checkm, lineage_wf]

inputs:

  dataDir:
    type: Directory
  
  thread-number:
    type: int?
    default: 6
    inputBinding:
      position: 1
      prefix: "-t"

  bin_suffix:
    type: string
    default: "fa"
    inputBinding:
      position: 2
      prefix: "-x"

  report_file:
    type: string
    default: checkm.tsv
    inputBinding:
      position: 3
      prefix: "-f"

  tabular_output:
    type: boolean
    default: true
    inputBinding:
      position: 4
      prefix: "--tab_table"

  binnedFastas:
    type: File[]
#    inputBinding:
#      position: 5

  outdir:
    type: string
    default: "checkm_out"
    inputBinding:
      position: 6

arguments:
  - position: 5
    valueFrom: "."

outputs:

  output:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.report_file)

