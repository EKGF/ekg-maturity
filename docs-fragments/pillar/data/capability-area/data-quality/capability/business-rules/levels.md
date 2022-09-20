# Levels

## Maturity Level 1

- [ ] [Data quality business rules](../../../data-governance/capability/classification-management)
      (conditions) have been defined, documented and, verified by _subject matter experts (SMEs)_ 
      (process for evaluation and acceptance defined)
- [ ] Business rules are aligned with in-scope [use cases](https://method.ekgf.org/concept/use-case)
      and specific [user stories](https://method.ekgf.org/concept/story)
- [ ] Business rules are standardized and registered into a repository with a defined mechanism for
      logging additions and performing updates

## Maturity Level 2

- [ ] A defined architecture exists to translate business rules into machine-executable code
      (some rules will be _OWL expressions_, some will be 
      [_SHACL shapes_ and _SHACL constraints_](https://www.w3.org/TR/shacl/#constraints-section),
      some will be translated into workflow logic)
- [ ] _Business provenance_ and _lineage_ are traceable across the _data supply chain_ and
      evaluated against defined business rules (all business rules must be traceable and understandable in
      context---must understand the purpose and importance of the rule)
- [ ] Business rules for in-scope use cases are implemented in the EKG

## Maturity Level 3

- [ ] Metrics---The measurement criteria are defined for data quality business rules (which rules are executed,
      how often, improvement)
- [ ] Performance---The value of business rules are related to business concepts (products, financial performance,
      organizational objectives)---able to trace the core relationship between the 
      [business objectives](/pillar/business/capability-area/strategy-actuation/capability/business-goals) and
      the data quality business rules (correlation between rules and outcomes are known, able to be queried and
      traceable within the EKG)

## Maturity Level 4

- [ ] Business rules are combined with _AI capability_ for compliance (dynamic optimization of business rules)
- [ ] Model-driven (senior management can begin to optimize business objectives using business rules in
      the EKG---i.e. alignment of business rules with “what if” scenarios)

## Maturity Level 5

- [ ] All business rules are driven by
      [business objectives](/pillar/business/capability-area/strategy-actuation/capability/business-goals) 
      (objectives are in the EKG with appropriate scorecards)
