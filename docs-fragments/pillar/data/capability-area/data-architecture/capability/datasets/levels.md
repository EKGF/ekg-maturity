# Maturity Levels

## Maturity Level 1

- [ ] Sources, data sets, and metadata are onboarded and expressed as _formal ontologies_
- [ ] Authoritative (upstream) data sources and (downstream) consumers are documented and verified by users,
      data, and technology
- [ ] The inventory of applications is defined and selected for graph applications
- [ ] Requirements and dependencies for each outbound data flow are documented and verified (implementation in the
      graph is not a requirement)
- [ ] Business glossaries for in-scope use cases are defined and verified in the graph (including a list of
      data sources and datasets)
- [ ] Policy implemented mandating inventory maintenance and only authorizing the use of data that has been logged
      into the inventory

## Maturity Level 2

- [ ] [_Use case tree(s) (UCTs)_](https://method.ekgf.org/concept/use-case-tree) is/are defined, 
      standardized, and implemented
- [ ] All upstream data sources are linked to the _authorized systems of record (SORs)_ and 
      distribution points
- [ ] Policy mandating the use of SORs and documentation of data flow is implemented
- [ ] Entitlements have been defined in the graph (governing access to sources of data in the inventory)
- [ ] _Classifications_ (i.e. _criticality_, _security_, _privacy_) are aligned with the use case tree
      and captured in the knowledge graph
- [ ] Governance requirements (i.e. use cases, _accountability_, _data sources_, _data flows_, 
      _service level agreements (SLAs)_) are modeled and registered into the knowledge graph

## Maturity Level 3

- [ ] _Data inventory_ is centralized in the graph and linked to governance for defined use cases
- [ ] Ontologies and data models (including change history and transformations) are registered in the knowledge graph
- [ ] Entitlements are calculated within the inventory and enforced at the _datapoint level_
- [ ] _Data Quality_ is automatically calculated (fine-grained with dynamic value resolution) 
      within the inventory for each use case
- [ ] Data retention rules are registered in the graph and automatically enforced
- [ ] Full audit trail for all upstream and downstream data usage is registered in the graph
- [ ] Data elements, calculation methods, and _critical data elements (CDEs)_ are linked to 
      individual _regulatory requirements_

## Maturity Level 4

- [ ] Connected inventory has been extended to include real-time (transactional) data
- [ ] Inventory is extended to external suppliers and third parties along the supply chain
- [ ] The inventory is fully integrated with _machine learning (ML)_ to optimize data flow
- [ ] The _“value of data”_ is calculated and classified within the organizational inventory

## Maturity Level 5

No further requirements.
