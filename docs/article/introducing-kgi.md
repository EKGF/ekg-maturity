---
title: Introducing the EKG Matrix Plot & KGI Value
summary: Introducing the EKG Matrix Plot & KGI Value
authors:
- Carl Mattocks
date: 2022-03-06
some_url: https://maturity.ekgf.org/article/introducing-kgi/
---

New Jersey, 2021, [Carl Mattocks](../other/author/carl-mattocks.md)

# Introducing the EKG Matrix Plot & KGI Value

The Enterprise Knowledge Graph (EKG) 0-5 Level Maturity Model is an industry-standard 
knowledge management guideline with topics that support an evidence-rating system 
for organizational use of Knowledge Graphs (KG). 

In particular, it uses [Pillars](../pillar/index.md) of meta-knowledge, each containing a 
collection of subject area specific assessment criteria that are the related 
dimension values of distinct maturity metrics.

## EKG Matrix Plot

An EKG Matrix is a scatterplot of grouped maturity metrics that can be used 
to compute the Maturity Level of a particular business area.
Which may be scoped as a group of value stream Business Use Cases that 
graphed the build / operation of systems enabling capabilities. 
Equally a Matrix Plot defined with a Business Capability Axis, 
and a Dimension / Pillar Axis could provide group maturity metrics for 
All Business Use Cases that are measured across specific 
Pillars --- e.g. Organization, Data and Technology. 

!!! note

    Common vector elements are required to compute the sum of two or more Dimensions

Business Use Case – [**Enterprise Initiative Prioritization**](https://catalog.ekgf.org//use-case/other/enterprise-initiative-prioritization/)<br/>
EKG Matrix plot identifies Dimension/Pillar Maturity Levels:  2, 2, 3, 3, 2, 2

| D/P | D/P | D/P | D/P | D/P | D/P |
|-----|-----|-----|-----|-----|-----|
|     |     | xXx | xXx |     |     |
| xXx | xXx |     |     | xXx | xXx |
|     |     |     |     |     |     |

Business Use Case – [**Merger and Acquisition Evaluation and Integration**](https://catalog.ekgf.org/use-case/other/merger-and-acquisition-evaluation-and-integration/)<br/>
EKG Matrix plot identifies Dimension/Pillar Maturity Levels:  3, 3, 4, 3, 3, 3

| D/P | D/P | D/P | D/P | D/P | D/P |
|-----|-----|-----|-----|-----|-----|
|     |     | xXx |     |     |     |
| xXx | xXx |     | xXx | xXx | xXx |
|     |     |     |     |     |     |
|     |     |     |     |     |     |

Business Use Case – [**Identify Redundant Vendor Contracts**](https://catalog.ekgf.org/use-case/other/identify-redundant-vendor-contracts/)<br/>
EKG Matrix plot identifies Dimension/Pillar Maturity Levels:  3, 3, 3, 3, 4, 3 

| D/P | D/P | D/P | D/P | D/P | D/P |
|-----|-----|-----|-----|-----|-----|
|     |     |     |     | xXx |     |
| xXx | xXx | xXx | xXx |     | xXx |
|     |     |     |     |     |     |
|     |     |     |     |     |     |

## Knowledge Graph Indicator (KGI) Value

When in scope, a Matrix Plot for a named business --- EKG + Dimension have a 
common Business Identifier --- subject area specific assessment criteria may 
explicitly reference the evidence-rating of a _Knowledge Graph Indicator_ (KGI). 
Wherein, the KGI is a type of _Key Results Indicator_ that incorporates process 
outcome as a maturity factor. 
Whereas, content of the KG construct --- that lays out how specific 
business objects, events, situations are related --- has been subjected to a 
predefined treatment that inherently increased the value of that knowledge 
when utilized for the identified business capability. 
Whereby, a business capability may have one or more related dimension values 
that are unique to their value chain (of countable dimensional spaces). 

For example:

- Business Impact Dimension : Readability > Understandability > Influenceability
- FAIR Principles Dimension :  Findability +  Accessibility +  Interoperability

!!! note

    Matrix Plot for Systems Interoperability may have two axis --- workflow and dataset


## Evidence Rating Dimension

Evidence Rating Dimension is a countable dimensional space that indicates 
_Quality of Evidence Level_, such as, 5=High, 4=Moderate, 2=Low, 1=Very Low, 0=none.
Further, the method & criteria used to determine quality of evidence level is published. 
As in:

- Formulaically: a process may be any combination of task, function, 
  activity performed in a cycle that has a declared value + is specific to one or 
  more Pillar dimensions.
- Semantically, a process outcome may be defined as a capability specific goal, 
  objective, proposed value proposition or measurable result identified for a 
  particular strategy, plan, tactic or use case.
- Cross Pillar specific use cases can have different cycles and outcomes e.g.
    - intellectual property safeguards
    - data privacy protections
    - information security controls
    - value chain definitions

Evidence that KG was subjected to a predefined treatment could be that at least one 
critical Dimension has a level greater than 0 (none). 
Which could include:

1. Actual process outcome was verified by semantic matching with planned outcome
2. Process treatment was designed to enhance the value for a structure composed 
   of same types of business objects, events, situations
3. KGI Zone Parameters (which identify salient properties, such as, the 
   beginning-edge and the ending-edge of the particular knowledge graph) 
   are within stated range tolerances

