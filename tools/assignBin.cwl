cwlVersion: v1.2
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/smallscripts

label: "Taxonomic assignment of a metagenomic bin"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: assignBin.pl

inputs:

  kraken2Output:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 1

  taxonomyDirectory:
    type: Directory
    inputBinding:
      position: 2

  fractionCutoff:
    type: string
    default: "0.55"
    inputBinding:
      position: 3

  minNumber:
    type: int
    default: 5
    inputBinding:
      position: 4 

arguments:
  - position: 5
    valueFrom: |
      ${
        return inputs.kraken2Output.nameroot + ".tax"
      }

outputs:

  lineage:
    type: File
    outputBinding:
      glob: $(inputs.kraken2Output.nameroot + ".tax")

