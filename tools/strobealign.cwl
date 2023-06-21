cwlVersion: v1.0
class: CommandLineTool

label: "StrobeAlign - fast short read aligner"

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 3000
    coresMin: 10

baseCommand: strobealign

inputs:

  reference:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 4

  read1:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 5

  read2:
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 6

  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 1
      prefix: "-t"

  skip_unaligned:
    type: boolean
    default: true
    inputBinding:
      position: 2
      prefix: "-U"

arguments:

  - position: 3
    prefix: '-o'
    valueFrom: |
      ${
        return inputs.read1.nameroot.split("_")[0] + ".sam"
      }

outputs:

  sam:
    type: File
    format: http://edamontology.org/format_2573 # SAM
    outputBinding:
      glob: $(inputs.read1.nameroot.split("_")[0] + ".sam")

