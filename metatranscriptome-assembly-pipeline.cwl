class: Workflow
cwlVersion: v1.2
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
    doc: Name of the assembly
    'sbg:x': 4488.1689453125
    'sbg:y': -85.73023986816406
  - id: sequencingAdaptersFile
    type: File
    'sbg:x': -185.31167602539062
    'sbg:y': 196.1172637939453
outputs:
  - id: success
    outputSource:
      - annotationclient/success
    type: boolean
    'sbg:x': 4874.22802734375
    'sbg:y': -308.88360595703125
steps:
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
      - id: singleReads
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
          - trimmomatic_pe/fwdTrimmed
      - id: read2
        source:
          - trimmomatic_pe/revTrimmed
      - id: thread-number
        default: 125
      - id: unpaired
        source:
          - trimmomatic_se/fwdTrimmed
    out:
      - id: contigs
    run: tools/rnaspades.cwl
    label: rnaSPAdes
    'sbg:x': 444.4377136230469
    'sbg:y': 241.66441345214844
  - id: prodigal
    in:
      - id: inputFile
        source: rnaspades/contigs
      - id: metagenomic
        default: true
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    'sbg:x': 2489.327880859375
    'sbg:y': 239.57028198242188
  - id: samtools_sam2bam
    in:
      - id: input
        source: strobealign_pe/sam
    out:
      - id: output
    run: tools/samtools-sam2bam.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 1672.1806640625
    'sbg:y': 894.350830078125
  - id: samtools_sort
    in:
      - id: input
        source: samtools_sam2bam/output
    out:
      - id: output
    run: tools/samtools-sort.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 1964.7889404296875
    'sbg:y': 893.903564453125
  - id: feature_counts_se
    in:
      - id: annotation
        source: prodigal/annotations
      - id: bamFile
        source: samtools_sort_1/output
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    scatter:
      - bamFile
    scatterMethod: dotproduct
    'sbg:x': 3332.6796875
    'sbg:y': 333.0718994140625
  - id: samtools_merge_all
    in:
      - id: inputs
        linkMerge: merge_flattened
        source:
          - samtools_sort/output
          - samtools_sort_1/output
    out:
      - id: output
    run: tools/samtools-merge.cwl
    'sbg:x': 2846.90625
    'sbg:y': 1069.1043701171875
  - id: feature_counts_pe
    in:
      - id: annotation
        source: prodigal/annotations
      - id: bamFile
        source: samtools_sort/output
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    scatter:
      - bamFile
    scatterMethod: dotproduct
    'sbg:x': 3347.258056640625
    'sbg:y': 562.1612548828125
  - id: annotationclient
    in:
      - id: apiKey
        source: apiKey
      - id: assemblyName
        source: assemblyName
      - id: binnedFastas
        linkMerge: merge_nested
        source:
          - rnaspades/contigs
      - id: contigCoverage
        source: bamstats/tsvOutput
      - id: featureCountsPerSample
        linkMerge: merge_flattened
        source:
          - feature_counts_se/output_counts
          - feature_counts_pe/output_counts
      - id: featureCountsTotal
        source: merge_f_c/tsvOutput
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
        source: samtools_merge_all/output
      - id: outFile
        default: contig_coverage.tsv
    out:
      - id: tsvOutput
    run: tools/bamstats.cwl
    label: 'bamstats: BAM alignment statistics per reference sequence'
    'sbg:x': 3370.869140625
    'sbg:y': 1072.1676025390625
  - id: strobealign_pe
    in:
      - id: read1
        source: trimmomatic_pe/fwdTrimmed
      - id: read2
        source: trimmomatic_pe/revTrimmed
      - id: reference
        source: rnaspades/contigs
    out:
      - id: sam
    run: tools/strobealign.cwl
    label: 'StrobeAlign: map PE reads'
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': 1346.361572265625
    'sbg:y': 897.0208129882812
  - id: trimmomatic_se
    in:
      - id: end_mode
        default: SE
      - id: fwdReads
        source: ribodetector/fwdFiltered
      - id: input_adapters_file
        source: sequencingAdaptersFile
    out:
      - id: fwdTrimmed
      - id: revTrimmed
    run: tools/trimmomatic.cwl
    scatter:
      - fwdReads
    scatterMethod: dotproduct
    'sbg:x': 121.0569839477539
    'sbg:y': 76.77188873291016
    when: $(inputs.fwdReads != null)
  - id: trimmomatic_pe
    in:
      - id: end_mode
        default: PE
      - id: fwdReads
        source: ribodetector_1/fwdFiltered
      - id: revReads
        source: ribodetector_1/revFiltered
      - id: input_adapters_file
        source: sequencingAdaptersFile
    out:
      - id: fwdTrimmed
      - id: revTrimmed
    run: tools/trimmomatic.cwl
    scatter:
      - fwdReads
      - revReads
    scatterMethod: dotproduct
    'sbg:x': 117.1124038696289
    'sbg:y': 341.240966796875
  - id: strobealign_se
    in:
      - id: read1
        source: trimmomatic_se/fwdTrimmed
      - id: reference
        source: rnaspades/contigs
    out:
      - id: sam
    run: tools/strobealign.cwl
    label: 'StrobeAlign: map SE reads'
    scatter:
      - read1
    scatterMethod: dotproduct
    'sbg:x': 1324.580810546875
    'sbg:y': 50.46404266357422
  - id: samtools_sam2bam_1
    in:
      - id: input
        source: strobealign_se/sam
    out:
      - id: output
    run: tools/samtools-sam2bam.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 1661.573974609375
    'sbg:y': 56.39213180541992
  - id: samtools_sort_1
    in:
      - id: input
        source: samtools_sam2bam_1/output
    out:
      - id: output
    run: tools/samtools-sort.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 2009.41796875
    'sbg:y': 51
  - id: merge_f_c
    in:
      - id: featureCountsTSV
        linkMerge: merge_flattened
        source:
          - feature_counts_se/output_counts
          - feature_counts_pe/output_counts
      - id: outFile
        default: genecoverage_total.tsv
    out:
      - id: tsvOutput
    run: tools/mergeFC.cwl
    'sbg:x': 3665.084228515625
    'sbg:y': 403.438232421875
  - id: ribodetector
    in:
      - id: fwdReads
        source: seqrunfetch/singleReads
    out:
      - id: fwdFiltered
      - id: revFiltered
    run: tools/ribodetector.cwl
    label: RiboDetector
    scatter:
      - fwdReads
    scatterMethod: dotproduct
    'sbg:x': -461.6506042480469
    'sbg:y': 42.87717056274414
  - id: ribodetector_1
    in:
      - id: fwdReads
        source: seqrunfetch/fwdReads
      - id: revReads
        source: seqrunfetch/revReads
    out:
      - id: fwdFiltered
      - id: revFiltered
    run: tools/ribodetector.cwl
    label: RiboDetector
    scatter:
      - fwdReads
      - revReads
    scatterMethod: dotproduct
    'sbg:x': -459.84661865234375
    'sbg:y': 350.7164611816406
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
