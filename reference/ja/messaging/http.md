---
layout: index
title: http | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / http <a href="/reference/en/messaging/http.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli http get PATH](#get)
- [magellan-cli http post PATH](#post)
- [magellan-cli http put PATH](#put)
- [magellan-cli http patch PATH](#patch)
- [magellan-cli http delete PATH](#delete)
- [magellan-cli http ping](#ping)
- [magellan-cli http help [COMMAND]](#help)

## 共通オプション

```text
Options:
  -v, [--version], [--no-version]  # バージョンを表示します
  -V, [--verbose], [--no-verbose]  # 追加のログ情報を表示します
  -D, [--dryrun], [--no-dryrun]    # 登録や削除などのシステムには反映させずにアクションを実行します

```


## コマンドの詳細
### <a name="get"></a>get

```text
magellan-cli http get PATH
```

```text
Options:
  -H, [--headers=HEADERS]  # JSON形式の文字列か、拡張子が.ymlのYAML形式のファイルへのパス、あるいは拡張子が.jsonのJSON形式のファイルへのパス

```

GETメソッドを使ってHTTPリクエストを送信します

### <a name="post"></a>post

```text
magellan-cli http post PATH
```

```text
Options:
  -d, [--body=BODY]        # 内容を表す文字列か、内容を保持するファイルへのパス
  -H, [--headers=HEADERS]  # JSON形式の文字列か、拡張子が.ymlのYAML形式のファイルへのパス、あるいは拡張子が.jsonのJSON形式のファイルへのパス

```

POSTメソッドを使ってHTTPリクエストを送信します

### <a name="put"></a>put

```text
magellan-cli http put PATH
```

```text
Options:
  -d, [--body=BODY]        # 内容を表す文字列か、内容を保持するファイルへのパス
  -H, [--headers=HEADERS]  # JSON形式の文字列か、拡張子が.ymlのYAML形式のファイルへのパス、あるいは拡張子が.jsonのJSON形式のファイルへのパス

```

PUTメソッドを使ってHTTPリクエストを送信します

### <a name="patch"></a>patch

```text
magellan-cli http patch PATH
```

```text
Options:
  -d, [--body=BODY]        # 内容を表す文字列か、内容を保持するファイルへのパス
  -H, [--headers=HEADERS]  # JSON形式の文字列か、拡張子が.ymlのYAML形式のファイルへのパス、あるいは拡張子が.jsonのJSON形式のファイルへのパス

```

PATCHメソッドを使ってHTTPリクエストを送信します

### <a name="delete"></a>delete

```text
magellan-cli http delete PATH
```

```text
Options:
  -H, [--headers=HEADERS]  # JSON形式の文字列か、拡張子が.ymlのYAML形式のファイルへのパス、あるいは拡張子が.jsonのJSON形式のファイルへのパス

```

DELETEメソッドを使ってHTTPリクエストを送信します

### <a name="ping"></a>ping

```text
magellan-cli http ping
```

接続確認のリクエストを送信します

### <a name="help"></a>help

```text
magellan-cli http help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

