---
layout: index
title: cloudsql | magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> / cloudsql en <a href="/reference/ja/resources/cloudsql.html">ja</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli cloudsql list](#list)
- [magellan-cli cloudsql show [ID]](#show)
- [magellan-cli cloudsql select NAME](#select)
- [magellan-cli cloudsql deselect](#deselect)
- [magellan-cli cloudsql delete NAME](#delete)
- [magellan-cli cloudsql create NAME](#create)
- [magellan-cli cloudsql help [COMMAND]](#help)

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
magellan-cli cloudsql list
```

Show a list of the cloudsqls

### <a name="show"></a>show

```text
magellan-cli cloudsql show [ID]
```

Show the detail of the cloudsql specified by ID

### <a name="select"></a>select

```text
magellan-cli cloudsql select NAME
```

Select the cloudsql by NAME

### <a name="deselect"></a>deselect

```text
magellan-cli cloudsql deselect
```

Deselect the cloudsql

### <a name="delete"></a>delete

```text
magellan-cli cloudsql delete NAME
```

Delete the cloudsql specified by NAME

### <a name="create"></a>create

```text
magellan-cli cloudsql create NAME
```

```text
Options:
  [-A], [--no-A]  # -A async mode. release_now returns soon
  [-i=N]          # -i polling interval(seconds)
                  # Default: 10
  [-t=N]          # -t timeout(seconds)
                  # Default: 600

```

Create a new cloudsql database with NAME

### <a name="help"></a>help

```text
magellan-cli cloudsql help [COMMAND]
```

Describe available commands or one specific command

