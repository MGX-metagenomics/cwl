# src https://gitlab.com/sibyllewohlgemuth/cwl_files/raw/master/bowtie2_build.cwl

cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/bowtie2

requirements:
  - class: InlineJavascriptRequirement
inputs:
  reference:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 1

  thread-number:
    type: int?
    default: 6
    inputBinding:
      position: 2
      prefix: "--threads"

  output_prefix:
    type: string?
    default: default
    inputBinding:
      position: 3
      valueFrom: |
        ${
          if (self == "default") {
            return inputs.reference.nameroot;
          } else {
            return self;
          }
        }
    doc: |
      Specify a filename prefix for the reference genome index. Default: use the filename prefix of the reference

outputs:

  index:
    type: {type: array, items: File}
    format: http://edamontology.org/format_3326 # index
    outputBinding:
      glob:
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".1.bt2"
          } else {
            return inputs.output_prefix + ".1.bt2"
          }
        }
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".2.bt2"
          } else {
            return inputs.output_prefix + ".2.bt2"
          }
        }
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".3.bt2"
          } else {
            return inputs.output_prefix + ".3.bt2"
          }
        }
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".4.bt2"
          } else {
            return inputs.output_prefix + ".4.bt2"
          }
        }
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".rev.1.bt2"
          } else {
            return inputs.output_prefix + ".rev.1.bt2"
          }
        }
      - |
        ${
          if (inputs.output_prefix == "default") {
            return inputs.reference.nameroot + ".rev.2.bt2"
          } else {
            return inputs.output_prefix + ".rev.2.bt2"
          }
        }

baseCommand: ["bowtie2-build"]

doc: |
  Usage:   bowtie2-build [options]* <reference_in> <bt2_base>
