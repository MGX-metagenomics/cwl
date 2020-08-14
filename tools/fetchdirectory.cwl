cwlVersion: v1.0
class: ExpressionTool


requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
    - entry: '$({"listing": [], "class": "Directory"})'
      entryname: $(inputs.dirName)

inputs:
  - id: dirName
    type: string

outputs:

  - id: directory
    type: Directory

expression: |
  ${
      var dir={};
      dir["class"]="Directory";
      dir["location"]=inputs.dirName;
      return {"directory": dir};
  }
