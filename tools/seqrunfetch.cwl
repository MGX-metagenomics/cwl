cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/mgxannotate

label: "MGX Fetch sequences"


baseCommand: ["SeqRunFetcher"]

inputs:

  hostURI:
    type: string
    inputBinding:
      position: 1
      prefix: "-h"

  apiKey:
    type: string
    inputBinding:
      position: 2
      prefix: "-a"

  projectName:
    type: string
    inputBinding:
      position: 3
      prefix: "-p"

  runId:
    type: string
    inputBinding:
      position: 5 
      prefix: "-r"

outputs:

  fwdReads:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.runId + "_R1.fq")

  revReads:
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.runId + "_R2.fq")
 