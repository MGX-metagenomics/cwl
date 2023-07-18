cwlVersion: v1.0
class: CommandLineTool

label: "VAMB to Bin TSV"

hints:
  DockerRequirement:
    dockerPull: sjaenick/smallscripts

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: reformat.sh
        entry: paste <(cut -f2 $(inputs.vambOutput.path)) <(cut -f1 $(inputs.vambOutput.path)) > reformatted.tsv

baseCommand: [ "bash", "reformat.sh" ]

inputs:
  vambOutput:
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

