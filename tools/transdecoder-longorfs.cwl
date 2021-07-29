cwlVersion: v1.0
class: CommandLineTool

label: TransDecoder-LongOrfs

baseCommand: TransDecoder.LongOrfs

arguments:
  - position: 1
    prefix: '--output_dir'
    valueFrom: 'transdecoder_longorfs_out'

inputs:

  transcripts:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 2
      prefix: "-t"

  min-protein-length:
    type: int?
    default: 100
    inputBinding:
      position: 3
      prefix: '-m'

outputs:

  outputDir:
    type: Directory
    outputBinding:
      glob: "transdecoder_longorfs_out"

