# GCP でコストが高い国をブロックするルールを作るスクリプト

## 事前準備

1. [Google Cloud SDK](https://cloud.google.com/sdk/downloads?hl=JA) をインストールし、`gcloud` コマンドを使用できるようにしてください。
2. 下記2コマンドを実施し、ログインを行ってください。
    * `gcloud auth login`
    * `gcloud config set project YOUR-PROJECT-ID`

## 使用方法

* `ruby create-firewall-rules.rb`

以上。
