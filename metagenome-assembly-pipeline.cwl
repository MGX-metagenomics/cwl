class: Workflow
cwlVersion: v1.2
id: metagenome_assembly_pipeline
label: Metagenome Assembly and Quantification
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: assemblyName
    type: string
    doc: Name of the assembly
    'sbg:x': 2291.843994140625
    'sbg:y': 135.27081298828125
  - id: runIds
    type: 'string[]'
    doc: MGX seqrun IDs
    'sbg:x': -1998.548095703125
    'sbg:y': -476.452392578125
  - id: apiKey
    type: string
    'sbg:x': -1995.6141357421875
    'sbg:y': -61.706756591796875
  - id: projectName
    type: string
    'sbg:x': -2003.3499755859375
    'sbg:y': -340.8485107421875
  - id: hostURI
    type: string
    'sbg:x': -2001.72265625
    'sbg:y': -196.57472229003906
  - id: taxonomyDirectory
    type: Directory
    'sbg:x': 1716.697509765625
    'sbg:y': -395.3261413574219
  - id: checkmDataDir
    type: Directory
    'sbg:x': 1310.708251953125
    'sbg:y': -735.12158203125
  - id: dastoolDatabaseDir
    type: Directory
    'sbg:x': 909.6793823242188
    'sbg:y': -747.2562866210938
  - id: metabuliDatabaseDir
    type: Directory
    'sbg:x': 1301.1171875
    'sbg:y': -289.041748046875
outputs:
  - id: success
    outputSource:
      - annotationclient/success
    type: boolean
    'sbg:x': 2657.0322265625
    'sbg:y': -49.6494140625
steps:
  - id: fastp
    in:
      - id: detect-paired-end-adapter
        default: true
      - id: read1
        source: seqrunfetch/fwdReads
      - id: read2
        source: seqrunfetch/revReads
      - id: trim-poly-g
        default: true
    out:
      - id: reads1
      - id: reads2
    run: tools/fastp.cwl
    label: 'fastp: trim PE reads'
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': -1094.861572265625
    'sbg:y': 419.8493957519531
  - id: megahit
    in:
      - id: presets
        default: meta-sensitive
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
      - id: singleended
        source:
          - fastp_1/reads1
        pickValue: all_non_null
    out:
      - id: contigs
    run: tools/megahit.cwl
    label: 'MEGAHIT: metagenome assembly'
    'sbg:x': -477.37213134765625
    'sbg:y': 392.39459228515625
  - id: samtools_sam2bam
    in:
      - id: input
        source: strobealign_pe/sam
      - id: thread-number
        default: 10
    out:
      - id: output
    run: tools/samtools-sam2bam.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 215.52435302734375
    'sbg:y': 552.3421020507812
  - id: samtools_sort
    in:
      - id: input
        source: samtools_sam2bam/output
      - id: thread-number
        default: 10
    out:
      - id: output
    run: tools/samtools-sort.cwl
    scatter:
      - input
    scatterMethod: dotproduct
    'sbg:x': 383.2618103027344
    'sbg:y': 558.3683471679688
  - id: checkm
    in:
      - id: bin_suffix
        default: fas
      - id: binnedFastas
        source:
          - tsv2bins/binFastas
      - id: dataDir
        source: checkmDataDir
    out:
      - id: output
    run: tools/checkm.cwl
    'sbg:x': 1425.5784912109375
    'sbg:y': -645.318115234375
  - id: feature_counts_pe_samples
    in:
      - id: annotation
        source: prodigal_assembly/annotations
      - id: attribute_type
        default: ID
      - id: bamFile
        source: samtools_sort/output
      - id: feature_type
        default: CDS
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    label: featureCounts per paired sample
    scatter:
      - bamFile
    scatterMethod: dotproduct
    'sbg:x': 1676.5452880859375
    'sbg:y': 433.1310729980469
  - id: assign_bin
    in:
      - id: kraken2Output
        source: metabuli/output
      - id: taxonomyDirectory
        source: taxonomyDirectory
    out:
      - id: lineage
    run: tools/assignBin.cwl
    label: Taxonomic assignment of a metagenomic bin
    scatter:
      - kraken2Output
    scatterMethod: dotproduct
    'sbg:x': 1866.4539794921875
    'sbg:y': -317.1265563964844
  - id: dastool
    in:
      - id: binAssignments
        linkMerge: merge_flattened
        source:
          - removefirstline/binAssignment
          - filterbin/filtered
          - metabat/binAssignment
      - id: contigs
        source: megahit/contigs
      - id: dastoolDatabaseDir
        source: dastoolDatabaseDir
      - id: threads
        default: 10
    out:
      - id: binTSV
    run: tools/dastool.cwl
    label: DAS tool
    'sbg:x': 1043.5084228515625
    'sbg:y': -626.27734375
  - id: bamstats
    in:
      - id: bamFile
        source: samtools_merge_all/output
      - id: outFile
        default: contig_coverage.tsv
    out:
      - id: tsvOutput
    run: tools/bamstats.cwl
    label: bamstats contig coverage
    'sbg:x': 1941.128662109375
    'sbg:y': 624.66259765625
  - id: tsv2bins
    in:
      - id: assembledContigs
        source: megahit/contigs
      - id: scaffold2bin
        source: dastool/binTSV
    out:
      - id: binFastas
    run: tools/tsv2bins.cwl
    label: TSV to binned FASTA
    'sbg:x': 1162.4385986328125
    'sbg:y': -487.7795104980469
  - id: prodigal_assembly
    in:
      - id: inputFile
        source: megahit/contigs
      - id: metagenomic
        default: false
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    'sbg:x': 1101.5889892578125
    'sbg:y': 372.96759033203125
  - id: annotationclient
    in:
      - id: apiKey
        source: apiKey
      - id: assemblyName
        source: assemblyName
      - id: binLineages
        source:
          - assign_bin/lineage
      - id: binnedFastas
        source:
          - tsv2bins/binFastas
      - id: checkmReport
        source: checkm/output
      - id: contigCoverage
        source: bamstats/tsvOutput
      - id: featureCountsPerSample
        linkMerge: merge_flattened
        source:
          - feature_counts_se_samples/output_counts
          - feature_counts_pe_samples/output_counts
      - id: featureCountsTotal
        source: merge_featurecounts/tsvOutput
      - id: hostURI
        source: hostURI
      - id: predictedGenes
        source: prodigal_assembly/annotations
      - id: projectName
        source: projectName
      - id: runIds
        source:
          - runIds
    out:
      - id: success
    run: tools/annotationclient.cwl
    label: MGX Annotate
    'sbg:x': 2443.158203125
    'sbg:y': -52.65791320800781
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
    'sbg:x': -1400.3929443359375
    'sbg:y': 389.80621337890625
  - id: strobealign_pe
    in:
      - id: read1
        source: fastp/reads1
      - id: read2
        source: fastp/reads2
      - id: reference
        source: megahit/contigs
      - id: skip_unaligned
        default: true
    out:
      - id: sam
    run: tools/strobealign.cwl
    label: 'StrobeAlign: map PE reads'
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': 30.550609588623047
    'sbg:y': 550.9737548828125
  - id: vamb
    in:
      - id: bamfiles
        source:
          - samtools_sort/output
      - id: contigs
        source: megahit/contigs
    out:
      - id: binAssignment
    run: tools/vamb.cwl
    label: VAMB
    'sbg:x': 502.3221130371094
    'sbg:y': -659.5704956054688
  - id: semibin2
    in:
      - id: bamfiles
        source:
          - samtools_sort/output
      - id: contigs
        source: megahit/contigs
    out:
      - id: binAssignment
    run: tools/semibin2.cwl
    label: SemiBin 2
    'sbg:x': 488.7420654296875
    'sbg:y': -821.9281005859375
  - id: vamb2bintsv
    in:
      - id: vambOutput
        source: vamb/binAssignment
    out:
      - id: binAssignment
    run: tools/vamb2bintsv.cwl
    label: VAMB to Bin TSV
    'sbg:x': 637.894775390625
    'sbg:y': -590.1747436523438
  - id: fastp_1
    in:
      - id: read1
        source: seqrunfetch/singleReads
    out:
      - id: reads1
      - id: reads2
    run: tools/fastp.cwl
    label: 'fastp: trim SE reads'
    scatter:
      - read1
    scatterMethod: dotproduct
    'sbg:x': -1085.7545166015625
    'sbg:y': 178.67938232421875
    when: $(inputs.read1 != null)
  - id: strobealign_se
    in:
      - id: read1
        source: fastp_1/reads1
        pickValue: all_non_null
      - id: reference
        source: megahit/contigs
    out:
      - id: sam
    run: tools/strobealign.cwl
    label: 'StrobeAlign: map SE reads'
    scatter:
      - read1
    scatterMethod: dotproduct
    'sbg:x': 16.529380798339844
    'sbg:y': 296.0989074707031
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
    'sbg:x': 199.96910095214844
    'sbg:y': 296.8038330078125
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
    'sbg:x': 353.5250244140625
    'sbg:y': 295.3158264160156
  - id: samtools_merge_all
    in:
      - id: inputs
        linkMerge: merge_flattened
        source:
          - samtools_sort_1/output
          - samtools_sort/output
    out:
      - id: output
    run: tools/samtools-merge.cwl
    'sbg:x': 1241.137451171875
    'sbg:y': 627.0687255859375
  - id: feature_counts_se_samples
    in:
      - id: annotation
        source: prodigal_assembly/annotations
      - id: attribute_type
        default: ID
      - id: bamFile
        source: samtools_sort_1/output
      - id: feature_type
        default: CDS
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    label: featureCounts per single-end sample
    scatter:
      - bamFile
    scatterMethod: dotproduct
    'sbg:x': 1676.52392578125
    'sbg:y': 251.05320739746094
  - id: removefirstline
    in:
      - id: infile
        source: semibin2/binAssignment
    out:
      - id: binAssignment
    run: tools/removefirstline.cwl
    label: remove first line
    'sbg:x': 638.3487548828125
    'sbg:y': -734.4201049804688
  - id: filterbin
    in:
      - id: assembledContigs
        source: megahit/contigs
      - id: binTSV
        source: vamb2bintsv/binAssignment
    out:
      - id: filtered
    run: tools/filterbin.cwl
    label: filter bin TSV by size
    'sbg:x': 763.8992919921875
    'sbg:y': -487.2594909667969
  - id: metabat
    in:
      - id: bamfiles
        source:
          - samtools_sort/output
      - id: contigs
        source: megahit/contigs
    out:
      - id: binAssignment
    run: tools/metabat.cwl
    label: >-
      MetaBAT: Metagenome Binning based on Abundance and Tetranucleotide
      frequency
    'sbg:x': 481.2071533203125
    'sbg:y': -973.3815307617188
  - id: merge_featurecounts
    in:
      - id: featureCountsTSV
        linkMerge: merge_flattened
        source:
          - feature_counts_se_samples/output_counts
          - feature_counts_pe_samples/output_counts
      - id: outFile
        default: genecoverage_total.tsv
    out:
      - id: tsvOutput
    run: tools/mergeFC.cwl
    'sbg:x': 1843.674072265625
    'sbg:y': 296.18115234375
  - id: metabuli
    in:
      - id: databaseDir
        source: metabuliDatabaseDir
      - id: querySequences
        source: tsv2bins/binFastas
    out:
      - id: output
    run: tools/metabuli.cwl
    scatter:
      - querySequences
    scatterMethod: dotproduct
    'sbg:x': 1495.70849609375
    'sbg:y': -319.610107421875
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
