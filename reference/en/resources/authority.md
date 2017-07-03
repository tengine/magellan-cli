---
layout: index
title: authority | magellan-cli-0.10 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.10</a> / authority en <a href="/reference/ja/resources/authority.html">ja</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli authority list](#list)
- [magellan-cli authority show [ID]](#show)
- [magellan-cli authority select ID](#select)
- [magellan-cli authority deselect](#deselect)
- [magellan-cli authority update ATTRIBUTES](#update)
- [magellan-cli authority create PROJECT_ROLE STAGE_ROLE STAGE_TYPE](#create)
- [magellan-cli authority delete ID](#delete)
- [magellan-cli authority help [COMMAND]](#help)

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
magellan-cli authority list
```

Show a list of the authorities

### <a name="show"></a>show

```text
magellan-cli authority show [ID]
```

Show the detail of the authority specified by ID

### <a name="select"></a>select

```text
magellan-cli authority select ID
```

Select the authority by ID

### <a name="deselect"></a>deselect

```text
magellan-cli authority deselect
```

Deselect the authority

### <a name="update"></a>update

```text
magellan-cli authority update ATTRIBUTES
```

Update the ATTRIBUTES of the selected authority

### <a name="create"></a>create

```text
magellan-cli authority create PROJECT_ROLE STAGE_ROLE STAGE_TYPE
```

Create a new authority with PROJECT_ROLE STAGE_ROLE STAGE_TYPE

### <a name="delete"></a>delete

```text
magellan-cli authority delete ID
```

Delete the authority specified by ID

### <a name="help"></a>help

```text
magellan-cli authority help [COMMAND]
```

Describe available commands or one specific command

