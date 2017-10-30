---
layout: index
title: cloudsql | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / cloudsql <a href="/reference/en/resources/cloudsql.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli cloudsql list](#list)
- [magellan-cli cloudsql show [ID]](#show)
- [magellan-cli cloudsql select NAME](#select)
- [magellan-cli cloudsql deselect](#deselect)
- [magellan-cli cloudsql delete NAME](#delete)
- [magellan-cli cloudsql create NAME](#create)
- [magellan-cli cloudsql help [COMMAND]](#help)

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
magellan-cli cloudsql list
```

cloudsqls の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli cloudsql show [ID]
```

IDで指定されたcloudsqlの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli cloudsql select NAME
```

NAMEを指定してcloudsqlを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli cloudsql deselect
```

cloudsqlの選択を解除します

### <a name="delete"></a>delete

```text
magellan-cli cloudsql delete NAME
```

NAMEを指定してcloudsqlを削除します

### <a name="create"></a>create

```text
magellan-cli cloudsql create NAME
```

```text
Options:
  [-A], [--no-A]  # -A 非同期モード。リリースの終了を待たずにコマンドを終了します
  [-i=N]          # -i 状態を取得する間隔を秒で指定します
                  # Default: 10
  [-t=N]          # -t タイムアウトを秒で指定します
                  # Default: 600

```

NAMEを指定してcloudsql databaseを登録します

### <a name="help"></a>help

```text
magellan-cli cloudsql help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

