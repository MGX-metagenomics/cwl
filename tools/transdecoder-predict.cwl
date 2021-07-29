cwlVersion: v1.0
class: CommandLineTool

label: TransDecoder-Predict

baseCommand: TransDecoder.Predict

inputs:

  transcripts:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1
      prefix: "-t"

  longorfsDir:
    type: Directory
    inputBinding:
      position: 2
      prefix: "--output_dir"

outputs:

  cdsFasta:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "*$(inputs.transcripts).transdecoder.cds"

  peptideFasta:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "*$(inputs.transcripts).transdecoder.pep"
