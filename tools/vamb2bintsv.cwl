cwlVersion: v1.0
class: CommandLineTool

label: "VAMB to Bin TSV"

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: reformat.sh
        entry: paste <(cut -f2 $(inputs.vambOutput)) <(cut -f1 $(inputs.vambOutput)) > reformatted.tsv

baseCommand: [ "bash", "reformat.sh" ]

inputs:
  vampOutput:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    inputBinding:
      position: 1

outputs:
  binAssignment:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: reformatted.tsv

