!!! warn

    Work in progress

## What is key to operations?

Knowing that the EKG team will more than likely be hands off from production, and even non production environments due to Sarbanes-Oxley makes day-to-day infrastructure management very challenging. In a regulated environment, software installations and hardware will be intentionally deployed by other Information Technology, IT, teams and drive their configuration and support.

Infrastructure as code, which can be stored in source control, software allow teams to use markup such as YAML to manage configurations and orchestrate installation. A couple examples of open source software in this space include Ansible, Terraform, and Pulumi. EKG teams should try to leverage this to mitigate IT missteps that can and do occur while delegating the administration of the platform to other groups.

Regardless of having the ability to treat infrastructure as code. It’s imperative for the team to have access to an environment where they have privileges to run some of the infrastructure configuration manually and explore, as they may need to provide guidance to other IT teams such as a sandbox and/or lab. A sandbox is very useful to test and validate infrastructure in advance.

Sandboxes, which could include a group of virtual machine instances in a lab should be as flexible as possible, and interim ideally. That said, because of the flexibility they offer there could be a tendency for them to become more permanent because of less restrictions. IT support groups will need very concise but relevant documentation to perform tasks, a step by step runbook. The sandboxes in the lab are viable way to create runbook documentation.

Runbooks typically have specific configuration information, how to start and stopping software services, necessary permissions, troubleshooting tips, and other relevant server host information.

Separate environments are typically defined and adhered to such as Development, User Acceptance Testing Production, Disaster Recovery, defined by IT.  If you are doing machine learning, natural language processing, or anything which requires models , it may be imperative to have Production model training/development. This may seem counter intuitive to have a model training/development, but needed but may be challenging to justify as test data may not be representative due to redaction. 

Backups should be made both by disk image snapshots of the VMs, and serialized data exports from the software platform tools and utilities.

Containerization, such as Docker, and container management, such  as Kubernetes and Helm roles/playbooks, while pervasive may not be available. 

When not available numerous tool package managers such as pip, npm, brew, chocolatey, nixos, yum, apt are responsible for dependencies for underlying software components inevitably can fill the the gap but must be inventoried, understood, and dealt separately rather than just using as an opaque container provided. Package management can be categorized into operating system level, programming library, and application installation dependencies. This package management is often a time consuming, interwoven, tedious process, which should not to be under estimated for. Package managers can also be invoked from containers and infrastructure as code.
Typically in-house developed applications deployments are a push vs a pull, due to security requirements. Thus a DevOps pipeline incorporate Build from code, Archive artifacts, Scan for security issues, and Deploy to target server steps. A challenge is that custom applications use many libraries and packages, the application may expect to pull dependencies dynamically even at run time, in practice this may not be feasible on an air-gapped platform.  Dependencies may need to be incorporated prior at build time and archived, and not dynamically at run-time depending on IT regulation and governance.

When we are discussing operations, while important to the EKG team we typically are not discussing specific EKG roles of the platform with IT such as ontology versions. That said, we can discuss in terms they may understand such as ETL/ELT, data model management, and application performance vendor or developed in-house. It may be good to try to map terms the EKG is familiar with to IT terminology.

Not everything can be mapped to IT terminology and but imperative. For example.Ensuring ontology namespace IRIs are allocated by DNS .  An organization may have a preference for .net versus .com for example. That said, an ontologist may have no preference, unless it doesn’t change.

Any sort of artifact that expires such as certificates even DNS name allocations, should be managed by IT operations. These sort of infrastructure challenges may not even be visible or be on the agenda of the EKG team, but if not considered could cause outages while trying to rectify and determining responsibility.

Folders need to be organized where data is staged and materialized, not in a haphazard manner, if IT has standards - follow them.

Credentials should to be encrypted by a separate group and never given to a development team, if only for a temporary basis for troubleshooting and immediately changed after.

You must have a dedicated IT support team to the EKG group, with appropriate access to perform administrative tasks, not necessarily root/admin access but with just the right amount of access to perform application management and/or operating system level changes if and only if the platform requires it.

Release notes, platform, and other operational guidance should be published for the team to communicate with IT. It may also need to be restricted as some sensitive information could be maliciously used by sharing the configuration in a non-restricted manner. This information should be need to know only.

Logging and system monitoring is also very important but will be covered in a subsequent section.
