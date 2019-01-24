---
layout: index
title: authority | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / authority ja <a href="/reference/en/resources/authority.html">en</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli authority list](#list)
- [magellan-cli authority show [ID]](#show)
- [magellan-cli authority select ID](#select)
- [magellan-cli authority deselect](#deselect)
- [magellan-cli authority update ATTRIBUTES](#update)
- [magellan-cli authority create PROJECT_ROLE STAGE_ROLE STAGE_TYPE](#create)
- [magellan-cli authority delete ID](#delete)
- [magellan-cli authority help [COMMAND]](#help)

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
magellan-cli authority list
```

authorities の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli authority show [ID]
```

IDで指定されたauthorityの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli authority select ID
```

ID を指定してauthorityを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli authority deselect
```

authorityの選択を解除します

### <a name="update"></a>update

```text
magellan-cli authority update ATTRIBUTES
```

選択したauthorityの属性を指定したATTRIBUTESで更新します

### <a name="create"></a>create

```text
magellan-cli authority create PROJECT_ROLE STAGE_ROLE STAGE_TYPE
```

PROJECT_ROLE STAGE_ROLE STAGE_TYPE を指定してauthorityを登録します

### <a name="delete"></a>delete

```text
magellan-cli authority delete ID
```

ID を指定してauthorityを削除します

### <a name="help"></a>help

```text
magellan-cli authority help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

