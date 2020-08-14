cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/metabat

label: "MetaBAT: Metagenome Binning based on Abundance and Tetranucleotide frequency"

requirements:
  - class: InlineJavascriptRequirement

baseCommand: runMetaBat.sh

inputs:

  thread-number:
    type: int?
    inputBinding:
      position: 1
      prefix: "--numThreads"

  save-unbinned:
    type: boolean?
    default: false
    inputBinding:
      position: 2
      prefix: "--unbinned"

  save-class:
    type: boolean?
    default: true
    inputBinding:
      position: 3
      prefix: "--saveCls"

  min-contig-length:
    type: int?
    inputBinding:
      position: 4 
      prefix: "--minContig"

  min-class-size:
    type: int?
    inputBinding:
      position: 5 
      prefix: "--minClsSize"

  suppressBinOutput:
    type: boolean
    default: true
    inputBinding:
      position: 6
      prefix: "--noBinOut"

  contigs:
    type: File
    inputBinding:
      position: 7

  bamfiles:
    type: File[]
    inputBinding:
      position: 8

outputs:

  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.contigs.basename).metabat-bins/bin

