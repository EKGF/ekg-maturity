# Background & Intro

!!! warn

    Work in progress

# Contribution to the EKG

!!! warn

    Work in progress

# Contribution to the Enterprise

In the EKG, _critical data elements_ (CDEs) are defined by 
data quality business rules and expressed as 
machine-executable models.

!!! inline end "Comment Jacobus"
    We should be more explicit about this by saying that CDEs
    basically do not exist as such anymore, a data element is
    deemed critical from the point of view of the enterprise 
    perhaps but that's just one viewpoint, one context.
    In the EKG we have to serve any viewpoint.
    For every use case there are data elements (concepts) 
    that are critical which may be a whole different set of 
    data elements than what enterprise-level deems to be critical.
    All data elements are critical somewhere in some context.
    This has to do with the "Single-version-of-the-Truth-delusion".
    It's of course fine to label certain data elements as "critical"
    but it should be tied to the use case: Data element X is 
    critical for use case Y.

These rules are automatically executed across systems, 
processes and applications to ensure consistency.
Data is linked to the ontology and resolved to a 
single identifier to mitigate confusion about meaning when the
data is onboarded or transformed.
The EKG is able to trace data flow and verify that criticality
is aligned with _Sources of Record_ (SORs) and agreed usage.
