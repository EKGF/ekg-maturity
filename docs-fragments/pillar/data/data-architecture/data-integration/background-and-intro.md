A dataset represents a coherent and distinct data asset, or data product, including unstructured data. 

A dataset is a logical view on the EKG for a specific purpose and may not directly represent physical storage or a source of data. It may encompass subsetting (shapes, projection or selection) of a physical data store: (e.g. for ontologies: specific classes and properties; for relational databases specific rows and columns as well as tables).
The same data element could be exposed through many datasets (grouped/filtered differently subject to different access controls).

Datasets are in general usage outside specific enterprises:
- governments have public data catalogs e.g. US data.gov for many datasets, including published statistics;
- datasets cataloged by cloud providers (Google, Amazon) and commercial data publishers (Bloomberg, Factset etc) and may be available by download or API
- Wikidata
- scientific datasets submitted with papers to represent experimental data

## Dataset Metadata

The dataset metadata contains information about

- what data exists, 
- what it means (ontologies for the data set)
- cross-references e.g. to related data sets
    - family of datasets
    - vocabularies
    - ontologies
- where it resides (“data-at-rest”)
- format(s)
- how to access (UI, APIs, queries, reports etc)
- usage permission e.g. approved authoritative source
- link to data sharing agreements
- responsible parties
- lifecycle/maintenance/approval process
- retention and records management: legal requirements to both retain (legal hold) and delete (to avoid discovery).
  Requirements are jurisdiction-specific. 
- licensing (how the data can be used and by whom; pricing)
- data sharing agreements
- Snapshot vs dynamically updated (snapshot possibly for legal reasons)
- Compliance with [FAIR principles](https://principles.ekgf.org/fair/)
  (encompassed by [EKG Principles](https://principles.ekgf.org/principle/#__tabbed_1_2))
- accessibility/security 
- privacy (especially for personal data, need for masking/encryption)
- sensitivity (e.g. financial)
- upstream/downstream usage (lineage)
- how it moves (“data in motion”) 
- classifications/tagging
- quality metrics
- usage metrics (frequency of access, update, concentration of access)
- “data temperature” (frequency of access, change/volatility) - may determine storage media, in memory vs archive
- availability and other useful metrics (volumetrics)
- provenance e.g. source systems, lineage, derivation, processing, machine learning, simulation
- datasets usable for ML training data (check semantic tagging for relational data)  

See also [Self-describing Dataset (SDD)](https://principles.ekgf.org/vocab/sdd/).

