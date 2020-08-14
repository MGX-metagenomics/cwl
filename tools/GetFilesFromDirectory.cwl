cwlVersion: v1.0
class: ExpressionTool

requirements:
 - class: InlineJavascriptRequirement

label: GetFilesFromDirectory

inputs:

  directory:
    type: Directory

outputs:

  files:
    type: {type: array, items: File}

expression: |
  ${
    var files = [];
    for (var i = 0; i < inputs.directory.listing.length; i++) {
      var file = inputs.directory.listing[i];
      if (file["class"] == "File") {
        files.push(file);
      }
    }
    return {"files": files};
  }

