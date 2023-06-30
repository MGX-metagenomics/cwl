cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/ribodetector

label: "RiboDetector"

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 5000
    coresMin: 10

baseCommand: ribodetector_cpu

arguments:

  - position: 1
    prefix: "-t"
    valueFrom: "10"

  - position: 2
    prefix: "-e"
    valueFrom: "rrna"

  - position: 3
    prefix: "-l"
    valueFrom: "250"

  - position: 6
    prefix: "-o"
    valueFrom: ${ return inputs.fwdReads.nameroot + "_filtered.fq" }

  - position: 7
    valueFrom: ${ return inputs.revReads.nameroot + "_filtered.fq" }

inputs:

  fwdReads:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "-i"

  revReads:
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 5

outputs:

  fwdFiltered:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.fwdReads.nameroot + "_filtered.fq")

  revFiltered:
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.revReads.nameroot + "_filtered.fq")


