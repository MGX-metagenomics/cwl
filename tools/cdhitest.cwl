cwlVersion: v1.0
class: CommandLineTool

label: cd-hit-est

baseCommand: cd-hit-est

arguments:

  - position: 1
    prefix: '-o'
    valueFrom: 'clustered.fas'

inputs:

  transcripts:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 2
      prefix: "-i"

  identity-threshold:
    type: float?
    default: 0.9
    inputBinding:
      position: 3
      prefix: '-c'

  use-global-identity:
    type: int?
    default: 1
    inputBinding:
      position: 4
      prefix: '-G'

  memory-threshold-mb:
    type: int?
    default: 800
    inputBinding:
      position: 5
      prefix: '-M'

  threads:
    type: int?
    default: 1
    inputBinding:
      position: 6
      prefix: '-T'

outputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "clustered.fas"

