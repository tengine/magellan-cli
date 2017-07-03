---
layout: index
title: container | magellan-cli-0.10 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.10</a> / container <a href="/reference/en/resources/container.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli container list](#list)
- [magellan-cli container show [ID]](#show)
- [magellan-cli container select NAME](#select)
- [magellan-cli container deselect](#deselect)
- [magellan-cli container help [COMMAND]](#help)

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
magellan-cli container list
```

containers の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli container show [ID]
```

IDで指定されたcontainerの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli container select NAME
```

NAMEを指定してcontainerを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli container deselect
```

containerの選択を解除します

### <a name="help"></a>help

```text
magellan-cli container help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

