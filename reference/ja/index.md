---
layout: index
title: magellan-cli-0.9 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.9</a> /  <a href="/reference/en/index.html">en</a> ja
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli login](#login)
- [magellan-cli organization SUBCOMMAND ...ARGS](./resources/organization.html)
- [magellan-cli team SUBCOMMAND ...ARGS](./resources/team.html)
- [magellan-cli project SUBCOMMAND ...ARGS](./resources/project.html)
- [magellan-cli authority SUBCOMMAND ...ARGS](./resources/authority.html)
- [magellan-cli stage SUBCOMMAND ...ARGS](./resources/stage.html)
- [magellan-cli client_version SUBCOMMAND ...ARGS](./resources/client_version.html)
- [magellan-cli worker SUBCOMMAND ...ARGS](./resources/worker.html)
- [magellan-cli image SUBCOMMAND ...ARGS](./resources/image.html)
- [magellan-cli container SUBCOMMAND ...ARGS](./resources/container.html)
- [magellan-cli cloudsql SUBCOMMAND ...ARGS](./resources/cloudsql.html)
- [magellan-cli cloudsql_instance SUBCOMMAND ...ARGS](./cloudsql_instance.html)
- [magellan-cli http SUBCOMMAND ...ARGS](./messaging/http.html)
- [magellan-cli mqtt SUBCOMMAND ...ARGS](./messaging/mqtt.html)
- [magellan-cli info](#info)
- [magellan-cli help [COMMAND]](#help)

## 共通オプション

```text
Options:
  -v, [--version], [--no-version]  # バージョンを表示します
  -V, [--verbose], [--no-verbose]  # 追加のログ情報を表示します
  -D, [--dryrun], [--no-dryrun]    # 登録や削除などのシステムには反映させずにアクションを実行します

```


## コマンドの詳細
### <a name="login"></a>login

```text
magellan-cli login
```

```text
Options:
  -e, [--email=EMAIL]                                # ログインするアカウントのメールアドレス
  -p, [--password=PASSWORD]                          # ログインするアカウントのパスワード
  -t, [--authentication-token=AUTHENTICATION_TOKEN]  # ログインするアカウントの認証トークン

```

MAGELLANのサーバにログインします

### <a name="info"></a>info

```text
magellan-cli info
```

ログイン情報と選択されているリソースを表示します

### <a name="help"></a>help

```text
magellan-cli help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

