---
layout: index
title: team | magellan-cli-0.10 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.10</a> / team <a href="/reference/en/resources/team.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli team list](#list)
- [magellan-cli team show [ID]](#show)
- [magellan-cli team select NAME](#select)
- [magellan-cli team deselect](#deselect)
- [magellan-cli team delete NAME](#delete)
- [magellan-cli team create NAME ROLE](#create)
- [magellan-cli team help [COMMAND]](#help)

## 共通オプション

```text
Options:
  -v, [--version], [--no-version]  # バージョンを表示します
  -V, [--verbose], [--no-verbose]  # 追加のログ情報を表示します
  -D, [--dryrun], [--no-dryrun]    # 登録や削除などのシステムには反映させずにアクションを実行します

```


## コマンドの詳細
### <a name="list"></a>list

```text
magellan-cli team list
```

teams の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli team show [ID]
```

IDで指定されたteamの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli team select NAME
```

NAMEを指定してteamを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli team deselect
```

teamの選択を解除します

### <a name="delete"></a>delete

```text
magellan-cli team delete NAME
```

NAMEを指定してteamを削除します

### <a name="create"></a>create

```text
magellan-cli team create NAME ROLE
```

NAMEとROLEを指定してteamを登録します

### <a name="help"></a>help

```text
magellan-cli team help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

