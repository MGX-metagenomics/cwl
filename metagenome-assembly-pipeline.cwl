class: Workflow
cwlVersion: v1.0
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
  - id: kraken2DatabaseDir
    type: Directory
    'sbg:x': 1405.8983154296875
    'sbg:y': -285.9196472167969
  - id: dastoolDatabaseDir
    type: Directory
    'sbg:x': 856.934814453125
    'sbg:y': -655.3026123046875
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
    label: 'fastp: An ultra-fast all-in-one FASTQ preprocessor'
    scatter:
      - read1
      - read2
    scatterMethod: dotproduct
    'sbg:x': -1147.20068359375
    'sbg:y': 389.0754699707031
  - id: megahit
    in:
      - id: read1
        source:
          - fastp/reads1
      - id: read2
        source:
          - fastp/reads2
    out:
      - id: contigs
    run: tools/megahit.cwl
    label: 'MEGAHIT: metagenome assembly'
    'sbg:x': -477.37213134765625
    'sbg:y': 392.39459228515625
  - id: samtools_sam2bam
    in:
      - id: input
        source: strobealign/sam
      - id: thread-number
        default: 8
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
        default: 8
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
  - id: prodigal
    in:
      - id: inputFile
        source: tsv2bins/binFastas
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    scatter:
      - inputFile
    scatterMethod: dotproduct
    'sbg:x': 1275.5765380859375
    'sbg:y': -337.3270568847656
  - id: feature_counts
    in:
      - id: annotation
        source: prodigal_1/annotations
      - id: attribute_type
        default: ID
      - id: bamFile
        source: samtools_sort/output
      - id: feature_type
        default: CDS
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    scatter:
      - bamFile
    scatterMethod: dotproduct
    'sbg:x': 1605.001953125
    'sbg:y': 299.0058898925781
  - id: kraken2
    in:
      - id: databaseDir
        source: kraken2DatabaseDir
      - id: proteinQuery
        default: true
      - id: querySequences
        source: prodigal/proteins
      - id: thread-number
        default: 10
    out:
      - id: output
    run: tools/kraken2.cwl
    scatter:
      - querySequences
    scatterMethod: dotproduct
    'sbg:x': 1525.156982421875
    'sbg:y': -324.01104736328125
  - id: assign_bin
    in:
      - id: kraken2Output
        source: kraken2/output
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
  - id: createtsvlist
    in:
      - id: file1
        source: vamb2bintsv/binAssignment
      - id: file2
        source: semibin2/binAssignment
    out:
      - id: files
    run: tools/CreateTSVList.cwl
    label: CreateTSVList
    'sbg:x': 751.8648071289062
    'sbg:y': -504.7113952636719
  - id: dastool
    in:
      - id: binAssignments
        source:
          - createtsvlist/files
      - id: contigs
        source: megahit/contigs
      - id: dastoolDatabaseDir
        source: dastoolDatabaseDir
      - id: threads
        default: 8
    out:
      - id: binTSV
    run: tools/dastool.cwl
    label: DAS tool
    'sbg:x': 966.7775268554688
    'sbg:y': -584.3911743164062
  - id: samtools_merge
    in:
      - id: inputs
        source:
          - samtools_sort/output
      - id: outFile
        default: total_mapped.bam
    out:
      - id: output
    run: tools/samtools-merge.cwl
    'sbg:x': 1086.564697265625
    'sbg:y': 551.5995483398438
  - id: feature_counts_1
    in:
      - id: annotation
        source: prodigal_1/annotations
      - id: attribute_type
        default: ID
      - id: bamFile
        source: samtools_merge/output
      - id: feature_type
        default: CDS
      - id: outFile
        default: featureCounts_total.tsv
    out:
      - id: output_counts
    run: tools/featureCounts.cwl
    'sbg:x': 1837.6478271484375
    'sbg:y': 553.8271484375
  - id: bamstats
    in:
      - id: bamFile
        source: samtools_merge/output
    out:
      - id: tsvOutput
    run: tools/bamstats.cwl
    label: 'bamstats: BAM alignment statistics per reference sequence'
    'sbg:x': 1698.8221435546875
    'sbg:y': 788.7218017578125
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
  - id: prodigal_1
    in:
      - id: inputFile
        source: megahit/contigs
    out:
      - id: annotations
      - id: genes
      - id: proteins
    run: tools/prodigal.cwl
    label: Prodigal 2.6.3
    'sbg:x': 1122.874755859375
    'sbg:y': 288.3991394042969
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
    'sbg:x': 1835.0096435546875
    'sbg:y': 176.96951293945312
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
        source:
          - renamefile/outfile
      - id: featureCountsTotal
        source: feature_counts_1/output_counts
      - id: hostURI
        source: hostURI
      - id: predictedGenes
        source: prodigal_1/annotations
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
    run: tools/seqrunfetch.cwl
    label: MGX Fetch sequences
    scatter:
      - runId
    scatterMethod: dotproduct
    'sbg:x': -1400.3929443359375
    'sbg:y': 389.80621337890625
  - id: strobealign
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
    label: StrobeAlign - fast short read aligner
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
    'sbg:x': 575.9758911132812
    'sbg:y': -542.1419067382812
requirements:
  - class: ScatterFeatureRequirement
