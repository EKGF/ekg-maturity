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

# Contribution to the EKG

Ontologies are the basis for [Principle Meaning](https://www.ekgf.org/principles):

```
The meaning of every data point must be directly resolvable to a
machine-readable definition in verifiable formal logic.
```

The link to precise meaning serves to mitigate problems created using the 
same word with multiple definitions;
and the challenges of expressing conceptual nuance using multiple informal sentences.
In the other direction, from ontology to vocabulary, it should be possible 
to generate a business glossary directly from ontologies for a given scope.
Since they should capture the meaning of concepts applicable to an organization,
or an even broader ecosystem, the choice of concepts to include in an EKG 
should be driven by business use cases.
And different overlapping ontologies may be included and mapped to cover 
different relevant aspects.
Likewise, it should be possible to generate---and map to---models for more
conventional tools from ontologies,
by applying technology-specific rules.

Semantic modeling also eliminates the problem of hard-coding assumptions 
about the world into a single data model.
And while multiple ontologies may coexist, they are able to be mapped
and connected to each other.
In a mature environment, the data modeling process drives technology implementation,
by defining the detailed data structures and associated APIs.
These components---along with functional code---are included as part
of the testing suite within the EKG to facilitate rapid deployment.

Different types of external data models are not needed in EKG but can 
be mapped to or generated.
In fact, physical data modelers are a community with their own vocabulary.

Constraints/shapes for models are applied by context (use case)---there 
is no _Single Version of the Truth_ (SVOT) for the EKG as a whole.
Different ontologies may be used for different contexts and mapped to 
each other in the underlying knowledge graph.

Ontology elements are linked to by vocabularies and mapped to other
data models and datasets to provide their meaning;
and from Use Cases to provide their scope.
These aspects are covered by those respective capabilities.
