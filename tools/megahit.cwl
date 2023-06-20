cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/megahit

requirements:
  - class: ResourceRequirement
    ramMin: 250000
    coresMin: 128


label: "MEGAHIT: metagenome assembly"

baseCommand: megahit

inputs:

  read1:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 1
      prefix: "-1"
      itemSeparator: ","

  read2:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 2
      prefix: "-2"
      itemSeparator: ","

  interleaved:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "--12"
      itemSeparator: ","

  singleended:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "-r"
      itemSeparator: ","

#  outdir:
#    type: string
#    inputBinding:
#      position: 5
#      prefix: "-o"

  thread-number:
    type: int
    default: 128
    inputBinding:
      position: 6
      prefix: "--num-cpu-threads"

  min-contig-length:
    type: int?
    default: 1000
    inputBinding:
      position: 7 
      prefix: "--min-contig-len"

  presets:
    type: string?
    inputBinding:
      position: 8
      prefix: "--presets"

  memory:
    type: int?
    default: 250000000
    inputBinding:
      position: 9
      prefix: "--memory"

outputs:
  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "megahit_out/final.contigs.fa"

