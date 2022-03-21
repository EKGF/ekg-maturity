# Background & Intro

!!! warn

    Work in progress

Identifier resolution is a process of combining multiple identifiers
across devices, spreadsheets, repositories, and platforms into a
cohesive profile. 
The process includes searching across disparate datasets and analyzing 
content to find (and resolve) matches based on available data records
and attributes. 
Identifier resolution is complicated by distinctions in both structure
and meaning because various information systems can vary in quality,
completeness, format, and nomenclature.

TODO: add named UUIDs

## Scenario A -- Meaningful named identifiers

Use a IRI for identification without considering impacts 
to unique identity by using a named identifier.

If you will only have a single gremlin vehicle, ever for-sale then you
could go with a IRI for which there isn’t a concern for the uniqueness
as it’s not possible another will come along.
Or, it could be managed manually by checking for existence of the name 
of the vehicle prior and incrementing.

- `<https://your.org/cars/for-sale#gremlin>` --- First gremlin
- `<https://your.org/cars/for-sale#gremlin2>` --- Second gremlin

Could also be:

- `<https://your.org/cars/for-sale/gremlin>` --- First gremlin
- `<https://your.org/cars/for-sale/gremlin2>` --- Second gremlin

| Pro                                                      | Con                                                                                                                                                                                                                          |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Easy to implement                                        | High chance of duplicates and collisions.                                                                                                                                                                                    |
| Mainstream way of doing things in Linked Open Data world | Cannot be used for _Things_ in confidential datasets such as People, Accounts etc, these "meaningful IRIs" would not be allowed --- by security/compliance staff --- to proliferate throughout the organization unprotected. | |
| Makes it easy for others to "guess" what an IRI would be | Assumptions about what an IRI would be will be hard-coded in downstream systems thereby creating a dependency on a your IRI-creation structure which will force you to never change that.                                    | 

## Scenario B -- Identifiers with encoded data

Any and all attributes can be used to make the IRI unique for 
identification and can be used for the IRI.

URL Encoded name concatenated to the IRI:

- `<https://your.org/cars/for-sale#gremlinUsed%20Vintage%20Gremlin%20%237>` --- "Used Vintage Gremlin #7”  
- `<http://purl.org/goodrelations/v1#name>` 

| Pro               | Con                                                                                                                                                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Easy to implement | Chance of duplicates and collisions moderate, uses more details from the attributes. Discouraged, considered an anti-pattern for designing ontologies.                                                                       |
|                   | Cannot be used for _Things_ in confidential datasets such as People, Accounts etc, these "meaningful IRIs" would not be allowed --- by security/compliance staff --- to proliferate throughout the organization unprotected. | |

## Scenario C -- Identifiers based on legacy-identifiers

Use a unique identifier from an external service in the IRI.

The IRI `<https://your.org/cars/for-sale#gremlin>` could have a _Vehicle
Identification Number_ (VIN) added to the IRI, the organization responsible for
VINs guarantees uniqueness
`<https://your.org/cars/for-sale#gremlinA3A465H399999>`

| Pro               | Con                                                                                 |
|-------------------|-------------------------------------------------------------------------------------|
| Easy to implement | Chance of duplicates and collisions moderate, uses more details from the attributes |

## Scenario D -- Identifiers in the form of a URN

We can promote blank nodes to more explicit local resources in the 
form `urn:` 

Perhaps we adopt `<urn:org:method:id>`, method could be `base64`, `sha256`, or
others which would indicate the type.

Could also look like:

- create a blank node for the VIN of the vehicle `A3A465H399999` with a
  URN like `<urn:ekgf:vin:A3A465H399999>`

| Pro                                                                                                                   | Con                                                                                   |
|-----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| Gives a more normalized approach for blank nodes to be used with other systems. Or not-well defined canonical scheme. | Debatable utility if you have a namespace already, if possible use a prefix instead.  |

## Scenario E -- Identifiers based on a timestamp

We can use an iso8601 date timestamp for a unique identifier for the IRI.

iso8601 generated date/time

2021-11-22T03:28:4

## Scenario F -- Identifiers based on a random number

We can use a random number for a unique identifier.

This could be done as a URL or a URN:

- URL: `<https://your.org/id/uuid4:7004b2a1-cede-4eaf-97aa-e3b42144c3e8>`
- URN: `<urn:yourorg:id:uuid4:7004b2a1-cede-4eaf-97aa-e3b42144c3e8>`

| Pro                                                                                                                           | Con                                                                                   |
|-------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| Useful for _Things_ that would otherwise be "blank nodes"                                                                     | Requires lookup service for anyone wanting to refer to a _Thing_ with a IRI like this |
| Useful for _Things_ that the dataset is authoritative for                                                                     | .                                                                                     |
| More secure: meaningless / opaque                                                                                             | .                                                                                     |
| Less dependency from downstream systems on source system since random URIs cannot be "guessed", they require a lookup-service | .                                                                                     | 

## Scenario G -- Identifiers based on a hash

We can hash the legacy key(s) of any given _Thing_ in the EKG and
create an IRI.

For a given key "this is a key", the SHA256 hash would
be `c9fc5d06292274fd98bcb57882657bf71de1eda4df902c519d915fc585b10190`.

- `<https://your.org/id/sha256:c9fc5d06292274fd98bcb57882657bf71de1eda4df902c519d915fc585b10190>`

| Pro                                                                                                                      | Con                                                                                            |
|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| Meaningless/Opaque, can safely proliferate via mail, excel, or social media throughout the ecosystem                     | Does not "look" nice for end-users in browsers (which can be resolved by using alias-URLs)     |
| The hash itself or the whole IRI can be used as foreign key in other databases.                                          |                                                                                                |
| Can still be "guessed" by hashing the original "legacy" key which makes it easier for others to make links to your data  | Can still be "guessed" which creates a dependency in downstream systems to your hashing-scheme |
| Allows for de-centralised linking to your data                                                                           |                                                                                                |

## Scenario H -- Identifiers based on a signed hash

Same as the previous Scenario with the difference that the given hash will
be signed before it ends up in the IRI.

| Pro                                                                                | Con                                                                               |
|------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Secure & Compliant, can be publicly proliferated even for confidential _Things_    | Requires others to have access to the signing certificate in order to make links  |
|                                                                                    | Requires more complicated ETL pipelines                                           |

