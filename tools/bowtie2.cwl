cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/bowtie2

baseCommand: [ "bowtie2" ]

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.index[0])
      - $(inputs.index[1])
      - $(inputs.index[2])
      - $(inputs.index[3])
      - $(inputs.index[4])
      - $(inputs.index[5])

inputs:

  thread-number:
    type: int?
    default: 10
    inputBinding:
      position: 1
      prefix: "--threads"

  index:
    type:
      type: array
      items: File
      inputBinding:
        valueFrom: |
          ${
            if (self.basename == inputs.index[0].basename) {
              var split = self.basename.split('.');
              return split.slice(0, split.length - 2).join('.');
            } else {
              return null;
            }
          }
    format: http://edamontology.org/format_3326 # index
    inputBinding:
      position: 2
      prefix: "-x"

  read1:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "-1"
      itemSeparator: ","

  read2:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "-2"
      itemSeparator: ","

  skip_unaligned:
    type: boolean
    default: true
    inputBinding:
      position: 5
      prefix: "--no-unal"

  output_file:
      type: string
      default: mapped.sam
      inputBinding:
        position: 6
        prefix: "-S"

outputs:

  alignment:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    outputBinding:
      glob: $(inputs.output_file)
  
