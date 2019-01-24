---
layout: index
title: cloudsql_instance | magellan-cli-0.11 (ja) | Reference
breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/ja">magellan-cli-0.11</a> / cloudsql_instance ja <a href="/reference/en/cloudsql_instance.html">en</a>
sidemenu: sidemenu/reference/magellan-cli/sidemenu-ja
---

## コマンドの一覧

- [magellan-cli cloudsql_instance create INSTANCE](#create)
- [magellan-cli cloudsql_instance delete INSTANCE](#delete)
- [magellan-cli cloudsql_instance list](#list)
- [magellan-cli cloudsql_instance help [COMMAND]](#help)

## 共通オプション

```text
Options:
  -v, [--version], [--no-version]  # バージョンを表示します
  -V, [--verbose], [--no-verbose]  # 追加のログ情報を表示します
  -D, [--dryrun], [--no-dryrun]    # 登録や削除などのシステムには反映させずにアクションを実行します

```


## コマンドの詳細
### <a name="create"></a>create

```text
magellan-cli cloudsql_instance create INSTANCE
```

```text
Options:
      [--tier=TIER]                                        # Cloud SQLのインスタンスの階層。詳しくは https://cloud.google.com/sql/pricing を参照してください。
                                                           # Default: D0
                                                           # Possible values: D0, D1, D2, D4, D8, D16, D32
      [--region=REGION]                                    # Cloud SQLのインスタンスを動かす地域
                                                           # Default: asia-east1
      [--activation-policy=ACTIVATION-POLICY]              # Cloud SQLのインスタンスを有効にするポリシー
                                                           # Default: ON_DEMAND
                                                           # Possible values: ALWAYS, NEVER, ON_DEMAND
      [--skip-assign-ip], [--no-skip-assign-ip]            # IPv4 アドレスを割り当てない
      [--authorized-networks=AUTHORIZED-NETWORKS]          # 承認済みネットワーク
                                                           # Default: 0.0.0.0/0
      [--gce-zone=GCE-ZONE]                                # 希望する場所
                                                           # Default: asia-east1-c
      [--pricing-plan=PRICING-PLAN]                        # 料金プラン
                                                           # Default: PER_USE
                                                           # Possible values: PACKAGE, PER_USE
  -p, [--password=PASSWORD]                                # Cloud SQLのrootユーザのパスワード
      [--account=ACCOUNT]                                  # GCPユーザアカウント
      [--log-http], [--no-log-http]                        # 全てのHTTPのリクエストとレスポンスを標準エラー出力に出力します
      [--project=PROJECT]                                  # GCPプロジェクト
      [--trace-token=TRACE-TOKEN]                          # トレーストークン
      [--user-output-enabled], [--no-user-output-enabled]  # コンソールにユーザを出力します
      [--verbosity=VERBOSITY]                              # ログレベル
                                                           # Default: info
                                                           # Possible values: debug, info, warning, error, critical, none
      [--async], [--no-async]                              # 指定しても無視されます
      [--format=FORMAT]                                    # 指定しても無視されます
                                                           # Default: json

```

INSTANCEを指定してCloudSQL instanceを登録します

### <a name="delete"></a>delete

```text
magellan-cli cloudsql_instance delete INSTANCE
```

INSTANCEを指定してCloudSQL instanceを削除します

### <a name="list"></a>list

```text
magellan-cli cloudsql_instance list
```

CloudSQL instanceの一覧を表示します

### <a name="help"></a>help

```text
magellan-cli cloudsql_instance help [COMMAND]
```

利用可能なコマンドの一覧か特定のコマンドの説明を表示します

