cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/prodigal

requirements:
  - class: InlineJavascriptRequirement

label: Prodigal 2.6.3

baseCommand: prodigal

arguments:
  - position: 1
    prefix: "-p"
    valueFrom: "meta"
  - position: 2
    prefix: "-f"
    valueFrom: "gff"
  - position: 3
    prefix: '-o'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".gff"
      }
  - position: 4
    prefix: '-a'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".faa"
      }
  - position: 5
    prefix: '-d'
    valueFrom: |
      ${
        return inputs.inputFile.nameroot + ".fna"
      }


inputs:

  inputFile:
    type: File
    inputBinding:
      position: 6
      prefix: '-i'

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

