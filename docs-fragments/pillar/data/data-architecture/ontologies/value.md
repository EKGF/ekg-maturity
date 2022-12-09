### Contribution to the EKG

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

### Contribution to the Enterprise

Ontologies are needed to truly understand what a given set
of data really means and what can be inferred from it.
For example, you cannot rely on the name of a column in a
spreadsheet.
A deceptively simple column name such as "number of European
customers" leaves open the meaning of "European" and "customer"
and timing (when does one start and stop being a customer?).
And different sources could have different interpretations of
that same name.
The benefit is consistency, accuracy and the ability to make
sound business decisions.
Having the models themselves be resources that can be looked
up means that all data is self-defining and carries its
meaning with it.
In an EKG there is no fixed set of ontologies so it can
non-disruptively incorporate additional knowledge.
Ontologies allow data to be understood independent of the
format/technology and the vocabulary used in different
communities, saving misunderstandings and battles over
which word to use.
