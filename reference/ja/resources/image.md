---
layout: index
title: image | magellan-cli-0.10 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.10</a> / image <a href="/reference/en/resources/image.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli image list](#list)
- [magellan-cli image show [ID]](#show)
- [magellan-cli image select NAME](#select)
- [magellan-cli image deselect](#deselect)
- [magellan-cli image help [COMMAND]](#help)

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
magellan-cli image list
```

images の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli image show [ID]
```

IDで指定されたimageの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli image select NAME
```

NAMEを指定してimageを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli image deselect
```

imageの選択を解除します

### <a name="help"></a>help

```text
magellan-cli image help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

