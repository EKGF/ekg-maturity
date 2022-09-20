# Levels

The goal is not always a single source of data - but rather the ability to choose the right authoritative source
for the appropriate context.

## Maturity Level 1

- [ ] All data sources are identified and documented for in-scope use cases
- [ ] Do we know the authoritative source for each data set (should not be able to do integration without
      using approved authoritative source)
- [ ] Does everyone agree that we are using the right sources (the right source for every
      context) --- link to governance
- [ ] Do we have an approved list of what each source feeds (precise description at the entity level that
      we can get from an approved source---must know if this is the primary source of the data per the
      use case context).<br/>
      _"For any given entity do I have all the potential sources and for a specific context do I know which
      is authorized."_
- [ ] There is a defined governance process for change management and testing (clear picture of all the
      dependencies for data integration).
      If there are changes to authoritative sources---do we know the downstream implications (tracked and tested)
- [ ] Are all _technology-stacks_ known and supported by current teams (are all key systems under the
      management and governance of the organization---should not have ghost systems that are not controlled
      as part of the integration process)
- [ ] Entitlement policies and classification rules (i.e. security, PII, business sensitive) are 
      defined and verified
- [ ] Data Quality requirements are defined, documented, and verified

## Maturity Level 2

- [ ] All information (above) are identified, precisely defined, and on-boarded into the knowledge graph
- [ ] Able to do _datapoint lineage_ (detailed and complete view of the data integration landscape)
- [ ] Start making the EKG the central point for data integration (the EKG becomes the _Rosetta stone_ of
      integration)---onboard systems, convert to RDF, integrate into EKG (defined as the
      data integration strategy---not necessarily complete)
- [ ] All data sets that are on-boarded into the EKG are coming from the authoritative sources.
      There are no man-in-the-middle systems.
      The goal is direct from the authoritative source to the target system for in-scope use cases.
      Must get <ins>the most granular data</ins> directly from the authoritative sources.
- [ ] All datasets are _"self-describing datasets" (SDDs)_.[^principle5]
- [ ] Policy---All data is obtained from the EKG as the authoritative source.
      Do not go directly to the originating source of the data.
- [ ] Entitlement policies and classification requirements are on-boarded into the EKG
- [ ] [Data quality business rules](../../../data-governance/capability/classification-management) 
      are on-boarded into the EKG

## Maturity Level 3

- [ ] Data is precisely defined (granular level)---expressed as formal ontologies---and on-boarded into the EKG
- [ ] All data flows are modeled, defined, and registered in the EKG (_full lineage_ in the EKG for all
      in-scope use cases or applications)
- [ ] Start to make the EKG the authoritative source (set-up to facilitate decommissioning of systems).
      The EKG is structured to become the “new” system for in-scope applications (as soon as all
      connections emanate from the EKG).
- [ ] Entitlements are automatically managed and enforced

## Maturity Level 4

- [ ] Policy---All downstream client systems are using authoritative sources as the only source of information
      for in-scope datasets (EKG is in the middle of all data flows)
- [ ] All “cottage industry systems” are replaced by the EKG (and EKG is able to perform all the 
      requirements of any system it replaced---reporting, entitlement, quality control)

## Maturity Level 5

No further requirements.

[^principle5]: See [EKG principle 5: Self-describing](https://principles.ekgf.org/principle/05-self-describing/)
