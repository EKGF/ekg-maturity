# Background & Intro

!!! warn

    Work in progress
Data Integration

Within an Enterprise Knowledge Graph there is a need to map and combine data using ontologies as a basis for the integration of classes/concepts to achieve wisdom through common view(s) & model(s). Partners will need to exchange information within N-lines of business and N-shared activities. Data integration must support these activities to connect data silos.

Each lines of business can interchange data with concepts from ontologies for shared activities and transactions.

External data can also be interchanged with the enterprise using similar concepts from ontologies with vendors, channels, and customers.

Enterprise Knowledge Graphs when most mature fully implement a unity of heterogeneous sources. An evolving ontology drives data, information, knowledge, wisdom, and in turn is formed in that order. Graphs provide an operational structure to allow for chaining and integrating data to create information/data integration via linking data throughout.

RDF graphs are serializable by materialized data represented in the form of triples and/or quads. Direct import queries enables data to be integrated into and within a knowledge graph.

Extract, transform, load processes are necessary. Often these processes are abbreviated as ETL or ELT since the mapping/transform may occur once after a load process is performed.

RDF mapping language, RML, is a generalized source mapping language for RDF to facilitate data integration from non-RDF sources. Examples of RML sources include JSON,CSV, TSV, XML. R2RML is a subset of RML, designed for integration of data from relational sources leveraging JDBC.

CoNLL is a standard within NLP, Natural Language Processing, implemented in CSV/TSV. CoNLL can be stored using the expressiveness of RDF using CoNLL-RDF and converted back to CSV/TSV.

Data when materialized should be stored in various RDF file serialization formats such as: RDF/XML, JSON-LD, Turtle/TTL, NQUADS, NTriples, TriG, Trix, and n3. The tools used in the ETL/ELT process should support manipulating data in these common standardized knowledge graph formats.

ETL/ELT needs to orchestrated once of any scale with data pipelines and scheduling software.The simplest example would be using scheduling software with batch scripts, more elaborate open source examples would be using a Dev/MLOps framework. The goal of the ETL/ELT is to take RDF serialized data and incorporate into a knowledge graph RDF data store from serialized files. RDF data stores offer significant capabilities and performance over flat-file serialized files.

At the most mature level of a knowledge graph data integration must incorporate mapping using utilities and/or capabilities using RDF mapping languages and subsets, RDF serializable files, and RDF data stores using ETL/ELT data pipelines.
