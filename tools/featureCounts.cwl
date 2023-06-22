#!/usr/bin/env featureCounts

# src https://raw.githubusercontent.com/byee4/featureCounts/master/featureCounts.cwl

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/featurecounts

baseCommand: featureCounts

inputs:
  annotation:
    type: File
    format: http://edamontology.org/format_2306 # GTF
    inputBinding:
      position: 0
      prefix: -a
    doc: "Name of an annotation file. GTF format by default. See -F option for more formats."

  # semi-required arguments (commonly modified params)
  strand:
    type: int
    default: 0
    inputBinding:
      position: -1
      prefix: -s
    doc: "Perform strand-specific read counting. Possible values:   0 (unstranded), 1 (stranded) and 2 (reversely stranded).  0 by default."
  pairs:
    type: boolean
    default: false
    inputBinding:
      position: -2
      prefix: -p
    doc: "Count fragments (read pairs) instead of individual reads.  For each read pair, its two reads must be adjacent to  each other in BAM/SAM input."
  primary_only:
    type: boolean
    default: false
    inputBinding:
      position: -3
      prefix: --primary
    doc: "Count primary alignments only. Primary alignments are  identified using bit 0x100 in SAM/BAM FLAG field."

  # other paired-end arguments
  paired:
    type: boolean
    default: true
    inputBinding:
      position: -4
      prefix: -p

  pair_validity:
    type: boolean
    default: false
    inputBinding:
      position: -5
      prefix: -P
    doc: "Check validity of paired-end distance when counting read  pairs. Use -d and -D to set thresholds."
  count_paired_map_only:
    type: boolean
    default: false
    inputBinding:
      position: -6
      prefix: -B
    doc: "Count read pairs that have both ends successfully aligned  only."
  discard_diff_chrom_mapping_pairs:
    type: boolean
    default: false
    inputBinding:
      position: -7
      prefix: -C
    doc: "Do not count read pairs that have their two ends mapping  to different chromosomes or mapping to same chromosome  but on different strands."

  # GTF/Annotation-specific params
  file_format:
    type: string
    default: 'GTF'
    inputBinding:
      position: -8
      prefix: -F
    doc: "Specify format of provided annotation file. Acceptable  formats include `GTF' and `SAF'. `GTF' by default. See  Users Guide for description of SAF format."
  feature_type:
    type: string
    default: exon
    inputBinding:
      position: -9
      prefix: -t
    doc: "Specify feature type in GTF annotation. `exon' by  default. Features used for read counting will be  extracted from annotation using the provided value."
  attribute_type:
    type: string
    default: gene_id
    inputBinding:
      position: -10
      prefix: -g
    doc: "Specify attribute type in GTF annotation. `gene_id' by  default. Meta-features used for read counting will be extracted from annotation using the provided value."
  feature_level:
    type: boolean
    default: false
    inputBinding:
      position: -11
      prefix: -f
    doc: "Perform read counting at feature level (eg. counting  reads for exons rather than genes)."

  # read params
  min_fragment_length:
    type: int
    default: 50
    inputBinding:
      position: -12
      prefix: -d
    doc: "Minimum fragment/template length, 50 by default."
  max_fragment_length:
    type: int
    default: 600
    inputBinding:
      position: -13
      prefix: -D
    doc: "Maximum fragment/template length, 600 by default."
  overlap:
    type: boolean
    default: false
    inputBinding:
      position: -14
      prefix: -O
    doc: "Assign reads to all their overlapping meta-features (or  features if -f is specified)."
  min_overlap:
    type: int
    default: 1
    inputBinding:
      position: -15
      prefix: --minOverlap
    doc: "Specify minimum number of overlapping bases requried  between a read and a meta-feature/feature that the read  is assigned to. 1 by default."
  largest_overlap:
    type: boolean
    default: false
    inputBinding:
      position: -16
      prefix: --largestOverlap
    doc: "Assign reads to a meta-feature/feature that has the  largest number of overlapping bases."

  # optional arguments
  multimapping:
    type: boolean
    default: false
    inputBinding:
      position: -17
      prefix: -M
    doc: "Multi-mapping reads will also be counted. For a multi- mapping read, all its reported alignments will be  counted. The `NH' tag in BAM/SAM input is used to detect  multi-mapping reads."

  # performance
  threads:
    type: int
    default: 10
    inputBinding:
      position: -18
      prefix: -T
    doc: "Number of the threads. 10 by default."

  bamFile:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 1

#  outFile:
#    type: string
#    default: "featurecounts.tsv"
#    inputBinding:
#      position: 1
#      prefix: "-o"

arguments: 
  - position: 1
    prefix: "-o"
    valueFrom: |
      ${
        return inputs.bamFile.nameroot.split("_")[0]  + ".tsv"
      }

outputs:

  output_counts:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.bamFile.nameroot.split("_")[0]  + ".tsv")
