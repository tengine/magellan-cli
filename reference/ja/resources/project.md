---
layout: index
title: project | magellan-cli-0.10 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.10</a> / project <a href="/reference/en/resources/project.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli project list](#list)
- [magellan-cli project show [ID]](#show)
- [magellan-cli project select NAME](#select)
- [magellan-cli project deselect](#deselect)
- [magellan-cli project delete NAME](#delete)
- [magellan-cli project update ATTRIBUTES](#update)
- [magellan-cli project create NAME](#create)
- [magellan-cli project help [COMMAND]](#help)

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
magellan-cli project list
```

projects の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli project show [ID]
```

IDで指定されたprojectの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli project select NAME
```

NAMEを指定してprojectを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli project deselect
```

projectの選択を解除します

### <a name="delete"></a>delete

```text
magellan-cli project delete NAME
```

NAMEを指定してprojectを削除します

### <a name="update"></a>update

```text
magellan-cli project update ATTRIBUTES
```

選択したprojectの属性を指定したATTRIBUTESで更新します

### <a name="create"></a>create

```text
magellan-cli project create NAME
```

NAMEを指定してprojectを登録します

### <a name="help"></a>help

```text
magellan-cli project help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

