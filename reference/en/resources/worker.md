---
layout: index
title: worker | magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> / worker <a href="/reference/ja/resources/worker.html">ja</a> en
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli worker list](#list)
- [magellan-cli worker show [ID]](#show)
- [magellan-cli worker select NAME](#select)
- [magellan-cli worker deselect](#deselect)
- [magellan-cli worker create NAME IMAGE](#create)
- [magellan-cli worker update ATTRIBUTES](#update)
- [magellan-cli worker prepare_images](#prepare_images)
- [magellan-cli worker help [COMMAND]](#help)

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
magellan-cli worker list
```

Show a list of the workers

### <a name="show"></a>show

```text
magellan-cli worker show [ID]
```

Show the detail of the worker specified by ID

### <a name="select"></a>select

```text
magellan-cli worker select NAME
```

Select the worker by NAME

### <a name="deselect"></a>deselect

```text
magellan-cli worker deselect
```

Deselect the worker

### <a name="create"></a>create

```text
magellan-cli worker create NAME IMAGE
```

```text
Options:
  -A, [--attributes-yaml=ATTRIBUTES_YAML]  # path to YAML file which defines attributes

```

Create a new worker with NAME and IMAGE

### <a name="update"></a>update

```text
magellan-cli worker update ATTRIBUTES
```

Update the ATTRIBUTES(filename or JSON) of the selected worker

### <a name="prepare_images"></a>prepare_images

```text
magellan-cli worker prepare_images
```

Prepare the images for the selected worker

### <a name="help"></a>help

```text
magellan-cli worker help [COMMAND]
```

Describe available commands or one specific command

