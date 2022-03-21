# Background & Intro

!!! warn

    Work in progress

Identifier resolution is a process of combining multiple identifiers
across devices, spreadsheets, repositories, and platforms into a
cohesive profile. The process includes searching across disparate
datasets and analyzing content to find (and resolve) matches based on
available data records and attributes. Identifier resolution is
complicated by distinctions in both structure and meaning because
various information systems can vary in quality, completeness, format,
and nomenclature.

TODO: add named UUIDs

Scenario / Use Case - Use a URI for identification without considering
impacts of impacts to unique identity by using an named identifier.

If you will only have a single gremlin vehicle, ever for-sale then you
could go with a URI for which there isn’t a concern for the uniqueness
as it’s not possible another will come along. Or, it could be managed
manually by checking for existence of the name of the vehicle prior and
incrementing.  
First gremlin -  
<https://ekgf.org/cars/for-sale#gremlin\>  
Second gremlin -
<https://ekgf.org/cars/for-sale#gremlin2\>  
Pro(s): Easy to implement  
Con(s): Chance of duplicates and collisions high

Scenario / Use Case - Any and all attributes can be used to make the URI
unique for identification and can be used for the URI

URL Encoded name concatenated to the URI .

<https://ekgf.org/cars/for-sale#gremlinUsed%20Vintage%20Gremlin%20%237\>  
<http://purl.org/goodrelations/v1#name\> "Used Vintage Gremlin \#7”

Pro(s): Easy to implement  
Con(s): Chance of duplicates and collisions moderate, uses more details
from the attributes. Discouraged, considered an anti-pattern for
designing ontologies.

Scenario / Use Case - Use a unique identifier from an external service
in the URI .

<https://ekgf.org/cars/for-sale#gremlin\> Could have a Vehicle
Identification Number added to the URI, the organization responsible for
VINs guarantees uniqueness
<https://ekgf.org/cars/for-sale#gremlinA3A465H399999\>

Pro(s): Easy to implement  
Con(s): Chance of duplicates and collisions moderate, uses more details
from the attributes

Scenario / Use Case - We can promote blank nodes to more explicit local
resources in the form urn: and/or id:

Perhaps we adopt urn:org:method:id, method could be base64, sha256, or
others which would indicate the type. could also look like:

create a blank node for VIN of the vehicle :A3A465H399999

<urn:ekgf:vin:\_:A3A465H399999\>

Pro(s): Gives a more normalized approach for blank nodes to be used with
other systems. Or not-well defined canonical scheme.  
Con(s): Debatable utility if you have a namespace already, if possible
use a prefix instead.

Scenario / Use Case - We can use an iso8601 date timestamp for a unique
identifier for the URI .

iso8601 generated date/time  
2021-11-22T03:28:4
