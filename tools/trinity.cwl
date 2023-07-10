cwlVersion: v1.0
class: CommandLineTool

label: Trinity

requirements:
  - class: InlineJavascriptRequirement

baseCommand: Trinity

arguments:
  - position: 1
    prefix: '--seqType'
    valueFrom: 'fq'

  - position: 2
    prefix: '--output'
    valueFrom: 'trinity_out'

  - position: 10
    prefix: '--workdir'
    valueFrom: |
      ${
        function hashCode(string){
          var hash = 0;
          for (var i = 0; i < string.length; i++) {
            var code = string.charCodeAt(i);
            hash = ((hash<<5)-hash)+code;
            hash = hash & hash; // Convert to 32bit integer
          }
          return hash;
        }

        var hash=0;
        if (inputs.read1 != null) {
          for (var i = 0; i < inputs.read1.length; i++) {
            hash += hashCode(inputs.read1[i].basename);
          }
        }

        if (inputs.read2 != null) {
          for (var i = 0; i < inputs.read2.length; i++) {
            hash += hashCode(inputs.read2[i].basename);
          }
        }

        if (inputs.unpaired != null) {
          for (var i = 0; i < inputs.unpaired.length; i++) {
            hash += hashCode(inputs.unpaired[i].basename);
          }
        }

        return inputs.scratchDirectoryName + "/trinity-" + hash;
      }

inputs:

  read1:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
      prefix: "--left"
      itemSeparator: ","

  read2:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
      prefix: "--right"
      itemSeparator: ","

  unpaired:
    type: File[]?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 5
      prefix: "--single"
      itemSeparator: ","

  thread-number:
    type: int
    inputBinding:
      position: 6
      prefix: "--CPU"

  mem-limit:
    type: string
    inputBinding:
      position: 7
      prefix: "--max_memory"

  min-contig-length:
    type: int?
    inputBinding:
      position: 8
      prefix: '--min_contig_length'

  inchworm-thread-number:
    type: int?
    inputBinding:
      position: 9
      prefix: "--inchworm_cpu"

  scratchDirectoryName:
    type: string

  cleanup:
    type: boolean
    default: true
    inputBinding:
      position: 11 
      prefix: "--full_cleanup"

  skipVersionCheck:
    type: boolean
    default: true
    inputBinding:
      position: 12
      prefix: "--no_version_check"

outputs:

  contigs:
    type: File
    format: http://edamontology.org/format_1929 # FASTA
    outputBinding:
      glob: "trinity_out.Trinity.fasta"

