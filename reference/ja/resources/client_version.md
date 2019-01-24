---
layout: index
title: client_version | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / client_version ja <a href="/reference/en/resources/client_version.html">en</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli client_version list](#list)
- [magellan-cli client_version show [ID]](#show)
- [magellan-cli client_version select VERSION](#select)
- [magellan-cli client_version deselect](#deselect)
- [magellan-cli client_version create VERSION](#create)
- [magellan-cli client_version update ATTRIBUTES](#update)
- [magellan-cli client_version delete VERSION](#delete)
- [magellan-cli client_version help [COMMAND]](#help)

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
magellan-cli client_version list
```

client_versions の一覧を表示します

### <a name="show"></a>show

```text
magellan-cli client_version show [ID]
```

IDで指定されたclient_versionの詳細を表示します

### <a name="select"></a>select

```text
magellan-cli client_version select VERSION
```

VERSIONを指定してclient_versionを選択します

### <a name="deselect"></a>deselect

```text
magellan-cli client_version deselect
```

client_versionの選択を解除します

### <a name="create"></a>create

```text
magellan-cli client_version create VERSION
```

```text
Options:
  -d, [--domain=DOMAIN]  # OAuth認証を行わずHTTPアクセスする際のアクセス先となるドメイン名

```

VERSIONを指定してclient_versionを登録します

### <a name="update"></a>update

```text
magellan-cli client_version update ATTRIBUTES
```

選択したclient_versionの属性を指定したATTRIBUTESで更新します。ATTRIBUTESにはYAMLのファイル名かJSON文字列を指定可能です

### <a name="delete"></a>delete

```text
magellan-cli client_version delete VERSION
```

VERSIONを指定してclient_versionを削除します

### <a name="help"></a>help

```text
magellan-cli client_version help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

