class: Workflow
cwlVersion: v1.0
id: metatranscriptome_assembly_pipeline
label: Metatranscriptome Assembly and Quantification
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: runIds
    type: 'string[]'
    doc: MGX seqrun IDs
    'sbg:x': -960.977783203125
    'sbg:y': -519.2344360351562
  - id: apiKey
    type: string
    'sbg:x': -959.557861328125
    'sbg:y': -141.82296752929688
  - id: projectName
    type: string
    'sbg:x': -959.6152954101562
    'sbg:y': -395.3645935058594
  - id: hostURI
    type: string
    'sbg:x': -955.8181762695312
    'sbg:y': -272.5052490234375
  - id: assemblyName
    type: string
    'sbg:x': 4488.1689453125
    'sbg:y': -85.73023986816406
outputs:
  - id: success
    outputSource:
      - annotationclient/success
    type: boolean
    'sbg:x': 4874.22802734375
    'sbg:y': -308.88360595703125
steps:
  - id: fastp
    in:
      - id: read1
        source: seqrunfetch/fwdReads
      - id: read2
        source: seqrunfetch/revReads
    out:
      - id: reads1
      - id: reads2
    run: tools/fastp.cwl
    label: 'fastp: An ultra-fast all-in-one FASTQ preprocessor'
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': -488.9007873535156
    'sbg:y': -373.6049499511719
  - id: seqrunfetch
    in:
      - id: apiKey
        source: apiKey
      - id: hostURI
        source: hostURI
      - id: projectName
        source: projectName
      - id: runId
        source: runIds
    out:
      - id: fwdReads
      - id: revReads
    run: tools/seqrunfetch.cwl
    label: MGX Fetch sequences
    scatter:
      - runId
    scatterMethod: dotproduct
    'sbg:x': -749.3961791992188
    'sbg:y': -371.4114685058594
  - id: rnaspades
    in:
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
    out:
      - id: contigs
    run: tools/rnaspades.cwl
    label: rnaSPAdes
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': -208.56771850585938
    'sbg:y': -769.5135498046875
  - id: trinity
    in:
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
    out:
      - id: contigs
    run: tools/trinity.cwl
    label: Trinity
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': -195.46559143066406
    'sbg:y': -603.2540283203125
  - id: concat_fasta
    in:
      - id: file1
        source: trinity/contigs
      - id: file2
        source: rnaspades/contigs
    out:
      - id: outputFile
    run: tools/concat-fasta.cwl
    label: concat-fasta
    'sbg:x': 67.10921478271484
    'sbg:y': -664.2275390625
  - id: cdhitest
    in:
      - id: transcripts
        source: concat_fasta/outputFile
    out:
      - id: contigs
    run: tools/cdhitest.cwl
    label: cd-hit-est
    'sbg:x': 346.70965576171875
    'sbg:y': -661.027099609375
  - id: bowtie2_build_1
    in:
      - id: reference
        source: cdhitest/contigs
    out:
      - id: index
    run: tools/bowtie2_build.cwl
    'sbg:x': 596.469482421875
    'sbg:y': -550.282470703125
  - id: bowtie2
    in:
      - id: index
        source:
          - bowtie2_build_1/index
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
    out:
      - id: alignment
    run: tools/bowtie2.cwl
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': 868
    'sbg:y': -271.8039855957031
  - id: samtools_unmapped_mates
    in:
      - id: input
        source: bowtie2/alignment
    out:
      - id: output
    run: tools/samtools-unmapped-mates.cwl
    label: samtools-get-unmapped-pairs
    'sbg:x': 1135.1220703125
    'sbg:y': -309.0032043457031
  - id: samtools_sam_to_paired_fastq
    in:
      - id: input
        source: samtools_unmapped_mates/output
    out:
      - id: fastq_fwd
      - id: fastq_rev
    run: tools/samtools-sam-to-paired-fastq.cwl
    label: samtools-sam-to-paired-fastq
    'sbg:x': 1408.97705078125
    'sbg:y': -309.6297607421875
  - id: rnaspades_1
    in:
      - id: read1
        source:
          - samtools_sam_to_paired_fastq/fastq_fwd
      - id: read2
        source:
          - samtools_sam_to_paired_fastq/fastq_rev
    out:
      - id: contigs
    run: tools/rnaspades.cwl
    label: rnaSPAdes
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': 1695.9752197265625
    'sbg:y': -309.67938232421875
  - id: concat_fasta_1
    in:
      - id: file1
        source: rnaspades_1/contigs
      - id: file2
        source: cdhitest/contigs
    out:
      - id: outputFile
    run: tools/concat-fasta.cwl
    label: concat-fasta
    'sbg:x': 1930.2957763671875
    'sbg:y': -642.484619140625
  - id: cdhitest_1
    in:
      - id: transcripts
        source: concat_fasta_1/outputFile
    out:
      - id: contigs
    run: tools/cdhitest.cwl
    label: cd-hit-est
    'sbg:x': 2286.81494140625
    'sbg:y': -642.4446411132812
  - id: bowtie2_build
    in:
      - id: reference
        source: cdhitest_1/contigs
    out:
      - id: index
    run: tools/bowtie2_build.cwl
    'sbg:x': 2565.9423828125
    'sbg:y': -267.0924377441406
  - id: bowtie3
    in:
      - id: index
        source:
          - bowtie2_build/index
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
    out:
      - id: alignment
    run: tools/bowtie2.cwl
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': 2981.4169921875
    'sbg:y': 466.68475341796875
  - id: prodigal
    in:
      - id: inputFile
        source: cdhitest_1/contigs
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    'sbg:x': 2953.932861328125
    'sbg:y': -437.1302185058594
  - id: samtools_sam2bam
    in:
      - id: input
        source: bowtie3/alignment
    out:
      - id: output
    run: tools/samtools-sam2bam.cwl
    'sbg:x': 3209.06591796875
    'sbg:y': 467.7261962890625
  - id: samtools_sort
    in:
      - id: input
        source: samtools_sam2bam/output
    out:
      - id: output
    run: tools/samtools-sort.cwl
    'sbg:x': 3440.858154296875
    'sbg:y': 463.122314453125
  - id: feature_counts
    in:
      - id: annotation
        source: prodigal/annotations
      - id: bamFile
        source: samtools_sort/output
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    'sbg:x': 3685.063720703125
    'sbg:y': 118.17881774902344
  - id: samtools_merge
    in:
      - id: inputs
        source:
          - samtools_sort/output
    out:
      - id: output
    run: tools/samtools-merge.cwl
    'sbg:x': 3703.7197265625
    'sbg:y': 596.8690185546875
  - id: feature_counts_1
    in:
      - id: annotation
        source: prodigal/annotations
      - id: bamFile
        source: samtools_merge/output
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    'sbg:x': 4042.80078125
    'sbg:y': 566.7847290039062
  - id: annotationclient
    in:
      - id: apiKey
        source: apiKey
      - id: assemblyName
        source: assemblyName
      - id: binnedFastas
        source:
          - tsv2bins/binFastas
      - id: contigCoverage
        source: bamstats/tsvOutput
      - id: featureCountsPerSample
        source:
          - renamefile/outfile
      - id: featureCountsTotal
        source: feature_counts_1/output_counts
      - id: hostURI
        source: hostURI
      - id: predictedGenes
        source: prodigal/annotations
      - id: projectName
        source: projectName
      - id: runIds
        source:
          - runIds
    out:
      - id: success
    run: tools/annotationclient.cwl
    label: MGX Annotate
    'sbg:x': 4642.23876953125
    'sbg:y': -306
  - id: bamstats
    in:
      - id: bamFile
        source: samtools_merge/output
    out:
      - id: tsvOutput
    run: tools/bamstats.cwl
    label: 'bamstats: BAM alignment statistics per reference sequence'
    'sbg:x': 4056.581787109375
    'sbg:y': 759.6453247070312
  - id: renamefile
    in:
      - id: srcfile
        source: feature_counts/output_counts
      - id: newname
        source: runIds
    out:
      - id: outfile
    run: tools/renamefile.cwl
    scatter:
      - srcfile
      - newname
    scatterMethod: dotproduct
    'sbg:x': 3892.1767578125
    'sbg:y': 186.96112060546875
  - id: tsv2bins
    in:
      - id: assembledContigs
        source: cdhitest_1/contigs
    out:
      - id: binFastas
    run: tools/tsv2bins.cwl
    label: TSV to binned FASTA
    'sbg:x': 3747.49755859375
    'sbg:y': -645.3556518554688
hints:
  - {}
requirements:
  - class: ScatterFeatureRequirement
