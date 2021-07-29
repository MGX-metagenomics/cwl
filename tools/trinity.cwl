cwlVersion: v1.0
class: CommandLineTool

label: Trinity

baseCommand: Trinity

arguments:
  - position: 1
    prefix: '--seqType'
    valueFrom: 'fq'

  - position: 2
    prefix: '--output'
    valueFrom: 'trinity_out'

inputs:

  read1:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "--left"
      itemSeparator: ","

  read2:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "--right"
      itemSeparator: ","

  unpaired:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 5
      prefix: "--single"
      itemSeparator: ","

  thread-number:
    type: int?
    inputBinding:
      position: 6
      prefix: "--CPU"

  mem-limit:
    type: int?
    inputBinding:
      position: 7
      prefix: "--max_memory"

  min-contig-length:
    type: int?
    inputBinding:
      position: 8
      prefix: '--min_contig_length'

  inchworm-thread-number:
    type: int?
    inputBinding:
      position: 9
      prefix: "--inchworm_cpu"


outputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "trinity_out/Trinity.fasta"

