---
layout: index
title: mqtt | magellan-cli-0.9 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.9</a> / mqtt <a href="/reference/en/messaging/mqtt.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli mqtt pub TOPIC PAYLOAD](#pub)
- [magellan-cli mqtt get [TOPIC]](#get)
- [magellan-cli mqtt help [COMMAND]](#help)

## 共通オプション

```text
Options:
  -v, [--version], [--no-version]  # バージョンを表示します
  -V, [--verbose], [--no-verbose]  # 追加のログ情報を表示します
  -D, [--dryrun], [--no-dryrun]    # 登録や削除などのシステムには反映させずにアクションを実行します

```


## コマンドの詳細
### <a name="pub"></a>pub

```text
magellan-cli mqtt pub TOPIC PAYLOAD
```

TOPICを指定してメッセージを配信します

### <a name="get"></a>get

```text
magellan-cli mqtt get [TOPIC]
```

メッセージを取得します

### <a name="help"></a>help

```text
magellan-cli mqtt help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

