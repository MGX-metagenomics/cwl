class: CommandLineTool
cwlVersion: v1.0

# adapted based on
# https://github.com/UMCUGenetics/CWL/blob/master/tools/trimmomatic.cwl
#

requirements:
  - class: ResourceRequirement
    ramMin: 3000
    coresMin: 10
  - class: InlineJavascriptRequirement

baseCommand: trimmomatic

inputs:

  - id: end_mode
    type: string
    inputBinding:
      position: 1
    doc: |
      SE|PE
      Single End (SE) or Paired End (PE) mode

  - id: threads
    default: 10
    type: int
    inputBinding:
      position: 2
      prefix: '-threads'

  - id: fwdReads
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 3
    doc: FASTQ file for input read (read R1 in Paired End mode)

  - id: revReads
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    inputBinding:
      position: 4
    doc: FASTQ file for read R2 in Paired End mode

  - id: illuminaclip
    default: ":2:30:10"
    type: string
    doc: >
      <fastaWithAdaptersEtc>:<seed mismatches>:<palindrome clip
      threshold>:<simple clip threshold>:<minAdapterLength>:<keepBothReads>

      Find and remove Illumina adapters.

      REQUIRED:

      <fastaWithAdaptersEtc>: specifies the path to a fasta file containing all
      the adapters, PCR sequences etc.

      The naming of the various sequences within this file determines how they
      are used. See below.

      <seedMismatches>: specifies the maximum mismatch count which will still
      allow a full match to be performed

      <palindromeClipThreshold>: specifies how accurate the match between the
      two 'adapter ligated' reads must be

      for PE palindrome read alignment.

      <simpleClipThreshold>: specifies how accurate the match between any
      adapter etc. sequence must be against a read

      OPTIONAL:

      <minAdapterLength>: In addition to the alignment score, palindrome mode
      can verify

      that a minimum length of adapter has been detected. If unspecified, this
      defaults to 8 bases,

      for historical reasons. However, since palindrome mode has a very low
      false positive rate, this

      can be safely reduced, even down to 1, to allow shorter adapter fragments
      to be removed.

      <keepBothReads>: After read-though has been detected by palindrome mode,
      and the

      adapter sequence removed, the reverse read contains the same sequence
      information as the
      forward read, albeit in reverse complement. For this reason, the default
      behaviour is to
      entirely drop the reverse read. By specifying "true" for this parameter,
      the reverse read will
      also be retained, which may be useful e.g. if the downstream tools cannot
      handle a combination of paired and unpaired reads.

  - id: input_adapters_file
    type: File
    format: http://edamontology.org/format_1929 # FASTA

  - id: slidingwindow
    type: string
    default: "4:20"
    inputBinding:
      position: 10
      prefix: 'SLIDINGWINDOW:'
      separate: false
    doc: >
      <windowSize>:<requiredQuality>

      Perform a sliding window trimming, cutting once the average quality within
      the window falls

      below a threshold. By considering multiple bases, a single poor quality
      base will not cause the

      removal of high quality data later in the read.

      <windowSize>: specifies the number of bases to average across

      <requiredQuality>: specifies the average quality required

  - id: minlen
    type: int
    default: 50
    inputBinding:
      position: 11
      prefix: 'MINLEN:'
      separate: false


outputs:

  - id: fwdTrimmed
    type: File
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.fwdReads.nameroot + "_trimmed.fq")

  - id: revTrimmed
    type: File?
    format: http://edamontology.org/format_1930 # FASTQ
    outputBinding:
      glob: $(inputs.revReads.nameroot + "_trimmed.fq")

arguments:

  - position: 5
    valueFrom: |
      ${
        inputs.fwdReads.nameroot + '_trimmed.fq'
      }
  - position: 6
    valueFrom: |
      ${
        inputs.fwdReads.nameroot + '_unpaired_trimmed.fq'
      }
  - position: 7
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.revReads)
          return inputs.revReads.nameroot + '_trimmed.fq'
        return null;
      }
  - position: 8
    valueFrom: |
      ${
        if (inputs.end_mode == "PE" && inputs.revReads)
          return inputs.revReads.nameroot + '_unpaired_trimmed.fq'
        return null;
      }

  - position: 9
    valueFrom: >-
      $("ILLUMINACLIP:" + inputs.input_adapters_file.path + ":"+
      inputs.illuminaclip)

