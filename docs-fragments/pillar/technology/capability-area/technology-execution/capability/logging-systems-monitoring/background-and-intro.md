!!! warn

    Work in progress
Logging & Monitoring

Monitoring software should provide transparent platform event observability. Events include of running out of space, high cpu utilization for extended periods of time, audit, and other crucial system resource and capacity utilization metrics.

Push notifications should exist from monitoring events so that teams can take action before issues become a problem. This may require setting up messaging from a host. Monitoring capability should also write information to logs.

Metrics output from logs created by monitoring software can help with forecasting growth for capacity planning, if the metrics are retained.

It’s useful to know peak usage, besides average(s). If peak utilization isn’t accounted for capacity planning then it’s very possible that when sizing new resources, it may be undersized. Metrics can help with existing resources and estimate new software licenses, space, processing power. Vendors and installation requirements on the platform software may provide guidance on how to perform calculations on disk, cpu, ram, and minimal software dependencies.

IT standards such as centralized logging facilities are often required, and vendor logs may need to be extended to support such needs.

Additional considerations are needed for monitoring and logging changes to storage of serialized RDF DataSets. This includes ontologies, t-box/terms with a-box/assertions instance data which is often not only stored as files, but also within a database. Typically, these databases keep the data in what they refer as a database and/or repository.

A couple of approaches to logging RDF DataSet / repository changes which can be used for propagation are RDF Delta and ChangeSets.

RDF Delta uses differences and patch logging to propagate changes. ChangeSets use reification to express actions that need to be performed on RDF.

If a difference log isn’t available then, changes may need to be orchestrated by customized bespoke approaches or complete non-differential fill exports of repositories.

Security changes should be logged for auditing significant changes such as repository creation. Sensitive/personal identifiable data needs to be kept out of logs in most cases. This also presents a challenge when troubleshooting, but often a must for compliance.

To perform troubleshooting it’s critical that members of the knowledge graph team know how to access and evaluate output from logs and monitoring software, as the output from these are usually how root cause is determined for issues and solutions arrived upon.

Governance usually requires tracking repositories and retention guidelines for types of data, so the logging may need an expiration system as it is data.
Thus, provenance should be stored within the logs to help provide source metadata, when possible.
