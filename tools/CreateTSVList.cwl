cwlVersion: v1.0
class: ExpressionTool

requirements:
 - class: InlineJavascriptRequirement

label: CreateTSVList

inputs:

  file1:
    type: File
    format: http://edamontology.org/format_3475 # TSV

  file2:
    type: File
    format: http://edamontology.org/format_3475 # TSV

outputs:

  files:
    type: {type: array, items: File}

expression: |
  ${
    var files = [];
    if (inputs.file1["size"] && inputs.file1["size"] != 0) {
        files.push(inputs.file1)
    }
    if (inputs.file2["size"] && inputs.file2["size"] != 0) {
        files.push(inputs.file2)
    }
    return {"files": files};
  }

