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



