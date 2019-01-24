---
layout: index
title: organization | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / organization ja <a href="/reference/en/resources/organization.html">en</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli organization list](#list)
- [magellan-cli organization show [ID]](#show)
- [magellan-cli organization select NAME](#select)
- [magellan-cli organization deselect](#deselect)
- [magellan-cli organization delete NAME](#delete)
- [magellan-cli organization create NAME](#create)
- [magellan-cli organization help [COMMAND]](#help)

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
magellan-cli organization list
```

organizations の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli organization show [ID]
```

IDで指定されたorganizationの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli organization select NAME
```

NAMEを指定してorganizationを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli organization deselect
```

organizationの選択を解除します

### <a name="delete"></a>delete

```text
magellan-cli organization delete NAME
```

NAMEを指定してorganizationを削除します

### <a name="create"></a>create

```text
magellan-cli organization create NAME
```

NAMEを指定してorganizationを登録します

### <a name="help"></a>help

```text
magellan-cli organization help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

