---
layout: index
title: stage | magellan-cli-0.10 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.10</a> / stage <a href="/reference/en/resources/stage.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

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
magellan-cli stage list
```

stages の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli stage show [ID]
```

IDで指定されたstageの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli stage select NAME
```

NAMEを指定してstageを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli stage deselect
```

stageの選択を解除します

### <a name="delete"></a>delete

```text
magellan-cli stage delete NAME
```

NAMEを指定してstageを削除します

### <a name="create"></a>create

```text
magellan-cli stage create NAME [-t development|staging|production]
```

```text
Options:
  [-t=T]  # -t development|staging|production いずれかのTYPEを指定してください
          # Default: development
  [-s=S]  # -s micro|standard いずれかのSIZEを指定してください
          # Default: micro

```

NAMEとTYPEを指定してstageを登録します

### <a name="planning"></a>planning

```text
magellan-cli stage planning
```

次回リリースのステージの計画に切り替えます

### <a name="current"></a>current

```text
magellan-cli stage current
```

現在リリースされているステージの情報に切り替えます

### <a name="prepare"></a>prepare

```text
magellan-cli stage prepare
```

containersを準備します

### <a name="repair"></a>repair

```text
magellan-cli stage repair
```

stageの状態を修正します

### <a name="update"></a>update

```text
magellan-cli stage update ATTRIBUTES
```

選択したstageの属性を指定したATTRIBUTESで更新します

### <a name="release_now"></a>release_now

```text
magellan-cli stage release_now
```

```text
Options:
  [-A], [--no-A]  # -A 非同期モード。リリースの終了を待たずにコマンドを終了します
  [-i=N]          # -i 状態を取得する間隔を秒で指定します
                  # Default: 10
  [-t=N]          # -t タイムアウトを秒で指定します
                  # Default: 3600

```

すぐにリリースを開始します

### <a name="logs"></a>logs

```text
magellan-cli stage logs
```

workersのログを表示します

### <a name="set_container_num"></a>set_container_num

```text
magellan-cli stage set_container_num NUM
```

選択されたimageのcontainersの数を設定します

### <a name="reload"></a>reload

```text
magellan-cli stage reload
```

最後にselectされたものをロードし直します

### <a name="help"></a>help

```text
magellan-cli stage help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

