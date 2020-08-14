cwlVersion: v1.0
class: ExpressionTool

requirements:
 - class: InlineJavascriptRequirement

label: FilterEmptyFiles

inputs:

  input:
    type: File[]

outputs:

  output:
    type: {type: array, items: File}

expression: |
  ${
    var files = [];
    for (var i = 0; i < inputs.input.length; i++) {
      var file = inputs.input[i];
      if (file["size"] && file["size"] != 0) {
        files.push(file);
      }
    }
    return {"output": files};
  }

