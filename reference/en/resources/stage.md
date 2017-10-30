---
layout: index
title: stage | magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> / stage en <a href="/reference/ja/resources/stage.html">ja</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli stage list](#list)
- [magellan-cli stage show [ID]](#show)
- [magellan-cli stage select NAME](#select)
- [magellan-cli stage deselect](#deselect)
- [magellan-cli stage delete NAME](#delete)
- [magellan-cli stage create NAME [-t development|staging|production]](#create)
- [magellan-cli stage planning](#planning)
- [magellan-cli stage current](#current)
- [magellan-cli stage prepare](#prepare)
- [magellan-cli stage repair](#repair)
- [magellan-cli stage update ATTRIBUTES](#update)
- [magellan-cli stage release_now](#release_now)
- [magellan-cli stage logs](#logs)
- [magellan-cli stage set_container_num NUM](#set_container_num)
- [magellan-cli stage reload](#reload)
- [magellan-cli stage help [COMMAND]](#help)

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
magellan-cli stage list
```

Show a list of the stages

### <a name="show"></a>show

```text
magellan-cli stage show [ID]
```

Show the detail of the stage specified by ID

### <a name="select"></a>select

```text
magellan-cli stage select NAME
```

Select the stage by NAME

### <a name="deselect"></a>deselect

```text
magellan-cli stage deselect
```

Deselect the stage

### <a name="delete"></a>delete

```text
magellan-cli stage delete NAME
```

Delete the stage specified by NAME

### <a name="create"></a>create

```text
magellan-cli stage create NAME [-t development|staging|production]
```

```text
Options:
  [-t=T]  # -t development|staging|production specify Stage Type
          # Default: development
  [-s=S]  # -s micro|standard specify Stage Size
          # Default: micro

```

Create a new stage with Name and Type

### <a name="planning"></a>planning

```text
magellan-cli stage planning
```

Switch to planning to build next released version

### <a name="current"></a>current

```text
magellan-cli stage current
```

Switch to current released version

### <a name="prepare"></a>prepare

```text
magellan-cli stage prepare
```

Prepare the containers

### <a name="repair"></a>repair

```text
magellan-cli stage repair
```

Repair the stage status

### <a name="update"></a>update

```text
magellan-cli stage update ATTRIBUTES
```

Update the ATTRIBUTES of the selected stage

### <a name="release_now"></a>release_now

```text
magellan-cli stage release_now
```

```text
Options:
  [-A], [--no-A]  # -A async mode. release_now returns soon
  [-i=N]          # -i polling interval(seconds)
                  # Default: 10
  [-t=N]          # -t timeout(seconds)
                  # Default: 3600

```

Release the changes now

### <a name="logs"></a>logs

```text
magellan-cli stage logs
```

Fetch the logs of the workers

### <a name="set_container_num"></a>set_container_num

```text
magellan-cli stage set_container_num NUM
```

Set the number of containers for the selected image

### <a name="reload"></a>reload

```text
magellan-cli stage reload
```

Reload the last selections

### <a name="help"></a>help

```text
magellan-cli stage help [COMMAND]
```

Describe available commands or one specific command

