---
layout: index
title: cloudsql_instance | magellan-cli-0.9 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.9</a> / cloudsql_instance en <a href="/reference/ja/cloudsql_instance.html">ja</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli cloudsql_instance create INSTANCE](#create)
- [magellan-cli cloudsql_instance delete INSTANCE](#delete)
- [magellan-cli cloudsql_instance list](#list)
- [magellan-cli cloudsql_instance help [COMMAND]](#help)

## Global Options

```text
Options:
  -v, [--version], [--no-version]  # Show the program version
  -V, [--verbose], [--no-verbose]  # Show additional logging information
  -D, [--dryrun], [--no-dryrun]    # Do a dry run without executing actions

```


## Details
### <a name="create"></a>create

```text
magellan-cli cloudsql_instance create INSTANCE
```

```text
Options:
      [--tier=TIER]                                        # Tier of Cloud SQL instance. see also https://cloud.google.com/sql/pricing
                                                           # Default: D0
                                                           # Possible values: D0, D1, D2, D4, D8, D16, D32
      [--region=REGION]                                    # Region where the Cloud SQL instance works
                                                           # Default: asia-east1
      [--activation-policy=ACTIVATION-POLICY]              # The activation policy for this instance. This specifies when the instance should be activated and is applicable only when the instance state is RUNNABLE.
                                                           # Default: ON_DEMAND
                                                           # Possible values: ALWAYS, NEVER, ON_DEMAND
      [--skip-assign-ip], [--no-skip-assign-ip]            # Specified unless the instance must be assigned an IP address.
      [--authorized-networks=AUTHORIZED-NETWORKS]          # The list of external networks that are allowed to connect to the instance. Specified in CIDR notation, also known as 'slash' notation (e.g. 192.168.100.0/24).
                                                           # Default: 0.0.0.0/0
      [--gce-zone=GCE-ZONE]                                # The preferred Compute Engine zone (e.g. us-central1-a, us-central1-b, etc.).
                                                           # Default: asia-east1-c
      [--pricing-plan=PRICING-PLAN]                        # The pricing plan for this instance.
                                                           # Default: PER_USE
                                                           # Possible values: PACKAGE, PER_USE
  -p, [--password=PASSWORD]                                # The password for the root user.
      [--account=ACCOUNT]                                  # Google Cloud Platform user account to use for invocation.
      [--log-http], [--no-log-http]                        # Log all HTTP server requests and responses to stderr.
      [--project=PROJECT]                                  # Google Cloud Platform project ID to use for this invocation.
      [--trace-token=TRACE-TOKEN]                          # Token used to route traces of service requests for investigation of issues.
      [--user-output-enabled], [--no-user-output-enabled]  # Print user intended output to the console.
      [--verbosity=VERBOSITY]                              # Override the default verbosity for this command.  This must be a standard logging verbosity level: [debug, info, warning, error, critical, none] (Default: [warning]).
                                                           # Default: info
                                                           # Possible values: debug, info, warning, error, critical, none
      [--async], [--no-async]                              # translation missing: en.resources.cloudsql_instance.cmd_create.async
      [--format=FORMAT]                                    # Ignored even if it's given.
                                                           # Default: json

```

Create a new CloudSQL instance by INSTANCE

### <a name="delete"></a>delete

```text
magellan-cli cloudsql_instance delete INSTANCE
```

Delete the CloudSQL instance by INSTANCE

### <a name="list"></a>list

```text
magellan-cli cloudsql_instance list
```

Show list of the CloudSQL instance

### <a name="help"></a>help

```text
magellan-cli cloudsql_instance help [COMMAND]
```

Describe available commands or one specific command

