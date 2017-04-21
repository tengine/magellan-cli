---
layout: index
title: worker | magellan-cli-0.9 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.9</a> / worker <a href="/reference/en/resources/worker.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli worker list](#list)
- [magellan-cli worker show [ID]](#show)
- [magellan-cli worker select NAME](#select)
- [magellan-cli worker deselect](#deselect)
- [magellan-cli worker create NAME IMAGE](#create)
- [magellan-cli worker update ATTRIBUTES](#update)
- [magellan-cli worker prepare_images](#prepare_images)
- [magellan-cli worker help [COMMAND]](#help)

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
magellan-cli worker list
```

workers の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli worker show [ID]
```

IDで指定されたworkerの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli worker select NAME
```

NAMEを指定してworkerを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli worker deselect
```

workerの選択を解除します

### <a name="create"></a>create

```text
magellan-cli worker create NAME IMAGE
```

```text
Options:
  -A, [--attributes-yaml=ATTRIBUTES_YAML]  # 属性を定義するYAMLファイルへのパス

```

NAMEとIMAGEを指定してworkerを登録します

### <a name="update"></a>update

```text
magellan-cli worker update ATTRIBUTES
```

選択したworkerの属性を指定したATTRIBUTESで更新します。ATTRIBUTESにはYAMLのファイル名かJSON文字列を指定可能です

### <a name="prepare_images"></a>prepare_images

```text
magellan-cli worker prepare_images
```

選択されたworkerのimagesを準備します

### <a name="help"></a>help

```text
magellan-cli worker help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

