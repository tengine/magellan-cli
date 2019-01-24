---
layout: index
title: http | magellan-cli-0.11 (en) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/en">magellan-cli-0.11</a> / http <a href="/reference/ja/messaging/http.html">ja</a> en
sidemenu: sidemenu/reference/magellan-cli/sidemenu-en
---

## Commands

- [magellan-cli http get PATH](#get)
- [magellan-cli http post PATH](#post)
- [magellan-cli http put PATH](#put)
- [magellan-cli http patch PATH](#patch)
- [magellan-cli http delete PATH](#delete)
- [magellan-cli http ping](#ping)
- [magellan-cli http help [COMMAND]](#help)

## Global Options

```text
Options:
  -v, [--version], [--no-version]  # Show the program version
  -V, [--verbose], [--no-verbose]  # Show additional logging information
  -D, [--dryrun], [--no-dryrun]    # Do a dry run without executing actions

```


## Details
### <a name="get"></a>get

```text
magellan-cli http get PATH
```

```text
Options:
  -H, [--headers=HEADERS]  # JSON style string or .yml or .json file path which has content

```

Send a HTTP request with GET method

### <a name="post"></a>post

```text
magellan-cli http post PATH
```

```text
Options:
  -d, [--body=BODY]        # String or file path which has body
  -H, [--headers=HEADERS]  # JSON style string or .yml or .json file path which has content

```

Send a HTTP request with POST method

### <a name="put"></a>put

```text
magellan-cli http put PATH
```

```text
Options:
  -d, [--body=BODY]        # String or file path which has body
  -H, [--headers=HEADERS]  # JSON style string or .yml or .json file path which has content

```

Send a HTTP request with PUT method

### <a name="patch"></a>patch

```text
magellan-cli http patch PATH
```

```text
Options:
  -d, [--body=BODY]        # String or file path which has body
  -H, [--headers=HEADERS]  # JSON style string or .yml or .json file path which has content

```

Send a HTTP request with PATCH method

### <a name="delete"></a>delete

```text
magellan-cli http delete PATH
```

```text
Options:
  -H, [--headers=HEADERS]  # JSON style string or .yml or .json file path which has content

```

Send a HTTP request with DELETE method

### <a name="ping"></a>ping

```text
magellan-cli http ping
```

Send a HTTP request to check connection

### <a name="help"></a>help

```text
magellan-cli http help [COMMAND]
```

Describe available commands or one specific command

