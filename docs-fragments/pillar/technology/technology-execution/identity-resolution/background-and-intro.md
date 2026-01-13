Identifier resolution is a crucial process within the Enterprise Knowledge Graph (EKG), 
guided by the principles of the Enterprise Knowledge Graph Foundation[^principles].
It ensures that every object in the EKG has a unique, permanent, and resolvable identifier
known as the EKG Identifier (EKG IRI). 
This identifier serves as the primary means of identifying and connecting objects within 
the EKG ecosystem.

The EKG IRI offers several advantages. It provides a consistent and unchanging identifier 
that simplifies identity mapping and promotes interoperability across different EKGs. 
By encouraging the use of standardized EKG IRIs, the number of connections between 
EKGs increases, fostering better interoperability.

Resolving identifiers within the EKG can be achieved through different methods, 
including lookup services, standardized policies with hashing, and generating EKG IRIs 
for authoritative objects. 
These approaches ensure that the identifiers remain reliable and resolvable over time.

Adopting EKG IRIs requires considering factors such as mapping other identifiers to the 
EKG IRI, maintaining the opacity of EKG IRIs to prevent human-readable ambiguity, 
and handling objects with existing RDF and Linked Data compliant identifiers. 
It's important to note that using multiple EKG identifiers, often in conjunction with 
legacy identifiers, means that the Unique Name Assumption (UNA) should be avoided 
within the EKG.

By following these practices, organizations can establish a robust and consistent 
identification framework within their EKG, promoting data integrity, interoperability,
and long-term resolvability.

[^principles]: The [10 EKG principles](https://principles.ekgf.org/principle/#__tabbed_1_2)
