---
layout: index
title: magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> /  en <a href="/reference/ja/index.html">ja</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli login](#login)
- [magellan-cli organization SUBCOMMAND ...ARGS](./resources/organization.html)
- [magellan-cli team SUBCOMMAND ...ARGS](./resources/team.html)
- [magellan-cli project SUBCOMMAND ...ARGS](./resources/project.html)
- [magellan-cli authority SUBCOMMAND ...ARGS](./resources/authority.html)
- [magellan-cli stage SUBCOMMAND ...ARGS](./resources/stage.html)
- [magellan-cli client_version SUBCOMMAND ...ARGS](./resources/client_version.html)
- [magellan-cli worker SUBCOMMAND ...ARGS](./resources/worker.html)
- [magellan-cli image SUBCOMMAND ...ARGS](./resources/image.html)
- [magellan-cli container SUBCOMMAND ...ARGS](./resources/container.html)
- [magellan-cli cloudsql SUBCOMMAND ...ARGS](./resources/cloudsql.html)
- [magellan-cli cloudsql_instance SUBCOMMAND ...ARGS](./cloudsql_instance.html)
- [magellan-cli http SUBCOMMAND ...ARGS](./messaging/http.html)
- [magellan-cli mqtt SUBCOMMAND ...ARGS](./messaging/mqtt.html)
- [magellan-cli info](#info)
- [magellan-cli help [COMMAND]](#help)

## Global Options

```text
Options:
  -v, [--version], [--no-version]  # Show the program version
  -V, [--verbose], [--no-verbose]  # Show additional logging information
  -D, [--dryrun], [--no-dryrun]    # Do a dry run without executing actions

```


## Details
### <a name="login"></a>login

```text
magellan-cli login
```

```text
Options:
  -e, [--email=EMAIL]                                # email address for login
  -p, [--password=PASSWORD]                          # password for login
  -t, [--authentication-token=AUTHENTICATION_TOKEN]  # authentication token for login

```

Login to the Magellan server

### <a name="info"></a>info

```text
magellan-cli info
```

Show login user and selected resources

### <a name="help"></a>help

```text
magellan-cli help [COMMAND]
```

Describe available commands or one specific command

