class: CommandLineTool
cwlVersion: v1.0

baseCommand: "true"

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: $(inputs.newname + inputs.srcfile.nameext)
        entry: $(inputs.srcfile)

inputs:
  - id: srcfile
    type: File
    format: http://edamontology.org/format_3475 # TSV
  - id: newname
    type: string

outputs:
  - id: outfile
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.newname + inputs.srcfile.nameext)

