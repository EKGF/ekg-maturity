# Background & Intro

An ontology is about:

- explicit meanings and relationships; the terms used are less important
- a combination of definitions in both text and logic

An ontology can be the basis of, but is broader than:

- a taxonomy
- a vocabulary
- a data or object model
- a conceptual model
- a specific serialization format

Ontologies can be expressed at different levels of sophistication, with different scopes,
and in a combination of languages.
The basic structures include:

**individual**

:   a representation of a business object or item which is the subject of information to be managed.
    An individual has a unique identity. For example `Person X` or `Shipment Y`.
    Many such individuals might represent the same real world object.

**data value**

:   strings, numbers, dates which represent the data.

**property**

:   a type of data point that may be associated with individuals.
    An individual, a property and a value --- which may be a data value or another
    individual --- form a triple.<br/>
    For example person `X hasBirthDate D` or person `X hasMother Y`.
    Triples whose value is another individual form relationships.
    Properties may have generalizations, for example `hasMother` is a
    `subProperty` of `hasParent`.

**class**

:   a category applied to individuals, that determines what you can do with them,
    the properties you can expect to see, and the rules that might apply;
    an individual may be a member of many classes associated;
    classes may have generalizations.
    Note that, unlike more traditional approaches, properties are independent of
    classes or class membership.
    For example, given the triple `X hasMother Y` you may be able to infer that both
    `X` and `Y` are members of the class `Person`, or at least `Animal`.

**ontology**

:   grouping of the above for management and identification purposes.


# Maturity Dimensions

- How much of the enterprise data is covered by ontologies?
- How well is ontology coverage mapped to business need?
- To what extent are concepts independent of but mapped to terminology/vocabulary?
- Level of sophistication of textual and logic definitions
- Level of tooling is available and used
- Level of training and trained people
- Level of process (including change management), guidelines and standards
- Level of modularity and reuse --- internal and external
- Extent of examples and tests
- Extent of traceability with different logical and physical data models
    

# Maturity Levels

The following criteria for each level are abbreviated: each item is shorthand for:

- documented process
- trained participants
- implemented process and/or technology
- monitoring and improvement

## Maturity Level 1

- [ ] Minimal ontologies which could be as simple as a list of classes and properties used in graphs
- [ ] Basic metadata (definition, label) for each class and property
- [ ] Each individual (in data) has at least one explicit class
- [ ] Ontology coverage for each use case in scope of the project;
  project includes minimal number of ontologies and classes not justified by a use case
- [ ] Definitions catalogued and under change management

## Maturity Level 2

- [ ] Ontologies expressed in a standard ontology language (could be as simple as \gls{ekg:rdf-schema})
- [ ] Common (shared or mapped) concepts across EKG projects
- [ ] Ability to see ontology usage by use cases, vocabularies and datasets
- [ ] Namespace scheme established and used for new ontologies in the EKG
- [ ] Ontology guidelines in place and implemented, including common metadata
- [ ] Documented approach for external ontologies, including selection and adaptation
- [ ] Annotated example files for documentation and training
- [ ] Test files based on use cases covering all used ontology elements
- [ ] Ontology change management includes impact analysis and stakeholder approval
- [ ] Tooling for ontology diagrams and documentation
- [ ] Automated basic checking of ontology syntax
- [ ] Access to at least one trained \gls{ekg:ontologist}

## Maturity Level 3

- [ ] Modeling of required data and constraints by use case, including for stored and communicated data
- [ ] Automated validation of ontologies (for guideline compliance, and for logical consistency),
  with results as triples
- [ ] Automated testing and validation of test data with ontologies (per use case)
- [ ] Separation of concerns to support enterprise management such as
  bi-temporality, transactions and events
- [ ] Automated transformation of ontologies to use common serialization and metadata
- [ ] Automated checking of ontologies against different profiles (e.g. OWL-RL)
  to check for technology support
- [ ] Automated checking of ontologies against different best practices
- [ ] Ontology source changes linked to automated [operations](/pillar/technology/capability-area/technology-execution/capability/operations/)
  for testing and deployment
- [ ] Impact analysis identifies ontology breaking changes which require fixes to existing EKG data
- [ ] EKG-wide ontology browsing and searching
- [ ] _Follow-your-nose_ UI starting from any ontology element URI[^predicate-iri]
- [ ] _Follow-your-nose_ API starting from any ontology element URI[^predicate-iri]
- [ ] Trained ontologist available to each project (ideally via the _EKG Center of Excellence_)

## Maturity Level 4

- [ ] Separation of ontologies from vocabularies, with multiple vocabularies for different communities
  mapped to the same concepts
- [ ] Ontology architecture management process, including use of patterns and modularity
- [ ] Generation of logic into business language
- [ ] Automated fixes to existing EKG data in response to ontology breaking changes
- [ ] Basic ontology metrics and reporting, including usage in data
- [ ] Generation of ontologies/shapes for external interchange

## Maturity Level 5

- [ ] Sophisticated ontology metrics and reporting, including trends
- [ ] Matching and differencing of ontologies from different sources
- [ ] Automated matching of ontologies with vocabularies
- [ ] Generation of validation code for external interchange
- [ ] Wizard for developing ontologies from business questions
- [ ] Inducing of ontologies from instance data

[^predicate-iri]: see also "predicate"
