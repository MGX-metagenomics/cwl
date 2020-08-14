cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/dastool

label: "DAS tool"

baseCommand: DAS_Tool

inputs:

  binAssignments:
    type: File[]?
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 1
      prefix: "-i"
      itemSeparator: ","

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    inputBinding:
      position: 2
      prefix: "-c"

  outPrefix:
    type: string
    default: "DASTool"
    inputBinding:
      position: 3 
      prefix: "-o"

  createPlots:
    type: boolean
    default: false
    inputBinding:
      position: 4
      prefix: "--create_plots"

  dastoolDatabaseDir:
    type: Directory
    inputBinding:
      position: 5
      prefix: "--db_directory"

  searchEngine:
    type: string
    default: "diamond"
    inputBinding:
      position: 6
      prefix: "--search_engine"

  threads:
    type: int?
    inputBinding:
      position: 7
      prefix: "-t"

  writeBinEvals:
    type: int
    default: 1
    inputBinding:
      position: 8
      prefix: "--write_bin_evals"

outputs:
  binTSV:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.outPrefix + "_DASTool_scaffolds2bin.txt")

