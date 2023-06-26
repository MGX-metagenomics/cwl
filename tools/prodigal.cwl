cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/prodigal

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 20

label: Prodigal 2.6.3

baseCommand: pprodigal

arguments:
  - position: 1
    prefix: "-f"
    valueFrom: "gff"

  - position: 2
    prefix: '-o'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".gff"
      }
  - position: 3
    prefix: '-a'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".faa"
      }
  - position: 4
    prefix: '-d'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".fna"
      }


inputs:

  metagenomic:
    type: boolean
    default: false
    inputBinding:
      position: 1
      prefix: "-p"
      valueFrom: "meta"

  inputFile:
    type: File
    inputBinding:
      position: 6
      prefix: '-i'

  tasks:
    type: int
    default: 20
    inputBinding:
      position: 7
      prefix: '-T'

  chunkSize:
    type: int
    default: 2000
    inputBinding:
      position: 8
      prefix: '-C'


outputs:

  annotations:
    type: File
    format: http://edamontology.org/format_2306 # GTF
    outputBinding:
      glob: $(inputs.inputFile.nameroot + ".gff")

  genes:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: $(inputs.inputFile.nameroot + ".fna")

  proteins:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: $(inputs.inputFile.nameroot + ".faa")

