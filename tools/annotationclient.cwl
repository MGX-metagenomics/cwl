cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/mgxannotate

label: "MGX Annotate"

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - '$(inputs.checkmReport)'
      - '$(inputs.binnedFastas)'
      - '$(inputs.binLineages)'
      - '$(inputs.featureCountsPerSample)'
      - '$(inputs.predictedGenes)'
      - '$(inputs.featureCountsTotal)'
      - '$(inputs.contigCoverage)'

baseCommand: ["annotationclient"]

inputs:

  assemblyName:
    type: string
    inputBinding:
      position: 1
      prefix: "-n"

  hostURI:
    type: string
    inputBinding:
      position: 2
      prefix: "-h"

  apiKey:
    type: string
    inputBinding:
      position: 3
      prefix: "-a"

  projectName:
    type: string
    inputBinding:
      position: 4
      prefix: "-p"

  runIds:
    type: string[]
    inputBinding:
      position: 5 
      prefix: "-s"
      itemSeparator: ","

  checkmReport:
    type: File?
    format: http://edamontology.org/format_3475 # TSV

  binnedFastas:
    type: File[]
    format: http://edamontology.org/format_1929 # FASTA

  binLineages:
    type: File[]?

  featureCountsPerSample:
    type: File[]
    format: http://edamontology.org/format_3475 # TSV

  predictedGenes:
    type: File
    format: http://edamontology.org/format_2306 # GTF

  featureCountsTotal:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    
  contigCoverage:
    type: File
    format: http://edamontology.org/format_3475 # TSV

arguments:

  - position: 5
    prefix: '-d'
    valueFrom: '$(runtime.outdir)'

outputs:

  success:
    type: boolean
    outputBinding:
      outputEval: $(true)
    
