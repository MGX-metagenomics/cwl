cwlVersion: v1.0
class: CommandLineTool

label: "fastp: An ultra-fast all-in-one FASTQ preprocessor"

requirements:
  - class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: sjaenick/fastp

baseCommand: fastp

inputs:

  read1:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 1
      prefix: "--in1"

  read2:
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2
      prefix: "--in2"

  trim-poly-g:
    type: boolean?
    inputBinding:
      position: 5
      prefix: "--trim_poly_g"

  trim-poly-x:
    type: boolean?
    inputBinding:
      position: 6
      prefix: "--trim_poly_x"

  disable-quality-filter:
    type: boolean?
    inputBinding:
      position: 7
      prefix: "--disable_quality_filtering"

  enable-low-complexity-filter:
    type: boolean?
    inputBinding:
      position: 8
      prefix: "--low_complexity_filter"

  disable-adapter-trimming:
    type: boolean?
    inputBinding:
      position: 9
      prefix: "--disable_adapter_trimming"

  detect-paired-end-adapter:
    type: boolean?
    inputBinding:
      position: 10
      prefix: "--detect_adapter_for_pe"

  thread-number:
    type: int?
    default: 8
    inputBinding:
      position: 11
      prefix: "--thread"

  min-length:
    type: int?
    inputBinding:
      position: 12
      prefix: "--length_required"

  max-length:
    type: int?
    inputBinding:
      position: 13
      prefix: "--length_limit"

  json_report:
    type: string
    default: "/dev/null"
    inputBinding:
      position: 14
      prefix: "--json"

  html_report:
    type: string
    default: "/dev/null"
    inputBinding:
      position: 15
      prefix: "--html"

arguments:

  - position: 3
    prefix: '--out1'
    valueFrom: |
      ${
        return inputs.read1.nameroot + "_trimmed.fq"
      }

  - position: 4
    prefix: '--out2'
    valueFrom: |
      ${
        return inputs.read2.nameroot + "_trimmed.fq"
      }

outputs:

  reads1:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.read1.nameroot + "_trimmed.fq")

  reads2:
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.read2.nameroot + "_trimmed.fq")

