cwlVersion: v1.0
class: CommandLineTool

label: "remove first line"

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: reformat.sh
        entry: tail +2 $(inputs.infile.path) > outfile.tsv

baseCommand: [ "bash", "reformat.sh" ]

inputs:
  infile:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 1

outputs:
  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: outfile.tsv

