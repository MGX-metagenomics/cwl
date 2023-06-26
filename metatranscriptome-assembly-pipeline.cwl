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
    'sbg:x': -12.6336088180542
    'sbg:y': 332.4124450683594
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
    'sbg:x': -674.2255859375
    'sbg:y': 115.66755676269531
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
    'sbg:x': 728.2256469726562
    'sbg:y': 63.06300735473633
  - id: prodigal
    in:
      - id: inputFile
        source: rnaspades/contigs
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    'sbg:x': 1473.29443359375
    'sbg:y': 193.52017211914062
  - id: samtools_sam2bam
    in:
      - id: input
        source: strobealign/sam
    out:
      - id: output
    run: tools/samtools-sam2bam.cwl
    'sbg:x': 1672.1806640625
    'sbg:y': 894.350830078125
  - id: samtools_sort
    in:
      - id: input
        source: samtools_sam2bam/output
    out:
      - id: output
    run: tools/samtools-sort.cwl
    'sbg:x': 1964.7889404296875
    'sbg:y': 893.903564453125
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
    'sbg:x': 2846.90625
    'sbg:y': 1069.1043701171875
  - id: feature_counts_1
    in:
      - id: annotation
        source: prodigal/annotations
      - id: bamFile
        source: samtools_merge/output
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    'sbg:x': 3369.6025390625
    'sbg:y': 981.9159545898438
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
    'sbg:x': 3383.6025390625
    'sbg:y': 1242.5023193359375
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
    in: []
    out:
      - id: binFastas
    run: tools/tsv2bins.cwl
    label: TSV to binned FASTA
    'sbg:x': 3747.49755859375
    'sbg:y': -645.3556518554688
  - id: strobealign
    in:
      - id: read1
        source: fastp/reads2
      - id: read2
        source: fastp/reads1
      - id: reference
        source: rnaspades/contigs
    out:
      - id: sam
    run: tools/strobealign.cwl
    label: StrobeAlign - fast short read aligner
    'sbg:x': 1346.361572265625
    'sbg:y': 897.0208129882812
requirements:
  - class: ScatterFeatureRequirement
