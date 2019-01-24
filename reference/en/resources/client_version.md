---
layout: index
title: client_version | magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> / client_version <a href="/reference/ja/resources/client_version.html">ja</a> en
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli client_version list](#list)
- [magellan-cli client_version show [ID]](#show)
- [magellan-cli client_version select VERSION](#select)
- [magellan-cli client_version deselect](#deselect)
- [magellan-cli client_version create VERSION](#create)
- [magellan-cli client_version update ATTRIBUTES](#update)
- [magellan-cli client_version delete VERSION](#delete)
- [magellan-cli client_version help [COMMAND]](#help)

## Global Options

```text
Options:
  -v, [--version], [--no-version]  # Show the program version
  -V, [--verbose], [--no-verbose]  # Show additional logging information
  -D, [--dryrun], [--no-dryrun]    # Do a dry run without executing actions

```


## Details
### <a name="list"></a>list

```text
magellan-cli client_version list
```

Show a list of the client_versions

### <a name="show"></a>show

```text
magellan-cli client_version show [ID]
```

Show the detail of the client_version specified by ID

### <a name="select"></a>select

```text
magellan-cli client_version select VERSION
```

Select the client_version by VERSION

### <a name="deselect"></a>deselect

```text
magellan-cli client_version deselect
```

Deselect the client_version

### <a name="create"></a>create

```text
magellan-cli client_version create VERSION
```

```text
Options:
  -d, [--domain=DOMAIN]  # Domain name for HTTP access without OAuth

```

Create a new client_version with VERSION

### <a name="update"></a>update

```text
magellan-cli client_version update ATTRIBUTES
```

Update the ATTRIBUTES(filename or JSON) of the selected client_version

### <a name="delete"></a>delete

```text
magellan-cli client_version delete VERSION
```

Delete the client_version specified by VERSION

### <a name="help"></a>help

```text
magellan-cli client_version help [COMMAND]
```

Describe available commands or one specific command

