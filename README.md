# dev-config

開発環境の設定ファイル集

## セットアップ

Mac・Linux 共通。ホームディレクトリの設定ファイルからこのリポジトリの設定を読み込むようにし、ツールをインストールする。

1. git と、使いたいシェル（zsh または bash）を用意する（Mac は両方入っている。Linux で zsh を使うなら `sudo apt install zsh` など）
2. このリポジトリをクローンして `./install.sh` を実行する
   - `~/.zshrc` と `~/.bashrc` の末尾に、このリポジトリの設定を読み込む1行を追記（既存の内容はそのまま残る）
   - Mac では `~/.bash_profile` にも `~/.bashrc` を読み込む1行を追記（ログイン時の bash は `~/.bash_profile` しか読まないため）
   - mise がなければインストールし、`mise install` で下記のツールをまとめてインストール
3. ログインシェルを使いたいシェルに切り替える: `chsh -s "$(command -v zsh)"`（bash なら `zsh` を `bash` に）

何度実行しても同じ結果になる（追記済みの行や、インストール済みのツールはそのまま）。ツールを新しいバージョンに更新するには `mise upgrade` を使う。

> [!NOTE]
> 設定はこのリポジトリから直接読み込むので、リポジトリを移動・削除すると設定が読み込まれなくなる（エラーにはならない）。移動したら `~/.zshrc` などの読み込み行のパスを直す。

## シェル: zsh / bash

zsh と bash のどちらを使っても、同じツールが使えるようにしている。Mac・Linux の両方で同じ設定を使う。

> [!NOTE]
> シェルスクリプトは `#!/usr/bin/env bash` を付けて bash で実行する。

| ファイル | 内容 |
| --- | --- |
| [.config/shell/common.sh](.config/shell/common.sh) | 両方で共通の設定（PATH、Homebrew、mise と starship の設定ファイルの場所） |
| [.zshrc](.zshrc) | zsh の設定（`~/.zshrc` から読み込む） |
| [.bashrc](.bashrc) | bash の設定（`~/.bashrc` から読み込む） |

- リポジトリに入れたくないマシンごとの設定（仕事用の PATH など）は、`~/.zshrc`（bash は `~/.bashrc`）の読み込み行より下に書く。同じ設定はあとに書いた方が有効になる
- mise・starship の設定ファイルは、環境変数（`MISE_GLOBAL_CONFIG_FILE`、`STARSHIP_CONFIG`）でこのリポジトリのファイルを直接指定している
- 入っていないツールの設定は読み込まないので、ツールがない環境でもエラーにならない
- Mac の bash は古い 3.2 だが、この設定は 3.2 でも動く

## コマンドヒストリー管理ツール: [Atuin](https://docs.atuin.sh/cli/)

- ↑ キー（または Ctrl+r）を押すと専用の検索画面が立ち上がり、コマンドの一部、ディレクトリ名、実行時期などで絞り込みが可能

## プロンプト（シェルの表示部分）カスタマイズツール: [starship](https://starship.rs/)

- 設定は [.config/starship.toml](.config/starship.toml) に記載
- 今いるディレクトリ、Git のブランチと状態、使っている言語のバージョン（`nodejs v26.12.1` など）を自動で表示
- 先頭に現在時刻（`@15:42`）、ディレクトリは省略せずフルパスで表示
- 直前のコマンドが成功なら緑の `>`、失敗なら赤の `x`
- アイコンの代わりに文字（`git`、`py` など）で表示するので、特別なフォント（Nerd Font）は不要

## ランタイムバージョン管理ツール: [mise](https://mise.jdx.dev/)

- 設定は [.config/mise/config.toml](.config/mise/config.toml) に記載
- ディレクトリに入ると、そのディレクトリの設定（`mise.toml` など）に合わせて自動でバージョンを切り替え
- 管理しているツール
  - 言語・パッケージ管理
    - Node.js（LTS の最新版）
    - pnpm
    - uv（Python 本体は mise ではなく uv で管理）
  - シェル
    - Atuin
    - starship

## Python プロジェクトのひな形: [python/](python/)

- Python のバージョンは [python/.python-version](python/.python-version)（3.14）、バージョン管理・パッケージ管理は [uv](https://docs.astral.sh/uv/)
  - Python 本体は uv だけで管理し、mise では入れない（`uv python list` で確認、`uv python install` で追加）
- 開発用パッケージ
  - リンター・フォーマッター: Ruff（1行の長さは 100 文字）
  - 型チェック: Mypy
  - 脆弱性チェック: pip-audit（依存パッケージ）、bandit（コード）
  - テスト: pytest
- 使い方: フォルダをコピーして `uv sync`、その後 `uv run ruff check .` / `uv run ruff format .` / `uv run mypy .` / `uv run pip-audit` / `uv run bandit -r . -x ./.venv` / `uv run pytest`

## Node.js プロジェクトのひな形: [node/](node/)

- Node.js のバージョンは [node/mise.toml](node/mise.toml)（LTS の最新版）、パッケージ管理は pnpm
- 開発用パッケージ
  - リンター: ESLint（typescript-eslint）
  - フォーマッター: Prettier
  - 型チェック: TypeScript（typescript-eslint が対応する 6.0 系）
  - 脆弱性チェック: `pnpm audit`
  - テスト: Vitest
- コードは [node/src/](node/src/) に置く（`node src/index.ts` で TypeScript をそのまま実行できる）
- 使い方: フォルダをコピーして `pnpm install`、その後 `pnpm lint` / `pnpm format` / `pnpm typecheck` / `pnpm audit` / `pnpm test`

## エディタ: [VS Code](https://code.visualstudio.com/)

設定は [.vscode/settings.json](.vscode/settings.json)、推奨拡張機能は [.vscode/extensions.json](.vscode/extensions.json) に記載。

### 推奨拡張機能

| 拡張機能                                                                                                        | 用途                                                        |
| --------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)                        | VS Code 上で Claude Code を使用                             |
| [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)                                  | Python のフォーマット・import 整理・自動修正                |
| [markdownlint](https://marketplace.visualstudio.com/items?itemName=davidanson.vscode-markdownlint)              | Markdown のリント                                           |
| [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)                            | JavaScript / TypeScript のリント                            |
| [GitHub Actions](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions)              | ワークフローの編集支援・実行状況の確認                      |
| [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=github.vscode-pull-request-github)   | VS Code 上でプルリクエスト・Issue のレビューや管理          |
| [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)                  | Terraform の構文ハイライト・補完・フォーマット              |
| [Draw.io Integration](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)                 | VS Code 上で draw.io の図を編集                             |
| [Output Colorizer](https://marketplace.visualstudio.com/items?itemName=ibm.output-colorizer)                    | 出力パネルやログファイルに色付け                            |
| [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)                             | Git のコミット履歴をグラフ表示                              |
| [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)                       | Dockerfile・docker compose の編集、コンテナ・イメージの管理 |
| [Japanese Language Pack](https://marketplace.visualstudio.com/items?itemName=ms-ceintl.vscode-language-pack-ja) | VS Code の UI を日本語化                                    |
| [Mypy Type Checker](https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker)            | Python の型チェック                                         |
| [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)                                  | Python 言語サポート                                         |
| [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)        | コンテナ内を開発環境として VS Code で開く                   |
| [Live Preview](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server)                       | HTML を VS Code 内でプレビュー（ローカルサーバー起動）      |
| [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)                                  | YAML の構文チェック・補完（スキーマ対応）                   |

### 本体の設定

- エディタ
  - 保存時に自動フォーマット、行末の空白を自動削除
  - 括弧のペアをガイド線で表示
  - 空白文字をすべて可視化
  - 現在行を行番号部分も含めてハイライト
  - 折りたたみボタンを常に表示
  - ミニマップのスライダーを常に表示
  - Ctrl（Mac は Cmd）+ マウスホイールで文字サイズを変更
- 見た目
  - テーマ: Light 2026
  - レイアウト・アクティビティバーをコンパクト表示
  - タブが多いときは折り返して表示
- Git
  - 自動で fetch
  - ソース管理の変更ファイルをツリー表示
  - ソース管理グラフにすべてのバッジを表示
- JSON / JSONC は VS Code 標準のフォーマッターを使用

### 拡張機能に依存する設定

- Ruff: Python ファイルの保存時にフォーマット、自動修正（fixAll）、import の整理を実行
- Mypy Type Checker: プロジェクトの環境（uv の仮想環境など）にインストールされた mypy を使用
- Pylance: 型チェックは Mypy に任せるため無効化
- Claude Code: Enter で送信せず改行し、Ctrl（Mac は Cmd）+ Enter で送信
- Draw.io Integration: `*.svg` を draw.io エディタで開く
